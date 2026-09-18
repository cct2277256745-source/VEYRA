/// VEYRA 本地数据库（drift / SQLite）。
///
/// 迁移策略：schemaVersion 单调递增；破坏性变更走 onUpgrade 逐步迁移，
/// 用户数据永不允许静默清空（PRD 本地优先原则）。
library;

import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';

import '../../core/domain/enums.dart' as dom;

part 'app_database.g.dart';

@DataClassName('ProjectsRow')
class Projects extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get title => text().withLength(min: 1, max: 200)();
  TextColumn get outcome => text().withDefault(const Constant(''))();
  TextColumn get executionMode => textEnum<dom.ExecutionMode>()();
  TextColumn get status => textEnum<dom.ProjectStatus>()();
  TextColumn get health => textEnum<dom.PlanHealth>()();
  DateTimeColumn get startDate => dateTime()();
  DateTimeColumn get deadline => dateTime().nullable()();
  IntColumn get themeColor => integer().nullable()();
  IntColumn get sourceDocumentId => integer().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
}

@DataClassName('PhasesRow')
class Phases extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get projectId => integer().references(Projects, #id)();
  TextColumn get title => text().withLength(min: 1, max: 200)();
  TextColumn get goal => text().nullable()();
  IntColumn get orderIndex => integer()();
  DateTimeColumn get createdAt => dateTime()();
}

@DataClassName('MilestonesRow')
class Milestones extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get projectId => integer().references(Projects, #id)();
  IntColumn get phaseId => integer().references(Phases, #id)();
  TextColumn get title => text().withLength(min: 1, max: 200)();
  IntColumn get orderIndex => integer()();
  DateTimeColumn get completedAt => dateTime().nullable()();
  DateTimeColumn get createdAt => dateTime()();
}

@DataClassName('TasksRow')
class Tasks extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get projectId => integer().references(Projects, #id)();
  IntColumn get phaseId => integer().references(Phases, #id)();
  IntColumn get milestoneId => integer().nullable()();
  TextColumn get title => text().withLength(min: 1, max: 300)();
  TextColumn get description => text().nullable()();
  TextColumn get status => textEnum<dom.TaskStatus>()();
  TextColumn get priority => textEnum<dom.TaskPriority>()();
  TextColumn get effort => textEnum<dom.EstimatedEffort>()();
  DateTimeColumn get dueDate => dateTime().nullable()();
  IntColumn get sourceRefId => integer().nullable()();
  TextColumn get outcomeNote => text().nullable()();
  TextColumn get userNote => text().nullable()();
  IntColumn get orderIndex => integer()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
}

@DataClassName('TaskDependencyRow')
class TaskDependencies extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get taskId => integer().references(Tasks, #id)();
  IntColumn get dependsOnTaskId => integer().references(Tasks, #id)();
}

@DataClassName('SourceRefRow')
class SourceRefs extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get kind => textEnum<dom.SourceKind>()();
  TextColumn get quote => text()();
  TextColumn get aiReason => text().withDefault(const Constant(''))();
  IntColumn get documentId => integer().nullable()();
  DateTimeColumn get createdAt => dateTime()();
}

@DataClassName('WeekSettingRow')
class WeekSettings extends Table {
  IntColumn get id => integer().autoIncrement()();
  DateTimeColumn get weekStart => dateTime().unique()();
  TextColumn get capacity => textEnum<dom.CapacityLevel>()();
}

@DataClassName('WeeklyAssignmentRow')
class WeeklyAssignments extends Table {
  IntColumn get id => integer().autoIncrement()();
  DateTimeColumn get weekStart => dateTime()();
  IntColumn get taskId => integer().references(Tasks, #id)();
  IntColumn get projectId => integer().references(Projects, #id)();
  DateTimeColumn get addedAt => dateTime()();
}

@DataClassName('InboxItemRow')
class InboxItems extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get kind => textEnum<dom.InboxKind>()();
  TextColumn get content => text()();
  TextColumn get filePath => text().nullable()();
  TextColumn get status => textEnum<dom.InboxStatus>()();
  DateTimeColumn get createdAt => dateTime()();
}

@DataClassName('SourceDocumentRow')
class SourceDocuments extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get fileName => text()();
  TextColumn get fileKind => text()();
  TextColumn get filePath => text().nullable()();
  TextColumn get extractedText => text().nullable()();
  DateTimeColumn get importedAt => dateTime()();
}

@DataClassName('AiProposalRow')
class AiProposals extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get kind => text()();
  TextColumn get status => textEnum<dom.ProposalStatus>()();
  TextColumn get payloadJson => text()();
  TextColumn get summary => text()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get decidedAt => dateTime().nullable()();
}

@DataClassName('ProgressEventRow')
class ProgressEvents extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get type => textEnum<dom.ProgressEventType>()();
  IntColumn get projectId => integer().nullable()();
  IntColumn get taskId => integer().nullable()();
  TextColumn get detail => text().withDefault(const Constant(''))();
  DateTimeColumn get occurredAt => dateTime()();
}

class Settings extends Table {
  TextColumn get key => text()();
  TextColumn get value => text()();

  @override
  Set<Column> get primaryKey => {key};
}

@DataClassName('ReviewSnapshotRow')
class ReviewSnapshots extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get scope => textEnum<dom.ReviewScope>()();
  IntColumn get targetId => integer().nullable()();
  DateTimeColumn get periodStart => dateTime()();
  DateTimeColumn get periodEnd => dateTime()();
  TextColumn get storyJson => text()();
  TextColumn get aiSummary => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();
}

@DriftDatabase(tables: [
  Projects,
  Phases,
  Milestones,
  Tasks,
  TaskDependencies,
  SourceRefs,
  WeekSettings,
  WeeklyAssignments,
  InboxItems,
  SourceDocuments,
  AiProposals,
  ProgressEvents,
  ReviewSnapshots,
  Settings,
])
class AppDatabase extends _$AppDatabase {
  AppDatabase(super.e);

  AppDatabase.openInMemory() : super(NativeDatabase.memory());

  /// 打开基于文件的数据库（真实 App 与重启持久化测试共用此路径逻辑）。
  factory AppDatabase.openFile(File dbFile) =>
      AppDatabase(NativeDatabase(dbFile));

  /// 本地优先：数据库文件位置不依赖平台插件。
  /// macOS（含沙盒，HOME 指向容器）/ Windows 均可解析。
  static File defaultDatabaseFile() {
    final home =
        Platform.environment['HOME'] ?? Platform.environment['USERPROFILE']!;
    final File file;
    if (Platform.isMacOS) {
      file = File('$home/Library/Application Support/veyra/veyra.sqlite3');
    } else {
      final appData =
          Platform.environment['APPDATA'] ?? home;
      file = File('$appData/veyra/veyra.sqlite3');
    }
    file.parent.createSync(recursive: true);
    return file;
  }

  @override
  int get schemaVersion => 2;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onUpgrade: (m, from, to) async {
          // 逐级迁移；禁止 drop 全表。
          if (from < 2) {
            await m.createTable(settings);
          }
        },
      );
}
