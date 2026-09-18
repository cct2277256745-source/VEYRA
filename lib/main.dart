import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'app/app.dart';
import 'app/app_scope.dart';
import 'features/projects/project_focus_page.dart';
import 'features/projects/project_plan_page.dart';
import 'features/replanning/rebalance_preview_page.dart';
import 'features/review/review_pages.dart';
import 'features/settings/settings_page.dart';
import 'core/design/tokens.dart';
import 'features/week/week_page.dart';
import 'features/inbox/inbox_page.dart';
import 'data/app_services.dart';
import 'ai/ai_provider_factory.dart';
import 'ai/mock_ai_provider.dart';
import 'ai/replanner_service.dart';
import 'ai/secure_key_store.dart';
import 'data/demo/demo_data.dart';

const veyraDemoFocus = bool.fromEnvironment('VEYRA_DEMO_FOCUS');

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final services = AppServices.open();
  await DemoDataService(services).seedIfEmpty();
  final aiFactory = AIProviderFactory(
    settings: services.aiSettings,
    keyStore: SecureStorageKeyStore(),
  );
  // 视觉验收运行：VEYRA_DEMO_FOCUS 或 VEYRA_OPEN_PAGE 指定截图目标页。
  // 截图模式下 AI 一律使用 Mock（离线、确定性）。
  final openPage = Platform.environment['VEYRA_OPEN_PAGE'];
  final captureMode = veyraDemoFocus || openPage != null;
  Widget? demoHome;
  final captureKey = GlobalKey();

  Future<int> richestProjectId() async {
    final projects = await services.projects.listProjects();
    var best = projects.first;
    var bestCount = 0;
    for (final p in projects) {
      final n = (await services.projects.phasesOfProject(p.id)).length;
      if (n > bestCount) {
        best = p;
        bestCount = n;
      }
    }
    return best.id;
  }

  if (captureMode) {
    final page = veyraDemoFocus ? 'focus' : (openPage ?? 'projects');
    switch (page) {
      case 'focus':
        demoHome = ProjectFocusPage(projectId: await richestProjectId());
      case 'plan':
        demoHome = ProjectPlanPage(projectId: await richestProjectId());
      case 'week':
        demoHome = const WeekPage();
      case 'inbox':
        demoHome = const InboxPage();
      case 'settings':
        demoHome = const SettingsPage();
      case 'review-week':
        demoHome = const WeekReviewPage();
      case 'review-project':
        demoHome = ProjectReviewPage(projectId: await richestProjectId());
      case 'rebalance':
        final replanner = ReplannerService(
          provider: MockAIProvider(),
          services: services,
        );
        final proposal = await replanner.proposeChanges(situation: '截图演示');
        demoHome = RebalancePreviewPage(proposalId: proposal.id);
      case 'newproject':
        final captureKeyRef = captureKey;
        WidgetsBinding.instance.addPostFrameCallback((_) async {
          await Future<void>.delayed(const Duration(seconds: 3));
          final ctx = captureKeyRef.currentContext;
          if (ctx == null || !ctx.mounted) return;
          await showDialog<void>(
            context: ctx,
            builder: (_) => const AlertDialog(
              title: Text('创建项目'),
              content: SizedBox(
                width: 420,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('你想完成什么？',
                        style: TextStyle(
                            fontSize: 15, color: VeyraColors.textSecondary)),
                    SizedBox(height: 12),
                    TextField(
                        decoration:
                            InputDecoration(labelText: '项目名称')),
                  ],
                ),
              ),
              actions: [
                TextButton(onPressed: null, child: Text('取消')),
                FilledButton(onPressed: null, child: Text('继续')),
              ],
            ),
          );
        });
    }
  }

  // 自截图钩子（开发工具，非产品功能）：设置 VEYRA_CAPTURE_PATH 后，
  // App 用真实系统字体渲染首帧，写出 PNG 后自动退出。
  // 用法：VEYRA_WINDOW=1440x900 VEYRA_CAPTURE_PATH=out.png <运行 App>
  final capturePath = Platform.environment['VEYRA_CAPTURE_PATH'];
  if (capturePath != null) {
    // 延迟到首帧渲染完成后再取 RenderObject，避免 lint 报的跨 async 引用。
    Future(() async {
      await Future<void>.delayed(const Duration(seconds: 2));
      final ctx = captureKey.currentContext;
      if (ctx == null) {
        stderr.writeln('CAPTURE FAILED: boundary not found');
        exit(3);
      }
      // 开发自截图工具：GlobalKey 查找晚于 await 是有意为之（等首帧渲染）。
      // ignore: use_build_context_synchronously
      final renderObject = ctx.findRenderObject();
      if (renderObject is! RenderRepaintBoundary) {
        stderr.writeln('CAPTURE FAILED: not a RepaintBoundary');
        exit(3);
      }
      final image = await renderObject.toImage(pixelRatio: 2.0);
      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      File(capturePath)
          .writeAsBytesSync(byteData!.buffer.asUint8List(), flush: true);
      stdout.writeln('CAPTURED $capturePath '
          '(${image.width}x${image.height})');
      exit(0);
    });
  }

  runApp(AIScope(
    factory: aiFactory,
    child: AppScope(
      services: services,
      child: RepaintBoundary(
        key: captureKey,
        child: VeyraApp(home: demoHome),
      ),
    ),
  ));
}
