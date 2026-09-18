import 'package:flutter/material.dart';

import '../../app/app_scope.dart';
import '../../core/design/tokens.dart';
import '../../core/design/veyra_app_bar.dart';
import '../../core/design/veyra_badge.dart';
import '../../core/domain/enums.dart';
import '../../core/domain/entities.dart';

class ProjectPlanPage extends StatefulWidget {
  const ProjectPlanPage({super.key, required this.projectId});

  final int projectId;

  @override
  State<ProjectPlanPage> createState() => _ProjectPlanPageState();
}

class _ProjectPlanPageState extends State<ProjectPlanPage>
    with AppServicesAccess {
  Future<_PlanData>? _future;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _future ??= _load();
  }

  Future<_PlanData> _load() async {
    final project = await services.projects.getProject(widget.projectId);
    final phases = await services.projects.phasesOfProject(widget.projectId);
    final milestones =
        await services.projects.milestonesOfProject(widget.projectId);
    final tasks = await services.projects.tasksOfProject(widget.projectId);
    return _PlanData(
      project: project!,
      phases: phases,
      milestones: milestones,
      tasks: tasks,
    );
  }

  void _reload() {
    setState(() {
      _future = _load();
    });
  }

  Future<void> _addPhase() async {
    final title = await _askSingleLine('新建阶段', '阶段名称（例如：听力专项）');
    if (title == null || title.isEmpty) return;
    await services.projects.createPhase(widget.projectId, title);
    _reload();
  }

  Future<void> _addTask(int phaseId) async {
    final title = await _askSingleLine('新建任务', '任务名称');
    if (title == null || title.isEmpty) return;
    await services.projects.createTask(
      projectId: widget.projectId,
      phaseId: phaseId,
      title: title,
    );
    _reload();
  }

  Future<void> _addMilestone(int phaseId) async {
    final title = await _askSingleLine('新建里程碑', '里程碑名称');
    if (title == null || title.isEmpty) return;
    await services.projects.createMilestone(phaseId, title);
    _reload();
  }

  Future<String?> _askSingleLine(String title, String hint) {
    final controller = TextEditingController();
    return showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: VeyraColors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(VeyraRadius.large),
          side: const BorderSide(color: VeyraColors.border),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: VeyraColors.textPrimary,
          ),
        ),
        content: TextField(
          controller: controller,
          autofocus: true,
          style: const TextStyle(fontSize: 14),
          decoration: InputDecoration(
            labelText: hint,
            labelStyle: const TextStyle(
              fontSize: 14,
              color: VeyraColors.textSecondary,
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('取消'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: VeyraColors.primaryButton,
            ),
            onPressed: () => Navigator.of(context).pop(controller.text.trim()),
            child: const Text('确定'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const VeyraAppBar(
        title: Text('完整规划与拆解'),
      ),
      body: FutureBuilder<_PlanData>(
        future: _future,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final data = snapshot.data!;
          final accent = VeyraColors.fromArgb(data.project.themeColor);

          return Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 880),
              child: ListView(
                padding: const EdgeInsets.fromLTRB(
                  VeyraSpacing.s32,
                  VeyraSpacing.s24,
                  VeyraSpacing.s32,
                  VeyraSpacing.s48,
                ),
                children: [
                  // 顶部项目简要信息
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              data.project.title,
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.w700,
                                letterSpacing: -0.5,
                                color: VeyraColors.textPrimary,
                              ),
                            ),
                            if (data.project.outcome.isNotEmpty) ...[
                              const SizedBox(height: VeyraSpacing.s4),
                              Text(
                                data.project.outcome,
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: VeyraColors.textSecondary,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                      OutlinedButton.icon(
                        icon: const Icon(Icons.add_rounded, size: 16),
                        label: const Text('新建阶段'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: VeyraColors.textPrimary,
                          side: const BorderSide(color: VeyraColors.border),
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(VeyraRadius.medium),
                          ),
                        ),
                        onPressed: _addPhase,
                      ),
                    ],
                  ),

                  const SizedBox(height: VeyraSpacing.s24),

                  // 阶段卡片列表
                  for (var i = 0; i < data.phases.length; i++) ...[
                    _PhaseCard(
                      index: i + 1,
                      phase: data.phases[i],
                      milestones: data.milestones
                          .where((m) => m.phaseId == data.phases[i].id)
                          .toList(),
                      tasks: data.tasks
                          .where((t) => t.phaseId == data.phases[i].id)
                          .toList(),
                      accent: accent,
                      onAddMilestone: () => _addMilestone(data.phases[i].id),
                      onAddTask: () => _addTask(data.phases[i].id),
                      onToggleTask: (task, checked) async {
                        if (checked) {
                          await services.projects.completeTask(task.id);
                        } else {
                          await services.projects
                              .setTaskStatus(task.id, TaskStatus.planned);
                        }
                        _reload();
                      },
                    ),
                    const SizedBox(height: VeyraSpacing.s20),
                  ],

                  if (data.phases.isEmpty)
                    Container(
                      padding: const EdgeInsets.all(VeyraSpacing.s32),
                      decoration: BoxDecoration(
                        color: VeyraColors.surface,
                        borderRadius:
                            BorderRadius.circular(VeyraRadius.large),
                        border: Border.all(color: VeyraColors.border),
                      ),
                      child: Center(
                        child: Column(
                          children: [
                            const Text(
                              '当前还没有阶段规划',
                              style: TextStyle(
                                fontSize: 15,
                                color: VeyraColors.textSecondary,
                              ),
                            ),
                            const SizedBox(height: VeyraSpacing.s16),
                            FilledButton.icon(
                              onPressed: _addPhase,
                              icon: const Icon(Icons.add, size: 16),
                              label: const Text('创建第一个阶段'),
                              style: FilledButton.styleFrom(
                                backgroundColor: VeyraColors.primaryButton,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _PhaseCard extends StatelessWidget {
  const _PhaseCard({
    required this.index,
    required this.phase,
    required this.milestones,
    required this.tasks,
    required this.accent,
    required this.onAddMilestone,
    required this.onAddTask,
    required this.onToggleTask,
  });

  final int index;
  final Phase phase;
  final List<Milestone> milestones;
  final List<Task> tasks;
  final Color accent;
  final VoidCallback onAddMilestone;
  final VoidCallback onAddTask;
  final void Function(Task task, bool checked) onToggleTask;

  @override
  Widget build(BuildContext context) {
    final doneTasks = tasks.where((t) => t.isDone).length;
    final totalTasks = tasks.length;

    return Container(
      decoration: BoxDecoration(
        color: VeyraColors.surface,
        borderRadius: BorderRadius.circular(VeyraRadius.large),
        border: Border.all(color: VeyraColors.border),
        boxShadow: VeyraShadows.subtle,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 阶段头部
          Padding(
            padding: const EdgeInsets.fromLTRB(
              VeyraSpacing.s20,
              VeyraSpacing.s16,
              VeyraSpacing.s16,
              VeyraSpacing.s12,
            ),
            child: Row(
              children: [
                VeyraTagBadge(
                  label: 'PHASE ${index.toString().padLeft(2, '0')}',
                  color: VeyraColors.textSecondary,
                  background: VeyraColors.backgroundAlt,
                ),
                const SizedBox(width: VeyraSpacing.s10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '阶段 · ${phase.title}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: VeyraColors.textPrimary,
                        ),
                      ),
                      if (phase.goal != null && phase.goal!.isNotEmpty) ...[
                        const SizedBox(height: 2),
                        Text(
                          phase.goal!,
                          style: const TextStyle(
                            fontSize: 13,
                            color: VeyraColors.textSecondary,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                if (totalTasks > 0)
                  VeyraTagBadge(
                    label: '$doneTasks/$totalTasks 完成',
                    color: doneTasks == totalTasks
                        ? VeyraColors.success
                        : VeyraColors.textSecondary,
                    background: doneTasks == totalTasks
                        ? VeyraColors.successBg
                        : VeyraColors.backgroundAlt,
                  ),
                const SizedBox(width: VeyraSpacing.s8),
                IconButton(
                  tooltip: '添加里程碑',
                  icon: const Icon(Icons.outlined_flag_rounded, size: 18),
                  onPressed: onAddMilestone,
                ),
                IconButton(
                  tooltip: '新建任务',
                  icon: const Icon(Icons.add_task_rounded, size: 18),
                  onPressed: onAddTask,
                ),
              ],
            ),
          ),

          // 里程碑条目
          if (milestones.isNotEmpty) ...[
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: VeyraSpacing.s20,
                vertical: VeyraSpacing.s4,
              ),
              child: Wrap(
                spacing: VeyraSpacing.s8,
                runSpacing: VeyraSpacing.s6,
                children: milestones.map((m) {
                  final isDone = m.isCompleted;
                  return Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: VeyraSpacing.s10,
                      vertical: VeyraSpacing.s6,
                    ),
                    decoration: BoxDecoration(
                      color: isDone
                          ? VeyraColors.successBg
                          : VeyraColors.dopamineCardBg,
                      borderRadius:
                          BorderRadius.circular(VeyraRadius.medium),
                      border: Border.all(
                        color: isDone
                            ? VeyraColors.success.withValues(alpha: 0.35)
                            : VeyraColors.dopamineCardBorder,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          isDone
                              ? Icons.check_circle_outline_rounded
                              : Icons.outlined_flag_rounded,
                          size: 14,
                          color: isDone
                              ? VeyraColors.success
                              : VeyraColors.dopamineIris,
                        ),
                        const SizedBox(width: VeyraSpacing.s6),
                        Text(
                          m.title,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: VeyraColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: VeyraSpacing.s8),
          ],

          // 分割线
          if (tasks.isNotEmpty)
            const Divider(height: 1, color: VeyraColors.border),

          // 任务列表
          if (tasks.isEmpty && milestones.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(
                horizontal: VeyraSpacing.s20,
                vertical: VeyraSpacing.s16,
              ),
              child: Text(
                '这个阶段还没有任务',
                style: TextStyle(
                  fontSize: 13,
                  color: VeyraColors.textTertiary,
                ),
              ),
            )
          else
            for (var j = 0; j < tasks.length; j++) ...[
              if (j > 0)
                const Divider(height: 1, color: VeyraColors.border),
              _PlanTaskRow(
                task: tasks[j],
                accent: accent,
                onToggle: (checked) => onToggleTask(tasks[j], checked),
              ),
            ],
        ],
      ),
    );
  }
}

class _PlanTaskRow extends StatelessWidget {
  const _PlanTaskRow({
    required this.task,
    required this.accent,
    required this.onToggle,
  });

  final Task task;
  final Color accent;
  final ValueChanged<bool> onToggle;

  @override
  Widget build(BuildContext context) {
    final done = task.isDone;

    return Material(
      color: Colors.transparent,
      child: CheckboxListTile(
        value: done,
        dense: true,
        checkboxShape: const CircleBorder(),
        side: const BorderSide(color: VeyraColors.checkboxBorder, width: 1.5),
        activeColor: accent,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: VeyraSpacing.s20,
          vertical: 2,
        ),
        title: Text(
          task.title,
          style: TextStyle(
            fontSize: 14,
            color: done ? VeyraColors.textTertiary : VeyraColors.textPrimary,
            decoration: done ? TextDecoration.lineThrough : null,
            fontWeight: done ? FontWeight.w400 : FontWeight.w500,
          ),
        ),
        subtitle: task.priority == TaskPriority.must
            ? const Text(
                '必做',
                style: TextStyle(
                  fontSize: 12,
                  color: VeyraColors.mustText,
                  fontWeight: FontWeight.w600,
                ),
              )
            : null,
        secondary: VeyraEffortBadge(effort: task.effort),
        onChanged: (checked) => onToggle(checked ?? false),
      ),
    );
  }
}

class _PlanData {
  _PlanData({
    required this.project,
    required this.phases,
    required this.milestones,
    required this.tasks,
  });

  final Project project;
  final List<Phase> phases;
  final List<Milestone> milestones;
  final List<Task> tasks;
}
