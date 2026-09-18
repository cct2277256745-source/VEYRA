import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:veyra/ai/ai_provider_factory.dart';
import 'package:veyra/ai/mock_ai_provider.dart';
import 'package:veyra/ai/plan_application_service.dart';
import 'package:veyra/ai/plan_models.dart';
import 'package:veyra/ai/secure_key_store.dart';
import 'package:veyra/app/app_scope.dart';
import 'package:veyra/data/app_services.dart';
import 'package:veyra/features/projects/new_project_flow.dart';

void main() {
  late AppServices services;
  late AIProviderFactory aiFactory;
  late MockAIProvider mockProvider;
  late PlanApplicationService planService;

  setUp(() {
    services = AppServices.inMemory();
    mockProvider = MockAIProvider();
    aiFactory = AIProviderFactory(
      settings: services.aiSettings,
      keyStore: InMemoryKeyStore(),
      debugProvider: mockProvider,
    );
    planService = PlanApplicationService(
      provider: mockProvider,
      services: services,
    );
  });

  tearDown(() => services.close());

  group('Document Import AI Planning Pipeline', () {
    test('generateBlueprintFromFile 从文档提炼阶段蓝图', () async {
      final file = ExtractedPlanFile(
        fileName: '2026战略规划.docx',
        text: '阶段一：市场调研与客户验证\n阶段二：MVP快速迭代与冷启动\n阶段三：渠道放量与营收增长',
      );

      final blueprint = await planService.generateBlueprintFromFile(file: file);

      expect(blueprint.title, '2026战略规划');
      expect(blueprint.phases.length, 3);
      expect(blueprint.phases[0].title, contains('第一阶段'));
      expect(blueprint.phases[1].title, contains('第二阶段'));
      expect(blueprint.phases[2].title, contains('第三阶段'));
      // 蓝图阶段不展开具体子任务
      for (final phase in blueprint.phases) {
        expect(phase.tasks, isEmpty);
      }
    });

    test('generateFromFile 严格受控于用户确认的阶段架构 confirmedPhases', () async {
      final file = ExtractedPlanFile(
        fileName: '2026战略规划.docx',
        text: '阶段一：市场调研\n阶段二：MVP迭代',
      );

      // 用户在中间门禁编辑确认了 2 个自定义阶段
      final confirmed = <PlanPhaseDraft>[
        const PlanPhaseDraft(
          title: '自定义阶段 A：核心协议重构',
          goal: '确保离线数据一致性',
          milestones: ['协议通过验证'],
          tasks: [],
        ),
        const PlanPhaseDraft(
          title: '自定义阶段 B：macOS 原生发布',
          goal: '完成打包与签名',
          milestones: ['通过 notarization'],
          tasks: [],
        ),
      ];

      final proposal = await planService.generateFromFile(
        file: file,
        confirmedPhases: confirmed,
      );

      final draft = PlanDraft.fromJson(
        jsonDecode(proposal.payloadJson) as Map<String, dynamic>,
      );

      // 生成的任务必须严格挂载在用户确认的阶段下
      expect(draft.phases.length, 2);
      expect(draft.phases[0].title, '自定义阶段 A：核心协议重构');
      expect(draft.phases[0].goal, '确保离线数据一致性');
      expect(draft.phases[0].tasks, isNotEmpty);

      expect(draft.phases[1].title, '自定义阶段 B：macOS 原生发布');
      expect(draft.phases[1].goal, '完成打包与签名');
      expect(draft.phases[1].tasks, isNotEmpty);

      // 落库并验证
      final project = await planService.confirmProposal(proposal.id);
      final persistedPhases = await services.projects.phasesOfProject(project.id);
      expect(persistedPhases.length, 2);
      expect(persistedPhases[0].title, '自定义阶段 A：核心协议重构');
      expect(persistedPhases[1].title, '自定义阶段 B：macOS 原生发布');
    });
  });

  group('NewProjectFlowDialog Document Blueprint UI Flow', () {
    Future<void> pumpDialog(WidgetTester tester) async {
      await tester.pumpWidget(
        AIScope(
          factory: aiFactory,
          child: AppScope(
            services: services,
            child: const MaterialApp(
              home: Scaffold(
                body: Center(
                  child: NewProjectFlowDialog(),
                ),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
    }

    testWidgets('统一文档规划流在阶段门禁中支持增删改并严格驱动全案生成', (tester) async {
      tester.view.physicalSize = const Size(1280, 900);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      await pumpDialog(tester);

      // 输入项目名并继续
      await tester.enterText(find.byType(TextField), '战略落地计划');
      await tester.tap(find.text('继续'));
      await tester.pumpAndSettle();

      expect(find.text('你想怎么开始？'), findsOneWidget);
      expect(find.text('上传已有规划'), findsOneWidget);

      // 点击「让 VEYRA 帮我规划」同样经由统一的 Blueprint 门禁
      await tester.tap(find.text('让 VEYRA 帮我规划'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('下一步：生成阶段蓝图'));
      await tester.pumpAndSettle();

      // 验证进入阶段架构门禁
      expect(find.text('阶段架构与里程碑确认'), findsOneWidget);
      expect(find.text('确认阶段，细化任务'), findsOneWidget);

      // 用户增删改阶段
      await tester.ensureVisible(find.text('添加阶段'));
      await tester.tap(find.text('添加阶段'));
      await tester.pumpAndSettle();
      expect(find.textContaining('阶段 4'), findsWidgets);

      // 确认阶段并细化任务
      await tester.ensureVisible(find.text('确认阶段，细化任务'));
      await tester.tap(find.text('确认阶段，细化任务'));
      await tester.pumpAndSettle();

      // 进入全案预览页
      expect(find.text('确认规划草案'), findsOneWidget);
      expect(find.text('确认，创建项目'), findsOneWidget);

      await tester.tap(find.text('确认，创建项目'));
      await tester.pumpAndSettle();

      final projects = await services.projects.listProjects();
      expect(projects.any((p) => p.title == '战略落地计划'), isTrue);
    });
  });
}
