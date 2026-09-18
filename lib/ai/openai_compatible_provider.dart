/// OpenAI-compatible Provider（PRD §16.4 V1 范围）。
///
/// 用户自配 Base URL / Model / API Key；强制 JSON 输出；错误映射为
/// 可恢复的 AIException 子类。绝不写死任何 Key（AGENTS §6）。
library;

import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import 'ai_provider.dart';
import 'plan_models.dart';

class AIConfig {
  const AIConfig({
    required this.baseUrl,
    required this.model,
    required this.apiKey,
    this.timeout = const Duration(seconds: 120),
  });

  final String baseUrl;
  final String model;
  final String apiKey;
  final Duration timeout;

  Uri get chatCompletionsUri {
    final base = baseUrl.endsWith('/')
        ? baseUrl.substring(0, baseUrl.length - 1)
        : baseUrl;
    return Uri.parse('$base/chat/completions');
  }
}

class OpenAICompatibleProvider implements AIProvider {
  OpenAICompatibleProvider({
    required this.config,
    http.Client? client,
  }) : _client = client ?? http.Client();

  final AIConfig config;
  final http.Client _client;

  @override
  String get id => 'openai_compatible:${config.model}';

  @override
  Future<PlanDraft> buildBlueprint(AIBuildPlanRequest request) async {
    final prompt = '''
用户目标：${request.goal}
${request.outcome == null ? '' : '预期成果与交付：${request.outcome}'}
${request.background == null ? '' : '当前基础：${request.background}'}
${request.deadline == null ? '' : '截止日期：${request.deadline!.toIso8601String().substring(0, 10)}'}
${request.constraints == null ? '' : '约束与可用精力：${request.constraints}'}
请提炼出 2 到 4 个核心阶段与关键里程碑（作为规划蓝图框架，暂不展开具体 tasks），按 JSON 输出规范返回。''';
    final json = await _chatJson(_blueprintSystemPrompt, prompt);
    return PlanDraft.fromJson(json);
  }

  @override
  Future<PlanDraft> buildPlan(AIBuildPlanRequest request) async {
    final confirmedInfo = (request.confirmedPhases != null &&
            request.confirmedPhases!.isNotEmpty)
        ? '\n用户已确认阶段架构如下，请严格在以下阶段下细化具体的执行任务（每个阶段拆解 2-5 项具体可执行的 tasks）：\n${request.confirmedPhases!.map((p) {
            final g = p.goal != null ? '（目标：${p.goal}）' : '';
            final m = p.milestones.isNotEmpty ? '（里程碑：${p.milestones.join('、')}）' : '';
            return '- 阶段「${p.title}」$g$m';
          }).join('\n')}'
        : '';
    final prompt = '''
用户目标：${request.goal}
${request.outcome == null ? '' : '预期成果与交付：${request.outcome}'}
${request.background == null ? '' : '当前基础：${request.background}'}
${request.deadline == null ? '' : '截止日期：${request.deadline!.toIso8601String().substring(0, 10)}'}
${request.constraints == null ? '' : '约束与可用精力：${request.constraints}'}$confirmedInfo
请按 JSON 输出规范生成个人项目规划。''';
    final json = await _chatJson(_planSystemPrompt, prompt);
    return PlanDraft.fromJson(json);
  }

  @override
  Future<PlanDraft> parseBlueprint(AIParsePlanRequest request) async {
    final docText = request.documentText.length > 12000
        ? '${request.documentText.substring(0, 12000)}\n[注：文档篇幅较长，已截取前 12000 字符进行核心规划解析]'
        : request.documentText;
    final prompt = '''这是用户上传的规划书/大纲文件（文件名：${request.fileName}）。
请深入阅读理解文档主旨，提炼出 2 到 4 个核心战略攻坚阶段（phases）与关键里程碑（milestones）。
注意：本次仅提取阶段大纲与里程碑（tasks 返回空数组 []），供用户中间确认。
---
$docText''';
    final json = await _chatJson(_blueprintSystemPrompt, prompt);
    return PlanDraft.fromJson(json);
  }

  @override
  Future<PlanDraft> parsePlan(AIParsePlanRequest request) async {
    final docText = request.documentText.length > 12000
        ? '${request.documentText.substring(0, 12000)}\n[注：文档篇幅较长，已截取前 12000 字符进行核心规划解析]'
        : request.documentText;
    final confirmedInfo = (request.confirmedPhases != null &&
            request.confirmedPhases!.isNotEmpty)
        ? '\n用户已在中间门禁中确认了以下阶段架构与里程碑，请严格遵循这 ${request.confirmedPhases!.length} 个阶段，从文档中为每个阶段提取并细化 2 到 5 个具体行动任务（tasks）：\n${request.confirmedPhases!.map((p) {
            final g = p.goal != null ? '（目标：${p.goal}）' : '';
            final m = p.milestones.isNotEmpty ? '（里程碑：${p.milestones.join('、')}）' : '';
            return '- 阶段「${p.title}」$g$m';
          }).join('\n')}\n'
        : '';
    final prompt = '''这是用户上传的规划书（文件：${request.fileName}）。
请把它转换成可执行的项目规划 JSON。
$confirmedInfo
要求：
1. 梳理出各个阶段（phases），每个阶段包含 2 到 5 个具体行动任务（tasks）以及关键里程碑（milestones）。
2. 保持均衡：提取各个阶段的核心任务，不要让后续阶段的任务为空；总任务量建议在 10 到 20 项之间，聚焦高价值行动，避免琐碎罗列。
3. 保留每个任务的可追溯来源（sourceQuote 引用原文简短语句）。
---
$docText''';
    final json = await _chatJson(_planSystemPrompt, prompt);
    return PlanDraft.fromJson(json);
  }

  @override
  Future<List<PlanTaskDraft>> decomposeTask(AIDecomposeRequest request) async {
    final prompt = '把任务「${request.taskTitle}」拆成 3 到 8 个可直接执行的小任务。'
        '${request.projectOutcome == null ? '' : '项目最终目标：${request.projectOutcome}'}'
        '输出 JSON：{"tasks": [...]}';
    final json = await _chatJson(_decomposeSystemPrompt, prompt);
    final raw = json['tasks'];
    if (raw is! List || raw.isEmpty) {
      throw AIFormatException('tasks 缺失或为空');
    }
    return raw.map(PlanTaskDraft.fromJson).toList();
  }

  @override
  Future<RebalanceProposal> proposeRebalance(AIRebalanceRequest request) async {
    final prompt = '''
现实变化：${request.situation}
本周现状：${request.currentWeekDescription}
截止时间：${request.deadlineDescription}
当前任务与优先级：${request.taskSummary}
只提出必要的调整，不要重排一切。''';
    final json = await _chatJson(_rebalanceSystemPrompt, prompt);
    return RebalanceProposal.fromJson(json);
  }

  @override
  Future<AIReviewSummary> generateReview(AIReviewRequest request) async {
    final prompt = '''
范围：${request.scopeDescription}
完成的事项：${request.completedItems.join('；')}
完成的里程碑：${request.milestonesCompleted.join('；')}
被推迟的事项：${request.deferredItems.isEmpty ? '无' : request.deferredItems.join('；')}
highlights 要强调真实产出的成果（deliverable），任务数量只是次要信息。''';
    final json = await _chatJson(_reviewSystemPrompt, prompt);
    return AIReviewSummary.fromJson(json);
  }

  /// 测试连接：用最小请求验证 URL / Model / Key 是否可用。
  /// 成功正常返回；失败抛对应 AIException 子类（可直接展示）。
  Future<void> testConnection() async {
    await _chatJson('只输出 JSON 对象 {"ok": true}。', '测试连接');
  }

  // ---------- HTTP ----------

  Future<Map<String, dynamic>> _chatJson(
      String systemPrompt, String userPrompt, {bool allowRetry = true}) async {
    final body = jsonEncode({
      'model': config.model,
      'messages': [
        {'role': 'system', 'content': systemPrompt},
        {'role': 'user', 'content': userPrompt},
      ],
      'response_format': {'type': 'json_object'},
      'temperature': 0.3,
    });
    final http.Response response;
    try {
      response = await _client
          .post(config.chatCompletionsUri,
              headers: {
                'Content-Type': 'application/json',
                'Authorization': 'Bearer ${config.apiKey}',
              },
              body: body)
          .timeout(config.timeout);
    } on TimeoutException {
      throw AINetworkException();
    } catch (_) {
      throw AINetworkException();
    }
    if (response.statusCode != 200 && response.statusCode != 201) {
      String? serverMessage;
      try {
        final errJson = jsonDecode(utf8.decode(response.bodyBytes));
        if (errJson is Map) {
          final errorObj = errJson['error'];
          if (errorObj is Map && errorObj['message'] != null) {
            serverMessage = errorObj['message'].toString();
          } else if (errJson['message'] != null) {
            serverMessage = errJson['message'].toString();
          }
        }
      } catch (_) {}

      if (response.statusCode == 429) {
        final isQuota = serverMessage != null &&
            (serverMessage.contains('余额不足') ||
             serverMessage.contains('无可用资源包') ||
             serverMessage.contains('quota') ||
             serverMessage.contains('balance') ||
             serverMessage.contains('欠费') ||
             serverMessage.contains('充值'));
        if (isQuota) {
          throw AIException('AI 额度不足：$serverMessage（请在设置中换用免费模型 glm-4-flash 或充值）。');
        }
        if (allowRetry) {
          final retryAfterHeader = int.tryParse(response.headers['retry-after'] ?? '');
          final waitSeconds = (retryAfterHeader != null && retryAfterHeader > 0 && retryAfterHeader <= 5)
              ? retryAfterHeader
              : 2;
          await Future<void>.delayed(Duration(seconds: waitSeconds));
          return _chatJson(systemPrompt, userPrompt, allowRetry: false);
        }
        final retryAfter = int.tryParse(response.headers['retry-after'] ?? '');
        throw AIRateLimitException(retryAfterSeconds: retryAfter);
      } else if (response.statusCode == 401 || response.statusCode == 403) {
        throw AIAuthException(serverMessage != null && serverMessage.isNotEmpty
            ? 'API Key 无效或未授权：$serverMessage'
            : null);
      } else {
        throw AIException(serverMessage != null && serverMessage.isNotEmpty
            ? 'AI 服务返回了 ${response.statusCode}：$serverMessage'
            : 'AI 服务返回了 ${response.statusCode}，请稍后再试。');
      }
    }
    final decoded = jsonDecode(utf8.decode(response.bodyBytes));
    if (decoded is! Map<String, dynamic>) {
      throw AIFormatException('响应不是 JSON 对象');
    }
    final choices = decoded['choices'];
    if (choices is! List || choices.isEmpty) {
      throw AIFormatException('响应缺少 choices');
    }
    final message = choices.first['message'];
    if (message is! Map<String, dynamic>) {
      throw AIFormatException('响应缺少 message');
    }
    final content = message['content'];
    if (content is! String || content.trim().isEmpty) {
      throw AIFormatException('响应缺少内容');
    }
    final parsed = jsonDecode(content);
    if (parsed is! Map<String, dynamic>) {
      throw AIFormatException('AI 输出的内容不是 JSON 对象');
    }
    return parsed;
  }
}

const _blueprintSystemPrompt = '你是 VEYRA 的战略规划助手。'
    '请根据用户的个人目标与约束，提炼出清晰的【阶段战略蓝图】（Phase Blueprint），作为后续细化任务的宏观骨架。'
    '只输出 JSON 对象，schema：'
    '{"project":{"title":"...","outcome":"清晰明确的终点交付成果物","executionMode":"project_only 或 weekly_planning",'
    '"deadline":"YYYY-MM-DD 可省略","phases":[{"title":"阶段名称（简短有力）","goal":"该阶段核心目标与边界","milestones":["阶段完成标志的里程碑"],"tasks":[]}]}}。'
    '注意：'
    '1. 提炼 2 到 4 个逻辑递进的阶段（例如：阶段一 基础摸底；阶段二 专项攻坚；阶段三 模拟验收）。'
    '2. 每个阶段设置明确的 goal 与 1~2 个关键 milestone。'
    '3. 此步骤不需要生成 tasks 列表（tasks 为空数组 []），重点在于阶段框架与方向对齐！'
    '4. 严禁输出 JSON 以外的任何文字。'
    '语气遵循：清晰、平静、推进感；不要制造焦虑。';

const _planSystemPrompt = '你是 VEYRA 的个人规划助手。'
    '把用户的目标变成可执行的项目规划。'
    '只输出 JSON 对象，schema：'
    '{"project":{"title":"...","outcome":"...","executionMode":"project_only 或 weekly_planning",'
    '"deadline":"YYYY-MM-DD 可省略","phases":[{"title":"...","goal":"...","milestones":["..."],'
    '"tasks":[{"title":"...","description":"...","priority":"must 或 optional",'
    '"estimatedEffort":"small/medium/large","dependencies":["其他任务标题"],"dueDate":"YYYY-MM-DD 可省略",'
    '"sourceQuote":"引用原文短句，可省略"}]}]}}。'
    '阶段 2 到 6 个，任务必须具体可执行，不要输出 JSON 以外的任何文字。'
    '语气遵循：清晰、平静、推进感；不要制造焦虑。';

const _decomposeSystemPrompt = '你是 VEYRA 的任务拆解助手。'
    '只输出 JSON：{"tasks":[{"title":"...","description":"...","priority":"must 或 optional",'
    '"estimatedEffort":"small/medium/large"}]}。每个小任务要具体、可在一次专注内推进。';

const _rebalanceSystemPrompt = '你是 VEYRA 的重规划助手。'
    'AI 不允许偷偷修改计划：你只能提出建议。'
    '只输出 JSON：{"changes":[{"kind":"move_week 或 priority_change 或 add_task 或 defer",'
    '"taskTitle":"...","from":"...","to":"...","detail":"为什么这样调整"}],"summary":"一句话总结"}。'
    '调整要克制，优先保住截止时间与必做项。';

const _reviewSystemPrompt = '你是 VEYRA 的复盘助手。'
    '只输出 JSON：{"highlights":["真实产出"],"deferred":["被推迟事项"],"oneLineSummary":"一句话"}。'
    'highlights 强调成果（deliverable），不要罗列任务数量，语气温和。';
