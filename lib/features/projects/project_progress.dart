/// 项目进度计算（Focus View 与 Projects 卡共用，单一来源）。
library;

import '../../core/design/progress_path.dart';
import '../../core/domain/entities.dart';

class ProjectProgress {
  ProjectProgress._();

  static double ratio(List<Task> tasks) {
    if (tasks.isEmpty) return 0;
    return tasks.where((t) => t.isDone).length / tasks.length;
  }

  static bool phaseDone(Phase phase, List<Task> tasks) {
    final phaseTasks = tasks.where((t) => t.phaseId == phase.id);
    return phaseTasks.isNotEmpty && phaseTasks.every((t) => t.isDone);
  }

  /// 当前阶段：第一个还有未完成任务的 Phase；全部完成则取最后一个。
  static Phase? currentPhase(List<Phase> phases, List<Task> tasks) {
    if (phases.isEmpty) return null;
    for (final phase in phases) {
      if (!phaseDone(phase, tasks)) return phase;
    }
    return phases.last;
  }

  /// Progress Path 节点：Phase 全部任务完成 = completed；
  /// 第一个未完成的 Phase = current（仅标记一个）。
  static List<ProgressPathNode> pathNodes(
      List<Phase> phases, List<Task> tasks) {
    var currentAssigned = false;
    final nodes = <ProgressPathNode>[];
    for (final phase in phases) {
      final done = phaseDone(phase, tasks);
      final isCurrent = !done && !currentAssigned;
      if (isCurrent) currentAssigned = true;
      nodes.add(ProgressPathNode(
          label: phase.title, completed: done, current: isCurrent));
    }
    return nodes;
  }
}
