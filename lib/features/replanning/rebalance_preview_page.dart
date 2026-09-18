/// 重规划预览页（Slice 2.7，PRD §15 Rebalance Preview）：
/// 只展示受影响的调整项；支持 全部应用 / 选择性应用 / 取消。
library;

import 'dart:convert';

import 'package:flutter/material.dart';

import '../../ai/ai_provider.dart';
import '../../ai/plan_models.dart';
import '../../ai/replanner_service.dart';
import '../../core/design/tokens.dart';
import '../../core/design/veyra_app_bar.dart';
import '../../app/app_scope.dart';

class RebalancePreviewPage extends StatefulWidget {
  const RebalancePreviewPage({super.key, required this.proposalId});

  final int proposalId;

  @override
  State<RebalancePreviewPage> createState() => _RebalancePreviewPageState();
}

class _RebalancePreviewPageState extends State<RebalancePreviewPage>
    with AppServicesAccess {
  ReplannerService? _service;
  Future<RebalanceProposal>? _proposal;
  late Set<int> _selected;
  bool _busy = false;
  bool _applied = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _proposal ??= _initAndLoad();
  }

  Future<RebalanceProposal> _initAndLoad() async {
    final provider = await AIScope.of(context).create();
    _service = ReplannerService(services: services, provider: provider);
    final proposal = (await services.proposals.get(widget.proposalId))!;
    final rebalance = RebalanceProposal.fromJson(
        jsonDecode(proposal.payloadJson) as Map<String, dynamic>);
    _selected = {for (var i = 0; i < rebalance.changes.length; i++) i};
    return rebalance;
  }

  Future<void> _apply(Set<int>? indexes) async {
    if (_service == null || _busy || _applied) return;
    setState(() => _busy = true);
    try {
      final applied = await _service!.applyChanges(widget.proposalId,
          indexes: indexes);
      if (!mounted) return;
      setState(() {
        _busy = false;
        _applied = true;
      });
      await Future.delayed(const Duration(milliseconds: 320));
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('已应用 $applied 项调整。')),
      );
      Navigator.of(context).pop(true);
    } on AIException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$e')));
      setState(() => _busy = false);
    }
  }

  Future<void> _cancel() async {
    await _service?.cancel(widget.proposalId);
    if (mounted) Navigator.of(context).pop(false);
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: !_busy,
      child: Scaffold(
        appBar: const VeyraAppBar(title: Text('拟调整')),
        body: FutureBuilder<RebalanceProposal>(
          future: _proposal,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }
            final rebalance = snapshot.data!;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(rebalance.summary,
                      style: Theme.of(context).textTheme.bodyLarge),
                ),
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    children: [
                      for (var i = 0; i < rebalance.changes.length; i++)
                        _ChangeCard(
                          change: rebalance.changes[i],
                          selected: _selected.contains(i),
                          onToggle: (v) => setState(() {
                            if (v == true) {
                              _selected.add(i);
                            } else {
                              _selected.remove(i);
                            }
                          }),
                        ),
                    ],
                  ),
                ),
                SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: _busy || _applied ? null : _cancel,
                            child: const Text('取消'),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: OutlinedButton(
                            onPressed: _busy || _applied || _selected.isEmpty
                                ? null
                                : () => _apply(_selected),
                            child: const Text('应用所选'),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: FilledButton(
                            onPressed: _busy || _applied || rebalance.changes.isEmpty
                                ? null
                                : () => _apply(null),
                            child: AnimatedSwitcher(
                              duration: VeyraMotion.fast,
                              child: _applied
                                  ? const Row(
                                      key: ValueKey('applied'),
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(Icons.check_rounded, size: 16),
                                        SizedBox(width: VeyraSpacing.s6),
                                        Text('已应用'),
                                      ],
                                    )
                                  : _busy
                                      ? const SizedBox(
                                          key: ValueKey('busy'),
                                          width: 16,
                                          height: 16,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                            color: Colors.white,
                                          ),
                                        )
                                      : const Text('全部应用',
                                          key: ValueKey('idle')),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

/// 变化卡（spec §19）：old → new 极清楚；统一视觉语言；勾选可选择性应用。
class _ChangeCard extends StatelessWidget {
  const _ChangeCard({
    required this.change,
    required this.selected,
    required this.onToggle,
  });

  final RebalanceChange change;
  final bool selected;
  final ValueChanged<bool?> onToggle;

  @override
  Widget build(BuildContext context) {
    final kindLabel = switch (change.kind) {
      RebalanceChangeKind.moveWeek => '移动',
      RebalanceChangeKind.priorityChange => '优先级',
      RebalanceChangeKind.addTask => '新增',
      RebalanceChangeKind.defer => '顺延',
    };
    final hasTransition = change.kind == RebalanceChangeKind.moveWeek ||
        change.kind == RebalanceChangeKind.priorityChange;
    return Card(
      margin: const EdgeInsets.only(bottom: VeyraSpacing.s12),
      clipBehavior: Clip.antiAlias,
      child: CheckboxListTile(
        value: selected,
        onChanged: onToggle,
        mouseCursor: SystemMouseCursors.click,
        controlAffinity: ListTileControlAffinity.leading,
        contentPadding: const EdgeInsets.symmetric(
            horizontal: VeyraSpacing.s16, vertical: VeyraSpacing.s8),
        title: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 56,
              child: Text(kindLabel,
                  style: const TextStyle(
                      fontSize: 13, color: VeyraColors.textTertiary)),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    change.taskTitle,
                    style: const TextStyle(
                      fontSize: 16,
                      height: 24 / 16,
                      fontWeight: FontWeight.w600,
                      color: VeyraColors.textPrimary,
                    ),
                  ),
                  if (hasTransition && change.from != null) ...[
                    const SizedBox(height: VeyraSpacing.s4),
                    Row(
                      children: [
                        Text(change.from!,
                            style: const TextStyle(
                                fontSize: 15,
                                color: VeyraColors.textSecondary)),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: VeyraSpacing.s8),
                          child: Icon(Icons.south,
                              size: 14, color: VeyraColors.textTertiary),
                        ),
                        Text(change.to ?? '',
                            style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                color: change.kind ==
                                        RebalanceChangeKind.priorityChange
                                    ? VeyraColors.success
                                    : VeyraColors.textPrimary)),
                      ],
                    ),
                  ],
                  if (change.kind == RebalanceChangeKind.addTask) ...[
                    const SizedBox(height: VeyraSpacing.s4),
                    Text(
                      change.to == null
                          ? '+ 新增到本周'
                          : '+ 新增到「${change.to}」',
                      style: const TextStyle(
                          fontSize: 15, color: VeyraColors.success),
                    ),
                  ],
                  if (change.detail.isNotEmpty) ...[
                    const SizedBox(height: VeyraSpacing.s4),
                    Text(change.detail,
                        style: const TextStyle(
                            fontSize: 13,
                            color: VeyraColors.textSecondary)),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
