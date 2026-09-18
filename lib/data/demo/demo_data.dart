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

    // —— 项目二：Project Only（求职，推进过半，展示 Progress Path）——
    final job = await _services.projects.createProject(
      title: 'AI 产品经理求职',
      outcome: '拿到 offer，开始投递。',
      executionMode: ExecutionMode.projectOnly,
      deadline: DateTime.now().add(const Duration(days: 42)),
    );
    final jobPlan = <String, List<(String, bool, String?)>>{
      '研究': [('分析岗位要求', true, '一份岗位能力清单'), ('找出能力差距', true, null)],
      '简历': [('重写项目经历', true, '一页针对 AI PM 的简历'), ('最终校对', true, null)],
      '作品集': [('完成第一组 Case Study', true, 'LUNE ONE 完整案例'), ('作品集介绍页', false, null)],
      '面试': [('产品问题演练', false, null), ('技术问题演练', false, null)],
      '投递': [('定制投递 12 家', false, null)],
    };
    for (final entry in jobPlan.entries) {
      final phase = await _services.projects.createPhase(
        job.id,
        entry.key,
        goal: entry.key == '作品集' ? '两个完整 Case Study 上线' : null,
      );
      for (final (taskTitle, done, outcome) in entry.value) {
        final task = await _services.projects.createTask(
          projectId: job.id,
          phaseId: phase.id,
          title: taskTitle,
          priority: entry.key == '作品集' ? TaskPriority.must : TaskPriority.optional,
        );
        if (done) {
          await _services.projects.completeTask(task.id, outcomeNote: outcome);
        }
      }
    }

    // —— 项目三：Project Only（作品集）——
    final portfolio = await _services.projects.createProject(
      title: '求职作品集 Case Study',
      outcome: '2 个完整 Case Study 上线',
      executionMode: ExecutionMode.projectOnly,
    );
    final research = await _services.projects
        .createPhase(portfolio.id, '研究', goal: '确定 Case Study 主线');
    await _services.projects.createTask(
      projectId: portfolio.id,
      phaseId: research.id,
      title: '写 Problem Statement',
      priority: TaskPriority.must,
    );

    // —— 收件箱示例 ——
    await _services.inbox.add(
        kind: InboxKind.idea, content: '想给作品集加一页 About');
  }
}
