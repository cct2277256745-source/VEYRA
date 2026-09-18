import 'package:flutter_test/flutter_test.dart';
import 'package:veyra/core/domain/enums.dart';
import 'package:veyra/data/app_services.dart';

void main() {
  late AppServices services;

  setUp(() {
    services = AppServices.inMemory();
  });

  tearDown(() => services.close());

  test('Project Only 任务加入 Week 被拒绝（PRD §11 硬规则）', () async {
    final project = await services.projects.createProject(
        title: '减脂计划', executionMode: ExecutionMode.projectOnly);
    final phase = await services.projects.createPhase(project.id, '研究');
    final task = await services.projects
        .createTask(projectId: project.id, phaseId: phase.id, title: 'T');

    expect(await services.week.assignTaskToWeek(task.id), isFalse);
    expect(await services.week.weekItems(DateTime.now()), isEmpty);
  });

  test('Weekly 项目任务可入周、可移动、不复制 Task 本体', () async {
    final project = await services.projects.createProject(
        title: '雅思', executionMode: ExecutionMode.weeklyPlanning);
    final phase = await services.projects.createPhase(project.id, '听力');
    final task = await services.projects
        .createTask(projectId: project.id, phaseId: phase.id, title: 'T');

    expect(await services.week.assignTaskToWeek(task.id), isTrue);
    final thisWeek = await services.week.assignmentsOfWeek(DateTime.now());
    expect(thisWeek, hasLength(1));

    final nextWeek = DateTime.now().add(const Duration(days: 7));
    await services.week.moveAssignment(thisWeek.single.id, nextWeek);
    expect(await services.week.assignmentsOfWeek(DateTime.now()), isEmpty);
    expect(await services.week.assignmentsOfWeek(nextWeek), hasLength(1));

    // 移动的是投影，Task 本体仍是同一行
    final stillThere = await services.projects.getTask(task.id);
    expect(stillThere, isNotNull);
  });

  test('重复加入同一周是幂等的', () async {
    final project = await services.projects.createProject(
        title: '雅思', executionMode: ExecutionMode.weeklyPlanning);
    final phase = await services.projects.createPhase(project.id, '听力');
    final task = await services.projects
        .createTask(projectId: project.id, phaseId: phase.id, title: 'T');

    expect(await services.week.assignTaskToWeek(task.id), isTrue);
    expect(await services.week.assignTaskToWeek(task.id), isTrue);
    expect(await services.week.assignmentsOfWeek(DateTime.now()), hasLength(1));
  });

  test('容量默认 normal，设置后按周读取', () async {
    expect(await services.week.capacityOf(DateTime.now()), CapacityLevel.normal);
    await services.week.setCapacity(DateTime.now(), CapacityLevel.survival);
    expect(await services.week.capacityOf(DateTime.now()), CapacityLevel.survival);
    // 下一周不受影响
    expect(
        await services.week
            .capacityOf(DateTime.now().add(const Duration(days: 7))),
        CapacityLevel.normal);
  });
}
