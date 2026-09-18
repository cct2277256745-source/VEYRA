/// Projects 页（UI Specification §15/§16）：
/// 页头 + 轻量说明 + Active 项目卡（Accent / 当前阶段 / 迷你 Path / 下一步）
/// + 新建项目 + 已归档极轻入口 + 空状态。
/// 禁止：任务计数、overdue、高密度统计（AGENTS §8 / spec §15）。
library;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../app/app_scope.dart';
import '../../app/page_scaffold.dart';
import '../../core/design/progress_path.dart';
import '../../core/design/tokens.dart';
import '../../core/design/veyra_motion.dart';
import '../../core/domain/enums.dart';
import '../../core/domain/entities.dart';
import 'new_project_flow.dart';
import 'project_focus_page.dart';
import 'projects_view_model.dart';

class ProjectsPage extends StatefulWidget {
  const ProjectsPage({super.key});

  @override
  State<ProjectsPage> createState() => _ProjectsPageState();
}

class _ProjectsPageState extends State<ProjectsPage> with AppServicesAccess {
  ProjectsViewModel? _viewModel;
  bool _showArchived = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _viewModel ??= ProjectsViewModel(services)..refresh();
  }

  @override
  void dispose() {
    _viewModel?.dispose();
    super.dispose();
  }

  Future<void> _newProject() async {
    final created = await showVeyraDialog<bool>(
      context: context,
      builder: (_) => const NewProjectFlowDialog(),
    );
    if (created == true) {
      await _viewModel!.refresh();
    }
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = _viewModel!;
    return PageScaffold(
      title: '项目',
      subtitle: '你正在推进的路径。',
      actions: [
        FilledButton.icon(
          onPressed: _newProject,
          icon: const Icon(Icons.add, size: 18),
          label: const Text('新建项目'),
        ),
      ],
      body: AnimatedBuilder(
        animation: viewModel,
        builder: (context, _) {
          if (viewModel.loading &&
              viewModel.projects.isEmpty &&
              viewModel.archivedProjects.isEmpty) {
            return const _ProjectsSkeleton();
          }
          final projects = viewModel.projects;
          if (projects.isEmpty && viewModel.archivedProjects.isEmpty) {
            return _EmptyProjects(onCreate: _newProject);
          }
          return SingleChildScrollView(
            child: Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                    maxWidth:
                        _projectsWidth(MediaQuery.of(context).size.width)),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(
                      VeyraSpacing.s32,
                      VeyraSpacing.s24,
                      VeyraSpacing.s32,
                      VeyraSpacing.s48),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      for (final p in projects) ...[
                        _ProjectCard(project: p, viewModel: viewModel),
                        const SizedBox(height: VeyraSpacing.s16),
                      ],
                      if (viewModel.archivedProjects.isNotEmpty) ...[
                        if (!_showArchived)
                          TextButton.icon(
                            onPressed: () =>
                                setState(() => _showArchived = true),
                            icon: const Icon(Icons.archive_outlined,
                                size: 16, color: VeyraColors.textTertiary),
                            label: const Text('已归档项目',
                                style: TextStyle(
                                    color: VeyraColors.textTertiary)),
                          ),
                        VeyraExpandable(
                          isExpanded: _showArchived,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: VeyraSpacing.s16),
                              const Text(
                                '已归档',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: VeyraColors.textTertiary,
                                ),
                              ),
                              const SizedBox(height: VeyraSpacing.s8),
                              for (final p in viewModel.archivedProjects) ...[
                                _ProjectCard(project: p, viewModel: viewModel),
                                const SizedBox(height: VeyraSpacing.s16),
                              ],
                              TextButton.icon(
                                onPressed: () =>
                                    setState(() => _showArchived = false),
                                icon: const Icon(Icons.expand_less,
                                    size: 16, color: VeyraColors.textTertiary),
                                label: const Text('收起已归档',
                                    style: TextStyle(
                                        color: VeyraColors.textTertiary)),
                              ),
                            ],
                          ),
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

/// 响应式内容宽度（与 Focus View 同族：760/840/920）。
double _projectsWidth(double viewportWidth) {
  if (viewportWidth < 1200) return 760;
  if (viewportWidth < 1600) return 840;
  return 920;
}

/// Loading：skeleton 灰块（spec §5，不用居中 spinner）。
class _ProjectsSkeleton extends StatelessWidget {
  const _ProjectsSkeleton();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 760),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(VeyraSpacing.s32,
                VeyraSpacing.s24, VeyraSpacing.s32, VeyraSpacing.s48),
            child: Column(
              children: [
                for (var i = 0; i < 3; i++) ...[
                  Container(
                    height: 120,
                    decoration: BoxDecoration(
                      color: VeyraColors.borderSubtle,
                      borderRadius: BorderRadius.circular(VeyraRadius.large),
                    ),
                  ),
                  const SizedBox(height: VeyraSpacing.s16),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _EmptyProjects extends StatelessWidget {
  const _EmptyProjects({required this.onCreate});

  final VoidCallback onCreate;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 480),
        padding: const EdgeInsets.all(VeyraSpacing.s32),
        decoration: BoxDecoration(
          color: VeyraColors.surface,
          borderRadius: BorderRadius.circular(VeyraRadius.large),
          border: Border.all(color: VeyraColors.border),
          boxShadow: VeyraShadows.subtle,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: VeyraColors.backgroundAlt,
                borderRadius: BorderRadius.circular(VeyraRadius.medium),
              ),
              child: const Icon(
                Icons.folder_open_rounded,
                size: 24,
                color: VeyraColors.textTertiary,
              ),
            ),
            const SizedBox(height: VeyraSpacing.s16),
            Text(
              '还没有项目。',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: VeyraColors.textPrimary,
                  ),
            ),
            const SizedBox(height: VeyraSpacing.s8),
            const Text(
              '从一个目标开始，或者导入你已有的规划。',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: VeyraColors.textSecondary,
              ),
            ),
            const SizedBox(height: VeyraSpacing.s24),
            FilledButton.icon(
              onPressed: onCreate,
              icon: const Icon(Icons.add, size: 16),
              label: const Text('新建项目'),
              style: FilledButton.styleFrom(
                backgroundColor: VeyraColors.primaryButton,
                padding: const EdgeInsets.symmetric(
                  horizontal: VeyraSpacing.s20,
                  vertical: VeyraSpacing.s12,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// 项目卡（spec §15）：项目名 / 当前阶段 / 迷你 Path / 下一步 / Accent 点 / More。
class _ProjectCard extends StatefulWidget {
  const _ProjectCard({required this.project, required this.viewModel});

  final Project project;
  final ProjectsViewModel viewModel;

  @override
  State<_ProjectCard> createState() => _ProjectCardState();
}

class _ProjectCardState extends State<_ProjectCard> {
  bool _hovering = false;
  bool _pressed = false;
  bool _focused = false;

  void _openProject() async {
    await Navigator.of(context).push(VeyraPageRoute(
      builder: (_) => ProjectFocusPage(projectId: widget.project.id),
    ));
    widget.viewModel.refresh();
  }

  @override
  Widget build(BuildContext context) {
    final accent = VeyraColors.fromArgb(widget.project.themeColor);
    final archived = widget.project.status == ProjectStatus.archived;
    final next = widget.viewModel.nextStepOf(widget.project.id);
    final path = widget.viewModel.pathOf(widget.project.id);
    final phaseName = widget.viewModel.currentPhaseOf(widget.project.id);
    final reduced = VeyraMotion.isReducedMotion(context);

    Widget card = AnimatedContainer(
      duration: VeyraMotion.fast,
      curve: VeyraMotion.curve,
      decoration: BoxDecoration(
        color: VeyraColors.surface,
        borderRadius: BorderRadius.circular(VeyraRadius.large),
        border: Border.all(
          color: _hovering
              ? VeyraColors.textSecondary.withValues(alpha: 0.4)
              : _focused
                  ? VeyraColors.focusRing.withValues(alpha: 0.4)
                  : VeyraColors.border,
          width: _focused ? 1.5 : 1.0,
        ),
        boxShadow: _hovering ? VeyraShadows.subtle : null,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(VeyraRadius.large),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: _openProject,
            child: Padding(
              padding: const EdgeInsets.all(VeyraSpacing.s20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: accent,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: VeyraSpacing.s12),
                        Expanded(
                          child: Text(
                            widget.project.title,
                            style: const TextStyle(
                              fontSize: 16,
                              height: 24 / 16,
                              fontWeight: FontWeight.w600,
                              color: VeyraColors.textPrimary,
                            ),
                          ),
                        ),
                        if (archived)
                          const Padding(
                            padding: EdgeInsets.only(right: VeyraSpacing.s8),
                            child: Text(
                              '已归档',
                              style: TextStyle(
                                fontSize: 13,
                                color: VeyraColors.textTertiary,
                              ),
                            ),
                          ),
                        PopupMenuButton<String>(
                          tooltip: '更多',
                          icon: const Icon(
                            Icons.more_horiz,
                            size: 20,
                            color: VeyraColors.textTertiary,
                          ),
                          onSelected: (action) {
                            if (action == 'archive') {
                              widget.viewModel.archiveProject(widget.project.id);
                            } else if (action == 'restore') {
                              widget.viewModel.restoreProject(widget.project.id);
                            }
                          },
                          itemBuilder: (_) => [
                            if (!archived)
                              const PopupMenuItem(
                                value: 'archive',
                                child: Text('归档项目'),
                              ),
                            if (archived)
                              const PopupMenuItem(
                                value: 'restore',
                                child: Text('恢复项目'),
                              ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: VeyraSpacing.s6),
                    if (phaseName != null)
                      Text(
                        '当前阶段 · $phaseName',
                        style: const TextStyle(
                          fontSize: 13,
                          color: VeyraColors.textSecondary,
                        ),
                      ),
                    if (path.isNotEmpty) ...[
                      const SizedBox(height: VeyraSpacing.s12),
                      ProgressPath(nodes: path, accent: accent, showLabels: false),
                    ],
                    const SizedBox(height: VeyraSpacing.s12),
                    Row(
                      children: [
                        const Icon(
                          Icons.arrow_right_alt_rounded,
                          size: 16,
                          color: VeyraColors.textTertiary,
                        ),
                        const SizedBox(width: VeyraSpacing.s6),
                        Expanded(
                          child: Text(
                            next == null || next.isEmpty ? '暂无下一步' : '下一步：$next',
                            style: const TextStyle(
                              fontSize: 14,
                              height: 20 / 14,
                              color: VeyraColors.textPrimary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );

    if (!reduced) {
      card = Transform.translate(
        offset: Offset(0, _hovering ? -1.5 : 0),
        child: AnimatedScale(
          scale: _pressed ? 0.99 : 1.0,
          duration: VeyraMotion.instant,
          curve: VeyraMotion.curveFast,
          child: card,
        ),
      );
    }

    return FocusableActionDetector(
      mouseCursor: SystemMouseCursors.click,
      onShowFocusHighlight: (v) => setState(() => _focused = v),
      onShowHoverHighlight: (v) => setState(() => _hovering = v),
      actions: {
        ActivateIntent: CallbackAction<ActivateIntent>(
          onInvoke: (_) {
            _openProject();
            return null;
          },
        ),
      },
      shortcuts: const {
        SingleActivator(LogicalKeyboardKey.enter): ActivateIntent(),
        SingleActivator(LogicalKeyboardKey.space): ActivateIntent(),
      },
      child: GestureDetector(
        onTapDown: (_) => setState(() => _pressed = true),
        onTapUp: (_) => setState(() => _pressed = false),
        onTapCancel: () => setState(() => _pressed = false),
        child: card,
      ),
    );
  }
}
