/// 应用服务组合根：数据库 + 全部仓储。
/// UI 与 Feature 层只依赖这里暴露的接口集合。
library;

import 'dart:io';

import 'db/app_database.dart';
import 'repositories/ai_proposal_repository.dart';
import 'repositories/ai_settings_repository.dart';
import 'repositories/inbox_repository.dart';
import 'repositories/project_repository.dart';
import 'repositories/progress_repository.dart';
import 'repositories/source_document_repository.dart';
import 'repositories/week_repository.dart';

class AppServices {
  AppServices._(this.db)
      : projects = ProjectRepository(db),
        week = WeekRepository(db),
        inbox = InboxRepository(db),
        proposals = AiProposalRepository(db),
        progress = ProgressRepository(db),
        sourceDocuments = SourceDocumentRepository(db),
        aiSettings = AiSettingsRepository(db);

  final AppDatabase db;
  final ProjectRepository projects;
  final WeekRepository week;
  final InboxRepository inbox;
  final AiProposalRepository proposals;
  final ProgressRepository progress;
  final SourceDocumentRepository sourceDocuments;
  final AiSettingsRepository aiSettings;

  /// 生产入口：打开默认位置的文件数据库。
  static AppServices open() {
    return AppServices._(AppDatabase.openFile(AppDatabase.defaultDatabaseFile()));
  }

  /// 测试入口：内存数据库或指定文件。
  factory AppServices.inMemory() =>
      AppServices._(AppDatabase.openInMemory());

  factory AppServices.openFile(File file) => AppServices._(
      AppDatabase.openFile(file));

  Future<void> close() => db.close();
}
