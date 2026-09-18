/// 计划草案预览页（Slice 2.5）：展示 AI Proposal，确认才落库，取消只改提案状态。
library;

import 'dart:convert';

import 'package:flutter/material.dart';

import '../../ai/plan_application_service.dart';
import '../../ai/plan_models.dart';
import '../../app/app_scope.dart';
import '../../core/design/tokens.dart';
import '../../core/design/veyra_app_bar.dart';

class PlanPreviewPage extends StatefulWidget {
  const PlanPreviewPage({super.key, required this.proposalId});

  final int proposalId;

  @override
  State<PlanPreviewPage> createState() => _PlanPreviewPageState();
}

enum _PlanApplyState { idle, applying, applied }

class _PlanPreviewPageState extends State<PlanPreviewPage>
    with AppServicesAccess {
  PlanApplicationService? _planService;
  Future<PlanDraft>? _draft;
  PlanDraft? _loadedDraft;
  final Set<String> _unselectedTaskKeys = <String>{};
  final Map<String, PlanTaskPriority> _overriddenPriorities = {};
  _PlanApplyState _applyState = _PlanApplyState.idle;

  String _taskKey(String phaseTitle, String taskTitle) => '$phaseTitle::$taskTitle';

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _draft ??= _initAndLoad();
  }

  Future<PlanDraft> _initAndLoad() async {
    final provider = await AIScope.of(context).createOrNull();
    final planService = PlanApplicationService(
      services: services,
      provider: provider,
    );
    _planService = planService;
    final proposal = (await services.proposals.get(widget.proposalId))!;
    final draft = PlanDraft.fromJson(
        jsonDecode(proposal.payloadJson) as Map<String, dynamic>);
    _loadedDraft = draft;
    return draft;
  }

  Future<void> _confirm() async {
    if (_applyState != _PlanApplyState.idle || _loadedDraft == null) return;
    setState(() => _applyState = _PlanApplyState.applying);
    try {
      final filteredPhases = _loadedDraft!.phases.map((phase) {
        final remainingTasks = phase.tasks
            .where((task) =>
                !_unselectedTaskKeys.contains(_taskKey(phase.title, task.title)))
            .map((task) {
              final prio =
                  _overriddenPriorities[_taskKey(phase.title, task.title)];
              return prio != null ? task.copyWith(priority: prio) : task;
            })
            .toList();
        return phase.copyWith(tasks: remainingTasks);
      }).toList();

      final finalDraft = _loadedDraft!.copyWith(phases: filteredPhases);
      final project = await _planService!.confirmProposal(
        widget.proposalId,
        customDraft: finalDraft,
      );
      if (!mounted) return;
      setState(() => _applyState = _PlanApplyState.applied);
      await Future.delayed(const Duration(milliseconds: 320));
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('已创建项目：${project.title}')),
      );
      Navigator.of(context).pop(project);
    } catch (e) {
      if (mounted) setState(() => _applyState = _PlanApplyState.idle);
      rethrow;
    }
  }

  Future<void> _cancel() async {
    if (_applyState != _PlanApplyState.idle) return;
    await _planService!.rejectProposal(widget.proposalId);
    if (mounted) Navigator.of(context).pop(null);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const VeyraAppBar(title: Text('确认规划草案')),
      body: FutureBuilder<PlanDraft>(
        future: _draft,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final draft = snapshot.data!;
          _loadedDraft ??= draft;

          final totalTasks = draft.phases.fold<int>(0, (n, p) => n + p.tasks.length);
          final selectedTasks = totalTasks - _unselectedTaskKeys.length;

          return ListView(
            padding: const EdgeInsets.all(24),
            children: [
              Text(draft.title, style: Theme.of(context).textTheme.headlineSmall),
              const SizedBox(height: 8),
              Text('最终目标：${draft.outcome}',
                  style: const TextStyle(fontSize: 14, color: VeyraColors.textSecondary)),
              Text(draft.suggestedMode == SuggestedExecutionMode.weeklyPlanning
                  ? '建议：加入周规划'
                  : '建议：仅项目内执行',
                  style: const TextStyle(fontSize: 13, color: VeyraColors.textTertiary)),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  color: VeyraColors.selectedSurface(VeyraColors.accentDustyBlue),
                  borderRadius: BorderRadius.circular(VeyraRadius.medium),
                  border: Border.all(
                      color: VeyraColors.accentDustyBlue.withValues(alpha: 0.25)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.checklist_rounded,
                        size: 18, color: VeyraColors.accentDustyBlue),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        '已选 $selectedTasks / $totalTasks 项任务 · 点击复选框剔除或切换优先级',
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: VeyraColors.textPrimary,
                        ),
                      ),
                    ),
                    if (_unselectedTaskKeys.isNotEmpty)
                      TextButton(
                        onPressed: () => setState(() => _unselectedTaskKeys.clear()),
                        child: const Text('全部恢复', style: TextStyle(fontSize: 12)),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              for (final phase in draft.phases) ...[
                Text('阶段 · ${phase.title}',
                    style: Theme.of(context).textTheme.titleMedium),
                if (phase.goal != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 2, bottom: 4),
                    child: Text('目标：${phase.goal}',
                        style: const TextStyle(fontSize: 13, color: VeyraColors.textSecondary)),
                  ),
                for (final milestone in phase.milestones)
                  ListTile(
                    dense: true,
                    leading: const Icon(Icons.emoji_events_outlined, size: 18),
                    title: Text(milestone),
                  ),
                for (final task in phase.tasks) ...[
                  () {
                    final key = _taskKey(phase.title, task.title);
                    final isSelected = !_unselectedTaskKeys.contains(key);
                    final prio = _overriddenPriorities[key] ?? task.priority;
                    return ListTile(
                      dense: true,
                      leading: SizedBox(
                        width: 24,
                        height: 24,
                        child: Checkbox(
                          value: isSelected,
                          onChanged: (val) {
                            setState(() {
                              if (val == true) {
                                _unselectedTaskKeys.remove(key);
                              } else {
                                _unselectedTaskKeys.add(key);
                              }
                            });
                          },
                        ),
                      ),
                      title: Text(
                        task.title,
                        style: TextStyle(
                          fontSize: 14,
                          decoration: isSelected ? null : TextDecoration.lineThrough,
                          color: isSelected
                              ? VeyraColors.textPrimary
                              : VeyraColors.textTertiary,
                        ),
                      ),
                      subtitle: task.sourceQuote == null
                          ? null
                          : Text('来源：${task.sourceQuote}'),
                      trailing: InkWell(
                        borderRadius: BorderRadius.circular(4),
                        onTap: () {
                          setState(() {
                            _overriddenPriorities[key] =
                                prio == PlanTaskPriority.must
                                    ? PlanTaskPriority.optional
                                    : PlanTaskPriority.must;
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: prio == PlanTaskPriority.must
                                ? VeyraColors.primaryButton.withValues(alpha: 0.12)
                                : VeyraColors.backgroundAlt,
                            borderRadius: BorderRadius.circular(4),
                            border: Border.all(
                              color: prio == PlanTaskPriority.must
                                  ? VeyraColors.primaryButton.withValues(alpha: 0.3)
                                  : VeyraColors.border,
                            ),
                          ),
                          child: Text(
                            prio == PlanTaskPriority.must ? '必做' : '可选',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: prio == PlanTaskPriority.must
                                  ? VeyraColors.primaryButton
                                  : VeyraColors.textTertiary,
                            ),
                          ),
                        ),
                      ),
                    );
                  }(),
                ],
              ],
            ],
          );
        },
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        decoration: const BoxDecoration(
          color: VeyraColors.surface,
          border: Border(top: BorderSide(color: VeyraColors.border)),
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: _applyState == _PlanApplyState.idle ? _cancel : null,
                      child: const Text('取消，不采用'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: FilledButton(
                      onPressed: _applyState == _PlanApplyState.idle ? _confirm : null,
                      style: FilledButton.styleFrom(
                        backgroundColor: _applyState == _PlanApplyState.applied
                            ? VeyraColors.success
                            : VeyraColors.primaryButton,
                      ),
                      child: AnimatedSwitcher(
                        duration: VeyraMotion.fast,
                        child: switch (_applyState) {
                          _PlanApplyState.idle => const Text(
                              '确认，创建项目',
                              key: ValueKey('idle'),
                            ),
                          _PlanApplyState.applying => const Row(
                              key: ValueKey('applying'),
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                SizedBox(
                                  width: 14,
                                  height: 14,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                ),
                                SizedBox(width: 8),
                                Text('正在创建...'),
                              ],
                            ),
                          _PlanApplyState.applied => const Row(
                              key: ValueKey('applied'),
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.check, size: 16, color: Colors.white),
                                SizedBox(width: 6),
                                Text('已创建'),
                              ],
                            ),
                        },
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              const Text(
                '确认之前不会改动你的任何数据；也可以先取消，随时再让 AI 重新生成。',
                style: TextStyle(fontSize: 12, color: VeyraColors.textTertiary),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
