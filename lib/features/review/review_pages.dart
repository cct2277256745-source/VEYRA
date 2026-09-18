/// 复盘页面（Slice 2.8）：周复盘与项目复盘共用展示骨架。
/// 成果优先，任务数量只是次要信息（PRD §9.6 / §27）。
library;

import 'package:flutter/material.dart';

import '../../ai/review_service.dart';
import '../projects/project_progress.dart';
import '../../core/design/progress_path.dart';
import '../../core/design/tokens.dart';
import '../../core/design/veyra_app_bar.dart';
import '../../app/app_scope.dart';

class WeekReviewPage extends StatelessWidget {
  const WeekReviewPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const _ReviewBody(title: '本周复盘', kind: _ReviewKind.week);
  }
}

class ProjectReviewPage extends StatelessWidget {
  const ProjectReviewPage({super.key, required this.projectId});

  final int projectId;

  @override
  Widget build(BuildContext context) {
    return _ReviewBody(title: '项目复盘', kind: _ReviewKind.project, projectId: projectId);
  }
}

enum _ReviewKind { week, project }

class _ReviewBody extends StatefulWidget {
  const _ReviewBody({required this.title, required this.kind, this.projectId});

  final String title;
  final _ReviewKind kind;
  final int? projectId;

  @override
  State<_ReviewBody> createState() => _ReviewBodyState();
}

class _ReviewBodyState extends State<_ReviewBody>
    with AppServicesAccess {
  ReviewStory? _story;
  List<ProgressPathNode> _path = const [];
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_story == null && _error == null && _loading) {
      _generate();
    }
  }

  Future<void> _generate() async {
    setState(() => _loading = true);
    try {
      final provider = await AIScope.of(context).createOrNull();
      if (provider == null) {
        if (!mounted) return;
        setState(() {
          _error = 'AI 还没有配置：在设置里填好 Base URL、Model 和 API Key 就能用了。';
          _loading = false;
        });
        return;
      }
      final service = ReviewService(services: services, provider: provider);
      ReviewStory story;
      if (widget.kind == _ReviewKind.week) {
        story = await service.weekReview();
      } else {
        story = await service.projectReview(widget.projectId!);
      }
      List<ProgressPathNode> path = const [];
      if (widget.kind == _ReviewKind.project) {
        final phases =
            await services.projects.phasesOfProject(widget.projectId!);
        final tasks = await services.projects.tasksOfProject(widget.projectId!);
        path = ProjectProgress.pathNodes(phases, tasks);
      }
      if (!mounted) return;
      setState(() {
        _story = story;
        _path = path;
        _loading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = '$e';
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: VeyraAppBar(title: Text(widget.title)),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(_error!, textAlign: TextAlign.center),
                      const SizedBox(height: 12),
                      OutlinedButton(onPressed: _generate, child: const Text('再试一次')),
                    ],
                  ),
                )
              : ListView(
                  padding: const EdgeInsets.all(24),
                  children: [
                    if (_path.isNotEmpty) ...[
                      Center(
                        child: ProgressPath(nodes: _path, showLabels: true),
                      ),
                      const SizedBox(height: VeyraSpacing.s24),
                    ],
                    if (_story!.aiSummary != null) ...[
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Text(_story!.aiSummary!,
                              style: Theme.of(context).textTheme.titleMedium),
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],
                    Text('你真正完成了',
                        style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 8),
                    if (_story!.highlights.isEmpty)
                      const Text('还没有记录成果。完成任务时可以写下「你最终完成了什么」。')
                    else
                      for (final h in _story!.highlights)
                        ListTile(
                          dense: true,
                          leading: const Icon(Icons.verified_outlined,
                              color: VeyraColors.success),
                          title: Text(h,
                              style: const TextStyle(
                                  fontWeight: FontWeight.w500)),
                        ),
                    const SizedBox(height: 16),
                    Text('完成的里程碑',
                        style: Theme.of(context).textTheme.titleMedium),
                    if (_story!.milestones.isEmpty)
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 8),
                        child: Text('这个周期还没有完成的里程碑。'),
                      )
                    else
                      for (final m in _story!.milestones)
                        ListTile(
                          dense: true,
                          leading: const Icon(Icons.emoji_events,
                              color: VeyraColors.warning),
                          title: Text(m),
                        ),
                    const SizedBox(height: 16),
                    Text('被推迟的',
                        style: Theme.of(context).textTheme.titleMedium),
                    if (_story!.deferred.isEmpty)
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 8),
                        child: Text('没有需要担心的推迟事项。'),
                      )
                    else
                      for (final d in _story!.deferred)
                        ListTile(
                          dense: true,
                          leading: const Icon(Icons.schedule),
                          title: Text(d),
                        ),
                    const SizedBox(height: 16),
                    Text('共完成 ${_story!.completedCount} 个任务',
                        style: Theme.of(context).textTheme.bodySmall),
                  ],
                ),
    );
  }
}
