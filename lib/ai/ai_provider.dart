/// AI Provider 抽象（PRD §16.4）。AI 只返回结构化 Proposal，绝不直接写库。
library;

import 'plan_models.dart';

/// AI 异常体系：全部可恢复，不允许影响本地功能（PRD §22）。
class AIException implements Exception {
  AIException(this.reason);

  final String reason;

  @override
  String toString() => reason;
}

class AINotConfiguredException extends AIException {
  AINotConfiguredException()
      : super('AI 还没有配置。在设置里填好 Base URL、Model 和 API Key 就能用了，本地功能不受影响。');
}

class AIAuthException extends AIException {
  AIAuthException([String? reason])
      : super(reason ?? 'API Key 无效或没有权限，请到设置里检查。');
}

class AIRateLimitException extends AIException {
  AIRateLimitException({this.retryAfterSeconds})
      : super('AI 服务限流了，稍等一下再试。');

  final int? retryAfterSeconds;

  @override
  String toString() =>
      'AI 服务限流了，稍等${retryAfterSeconds == null ? '一下' : ' $retryAfterSeconds 秒'}再试。';
}

class AIFormatException extends AIException {
  AIFormatException(super.reason);
}

class AINetworkException extends AIException {
  AINetworkException() : super('连不上 AI 服务。检查网络后重试，VEYRA 的本地功能不受影响。');
}

class AIBuildPlanRequest {
  const AIBuildPlanRequest({
    required this.goal,
    this.outcome,
    this.background,
    this.deadline,
    this.constraints,
    this.confirmedPhases,
  });

  final String goal;
  final String? outcome;
  final String? background;
  final DateTime? deadline;
  final String? constraints;
  final List<PlanPhaseDraft>? confirmedPhases;
}

class AIParsePlanRequest {
  const AIParsePlanRequest({
    required this.documentText,
    required this.fileName,
    this.confirmedPhases,
  });

  final String documentText;
  final String fileName;
  final List<PlanPhaseDraft>? confirmedPhases;
}

class AIDecomposeRequest {
  const AIDecomposeRequest({
    required this.taskTitle,
    this.projectOutcome,
  });

  final String taskTitle;
  final String? projectOutcome;
}

class AIRebalanceRequest {
  const AIRebalanceRequest({
    required this.situation,
    required this.currentWeekDescription,
    required this.deadlineDescription,
    required this.taskSummary,
  });

  final String situation;
  final String currentWeekDescription;
  final String deadlineDescription;
  final String taskSummary;
}

class AIReviewRequest {
  const AIReviewRequest({
    required this.scopeDescription,
    required this.completedItems,
    required this.milestonesCompleted,
    required this.deferredItems,
  });

  final String scopeDescription;
  final List<String> completedItems;
  final List<String> milestonesCompleted;
  final List<String> deferredItems;
}

abstract class AIProvider {
  String get id;

  /// 生成战略蓝图（提炼阶段架构与关键里程碑，供用户中间确认，不展开子任务）。
  Future<PlanDraft> buildBlueprint(AIBuildPlanRequest request);

  Future<PlanDraft> buildPlan(AIBuildPlanRequest request);

  /// 从导入文档提炼战略蓝图（阶段架构与里程碑，供用户中间确认）。
  Future<PlanDraft> parseBlueprint(AIParsePlanRequest request);

  Future<PlanDraft> parsePlan(AIParsePlanRequest request);

  Future<List<PlanTaskDraft>> decomposeTask(AIDecomposeRequest request);

  Future<RebalanceProposal> proposeRebalance(AIRebalanceRequest request);

  Future<AIReviewSummary> generateReview(AIReviewRequest request);
}
