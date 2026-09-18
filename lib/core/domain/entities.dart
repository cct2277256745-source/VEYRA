/// VEYRA 领域实体。全部为不可变值对象，与持久化层（drift）分离（AGENTS §5）。
///
/// 层级（PRD §8）：Project → Phase → Milestone（可选）→ Task。
/// 周归属 WeeklyAssignment 与 Task 本体分离（PRD §21）。
library;

import 'enums.dart';

class Project {
  const Project({
    required this.id,
    required this.title,
    required this.outcome,
    required this.executionMode,
    required this.status,
    required this.health,
    required this.startDate,
    this.deadline,
    this.themeColor,
    this.sourceDocumentId,
    required this.createdAt,
    required this.updatedAt,
  });

  final int id;
  final String title;
  final String outcome;
  final ExecutionMode executionMode;
  final ProjectStatus status;
  final PlanHealth health;
  final DateTime startDate;
  final DateTime? deadline;
  final int? themeColor;
  final int? sourceDocumentId;
  final DateTime createdAt;
  final DateTime updatedAt;

  Project copyWith({
    int? id,
    String? title,
    String? outcome,
    ExecutionMode? executionMode,
    ProjectStatus? status,
    PlanHealth? health,
    DateTime? startDate,
    DateTime? deadline,
    bool clearDeadline = false,
    int? themeColor,
    int? sourceDocumentId,
    DateTime? updatedAt,
  }) {
    return Project(
      id: id ?? this.id,
      title: title ?? this.title,
      outcome: outcome ?? this.outcome,
      executionMode: executionMode ?? this.executionMode,
      status: status ?? this.status,
      health: health ?? this.health,
      startDate: startDate ?? this.startDate,
      deadline: clearDeadline ? null : (deadline ?? this.deadline),
      themeColor: themeColor ?? this.themeColor,
      sourceDocumentId: sourceDocumentId ?? this.sourceDocumentId,
      createdAt: createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

class Phase {
  const Phase({
    required this.id,
    required this.projectId,
    required this.title,
    required this.orderIndex,
    required this.createdAt,
    this.goal,
  });

  final int id;
  final int projectId;
  final String title;
  final String? goal;
  final int orderIndex;
  final DateTime createdAt;
}

class Milestone {
  const Milestone({
    required this.id,
    required this.projectId,
    required this.phaseId,
    required this.title,
    required this.orderIndex,
    required this.createdAt,
    this.completedAt,
  });

  final int id;
  final int projectId;
  final int phaseId;
  final String title;
  final int orderIndex;
  final DateTime createdAt;
  final DateTime? completedAt;

  bool get isCompleted => completedAt != null;
}

class Task {
  const Task({
    required this.id,
    required this.projectId,
    required this.phaseId,
    this.milestoneId,
    required this.title,
    this.description,
    required this.status,
    required this.priority,
    required this.effort,
    this.dueDate,
    this.sourceRefId,
    this.outcomeNote,
    this.userNote,
    required this.orderIndex,
    required this.createdAt,
    required this.updatedAt,
  });

  final int id;
  final int projectId;
  final int phaseId;
  final int? milestoneId;
  final String title;
  final String? description;
  final TaskStatus status;
  final TaskPriority priority;
  final EstimatedEffort effort;
  final DateTime? dueDate;
  final int? sourceRefId;
  final String? outcomeNote;
  final String? userNote;
  final int orderIndex;
  final DateTime createdAt;
  final DateTime updatedAt;

  bool get isDone => status == TaskStatus.completed;

  Task copyWith({
    int? id,
    int? projectId,
    int? phaseId,
    int? milestoneId,
    bool clearMilestone = false,
    String? title,
    String? description,
    TaskStatus? status,
    TaskPriority? priority,
    EstimatedEffort? effort,
    DateTime? dueDate,
    bool clearDueDate = false,
    int? sourceRefId,
    String? outcomeNote,
    String? userNote,
    int? orderIndex,
    DateTime? updatedAt,
  }) {
    return Task(
      id: id ?? this.id,
      projectId: projectId ?? this.projectId,
      phaseId: phaseId ?? this.phaseId,
      milestoneId: clearMilestone ? null : (milestoneId ?? this.milestoneId),
      title: title ?? this.title,
      description: description ?? this.description,
      status: status ?? this.status,
      priority: priority ?? this.priority,
      effort: effort ?? this.effort,
      dueDate: clearDueDate ? null : (dueDate ?? this.dueDate),
      sourceRefId: sourceRefId ?? this.sourceRefId,
      outcomeNote: outcomeNote ?? this.outcomeNote,
      userNote: userNote ?? this.userNote,
      orderIndex: orderIndex ?? this.orderIndex,
      createdAt: createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

/// 任务依赖（PRD §8 依赖任务；DependencyPolicy 数据基础）。
class TaskDependency {
  const TaskDependency({required this.taskId, required this.dependsOnTaskId});

  final int taskId;
  final int dependsOnTaskId;
}

/// 来源引用（PRD §10 来源追踪：来自哪个文件/哪段话/AI 为什么判断）。
class SourceRef {
  const SourceRef({
    required this.id,
    required this.kind,
    required this.quote,
    required this.aiReason,
    required this.createdAt,
    this.documentId,
  });

  final int id;
  final SourceKind kind;
  final String quote;
  final String aiReason;
  final int? documentId;
  final DateTime createdAt;
}

/// 本周容量设置（PRD §11.2），按周（周一为一周起点）存储。
class WeekSetting {
  const WeekSetting({required this.weekStart, required this.capacity});

  final DateTime weekStart;
  final CapacityLevel capacity;
}

/// 周归属：Task 本体之外的可选投影（PRD §21 硬规则）。
class WeeklyAssignment {
  const WeeklyAssignment({
    required this.id,
    required this.weekStart,
    required this.taskId,
    required this.projectId,
    required this.addedAt,
  });

  final int id;
  final DateTime weekStart;
  final int taskId;
  final int projectId;
  final DateTime addedAt;
}

/// 收件箱条目（PRD §15 Inbox）。
class InboxItem {
  const InboxItem({
    required this.id,
    required this.kind,
    required this.content,
    required this.status,
    required this.createdAt,
    this.filePath,
  });

  final int id;
  final InboxKind kind;
  final String content;
  final String? filePath;
  final InboxStatus status;
  final DateTime createdAt;
}

/// 来源文件（PRD §18：保留原文件名）。
class SourceDocument {
  const SourceDocument({
    required this.id,
    required this.fileName,
    required this.fileKind,
    required this.importedAt,
    this.filePath,
    this.extractedText,
  });

  final int id;
  final String fileName;
  final String fileKind;
  final String? filePath;
  final String? extractedText;
  final DateTime importedAt;
}

/// AI 提案（PRD §21：draft/accepted/partially_accepted/rejected）。
/// payload 为提案的完整结构化 JSON 文本，应用前只是草稿。
class AIProposal {
  const AIProposal({
    required this.id,
    required this.kind,
    required this.status,
    required this.payloadJson,
    required this.summary,
    required this.createdAt,
    this.decidedAt,
  });

  final int id;
  final String kind;
  final ProposalStatus status;
  final String payloadJson;
  final String summary;
  final DateTime createdAt;
  final DateTime? decidedAt;

  bool get isDecided => status != ProposalStatus.draft;
}

/// 进度事件（Progress Story 的原始轨迹）。
class ProgressEvent {
  const ProgressEvent({
    required this.id,
    required this.type,
    required this.detail,
    required this.occurredAt,
    this.projectId,
    this.taskId,
  });

  final int id;
  final ProgressEventType type;
  final int? projectId;
  final int? taskId;
  final String detail;
  final DateTime occurredAt;
}

/// 复盘快照（周复盘 / 项目复盘，PRD §9.6）。
class ReviewSnapshot {
  const ReviewSnapshot({
    required this.id,
    required this.scope,
    required this.periodStart,
    required this.periodEnd,
    required this.storyJson,
    required this.createdAt,
    this.targetId,
    this.aiSummary,
  });

  final int id;
  final ReviewScope scope;
  final int? targetId;
  final DateTime periodStart;
  final DateTime periodEnd;
  final String storyJson;
  final String? aiSummary;
  final DateTime createdAt;
}
