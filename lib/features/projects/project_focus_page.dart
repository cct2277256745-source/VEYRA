import 'package:flutter/material.dart';

import '../../app/app_scope.dart';
import '../../core/design/progress_path.dart';
import '../../core/design/tokens.dart';
import '../../core/design/veyra_app_bar.dart';
import '../../core/design/veyra_badge.dart';
import '../../core/design/veyra_checkbox.dart';
import '../../core/design/veyra_motion.dart';
import '../../core/domain/enums.dart';
import '../../core/domain/entities.dart';
import '../review/review_pages.dart';
import '../zen/zen_focus_page.dart';
import 'project_plan_page.dart';
import 'project_progress.dart';

class ProjectFocusPage extends StatefulWidget {
  const ProjectFocusPage({super.key, required this.projectId});

  final int projectId;

  @override
  State<ProjectFocusPage> createState() => _ProjectFocusPageState();
}

class _ProjectFocusPageState extends State<ProjectFocusPage>
    with AppServicesAccess {
  Future<_FocusData>? _future;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _future ??= _load();
  }

  Future<_FocusData> _load() async {
    final project = await services.projects.getProject(widget.projectId);
    final phases = await services.projects.phasesOfProject(widget.projectId);
    final tasks = await services.projects.tasksOfProject(widget.projectId);
    final milestones =
        await services.projects.milestonesOfProject(widget.projectId);
    return _FocusData(
      project: project!,
      phases: phases,
      tasks: tasks,
      milestones: milestones,
    );
  }

  void _reload() {
    setState(() {
      _future = _load();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: VeyraAppBar(
        title: const Text('项目焦点'),
        actions: [
          IconButton(
            tooltip: '项目复盘',
            icon: const Icon(Icons.insights_outlined, size: 20),
            onPressed: () => Navigator.of(context).push(VeyraPageRoute(
              builder: (_) => ProjectReviewPage(projectId: widget.projectId),
            )),
          ),
        ],
      ),
      body: FutureBuilder<_FocusData>(
        future: _future,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            );
          }
          return VeyraFadeSwitcher(
            duration: VeyraMotion.standard,
            child: _FocusBody(
              key: ValueKey(snapshot.data!.project.id),
              data: snapshot.data!,
              onReload: _reload,
              onCompleteTask: (id) {
                services.projects.completeTask(id);
                _reload();
              },
            ),
          );
        },
      ),
    );
  }
}

/// 响应式 Content Frame：
/// Small ≈760 / Standard ≈840 / Wide ≈920，达到 max-width 后停止增长。
double _contentWidth(double viewportWidth) {
  if (viewportWidth < 1200) return 760;
  if (viewportWidth < 1600) return 840;
  return 920;
}

class _FocusBody extends StatelessWidget {
  const _FocusBody({
    super.key,
    required this.data,
    required this.onReload,
    required this.onCompleteTask,
  });

  final _FocusData data;
  final VoidCallback onReload;
  final ValueChanged<int> onCompleteTask;

  @override
  Widget build(BuildContext context) {
    final accent = VeyraColors.fromArgb(data.project.themeColor);
    final open = data.openTasks;
    final next = ProjectsListFocusHelper.pickFocusTasks(open);
    final progress = ProjectProgress.ratio(data.tasks);
    final currentPhase = data.currentPhase;

    return SingleChildScrollView(
      child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: _contentWidth(MediaQuery.of(context).size.width),
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
              VeyraSpacing.s32,
              VeyraSpacing.s20,
              VeyraSpacing.s32,
              VeyraSpacing.s48,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // —— Project Hero：名字 + Outcome + 里程碑缎带 ——
                _ProjectHero(
                  title: data.project.title,
                  outcome: data.project.outcome,
                  executionMode: data.project.executionMode,
                  health: data.project.health,
                  progress: progress,
                  pathNodes: data.pathNodes,
                  accent: accent,
                  onOpenPlan: () async {
                    await Navigator.of(context).push(VeyraPageRoute(
                      builder: (_) =>
                          ProjectPlanPage(projectId: data.project.id),
                    ));
                    onReload();
                  },
                ),

                const SizedBox(height: VeyraSpacing.s32),

                // —— 当前阶段：真正的信息区 ——
                if (currentPhase != null) ...[
                  _CurrentPhaseCard(
                    accent: accent,
                    phaseTitle: currentPhase.title,
                    goal: currentPhase.goal,
                  ),
                  const SizedBox(height: VeyraSpacing.s32),
                ],

                // —— 接下来（1-3 个 Next Action，Things 3 风格圆环复选）——
                Row(
                  children: [
                    const Text(
                      '接下来',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                        letterSpacing: -0.3,
                        color: VeyraColors.textPrimary,
                      ),
                    ),
                    const SizedBox(width: VeyraSpacing.s8),
                    VeyraCountBadge(count: next.length),
                    const Spacer(),
                    if (next.isNotEmpty)
                      OutlinedButton.icon(
                        onPressed: () async {
                          await Navigator.of(context).push(
                            VeyraPageRoute(
                              builder: (_) => ZenFocusPage(
                                project: data.project,
                                phase: currentPhase,
                                initialTask: next.first,
                                remainingTasks: open.where((t) => t.id != next.first.id).toList(),
                              ),
                            ),
                          );
                          onReload();
                        },
                        icon: const Icon(Icons.self_improvement_rounded, size: 16),
                        label: const Text('进入禅意专注'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: accent,
                          side: BorderSide(color: accent.withValues(alpha: 0.35)),
                          padding: const EdgeInsets.symmetric(
                            horizontal: VeyraSpacing.s12,
                            vertical: VeyraSpacing.s8,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(VeyraRadius.full),
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: VeyraSpacing.s12),
                if (next.isEmpty)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      horizontal: VeyraSpacing.s24,
                      vertical: VeyraSpacing.s32,
                    ),
                    decoration: BoxDecoration(
                      color: VeyraColors.surface,
                      borderRadius: BorderRadius.circular(VeyraRadius.large),
                      border: Border.all(color: VeyraColors.border),
                    ),
                    child: const Center(
                      child: Text(
                        '当前没有待办。打开完整规划，看看下一段路径。',
                        style: TextStyle(
                          fontSize: 14,
                          color: VeyraColors.textSecondary,
                        ),
                      ),
                    ),
                  )
                else
                  Container(
                    decoration: BoxDecoration(
                      color: VeyraColors.surface,
                      borderRadius: BorderRadius.circular(VeyraRadius.large),
                      border: Border.all(color: VeyraColors.border),
                      boxShadow: VeyraShadows.subtle,
                    ),
                    child: Column(
                      children: [
                        for (var i = 0; i < next.length; i++) ...[
                          if (i > 0)
                            const Divider(
                              height: 1,
                              color: VeyraColors.border,
                            ),
                          _NextActionRow(
                            task: next[i],
                            accent: accent,
                            onCompleted: () => onCompleteTask(next[i].id),
                            onStartFocus: () async {
                              await Navigator.of(context).push(
                                VeyraPageRoute(
                                  builder: (_) => ZenFocusPage(
                                    project: data.project,
                                    phase: currentPhase,
                                    initialTask: next[i],
                                    remainingTasks: open.where((t) => t.id != next[i].id).toList(),
                                  ),
                                ),
                              );
                              onReload();
                            },
                          ),
                        ],
                      ],
                    ),
                  ),

                // —— 里程碑进度（Next Milestones）——
                if (data.milestones.isNotEmpty) ...[
                  const SizedBox(height: VeyraSpacing.s32),
                  Row(
                    children: [
                      const Text(
                        '里程碑',
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                          letterSpacing: -0.3,
                          color: VeyraColors.textPrimary,
                        ),
                      ),
                      const SizedBox(width: VeyraSpacing.s8),
                      VeyraCountBadge(count: data.milestones.length),
                    ],
                  ),
                  const SizedBox(height: VeyraSpacing.s12),
                  Wrap(
                    spacing: VeyraSpacing.s12,
                    runSpacing: VeyraSpacing.s12,
                    children: [
                      for (final m in data.milestones)
                        Container(
                          constraints: const BoxConstraints(minWidth: 160),
                          padding: const EdgeInsets.symmetric(
                            horizontal: VeyraSpacing.s16,
                            vertical: VeyraSpacing.s12,
                          ),
                          decoration: BoxDecoration(
                            color: VeyraColors.surface,
                            borderRadius:
                                BorderRadius.circular(VeyraRadius.medium),
                            border: Border.all(color: VeyraColors.border),
                            boxShadow: VeyraShadows.subtle,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                m.title,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: VeyraColors.textPrimary,
                                ),
                              ),
                              const SizedBox(height: VeyraSpacing.s6),
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    m.isCompleted
                                        ? Icons.check_circle_outline_rounded
                                        : Icons.outlined_flag_rounded,
                                    size: 13,
                                    color: m.isCompleted
                                        ? VeyraColors.success
                                        : accent,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    m.isCompleted ? '已达成' : '进行中',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                      color: m.isCompleted
                                          ? VeyraColors.success
                                          : VeyraColors.textSecondary,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Project Hero：整合标题、预期成果、执行模式与全横贯里程碑缎带。
class _ProjectHero extends StatelessWidget {
  const _ProjectHero({
    required this.title,
    required this.outcome,
    required this.executionMode,
    required this.health,
    required this.progress,
    required this.pathNodes,
    required this.accent,
    required this.onOpenPlan,
  });

  final String title;
  final String outcome;
  final ExecutionMode executionMode;
  final PlanHealth health;
  final double progress;
  final List<ProgressPathNode> pathNodes;
  final Color accent;
  final VoidCallback onOpenPlan;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(VeyraSpacing.s24),
      decoration: BoxDecoration(
        color: VeyraColors.surface,
        borderRadius: BorderRadius.circular(VeyraRadius.large),
        border: Border.all(color: VeyraColors.border),
        boxShadow: VeyraShadows.subtle,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 顶部标题与快速入口
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: const EdgeInsets.only(top: 8),
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  color: accent,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: VeyraSpacing.s12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 26,
                        height: 32 / 26,
                        fontWeight: FontWeight.w700,
                        color: VeyraColors.textPrimary,
                        letterSpacing: -0.6,
                      ),
                    ),
                    if (outcome.isNotEmpty) ...[
                      const SizedBox(height: VeyraSpacing.s6),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(
                            Icons.track_changes_rounded,
                            size: 15,
                            color: VeyraColors.textTertiary,
                          ),
                          const SizedBox(width: VeyraSpacing.s6),
                          Expanded(
                            child: Text(
                              outcome,
                              style: const TextStyle(
                                fontSize: 14,
                                height: 20 / 14,
                                color: VeyraColors.textSecondary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(width: VeyraSpacing.s16),
              // 微操作胶囊
              TextButton.icon(
                onPressed: onOpenPlan,
                icon: const Icon(Icons.east_rounded, size: 14),
                label: const Text('查看完整规划'),
                style: TextButton.styleFrom(
                  foregroundColor: VeyraColors.textSecondary,
                  padding: const EdgeInsets.symmetric(
                    horizontal: VeyraSpacing.s12,
                    vertical: VeyraSpacing.s8,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: VeyraSpacing.s16),

          // 状态标签排
          Wrap(
            spacing: VeyraSpacing.s8,
            runSpacing: VeyraSpacing.s6,
            children: [
              VeyraTagBadge(
                label: executionMode == ExecutionMode.weeklyPlanning
                    ? '每周推进'
                    : '独立项目',
                icon: Icons.calendar_month_outlined,
              ),
              if (health == PlanHealth.atRisk)
                const VeyraTagBadge(
                  label: '延期风险',
                  color: VeyraColors.warning,
                  background: VeyraColors.warningBg,
                  icon: Icons.error_outline_rounded,
                )
              else if (health == PlanHealth.needsAttention)
                const VeyraTagBadge(
                  label: '需关注',
                  color: VeyraColors.warning,
                  background: VeyraColors.warningBg,
                )
              else
                const VeyraTagBadge(
                  label: '正常推进',
                  color: VeyraColors.success,
                  background: VeyraColors.successBg,
                  icon: Icons.check_circle_outline_rounded,
                ),
            ],
          ),

          if (pathNodes.isNotEmpty) ...[
            const SizedBox(height: VeyraSpacing.s24),
            Container(
              height: 1,
              color: VeyraColors.border.withValues(alpha: 0.6),
            ),
            const SizedBox(height: VeyraSpacing.s20),
            Center(child: ProgressPath(nodes: pathNodes, accent: accent)),
            const SizedBox(height: VeyraSpacing.s16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '整体进度 ${(progress * 100).round()}%',
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: VeyraColors.textSecondary,
                  ),
                ),
                Text(
                  '共 ${pathNodes.length} 个里程碑节点',
                  style: const TextStyle(
                    fontSize: 12,
                    color: VeyraColors.textTertiary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: VeyraSpacing.s6),
            ClipRRect(
              borderRadius: BorderRadius.circular(VeyraRadius.full),
              child: LinearProgressIndicator(
                value: progress,
                minHeight: 4,
                backgroundColor: VeyraColors.border.withValues(alpha: 0.8),
                valueColor: AlwaysStoppedAnimation<Color>(accent),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// 当前阶段信息区：线性精致卡片，带有当前状态徽标与阶段目标。
class _CurrentPhaseCard extends StatelessWidget {
  const _CurrentPhaseCard({
    required this.accent,
    required this.phaseTitle,
    this.goal,
  });

  final Color accent;
  final String phaseTitle;
  final String? goal;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(VeyraSpacing.s20),
      decoration: BoxDecoration(
        color: VeyraColors.surface,
        borderRadius: BorderRadius.circular(VeyraRadius.large),
        border: Border.all(color: VeyraColors.border),
        boxShadow: VeyraShadows.subtle,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              VeyraTagBadge(
                label: '当前进行',
                color: accent,
                background: accent.withValues(alpha: 0.12),
              ),
              const SizedBox(width: VeyraSpacing.s10),
              Expanded(
                child: Text(
                  phaseTitle,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                    letterSpacing: -0.3,
                    color: VeyraColors.textPrimary,
                  ),
                ),
              ),
            ],
          ),
          if (goal != null && goal!.isNotEmpty) ...[
            const SizedBox(height: VeyraSpacing.s8),
            Text(
              goal!,
              style: const TextStyle(
                fontSize: 14,
                height: 20 / 14,
                color: VeyraColors.textSecondary,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// Next Action 行：使用 Things 3 风格圆环复选框 + Linear 风格微标签。
class _NextActionRow extends StatefulWidget {
  const _NextActionRow({
    required this.task,
    required this.accent,
    required this.onCompleted,
    this.onStartFocus,
  });

  final Task task;
  final Color accent;
  final VoidCallback onCompleted;
  final VoidCallback? onStartFocus;

  @override
  State<_NextActionRow> createState() => _NextActionRowState();
}

class _NextActionRowState extends State<_NextActionRow> {
  bool _hovering = false;
  bool _completing = false;

  void _handleComplete() async {
    if (_completing) return;
    setState(() => _completing = true);
    await Future.delayed(const Duration(milliseconds: 140));
    if (mounted) {
      widget.onCompleted();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovering = true),
      onExit: (_) => setState(() => _hovering = false),
      child: AnimatedContainer(
        duration: VeyraMotion.fast,
        curve: VeyraMotion.curve,
        color: _hovering ? VeyraColors.hoverOverlay : Colors.transparent,
        padding: const EdgeInsets.symmetric(
          horizontal: VeyraSpacing.s20,
          vertical: VeyraSpacing.s14,
        ),
        child: Row(
          children: [
            // Things 3 风格圆环复选框
            VeyraCheckbox(
              checked: _completing,
              accentColor: widget.accent,
              onToggle: _handleComplete,
            ),
            const SizedBox(width: VeyraSpacing.s14),
            // 任务标题
            Expanded(
              child: AnimatedDefaultTextStyle(
                duration: VeyraMotion.fast,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: _completing
                      ? VeyraColors.textTertiary
                      : VeyraColors.textPrimary,
                  decoration: _completing ? TextDecoration.lineThrough : null,
                ),
                child: Text(widget.task.title),
              ),
            ),
            if (_hovering && widget.onStartFocus != null) ...[
              IconButton(
                icon: const Icon(Icons.self_improvement_rounded, size: 18),
                tooltip: '禅意专注',
                style: IconButton.styleFrom(
                  foregroundColor: widget.accent,
                  padding: const EdgeInsets.all(4),
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                onPressed: widget.onStartFocus,
              ),
              const SizedBox(width: VeyraSpacing.s8),
            ],
            const SizedBox(width: VeyraSpacing.s4),
            // 标签徽标
            VeyraPriorityBadge(priority: widget.task.priority),
            const SizedBox(width: VeyraSpacing.s6),
            VeyraEffortBadge(effort: widget.task.effort),
          ],
        ),
      ),
    );
  }
}

class _FocusData {
  _FocusData({
    required this.project,
    required this.phases,
    required this.tasks,
    required this.milestones,
  });

  final Project project;
  final List<Phase> phases;
  final List<Task> tasks;
  final List<Milestone> milestones;

  Iterable<Task> get openTasks =>
      tasks.where((t) => !t.isDone && t.status != TaskStatus.skipped);

  /// 当前阶段与 Progress Path 统一走共享计算（project_progress.dart）。
  Phase? get currentPhase =>
      ProjectProgress.currentPhase(phases, tasks);

  List<ProgressPathNode> get pathNodes =>
      ProjectProgress.pathNodes(phases, tasks);
}

/// Focus / 列表共用的「下一步」挑选规则。
class ProjectsListFocusHelper {
  static List<Task> pickFocusTasks(Iterable<Task> open, {int limit = 3}) {
    final list = open.toList()
      ..sort((a, b) {
        if (a.priority != b.priority) {
          return a.priority == TaskPriority.must ? -1 : 1;
        }
        final ad = a.dueDate, bd = b.dueDate;
        if (ad == null && bd == null) return 0;
        if (ad == null) return 1;
        if (bd == null) return -1;
        return ad.compareTo(bd);
      });
    return list.take(limit).toList();
  }
}
