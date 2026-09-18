import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:veyra/ai/ai_provider.dart';
import 'package:veyra/ai/mock_ai_provider.dart';
import 'package:veyra/ai/openai_compatible_provider.dart';
import 'package:veyra/ai/plan_models.dart';
import 'package:veyra/ai/secure_key_store.dart';
import 'package:veyra/data/app_services.dart';

void main() {
  group('PlanDraft 校验', () {
    test('合法 JSON 解析成功', () {
      final draft = PlanDraft.fromJson({
        'project': {
          'title': 'AI 产品经理求职',
          'outcome': '拿到 offer',
          'executionMode': 'weekly_planning',
          'phases': [
            {
              'title': '准备期',
              'tasks': [
                {
                  'title': '改简历',
                  'priority': 'must',
                  'estimatedEffort': 'medium',
                  'dependencies': [],
                }
              ],
            }
          ],
        }
      });
      expect(draft.title, 'AI 产品经理求职');
      expect(draft.suggestedMode, SuggestedExecutionMode.weeklyPlanning);
      expect(draft.phases.single.tasks.single.priority, PlanTaskPriority.must);
    });

    test('缺 project 抛 AIFormatException', () {
      expect(() => PlanDraft.fromJson({}), throwsA(isA<AIFormatException>()));
    });

    test('缺 phases 抛 AIFormatException', () {
      expect(
        () => PlanDraft.fromJson({
          'project': {'title': 'x'}
        }),
        throwsA(isA<AIFormatException>()),
      );
    });

    test('title 为空抛 AIFormatException', () {
      expect(
        () => PlanDraft.fromJson({
          'project': {
            'title': '  ',
            'phases': [
              {'title': 'p'}
            ],
          }
        }),
        throwsA(isA<AIFormatException>()),
      );
    });

    test('toJSON / fromJSON 往返一致', () {
      final draft = PlanDraft(
        title: 'T',
        outcome: 'O',
        suggestedMode: SuggestedExecutionMode.projectOnly,
        phases: const [
          PlanPhaseDraft(title: 'P1', tasks: [
            PlanTaskDraft(title: 'T1', priority: PlanTaskPriority.must),
          ]),
        ],
      );
      final round = PlanDraft.fromJson(draft.toJson());
      expect(round.title, 'T');
      expect(round.phases.single.tasks.single.title, 'T1');
    });

    test('PlanPhaseDraft 与 PlanTaskDraft 容错兼容字符串与别名字段', () {
      final p1 = PlanPhaseDraft.fromJson('准备阶段');
      expect(p1.title, '准备阶段');
      expect(p1.tasks, isEmpty);

      final p2 = PlanPhaseDraft.fromJson({
        'phaseName': '执行阶段',
        'milestones': ['M1', {'title': 'M2'}],
        'tasks': ['T1', {'name': 'T2', 'priority': 'must'}],
      });
      expect(p2.title, '执行阶段');
      expect(p2.milestones, ['M1', 'M2']);
      expect(p2.tasks.length, 2);
      expect(p2.tasks[0].title, 'T1');
      expect(p2.tasks[1].title, 'T2');
      expect(p2.tasks[1].priority, PlanTaskPriority.must);
    });
  });

  group('MockAIProvider', () {
    test('五个能力都返回结构化结果', () async {
      final mock = MockAIProvider();
      final plan = await mock.buildPlan(
          AIBuildPlanRequest(goal: '8 周雅思冲刺'));
      expect(plan.phases, isNotEmpty);
      expect(
          plan.suggestedMode, SuggestedExecutionMode.weeklyPlanning);

      final parsed = await mock
          .parsePlan(AIParsePlanRequest(documentText: '...', fileName: 'plan.md'));
      expect(parsed.phases, isNotEmpty);

      final tasks = await mock
          .decomposeTask(AIDecomposeRequest(taskTitle: '完成作品集'));
      expect(tasks, isNotEmpty);

      final rebalance = await mock.proposeRebalance(AIRebalanceRequest(
        situation: '周五突然有一个面试',
        currentWeekDescription: '三件事',
        deadlineDescription: '两周后',
        taskSummary: '写作/作品集',
      ));
      expect(rebalance.changes, isNotEmpty);

      final review = await mock.generateReview(AIReviewRequest(
        scopeDescription: '本周',
        completedItems: ['一份优化简历'],
        milestonesCompleted: [],
        deferredItems: ['作品集视觉'],
      ));
      expect(review.oneLineSummary, isNotEmpty);
      expect(review.highlights, contains('一份优化简历'));
    });

    test('failWith 抛出指定异常', () async {
      final mock = MockAIProvider(failWith: AINetworkException());
      await expectLater(
        mock.buildPlan(AIBuildPlanRequest(goal: 'x')),
        throwsA(isA<AINetworkException>()),
      );
    });
  });

  group('OpenAICompatibleProvider 错误映射', () {
    OpenAICompatibleProvider providerFor(int statusCode, String body) {
      return OpenAICompatibleProvider(
        config: const AIConfig(
            baseUrl: 'https://example.invalid/v1',
            model: 'test-model',
            apiKey: 'test-key'),
        client: MockClient((request) async =>
            http.Response(body, statusCode, headers: {
              'content-type': 'application/json',
            })),
      );
    }

    String okBody(String content) => jsonEncode({
          'choices': [
            {
              'message': {'content': content}
            }
          ]
        });

    test('401 → AIAuthException', () async {
      await expectLater(
        providerFor(401, '{"error":"bad key"}').buildPlan(
            AIBuildPlanRequest(goal: 'x')),
        throwsA(isA<AIAuthException>()),
      );
    });

    test('429 → AIRateLimitException', () async {
      await expectLater(
        providerFor(429, '{}').buildPlan(AIBuildPlanRequest(goal: 'x')),
        throwsA(isA<AIRateLimitException>()),
      );
    });

    test('429 包含余额不足 → AIException 并包含精确说明', () async {
      await expectLater(
        providerFor(429, '{"error":{"code":"1113","message":"余额不足或无可用资源包,请充值。"}}')
            .buildPlan(AIBuildPlanRequest(goal: 'x')),
        throwsA(predicate((e) =>
            e is AIException && e.toString().contains('AI 额度不足'))),
      );
    });

    test('500 → AIException', () async {
      await expectLater(
        providerFor(500, 'oops').buildPlan(AIBuildPlanRequest(goal: 'x')),
        throwsA(isA<AIException>()),
      );
    });

    test('内容不是 JSON 对象 → AIFormatException', () async {
      await expectLater(
        providerFor(200, okBody('"just a string"')).buildPlan(
            AIBuildPlanRequest(goal: 'x')),
        throwsA(isA<AIFormatException>()),
      );
    });

    test('AI 输出缺字段 → AIFormatException（格式错误不进入数据层）', () async {
      await expectLater(
        providerFor(200, okBody('{"nope":true}')).buildPlan(
            AIBuildPlanRequest(goal: 'x')),
        throwsA(isA<AIFormatException>()),
      );
    });

    test('网络异常 → AINetworkException', () async {
      final provider = OpenAICompatibleProvider(
        config: const AIConfig(
            baseUrl: 'https://example.invalid/v1',
            model: 'm',
            apiKey: 'k'),
        client: MockClient((request) async =>
            throw const SocketException('offline')),
      );
      await expectLater(
        provider.buildPlan(AIBuildPlanRequest(goal: 'x')),
        throwsA(isA<AINetworkException>()),
      );
    });

    test('正常响应解析为 PlanDraft（不会自己写库）', () async {
      final planJson = jsonEncode({
        'project': {
          'title': 'Mock 计划',
          'outcome': 'O',
          'executionMode': 'project_only',
          'phases': [
            {
              'title': 'P',
              'tasks': [
                {'title': 'T1'}
              ],
            }
          ],
        }
      });
      final provider = providerFor(200, okBody(planJson));
      final plan = await provider.buildPlan(AIBuildPlanRequest(goal: 'x'));
      expect(plan.title, 'Mock 计划');
    });

    test('请求带 Authorization 与 json response_format', () async {
      http.Request? captured;
      final provider = OpenAICompatibleProvider(
        config: const AIConfig(
            baseUrl: 'https://example.invalid/v1',
            model: 'test-model',
            apiKey: 'secret-key'),
        client: MockClient((request) async {
          captured = request;
          return http.Response(
              okBody(jsonEncode({
                'project': {
                  'title': 'T',
                  'phases': [
                    {
                      'title': 'P',
                      'tasks': [
                        {'title': 'A'}
                      ],
                    }
                  ],
                }
              })),
              200);
        }),
      );
      await provider.buildPlan(AIBuildPlanRequest(goal: 'x'));
      expect(captured!.headers['Authorization'], 'Bearer secret-key');
      expect(captured!.url.path, endsWith('/chat/completions'));
      expect(captured!.body, contains('"response_format"'));
    });
  });

  group('SecureKeyStore', () {
    test('InMemoryKeyStore 读写删', () async {
      final store = InMemoryKeyStore();
      await store.write('ai.apikey', 'abc');
      expect(await store.read('ai.apikey'), 'abc');
      await store.delete('ai.apikey');
      expect(await store.read('ai.apikey'), isNull);
    });
  });

  test('Settings 仓储存取 AI 配置（Key 不入 Settings）', () async {
    final services = AppServices.inMemory();
    addTearDown(services.close);
    await services.aiSettings.set('ai.baseUrl', 'https://api.example.com/v1');
    await services.aiSettings.set('ai.model', 'gpt-test');
    expect(await services.aiSettings.get('ai.baseUrl'),
        'https://api.example.com/v1');
    expect(await services.aiSettings.get('ai.model'), 'gpt-test');
    await services.aiSettings.remove('ai.model');
    expect(await services.aiSettings.get('ai.model'), isNull);
  });
}
