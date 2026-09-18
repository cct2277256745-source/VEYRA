/// 收件箱（Inbox，UI Specification §18）：先把事情放下来，之后再决定。
/// Quick Capture 明显但轻；条目不做重卡；操作 hover 后出现；删除保留确认。
library;

import 'package:flutter/material.dart';

import '../../app/app_scope.dart';
import '../../app/page_scaffold.dart';
import '../../core/design/tokens.dart';
import '../../core/design/veyra_motion.dart';
import '../../core/domain/enums.dart';
import '../../core/domain/entities.dart';

class InboxPage extends StatefulWidget {
  const InboxPage({super.key});

  @override
  State<InboxPage> createState() => _InboxPageState();
}

class _InboxPageState extends State<InboxPage> with AppServicesAccess {
  final _quickInput = TextEditingController();
  List<InboxItem> _items = [];
  bool _loading = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _refresh();
  }

  @override
  void dispose() {
    _quickInput.dispose();
    super.dispose();
  }

  Future<void> _refresh() async {
    _items = await services.inbox.listOpen();
    if (mounted) setState(() => _loading = false);
  }

  Future<void> _quickAdd() async {
    final text = _quickInput.text.trim();
    if (text.isEmpty) return;
    await services.inbox.add(kind: InboxKind.quickTask, content: text);
    _quickInput.clear();
    await _refresh();
  }

  Future<void> _edit(InboxItem item) async {
    final controller = TextEditingController(text: item.content);
    final updated = await showVeyraDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('编辑'),
        content: TextField(controller: controller, autofocus: true, maxLines: 3),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('取消'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(controller.text.trim()),
            child: const Text('保存'),
          ),
        ],
      ),
    );
    if (updated != null && updated.isNotEmpty) {
      await services.inbox.updateContent(item.id, updated);
      await _refresh();
    }
  }

  Future<void> _convertToExistingProject(InboxItem item) async {
    final projects = await services.projects.listProjects();
    if (!mounted) return;
    if (projects.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('还没有项目。可以先把这条变成新项目。')));
      return;
    }
    final projectId = await showVeyraDialog<int>(
      context: context,
      builder: (context) => SimpleDialog(
        title: const Text('转入哪个项目？'),
        children: [
          for (final p in projects)
            SimpleDialogOption(
              onPressed: () => Navigator.of(context).pop(p.id),
              child: Text(p.title),
            ),
        ],
      ),
    );
    if (projectId == null) return;
    final phases = await services.projects.phasesOfProject(projectId);
    final phase = phases.isNotEmpty
        ? phases.first
        : await services.projects.createPhase(projectId, '收件箱');
    await services.projects
        .createTask(projectId: projectId, phaseId: phase.id, title: item.content);
    await services.inbox.setStatus(item.id, InboxStatus.converted);
    if (mounted) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('已转入项目。')));
    }
    await _refresh();
  }

  Future<void> _createAsNewProject(InboxItem item) async {
    await services.projects.createProject(title: item.content);
    await services.inbox.setStatus(item.id, InboxStatus.converted);
    if (mounted) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('已创建项目：${item.content}')));
    }
    await _refresh();
  }

  Future<void> _confirmDelete(InboxItem item) async {
    final confirmed = await showVeyraDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('删除这条记录？'),
        content: const Text('删除后无法恢复。'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('取消'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('删除'),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      await services.inbox.delete(item.id);
      await _refresh();
    }
  }

  @override
  Widget build(BuildContext context) {
    return PageScaffold(
      title: '收件箱',
      subtitle: '先放在这里。之后再决定。',
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 840),
          child: Column(
            children: [
              // —— Quick Capture：明显但轻 ——
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  VeyraSpacing.s32,
                  VeyraSpacing.s16,
                  VeyraSpacing.s32,
                  VeyraSpacing.s16,
                ),
                child: TextField(
                  controller: _quickInput,
                  onSubmitted: (_) => _quickAdd(),
                  style: const TextStyle(fontSize: 14),
                  decoration: InputDecoration(
                    hintText: '发生了什么？',
                    hintStyle: const TextStyle(
                      fontSize: 14,
                      color: VeyraColors.textTertiary,
                    ),
                    suffixIcon: IconButton(
                      tooltip: '添加',
                      icon: const Icon(
                        Icons.add_rounded,
                        color: VeyraColors.textPrimary,
                        size: 20,
                      ),
                      onPressed: _quickAdd,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: _loading
                    ? const SizedBox.shrink()
                    : _items.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  width: 44,
                                  height: 44,
                                  decoration: BoxDecoration(
                                    color: VeyraColors.backgroundAlt,
                                    borderRadius: BorderRadius.circular(
                                      VeyraRadius.medium,
                                    ),
                                  ),
                                  child: const Icon(
                                    Icons.inbox_outlined,
                                    size: 24,
                                    color: VeyraColors.textTertiary,
                                  ),
                                ),
                                const SizedBox(height: VeyraSpacing.s16),
                                Text(
                                  '收件箱是空的。',
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium
                                      ?.copyWith(
                                        fontWeight: FontWeight.w600,
                                        color: VeyraColors.textPrimary,
                                      ),
                                ),
                                const SizedBox(height: VeyraSpacing.s8),
                                const Text(
                                  '任何新想法都可以先放在这里。',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: VeyraColors.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                          )
                        : ListView.separated(
                            padding: const EdgeInsets.symmetric(
                              horizontal: VeyraSpacing.s32,
                              vertical: VeyraSpacing.s8,
                            ),
                            itemCount: _items.length,
                            separatorBuilder: (_, _) => const Divider(
                              height: 1,
                              color: VeyraColors.border,
                            ),
                            itemBuilder: (context, index) {
                              final item = _items[index];
                              return _InboxRow(
                                item: item,
                                onEdit: () => _edit(item),
                                onConvert: () =>
                                    _convertToExistingProject(item),
                                onNewProject: () =>
                                    _createAsNewProject(item),
                                onArchive: () async {
                                  await services.inbox.setStatus(
                                    item.id,
                                    InboxStatus.archived,
                                  );
                                  await _refresh();
                                },
                                onDelete: () => _confirmDelete(item),
                              );
                            },
                          ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// 单条收件箱记录：默认只有内容，hover 后出现操作（spec §18）。
class _InboxRow extends StatefulWidget {
  const _InboxRow({
    required this.item,
    required this.onEdit,
    required this.onConvert,
    required this.onNewProject,
    required this.onArchive,
    required this.onDelete,
  });

  final InboxItem item;
  final VoidCallback onEdit;
  final VoidCallback onConvert;
  final VoidCallback onNewProject;
  final VoidCallback onArchive;
  final VoidCallback onDelete;

  @override
  State<_InboxRow> createState() => _InboxRowState();
}

class _InboxRowState extends State<_InboxRow> {
  bool _hovering = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovering = true),
      onExit: (_) => setState(() => _hovering = false),
      child: AnimatedContainer(
        duration: VeyraMotion.fast,
        curve: VeyraMotion.curve,
        color: _hovering ? VeyraColors.hoverOverlay : Colors.transparent,
        padding: const EdgeInsets.symmetric(
            horizontal: VeyraSpacing.s32, vertical: VeyraSpacing.s12),
        child: Row(
          children: [
            Expanded(
              child: Text(
                widget.item.content,
                style: const TextStyle(
                  fontSize: 15,
                  height: 22 / 15,
                  color: VeyraColors.textPrimary,
                ),
              ),
            ),
            // 操作：hover 后出现，减少默认视觉噪音
            AnimatedOpacity(
              duration: VeyraMotion.fast,
              opacity: _hovering ? 1.0 : 0.0,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _GhostAction(label: '编辑', onTap: widget.onEdit),
                  _GhostAction(label: '移入项目', onTap: widget.onConvert),
                  _GhostAction(label: '创建为项目', onTap: widget.onNewProject),
                  _GhostAction(label: '归档', onTap: widget.onArchive),
                  _GhostAction(label: '删除', onTap: widget.onDelete),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _GhostAction extends StatefulWidget {
  const _GhostAction({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  State<_GhostAction> createState() => _GhostActionState();
}

class _GhostActionState extends State<_GhostAction> {
  bool _hovering = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: VeyraSpacing.s4),
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (_) => setState(() => _hovering = true),
        onExit: (_) => setState(() => _hovering = false),
        child: TextButton(
          onPressed: widget.onTap,
          style: TextButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: VeyraSpacing.s8),
            minimumSize: const Size(0, 32),
            foregroundColor: _hovering
                ? VeyraColors.textPrimary
                : VeyraColors.textSecondary,
          ),
          child: Text(
            widget.label,
            style: const TextStyle(fontSize: 13),
          ),
        ),
      ),
    );
  }
}
