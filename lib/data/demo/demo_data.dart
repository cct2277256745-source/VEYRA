/// Demo Data：首次启动时填入示例内容，方便确认数据通路。
/// 只在数据库为空时执行一次，之后绝不重复。
library;

import '../../core/domain/enums.dart';
import '../app_services.dart';

class DemoDataService {
  DemoDataService(this._services);

  final AppServices _services;

  Future<void> seedIfEmpty() async {
    final count = await _services.db.select(_services.db.projects).get();
    if (count.isNotEmpty) return;

    // —— 项目一：Weekly Planning（雅思）——
    final ielts = await _services.projects.createProject(
      title: '雅思 8 周计划',
      outcome: '总分 7.0，小分不低于 6.5',
      executionMode: ExecutionMode.weeklyPlanning,
      deadline: DateTime.now().add(const Duration(days: 56)),
    );
    final listening = await _services.projects
        .createPhase(ielts.id, '听力专项', goal: 'Section 3 稳定正确率 80%');
    final writing = await _services.projects
        .createPhase(ielts.id, '写作专项', goal: 'Task 2 结构化写作');
    final readingT1 = await _services.projects.createTask(
      projectId: ielts.id,
      phaseId: listening.id,
      title: '完成阅读模块 02',
      priority: TaskPriority.must,
      effort: EstimatedEffort.medium,
    );
    final writingT1 = await _services.projects.createTask(
      projectId: ielts.id,
      phaseId: writing.id,
      title: '写 2 篇 Task 2 范文精读',
      priority: TaskPriority.optional,
    );
    await _services.week.assignTaskToWeek(readingT1.id);
    await _services.week.assignTaskToWeek(writingT1.id);

    // —— 项目二：Project Only（健身，推进过半，展示 Progress Path）——
    final fitness = await _services.projects.createProject(
      title: '健身 12 周计划',
      outcome: '每周训练 3 次，完成 12 周训练记录。',
      executionMode: ExecutionMode.projectOnly,
      deadline: DateTime.now().add(const Duration(days: 42)),
    );
    final fitnessPlan = <String, List<(String, bool, String?)>>{
      '力量基础': [('完成第一周训练', true, '建立训练节奏'), ('记录动作与重量', true, null)],
      '训练节奏': [('完成第二周训练', true, '连续训练两周'), ('安排恢复日', true, null)],
      '动作复盘': [('整理训练记录', false, null), ('调整下一阶段动作', false, null)],
      '习惯巩固': [('完成第六周训练', false, null), ('复盘训练感受', false, null)],
      '阶段总结': [('完成第十二周测试', false, null)],
    };
    for (final entry in fitnessPlan.entries) {
      final phase = await _services.projects.createPhase(
        fitness.id,
        entry.key,
        goal: entry.key == '动作复盘' ? '形成可持续的训练调整方法' : null,
      );
      for (final (taskTitle, done, outcome) in entry.value) {
        final task = await _services.projects.createTask(
          projectId: fitness.id,
          phaseId: phase.id,
          title: taskTitle,
          priority: entry.key == '动作复盘' ? TaskPriority.must : TaskPriority.optional,
        );
        if (done) {
          await _services.projects.completeTask(task.id, outcomeNote: outcome);
        }
      }
    }

    // —— 项目三：Project Only（减脂，展示简短项目）——
    final fatLoss = await _services.projects.createProject(
      title: '减脂计划',
      outcome: '建立稳定饮食与活动节奏。',
      executionMode: ExecutionMode.projectOnly,
    );
    final nutrition = await _services.projects
        .createPhase(fatLoss.id, '饮食与活动', goal: '让每日选择变得可持续');
    await _services.projects.createTask(
      projectId: fatLoss.id,
      phaseId: nutrition.id,
      title: '记录 7 天饮食与步数',
      priority: TaskPriority.must,
    );

    // —— 收件箱示例 ——
    await _services.inbox.add(
        kind: InboxKind.idea, content: '想把训练和饮食记录合并到每周复盘');
  }
}
