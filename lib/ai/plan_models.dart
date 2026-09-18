/// AI 结构化输出模型（PRD §17）。
///
/// fromJson 带校验：格式错误抛 AIFormatException，绝不让坏数据进入仓储。
library;

import 'ai_provider.dart';

enum PlanTaskPriority { must, optional }

enum PlanTaskEffort { small, medium, large }

enum SuggestedExecutionMode { projectOnly, weeklyPlanning }

class PlanDraft {
  const PlanDraft({
    required this.title,
    required this.outcome,
    required this.suggestedMode,
    required this.phases,
    this.deadline,
  });

  final String title;
  final String outcome;
  final SuggestedExecutionMode suggestedMode;
  final List<PlanPhaseDraft> phases;
  final DateTime? deadline;

  static PlanDraft fromJson(Map<String, dynamic> json) {
    final project = json['project'];
    if (project is! Map<String, dynamic>) {
      throw AIFormatException('缺少 project 对象');
    }
    final title = project['title'];
    if (title is! String || title.trim().isEmpty) {
      throw AIFormatException('project.title 缺失或为空');
    }
    final modeRaw = project['executionMode'];
    final mode = switch (modeRaw) {
      'project_only' => SuggestedExecutionMode.projectOnly,
      'weekly_planning' => SuggestedExecutionMode.weeklyPlanning,
      _ => SuggestedExecutionMode.projectOnly,
    };
    final rawPhases = project['phases'];
    if (rawPhases is! List || rawPhases.isEmpty) {
      throw AIFormatException('project.phases 缺失或为空');
    }
    final phases = rawPhases.map((p) => PlanPhaseDraft.fromJson(p)).toList();
    final deadlineRaw = project['deadline'];
    DateTime? deadline;
    if (deadlineRaw is String && deadlineRaw.isNotEmpty) {
      deadline = DateTime.tryParse(deadlineRaw);
    }
    final outcomeRaw = project['outcome'];
    return PlanDraft(
      title: title.trim(),
      outcome: outcomeRaw is String ? outcomeRaw : '',
      suggestedMode: mode,
      phases: phases,
      deadline: deadline,
    );
  }

  PlanDraft copyWith({
    String? title,
    String? outcome,
    SuggestedExecutionMode? suggestedMode,
    List<PlanPhaseDraft>? phases,
    DateTime? deadline,
  }) {
    return PlanDraft(
      title: title ?? this.title,
      outcome: outcome ?? this.outcome,
      suggestedMode: suggestedMode ?? this.suggestedMode,
      phases: phases ?? this.phases,
      deadline: deadline ?? this.deadline,
    );
  }

  Map<String, dynamic> toJson() => {
        'project': {
          'title': title,
          'outcome': outcome,
          'executionMode': suggestedMode == SuggestedExecutionMode.projectOnly
              ? 'project_only'
              : 'weekly_planning',
          if (deadline != null)
            'deadline': deadline!.toIso8601String().substring(0, 10),
          'phases': phases.map((p) => p.toJson()).toList(),
        }
      };
}

class PlanPhaseDraft {
  const PlanPhaseDraft({
    required this.title,
    this.goal,
    required this.tasks,
    this.milestones = const [],
  });

  final String title;
  final String? goal;
  final List<String> milestones;
  final List<PlanTaskDraft> tasks;

  static PlanPhaseDraft fromJson(Object? json) {
    if (json is String) {
      return PlanPhaseDraft(
        title: json.trim().isEmpty ? '未命名阶段' : json.trim(),
        tasks: const [],
        milestones: const [],
      );
    }
    final Map<String, dynamic> map;
    if (json is Map<String, dynamic>) {
      map = json;
    } else if (json is Map) {
      map = json.map((k, v) => MapEntry(k.toString(), v));
    } else {
      throw AIFormatException('phases 元素不是对象');
    }
    final rawTitle = map['title'] ?? map['phase'] ?? map['name'] ?? map['phaseName'];
    if (rawTitle == null || rawTitle.toString().trim().isEmpty) {
      throw AIFormatException('phase.title 缺失或为空');
    }
    final title = rawTitle.toString().trim();
    final rawTasks = map['tasks'];
    final tasks = <PlanTaskDraft>[];
    if (rawTasks is List) {
      for (final t in rawTasks) {
        tasks.add(PlanTaskDraft.fromJson(t));
      }
    }
    final rawMilestones = map['milestones'];
    final milestones = <String>[];
    if (rawMilestones is List) {
      for (final m in rawMilestones) {
        if (m is String && m.trim().isNotEmpty) {
          milestones.add(m.trim());
        } else if (m is Map) {
          final mTitle = m['title'] ?? m['name'];
          if (mTitle is String && mTitle.trim().isNotEmpty) {
            milestones.add(mTitle.trim());
          }
        }
      }
    }
    final goal = map['goal'];
    return PlanPhaseDraft(
      title: title,
      goal: goal?.toString(),
      tasks: tasks,
      milestones: milestones,
    );
  }

  PlanPhaseDraft copyWith({
    String? title,
    String? goal,
    List<String>? milestones,
    List<PlanTaskDraft>? tasks,
  }) {
    return PlanPhaseDraft(
      title: title ?? this.title,
      goal: goal ?? this.goal,
      milestones: milestones ?? this.milestones,
      tasks: tasks ?? this.tasks,
    );
  }

  Map<String, dynamic> toJson() => {
        'title': title,
        if (goal != null) 'goal': goal,
        'milestones': milestones,
        'tasks': tasks.map((t) => t.toJson()).toList(),
      };
}

class PlanTaskDraft {
  const PlanTaskDraft({
    required this.title,
    this.description,
    this.priority = PlanTaskPriority.optional,
    this.effort = PlanTaskEffort.medium,
    this.dependencies = const [],
    this.dueDate,
    this.sourceQuote,
  });

  final String title;
  final String? description;
  final PlanTaskPriority priority;
  final PlanTaskEffort effort;
  final List<String> dependencies;
  final DateTime? dueDate;
  final String? sourceQuote;

  static PlanTaskDraft fromJson(Object? json) {
    if (json is String) {
      return PlanTaskDraft(
        title: json.trim().isEmpty ? '未命名任务' : json.trim(),
      );
    }
    final Map<String, dynamic> map;
    if (json is Map<String, dynamic>) {
      map = json;
    } else if (json is Map) {
      map = json.map((k, v) => MapEntry(k.toString(), v));
    } else {
      throw AIFormatException('task 元素不是对象');
    }
    final rawTitle = map['title'] ?? map['task'] ?? map['name'] ?? map['taskTitle'];
    if (rawTitle == null || rawTitle.toString().trim().isEmpty) {
      throw AIFormatException('task.title 缺失或为空');
    }
    final title = rawTitle.toString().trim();
    final priority = switch (map['priority']) {
      'must' => PlanTaskPriority.must,
      'optional' => PlanTaskPriority.optional,
      _ => PlanTaskPriority.optional,
    };
    final effort = switch (map['estimatedEffort']) {
      'small' => PlanTaskEffort.small,
      'large' => PlanTaskEffort.large,
      _ => PlanTaskEffort.medium,
    };
    final deps = <String>[];
    if (map['dependencies'] is List) {
      for (final d in map['dependencies'] as List) {
        if (d is String && d.trim().isNotEmpty) deps.add(d.trim());
      }
    }
    final dueRaw = map['dueDate'];
    DateTime? due;
    if (dueRaw is String && dueRaw.isNotEmpty) due = DateTime.tryParse(dueRaw);
    final quote = map['sourceQuote'];
    final desc = map['description'];
    return PlanTaskDraft(
      title: title,
      description: desc?.toString(),
      priority: priority,
      effort: effort,
      dependencies: deps,
      dueDate: due,
      sourceQuote: quote?.toString(),
    );
  }

  PlanTaskDraft copyWith({
    String? title,
    String? description,
    PlanTaskPriority? priority,
    PlanTaskEffort? effort,
    List<String>? dependencies,
    DateTime? dueDate,
    String? sourceQuote,
  }) {
    return PlanTaskDraft(
      title: title ?? this.title,
      description: description ?? this.description,
      priority: priority ?? this.priority,
      effort: effort ?? this.effort,
      dependencies: dependencies ?? this.dependencies,
      dueDate: dueDate ?? this.dueDate,
      sourceQuote: sourceQuote ?? this.sourceQuote,
    );
  }

  Map<String, dynamic> toJson() => {
        'title': title,
        if (description != null) 'description': description,
        'priority': priority == PlanTaskPriority.must ? 'must' : 'optional',
        'estimatedEffort': switch (effort) {
          PlanTaskEffort.small => 'small',
          PlanTaskEffort.medium => 'medium',
          PlanTaskEffort.large => 'large',
        },
        'dependencies': dependencies,
        if (dueDate != null)
          'dueDate': dueDate!.toIso8601String().substring(0, 10),
        if (sourceQuote != null) 'sourceQuote': sourceQuote,
      };
}

/// 重规划差异项（Slice 2.7 预览的数据基础）。
enum RebalanceChangeKind { moveWeek, priorityChange, addTask, defer }

class RebalanceChange {
  const RebalanceChange({
    required this.kind,
    required this.taskTitle,
    required this.detail,
    this.from,
    this.to,
  });

  final RebalanceChangeKind kind;
  final String taskTitle;
  final String? from;
  final String? to;
  final String detail;

  static RebalanceChange fromJson(Object? json) {
    if (json is! Map<String, dynamic>) {
      throw AIFormatException('change 元素不是对象');
    }
    final kind = switch (json['kind']) {
      'move_week' => RebalanceChangeKind.moveWeek,
      'priority_change' => RebalanceChangeKind.priorityChange,
      'add_task' => RebalanceChangeKind.addTask,
      'defer' => RebalanceChangeKind.defer,
      _ => throw AIFormatException('未知的 change kind'),
    };
    final taskTitle = json['taskTitle'];
    if (taskTitle is! String || taskTitle.trim().isEmpty) {
      throw AIFormatException('change.taskTitle 缺失');
    }
    return RebalanceChange(
      kind: kind,
      taskTitle: taskTitle.trim(),
      from: json['from'] is String ? json['from'] as String : null,
      to: json['to'] is String ? json['to'] as String : null,
      detail: json['detail'] is String ? json['detail'] as String : '',
    );
  }

  Map<String, dynamic> toJson() => {
        'kind': switch (kind) {
          RebalanceChangeKind.moveWeek => 'move_week',
          RebalanceChangeKind.priorityChange => 'priority_change',
          RebalanceChangeKind.addTask => 'add_task',
          RebalanceChangeKind.defer => 'defer',
        },
        'taskTitle': taskTitle,
        if (from != null) 'from': from,
        if (to != null) 'to': to,
        'detail': detail,
      };
}

class RebalanceProposal {
  const RebalanceProposal({required this.changes, required this.summary});

  final List<RebalanceChange> changes;
  final String summary;

  static RebalanceProposal fromJson(Map<String, dynamic> json) {
    final raw = json['changes'];
    if (raw is! List) {
      throw AIFormatException('changes 缺失');
    }
    return RebalanceProposal(
      changes: raw.map(RebalanceChange.fromJson).toList(),
      summary: json['summary'] is String ? json['summary'] as String : '',
    );
  }

  Map<String, dynamic> toJson() => {
        'changes': changes.map((c) => c.toJson()).toList(),
        'summary': summary,
      };
}

/// 复盘总结（成果优先，PRD §9.6）。
class AIReviewSummary {
  const AIReviewSummary({
    required this.highlights,
    required this.oneLineSummary,
    this.deferred = const [],
  });

  final List<String> highlights;
  final List<String> deferred;
  final String oneLineSummary;

  static AIReviewSummary fromJson(Map<String, dynamic> json) {
    final highlights = <String>[];
    if (json['highlights'] is List) {
      for (final h in json['highlights'] as List) {
        if (h is String && h.trim().isNotEmpty) highlights.add(h.trim());
      }
    }
    final deferred = <String>[];
    if (json['deferred'] is List) {
      for (final d in json['deferred'] as List) {
        if (d is String && d.trim().isNotEmpty) deferred.add(d.trim());
      }
    }
    final summary = json['oneLineSummary'];
    if (summary is! String || summary.trim().isEmpty) {
      throw AIFormatException('oneLineSummary 缺失');
    }
    return AIReviewSummary(
      highlights: highlights,
      deferred: deferred,
      oneLineSummary: summary.trim(),
    );
  }

  Map<String, dynamic> toJson() => {
        'highlights': highlights,
        'deferred': deferred,
        'oneLineSummary': oneLineSummary,
      };
}
