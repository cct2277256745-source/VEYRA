/// Mock Provider：无网络、结果固定，用于测试与「未配置真实服务」时的演示（PRD §22 / AGENTS §6）。
/// Mock 绝不写任何真实用户数据——它只返回 Proposal，保存与否仍由应用层决定。
library;

import 'ai_provider.dart';
import 'plan_models.dart';

class MockAIProvider implements AIProvider {
  MockAIProvider({this.failWith});

  /// 设置后所有调用都会抛出该异常（错误路径测试用）。
  AIException? failWith;

  @override
  String get id => 'mock';

  @override
  Future<PlanDraft> buildBlueprint(AIBuildPlanRequest request) async {
    _maybeFail();
    final weekly = request.goal.contains('周') ||
        request.goal.contains('月') ||
        request.goal.contains('雅思') ||
        request.goal.contains('考研');
    return PlanDraft(
      title: request.goal.length > 40 ? request.goal.substring(0, 40) : request.goal,
      outcome: request.outcome ?? '完成：${request.goal}',
      suggestedMode: weekly
          ? SuggestedExecutionMode.weeklyPlanning
          : SuggestedExecutionMode.projectOnly,
      phases: const [
        PlanPhaseDraft(
          title: '第一步 · 摸清现状',
          goal: '把范围与基础看清楚',
          milestones: ['梳理出完整清单'],
          tasks: [],
        ),
        PlanPhaseDraft(
          title: '第二步 · 集中突破',
          goal: '攻克核心交付物',
          milestones: ['主要产出完成交付'],
          tasks: [],
        ),
        PlanPhaseDraft(
          title: '第三步 · 验收与固化',
          goal: '复盘成果并形成闭环',
          milestones: ['项目最终达成'],
          tasks: [],
        ),
      ],
    );
  }

  @override
  Future<PlanDraft> buildPlan(AIBuildPlanRequest request) async {
    _maybeFail();
    final weekly = request.goal.contains('周') ||
        request.goal.contains('月') ||
        request.goal.contains('雅思') ||
        request.goal.contains('考研');
    if (request.confirmedPhases != null && request.confirmedPhases!.isNotEmpty) {
      return PlanDraft(
        title: request.goal.length > 40 ? request.goal.substring(0, 40) : request.goal,
        outcome: request.outcome ?? '完成：${request.goal}',
        suggestedMode: weekly
            ? SuggestedExecutionMode.weeklyPlanning
            : SuggestedExecutionMode.projectOnly,
        phases: request.confirmedPhases!.asMap().entries.map((entry) {
          final idx = entry.key + 1;
          final phase = entry.value;
          final existingTasks = phase.tasks;
          return phase.copyWith(
            tasks: existingTasks.isNotEmpty
                ? existingTasks
                : [
                    PlanTaskDraft(
                      title: '落实「${phase.title}」重点工作',
                      priority: PlanTaskPriority.must,
                      effort: PlanTaskEffort.medium,
                      description: phase.goal,
                    ),
                    PlanTaskDraft(
                      title: '完成阶段 $idx 里程碑验收',
                      priority: PlanTaskPriority.optional,
                      effort: PlanTaskEffort.small,
                    ),
                  ],
          );
        }).toList(),
      );
    }
    return _fixedPlan(request.goal, weekly);
  }

  @override
  Future<PlanDraft> parseBlueprint(AIParsePlanRequest request) async {
    _maybeFail();
    return PlanDraft(
      title: request.fileName.replaceAll(RegExp(r'\.[a-zA-Z0-9]+$'), ''),
      outcome: '根据文档「${request.fileName}」提炼的完整攻坚方案',
      suggestedMode: SuggestedExecutionMode.weeklyPlanning,
      phases: const [
        PlanPhaseDraft(
          title: '第一阶段：基础梳理与认知构建',
          goal: '全面通读文档内容，建立核心概念与准备知识',
          milestones: ['准备工作就绪', '核心框架明确'],
          tasks: [],
        ),
        PlanPhaseDraft(
          title: '第二阶段：核心专题攻坚与实战',
          goal: '针对文档提出的重点难点进行集中攻关',
          milestones: ['核心模块突破', '形成阶段交付物'],
          tasks: [],
        ),
        PlanPhaseDraft(
          title: '第三阶段：整合验收与成果交付',
          goal: '全面复盘检验，查漏补缺，完成最终成果交付',
          milestones: ['最终验收达标', '沉淀完整复盘'],
          tasks: [],
        ),
      ],
    );
  }

  @override
  Future<PlanDraft> parsePlan(AIParsePlanRequest request) async {
    _maybeFail();
    final title = request.fileName.replaceAll(RegExp(r'\.[a-zA-Z0-9]+$'), '');
    if (request.confirmedPhases != null && request.confirmedPhases!.isNotEmpty) {
      return PlanDraft(
        title: title,
        outcome: '根据文档「${request.fileName}」提炼的完整攻坚方案',
        suggestedMode: SuggestedExecutionMode.weeklyPlanning,
        phases: request.confirmedPhases!.asMap().entries.map((entry) {
          final idx = entry.key + 1;
          final phase = entry.value;
          final existingTasks = phase.tasks;
          return phase.copyWith(
            tasks: existingTasks.isNotEmpty
                ? existingTasks
                : [
                    PlanTaskDraft(
                      title: '执行「${phase.title}」文档核心行动',
                      priority: PlanTaskPriority.must,
                      effort: PlanTaskEffort.medium,
                      description: phase.goal,
                      sourceQuote: '摘自文档：${phase.title}',
                    ),
                    PlanTaskDraft(
                      title: '完成阶段 $idx 里程碑验收',
                      priority: PlanTaskPriority.optional,
                      effort: PlanTaskEffort.small,
                      sourceQuote: '摘自文档里程碑',
                    ),
                  ],
          );
        }).toList(),
      );
    }
    return _fixedPlan(request.fileName, true);
  }

  @override
  Future<List<PlanTaskDraft>> decomposeTask(AIDecomposeRequest request) async {
    _maybeFail();
    return [
      PlanTaskDraft(
        title: '确定主线：${request.taskTitle}',
        description: '明确范围与产出物',
        priority: PlanTaskPriority.must,
        effort: PlanTaskEffort.small,
      ),
      const PlanTaskDraft(title: '列出第一步', priority: PlanTaskPriority.must),
      const PlanTaskDraft(title: '写第一版草稿'),
    ];
  }

  @override
  Future<RebalanceProposal> proposeRebalance(AIRebalanceRequest request) async {
    _maybeFail();
    return const RebalanceProposal(
      changes: [
        RebalanceChange(
          kind: RebalanceChangeKind.moveWeek,
          taskTitle: '雅思写作 Task 2',
          from: '本周',
          to: '下周',
          detail: '本周容量不足，把它移到下周更稳。',
        ),
        RebalanceChange(
          kind: RebalanceChangeKind.priorityChange,
          taskTitle: '作品集视觉',
          from: '可选',
          to: '必做',
          detail: '距截止日还有两周，视觉部分需要提前。',
        ),
        RebalanceChange(
          kind: RebalanceChangeKind.addTask,
          taskTitle: '周五面试准备',
          detail: '根据你的新情况新增。',
        ),
      ],
      summary: '建议把写作顺延一周，并提前作品集视觉。',
    );
  }

  @override
  Future<AIReviewSummary> generateReview(AIReviewRequest request) async {
    _maybeFail();
    return AIReviewSummary(
      highlights: request.completedItems.isEmpty
          ? const ['本周安静地推进了规划']
          : request.completedItems.take(3).toList(),
      deferred: request.deferredItems,
      oneLineSummary: '这一周在稳步向前，重要的节点都在靠近。',
    );
  }

  PlanDraft _fixedPlan(String goal, bool weekly) => PlanDraft(
        title: goal.length > 40 ? goal.substring(0, 40) : goal,
        outcome: '完成：$goal',
        suggestedMode: weekly
            ? SuggestedExecutionMode.weeklyPlanning
            : SuggestedExecutionMode.projectOnly,
        phases: [
          const PlanPhaseDraft(
            title: '第一步 · 摸清现状',
            goal: '把范围看清楚',
            tasks: [
              PlanTaskDraft(
                title: '列出现状清单',
                priority: PlanTaskPriority.must,
                effort: PlanTaskEffort.small,
                sourceQuote: '引自原文：现状与目标',
              ),
              PlanTaskDraft(title: '确定衡量标准'),
            ],
          ),
          const PlanPhaseDraft(
            title: '第二步 · 集中推进',
            goal: '把主要产出做出来',
            milestones: ['核心产出完成'],
            tasks: [
              PlanTaskDraft(title: '完成主要产出', priority: PlanTaskPriority.must),
            ],
          ),
        ],
      );

  void _maybeFail() {
    final failure = failWith;
    if (failure != null) throw failure;
  }
}
