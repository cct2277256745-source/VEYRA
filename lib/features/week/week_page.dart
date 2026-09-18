/// Week 页（UI Specification §17）：本周重点目标，不是任务垃圾场。
/// 默认 2–5 个目标、支持任务折叠、容量轻量；无日历格、无小时时间轴。
library;

import 'package:flutter/material.dart';

import '../../app/app_scope.dart';
import '../../ai/ai_provider.dart';
import '../../ai/ai_unconfigured.dart';
import '../settings/settings_page.dart';
import '../../ai/replanner_service.dart';
import '../../app/page_scaffold.dart';
import '../../core/design/tokens.dart';
import '../../core/design/veyra_badge.dart';
import '../../core/design/veyra_checkbox.dart';
import '../../core/design/veyra_motion.dart';
import '../../core/domain/enums.dart';
import '../../core/domain/entities.dart';
import '../replanning/rebalance_preview_page.dart';
import '../review/review_pages.dart';
import '../zen/zen_focus_page.dart';
import 'week_view_model.dart';

class WeekPage extends StatefulWidget {
  const WeekPage({super.key});

  @override
  State<WeekPage> createState() => _WeekPageState();
}

class _WeekPageState extends State<WeekPage> with AppServicesAccess {
  WeekViewModel? _viewModel;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _viewModel ??= WeekViewModel(services)..refresh();
  }

  @override
  void dispose() {
    _viewModel?.dispose();
    super.dispose();
  }

  Future<void> _addTask() async {
    final candidates = await _viewModel!.availableTasks();
    if (!mounted) return;
    if (candidates.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('还没有可加入本周的任务。只有加入周规划的项目任务会出现在这里。')));
      return;
    }
    final selected = await showVeyraDialog<int>(
      context: context,
      builder: (context) => SimpleDialog(
        title: const Text('把哪个任务加入本周？'),
        children: [
          for (final (task, project) in candidates)
            SimpleDialogOption(
              onPressed: () => Navigator.of(context).pop(task.id),
              child: Text('${project.title} · ${task.title}'),
            ),
        ],
      ),
    );
    if (selected != null) {
      await _viewModel!.addTaskToWeek(selected);
    }
  }

  Future<void> _rebalance() async {
    final messenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);
    final aiFactory = AIScope.of(context);
    final situation = await _askSituation();
    if (situation == null || situation.trim().isEmpty) return;
    final aiProvider = await aiFactory.createOrNull();
    if (aiProvider == null) {
      messenger.showSnackBar(SnackBar(
        duration: const Duration(seconds: 5),
        content: const Text('$aiNotConfiguredTitle$aiNotConfiguredBody'),
        action: SnackBarAction(label: '配置 AI', onPressed: _openSettingsPage),
      ));
      return;
    }
    if (!mounted) return;
    final service = ReplannerService(services: services, provider: aiProvider);
    showVeyraDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (_) => const AlertDialog(
        content: Row(
          children: [
            SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
            SizedBox(width: 16),
            Expanded(child: Text('正在智能分析本周任务并生成调整建议...')),
          ],
        ),
      ),
    );
    try {
      final proposal = await service.proposeChanges(situation: situation.trim());
      if (!mounted) return;
      navigator.pop();
      final applied = await navigator.push(VeyraPageRoute(
        builder: (_) => RebalancePreviewPage(proposalId: proposal.id),
      ));
      if (applied == true) {
        await _viewModel!.refresh();
      }
    } on AIException catch (e) {
      if (mounted) navigator.pop();
      messenger.showSnackBar(SnackBar(content: Text('$e')));
    } catch (e) {
      if (mounted) navigator.pop();
      messenger.showSnackBar(SnackBar(content: Text('生成调整建议失败: $e')));
    }
  }

  void _openSettingsPage() {
    Navigator.of(context, rootNavigator: true).push(
      VeyraPageRoute(builder: (_) => const SettingsPage()),
    );
  }

  Future<String?> _askSituation() {
    final controller = TextEditingController();
    return showVeyraDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('发生了什么变化？'),
        content: TextField(
          controller: controller,
          autofocus: true,
          maxLines: 3,
          decoration: const InputDecoration(
            labelText: '例如：周五突然有一个面试；这周雅思做不完',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('取消'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(controller.text.trim()),
            child: const Text('生成调整建议'),
          ),
        ],
      ),
    );
  }

  String _dateRange() {
    final start = _viewModel!.currentWeekStart;
    final end = start.add(const Duration(days: 6));
    String fmt(DateTime d) => '${d.month} 月 ${d.day} 日';
    return '${fmt(start)} — ${fmt(end)}';
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = _viewModel!;
    return PageScaffold(
      title: '本周',
      subtitle: _dateRange(),
      actions: [
        OutlinedButton.icon(
          onPressed: _addTask,
          icon: const Icon(Icons.add_task_rounded, size: 16),
          label: const Text('加入任务'),
          style: OutlinedButton.styleFrom(
            foregroundColor: VeyraColors.textPrimary,
            side: const BorderSide(color: VeyraColors.border),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(VeyraRadius.medium),
            ),
          ),
        ),
        const SizedBox(width: VeyraSpacing.s8),
        OutlinedButton.icon(
          onPressed: _rebalance,
          icon: const Icon(Icons.balance_rounded, size: 16),
          label: const Text('重新平衡'),
          style: OutlinedButton.styleFrom(
            foregroundColor: VeyraColors.textPrimary,
            side: const BorderSide(color: VeyraColors.border),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(VeyraRadius.medium),
            ),
          ),
        ),
        const SizedBox(width: VeyraSpacing.s8),
        IconButton(
          tooltip: '本周复盘',
          icon: const Icon(Icons.insights_outlined, size: 20),
          onPressed: () => Navigator.of(context).push(VeyraPageRoute(
            builder: (_) => const WeekReviewPage(),
          )),
        ),
      ],
      body: AnimatedBuilder(
        animation: viewModel,
        builder: (context, _) {
          return SingleChildScrollView(
            child: Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: _weekWidth(MediaQuery.of(context).size.width),
                ),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(
                    VeyraSpacing.s32,
                    VeyraSpacing.s16,
                    VeyraSpacing.s32,
                    VeyraSpacing.s48,
                  ),
                  child: Column(
                    children: [
                      // —— 容量与状态栏：Sunsama 风格与多巴胺状态融合 ——
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                          horizontal: VeyraSpacing.s16,
                          vertical: VeyraSpacing.s10,
                        ),
                        decoration: BoxDecoration(
                          color: VeyraColors.surface,
                          borderRadius:
                              BorderRadius.circular(VeyraRadius.large),
                          border: Border.all(color: VeyraColors.border),
                          boxShadow: VeyraShadows.subtle,
                        ),
                        child: Wrap(
                          alignment: WrapAlignment.spaceBetween,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          spacing: VeyraSpacing.s12,
                          runSpacing: VeyraSpacing.s8,
                          children: [
                            _CapacitySegmentedBar(
                              current: viewModel.capacity,
                              onChanged: viewModel.setCapacity,
                            ),
                            if (viewModel.groups.isNotEmpty)
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    width: 6,
                                    height: 6,
                                    decoration: const BoxDecoration(
                                      color: VeyraColors.dopamineMint,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                  const SizedBox(width: VeyraSpacing.s6),
                                  Text(
                                    '推进 ${viewModel.groups.length} 个重点项目 · ${viewModel.groups.fold<int>(0, (sum, g) => sum + g.tasks.where((t) => !t.isDone).length)} 项任务',
                                    style: const TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w500,
                                      color: VeyraColors.textSecondary,
                                    ),
                                  ),
                                ],
                              ),
                          ],
                        ),
                      ),

                      const SizedBox(height: VeyraSpacing.s24),

                      if (viewModel.groups.isEmpty)
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(
                            horizontal: VeyraSpacing.s32,
                            vertical: VeyraSpacing.s48,
                          ),
                          decoration: BoxDecoration(
                            color: VeyraColors.surface,
                            borderRadius:
                                BorderRadius.circular(VeyraRadius.large),
                            border: Border.all(color: VeyraColors.border),
                          ),
                          child: const Center(
                            child: Column(
                              children: [
                                Text(
                                  '本周还没有需要你处理的事。',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: VeyraColors.textPrimary,
                                  ),
                                ),
                                SizedBox(height: VeyraSpacing.s8),
                                Text(
                                  '加入周规划的项目会出现在这里。',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: VeyraColors.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      else ...[
                        for (var i = 0; i < viewModel.groups.length; i++)
                          _GoalCard(
                            index: i,
                            group: viewModel.groups[i],
                            viewModel: viewModel,
                          ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

/// 响应式内容宽度（与 Focus/Projects 同族）。
double _weekWidth(double viewportWidth) {
  if (viewportWidth < 1200) return 760;
  if (viewportWidth < 1600) return 840;
  return 920;
}

/// Sunsama 风格轻质分段容量条（多巴胺色彩状态）
class _CapacitySegmentedBar extends StatelessWidget {
  const _CapacitySegmentedBar({
    required this.current,
    required this.onChanged,
  });

  final CapacityLevel current;
  final ValueChanged<CapacityLevel> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: VeyraColors.backgroundAlt,
        borderRadius: BorderRadius.circular(VeyraRadius.medium),
        border: Border.all(color: VeyraColors.border),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: VeyraSpacing.s8),
            child: Text(
              '容量',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: VeyraColors.textTertiary,
              ),
            ),
          ),
          for (final level in CapacityLevel.values)
            _CapacitySegment(
              level: level,
              label: switch (level) {
                CapacityLevel.relaxed => '轻松',
                CapacityLevel.normal => '正常',
                CapacityLevel.busy => '忙碌',
                CapacityLevel.survival => '生存模式',
              },
              selected: current == level,
              onTap: () => onChanged(level),
            ),
        ],
      ),
    );
  }
}

class _CapacitySegment extends StatelessWidget {
  const _CapacitySegment({
    required this.level,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final CapacityLevel level;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final dotColor = switch (level) {
      CapacityLevel.relaxed => VeyraColors.dopamineMint,
      CapacityLevel.normal => VeyraColors.dopamineIris,
      CapacityLevel.busy => VeyraColors.dopamineCoral,
      CapacityLevel.survival => VeyraColors.dopamineBerry,
    };

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: VeyraMotion.fast,
          curve: VeyraMotion.curve,
          padding: const EdgeInsets.symmetric(
            horizontal: VeyraSpacing.s10,
            vertical: 4,
          ),
          decoration: BoxDecoration(
            color: selected ? VeyraColors.surface : Colors.transparent,
            borderRadius: BorderRadius.circular(VeyraRadius.small),
            border: selected ? Border.all(color: VeyraColors.border) : null,
            boxShadow: selected ? VeyraShadows.subtle : null,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (selected) ...[
                Container(
                  width: 6,
                  height: 6,
                  decoration: BoxDecoration(
                    color: dotColor,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: VeyraSpacing.s6),
              ],
              Text(
                label,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
                  color: selected
                      ? VeyraColors.textPrimary
                      : VeyraColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// 目标卡（spec §17）：项目标题栏 + Things 3 风格圆环任务行。
class _GoalCard extends StatelessWidget {
  const _GoalCard({
    required this.index,
    required this.group,
    required this.viewModel,
  });

  final int index;
  final WeekGoalGroup group;
  final WeekViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    final accent = VeyraColors.fromArgb(group.project.themeColor);
    final openTasks = group.tasks.where((t) => !t.isDone).length;

    return Container(
      margin: const EdgeInsets.only(bottom: VeyraSpacing.s16),
      decoration: BoxDecoration(
        color: VeyraColors.surface,
        borderRadius: BorderRadius.circular(VeyraRadius.large),
        border: Border.all(color: VeyraColors.border),
        boxShadow: VeyraShadows.subtle,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 项目标题栏
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: VeyraSpacing.s20,
              vertical: VeyraSpacing.s14,
            ),
            child: Row(
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: accent,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: VeyraSpacing.s10),
                Expanded(
                  child: Text(
                    group.project.title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: VeyraColors.textPrimary,
                    ),
                  ),
                ),
                if (group.allDone)
                  const VeyraTagBadge(
                    label: '本周已完成',
                    color: VeyraColors.success,
                    background: VeyraColors.successBg,
                    icon: Icons.check_circle_outline_rounded,
                  )
                else
                  VeyraCountBadge(count: openTasks),
              ],
            ),
          ),
          const Divider(height: 1, color: VeyraColors.border),
          // 任务行
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: VeyraSpacing.s12,
              vertical: VeyraSpacing.s4,
            ),
            child: Column(
              children: [
                for (var j = 0; j < group.tasks.length; j++) ...[
                  if (j > 0)
                    const Divider(
                      height: 1,
                      color: VeyraColors.borderSubtle,
                    ),
                  _WeekTaskRow(
                    task: group.tasks[j],
                    accent: accent,
                    onComplete: () => viewModel.completeTask(group.tasks[j].id),
                    onRemove: () => viewModel.removeAssignment(
                      group.assignments
                          .firstWhere((a) => a.taskId == group.tasks[j].id)
                          .id,
                    ),
                    onStartFocus: () async {
                      await Navigator.of(context).push(
                        VeyraPageRoute(
                          builder: (_) => ZenFocusPage(
                            project: group.project,
                            initialTask: group.tasks[j],
                            remainingTasks: group.tasks
                                .where((t) => !t.isDone && t.id != group.tasks[j].id)
                                .toList(),
                          ),
                        ),
                      );
                      await viewModel.refresh();
                    },
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _WeekTaskRow extends StatefulWidget {
  const _WeekTaskRow({
    required this.task,
    required this.accent,
    required this.onComplete,
    required this.onRemove,
    this.onStartFocus,
  });

  final Task task;
  final Color accent;
  final VoidCallback onComplete;
  final VoidCallback onRemove;
  final VoidCallback? onStartFocus;

  @override
  State<_WeekTaskRow> createState() => _WeekTaskRowState();
}

class _WeekTaskRowState extends State<_WeekTaskRow> {
  bool _hovering = false;
  bool _completing = false;

  void _toggle() async {
    if (_completing) return;
    setState(() => _completing = true);
    await Future.delayed(const Duration(milliseconds: 140));
    if (mounted) {
      widget.onComplete();
      setState(() => _completing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final done = widget.task.isDone || _completing;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovering = true),
      onExit: (_) => setState(() => _hovering = false),
      child: AnimatedContainer(
        duration: VeyraMotion.fast,
        curve: VeyraMotion.curve,
        margin: const EdgeInsets.symmetric(vertical: 2),
        padding: const EdgeInsets.symmetric(
          horizontal: VeyraSpacing.s12,
          vertical: VeyraSpacing.s10,
        ),
        decoration: BoxDecoration(
          color: _hovering ? VeyraColors.hoverOverlay : Colors.transparent,
          borderRadius: BorderRadius.circular(VeyraRadius.medium),
        ),
        child: Row(
          children: [
            // Things 3 风格统一圆环复选框
            VeyraCheckbox(
              checked: done,
              accentColor: widget.accent,
              onToggle: _toggle,
            ),
            const SizedBox(width: VeyraSpacing.s12),
            Expanded(
              child: AnimatedDefaultTextStyle(
                duration: VeyraMotion.fast,
                style: TextStyle(
                  fontSize: 14,
                  color: done
                      ? VeyraColors.textTertiary
                      : VeyraColors.textPrimary,
                  decoration: done ? TextDecoration.lineThrough : null,
                  fontWeight: done ? FontWeight.w400 : FontWeight.w500,
                ),
                child: Text(widget.task.title),
              ),
            ),
            if (widget.task.priority == TaskPriority.must)
              Container(
                margin: const EdgeInsets.only(right: VeyraSpacing.s8),
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: VeyraColors.mustBadgeBg,
                  borderRadius: BorderRadius.circular(VeyraRadius.small),
                ),
                child: const Text(
                  '必做',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: VeyraColors.mustBadgeText,
                  ),
                ),
              ),
            if (_hovering && widget.onStartFocus != null && !done)
              IconButton(
                tooltip: '禅意专注',
                icon: Icon(
                  Icons.self_improvement_rounded,
                  size: 18,
                  color: widget.accent,
                ),
                onPressed: widget.onStartFocus,
              ),
            IconButton(
              tooltip: '移出本周',
              icon: const Icon(
                Icons.link_off_rounded,
                size: 18,
                color: VeyraColors.textTertiary,
              ),
              onPressed: widget.onRemove,
            ),
          ],
        ),
      ),
    );
  }
}
