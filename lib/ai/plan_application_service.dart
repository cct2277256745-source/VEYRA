/// Plan Builder / Parser 应用服务（Slice 2.5，PRD §7/§9.1/§9.2/§17）。
///
/// 硬流程：AI 输出 → 结构校验 → AIProposal 草稿 → Preview → 用户确认 → 落库。
/// AI 不得直接覆盖或创建用户数据：确认之前，唯一变化是 proposals 表多一行 draft。
library;

import 'dart:convert';

import '../core/domain/enums.dart';
import '../core/domain/entities.dart';
import '../data/app_services.dart';
import 'ai_provider.dart';
import 'plan_models.dart';

class PlanApplicationService {
  PlanApplicationService({this.provider, required this.services});

  final AIProvider? provider;
  final AppServices services;

  /// 阶段一：生成战略蓝图（阶段框架与关键里程碑，供用户中间确认与微调）。
  Future<PlanDraft> generateBlueprint(AIBuildPlanRequest request) async {
    if (provider == null) throw AINotConfiguredException();
    return await provider!.buildBlueprint(request);
  }

  /// 路径 B：从自然语言目标生成计划草案。
  Future<AIProposal> generateFromGoal(AIBuildPlanRequest request) async {
    if (provider == null) throw AINotConfiguredException();
    final draft = await provider!.buildPlan(request);
    return _saveDraft(draft, '来自目标：${request.goal}');
  }

  /// 从已导入文档提炼战略蓝图（阶段架构与关键里程碑，供用户中间确认与微调）。
  Future<PlanDraft> generateBlueprintFromFile({
    required ExtractedPlanFile file,
  }) async {
    if (provider == null) throw AINotConfiguredException();
    return await provider!.parseBlueprint(AIParsePlanRequest(
      documentText: file.text,
      fileName: file.fileName,
    ));
  }

  /// 路径 A：从已导入文件生成计划草案（可带来源文件与用户确认的阶段约束）。
  Future<AIProposal> generateFromFile({
    required ExtractedPlanFile file,
    List<PlanPhaseDraft>? confirmedPhases,
  }) async {
    if (provider == null) throw AINotConfiguredException();
    final draft = await provider!.parsePlan(AIParsePlanRequest(
      documentText: file.text,
      fileName: file.fileName,
      confirmedPhases: confirmedPhases,
    ));
    final saved = await _saveDraft(
        draft, '来自文件：${file.fileName}');
    return saved;
  }

  /// 用户确认：把草案真正落库，返回创建的 Project。
  /// 支持传入用户在预览页勾选/微调后的 [customDraft]，真正实现“所见即所建”。
  Future<Project> confirmProposal(
    int proposalId, {
    int? sourceDocumentId,
    PlanDraft? customDraft,
  }) async {
    final proposal = await services.proposals.get(proposalId);
    if (proposal == null) {
      throw AIException('提案不存在。');
    }
    if (proposal.isDecided) {
      throw AIException('这份提案已经处理过了。');
    }
    final draft = customDraft ??
        PlanDraft.fromJson(jsonDecode(proposal.payloadJson) as Map<String, dynamic>);

    final project = await services.projects.createProject(
      title: draft.title,
      outcome: draft.outcome,
      executionMode: draft.suggestedMode == SuggestedExecutionMode.weeklyPlanning
          ? ExecutionMode.weeklyPlanning
          : ExecutionMode.projectOnly,
      deadline: draft.deadline,
      sourceDocumentId: sourceDocumentId,
    );

    // 任务标题 → 已创建任务（依赖在本计划内按标题解析）。
    final taskIdsByTitle = <String, int>{};
    for (final phaseDraft in draft.phases) {
      final phase = await services.projects
          .createPhase(project.id, phaseDraft.title, goal: phaseDraft.goal);
      for (final milestoneTitle in phaseDraft.milestones) {
        await services.projects.createMilestone(phase.id, milestoneTitle);
      }
      for (final taskDraft in phaseDraft.tasks) {
        int? sourceRefId;
        if (taskDraft.sourceQuote != null && taskDraft.sourceQuote!.isNotEmpty) {
          final ref = await services.projects.createSourceRef(
            kind: SourceKind.document,
            quote: taskDraft.sourceQuote!,
            aiReason: 'AI 判断它应存在于「${phaseDraft.title}」阶段',
          );
          sourceRefId = ref.id;
        }
        final task = await services.projects.createTask(
          projectId: project.id,
          phaseId: phase.id,
          title: taskDraft.title,
          description: taskDraft.description,
          priority: taskDraft.priority == PlanTaskPriority.must
              ? TaskPriority.must
              : TaskPriority.optional,
          effort: taskDraft.effort == PlanTaskEffort.small
              ? EstimatedEffort.small
              : taskDraft.effort == PlanTaskEffort.large
                  ? EstimatedEffort.large
                  : EstimatedEffort.medium,
          sourceRefId: sourceRefId,
        );
        taskIdsByTitle[taskDraft.title] = task.id;
      }
    }
    // 依赖在全部任务创建后统一接线（避免前向引用丢失）。
    for (final phaseDraft in draft.phases) {
      for (final taskDraft in phaseDraft.tasks) {
        for (final depTitle in taskDraft.dependencies) {
          final depId = taskIdsByTitle[depTitle];
          final taskId = taskIdsByTitle[taskDraft.title];
          if (depId != null && taskId != null) {
            await services.projects.addDependency(taskId, depId);
          }
        }
      }
    }

    await services.proposals.decide(proposalId, ProposalStatus.accepted);
    await services.progress.log(ProgressEventType.proposalApplied,
        projectId: project.id, detail: proposal.summary);
    return (await services.projects.getProject(project.id))!;
  }

  /// 用户拒绝：只改提案状态，不碰任何项目数据。
  Future<void> rejectProposal(int proposalId) async {
    final proposal = await services.proposals.get(proposalId);
    if (proposal == null || proposal.isDecided) return;
    await services.proposals.decide(proposalId, ProposalStatus.rejected);
  }

  Future<AIProposal> _saveDraft(PlanDraft draft, String summary) async {
    final taskCount = draft.phases.fold<int>(0, (n, p) => n + p.tasks.length);
    return services.proposals.saveDraft(
      kind: 'plan',
      payloadJson: jsonEncode(draft.toJson()),
      summary: '${draft.title}（${draft.phases.length} 个阶段 / $taskCount 个任务）',
    );
  }
}

/// 已导入文件 → AI 解析输入。
class ExtractedPlanFile {
  const ExtractedPlanFile({
    required this.fileName,
    required this.text,
    this.sourceDocumentId,
  });

  final String fileName;
  final String text;
  final int? sourceDocumentId;
}
