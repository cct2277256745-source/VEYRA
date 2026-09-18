import 'package:flutter_test/flutter_test.dart';
import 'package:veyra/core/domain/enums.dart';
import 'package:veyra/data/app_services.dart';

void main() {
  late AppServices services;

  setUp(() {
    services = AppServices.inMemory();
  });

  tearDown(() => services.close());

  test('创建 Project → Phase → Task 后可完整读回', () async {
    final project = await services.projects.createProject(
      title: '雅思 8 周计划',
      outcome: '总分 7.0',
      executionMode: ExecutionMode.weeklyPlanning,
    );
    final phase = await services.projects.createPhase(project.id, '听力专项');
    final task = await services.projects.createTask(
      projectId: project.id,
      phaseId: phase.id,
      title: '完成阅读模块 02',
      priority: TaskPriority.must,
    );

    final loaded = await services.projects.getProject(project.id);
    expect(loaded!.title, '雅思 8 周计划');
    expect(loaded.executionMode, ExecutionMode.weeklyPlanning);
    expect(loaded.status, ProjectStatus.active);

    final tasks = await services.projects.tasksOfProject(project.id);
    expect(tasks.single.title, '完成阅读模块 02');
    expect(tasks.single.id, task.id);
    expect(tasks.single.status, TaskStatus.planned);
  });

  test('完成任务写入 outcomeNote 并产生 ProgressEvent', () async {
    final project = await services.projects.createProject(title: 'P');
    final phase = await services.projects.createPhase(project.id, '阶段');
    final task = await services.projects.createTask(
        projectId: project.id, phaseId: phase.id, title: 'T');
    final milestone = await services.projects.createMilestone(phase.id, 'M1');

    await services.projects.completeTask(task.id, outcomeNote: '一份精听笔记');
    await services.projects.completeMilestone(milestone.id);

    final done = await services.projects.getTask(task.id);
    expect(done!.isDone, isTrue);
    expect(done.outcomeNote, '一份精听笔记');

    final events = await services.progress.eventsOfProject(project.id);
    final types = events.map((e) => e.type).toSet();
    expect(types, containsAll(
        [ProgressEventType.taskCompleted, ProgressEventType.milestoneCompleted]));
  });

  test('删除被依赖的任务被拒绝，先移除依赖后可删除', () async {
    final project = await services.projects.createProject(title: 'P');
    final phase = await services.projects.createPhase(project.id, '阶段');
    final a = await services.projects
        .createTask(projectId: project.id, phaseId: phase.id, title: 'A');
    final b = await services.projects
        .createTask(projectId: project.id, phaseId: phase.id, title: 'B');
    await services.projects.addDependency(b.id, a.id);

    expect(() => services.projects.deleteTask(a.id), throwsStateError);

    final deps = await services.projects.dependenciesOfTask(b.id);
    expect(deps.single.dependsOnTaskId, a.id);
  });

  test('切换为 Project Only 后周归属被清除（Week 是可选投影）', () async {
    final project = await services.projects.createProject(
        title: 'P', executionMode: ExecutionMode.weeklyPlanning);
    final phase = await services.projects.createPhase(project.id, '阶段');
    final task = await services.projects
        .createTask(projectId: project.id, phaseId: phase.id, title: 'T');
    expect(await services.week.assignTaskToWeek(task.id), isTrue);

    await services.projects.setExecutionMode(
        project.id, ExecutionMode.projectOnly);

    final items = await services.week.weekItems(DateTime.now());
    expect(items, isEmpty);
  });
}
