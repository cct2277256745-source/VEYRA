// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $ProjectsTable extends Projects
    with TableInfo<$ProjectsTable, ProjectsRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ProjectsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 200,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _outcomeMeta = const VerificationMeta(
    'outcome',
  );
  @override
  late final GeneratedColumn<String> outcome = GeneratedColumn<String>(
    'outcome',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  @override
  late final GeneratedColumnWithTypeConverter<dom.ExecutionMode, String>
  executionMode = GeneratedColumn<String>(
    'execution_mode',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  ).withConverter<dom.ExecutionMode>($ProjectsTable.$converterexecutionMode);
  @override
  late final GeneratedColumnWithTypeConverter<dom.ProjectStatus, String>
  status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  ).withConverter<dom.ProjectStatus>($ProjectsTable.$converterstatus);
  @override
  late final GeneratedColumnWithTypeConverter<dom.PlanHealth, String> health =
      GeneratedColumn<String>(
        'health',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<dom.PlanHealth>($ProjectsTable.$converterhealth);
  static const VerificationMeta _startDateMeta = const VerificationMeta(
    'startDate',
  );
  @override
  late final GeneratedColumn<DateTime> startDate = GeneratedColumn<DateTime>(
    'start_date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _deadlineMeta = const VerificationMeta(
    'deadline',
  );
  @override
  late final GeneratedColumn<DateTime> deadline = GeneratedColumn<DateTime>(
    'deadline',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _themeColorMeta = const VerificationMeta(
    'themeColor',
  );
  @override
  late final GeneratedColumn<int> themeColor = GeneratedColumn<int>(
    'theme_color',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _sourceDocumentIdMeta = const VerificationMeta(
    'sourceDocumentId',
  );
  @override
  late final GeneratedColumn<int> sourceDocumentId = GeneratedColumn<int>(
    'source_document_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    title,
    outcome,
    executionMode,
    status,
    health,
    startDate,
    deadline,
    themeColor,
    sourceDocumentId,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'projects';
  @override
  VerificationContext validateIntegrity(
    Insertable<ProjectsRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('outcome')) {
      context.handle(
        _outcomeMeta,
        outcome.isAcceptableOrUnknown(data['outcome']!, _outcomeMeta),
      );
    }
    if (data.containsKey('start_date')) {
      context.handle(
        _startDateMeta,
        startDate.isAcceptableOrUnknown(data['start_date']!, _startDateMeta),
      );
    } else if (isInserting) {
      context.missing(_startDateMeta);
    }
    if (data.containsKey('deadline')) {
      context.handle(
        _deadlineMeta,
        deadline.isAcceptableOrUnknown(data['deadline']!, _deadlineMeta),
      );
    }
    if (data.containsKey('theme_color')) {
      context.handle(
        _themeColorMeta,
        themeColor.isAcceptableOrUnknown(data['theme_color']!, _themeColorMeta),
      );
    }
    if (data.containsKey('source_document_id')) {
      context.handle(
        _sourceDocumentIdMeta,
        sourceDocumentId.isAcceptableOrUnknown(
          data['source_document_id']!,
          _sourceDocumentIdMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ProjectsRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ProjectsRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      outcome: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}outcome'],
      )!,
      executionMode: $ProjectsTable.$converterexecutionMode.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}execution_mode'],
        )!,
      ),
      status: $ProjectsTable.$converterstatus.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}status'],
        )!,
      ),
      health: $ProjectsTable.$converterhealth.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}health'],
        )!,
      ),
      startDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}start_date'],
      )!,
      deadline: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}deadline'],
      ),
      themeColor: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}theme_color'],
      ),
      sourceDocumentId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}source_document_id'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $ProjectsTable createAlias(String alias) {
    return $ProjectsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<dom.ExecutionMode, String, String>
  $converterexecutionMode = const EnumNameConverter<dom.ExecutionMode>(
    dom.ExecutionMode.values,
  );
  static JsonTypeConverter2<dom.ProjectStatus, String, String>
  $converterstatus = const EnumNameConverter<dom.ProjectStatus>(
    dom.ProjectStatus.values,
  );
  static JsonTypeConverter2<dom.PlanHealth, String, String> $converterhealth =
      const EnumNameConverter<dom.PlanHealth>(dom.PlanHealth.values);
}

class ProjectsRow extends DataClass implements Insertable<ProjectsRow> {
  final int id;
  final String title;
  final String outcome;
  final dom.ExecutionMode executionMode;
  final dom.ProjectStatus status;
  final dom.PlanHealth health;
  final DateTime startDate;
  final DateTime? deadline;
  final int? themeColor;
  final int? sourceDocumentId;
  final DateTime createdAt;
  final DateTime updatedAt;
  const ProjectsRow({
    required this.id,
    required this.title,
    required this.outcome,
    required this.executionMode,
    required this.status,
    required this.health,
    required this.startDate,
    this.deadline,
    this.themeColor,
    this.sourceDocumentId,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['title'] = Variable<String>(title);
    map['outcome'] = Variable<String>(outcome);
    {
      map['execution_mode'] = Variable<String>(
        $ProjectsTable.$converterexecutionMode.toSql(executionMode),
      );
    }
    {
      map['status'] = Variable<String>(
        $ProjectsTable.$converterstatus.toSql(status),
      );
    }
    {
      map['health'] = Variable<String>(
        $ProjectsTable.$converterhealth.toSql(health),
      );
    }
    map['start_date'] = Variable<DateTime>(startDate);
    if (!nullToAbsent || deadline != null) {
      map['deadline'] = Variable<DateTime>(deadline);
    }
    if (!nullToAbsent || themeColor != null) {
      map['theme_color'] = Variable<int>(themeColor);
    }
    if (!nullToAbsent || sourceDocumentId != null) {
      map['source_document_id'] = Variable<int>(sourceDocumentId);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  ProjectsCompanion toCompanion(bool nullToAbsent) {
    return ProjectsCompanion(
      id: Value(id),
      title: Value(title),
      outcome: Value(outcome),
      executionMode: Value(executionMode),
      status: Value(status),
      health: Value(health),
      startDate: Value(startDate),
      deadline: deadline == null && nullToAbsent
          ? const Value.absent()
          : Value(deadline),
      themeColor: themeColor == null && nullToAbsent
          ? const Value.absent()
          : Value(themeColor),
      sourceDocumentId: sourceDocumentId == null && nullToAbsent
          ? const Value.absent()
          : Value(sourceDocumentId),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory ProjectsRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ProjectsRow(
      id: serializer.fromJson<int>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      outcome: serializer.fromJson<String>(json['outcome']),
      executionMode: $ProjectsTable.$converterexecutionMode.fromJson(
        serializer.fromJson<String>(json['executionMode']),
      ),
      status: $ProjectsTable.$converterstatus.fromJson(
        serializer.fromJson<String>(json['status']),
      ),
      health: $ProjectsTable.$converterhealth.fromJson(
        serializer.fromJson<String>(json['health']),
      ),
      startDate: serializer.fromJson<DateTime>(json['startDate']),
      deadline: serializer.fromJson<DateTime?>(json['deadline']),
      themeColor: serializer.fromJson<int?>(json['themeColor']),
      sourceDocumentId: serializer.fromJson<int?>(json['sourceDocumentId']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'title': serializer.toJson<String>(title),
      'outcome': serializer.toJson<String>(outcome),
      'executionMode': serializer.toJson<String>(
        $ProjectsTable.$converterexecutionMode.toJson(executionMode),
      ),
      'status': serializer.toJson<String>(
        $ProjectsTable.$converterstatus.toJson(status),
      ),
      'health': serializer.toJson<String>(
        $ProjectsTable.$converterhealth.toJson(health),
      ),
      'startDate': serializer.toJson<DateTime>(startDate),
      'deadline': serializer.toJson<DateTime?>(deadline),
      'themeColor': serializer.toJson<int?>(themeColor),
      'sourceDocumentId': serializer.toJson<int?>(sourceDocumentId),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  ProjectsRow copyWith({
    int? id,
    String? title,
    String? outcome,
    dom.ExecutionMode? executionMode,
    dom.ProjectStatus? status,
    dom.PlanHealth? health,
    DateTime? startDate,
    Value<DateTime?> deadline = const Value.absent(),
    Value<int?> themeColor = const Value.absent(),
    Value<int?> sourceDocumentId = const Value.absent(),
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => ProjectsRow(
    id: id ?? this.id,
    title: title ?? this.title,
    outcome: outcome ?? this.outcome,
    executionMode: executionMode ?? this.executionMode,
    status: status ?? this.status,
    health: health ?? this.health,
    startDate: startDate ?? this.startDate,
    deadline: deadline.present ? deadline.value : this.deadline,
    themeColor: themeColor.present ? themeColor.value : this.themeColor,
    sourceDocumentId: sourceDocumentId.present
        ? sourceDocumentId.value
        : this.sourceDocumentId,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  ProjectsRow copyWithCompanion(ProjectsCompanion data) {
    return ProjectsRow(
      id: data.id.present ? data.id.value : this.id,
      title: data.title.present ? data.title.value : this.title,
      outcome: data.outcome.present ? data.outcome.value : this.outcome,
      executionMode: data.executionMode.present
          ? data.executionMode.value
          : this.executionMode,
      status: data.status.present ? data.status.value : this.status,
      health: data.health.present ? data.health.value : this.health,
      startDate: data.startDate.present ? data.startDate.value : this.startDate,
      deadline: data.deadline.present ? data.deadline.value : this.deadline,
      themeColor: data.themeColor.present
          ? data.themeColor.value
          : this.themeColor,
      sourceDocumentId: data.sourceDocumentId.present
          ? data.sourceDocumentId.value
          : this.sourceDocumentId,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ProjectsRow(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('outcome: $outcome, ')
          ..write('executionMode: $executionMode, ')
          ..write('status: $status, ')
          ..write('health: $health, ')
          ..write('startDate: $startDate, ')
          ..write('deadline: $deadline, ')
          ..write('themeColor: $themeColor, ')
          ..write('sourceDocumentId: $sourceDocumentId, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    title,
    outcome,
    executionMode,
    status,
    health,
    startDate,
    deadline,
    themeColor,
    sourceDocumentId,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ProjectsRow &&
          other.id == this.id &&
          other.title == this.title &&
          other.outcome == this.outcome &&
          other.executionMode == this.executionMode &&
          other.status == this.status &&
          other.health == this.health &&
          other.startDate == this.startDate &&
          other.deadline == this.deadline &&
          other.themeColor == this.themeColor &&
          other.sourceDocumentId == this.sourceDocumentId &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class ProjectsCompanion extends UpdateCompanion<ProjectsRow> {
  final Value<int> id;
  final Value<String> title;
  final Value<String> outcome;
  final Value<dom.ExecutionMode> executionMode;
  final Value<dom.ProjectStatus> status;
  final Value<dom.PlanHealth> health;
  final Value<DateTime> startDate;
  final Value<DateTime?> deadline;
  final Value<int?> themeColor;
  final Value<int?> sourceDocumentId;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  const ProjectsCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.outcome = const Value.absent(),
    this.executionMode = const Value.absent(),
    this.status = const Value.absent(),
    this.health = const Value.absent(),
    this.startDate = const Value.absent(),
    this.deadline = const Value.absent(),
    this.themeColor = const Value.absent(),
    this.sourceDocumentId = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  ProjectsCompanion.insert({
    this.id = const Value.absent(),
    required String title,
    this.outcome = const Value.absent(),
    required dom.ExecutionMode executionMode,
    required dom.ProjectStatus status,
    required dom.PlanHealth health,
    required DateTime startDate,
    this.deadline = const Value.absent(),
    this.themeColor = const Value.absent(),
    this.sourceDocumentId = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
  }) : title = Value(title),
       executionMode = Value(executionMode),
       status = Value(status),
       health = Value(health),
       startDate = Value(startDate),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<ProjectsRow> custom({
    Expression<int>? id,
    Expression<String>? title,
    Expression<String>? outcome,
    Expression<String>? executionMode,
    Expression<String>? status,
    Expression<String>? health,
    Expression<DateTime>? startDate,
    Expression<DateTime>? deadline,
    Expression<int>? themeColor,
    Expression<int>? sourceDocumentId,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (outcome != null) 'outcome': outcome,
      if (executionMode != null) 'execution_mode': executionMode,
      if (status != null) 'status': status,
      if (health != null) 'health': health,
      if (startDate != null) 'start_date': startDate,
      if (deadline != null) 'deadline': deadline,
      if (themeColor != null) 'theme_color': themeColor,
      if (sourceDocumentId != null) 'source_document_id': sourceDocumentId,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  ProjectsCompanion copyWith({
    Value<int>? id,
    Value<String>? title,
    Value<String>? outcome,
    Value<dom.ExecutionMode>? executionMode,
    Value<dom.ProjectStatus>? status,
    Value<dom.PlanHealth>? health,
    Value<DateTime>? startDate,
    Value<DateTime?>? deadline,
    Value<int?>? themeColor,
    Value<int?>? sourceDocumentId,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
  }) {
    return ProjectsCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      outcome: outcome ?? this.outcome,
      executionMode: executionMode ?? this.executionMode,
      status: status ?? this.status,
      health: health ?? this.health,
      startDate: startDate ?? this.startDate,
      deadline: deadline ?? this.deadline,
      themeColor: themeColor ?? this.themeColor,
      sourceDocumentId: sourceDocumentId ?? this.sourceDocumentId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (outcome.present) {
      map['outcome'] = Variable<String>(outcome.value);
    }
    if (executionMode.present) {
      map['execution_mode'] = Variable<String>(
        $ProjectsTable.$converterexecutionMode.toSql(executionMode.value),
      );
    }
    if (status.present) {
      map['status'] = Variable<String>(
        $ProjectsTable.$converterstatus.toSql(status.value),
      );
    }
    if (health.present) {
      map['health'] = Variable<String>(
        $ProjectsTable.$converterhealth.toSql(health.value),
      );
    }
    if (startDate.present) {
      map['start_date'] = Variable<DateTime>(startDate.value);
    }
    if (deadline.present) {
      map['deadline'] = Variable<DateTime>(deadline.value);
    }
    if (themeColor.present) {
      map['theme_color'] = Variable<int>(themeColor.value);
    }
    if (sourceDocumentId.present) {
      map['source_document_id'] = Variable<int>(sourceDocumentId.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ProjectsCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('outcome: $outcome, ')
          ..write('executionMode: $executionMode, ')
          ..write('status: $status, ')
          ..write('health: $health, ')
          ..write('startDate: $startDate, ')
          ..write('deadline: $deadline, ')
          ..write('themeColor: $themeColor, ')
          ..write('sourceDocumentId: $sourceDocumentId, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $PhasesTable extends Phases with TableInfo<$PhasesTable, PhasesRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PhasesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _projectIdMeta = const VerificationMeta(
    'projectId',
  );
  @override
  late final GeneratedColumn<int> projectId = GeneratedColumn<int>(
    'project_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES projects (id)',
    ),
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 200,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _goalMeta = const VerificationMeta('goal');
  @override
  late final GeneratedColumn<String> goal = GeneratedColumn<String>(
    'goal',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _orderIndexMeta = const VerificationMeta(
    'orderIndex',
  );
  @override
  late final GeneratedColumn<int> orderIndex = GeneratedColumn<int>(
    'order_index',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    projectId,
    title,
    goal,
    orderIndex,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'phases';
  @override
  VerificationContext validateIntegrity(
    Insertable<PhasesRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('project_id')) {
      context.handle(
        _projectIdMeta,
        projectId.isAcceptableOrUnknown(data['project_id']!, _projectIdMeta),
      );
    } else if (isInserting) {
      context.missing(_projectIdMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('goal')) {
      context.handle(
        _goalMeta,
        goal.isAcceptableOrUnknown(data['goal']!, _goalMeta),
      );
    }
    if (data.containsKey('order_index')) {
      context.handle(
        _orderIndexMeta,
        orderIndex.isAcceptableOrUnknown(data['order_index']!, _orderIndexMeta),
      );
    } else if (isInserting) {
      context.missing(_orderIndexMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PhasesRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PhasesRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      projectId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}project_id'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      goal: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}goal'],
      ),
      orderIndex: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}order_index'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $PhasesTable createAlias(String alias) {
    return $PhasesTable(attachedDatabase, alias);
  }
}

class PhasesRow extends DataClass implements Insertable<PhasesRow> {
  final int id;
  final int projectId;
  final String title;
  final String? goal;
  final int orderIndex;
  final DateTime createdAt;
  const PhasesRow({
    required this.id,
    required this.projectId,
    required this.title,
    this.goal,
    required this.orderIndex,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['project_id'] = Variable<int>(projectId);
    map['title'] = Variable<String>(title);
    if (!nullToAbsent || goal != null) {
      map['goal'] = Variable<String>(goal);
    }
    map['order_index'] = Variable<int>(orderIndex);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  PhasesCompanion toCompanion(bool nullToAbsent) {
    return PhasesCompanion(
      id: Value(id),
      projectId: Value(projectId),
      title: Value(title),
      goal: goal == null && nullToAbsent ? const Value.absent() : Value(goal),
      orderIndex: Value(orderIndex),
      createdAt: Value(createdAt),
    );
  }

  factory PhasesRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PhasesRow(
      id: serializer.fromJson<int>(json['id']),
      projectId: serializer.fromJson<int>(json['projectId']),
      title: serializer.fromJson<String>(json['title']),
      goal: serializer.fromJson<String?>(json['goal']),
      orderIndex: serializer.fromJson<int>(json['orderIndex']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'projectId': serializer.toJson<int>(projectId),
      'title': serializer.toJson<String>(title),
      'goal': serializer.toJson<String?>(goal),
      'orderIndex': serializer.toJson<int>(orderIndex),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  PhasesRow copyWith({
    int? id,
    int? projectId,
    String? title,
    Value<String?> goal = const Value.absent(),
    int? orderIndex,
    DateTime? createdAt,
  }) => PhasesRow(
    id: id ?? this.id,
    projectId: projectId ?? this.projectId,
    title: title ?? this.title,
    goal: goal.present ? goal.value : this.goal,
    orderIndex: orderIndex ?? this.orderIndex,
    createdAt: createdAt ?? this.createdAt,
  );
  PhasesRow copyWithCompanion(PhasesCompanion data) {
    return PhasesRow(
      id: data.id.present ? data.id.value : this.id,
      projectId: data.projectId.present ? data.projectId.value : this.projectId,
      title: data.title.present ? data.title.value : this.title,
      goal: data.goal.present ? data.goal.value : this.goal,
      orderIndex: data.orderIndex.present
          ? data.orderIndex.value
          : this.orderIndex,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PhasesRow(')
          ..write('id: $id, ')
          ..write('projectId: $projectId, ')
          ..write('title: $title, ')
          ..write('goal: $goal, ')
          ..write('orderIndex: $orderIndex, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, projectId, title, goal, orderIndex, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PhasesRow &&
          other.id == this.id &&
          other.projectId == this.projectId &&
          other.title == this.title &&
          other.goal == this.goal &&
          other.orderIndex == this.orderIndex &&
          other.createdAt == this.createdAt);
}

class PhasesCompanion extends UpdateCompanion<PhasesRow> {
  final Value<int> id;
  final Value<int> projectId;
  final Value<String> title;
  final Value<String?> goal;
  final Value<int> orderIndex;
  final Value<DateTime> createdAt;
  const PhasesCompanion({
    this.id = const Value.absent(),
    this.projectId = const Value.absent(),
    this.title = const Value.absent(),
    this.goal = const Value.absent(),
    this.orderIndex = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  PhasesCompanion.insert({
    this.id = const Value.absent(),
    required int projectId,
    required String title,
    this.goal = const Value.absent(),
    required int orderIndex,
    required DateTime createdAt,
  }) : projectId = Value(projectId),
       title = Value(title),
       orderIndex = Value(orderIndex),
       createdAt = Value(createdAt);
  static Insertable<PhasesRow> custom({
    Expression<int>? id,
    Expression<int>? projectId,
    Expression<String>? title,
    Expression<String>? goal,
    Expression<int>? orderIndex,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (projectId != null) 'project_id': projectId,
      if (title != null) 'title': title,
      if (goal != null) 'goal': goal,
      if (orderIndex != null) 'order_index': orderIndex,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  PhasesCompanion copyWith({
    Value<int>? id,
    Value<int>? projectId,
    Value<String>? title,
    Value<String?>? goal,
    Value<int>? orderIndex,
    Value<DateTime>? createdAt,
  }) {
    return PhasesCompanion(
      id: id ?? this.id,
      projectId: projectId ?? this.projectId,
      title: title ?? this.title,
      goal: goal ?? this.goal,
      orderIndex: orderIndex ?? this.orderIndex,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (projectId.present) {
      map['project_id'] = Variable<int>(projectId.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (goal.present) {
      map['goal'] = Variable<String>(goal.value);
    }
    if (orderIndex.present) {
      map['order_index'] = Variable<int>(orderIndex.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PhasesCompanion(')
          ..write('id: $id, ')
          ..write('projectId: $projectId, ')
          ..write('title: $title, ')
          ..write('goal: $goal, ')
          ..write('orderIndex: $orderIndex, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $MilestonesTable extends Milestones
    with TableInfo<$MilestonesTable, MilestonesRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MilestonesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _projectIdMeta = const VerificationMeta(
    'projectId',
  );
  @override
  late final GeneratedColumn<int> projectId = GeneratedColumn<int>(
    'project_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES projects (id)',
    ),
  );
  static const VerificationMeta _phaseIdMeta = const VerificationMeta(
    'phaseId',
  );
  @override
  late final GeneratedColumn<int> phaseId = GeneratedColumn<int>(
    'phase_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES phases (id)',
    ),
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 200,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _orderIndexMeta = const VerificationMeta(
    'orderIndex',
  );
  @override
  late final GeneratedColumn<int> orderIndex = GeneratedColumn<int>(
    'order_index',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _completedAtMeta = const VerificationMeta(
    'completedAt',
  );
  @override
  late final GeneratedColumn<DateTime> completedAt = GeneratedColumn<DateTime>(
    'completed_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    projectId,
    phaseId,
    title,
    orderIndex,
    completedAt,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'milestones';
  @override
  VerificationContext validateIntegrity(
    Insertable<MilestonesRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('project_id')) {
      context.handle(
        _projectIdMeta,
        projectId.isAcceptableOrUnknown(data['project_id']!, _projectIdMeta),
      );
    } else if (isInserting) {
      context.missing(_projectIdMeta);
    }
    if (data.containsKey('phase_id')) {
      context.handle(
        _phaseIdMeta,
        phaseId.isAcceptableOrUnknown(data['phase_id']!, _phaseIdMeta),
      );
    } else if (isInserting) {
      context.missing(_phaseIdMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('order_index')) {
      context.handle(
        _orderIndexMeta,
        orderIndex.isAcceptableOrUnknown(data['order_index']!, _orderIndexMeta),
      );
    } else if (isInserting) {
      context.missing(_orderIndexMeta);
    }
    if (data.containsKey('completed_at')) {
      context.handle(
        _completedAtMeta,
        completedAt.isAcceptableOrUnknown(
          data['completed_at']!,
          _completedAtMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  MilestonesRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MilestonesRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      projectId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}project_id'],
      )!,
      phaseId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}phase_id'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      orderIndex: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}order_index'],
      )!,
      completedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}completed_at'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $MilestonesTable createAlias(String alias) {
    return $MilestonesTable(attachedDatabase, alias);
  }
}

class MilestonesRow extends DataClass implements Insertable<MilestonesRow> {
  final int id;
  final int projectId;
  final int phaseId;
  final String title;
  final int orderIndex;
  final DateTime? completedAt;
  final DateTime createdAt;
  const MilestonesRow({
    required this.id,
    required this.projectId,
    required this.phaseId,
    required this.title,
    required this.orderIndex,
    this.completedAt,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['project_id'] = Variable<int>(projectId);
    map['phase_id'] = Variable<int>(phaseId);
    map['title'] = Variable<String>(title);
    map['order_index'] = Variable<int>(orderIndex);
    if (!nullToAbsent || completedAt != null) {
      map['completed_at'] = Variable<DateTime>(completedAt);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  MilestonesCompanion toCompanion(bool nullToAbsent) {
    return MilestonesCompanion(
      id: Value(id),
      projectId: Value(projectId),
      phaseId: Value(phaseId),
      title: Value(title),
      orderIndex: Value(orderIndex),
      completedAt: completedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(completedAt),
      createdAt: Value(createdAt),
    );
  }

  factory MilestonesRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MilestonesRow(
      id: serializer.fromJson<int>(json['id']),
      projectId: serializer.fromJson<int>(json['projectId']),
      phaseId: serializer.fromJson<int>(json['phaseId']),
      title: serializer.fromJson<String>(json['title']),
      orderIndex: serializer.fromJson<int>(json['orderIndex']),
      completedAt: serializer.fromJson<DateTime?>(json['completedAt']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'projectId': serializer.toJson<int>(projectId),
      'phaseId': serializer.toJson<int>(phaseId),
      'title': serializer.toJson<String>(title),
      'orderIndex': serializer.toJson<int>(orderIndex),
      'completedAt': serializer.toJson<DateTime?>(completedAt),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  MilestonesRow copyWith({
    int? id,
    int? projectId,
    int? phaseId,
    String? title,
    int? orderIndex,
    Value<DateTime?> completedAt = const Value.absent(),
    DateTime? createdAt,
  }) => MilestonesRow(
    id: id ?? this.id,
    projectId: projectId ?? this.projectId,
    phaseId: phaseId ?? this.phaseId,
    title: title ?? this.title,
    orderIndex: orderIndex ?? this.orderIndex,
    completedAt: completedAt.present ? completedAt.value : this.completedAt,
    createdAt: createdAt ?? this.createdAt,
  );
  MilestonesRow copyWithCompanion(MilestonesCompanion data) {
    return MilestonesRow(
      id: data.id.present ? data.id.value : this.id,
      projectId: data.projectId.present ? data.projectId.value : this.projectId,
      phaseId: data.phaseId.present ? data.phaseId.value : this.phaseId,
      title: data.title.present ? data.title.value : this.title,
      orderIndex: data.orderIndex.present
          ? data.orderIndex.value
          : this.orderIndex,
      completedAt: data.completedAt.present
          ? data.completedAt.value
          : this.completedAt,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MilestonesRow(')
          ..write('id: $id, ')
          ..write('projectId: $projectId, ')
          ..write('phaseId: $phaseId, ')
          ..write('title: $title, ')
          ..write('orderIndex: $orderIndex, ')
          ..write('completedAt: $completedAt, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    projectId,
    phaseId,
    title,
    orderIndex,
    completedAt,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MilestonesRow &&
          other.id == this.id &&
          other.projectId == this.projectId &&
          other.phaseId == this.phaseId &&
          other.title == this.title &&
          other.orderIndex == this.orderIndex &&
          other.completedAt == this.completedAt &&
          other.createdAt == this.createdAt);
}

class MilestonesCompanion extends UpdateCompanion<MilestonesRow> {
  final Value<int> id;
  final Value<int> projectId;
  final Value<int> phaseId;
  final Value<String> title;
  final Value<int> orderIndex;
  final Value<DateTime?> completedAt;
  final Value<DateTime> createdAt;
  const MilestonesCompanion({
    this.id = const Value.absent(),
    this.projectId = const Value.absent(),
    this.phaseId = const Value.absent(),
    this.title = const Value.absent(),
    this.orderIndex = const Value.absent(),
    this.completedAt = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  MilestonesCompanion.insert({
    this.id = const Value.absent(),
    required int projectId,
    required int phaseId,
    required String title,
    required int orderIndex,
    this.completedAt = const Value.absent(),
    required DateTime createdAt,
  }) : projectId = Value(projectId),
       phaseId = Value(phaseId),
       title = Value(title),
       orderIndex = Value(orderIndex),
       createdAt = Value(createdAt);
  static Insertable<MilestonesRow> custom({
    Expression<int>? id,
    Expression<int>? projectId,
    Expression<int>? phaseId,
    Expression<String>? title,
    Expression<int>? orderIndex,
    Expression<DateTime>? completedAt,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (projectId != null) 'project_id': projectId,
      if (phaseId != null) 'phase_id': phaseId,
      if (title != null) 'title': title,
      if (orderIndex != null) 'order_index': orderIndex,
      if (completedAt != null) 'completed_at': completedAt,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  MilestonesCompanion copyWith({
    Value<int>? id,
    Value<int>? projectId,
    Value<int>? phaseId,
    Value<String>? title,
    Value<int>? orderIndex,
    Value<DateTime?>? completedAt,
    Value<DateTime>? createdAt,
  }) {
    return MilestonesCompanion(
      id: id ?? this.id,
      projectId: projectId ?? this.projectId,
      phaseId: phaseId ?? this.phaseId,
      title: title ?? this.title,
      orderIndex: orderIndex ?? this.orderIndex,
      completedAt: completedAt ?? this.completedAt,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (projectId.present) {
      map['project_id'] = Variable<int>(projectId.value);
    }
    if (phaseId.present) {
      map['phase_id'] = Variable<int>(phaseId.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (orderIndex.present) {
      map['order_index'] = Variable<int>(orderIndex.value);
    }
    if (completedAt.present) {
      map['completed_at'] = Variable<DateTime>(completedAt.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MilestonesCompanion(')
          ..write('id: $id, ')
          ..write('projectId: $projectId, ')
          ..write('phaseId: $phaseId, ')
          ..write('title: $title, ')
          ..write('orderIndex: $orderIndex, ')
          ..write('completedAt: $completedAt, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $TasksTable extends Tasks with TableInfo<$TasksTable, TasksRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TasksTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _projectIdMeta = const VerificationMeta(
    'projectId',
  );
  @override
  late final GeneratedColumn<int> projectId = GeneratedColumn<int>(
    'project_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES projects (id)',
    ),
  );
  static const VerificationMeta _phaseIdMeta = const VerificationMeta(
    'phaseId',
  );
  @override
  late final GeneratedColumn<int> phaseId = GeneratedColumn<int>(
    'phase_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES phases (id)',
    ),
  );
  static const VerificationMeta _milestoneIdMeta = const VerificationMeta(
    'milestoneId',
  );
  @override
  late final GeneratedColumn<int> milestoneId = GeneratedColumn<int>(
    'milestone_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 300,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  late final GeneratedColumnWithTypeConverter<dom.TaskStatus, String> status =
      GeneratedColumn<String>(
        'status',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<dom.TaskStatus>($TasksTable.$converterstatus);
  @override
  late final GeneratedColumnWithTypeConverter<dom.TaskPriority, String>
  priority = GeneratedColumn<String>(
    'priority',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  ).withConverter<dom.TaskPriority>($TasksTable.$converterpriority);
  @override
  late final GeneratedColumnWithTypeConverter<dom.EstimatedEffort, String>
  effort = GeneratedColumn<String>(
    'effort',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  ).withConverter<dom.EstimatedEffort>($TasksTable.$convertereffort);
  static const VerificationMeta _dueDateMeta = const VerificationMeta(
    'dueDate',
  );
  @override
  late final GeneratedColumn<DateTime> dueDate = GeneratedColumn<DateTime>(
    'due_date',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _sourceRefIdMeta = const VerificationMeta(
    'sourceRefId',
  );
  @override
  late final GeneratedColumn<int> sourceRefId = GeneratedColumn<int>(
    'source_ref_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _outcomeNoteMeta = const VerificationMeta(
    'outcomeNote',
  );
  @override
  late final GeneratedColumn<String> outcomeNote = GeneratedColumn<String>(
    'outcome_note',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _userNoteMeta = const VerificationMeta(
    'userNote',
  );
  @override
  late final GeneratedColumn<String> userNote = GeneratedColumn<String>(
    'user_note',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _orderIndexMeta = const VerificationMeta(
    'orderIndex',
  );
  @override
  late final GeneratedColumn<int> orderIndex = GeneratedColumn<int>(
    'order_index',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    projectId,
    phaseId,
    milestoneId,
    title,
    description,
    status,
    priority,
    effort,
    dueDate,
    sourceRefId,
    outcomeNote,
    userNote,
    orderIndex,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'tasks';
  @override
  VerificationContext validateIntegrity(
    Insertable<TasksRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('project_id')) {
      context.handle(
        _projectIdMeta,
        projectId.isAcceptableOrUnknown(data['project_id']!, _projectIdMeta),
      );
    } else if (isInserting) {
      context.missing(_projectIdMeta);
    }
    if (data.containsKey('phase_id')) {
      context.handle(
        _phaseIdMeta,
        phaseId.isAcceptableOrUnknown(data['phase_id']!, _phaseIdMeta),
      );
    } else if (isInserting) {
      context.missing(_phaseIdMeta);
    }
    if (data.containsKey('milestone_id')) {
      context.handle(
        _milestoneIdMeta,
        milestoneId.isAcceptableOrUnknown(
          data['milestone_id']!,
          _milestoneIdMeta,
        ),
      );
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    }
    if (data.containsKey('due_date')) {
      context.handle(
        _dueDateMeta,
        dueDate.isAcceptableOrUnknown(data['due_date']!, _dueDateMeta),
      );
    }
    if (data.containsKey('source_ref_id')) {
      context.handle(
        _sourceRefIdMeta,
        sourceRefId.isAcceptableOrUnknown(
          data['source_ref_id']!,
          _sourceRefIdMeta,
        ),
      );
    }
    if (data.containsKey('outcome_note')) {
      context.handle(
        _outcomeNoteMeta,
        outcomeNote.isAcceptableOrUnknown(
          data['outcome_note']!,
          _outcomeNoteMeta,
        ),
      );
    }
    if (data.containsKey('user_note')) {
      context.handle(
        _userNoteMeta,
        userNote.isAcceptableOrUnknown(data['user_note']!, _userNoteMeta),
      );
    }
    if (data.containsKey('order_index')) {
      context.handle(
        _orderIndexMeta,
        orderIndex.isAcceptableOrUnknown(data['order_index']!, _orderIndexMeta),
      );
    } else if (isInserting) {
      context.missing(_orderIndexMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TasksRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TasksRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      projectId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}project_id'],
      )!,
      phaseId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}phase_id'],
      )!,
      milestoneId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}milestone_id'],
      ),
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      ),
      status: $TasksTable.$converterstatus.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}status'],
        )!,
      ),
      priority: $TasksTable.$converterpriority.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}priority'],
        )!,
      ),
      effort: $TasksTable.$convertereffort.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}effort'],
        )!,
      ),
      dueDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}due_date'],
      ),
      sourceRefId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}source_ref_id'],
      ),
      outcomeNote: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}outcome_note'],
      ),
      userNote: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}user_note'],
      ),
      orderIndex: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}order_index'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $TasksTable createAlias(String alias) {
    return $TasksTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<dom.TaskStatus, String, String> $converterstatus =
      const EnumNameConverter<dom.TaskStatus>(dom.TaskStatus.values);
  static JsonTypeConverter2<dom.TaskPriority, String, String>
  $converterpriority = const EnumNameConverter<dom.TaskPriority>(
    dom.TaskPriority.values,
  );
  static JsonTypeConverter2<dom.EstimatedEffort, String, String>
  $convertereffort = const EnumNameConverter<dom.EstimatedEffort>(
    dom.EstimatedEffort.values,
  );
}

class TasksRow extends DataClass implements Insertable<TasksRow> {
  final int id;
  final int projectId;
  final int phaseId;
  final int? milestoneId;
  final String title;
  final String? description;
  final dom.TaskStatus status;
  final dom.TaskPriority priority;
  final dom.EstimatedEffort effort;
  final DateTime? dueDate;
  final int? sourceRefId;
  final String? outcomeNote;
  final String? userNote;
  final int orderIndex;
  final DateTime createdAt;
  final DateTime updatedAt;
  const TasksRow({
    required this.id,
    required this.projectId,
    required this.phaseId,
    this.milestoneId,
    required this.title,
    this.description,
    required this.status,
    required this.priority,
    required this.effort,
    this.dueDate,
    this.sourceRefId,
    this.outcomeNote,
    this.userNote,
    required this.orderIndex,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['project_id'] = Variable<int>(projectId);
    map['phase_id'] = Variable<int>(phaseId);
    if (!nullToAbsent || milestoneId != null) {
      map['milestone_id'] = Variable<int>(milestoneId);
    }
    map['title'] = Variable<String>(title);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    {
      map['status'] = Variable<String>(
        $TasksTable.$converterstatus.toSql(status),
      );
    }
    {
      map['priority'] = Variable<String>(
        $TasksTable.$converterpriority.toSql(priority),
      );
    }
    {
      map['effort'] = Variable<String>(
        $TasksTable.$convertereffort.toSql(effort),
      );
    }
    if (!nullToAbsent || dueDate != null) {
      map['due_date'] = Variable<DateTime>(dueDate);
    }
    if (!nullToAbsent || sourceRefId != null) {
      map['source_ref_id'] = Variable<int>(sourceRefId);
    }
    if (!nullToAbsent || outcomeNote != null) {
      map['outcome_note'] = Variable<String>(outcomeNote);
    }
    if (!nullToAbsent || userNote != null) {
      map['user_note'] = Variable<String>(userNote);
    }
    map['order_index'] = Variable<int>(orderIndex);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  TasksCompanion toCompanion(bool nullToAbsent) {
    return TasksCompanion(
      id: Value(id),
      projectId: Value(projectId),
      phaseId: Value(phaseId),
      milestoneId: milestoneId == null && nullToAbsent
          ? const Value.absent()
          : Value(milestoneId),
      title: Value(title),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      status: Value(status),
      priority: Value(priority),
      effort: Value(effort),
      dueDate: dueDate == null && nullToAbsent
          ? const Value.absent()
          : Value(dueDate),
      sourceRefId: sourceRefId == null && nullToAbsent
          ? const Value.absent()
          : Value(sourceRefId),
      outcomeNote: outcomeNote == null && nullToAbsent
          ? const Value.absent()
          : Value(outcomeNote),
      userNote: userNote == null && nullToAbsent
          ? const Value.absent()
          : Value(userNote),
      orderIndex: Value(orderIndex),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory TasksRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TasksRow(
      id: serializer.fromJson<int>(json['id']),
      projectId: serializer.fromJson<int>(json['projectId']),
      phaseId: serializer.fromJson<int>(json['phaseId']),
      milestoneId: serializer.fromJson<int?>(json['milestoneId']),
      title: serializer.fromJson<String>(json['title']),
      description: serializer.fromJson<String?>(json['description']),
      status: $TasksTable.$converterstatus.fromJson(
        serializer.fromJson<String>(json['status']),
      ),
      priority: $TasksTable.$converterpriority.fromJson(
        serializer.fromJson<String>(json['priority']),
      ),
      effort: $TasksTable.$convertereffort.fromJson(
        serializer.fromJson<String>(json['effort']),
      ),
      dueDate: serializer.fromJson<DateTime?>(json['dueDate']),
      sourceRefId: serializer.fromJson<int?>(json['sourceRefId']),
      outcomeNote: serializer.fromJson<String?>(json['outcomeNote']),
      userNote: serializer.fromJson<String?>(json['userNote']),
      orderIndex: serializer.fromJson<int>(json['orderIndex']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'projectId': serializer.toJson<int>(projectId),
      'phaseId': serializer.toJson<int>(phaseId),
      'milestoneId': serializer.toJson<int?>(milestoneId),
      'title': serializer.toJson<String>(title),
      'description': serializer.toJson<String?>(description),
      'status': serializer.toJson<String>(
        $TasksTable.$converterstatus.toJson(status),
      ),
      'priority': serializer.toJson<String>(
        $TasksTable.$converterpriority.toJson(priority),
      ),
      'effort': serializer.toJson<String>(
        $TasksTable.$convertereffort.toJson(effort),
      ),
      'dueDate': serializer.toJson<DateTime?>(dueDate),
      'sourceRefId': serializer.toJson<int?>(sourceRefId),
      'outcomeNote': serializer.toJson<String?>(outcomeNote),
      'userNote': serializer.toJson<String?>(userNote),
      'orderIndex': serializer.toJson<int>(orderIndex),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  TasksRow copyWith({
    int? id,
    int? projectId,
    int? phaseId,
    Value<int?> milestoneId = const Value.absent(),
    String? title,
    Value<String?> description = const Value.absent(),
    dom.TaskStatus? status,
    dom.TaskPriority? priority,
    dom.EstimatedEffort? effort,
    Value<DateTime?> dueDate = const Value.absent(),
    Value<int?> sourceRefId = const Value.absent(),
    Value<String?> outcomeNote = const Value.absent(),
    Value<String?> userNote = const Value.absent(),
    int? orderIndex,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => TasksRow(
    id: id ?? this.id,
    projectId: projectId ?? this.projectId,
    phaseId: phaseId ?? this.phaseId,
    milestoneId: milestoneId.present ? milestoneId.value : this.milestoneId,
    title: title ?? this.title,
    description: description.present ? description.value : this.description,
    status: status ?? this.status,
    priority: priority ?? this.priority,
    effort: effort ?? this.effort,
    dueDate: dueDate.present ? dueDate.value : this.dueDate,
    sourceRefId: sourceRefId.present ? sourceRefId.value : this.sourceRefId,
    outcomeNote: outcomeNote.present ? outcomeNote.value : this.outcomeNote,
    userNote: userNote.present ? userNote.value : this.userNote,
    orderIndex: orderIndex ?? this.orderIndex,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  TasksRow copyWithCompanion(TasksCompanion data) {
    return TasksRow(
      id: data.id.present ? data.id.value : this.id,
      projectId: data.projectId.present ? data.projectId.value : this.projectId,
      phaseId: data.phaseId.present ? data.phaseId.value : this.phaseId,
      milestoneId: data.milestoneId.present
          ? data.milestoneId.value
          : this.milestoneId,
      title: data.title.present ? data.title.value : this.title,
      description: data.description.present
          ? data.description.value
          : this.description,
      status: data.status.present ? data.status.value : this.status,
      priority: data.priority.present ? data.priority.value : this.priority,
      effort: data.effort.present ? data.effort.value : this.effort,
      dueDate: data.dueDate.present ? data.dueDate.value : this.dueDate,
      sourceRefId: data.sourceRefId.present
          ? data.sourceRefId.value
          : this.sourceRefId,
      outcomeNote: data.outcomeNote.present
          ? data.outcomeNote.value
          : this.outcomeNote,
      userNote: data.userNote.present ? data.userNote.value : this.userNote,
      orderIndex: data.orderIndex.present
          ? data.orderIndex.value
          : this.orderIndex,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TasksRow(')
          ..write('id: $id, ')
          ..write('projectId: $projectId, ')
          ..write('phaseId: $phaseId, ')
          ..write('milestoneId: $milestoneId, ')
          ..write('title: $title, ')
          ..write('description: $description, ')
          ..write('status: $status, ')
          ..write('priority: $priority, ')
          ..write('effort: $effort, ')
          ..write('dueDate: $dueDate, ')
          ..write('sourceRefId: $sourceRefId, ')
          ..write('outcomeNote: $outcomeNote, ')
          ..write('userNote: $userNote, ')
          ..write('orderIndex: $orderIndex, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    projectId,
    phaseId,
    milestoneId,
    title,
    description,
    status,
    priority,
    effort,
    dueDate,
    sourceRefId,
    outcomeNote,
    userNote,
    orderIndex,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TasksRow &&
          other.id == this.id &&
          other.projectId == this.projectId &&
          other.phaseId == this.phaseId &&
          other.milestoneId == this.milestoneId &&
          other.title == this.title &&
          other.description == this.description &&
          other.status == this.status &&
          other.priority == this.priority &&
          other.effort == this.effort &&
          other.dueDate == this.dueDate &&
          other.sourceRefId == this.sourceRefId &&
          other.outcomeNote == this.outcomeNote &&
          other.userNote == this.userNote &&
          other.orderIndex == this.orderIndex &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class TasksCompanion extends UpdateCompanion<TasksRow> {
  final Value<int> id;
  final Value<int> projectId;
  final Value<int> phaseId;
  final Value<int?> milestoneId;
  final Value<String> title;
  final Value<String?> description;
  final Value<dom.TaskStatus> status;
  final Value<dom.TaskPriority> priority;
  final Value<dom.EstimatedEffort> effort;
  final Value<DateTime?> dueDate;
  final Value<int?> sourceRefId;
  final Value<String?> outcomeNote;
  final Value<String?> userNote;
  final Value<int> orderIndex;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  const TasksCompanion({
    this.id = const Value.absent(),
    this.projectId = const Value.absent(),
    this.phaseId = const Value.absent(),
    this.milestoneId = const Value.absent(),
    this.title = const Value.absent(),
    this.description = const Value.absent(),
    this.status = const Value.absent(),
    this.priority = const Value.absent(),
    this.effort = const Value.absent(),
    this.dueDate = const Value.absent(),
    this.sourceRefId = const Value.absent(),
    this.outcomeNote = const Value.absent(),
    this.userNote = const Value.absent(),
    this.orderIndex = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  TasksCompanion.insert({
    this.id = const Value.absent(),
    required int projectId,
    required int phaseId,
    this.milestoneId = const Value.absent(),
    required String title,
    this.description = const Value.absent(),
    required dom.TaskStatus status,
    required dom.TaskPriority priority,
    required dom.EstimatedEffort effort,
    this.dueDate = const Value.absent(),
    this.sourceRefId = const Value.absent(),
    this.outcomeNote = const Value.absent(),
    this.userNote = const Value.absent(),
    required int orderIndex,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) : projectId = Value(projectId),
       phaseId = Value(phaseId),
       title = Value(title),
       status = Value(status),
       priority = Value(priority),
       effort = Value(effort),
       orderIndex = Value(orderIndex),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<TasksRow> custom({
    Expression<int>? id,
    Expression<int>? projectId,
    Expression<int>? phaseId,
    Expression<int>? milestoneId,
    Expression<String>? title,
    Expression<String>? description,
    Expression<String>? status,
    Expression<String>? priority,
    Expression<String>? effort,
    Expression<DateTime>? dueDate,
    Expression<int>? sourceRefId,
    Expression<String>? outcomeNote,
    Expression<String>? userNote,
    Expression<int>? orderIndex,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (projectId != null) 'project_id': projectId,
      if (phaseId != null) 'phase_id': phaseId,
      if (milestoneId != null) 'milestone_id': milestoneId,
      if (title != null) 'title': title,
      if (description != null) 'description': description,
      if (status != null) 'status': status,
      if (priority != null) 'priority': priority,
      if (effort != null) 'effort': effort,
      if (dueDate != null) 'due_date': dueDate,
      if (sourceRefId != null) 'source_ref_id': sourceRefId,
      if (outcomeNote != null) 'outcome_note': outcomeNote,
      if (userNote != null) 'user_note': userNote,
      if (orderIndex != null) 'order_index': orderIndex,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  TasksCompanion copyWith({
    Value<int>? id,
    Value<int>? projectId,
    Value<int>? phaseId,
    Value<int?>? milestoneId,
    Value<String>? title,
    Value<String?>? description,
    Value<dom.TaskStatus>? status,
    Value<dom.TaskPriority>? priority,
    Value<dom.EstimatedEffort>? effort,
    Value<DateTime?>? dueDate,
    Value<int?>? sourceRefId,
    Value<String?>? outcomeNote,
    Value<String?>? userNote,
    Value<int>? orderIndex,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
  }) {
    return TasksCompanion(
      id: id ?? this.id,
      projectId: projectId ?? this.projectId,
      phaseId: phaseId ?? this.phaseId,
      milestoneId: milestoneId ?? this.milestoneId,
      title: title ?? this.title,
      description: description ?? this.description,
      status: status ?? this.status,
      priority: priority ?? this.priority,
      effort: effort ?? this.effort,
      dueDate: dueDate ?? this.dueDate,
      sourceRefId: sourceRefId ?? this.sourceRefId,
      outcomeNote: outcomeNote ?? this.outcomeNote,
      userNote: userNote ?? this.userNote,
      orderIndex: orderIndex ?? this.orderIndex,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (projectId.present) {
      map['project_id'] = Variable<int>(projectId.value);
    }
    if (phaseId.present) {
      map['phase_id'] = Variable<int>(phaseId.value);
    }
    if (milestoneId.present) {
      map['milestone_id'] = Variable<int>(milestoneId.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(
        $TasksTable.$converterstatus.toSql(status.value),
      );
    }
    if (priority.present) {
      map['priority'] = Variable<String>(
        $TasksTable.$converterpriority.toSql(priority.value),
      );
    }
    if (effort.present) {
      map['effort'] = Variable<String>(
        $TasksTable.$convertereffort.toSql(effort.value),
      );
    }
    if (dueDate.present) {
      map['due_date'] = Variable<DateTime>(dueDate.value);
    }
    if (sourceRefId.present) {
      map['source_ref_id'] = Variable<int>(sourceRefId.value);
    }
    if (outcomeNote.present) {
      map['outcome_note'] = Variable<String>(outcomeNote.value);
    }
    if (userNote.present) {
      map['user_note'] = Variable<String>(userNote.value);
    }
    if (orderIndex.present) {
      map['order_index'] = Variable<int>(orderIndex.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TasksCompanion(')
          ..write('id: $id, ')
          ..write('projectId: $projectId, ')
          ..write('phaseId: $phaseId, ')
          ..write('milestoneId: $milestoneId, ')
          ..write('title: $title, ')
          ..write('description: $description, ')
          ..write('status: $status, ')
          ..write('priority: $priority, ')
          ..write('effort: $effort, ')
          ..write('dueDate: $dueDate, ')
          ..write('sourceRefId: $sourceRefId, ')
          ..write('outcomeNote: $outcomeNote, ')
          ..write('userNote: $userNote, ')
          ..write('orderIndex: $orderIndex, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $TaskDependenciesTable extends TaskDependencies
    with TableInfo<$TaskDependenciesTable, TaskDependencyRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TaskDependenciesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _taskIdMeta = const VerificationMeta('taskId');
  @override
  late final GeneratedColumn<int> taskId = GeneratedColumn<int>(
    'task_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES tasks (id)',
    ),
  );
  static const VerificationMeta _dependsOnTaskIdMeta = const VerificationMeta(
    'dependsOnTaskId',
  );
  @override
  late final GeneratedColumn<int> dependsOnTaskId = GeneratedColumn<int>(
    'depends_on_task_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES tasks (id)',
    ),
  );
  @override
  List<GeneratedColumn> get $columns => [id, taskId, dependsOnTaskId];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'task_dependencies';
  @override
  VerificationContext validateIntegrity(
    Insertable<TaskDependencyRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('task_id')) {
      context.handle(
        _taskIdMeta,
        taskId.isAcceptableOrUnknown(data['task_id']!, _taskIdMeta),
      );
    } else if (isInserting) {
      context.missing(_taskIdMeta);
    }
    if (data.containsKey('depends_on_task_id')) {
      context.handle(
        _dependsOnTaskIdMeta,
        dependsOnTaskId.isAcceptableOrUnknown(
          data['depends_on_task_id']!,
          _dependsOnTaskIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_dependsOnTaskIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TaskDependencyRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TaskDependencyRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      taskId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}task_id'],
      )!,
      dependsOnTaskId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}depends_on_task_id'],
      )!,
    );
  }

  @override
  $TaskDependenciesTable createAlias(String alias) {
    return $TaskDependenciesTable(attachedDatabase, alias);
  }
}

class TaskDependencyRow extends DataClass
    implements Insertable<TaskDependencyRow> {
  final int id;
  final int taskId;
  final int dependsOnTaskId;
  const TaskDependencyRow({
    required this.id,
    required this.taskId,
    required this.dependsOnTaskId,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['task_id'] = Variable<int>(taskId);
    map['depends_on_task_id'] = Variable<int>(dependsOnTaskId);
    return map;
  }

  TaskDependenciesCompanion toCompanion(bool nullToAbsent) {
    return TaskDependenciesCompanion(
      id: Value(id),
      taskId: Value(taskId),
      dependsOnTaskId: Value(dependsOnTaskId),
    );
  }

  factory TaskDependencyRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TaskDependencyRow(
      id: serializer.fromJson<int>(json['id']),
      taskId: serializer.fromJson<int>(json['taskId']),
      dependsOnTaskId: serializer.fromJson<int>(json['dependsOnTaskId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'taskId': serializer.toJson<int>(taskId),
      'dependsOnTaskId': serializer.toJson<int>(dependsOnTaskId),
    };
  }

  TaskDependencyRow copyWith({int? id, int? taskId, int? dependsOnTaskId}) =>
      TaskDependencyRow(
        id: id ?? this.id,
        taskId: taskId ?? this.taskId,
        dependsOnTaskId: dependsOnTaskId ?? this.dependsOnTaskId,
      );
  TaskDependencyRow copyWithCompanion(TaskDependenciesCompanion data) {
    return TaskDependencyRow(
      id: data.id.present ? data.id.value : this.id,
      taskId: data.taskId.present ? data.taskId.value : this.taskId,
      dependsOnTaskId: data.dependsOnTaskId.present
          ? data.dependsOnTaskId.value
          : this.dependsOnTaskId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TaskDependencyRow(')
          ..write('id: $id, ')
          ..write('taskId: $taskId, ')
          ..write('dependsOnTaskId: $dependsOnTaskId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, taskId, dependsOnTaskId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TaskDependencyRow &&
          other.id == this.id &&
          other.taskId == this.taskId &&
          other.dependsOnTaskId == this.dependsOnTaskId);
}

class TaskDependenciesCompanion extends UpdateCompanion<TaskDependencyRow> {
  final Value<int> id;
  final Value<int> taskId;
  final Value<int> dependsOnTaskId;
  const TaskDependenciesCompanion({
    this.id = const Value.absent(),
    this.taskId = const Value.absent(),
    this.dependsOnTaskId = const Value.absent(),
  });
  TaskDependenciesCompanion.insert({
    this.id = const Value.absent(),
    required int taskId,
    required int dependsOnTaskId,
  }) : taskId = Value(taskId),
       dependsOnTaskId = Value(dependsOnTaskId);
  static Insertable<TaskDependencyRow> custom({
    Expression<int>? id,
    Expression<int>? taskId,
    Expression<int>? dependsOnTaskId,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (taskId != null) 'task_id': taskId,
      if (dependsOnTaskId != null) 'depends_on_task_id': dependsOnTaskId,
    });
  }

  TaskDependenciesCompanion copyWith({
    Value<int>? id,
    Value<int>? taskId,
    Value<int>? dependsOnTaskId,
  }) {
    return TaskDependenciesCompanion(
      id: id ?? this.id,
      taskId: taskId ?? this.taskId,
      dependsOnTaskId: dependsOnTaskId ?? this.dependsOnTaskId,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (taskId.present) {
      map['task_id'] = Variable<int>(taskId.value);
    }
    if (dependsOnTaskId.present) {
      map['depends_on_task_id'] = Variable<int>(dependsOnTaskId.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TaskDependenciesCompanion(')
          ..write('id: $id, ')
          ..write('taskId: $taskId, ')
          ..write('dependsOnTaskId: $dependsOnTaskId')
          ..write(')'))
        .toString();
  }
}

class $SourceRefsTable extends SourceRefs
    with TableInfo<$SourceRefsTable, SourceRefRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SourceRefsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  @override
  late final GeneratedColumnWithTypeConverter<dom.SourceKind, String> kind =
      GeneratedColumn<String>(
        'kind',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<dom.SourceKind>($SourceRefsTable.$converterkind);
  static const VerificationMeta _quoteMeta = const VerificationMeta('quote');
  @override
  late final GeneratedColumn<String> quote = GeneratedColumn<String>(
    'quote',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _aiReasonMeta = const VerificationMeta(
    'aiReason',
  );
  @override
  late final GeneratedColumn<String> aiReason = GeneratedColumn<String>(
    'ai_reason',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _documentIdMeta = const VerificationMeta(
    'documentId',
  );
  @override
  late final GeneratedColumn<int> documentId = GeneratedColumn<int>(
    'document_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    kind,
    quote,
    aiReason,
    documentId,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'source_refs';
  @override
  VerificationContext validateIntegrity(
    Insertable<SourceRefRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('quote')) {
      context.handle(
        _quoteMeta,
        quote.isAcceptableOrUnknown(data['quote']!, _quoteMeta),
      );
    } else if (isInserting) {
      context.missing(_quoteMeta);
    }
    if (data.containsKey('ai_reason')) {
      context.handle(
        _aiReasonMeta,
        aiReason.isAcceptableOrUnknown(data['ai_reason']!, _aiReasonMeta),
      );
    }
    if (data.containsKey('document_id')) {
      context.handle(
        _documentIdMeta,
        documentId.isAcceptableOrUnknown(data['document_id']!, _documentIdMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SourceRefRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SourceRefRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      kind: $SourceRefsTable.$converterkind.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}kind'],
        )!,
      ),
      quote: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}quote'],
      )!,
      aiReason: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}ai_reason'],
      )!,
      documentId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}document_id'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $SourceRefsTable createAlias(String alias) {
    return $SourceRefsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<dom.SourceKind, String, String> $converterkind =
      const EnumNameConverter<dom.SourceKind>(dom.SourceKind.values);
}

class SourceRefRow extends DataClass implements Insertable<SourceRefRow> {
  final int id;
  final dom.SourceKind kind;
  final String quote;
  final String aiReason;
  final int? documentId;
  final DateTime createdAt;
  const SourceRefRow({
    required this.id,
    required this.kind,
    required this.quote,
    required this.aiReason,
    this.documentId,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    {
      map['kind'] = Variable<String>(
        $SourceRefsTable.$converterkind.toSql(kind),
      );
    }
    map['quote'] = Variable<String>(quote);
    map['ai_reason'] = Variable<String>(aiReason);
    if (!nullToAbsent || documentId != null) {
      map['document_id'] = Variable<int>(documentId);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  SourceRefsCompanion toCompanion(bool nullToAbsent) {
    return SourceRefsCompanion(
      id: Value(id),
      kind: Value(kind),
      quote: Value(quote),
      aiReason: Value(aiReason),
      documentId: documentId == null && nullToAbsent
          ? const Value.absent()
          : Value(documentId),
      createdAt: Value(createdAt),
    );
  }

  factory SourceRefRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SourceRefRow(
      id: serializer.fromJson<int>(json['id']),
      kind: $SourceRefsTable.$converterkind.fromJson(
        serializer.fromJson<String>(json['kind']),
      ),
      quote: serializer.fromJson<String>(json['quote']),
      aiReason: serializer.fromJson<String>(json['aiReason']),
      documentId: serializer.fromJson<int?>(json['documentId']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'kind': serializer.toJson<String>(
        $SourceRefsTable.$converterkind.toJson(kind),
      ),
      'quote': serializer.toJson<String>(quote),
      'aiReason': serializer.toJson<String>(aiReason),
      'documentId': serializer.toJson<int?>(documentId),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  SourceRefRow copyWith({
    int? id,
    dom.SourceKind? kind,
    String? quote,
    String? aiReason,
    Value<int?> documentId = const Value.absent(),
    DateTime? createdAt,
  }) => SourceRefRow(
    id: id ?? this.id,
    kind: kind ?? this.kind,
    quote: quote ?? this.quote,
    aiReason: aiReason ?? this.aiReason,
    documentId: documentId.present ? documentId.value : this.documentId,
    createdAt: createdAt ?? this.createdAt,
  );
  SourceRefRow copyWithCompanion(SourceRefsCompanion data) {
    return SourceRefRow(
      id: data.id.present ? data.id.value : this.id,
      kind: data.kind.present ? data.kind.value : this.kind,
      quote: data.quote.present ? data.quote.value : this.quote,
      aiReason: data.aiReason.present ? data.aiReason.value : this.aiReason,
      documentId: data.documentId.present
          ? data.documentId.value
          : this.documentId,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SourceRefRow(')
          ..write('id: $id, ')
          ..write('kind: $kind, ')
          ..write('quote: $quote, ')
          ..write('aiReason: $aiReason, ')
          ..write('documentId: $documentId, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, kind, quote, aiReason, documentId, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SourceRefRow &&
          other.id == this.id &&
          other.kind == this.kind &&
          other.quote == this.quote &&
          other.aiReason == this.aiReason &&
          other.documentId == this.documentId &&
          other.createdAt == this.createdAt);
}

class SourceRefsCompanion extends UpdateCompanion<SourceRefRow> {
  final Value<int> id;
  final Value<dom.SourceKind> kind;
  final Value<String> quote;
  final Value<String> aiReason;
  final Value<int?> documentId;
  final Value<DateTime> createdAt;
  const SourceRefsCompanion({
    this.id = const Value.absent(),
    this.kind = const Value.absent(),
    this.quote = const Value.absent(),
    this.aiReason = const Value.absent(),
    this.documentId = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  SourceRefsCompanion.insert({
    this.id = const Value.absent(),
    required dom.SourceKind kind,
    required String quote,
    this.aiReason = const Value.absent(),
    this.documentId = const Value.absent(),
    required DateTime createdAt,
  }) : kind = Value(kind),
       quote = Value(quote),
       createdAt = Value(createdAt);
  static Insertable<SourceRefRow> custom({
    Expression<int>? id,
    Expression<String>? kind,
    Expression<String>? quote,
    Expression<String>? aiReason,
    Expression<int>? documentId,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (kind != null) 'kind': kind,
      if (quote != null) 'quote': quote,
      if (aiReason != null) 'ai_reason': aiReason,
      if (documentId != null) 'document_id': documentId,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  SourceRefsCompanion copyWith({
    Value<int>? id,
    Value<dom.SourceKind>? kind,
    Value<String>? quote,
    Value<String>? aiReason,
    Value<int?>? documentId,
    Value<DateTime>? createdAt,
  }) {
    return SourceRefsCompanion(
      id: id ?? this.id,
      kind: kind ?? this.kind,
      quote: quote ?? this.quote,
      aiReason: aiReason ?? this.aiReason,
      documentId: documentId ?? this.documentId,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (kind.present) {
      map['kind'] = Variable<String>(
        $SourceRefsTable.$converterkind.toSql(kind.value),
      );
    }
    if (quote.present) {
      map['quote'] = Variable<String>(quote.value);
    }
    if (aiReason.present) {
      map['ai_reason'] = Variable<String>(aiReason.value);
    }
    if (documentId.present) {
      map['document_id'] = Variable<int>(documentId.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SourceRefsCompanion(')
          ..write('id: $id, ')
          ..write('kind: $kind, ')
          ..write('quote: $quote, ')
          ..write('aiReason: $aiReason, ')
          ..write('documentId: $documentId, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $WeekSettingsTable extends WeekSettings
    with TableInfo<$WeekSettingsTable, WeekSettingRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $WeekSettingsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _weekStartMeta = const VerificationMeta(
    'weekStart',
  );
  @override
  late final GeneratedColumn<DateTime> weekStart = GeneratedColumn<DateTime>(
    'week_start',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  @override
  late final GeneratedColumnWithTypeConverter<dom.CapacityLevel, String>
  capacity = GeneratedColumn<String>(
    'capacity',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  ).withConverter<dom.CapacityLevel>($WeekSettingsTable.$convertercapacity);
  @override
  List<GeneratedColumn> get $columns => [id, weekStart, capacity];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'week_settings';
  @override
  VerificationContext validateIntegrity(
    Insertable<WeekSettingRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('week_start')) {
      context.handle(
        _weekStartMeta,
        weekStart.isAcceptableOrUnknown(data['week_start']!, _weekStartMeta),
      );
    } else if (isInserting) {
      context.missing(_weekStartMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  WeekSettingRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return WeekSettingRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      weekStart: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}week_start'],
      )!,
      capacity: $WeekSettingsTable.$convertercapacity.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}capacity'],
        )!,
      ),
    );
  }

  @override
  $WeekSettingsTable createAlias(String alias) {
    return $WeekSettingsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<dom.CapacityLevel, String, String>
  $convertercapacity = const EnumNameConverter<dom.CapacityLevel>(
    dom.CapacityLevel.values,
  );
}

class WeekSettingRow extends DataClass implements Insertable<WeekSettingRow> {
  final int id;
  final DateTime weekStart;
  final dom.CapacityLevel capacity;
  const WeekSettingRow({
    required this.id,
    required this.weekStart,
    required this.capacity,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['week_start'] = Variable<DateTime>(weekStart);
    {
      map['capacity'] = Variable<String>(
        $WeekSettingsTable.$convertercapacity.toSql(capacity),
      );
    }
    return map;
  }

  WeekSettingsCompanion toCompanion(bool nullToAbsent) {
    return WeekSettingsCompanion(
      id: Value(id),
      weekStart: Value(weekStart),
      capacity: Value(capacity),
    );
  }

  factory WeekSettingRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return WeekSettingRow(
      id: serializer.fromJson<int>(json['id']),
      weekStart: serializer.fromJson<DateTime>(json['weekStart']),
      capacity: $WeekSettingsTable.$convertercapacity.fromJson(
        serializer.fromJson<String>(json['capacity']),
      ),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'weekStart': serializer.toJson<DateTime>(weekStart),
      'capacity': serializer.toJson<String>(
        $WeekSettingsTable.$convertercapacity.toJson(capacity),
      ),
    };
  }

  WeekSettingRow copyWith({
    int? id,
    DateTime? weekStart,
    dom.CapacityLevel? capacity,
  }) => WeekSettingRow(
    id: id ?? this.id,
    weekStart: weekStart ?? this.weekStart,
    capacity: capacity ?? this.capacity,
  );
  WeekSettingRow copyWithCompanion(WeekSettingsCompanion data) {
    return WeekSettingRow(
      id: data.id.present ? data.id.value : this.id,
      weekStart: data.weekStart.present ? data.weekStart.value : this.weekStart,
      capacity: data.capacity.present ? data.capacity.value : this.capacity,
    );
  }

  @override
  String toString() {
    return (StringBuffer('WeekSettingRow(')
          ..write('id: $id, ')
          ..write('weekStart: $weekStart, ')
          ..write('capacity: $capacity')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, weekStart, capacity);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is WeekSettingRow &&
          other.id == this.id &&
          other.weekStart == this.weekStart &&
          other.capacity == this.capacity);
}

class WeekSettingsCompanion extends UpdateCompanion<WeekSettingRow> {
  final Value<int> id;
  final Value<DateTime> weekStart;
  final Value<dom.CapacityLevel> capacity;
  const WeekSettingsCompanion({
    this.id = const Value.absent(),
    this.weekStart = const Value.absent(),
    this.capacity = const Value.absent(),
  });
  WeekSettingsCompanion.insert({
    this.id = const Value.absent(),
    required DateTime weekStart,
    required dom.CapacityLevel capacity,
  }) : weekStart = Value(weekStart),
       capacity = Value(capacity);
  static Insertable<WeekSettingRow> custom({
    Expression<int>? id,
    Expression<DateTime>? weekStart,
    Expression<String>? capacity,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (weekStart != null) 'week_start': weekStart,
      if (capacity != null) 'capacity': capacity,
    });
  }

  WeekSettingsCompanion copyWith({
    Value<int>? id,
    Value<DateTime>? weekStart,
    Value<dom.CapacityLevel>? capacity,
  }) {
    return WeekSettingsCompanion(
      id: id ?? this.id,
      weekStart: weekStart ?? this.weekStart,
      capacity: capacity ?? this.capacity,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (weekStart.present) {
      map['week_start'] = Variable<DateTime>(weekStart.value);
    }
    if (capacity.present) {
      map['capacity'] = Variable<String>(
        $WeekSettingsTable.$convertercapacity.toSql(capacity.value),
      );
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('WeekSettingsCompanion(')
          ..write('id: $id, ')
          ..write('weekStart: $weekStart, ')
          ..write('capacity: $capacity')
          ..write(')'))
        .toString();
  }
}

class $WeeklyAssignmentsTable extends WeeklyAssignments
    with TableInfo<$WeeklyAssignmentsTable, WeeklyAssignmentRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $WeeklyAssignmentsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _weekStartMeta = const VerificationMeta(
    'weekStart',
  );
  @override
  late final GeneratedColumn<DateTime> weekStart = GeneratedColumn<DateTime>(
    'week_start',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _taskIdMeta = const VerificationMeta('taskId');
  @override
  late final GeneratedColumn<int> taskId = GeneratedColumn<int>(
    'task_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES tasks (id)',
    ),
  );
  static const VerificationMeta _projectIdMeta = const VerificationMeta(
    'projectId',
  );
  @override
  late final GeneratedColumn<int> projectId = GeneratedColumn<int>(
    'project_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES projects (id)',
    ),
  );
  static const VerificationMeta _addedAtMeta = const VerificationMeta(
    'addedAt',
  );
  @override
  late final GeneratedColumn<DateTime> addedAt = GeneratedColumn<DateTime>(
    'added_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    weekStart,
    taskId,
    projectId,
    addedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'weekly_assignments';
  @override
  VerificationContext validateIntegrity(
    Insertable<WeeklyAssignmentRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('week_start')) {
      context.handle(
        _weekStartMeta,
        weekStart.isAcceptableOrUnknown(data['week_start']!, _weekStartMeta),
      );
    } else if (isInserting) {
      context.missing(_weekStartMeta);
    }
    if (data.containsKey('task_id')) {
      context.handle(
        _taskIdMeta,
        taskId.isAcceptableOrUnknown(data['task_id']!, _taskIdMeta),
      );
    } else if (isInserting) {
      context.missing(_taskIdMeta);
    }
    if (data.containsKey('project_id')) {
      context.handle(
        _projectIdMeta,
        projectId.isAcceptableOrUnknown(data['project_id']!, _projectIdMeta),
      );
    } else if (isInserting) {
      context.missing(_projectIdMeta);
    }
    if (data.containsKey('added_at')) {
      context.handle(
        _addedAtMeta,
        addedAt.isAcceptableOrUnknown(data['added_at']!, _addedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_addedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  WeeklyAssignmentRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return WeeklyAssignmentRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      weekStart: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}week_start'],
      )!,
      taskId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}task_id'],
      )!,
      projectId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}project_id'],
      )!,
      addedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}added_at'],
      )!,
    );
  }

  @override
  $WeeklyAssignmentsTable createAlias(String alias) {
    return $WeeklyAssignmentsTable(attachedDatabase, alias);
  }
}

class WeeklyAssignmentRow extends DataClass
    implements Insertable<WeeklyAssignmentRow> {
  final int id;
  final DateTime weekStart;
  final int taskId;
  final int projectId;
  final DateTime addedAt;
  const WeeklyAssignmentRow({
    required this.id,
    required this.weekStart,
    required this.taskId,
    required this.projectId,
    required this.addedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['week_start'] = Variable<DateTime>(weekStart);
    map['task_id'] = Variable<int>(taskId);
    map['project_id'] = Variable<int>(projectId);
    map['added_at'] = Variable<DateTime>(addedAt);
    return map;
  }

  WeeklyAssignmentsCompanion toCompanion(bool nullToAbsent) {
    return WeeklyAssignmentsCompanion(
      id: Value(id),
      weekStart: Value(weekStart),
      taskId: Value(taskId),
      projectId: Value(projectId),
      addedAt: Value(addedAt),
    );
  }

  factory WeeklyAssignmentRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return WeeklyAssignmentRow(
      id: serializer.fromJson<int>(json['id']),
      weekStart: serializer.fromJson<DateTime>(json['weekStart']),
      taskId: serializer.fromJson<int>(json['taskId']),
      projectId: serializer.fromJson<int>(json['projectId']),
      addedAt: serializer.fromJson<DateTime>(json['addedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'weekStart': serializer.toJson<DateTime>(weekStart),
      'taskId': serializer.toJson<int>(taskId),
      'projectId': serializer.toJson<int>(projectId),
      'addedAt': serializer.toJson<DateTime>(addedAt),
    };
  }

  WeeklyAssignmentRow copyWith({
    int? id,
    DateTime? weekStart,
    int? taskId,
    int? projectId,
    DateTime? addedAt,
  }) => WeeklyAssignmentRow(
    id: id ?? this.id,
    weekStart: weekStart ?? this.weekStart,
    taskId: taskId ?? this.taskId,
    projectId: projectId ?? this.projectId,
    addedAt: addedAt ?? this.addedAt,
  );
  WeeklyAssignmentRow copyWithCompanion(WeeklyAssignmentsCompanion data) {
    return WeeklyAssignmentRow(
      id: data.id.present ? data.id.value : this.id,
      weekStart: data.weekStart.present ? data.weekStart.value : this.weekStart,
      taskId: data.taskId.present ? data.taskId.value : this.taskId,
      projectId: data.projectId.present ? data.projectId.value : this.projectId,
      addedAt: data.addedAt.present ? data.addedAt.value : this.addedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('WeeklyAssignmentRow(')
          ..write('id: $id, ')
          ..write('weekStart: $weekStart, ')
          ..write('taskId: $taskId, ')
          ..write('projectId: $projectId, ')
          ..write('addedAt: $addedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, weekStart, taskId, projectId, addedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is WeeklyAssignmentRow &&
          other.id == this.id &&
          other.weekStart == this.weekStart &&
          other.taskId == this.taskId &&
          other.projectId == this.projectId &&
          other.addedAt == this.addedAt);
}

class WeeklyAssignmentsCompanion extends UpdateCompanion<WeeklyAssignmentRow> {
  final Value<int> id;
  final Value<DateTime> weekStart;
  final Value<int> taskId;
  final Value<int> projectId;
  final Value<DateTime> addedAt;
  const WeeklyAssignmentsCompanion({
    this.id = const Value.absent(),
    this.weekStart = const Value.absent(),
    this.taskId = const Value.absent(),
    this.projectId = const Value.absent(),
    this.addedAt = const Value.absent(),
  });
  WeeklyAssignmentsCompanion.insert({
    this.id = const Value.absent(),
    required DateTime weekStart,
    required int taskId,
    required int projectId,
    required DateTime addedAt,
  }) : weekStart = Value(weekStart),
       taskId = Value(taskId),
       projectId = Value(projectId),
       addedAt = Value(addedAt);
  static Insertable<WeeklyAssignmentRow> custom({
    Expression<int>? id,
    Expression<DateTime>? weekStart,
    Expression<int>? taskId,
    Expression<int>? projectId,
    Expression<DateTime>? addedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (weekStart != null) 'week_start': weekStart,
      if (taskId != null) 'task_id': taskId,
      if (projectId != null) 'project_id': projectId,
      if (addedAt != null) 'added_at': addedAt,
    });
  }

  WeeklyAssignmentsCompanion copyWith({
    Value<int>? id,
    Value<DateTime>? weekStart,
    Value<int>? taskId,
    Value<int>? projectId,
    Value<DateTime>? addedAt,
  }) {
    return WeeklyAssignmentsCompanion(
      id: id ?? this.id,
      weekStart: weekStart ?? this.weekStart,
      taskId: taskId ?? this.taskId,
      projectId: projectId ?? this.projectId,
      addedAt: addedAt ?? this.addedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (weekStart.present) {
      map['week_start'] = Variable<DateTime>(weekStart.value);
    }
    if (taskId.present) {
      map['task_id'] = Variable<int>(taskId.value);
    }
    if (projectId.present) {
      map['project_id'] = Variable<int>(projectId.value);
    }
    if (addedAt.present) {
      map['added_at'] = Variable<DateTime>(addedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('WeeklyAssignmentsCompanion(')
          ..write('id: $id, ')
          ..write('weekStart: $weekStart, ')
          ..write('taskId: $taskId, ')
          ..write('projectId: $projectId, ')
          ..write('addedAt: $addedAt')
          ..write(')'))
        .toString();
  }
}

class $InboxItemsTable extends InboxItems
    with TableInfo<$InboxItemsTable, InboxItemRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $InboxItemsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  @override
  late final GeneratedColumnWithTypeConverter<dom.InboxKind, String> kind =
      GeneratedColumn<String>(
        'kind',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<dom.InboxKind>($InboxItemsTable.$converterkind);
  static const VerificationMeta _contentMeta = const VerificationMeta(
    'content',
  );
  @override
  late final GeneratedColumn<String> content = GeneratedColumn<String>(
    'content',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _filePathMeta = const VerificationMeta(
    'filePath',
  );
  @override
  late final GeneratedColumn<String> filePath = GeneratedColumn<String>(
    'file_path',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  late final GeneratedColumnWithTypeConverter<dom.InboxStatus, String> status =
      GeneratedColumn<String>(
        'status',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<dom.InboxStatus>($InboxItemsTable.$converterstatus);
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    kind,
    content,
    filePath,
    status,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'inbox_items';
  @override
  VerificationContext validateIntegrity(
    Insertable<InboxItemRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('content')) {
      context.handle(
        _contentMeta,
        content.isAcceptableOrUnknown(data['content']!, _contentMeta),
      );
    } else if (isInserting) {
      context.missing(_contentMeta);
    }
    if (data.containsKey('file_path')) {
      context.handle(
        _filePathMeta,
        filePath.isAcceptableOrUnknown(data['file_path']!, _filePathMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  InboxItemRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return InboxItemRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      kind: $InboxItemsTable.$converterkind.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}kind'],
        )!,
      ),
      content: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}content'],
      )!,
      filePath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}file_path'],
      ),
      status: $InboxItemsTable.$converterstatus.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}status'],
        )!,
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $InboxItemsTable createAlias(String alias) {
    return $InboxItemsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<dom.InboxKind, String, String> $converterkind =
      const EnumNameConverter<dom.InboxKind>(dom.InboxKind.values);
  static JsonTypeConverter2<dom.InboxStatus, String, String> $converterstatus =
      const EnumNameConverter<dom.InboxStatus>(dom.InboxStatus.values);
}

class InboxItemRow extends DataClass implements Insertable<InboxItemRow> {
  final int id;
  final dom.InboxKind kind;
  final String content;
  final String? filePath;
  final dom.InboxStatus status;
  final DateTime createdAt;
  const InboxItemRow({
    required this.id,
    required this.kind,
    required this.content,
    this.filePath,
    required this.status,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    {
      map['kind'] = Variable<String>(
        $InboxItemsTable.$converterkind.toSql(kind),
      );
    }
    map['content'] = Variable<String>(content);
    if (!nullToAbsent || filePath != null) {
      map['file_path'] = Variable<String>(filePath);
    }
    {
      map['status'] = Variable<String>(
        $InboxItemsTable.$converterstatus.toSql(status),
      );
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  InboxItemsCompanion toCompanion(bool nullToAbsent) {
    return InboxItemsCompanion(
      id: Value(id),
      kind: Value(kind),
      content: Value(content),
      filePath: filePath == null && nullToAbsent
          ? const Value.absent()
          : Value(filePath),
      status: Value(status),
      createdAt: Value(createdAt),
    );
  }

  factory InboxItemRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return InboxItemRow(
      id: serializer.fromJson<int>(json['id']),
      kind: $InboxItemsTable.$converterkind.fromJson(
        serializer.fromJson<String>(json['kind']),
      ),
      content: serializer.fromJson<String>(json['content']),
      filePath: serializer.fromJson<String?>(json['filePath']),
      status: $InboxItemsTable.$converterstatus.fromJson(
        serializer.fromJson<String>(json['status']),
      ),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'kind': serializer.toJson<String>(
        $InboxItemsTable.$converterkind.toJson(kind),
      ),
      'content': serializer.toJson<String>(content),
      'filePath': serializer.toJson<String?>(filePath),
      'status': serializer.toJson<String>(
        $InboxItemsTable.$converterstatus.toJson(status),
      ),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  InboxItemRow copyWith({
    int? id,
    dom.InboxKind? kind,
    String? content,
    Value<String?> filePath = const Value.absent(),
    dom.InboxStatus? status,
    DateTime? createdAt,
  }) => InboxItemRow(
    id: id ?? this.id,
    kind: kind ?? this.kind,
    content: content ?? this.content,
    filePath: filePath.present ? filePath.value : this.filePath,
    status: status ?? this.status,
    createdAt: createdAt ?? this.createdAt,
  );
  InboxItemRow copyWithCompanion(InboxItemsCompanion data) {
    return InboxItemRow(
      id: data.id.present ? data.id.value : this.id,
      kind: data.kind.present ? data.kind.value : this.kind,
      content: data.content.present ? data.content.value : this.content,
      filePath: data.filePath.present ? data.filePath.value : this.filePath,
      status: data.status.present ? data.status.value : this.status,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('InboxItemRow(')
          ..write('id: $id, ')
          ..write('kind: $kind, ')
          ..write('content: $content, ')
          ..write('filePath: $filePath, ')
          ..write('status: $status, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, kind, content, filePath, status, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is InboxItemRow &&
          other.id == this.id &&
          other.kind == this.kind &&
          other.content == this.content &&
          other.filePath == this.filePath &&
          other.status == this.status &&
          other.createdAt == this.createdAt);
}

class InboxItemsCompanion extends UpdateCompanion<InboxItemRow> {
  final Value<int> id;
  final Value<dom.InboxKind> kind;
  final Value<String> content;
  final Value<String?> filePath;
  final Value<dom.InboxStatus> status;
  final Value<DateTime> createdAt;
  const InboxItemsCompanion({
    this.id = const Value.absent(),
    this.kind = const Value.absent(),
    this.content = const Value.absent(),
    this.filePath = const Value.absent(),
    this.status = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  InboxItemsCompanion.insert({
    this.id = const Value.absent(),
    required dom.InboxKind kind,
    required String content,
    this.filePath = const Value.absent(),
    required dom.InboxStatus status,
    required DateTime createdAt,
  }) : kind = Value(kind),
       content = Value(content),
       status = Value(status),
       createdAt = Value(createdAt);
  static Insertable<InboxItemRow> custom({
    Expression<int>? id,
    Expression<String>? kind,
    Expression<String>? content,
    Expression<String>? filePath,
    Expression<String>? status,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (kind != null) 'kind': kind,
      if (content != null) 'content': content,
      if (filePath != null) 'file_path': filePath,
      if (status != null) 'status': status,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  InboxItemsCompanion copyWith({
    Value<int>? id,
    Value<dom.InboxKind>? kind,
    Value<String>? content,
    Value<String?>? filePath,
    Value<dom.InboxStatus>? status,
    Value<DateTime>? createdAt,
  }) {
    return InboxItemsCompanion(
      id: id ?? this.id,
      kind: kind ?? this.kind,
      content: content ?? this.content,
      filePath: filePath ?? this.filePath,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (kind.present) {
      map['kind'] = Variable<String>(
        $InboxItemsTable.$converterkind.toSql(kind.value),
      );
    }
    if (content.present) {
      map['content'] = Variable<String>(content.value);
    }
    if (filePath.present) {
      map['file_path'] = Variable<String>(filePath.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(
        $InboxItemsTable.$converterstatus.toSql(status.value),
      );
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('InboxItemsCompanion(')
          ..write('id: $id, ')
          ..write('kind: $kind, ')
          ..write('content: $content, ')
          ..write('filePath: $filePath, ')
          ..write('status: $status, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $SourceDocumentsTable extends SourceDocuments
    with TableInfo<$SourceDocumentsTable, SourceDocumentRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SourceDocumentsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _fileNameMeta = const VerificationMeta(
    'fileName',
  );
  @override
  late final GeneratedColumn<String> fileName = GeneratedColumn<String>(
    'file_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _fileKindMeta = const VerificationMeta(
    'fileKind',
  );
  @override
  late final GeneratedColumn<String> fileKind = GeneratedColumn<String>(
    'file_kind',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _filePathMeta = const VerificationMeta(
    'filePath',
  );
  @override
  late final GeneratedColumn<String> filePath = GeneratedColumn<String>(
    'file_path',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _extractedTextMeta = const VerificationMeta(
    'extractedText',
  );
  @override
  late final GeneratedColumn<String> extractedText = GeneratedColumn<String>(
    'extracted_text',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _importedAtMeta = const VerificationMeta(
    'importedAt',
  );
  @override
  late final GeneratedColumn<DateTime> importedAt = GeneratedColumn<DateTime>(
    'imported_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    fileName,
    fileKind,
    filePath,
    extractedText,
    importedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'source_documents';
  @override
  VerificationContext validateIntegrity(
    Insertable<SourceDocumentRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('file_name')) {
      context.handle(
        _fileNameMeta,
        fileName.isAcceptableOrUnknown(data['file_name']!, _fileNameMeta),
      );
    } else if (isInserting) {
      context.missing(_fileNameMeta);
    }
    if (data.containsKey('file_kind')) {
      context.handle(
        _fileKindMeta,
        fileKind.isAcceptableOrUnknown(data['file_kind']!, _fileKindMeta),
      );
    } else if (isInserting) {
      context.missing(_fileKindMeta);
    }
    if (data.containsKey('file_path')) {
      context.handle(
        _filePathMeta,
        filePath.isAcceptableOrUnknown(data['file_path']!, _filePathMeta),
      );
    }
    if (data.containsKey('extracted_text')) {
      context.handle(
        _extractedTextMeta,
        extractedText.isAcceptableOrUnknown(
          data['extracted_text']!,
          _extractedTextMeta,
        ),
      );
    }
    if (data.containsKey('imported_at')) {
      context.handle(
        _importedAtMeta,
        importedAt.isAcceptableOrUnknown(data['imported_at']!, _importedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_importedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SourceDocumentRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SourceDocumentRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      fileName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}file_name'],
      )!,
      fileKind: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}file_kind'],
      )!,
      filePath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}file_path'],
      ),
      extractedText: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}extracted_text'],
      ),
      importedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}imported_at'],
      )!,
    );
  }

  @override
  $SourceDocumentsTable createAlias(String alias) {
    return $SourceDocumentsTable(attachedDatabase, alias);
  }
}

class SourceDocumentRow extends DataClass
    implements Insertable<SourceDocumentRow> {
  final int id;
  final String fileName;
  final String fileKind;
  final String? filePath;
  final String? extractedText;
  final DateTime importedAt;
  const SourceDocumentRow({
    required this.id,
    required this.fileName,
    required this.fileKind,
    this.filePath,
    this.extractedText,
    required this.importedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['file_name'] = Variable<String>(fileName);
    map['file_kind'] = Variable<String>(fileKind);
    if (!nullToAbsent || filePath != null) {
      map['file_path'] = Variable<String>(filePath);
    }
    if (!nullToAbsent || extractedText != null) {
      map['extracted_text'] = Variable<String>(extractedText);
    }
    map['imported_at'] = Variable<DateTime>(importedAt);
    return map;
  }

  SourceDocumentsCompanion toCompanion(bool nullToAbsent) {
    return SourceDocumentsCompanion(
      id: Value(id),
      fileName: Value(fileName),
      fileKind: Value(fileKind),
      filePath: filePath == null && nullToAbsent
          ? const Value.absent()
          : Value(filePath),
      extractedText: extractedText == null && nullToAbsent
          ? const Value.absent()
          : Value(extractedText),
      importedAt: Value(importedAt),
    );
  }

  factory SourceDocumentRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SourceDocumentRow(
      id: serializer.fromJson<int>(json['id']),
      fileName: serializer.fromJson<String>(json['fileName']),
      fileKind: serializer.fromJson<String>(json['fileKind']),
      filePath: serializer.fromJson<String?>(json['filePath']),
      extractedText: serializer.fromJson<String?>(json['extractedText']),
      importedAt: serializer.fromJson<DateTime>(json['importedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'fileName': serializer.toJson<String>(fileName),
      'fileKind': serializer.toJson<String>(fileKind),
      'filePath': serializer.toJson<String?>(filePath),
      'extractedText': serializer.toJson<String?>(extractedText),
      'importedAt': serializer.toJson<DateTime>(importedAt),
    };
  }

  SourceDocumentRow copyWith({
    int? id,
    String? fileName,
    String? fileKind,
    Value<String?> filePath = const Value.absent(),
    Value<String?> extractedText = const Value.absent(),
    DateTime? importedAt,
  }) => SourceDocumentRow(
    id: id ?? this.id,
    fileName: fileName ?? this.fileName,
    fileKind: fileKind ?? this.fileKind,
    filePath: filePath.present ? filePath.value : this.filePath,
    extractedText: extractedText.present
        ? extractedText.value
        : this.extractedText,
    importedAt: importedAt ?? this.importedAt,
  );
  SourceDocumentRow copyWithCompanion(SourceDocumentsCompanion data) {
    return SourceDocumentRow(
      id: data.id.present ? data.id.value : this.id,
      fileName: data.fileName.present ? data.fileName.value : this.fileName,
      fileKind: data.fileKind.present ? data.fileKind.value : this.fileKind,
      filePath: data.filePath.present ? data.filePath.value : this.filePath,
      extractedText: data.extractedText.present
          ? data.extractedText.value
          : this.extractedText,
      importedAt: data.importedAt.present
          ? data.importedAt.value
          : this.importedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SourceDocumentRow(')
          ..write('id: $id, ')
          ..write('fileName: $fileName, ')
          ..write('fileKind: $fileKind, ')
          ..write('filePath: $filePath, ')
          ..write('extractedText: $extractedText, ')
          ..write('importedAt: $importedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, fileName, fileKind, filePath, extractedText, importedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SourceDocumentRow &&
          other.id == this.id &&
          other.fileName == this.fileName &&
          other.fileKind == this.fileKind &&
          other.filePath == this.filePath &&
          other.extractedText == this.extractedText &&
          other.importedAt == this.importedAt);
}

class SourceDocumentsCompanion extends UpdateCompanion<SourceDocumentRow> {
  final Value<int> id;
  final Value<String> fileName;
  final Value<String> fileKind;
  final Value<String?> filePath;
  final Value<String?> extractedText;
  final Value<DateTime> importedAt;
  const SourceDocumentsCompanion({
    this.id = const Value.absent(),
    this.fileName = const Value.absent(),
    this.fileKind = const Value.absent(),
    this.filePath = const Value.absent(),
    this.extractedText = const Value.absent(),
    this.importedAt = const Value.absent(),
  });
  SourceDocumentsCompanion.insert({
    this.id = const Value.absent(),
    required String fileName,
    required String fileKind,
    this.filePath = const Value.absent(),
    this.extractedText = const Value.absent(),
    required DateTime importedAt,
  }) : fileName = Value(fileName),
       fileKind = Value(fileKind),
       importedAt = Value(importedAt);
  static Insertable<SourceDocumentRow> custom({
    Expression<int>? id,
    Expression<String>? fileName,
    Expression<String>? fileKind,
    Expression<String>? filePath,
    Expression<String>? extractedText,
    Expression<DateTime>? importedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (fileName != null) 'file_name': fileName,
      if (fileKind != null) 'file_kind': fileKind,
      if (filePath != null) 'file_path': filePath,
      if (extractedText != null) 'extracted_text': extractedText,
      if (importedAt != null) 'imported_at': importedAt,
    });
  }

  SourceDocumentsCompanion copyWith({
    Value<int>? id,
    Value<String>? fileName,
    Value<String>? fileKind,
    Value<String?>? filePath,
    Value<String?>? extractedText,
    Value<DateTime>? importedAt,
  }) {
    return SourceDocumentsCompanion(
      id: id ?? this.id,
      fileName: fileName ?? this.fileName,
      fileKind: fileKind ?? this.fileKind,
      filePath: filePath ?? this.filePath,
      extractedText: extractedText ?? this.extractedText,
      importedAt: importedAt ?? this.importedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (fileName.present) {
      map['file_name'] = Variable<String>(fileName.value);
    }
    if (fileKind.present) {
      map['file_kind'] = Variable<String>(fileKind.value);
    }
    if (filePath.present) {
      map['file_path'] = Variable<String>(filePath.value);
    }
    if (extractedText.present) {
      map['extracted_text'] = Variable<String>(extractedText.value);
    }
    if (importedAt.present) {
      map['imported_at'] = Variable<DateTime>(importedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SourceDocumentsCompanion(')
          ..write('id: $id, ')
          ..write('fileName: $fileName, ')
          ..write('fileKind: $fileKind, ')
          ..write('filePath: $filePath, ')
          ..write('extractedText: $extractedText, ')
          ..write('importedAt: $importedAt')
          ..write(')'))
        .toString();
  }
}

class $AiProposalsTable extends AiProposals
    with TableInfo<$AiProposalsTable, AiProposalRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AiProposalsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _kindMeta = const VerificationMeta('kind');
  @override
  late final GeneratedColumn<String> kind = GeneratedColumn<String>(
    'kind',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<dom.ProposalStatus, String>
  status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  ).withConverter<dom.ProposalStatus>($AiProposalsTable.$converterstatus);
  static const VerificationMeta _payloadJsonMeta = const VerificationMeta(
    'payloadJson',
  );
  @override
  late final GeneratedColumn<String> payloadJson = GeneratedColumn<String>(
    'payload_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _summaryMeta = const VerificationMeta(
    'summary',
  );
  @override
  late final GeneratedColumn<String> summary = GeneratedColumn<String>(
    'summary',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _decidedAtMeta = const VerificationMeta(
    'decidedAt',
  );
  @override
  late final GeneratedColumn<DateTime> decidedAt = GeneratedColumn<DateTime>(
    'decided_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    kind,
    status,
    payloadJson,
    summary,
    createdAt,
    decidedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'ai_proposals';
  @override
  VerificationContext validateIntegrity(
    Insertable<AiProposalRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('kind')) {
      context.handle(
        _kindMeta,
        kind.isAcceptableOrUnknown(data['kind']!, _kindMeta),
      );
    } else if (isInserting) {
      context.missing(_kindMeta);
    }
    if (data.containsKey('payload_json')) {
      context.handle(
        _payloadJsonMeta,
        payloadJson.isAcceptableOrUnknown(
          data['payload_json']!,
          _payloadJsonMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_payloadJsonMeta);
    }
    if (data.containsKey('summary')) {
      context.handle(
        _summaryMeta,
        summary.isAcceptableOrUnknown(data['summary']!, _summaryMeta),
      );
    } else if (isInserting) {
      context.missing(_summaryMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('decided_at')) {
      context.handle(
        _decidedAtMeta,
        decidedAt.isAcceptableOrUnknown(data['decided_at']!, _decidedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  AiProposalRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AiProposalRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      kind: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}kind'],
      )!,
      status: $AiProposalsTable.$converterstatus.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}status'],
        )!,
      ),
      payloadJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}payload_json'],
      )!,
      summary: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}summary'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      decidedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}decided_at'],
      ),
    );
  }

  @override
  $AiProposalsTable createAlias(String alias) {
    return $AiProposalsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<dom.ProposalStatus, String, String>
  $converterstatus = const EnumNameConverter<dom.ProposalStatus>(
    dom.ProposalStatus.values,
  );
}

class AiProposalRow extends DataClass implements Insertable<AiProposalRow> {
  final int id;
  final String kind;
  final dom.ProposalStatus status;
  final String payloadJson;
  final String summary;
  final DateTime createdAt;
  final DateTime? decidedAt;
  const AiProposalRow({
    required this.id,
    required this.kind,
    required this.status,
    required this.payloadJson,
    required this.summary,
    required this.createdAt,
    this.decidedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['kind'] = Variable<String>(kind);
    {
      map['status'] = Variable<String>(
        $AiProposalsTable.$converterstatus.toSql(status),
      );
    }
    map['payload_json'] = Variable<String>(payloadJson);
    map['summary'] = Variable<String>(summary);
    map['created_at'] = Variable<DateTime>(createdAt);
    if (!nullToAbsent || decidedAt != null) {
      map['decided_at'] = Variable<DateTime>(decidedAt);
    }
    return map;
  }

  AiProposalsCompanion toCompanion(bool nullToAbsent) {
    return AiProposalsCompanion(
      id: Value(id),
      kind: Value(kind),
      status: Value(status),
      payloadJson: Value(payloadJson),
      summary: Value(summary),
      createdAt: Value(createdAt),
      decidedAt: decidedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(decidedAt),
    );
  }

  factory AiProposalRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AiProposalRow(
      id: serializer.fromJson<int>(json['id']),
      kind: serializer.fromJson<String>(json['kind']),
      status: $AiProposalsTable.$converterstatus.fromJson(
        serializer.fromJson<String>(json['status']),
      ),
      payloadJson: serializer.fromJson<String>(json['payloadJson']),
      summary: serializer.fromJson<String>(json['summary']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      decidedAt: serializer.fromJson<DateTime?>(json['decidedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'kind': serializer.toJson<String>(kind),
      'status': serializer.toJson<String>(
        $AiProposalsTable.$converterstatus.toJson(status),
      ),
      'payloadJson': serializer.toJson<String>(payloadJson),
      'summary': serializer.toJson<String>(summary),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'decidedAt': serializer.toJson<DateTime?>(decidedAt),
    };
  }

  AiProposalRow copyWith({
    int? id,
    String? kind,
    dom.ProposalStatus? status,
    String? payloadJson,
    String? summary,
    DateTime? createdAt,
    Value<DateTime?> decidedAt = const Value.absent(),
  }) => AiProposalRow(
    id: id ?? this.id,
    kind: kind ?? this.kind,
    status: status ?? this.status,
    payloadJson: payloadJson ?? this.payloadJson,
    summary: summary ?? this.summary,
    createdAt: createdAt ?? this.createdAt,
    decidedAt: decidedAt.present ? decidedAt.value : this.decidedAt,
  );
  AiProposalRow copyWithCompanion(AiProposalsCompanion data) {
    return AiProposalRow(
      id: data.id.present ? data.id.value : this.id,
      kind: data.kind.present ? data.kind.value : this.kind,
      status: data.status.present ? data.status.value : this.status,
      payloadJson: data.payloadJson.present
          ? data.payloadJson.value
          : this.payloadJson,
      summary: data.summary.present ? data.summary.value : this.summary,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      decidedAt: data.decidedAt.present ? data.decidedAt.value : this.decidedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AiProposalRow(')
          ..write('id: $id, ')
          ..write('kind: $kind, ')
          ..write('status: $status, ')
          ..write('payloadJson: $payloadJson, ')
          ..write('summary: $summary, ')
          ..write('createdAt: $createdAt, ')
          ..write('decidedAt: $decidedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, kind, status, payloadJson, summary, createdAt, decidedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AiProposalRow &&
          other.id == this.id &&
          other.kind == this.kind &&
          other.status == this.status &&
          other.payloadJson == this.payloadJson &&
          other.summary == this.summary &&
          other.createdAt == this.createdAt &&
          other.decidedAt == this.decidedAt);
}

class AiProposalsCompanion extends UpdateCompanion<AiProposalRow> {
  final Value<int> id;
  final Value<String> kind;
  final Value<dom.ProposalStatus> status;
  final Value<String> payloadJson;
  final Value<String> summary;
  final Value<DateTime> createdAt;
  final Value<DateTime?> decidedAt;
  const AiProposalsCompanion({
    this.id = const Value.absent(),
    this.kind = const Value.absent(),
    this.status = const Value.absent(),
    this.payloadJson = const Value.absent(),
    this.summary = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.decidedAt = const Value.absent(),
  });
  AiProposalsCompanion.insert({
    this.id = const Value.absent(),
    required String kind,
    required dom.ProposalStatus status,
    required String payloadJson,
    required String summary,
    required DateTime createdAt,
    this.decidedAt = const Value.absent(),
  }) : kind = Value(kind),
       status = Value(status),
       payloadJson = Value(payloadJson),
       summary = Value(summary),
       createdAt = Value(createdAt);
  static Insertable<AiProposalRow> custom({
    Expression<int>? id,
    Expression<String>? kind,
    Expression<String>? status,
    Expression<String>? payloadJson,
    Expression<String>? summary,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? decidedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (kind != null) 'kind': kind,
      if (status != null) 'status': status,
      if (payloadJson != null) 'payload_json': payloadJson,
      if (summary != null) 'summary': summary,
      if (createdAt != null) 'created_at': createdAt,
      if (decidedAt != null) 'decided_at': decidedAt,
    });
  }

  AiProposalsCompanion copyWith({
    Value<int>? id,
    Value<String>? kind,
    Value<dom.ProposalStatus>? status,
    Value<String>? payloadJson,
    Value<String>? summary,
    Value<DateTime>? createdAt,
    Value<DateTime?>? decidedAt,
  }) {
    return AiProposalsCompanion(
      id: id ?? this.id,
      kind: kind ?? this.kind,
      status: status ?? this.status,
      payloadJson: payloadJson ?? this.payloadJson,
      summary: summary ?? this.summary,
      createdAt: createdAt ?? this.createdAt,
      decidedAt: decidedAt ?? this.decidedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (kind.present) {
      map['kind'] = Variable<String>(kind.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(
        $AiProposalsTable.$converterstatus.toSql(status.value),
      );
    }
    if (payloadJson.present) {
      map['payload_json'] = Variable<String>(payloadJson.value);
    }
    if (summary.present) {
      map['summary'] = Variable<String>(summary.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (decidedAt.present) {
      map['decided_at'] = Variable<DateTime>(decidedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AiProposalsCompanion(')
          ..write('id: $id, ')
          ..write('kind: $kind, ')
          ..write('status: $status, ')
          ..write('payloadJson: $payloadJson, ')
          ..write('summary: $summary, ')
          ..write('createdAt: $createdAt, ')
          ..write('decidedAt: $decidedAt')
          ..write(')'))
        .toString();
  }
}

class $ProgressEventsTable extends ProgressEvents
    with TableInfo<$ProgressEventsTable, ProgressEventRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ProgressEventsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  @override
  late final GeneratedColumnWithTypeConverter<dom.ProgressEventType, String>
  type = GeneratedColumn<String>(
    'type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  ).withConverter<dom.ProgressEventType>($ProgressEventsTable.$convertertype);
  static const VerificationMeta _projectIdMeta = const VerificationMeta(
    'projectId',
  );
  @override
  late final GeneratedColumn<int> projectId = GeneratedColumn<int>(
    'project_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _taskIdMeta = const VerificationMeta('taskId');
  @override
  late final GeneratedColumn<int> taskId = GeneratedColumn<int>(
    'task_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _detailMeta = const VerificationMeta('detail');
  @override
  late final GeneratedColumn<String> detail = GeneratedColumn<String>(
    'detail',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _occurredAtMeta = const VerificationMeta(
    'occurredAt',
  );
  @override
  late final GeneratedColumn<DateTime> occurredAt = GeneratedColumn<DateTime>(
    'occurred_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    type,
    projectId,
    taskId,
    detail,
    occurredAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'progress_events';
  @override
  VerificationContext validateIntegrity(
    Insertable<ProgressEventRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('project_id')) {
      context.handle(
        _projectIdMeta,
        projectId.isAcceptableOrUnknown(data['project_id']!, _projectIdMeta),
      );
    }
    if (data.containsKey('task_id')) {
      context.handle(
        _taskIdMeta,
        taskId.isAcceptableOrUnknown(data['task_id']!, _taskIdMeta),
      );
    }
    if (data.containsKey('detail')) {
      context.handle(
        _detailMeta,
        detail.isAcceptableOrUnknown(data['detail']!, _detailMeta),
      );
    }
    if (data.containsKey('occurred_at')) {
      context.handle(
        _occurredAtMeta,
        occurredAt.isAcceptableOrUnknown(data['occurred_at']!, _occurredAtMeta),
      );
    } else if (isInserting) {
      context.missing(_occurredAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ProgressEventRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ProgressEventRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      type: $ProgressEventsTable.$convertertype.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}type'],
        )!,
      ),
      projectId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}project_id'],
      ),
      taskId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}task_id'],
      ),
      detail: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}detail'],
      )!,
      occurredAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}occurred_at'],
      )!,
    );
  }

  @override
  $ProgressEventsTable createAlias(String alias) {
    return $ProgressEventsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<dom.ProgressEventType, String, String>
  $convertertype = const EnumNameConverter<dom.ProgressEventType>(
    dom.ProgressEventType.values,
  );
}

class ProgressEventRow extends DataClass
    implements Insertable<ProgressEventRow> {
  final int id;
  final dom.ProgressEventType type;
  final int? projectId;
  final int? taskId;
  final String detail;
  final DateTime occurredAt;
  const ProgressEventRow({
    required this.id,
    required this.type,
    this.projectId,
    this.taskId,
    required this.detail,
    required this.occurredAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    {
      map['type'] = Variable<String>(
        $ProgressEventsTable.$convertertype.toSql(type),
      );
    }
    if (!nullToAbsent || projectId != null) {
      map['project_id'] = Variable<int>(projectId);
    }
    if (!nullToAbsent || taskId != null) {
      map['task_id'] = Variable<int>(taskId);
    }
    map['detail'] = Variable<String>(detail);
    map['occurred_at'] = Variable<DateTime>(occurredAt);
    return map;
  }

  ProgressEventsCompanion toCompanion(bool nullToAbsent) {
    return ProgressEventsCompanion(
      id: Value(id),
      type: Value(type),
      projectId: projectId == null && nullToAbsent
          ? const Value.absent()
          : Value(projectId),
      taskId: taskId == null && nullToAbsent
          ? const Value.absent()
          : Value(taskId),
      detail: Value(detail),
      occurredAt: Value(occurredAt),
    );
  }

  factory ProgressEventRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ProgressEventRow(
      id: serializer.fromJson<int>(json['id']),
      type: $ProgressEventsTable.$convertertype.fromJson(
        serializer.fromJson<String>(json['type']),
      ),
      projectId: serializer.fromJson<int?>(json['projectId']),
      taskId: serializer.fromJson<int?>(json['taskId']),
      detail: serializer.fromJson<String>(json['detail']),
      occurredAt: serializer.fromJson<DateTime>(json['occurredAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'type': serializer.toJson<String>(
        $ProgressEventsTable.$convertertype.toJson(type),
      ),
      'projectId': serializer.toJson<int?>(projectId),
      'taskId': serializer.toJson<int?>(taskId),
      'detail': serializer.toJson<String>(detail),
      'occurredAt': serializer.toJson<DateTime>(occurredAt),
    };
  }

  ProgressEventRow copyWith({
    int? id,
    dom.ProgressEventType? type,
    Value<int?> projectId = const Value.absent(),
    Value<int?> taskId = const Value.absent(),
    String? detail,
    DateTime? occurredAt,
  }) => ProgressEventRow(
    id: id ?? this.id,
    type: type ?? this.type,
    projectId: projectId.present ? projectId.value : this.projectId,
    taskId: taskId.present ? taskId.value : this.taskId,
    detail: detail ?? this.detail,
    occurredAt: occurredAt ?? this.occurredAt,
  );
  ProgressEventRow copyWithCompanion(ProgressEventsCompanion data) {
    return ProgressEventRow(
      id: data.id.present ? data.id.value : this.id,
      type: data.type.present ? data.type.value : this.type,
      projectId: data.projectId.present ? data.projectId.value : this.projectId,
      taskId: data.taskId.present ? data.taskId.value : this.taskId,
      detail: data.detail.present ? data.detail.value : this.detail,
      occurredAt: data.occurredAt.present
          ? data.occurredAt.value
          : this.occurredAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ProgressEventRow(')
          ..write('id: $id, ')
          ..write('type: $type, ')
          ..write('projectId: $projectId, ')
          ..write('taskId: $taskId, ')
          ..write('detail: $detail, ')
          ..write('occurredAt: $occurredAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, type, projectId, taskId, detail, occurredAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ProgressEventRow &&
          other.id == this.id &&
          other.type == this.type &&
          other.projectId == this.projectId &&
          other.taskId == this.taskId &&
          other.detail == this.detail &&
          other.occurredAt == this.occurredAt);
}

class ProgressEventsCompanion extends UpdateCompanion<ProgressEventRow> {
  final Value<int> id;
  final Value<dom.ProgressEventType> type;
  final Value<int?> projectId;
  final Value<int?> taskId;
  final Value<String> detail;
  final Value<DateTime> occurredAt;
  const ProgressEventsCompanion({
    this.id = const Value.absent(),
    this.type = const Value.absent(),
    this.projectId = const Value.absent(),
    this.taskId = const Value.absent(),
    this.detail = const Value.absent(),
    this.occurredAt = const Value.absent(),
  });
  ProgressEventsCompanion.insert({
    this.id = const Value.absent(),
    required dom.ProgressEventType type,
    this.projectId = const Value.absent(),
    this.taskId = const Value.absent(),
    this.detail = const Value.absent(),
    required DateTime occurredAt,
  }) : type = Value(type),
       occurredAt = Value(occurredAt);
  static Insertable<ProgressEventRow> custom({
    Expression<int>? id,
    Expression<String>? type,
    Expression<int>? projectId,
    Expression<int>? taskId,
    Expression<String>? detail,
    Expression<DateTime>? occurredAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (type != null) 'type': type,
      if (projectId != null) 'project_id': projectId,
      if (taskId != null) 'task_id': taskId,
      if (detail != null) 'detail': detail,
      if (occurredAt != null) 'occurred_at': occurredAt,
    });
  }

  ProgressEventsCompanion copyWith({
    Value<int>? id,
    Value<dom.ProgressEventType>? type,
    Value<int?>? projectId,
    Value<int?>? taskId,
    Value<String>? detail,
    Value<DateTime>? occurredAt,
  }) {
    return ProgressEventsCompanion(
      id: id ?? this.id,
      type: type ?? this.type,
      projectId: projectId ?? this.projectId,
      taskId: taskId ?? this.taskId,
      detail: detail ?? this.detail,
      occurredAt: occurredAt ?? this.occurredAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(
        $ProgressEventsTable.$convertertype.toSql(type.value),
      );
    }
    if (projectId.present) {
      map['project_id'] = Variable<int>(projectId.value);
    }
    if (taskId.present) {
      map['task_id'] = Variable<int>(taskId.value);
    }
    if (detail.present) {
      map['detail'] = Variable<String>(detail.value);
    }
    if (occurredAt.present) {
      map['occurred_at'] = Variable<DateTime>(occurredAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ProgressEventsCompanion(')
          ..write('id: $id, ')
          ..write('type: $type, ')
          ..write('projectId: $projectId, ')
          ..write('taskId: $taskId, ')
          ..write('detail: $detail, ')
          ..write('occurredAt: $occurredAt')
          ..write(')'))
        .toString();
  }
}

class $ReviewSnapshotsTable extends ReviewSnapshots
    with TableInfo<$ReviewSnapshotsTable, ReviewSnapshotRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ReviewSnapshotsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  @override
  late final GeneratedColumnWithTypeConverter<dom.ReviewScope, String> scope =
      GeneratedColumn<String>(
        'scope',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<dom.ReviewScope>($ReviewSnapshotsTable.$converterscope);
  static const VerificationMeta _targetIdMeta = const VerificationMeta(
    'targetId',
  );
  @override
  late final GeneratedColumn<int> targetId = GeneratedColumn<int>(
    'target_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _periodStartMeta = const VerificationMeta(
    'periodStart',
  );
  @override
  late final GeneratedColumn<DateTime> periodStart = GeneratedColumn<DateTime>(
    'period_start',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _periodEndMeta = const VerificationMeta(
    'periodEnd',
  );
  @override
  late final GeneratedColumn<DateTime> periodEnd = GeneratedColumn<DateTime>(
    'period_end',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _storyJsonMeta = const VerificationMeta(
    'storyJson',
  );
  @override
  late final GeneratedColumn<String> storyJson = GeneratedColumn<String>(
    'story_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _aiSummaryMeta = const VerificationMeta(
    'aiSummary',
  );
  @override
  late final GeneratedColumn<String> aiSummary = GeneratedColumn<String>(
    'ai_summary',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    scope,
    targetId,
    periodStart,
    periodEnd,
    storyJson,
    aiSummary,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'review_snapshots';
  @override
  VerificationContext validateIntegrity(
    Insertable<ReviewSnapshotRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('target_id')) {
      context.handle(
        _targetIdMeta,
        targetId.isAcceptableOrUnknown(data['target_id']!, _targetIdMeta),
      );
    }
    if (data.containsKey('period_start')) {
      context.handle(
        _periodStartMeta,
        periodStart.isAcceptableOrUnknown(
          data['period_start']!,
          _periodStartMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_periodStartMeta);
    }
    if (data.containsKey('period_end')) {
      context.handle(
        _periodEndMeta,
        periodEnd.isAcceptableOrUnknown(data['period_end']!, _periodEndMeta),
      );
    } else if (isInserting) {
      context.missing(_periodEndMeta);
    }
    if (data.containsKey('story_json')) {
      context.handle(
        _storyJsonMeta,
        storyJson.isAcceptableOrUnknown(data['story_json']!, _storyJsonMeta),
      );
    } else if (isInserting) {
      context.missing(_storyJsonMeta);
    }
    if (data.containsKey('ai_summary')) {
      context.handle(
        _aiSummaryMeta,
        aiSummary.isAcceptableOrUnknown(data['ai_summary']!, _aiSummaryMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ReviewSnapshotRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ReviewSnapshotRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      scope: $ReviewSnapshotsTable.$converterscope.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}scope'],
        )!,
      ),
      targetId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}target_id'],
      ),
      periodStart: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}period_start'],
      )!,
      periodEnd: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}period_end'],
      )!,
      storyJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}story_json'],
      )!,
      aiSummary: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}ai_summary'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $ReviewSnapshotsTable createAlias(String alias) {
    return $ReviewSnapshotsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<dom.ReviewScope, String, String> $converterscope =
      const EnumNameConverter<dom.ReviewScope>(dom.ReviewScope.values);
}

class ReviewSnapshotRow extends DataClass
    implements Insertable<ReviewSnapshotRow> {
  final int id;
  final dom.ReviewScope scope;
  final int? targetId;
  final DateTime periodStart;
  final DateTime periodEnd;
  final String storyJson;
  final String? aiSummary;
  final DateTime createdAt;
  const ReviewSnapshotRow({
    required this.id,
    required this.scope,
    this.targetId,
    required this.periodStart,
    required this.periodEnd,
    required this.storyJson,
    this.aiSummary,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    {
      map['scope'] = Variable<String>(
        $ReviewSnapshotsTable.$converterscope.toSql(scope),
      );
    }
    if (!nullToAbsent || targetId != null) {
      map['target_id'] = Variable<int>(targetId);
    }
    map['period_start'] = Variable<DateTime>(periodStart);
    map['period_end'] = Variable<DateTime>(periodEnd);
    map['story_json'] = Variable<String>(storyJson);
    if (!nullToAbsent || aiSummary != null) {
      map['ai_summary'] = Variable<String>(aiSummary);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  ReviewSnapshotsCompanion toCompanion(bool nullToAbsent) {
    return ReviewSnapshotsCompanion(
      id: Value(id),
      scope: Value(scope),
      targetId: targetId == null && nullToAbsent
          ? const Value.absent()
          : Value(targetId),
      periodStart: Value(periodStart),
      periodEnd: Value(periodEnd),
      storyJson: Value(storyJson),
      aiSummary: aiSummary == null && nullToAbsent
          ? const Value.absent()
          : Value(aiSummary),
      createdAt: Value(createdAt),
    );
  }

  factory ReviewSnapshotRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ReviewSnapshotRow(
      id: serializer.fromJson<int>(json['id']),
      scope: $ReviewSnapshotsTable.$converterscope.fromJson(
        serializer.fromJson<String>(json['scope']),
      ),
      targetId: serializer.fromJson<int?>(json['targetId']),
      periodStart: serializer.fromJson<DateTime>(json['periodStart']),
      periodEnd: serializer.fromJson<DateTime>(json['periodEnd']),
      storyJson: serializer.fromJson<String>(json['storyJson']),
      aiSummary: serializer.fromJson<String?>(json['aiSummary']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'scope': serializer.toJson<String>(
        $ReviewSnapshotsTable.$converterscope.toJson(scope),
      ),
      'targetId': serializer.toJson<int?>(targetId),
      'periodStart': serializer.toJson<DateTime>(periodStart),
      'periodEnd': serializer.toJson<DateTime>(periodEnd),
      'storyJson': serializer.toJson<String>(storyJson),
      'aiSummary': serializer.toJson<String?>(aiSummary),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  ReviewSnapshotRow copyWith({
    int? id,
    dom.ReviewScope? scope,
    Value<int?> targetId = const Value.absent(),
    DateTime? periodStart,
    DateTime? periodEnd,
    String? storyJson,
    Value<String?> aiSummary = const Value.absent(),
    DateTime? createdAt,
  }) => ReviewSnapshotRow(
    id: id ?? this.id,
    scope: scope ?? this.scope,
    targetId: targetId.present ? targetId.value : this.targetId,
    periodStart: periodStart ?? this.periodStart,
    periodEnd: periodEnd ?? this.periodEnd,
    storyJson: storyJson ?? this.storyJson,
    aiSummary: aiSummary.present ? aiSummary.value : this.aiSummary,
    createdAt: createdAt ?? this.createdAt,
  );
  ReviewSnapshotRow copyWithCompanion(ReviewSnapshotsCompanion data) {
    return ReviewSnapshotRow(
      id: data.id.present ? data.id.value : this.id,
      scope: data.scope.present ? data.scope.value : this.scope,
      targetId: data.targetId.present ? data.targetId.value : this.targetId,
      periodStart: data.periodStart.present
          ? data.periodStart.value
          : this.periodStart,
      periodEnd: data.periodEnd.present ? data.periodEnd.value : this.periodEnd,
      storyJson: data.storyJson.present ? data.storyJson.value : this.storyJson,
      aiSummary: data.aiSummary.present ? data.aiSummary.value : this.aiSummary,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ReviewSnapshotRow(')
          ..write('id: $id, ')
          ..write('scope: $scope, ')
          ..write('targetId: $targetId, ')
          ..write('periodStart: $periodStart, ')
          ..write('periodEnd: $periodEnd, ')
          ..write('storyJson: $storyJson, ')
          ..write('aiSummary: $aiSummary, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    scope,
    targetId,
    periodStart,
    periodEnd,
    storyJson,
    aiSummary,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ReviewSnapshotRow &&
          other.id == this.id &&
          other.scope == this.scope &&
          other.targetId == this.targetId &&
          other.periodStart == this.periodStart &&
          other.periodEnd == this.periodEnd &&
          other.storyJson == this.storyJson &&
          other.aiSummary == this.aiSummary &&
          other.createdAt == this.createdAt);
}

class ReviewSnapshotsCompanion extends UpdateCompanion<ReviewSnapshotRow> {
  final Value<int> id;
  final Value<dom.ReviewScope> scope;
  final Value<int?> targetId;
  final Value<DateTime> periodStart;
  final Value<DateTime> periodEnd;
  final Value<String> storyJson;
  final Value<String?> aiSummary;
  final Value<DateTime> createdAt;
  const ReviewSnapshotsCompanion({
    this.id = const Value.absent(),
    this.scope = const Value.absent(),
    this.targetId = const Value.absent(),
    this.periodStart = const Value.absent(),
    this.periodEnd = const Value.absent(),
    this.storyJson = const Value.absent(),
    this.aiSummary = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  ReviewSnapshotsCompanion.insert({
    this.id = const Value.absent(),
    required dom.ReviewScope scope,
    this.targetId = const Value.absent(),
    required DateTime periodStart,
    required DateTime periodEnd,
    required String storyJson,
    this.aiSummary = const Value.absent(),
    required DateTime createdAt,
  }) : scope = Value(scope),
       periodStart = Value(periodStart),
       periodEnd = Value(periodEnd),
       storyJson = Value(storyJson),
       createdAt = Value(createdAt);
  static Insertable<ReviewSnapshotRow> custom({
    Expression<int>? id,
    Expression<String>? scope,
    Expression<int>? targetId,
    Expression<DateTime>? periodStart,
    Expression<DateTime>? periodEnd,
    Expression<String>? storyJson,
    Expression<String>? aiSummary,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (scope != null) 'scope': scope,
      if (targetId != null) 'target_id': targetId,
      if (periodStart != null) 'period_start': periodStart,
      if (periodEnd != null) 'period_end': periodEnd,
      if (storyJson != null) 'story_json': storyJson,
      if (aiSummary != null) 'ai_summary': aiSummary,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  ReviewSnapshotsCompanion copyWith({
    Value<int>? id,
    Value<dom.ReviewScope>? scope,
    Value<int?>? targetId,
    Value<DateTime>? periodStart,
    Value<DateTime>? periodEnd,
    Value<String>? storyJson,
    Value<String?>? aiSummary,
    Value<DateTime>? createdAt,
  }) {
    return ReviewSnapshotsCompanion(
      id: id ?? this.id,
      scope: scope ?? this.scope,
      targetId: targetId ?? this.targetId,
      periodStart: periodStart ?? this.periodStart,
      periodEnd: periodEnd ?? this.periodEnd,
      storyJson: storyJson ?? this.storyJson,
      aiSummary: aiSummary ?? this.aiSummary,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (scope.present) {
      map['scope'] = Variable<String>(
        $ReviewSnapshotsTable.$converterscope.toSql(scope.value),
      );
    }
    if (targetId.present) {
      map['target_id'] = Variable<int>(targetId.value);
    }
    if (periodStart.present) {
      map['period_start'] = Variable<DateTime>(periodStart.value);
    }
    if (periodEnd.present) {
      map['period_end'] = Variable<DateTime>(periodEnd.value);
    }
    if (storyJson.present) {
      map['story_json'] = Variable<String>(storyJson.value);
    }
    if (aiSummary.present) {
      map['ai_summary'] = Variable<String>(aiSummary.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ReviewSnapshotsCompanion(')
          ..write('id: $id, ')
          ..write('scope: $scope, ')
          ..write('targetId: $targetId, ')
          ..write('periodStart: $periodStart, ')
          ..write('periodEnd: $periodEnd, ')
          ..write('storyJson: $storyJson, ')
          ..write('aiSummary: $aiSummary, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $SettingsTable extends Settings with TableInfo<$SettingsTable, Setting> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SettingsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _keyMeta = const VerificationMeta('key');
  @override
  late final GeneratedColumn<String> key = GeneratedColumn<String>(
    'key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _valueMeta = const VerificationMeta('value');
  @override
  late final GeneratedColumn<String> value = GeneratedColumn<String>(
    'value',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [key, value];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'settings';
  @override
  VerificationContext validateIntegrity(
    Insertable<Setting> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('key')) {
      context.handle(
        _keyMeta,
        key.isAcceptableOrUnknown(data['key']!, _keyMeta),
      );
    } else if (isInserting) {
      context.missing(_keyMeta);
    }
    if (data.containsKey('value')) {
      context.handle(
        _valueMeta,
        value.isAcceptableOrUnknown(data['value']!, _valueMeta),
      );
    } else if (isInserting) {
      context.missing(_valueMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {key};
  @override
  Setting map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Setting(
      key: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}key'],
      )!,
      value: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}value'],
      )!,
    );
  }

  @override
  $SettingsTable createAlias(String alias) {
    return $SettingsTable(attachedDatabase, alias);
  }
}

class Setting extends DataClass implements Insertable<Setting> {
  final String key;
  final String value;
  const Setting({required this.key, required this.value});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['key'] = Variable<String>(key);
    map['value'] = Variable<String>(value);
    return map;
  }

  SettingsCompanion toCompanion(bool nullToAbsent) {
    return SettingsCompanion(key: Value(key), value: Value(value));
  }

  factory Setting.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Setting(
      key: serializer.fromJson<String>(json['key']),
      value: serializer.fromJson<String>(json['value']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'key': serializer.toJson<String>(key),
      'value': serializer.toJson<String>(value),
    };
  }

  Setting copyWith({String? key, String? value}) =>
      Setting(key: key ?? this.key, value: value ?? this.value);
  Setting copyWithCompanion(SettingsCompanion data) {
    return Setting(
      key: data.key.present ? data.key.value : this.key,
      value: data.value.present ? data.value.value : this.value,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Setting(')
          ..write('key: $key, ')
          ..write('value: $value')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(key, value);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Setting && other.key == this.key && other.value == this.value);
}

class SettingsCompanion extends UpdateCompanion<Setting> {
  final Value<String> key;
  final Value<String> value;
  final Value<int> rowid;
  const SettingsCompanion({
    this.key = const Value.absent(),
    this.value = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SettingsCompanion.insert({
    required String key,
    required String value,
    this.rowid = const Value.absent(),
  }) : key = Value(key),
       value = Value(value);
  static Insertable<Setting> custom({
    Expression<String>? key,
    Expression<String>? value,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (key != null) 'key': key,
      if (value != null) 'value': value,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SettingsCompanion copyWith({
    Value<String>? key,
    Value<String>? value,
    Value<int>? rowid,
  }) {
    return SettingsCompanion(
      key: key ?? this.key,
      value: value ?? this.value,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (key.present) {
      map['key'] = Variable<String>(key.value);
    }
    if (value.present) {
      map['value'] = Variable<String>(value.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SettingsCompanion(')
          ..write('key: $key, ')
          ..write('value: $value, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $ProjectsTable projects = $ProjectsTable(this);
  late final $PhasesTable phases = $PhasesTable(this);
  late final $MilestonesTable milestones = $MilestonesTable(this);
  late final $TasksTable tasks = $TasksTable(this);
  late final $TaskDependenciesTable taskDependencies = $TaskDependenciesTable(
    this,
  );
  late final $SourceRefsTable sourceRefs = $SourceRefsTable(this);
  late final $WeekSettingsTable weekSettings = $WeekSettingsTable(this);
  late final $WeeklyAssignmentsTable weeklyAssignments =
      $WeeklyAssignmentsTable(this);
  late final $InboxItemsTable inboxItems = $InboxItemsTable(this);
  late final $SourceDocumentsTable sourceDocuments = $SourceDocumentsTable(
    this,
  );
  late final $AiProposalsTable aiProposals = $AiProposalsTable(this);
  late final $ProgressEventsTable progressEvents = $ProgressEventsTable(this);
  late final $ReviewSnapshotsTable reviewSnapshots = $ReviewSnapshotsTable(
    this,
  );
  late final $SettingsTable settings = $SettingsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    projects,
    phases,
    milestones,
    tasks,
    taskDependencies,
    sourceRefs,
    weekSettings,
    weeklyAssignments,
    inboxItems,
    sourceDocuments,
    aiProposals,
    progressEvents,
    reviewSnapshots,
    settings,
  ];
}

typedef $$ProjectsTableCreateCompanionBuilder = ProjectsCompanion Function({
  Value<int> id,
  required String title,
  Value<String> outcome,
  required dom.ExecutionMode executionMode,
  required dom.ProjectStatus status,
  required dom.PlanHealth health,
  required DateTime startDate,
  Value<DateTime?> deadline,
  Value<int?> themeColor,
  Value<int?> sourceDocumentId,
  required DateTime createdAt,
  required DateTime updatedAt,
});
typedef $$ProjectsTableUpdateCompanionBuilder = ProjectsCompanion Function({
  Value<int> id,
  Value<String> title,
  Value<String> outcome,
  Value<dom.ExecutionMode> executionMode,
  Value<dom.ProjectStatus> status,
  Value<dom.PlanHealth> health,
  Value<DateTime> startDate,
  Value<DateTime?> deadline,
  Value<int?> themeColor,
  Value<int?> sourceDocumentId,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
});

final class $$ProjectsTableReferences
    extends BaseReferences<_$AppDatabase, $ProjectsTable, ProjectsRow> {
  $$ProjectsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$PhasesTable, List<PhasesRow>> _phasesRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.phases,
    aliasName: 'projects__id__phases__project_id',
  );

  $$PhasesTableProcessedTableManager get phasesRefs {
    final manager = $$PhasesTableTableManager(
      $_db,
      $_db.phases,
    ).filter((f) => f.projectId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_phasesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$MilestonesTable, List<MilestonesRow>>
  _milestonesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.milestones,
    aliasName: 'projects__id__milestones__project_id',
  );

  $$MilestonesTableProcessedTableManager get milestonesRefs {
    final manager = $$MilestonesTableTableManager(
      $_db,
      $_db.milestones,
    ).filter((f) => f.projectId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_milestonesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$TasksTable, List<TasksRow>> _tasksRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.tasks,
    aliasName: 'projects__id__tasks__project_id',
  );

  $$TasksTableProcessedTableManager get tasksRefs {
    final manager = $$TasksTableTableManager(
      $_db,
      $_db.tasks,
    ).filter((f) => f.projectId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_tasksRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$WeeklyAssignmentsTable, List<WeeklyAssignmentRow>>
  _weeklyAssignmentsRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.weeklyAssignments,
        aliasName: 'projects__id__weekly_assignments__project_id',
      );

  $$WeeklyAssignmentsTableProcessedTableManager get weeklyAssignmentsRefs {
    final manager = $$WeeklyAssignmentsTableTableManager(
      $_db,
      $_db.weeklyAssignments,
    ).filter((f) => f.projectId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _weeklyAssignmentsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$ProjectsTableFilterComposer
    extends Composer<_$AppDatabase, $ProjectsTable> {
  $$ProjectsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get outcome => $composableBuilder(
    column: $table.outcome,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<dom.ExecutionMode, dom.ExecutionMode, String>
  get executionMode => $composableBuilder(
    column: $table.executionMode,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnWithTypeConverterFilters<dom.ProjectStatus, dom.ProjectStatus, String>
  get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnWithTypeConverterFilters<dom.PlanHealth, dom.PlanHealth, String>
  get health => $composableBuilder(
    column: $table.health,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<DateTime> get startDate => $composableBuilder(
    column: $table.startDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get deadline => $composableBuilder(
    column: $table.deadline,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get themeColor => $composableBuilder(
    column: $table.themeColor,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sourceDocumentId => $composableBuilder(
    column: $table.sourceDocumentId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> phasesRefs(
    Expression<bool> Function($$PhasesTableFilterComposer f) f,
  ) {
    final $$PhasesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.phases,
      getReferencedColumn: (t) => t.projectId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PhasesTableFilterComposer(
            $db: $db,
            $table: $db.phases,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> milestonesRefs(
    Expression<bool> Function($$MilestonesTableFilterComposer f) f,
  ) {
    final $$MilestonesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.milestones,
      getReferencedColumn: (t) => t.projectId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MilestonesTableFilterComposer(
            $db: $db,
            $table: $db.milestones,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> tasksRefs(
    Expression<bool> Function($$TasksTableFilterComposer f) f,
  ) {
    final $$TasksTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.tasks,
      getReferencedColumn: (t) => t.projectId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TasksTableFilterComposer(
            $db: $db,
            $table: $db.tasks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> weeklyAssignmentsRefs(
    Expression<bool> Function($$WeeklyAssignmentsTableFilterComposer f) f,
  ) {
    final $$WeeklyAssignmentsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.weeklyAssignments,
      getReferencedColumn: (t) => t.projectId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WeeklyAssignmentsTableFilterComposer(
            $db: $db,
            $table: $db.weeklyAssignments,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ProjectsTableOrderingComposer
    extends Composer<_$AppDatabase, $ProjectsTable> {
  $$ProjectsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get outcome => $composableBuilder(
    column: $table.outcome,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get executionMode => $composableBuilder(
    column: $table.executionMode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get health => $composableBuilder(
    column: $table.health,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get startDate => $composableBuilder(
    column: $table.startDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get deadline => $composableBuilder(
    column: $table.deadline,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get themeColor => $composableBuilder(
    column: $table.themeColor,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sourceDocumentId => $composableBuilder(
    column: $table.sourceDocumentId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ProjectsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ProjectsTable> {
  $$ProjectsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get outcome =>
      $composableBuilder(column: $table.outcome, builder: (column) => column);

  GeneratedColumnWithTypeConverter<dom.ExecutionMode, String>
  get executionMode => $composableBuilder(
    column: $table.executionMode,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<dom.ProjectStatus, String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumnWithTypeConverter<dom.PlanHealth, String> get health =>
      $composableBuilder(column: $table.health, builder: (column) => column);

  GeneratedColumn<DateTime> get startDate =>
      $composableBuilder(column: $table.startDate, builder: (column) => column);

  GeneratedColumn<DateTime> get deadline =>
      $composableBuilder(column: $table.deadline, builder: (column) => column);

  GeneratedColumn<int> get themeColor => $composableBuilder(
    column: $table.themeColor,
    builder: (column) => column,
  );

  GeneratedColumn<int> get sourceDocumentId => $composableBuilder(
    column: $table.sourceDocumentId,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  Expression<T> phasesRefs<T extends Object>(
    Expression<T> Function($$PhasesTableAnnotationComposer a) f,
  ) {
    final $$PhasesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.phases,
      getReferencedColumn: (t) => t.projectId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PhasesTableAnnotationComposer(
            $db: $db,
            $table: $db.phases,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> milestonesRefs<T extends Object>(
    Expression<T> Function($$MilestonesTableAnnotationComposer a) f,
  ) {
    final $$MilestonesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.milestones,
      getReferencedColumn: (t) => t.projectId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MilestonesTableAnnotationComposer(
            $db: $db,
            $table: $db.milestones,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> tasksRefs<T extends Object>(
    Expression<T> Function($$TasksTableAnnotationComposer a) f,
  ) {
    final $$TasksTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.tasks,
      getReferencedColumn: (t) => t.projectId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TasksTableAnnotationComposer(
            $db: $db,
            $table: $db.tasks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> weeklyAssignmentsRefs<T extends Object>(
    Expression<T> Function($$WeeklyAssignmentsTableAnnotationComposer a) f,
  ) {
    final $$WeeklyAssignmentsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.weeklyAssignments,
          getReferencedColumn: (t) => t.projectId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$WeeklyAssignmentsTableAnnotationComposer(
                $db: $db,
                $table: $db.weeklyAssignments,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$ProjectsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ProjectsTable,
          ProjectsRow,
          $$ProjectsTableFilterComposer,
          $$ProjectsTableOrderingComposer,
          $$ProjectsTableAnnotationComposer,
          $$ProjectsTableCreateCompanionBuilder,
          $$ProjectsTableUpdateCompanionBuilder,
          (ProjectsRow, $$ProjectsTableReferences),
          ProjectsRow,
          PrefetchHooks Function({
            bool phasesRefs,
            bool milestonesRefs,
            bool tasksRefs,
            bool weeklyAssignmentsRefs,
          })
        > {
  $$ProjectsTableTableManager(_$AppDatabase db, $ProjectsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ProjectsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ProjectsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ProjectsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String> outcome = const Value.absent(),
                Value<dom.ExecutionMode> executionMode = const Value.absent(),
                Value<dom.ProjectStatus> status = const Value.absent(),
                Value<dom.PlanHealth> health = const Value.absent(),
                Value<DateTime> startDate = const Value.absent(),
                Value<DateTime?> deadline = const Value.absent(),
                Value<int?> themeColor = const Value.absent(),
                Value<int?> sourceDocumentId = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => ProjectsCompanion(
                id: id,
                title: title,
                outcome: outcome,
                executionMode: executionMode,
                status: status,
                health: health,
                startDate: startDate,
                deadline: deadline,
                themeColor: themeColor,
                sourceDocumentId: sourceDocumentId,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String title,
                Value<String> outcome = const Value.absent(),
                required dom.ExecutionMode executionMode,
                required dom.ProjectStatus status,
                required dom.PlanHealth health,
                required DateTime startDate,
                Value<DateTime?> deadline = const Value.absent(),
                Value<int?> themeColor = const Value.absent(),
                Value<int?> sourceDocumentId = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
              }) => ProjectsCompanion.insert(
                id: id,
                title: title,
                outcome: outcome,
                executionMode: executionMode,
                status: status,
                health: health,
                startDate: startDate,
                deadline: deadline,
                themeColor: themeColor,
                sourceDocumentId: sourceDocumentId,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$ProjectsTable, ProjectsRow>(table),
                  $$ProjectsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                phasesRefs = false,
                milestonesRefs = false,
                tasksRefs = false,
                weeklyAssignmentsRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (phasesRefs) db.phases,
                    if (milestonesRefs) db.milestones,
                    if (tasksRefs) db.tasks,
                    if (weeklyAssignmentsRefs) db.weeklyAssignments,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (phasesRefs)
                        await $_getPrefetchedData<
                          ProjectsRow,
                          $ProjectsTable,
                          PhasesRow
                        >(
                          currentTable: table,
                          referencedTable: $$ProjectsTableReferences
                              ._phasesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ProjectsTableReferences(
                                db,
                                table,
                                p0,
                              ).phasesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.projectId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (milestonesRefs)
                        await $_getPrefetchedData<
                          ProjectsRow,
                          $ProjectsTable,
                          MilestonesRow
                        >(
                          currentTable: table,
                          referencedTable: $$ProjectsTableReferences
                              ._milestonesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ProjectsTableReferences(
                                db,
                                table,
                                p0,
                              ).milestonesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.projectId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (tasksRefs)
                        await $_getPrefetchedData<
                          ProjectsRow,
                          $ProjectsTable,
                          TasksRow
                        >(
                          currentTable: table,
                          referencedTable: $$ProjectsTableReferences
                              ._tasksRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ProjectsTableReferences(
                                db,
                                table,
                                p0,
                              ).tasksRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.projectId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (weeklyAssignmentsRefs)
                        await $_getPrefetchedData<
                          ProjectsRow,
                          $ProjectsTable,
                          WeeklyAssignmentRow
                        >(
                          currentTable: table,
                          referencedTable: $$ProjectsTableReferences
                              ._weeklyAssignmentsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ProjectsTableReferences(
                                db,
                                table,
                                p0,
                              ).weeklyAssignmentsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.projectId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$ProjectsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ProjectsTable,
      ProjectsRow,
      $$ProjectsTableFilterComposer,
      $$ProjectsTableOrderingComposer,
      $$ProjectsTableAnnotationComposer,
      $$ProjectsTableCreateCompanionBuilder,
      $$ProjectsTableUpdateCompanionBuilder,
      (ProjectsRow, $$ProjectsTableReferences),
      ProjectsRow,
      PrefetchHooks Function({
        bool phasesRefs,
        bool milestonesRefs,
        bool tasksRefs,
        bool weeklyAssignmentsRefs,
      })
    >;
typedef $$PhasesTableCreateCompanionBuilder = PhasesCompanion Function({
  Value<int> id,
  required int projectId,
  required String title,
  Value<String?> goal,
  required int orderIndex,
  required DateTime createdAt,
});
typedef $$PhasesTableUpdateCompanionBuilder = PhasesCompanion Function({
  Value<int> id,
  Value<int> projectId,
  Value<String> title,
  Value<String?> goal,
  Value<int> orderIndex,
  Value<DateTime> createdAt,
});

final class $$PhasesTableReferences
    extends BaseReferences<_$AppDatabase, $PhasesTable, PhasesRow> {
  $$PhasesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $ProjectsTable _projectIdTable(_$AppDatabase db) =>
      db.projects.createAlias('phases__project_id__projects__id');

  $$ProjectsTableProcessedTableManager get projectId {
    final $_column = $_itemColumn<int>('project_id')!;

    final manager = $$ProjectsTableTableManager(
      $_db,
      $_db.projects,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_projectIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$MilestonesTable, List<MilestonesRow>>
  _milestonesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.milestones,
    aliasName: 'phases__id__milestones__phase_id',
  );

  $$MilestonesTableProcessedTableManager get milestonesRefs {
    final manager = $$MilestonesTableTableManager(
      $_db,
      $_db.milestones,
    ).filter((f) => f.phaseId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_milestonesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$TasksTable, List<TasksRow>> _tasksRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.tasks,
    aliasName: 'phases__id__tasks__phase_id',
  );

  $$TasksTableProcessedTableManager get tasksRefs {
    final manager = $$TasksTableTableManager(
      $_db,
      $_db.tasks,
    ).filter((f) => f.phaseId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_tasksRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$PhasesTableFilterComposer
    extends Composer<_$AppDatabase, $PhasesTable> {
  $$PhasesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get goal => $composableBuilder(
    column: $table.goal,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get orderIndex => $composableBuilder(
    column: $table.orderIndex,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  $$ProjectsTableFilterComposer get projectId {
    final $$ProjectsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.projectId,
      referencedTable: $db.projects,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProjectsTableFilterComposer(
            $db: $db,
            $table: $db.projects,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> milestonesRefs(
    Expression<bool> Function($$MilestonesTableFilterComposer f) f,
  ) {
    final $$MilestonesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.milestones,
      getReferencedColumn: (t) => t.phaseId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MilestonesTableFilterComposer(
            $db: $db,
            $table: $db.milestones,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> tasksRefs(
    Expression<bool> Function($$TasksTableFilterComposer f) f,
  ) {
    final $$TasksTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.tasks,
      getReferencedColumn: (t) => t.phaseId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TasksTableFilterComposer(
            $db: $db,
            $table: $db.tasks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$PhasesTableOrderingComposer
    extends Composer<_$AppDatabase, $PhasesTable> {
  $$PhasesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get goal => $composableBuilder(
    column: $table.goal,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get orderIndex => $composableBuilder(
    column: $table.orderIndex,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$ProjectsTableOrderingComposer get projectId {
    final $$ProjectsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.projectId,
      referencedTable: $db.projects,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProjectsTableOrderingComposer(
            $db: $db,
            $table: $db.projects,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PhasesTableAnnotationComposer
    extends Composer<_$AppDatabase, $PhasesTable> {
  $$PhasesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get goal =>
      $composableBuilder(column: $table.goal, builder: (column) => column);

  GeneratedColumn<int> get orderIndex => $composableBuilder(
    column: $table.orderIndex,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$ProjectsTableAnnotationComposer get projectId {
    final $$ProjectsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.projectId,
      referencedTable: $db.projects,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProjectsTableAnnotationComposer(
            $db: $db,
            $table: $db.projects,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> milestonesRefs<T extends Object>(
    Expression<T> Function($$MilestonesTableAnnotationComposer a) f,
  ) {
    final $$MilestonesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.milestones,
      getReferencedColumn: (t) => t.phaseId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MilestonesTableAnnotationComposer(
            $db: $db,
            $table: $db.milestones,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> tasksRefs<T extends Object>(
    Expression<T> Function($$TasksTableAnnotationComposer a) f,
  ) {
    final $$TasksTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.tasks,
      getReferencedColumn: (t) => t.phaseId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TasksTableAnnotationComposer(
            $db: $db,
            $table: $db.tasks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$PhasesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PhasesTable,
          PhasesRow,
          $$PhasesTableFilterComposer,
          $$PhasesTableOrderingComposer,
          $$PhasesTableAnnotationComposer,
          $$PhasesTableCreateCompanionBuilder,
          $$PhasesTableUpdateCompanionBuilder,
          (PhasesRow, $$PhasesTableReferences),
          PhasesRow,
          PrefetchHooks Function({
            bool projectId,
            bool milestonesRefs,
            bool tasksRefs,
          })
        > {
  $$PhasesTableTableManager(_$AppDatabase db, $PhasesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PhasesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PhasesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PhasesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> projectId = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String?> goal = const Value.absent(),
                Value<int> orderIndex = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => PhasesCompanion(
                id: id,
                projectId: projectId,
                title: title,
                goal: goal,
                orderIndex: orderIndex,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int projectId,
                required String title,
                Value<String?> goal = const Value.absent(),
                required int orderIndex,
                required DateTime createdAt,
              }) => PhasesCompanion.insert(
                id: id,
                projectId: projectId,
                title: title,
                goal: goal,
                orderIndex: orderIndex,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$PhasesTable, PhasesRow>(table),
                  $$PhasesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({projectId = false, milestonesRefs = false, tasksRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (milestonesRefs) db.milestones,
                    if (tasksRefs) db.tasks,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (projectId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.projectId,
                            referencedTable: $$PhasesTableReferences
                                ._projectIdTable(db),
                            referencedColumn: $$PhasesTableReferences
                                ._projectIdTable(db)
                                .id,
                          ) as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (milestonesRefs)
                        await $_getPrefetchedData<
                          PhasesRow,
                          $PhasesTable,
                          MilestonesRow
                        >(
                          currentTable: table,
                          referencedTable: $$PhasesTableReferences
                              ._milestonesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$PhasesTableReferences(
                                db,
                                table,
                                p0,
                              ).milestonesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.phaseId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (tasksRefs)
                        await $_getPrefetchedData<
                          PhasesRow,
                          $PhasesTable,
                          TasksRow
                        >(
                          currentTable: table,
                          referencedTable: $$PhasesTableReferences
                              ._tasksRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$PhasesTableReferences(db, table, p0).tasksRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.phaseId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$PhasesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PhasesTable,
      PhasesRow,
      $$PhasesTableFilterComposer,
      $$PhasesTableOrderingComposer,
      $$PhasesTableAnnotationComposer,
      $$PhasesTableCreateCompanionBuilder,
      $$PhasesTableUpdateCompanionBuilder,
      (PhasesRow, $$PhasesTableReferences),
      PhasesRow,
      PrefetchHooks Function({
        bool projectId,
        bool milestonesRefs,
        bool tasksRefs,
      })
    >;
typedef $$MilestonesTableCreateCompanionBuilder = MilestonesCompanion Function({
  Value<int> id,
  required int projectId,
  required int phaseId,
  required String title,
  required int orderIndex,
  Value<DateTime?> completedAt,
  required DateTime createdAt,
});
typedef $$MilestonesTableUpdateCompanionBuilder = MilestonesCompanion Function({
  Value<int> id,
  Value<int> projectId,
  Value<int> phaseId,
  Value<String> title,
  Value<int> orderIndex,
  Value<DateTime?> completedAt,
  Value<DateTime> createdAt,
});

final class $$MilestonesTableReferences
    extends BaseReferences<_$AppDatabase, $MilestonesTable, MilestonesRow> {
  $$MilestonesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $ProjectsTable _projectIdTable(_$AppDatabase db) =>
      db.projects.createAlias('milestones__project_id__projects__id');

  $$ProjectsTableProcessedTableManager get projectId {
    final $_column = $_itemColumn<int>('project_id')!;

    final manager = $$ProjectsTableTableManager(
      $_db,
      $_db.projects,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_projectIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $PhasesTable _phaseIdTable(_$AppDatabase db) =>
      db.phases.createAlias('milestones__phase_id__phases__id');

  $$PhasesTableProcessedTableManager get phaseId {
    final $_column = $_itemColumn<int>('phase_id')!;

    final manager = $$PhasesTableTableManager(
      $_db,
      $_db.phases,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_phaseIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$MilestonesTableFilterComposer
    extends Composer<_$AppDatabase, $MilestonesTable> {
  $$MilestonesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get orderIndex => $composableBuilder(
    column: $table.orderIndex,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  $$ProjectsTableFilterComposer get projectId {
    final $$ProjectsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.projectId,
      referencedTable: $db.projects,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProjectsTableFilterComposer(
            $db: $db,
            $table: $db.projects,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$PhasesTableFilterComposer get phaseId {
    final $$PhasesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.phaseId,
      referencedTable: $db.phases,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PhasesTableFilterComposer(
            $db: $db,
            $table: $db.phases,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$MilestonesTableOrderingComposer
    extends Composer<_$AppDatabase, $MilestonesTable> {
  $$MilestonesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get orderIndex => $composableBuilder(
    column: $table.orderIndex,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$ProjectsTableOrderingComposer get projectId {
    final $$ProjectsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.projectId,
      referencedTable: $db.projects,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProjectsTableOrderingComposer(
            $db: $db,
            $table: $db.projects,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$PhasesTableOrderingComposer get phaseId {
    final $$PhasesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.phaseId,
      referencedTable: $db.phases,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PhasesTableOrderingComposer(
            $db: $db,
            $table: $db.phases,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$MilestonesTableAnnotationComposer
    extends Composer<_$AppDatabase, $MilestonesTable> {
  $$MilestonesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<int> get orderIndex => $composableBuilder(
    column: $table.orderIndex,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$ProjectsTableAnnotationComposer get projectId {
    final $$ProjectsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.projectId,
      referencedTable: $db.projects,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProjectsTableAnnotationComposer(
            $db: $db,
            $table: $db.projects,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$PhasesTableAnnotationComposer get phaseId {
    final $$PhasesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.phaseId,
      referencedTable: $db.phases,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PhasesTableAnnotationComposer(
            $db: $db,
            $table: $db.phases,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$MilestonesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $MilestonesTable,
          MilestonesRow,
          $$MilestonesTableFilterComposer,
          $$MilestonesTableOrderingComposer,
          $$MilestonesTableAnnotationComposer,
          $$MilestonesTableCreateCompanionBuilder,
          $$MilestonesTableUpdateCompanionBuilder,
          (MilestonesRow, $$MilestonesTableReferences),
          MilestonesRow,
          PrefetchHooks Function({bool projectId, bool phaseId})
        > {
  $$MilestonesTableTableManager(_$AppDatabase db, $MilestonesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MilestonesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MilestonesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MilestonesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> projectId = const Value.absent(),
                Value<int> phaseId = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<int> orderIndex = const Value.absent(),
                Value<DateTime?> completedAt = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => MilestonesCompanion(
                id: id,
                projectId: projectId,
                phaseId: phaseId,
                title: title,
                orderIndex: orderIndex,
                completedAt: completedAt,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int projectId,
                required int phaseId,
                required String title,
                required int orderIndex,
                Value<DateTime?> completedAt = const Value.absent(),
                required DateTime createdAt,
              }) => MilestonesCompanion.insert(
                id: id,
                projectId: projectId,
                phaseId: phaseId,
                title: title,
                orderIndex: orderIndex,
                completedAt: completedAt,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$MilestonesTable, MilestonesRow>(table),
                  $$MilestonesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({projectId = false, phaseId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (projectId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.projectId,
                        referencedTable: $$MilestonesTableReferences
                            ._projectIdTable(db),
                        referencedColumn: $$MilestonesTableReferences
                            ._projectIdTable(db)
                            .id,
                      ) as T;
                    }
                    if (phaseId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.phaseId,
                        referencedTable: $$MilestonesTableReferences
                            ._phaseIdTable(db),
                        referencedColumn: $$MilestonesTableReferences
                            ._phaseIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$MilestonesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $MilestonesTable,
      MilestonesRow,
      $$MilestonesTableFilterComposer,
      $$MilestonesTableOrderingComposer,
      $$MilestonesTableAnnotationComposer,
      $$MilestonesTableCreateCompanionBuilder,
      $$MilestonesTableUpdateCompanionBuilder,
      (MilestonesRow, $$MilestonesTableReferences),
      MilestonesRow,
      PrefetchHooks Function({bool projectId, bool phaseId})
    >;
typedef $$TasksTableCreateCompanionBuilder = TasksCompanion Function({
  Value<int> id,
  required int projectId,
  required int phaseId,
  Value<int?> milestoneId,
  required String title,
  Value<String?> description,
  required dom.TaskStatus status,
  required dom.TaskPriority priority,
  required dom.EstimatedEffort effort,
  Value<DateTime?> dueDate,
  Value<int?> sourceRefId,
  Value<String?> outcomeNote,
  Value<String?> userNote,
  required int orderIndex,
  required DateTime createdAt,
  required DateTime updatedAt,
});
typedef $$TasksTableUpdateCompanionBuilder = TasksCompanion Function({
  Value<int> id,
  Value<int> projectId,
  Value<int> phaseId,
  Value<int?> milestoneId,
  Value<String> title,
  Value<String?> description,
  Value<dom.TaskStatus> status,
  Value<dom.TaskPriority> priority,
  Value<dom.EstimatedEffort> effort,
  Value<DateTime?> dueDate,
  Value<int?> sourceRefId,
  Value<String?> outcomeNote,
  Value<String?> userNote,
  Value<int> orderIndex,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
});

final class $$TasksTableReferences
    extends BaseReferences<_$AppDatabase, $TasksTable, TasksRow> {
  $$TasksTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $ProjectsTable _projectIdTable(_$AppDatabase db) =>
      db.projects.createAlias('tasks__project_id__projects__id');

  $$ProjectsTableProcessedTableManager get projectId {
    final $_column = $_itemColumn<int>('project_id')!;

    final manager = $$ProjectsTableTableManager(
      $_db,
      $_db.projects,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_projectIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $PhasesTable _phaseIdTable(_$AppDatabase db) =>
      db.phases.createAlias('tasks__phase_id__phases__id');

  $$PhasesTableProcessedTableManager get phaseId {
    final $_column = $_itemColumn<int>('phase_id')!;

    final manager = $$PhasesTableTableManager(
      $_db,
      $_db.phases,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_phaseIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$WeeklyAssignmentsTable, List<WeeklyAssignmentRow>>
  _weeklyAssignmentsRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.weeklyAssignments,
        aliasName: 'tasks__id__weekly_assignments__task_id',
      );

  $$WeeklyAssignmentsTableProcessedTableManager get weeklyAssignmentsRefs {
    final manager = $$WeeklyAssignmentsTableTableManager(
      $_db,
      $_db.weeklyAssignments,
    ).filter((f) => f.taskId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _weeklyAssignmentsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$TasksTableFilterComposer extends Composer<_$AppDatabase, $TasksTable> {
  $$TasksTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get milestoneId => $composableBuilder(
    column: $table.milestoneId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<dom.TaskStatus, dom.TaskStatus, String>
  get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnWithTypeConverterFilters<dom.TaskPriority, dom.TaskPriority, String>
  get priority => $composableBuilder(
    column: $table.priority,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnWithTypeConverterFilters<
    dom.EstimatedEffort,
    dom.EstimatedEffort,
    String
  >
  get effort => $composableBuilder(
    column: $table.effort,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<DateTime> get dueDate => $composableBuilder(
    column: $table.dueDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sourceRefId => $composableBuilder(
    column: $table.sourceRefId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get outcomeNote => $composableBuilder(
    column: $table.outcomeNote,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get userNote => $composableBuilder(
    column: $table.userNote,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get orderIndex => $composableBuilder(
    column: $table.orderIndex,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$ProjectsTableFilterComposer get projectId {
    final $$ProjectsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.projectId,
      referencedTable: $db.projects,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProjectsTableFilterComposer(
            $db: $db,
            $table: $db.projects,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$PhasesTableFilterComposer get phaseId {
    final $$PhasesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.phaseId,
      referencedTable: $db.phases,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PhasesTableFilterComposer(
            $db: $db,
            $table: $db.phases,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> weeklyAssignmentsRefs(
    Expression<bool> Function($$WeeklyAssignmentsTableFilterComposer f) f,
  ) {
    final $$WeeklyAssignmentsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.weeklyAssignments,
      getReferencedColumn: (t) => t.taskId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WeeklyAssignmentsTableFilterComposer(
            $db: $db,
            $table: $db.weeklyAssignments,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$TasksTableOrderingComposer
    extends Composer<_$AppDatabase, $TasksTable> {
  $$TasksTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get milestoneId => $composableBuilder(
    column: $table.milestoneId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get priority => $composableBuilder(
    column: $table.priority,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get effort => $composableBuilder(
    column: $table.effort,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get dueDate => $composableBuilder(
    column: $table.dueDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sourceRefId => $composableBuilder(
    column: $table.sourceRefId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get outcomeNote => $composableBuilder(
    column: $table.outcomeNote,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get userNote => $composableBuilder(
    column: $table.userNote,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get orderIndex => $composableBuilder(
    column: $table.orderIndex,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$ProjectsTableOrderingComposer get projectId {
    final $$ProjectsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.projectId,
      referencedTable: $db.projects,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProjectsTableOrderingComposer(
            $db: $db,
            $table: $db.projects,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$PhasesTableOrderingComposer get phaseId {
    final $$PhasesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.phaseId,
      referencedTable: $db.phases,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PhasesTableOrderingComposer(
            $db: $db,
            $table: $db.phases,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TasksTableAnnotationComposer
    extends Composer<_$AppDatabase, $TasksTable> {
  $$TasksTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get milestoneId => $composableBuilder(
    column: $table.milestoneId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<dom.TaskStatus, String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumnWithTypeConverter<dom.TaskPriority, String> get priority =>
      $composableBuilder(column: $table.priority, builder: (column) => column);

  GeneratedColumnWithTypeConverter<dom.EstimatedEffort, String> get effort =>
      $composableBuilder(column: $table.effort, builder: (column) => column);

  GeneratedColumn<DateTime> get dueDate =>
      $composableBuilder(column: $table.dueDate, builder: (column) => column);

  GeneratedColumn<int> get sourceRefId => $composableBuilder(
    column: $table.sourceRefId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get outcomeNote => $composableBuilder(
    column: $table.outcomeNote,
    builder: (column) => column,
  );

  GeneratedColumn<String> get userNote =>
      $composableBuilder(column: $table.userNote, builder: (column) => column);

  GeneratedColumn<int> get orderIndex => $composableBuilder(
    column: $table.orderIndex,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  $$ProjectsTableAnnotationComposer get projectId {
    final $$ProjectsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.projectId,
      referencedTable: $db.projects,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProjectsTableAnnotationComposer(
            $db: $db,
            $table: $db.projects,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$PhasesTableAnnotationComposer get phaseId {
    final $$PhasesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.phaseId,
      referencedTable: $db.phases,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PhasesTableAnnotationComposer(
            $db: $db,
            $table: $db.phases,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> weeklyAssignmentsRefs<T extends Object>(
    Expression<T> Function($$WeeklyAssignmentsTableAnnotationComposer a) f,
  ) {
    final $$WeeklyAssignmentsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.weeklyAssignments,
          getReferencedColumn: (t) => t.taskId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$WeeklyAssignmentsTableAnnotationComposer(
                $db: $db,
                $table: $db.weeklyAssignments,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$TasksTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TasksTable,
          TasksRow,
          $$TasksTableFilterComposer,
          $$TasksTableOrderingComposer,
          $$TasksTableAnnotationComposer,
          $$TasksTableCreateCompanionBuilder,
          $$TasksTableUpdateCompanionBuilder,
          (TasksRow, $$TasksTableReferences),
          TasksRow,
          PrefetchHooks Function({
            bool projectId,
            bool phaseId,
            bool weeklyAssignmentsRefs,
          })
        > {
  $$TasksTableTableManager(_$AppDatabase db, $TasksTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TasksTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TasksTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TasksTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> projectId = const Value.absent(),
                Value<int> phaseId = const Value.absent(),
                Value<int?> milestoneId = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String?> description = const Value.absent(),
                Value<dom.TaskStatus> status = const Value.absent(),
                Value<dom.TaskPriority> priority = const Value.absent(),
                Value<dom.EstimatedEffort> effort = const Value.absent(),
                Value<DateTime?> dueDate = const Value.absent(),
                Value<int?> sourceRefId = const Value.absent(),
                Value<String?> outcomeNote = const Value.absent(),
                Value<String?> userNote = const Value.absent(),
                Value<int> orderIndex = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => TasksCompanion(
                id: id,
                projectId: projectId,
                phaseId: phaseId,
                milestoneId: milestoneId,
                title: title,
                description: description,
                status: status,
                priority: priority,
                effort: effort,
                dueDate: dueDate,
                sourceRefId: sourceRefId,
                outcomeNote: outcomeNote,
                userNote: userNote,
                orderIndex: orderIndex,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int projectId,
                required int phaseId,
                Value<int?> milestoneId = const Value.absent(),
                required String title,
                Value<String?> description = const Value.absent(),
                required dom.TaskStatus status,
                required dom.TaskPriority priority,
                required dom.EstimatedEffort effort,
                Value<DateTime?> dueDate = const Value.absent(),
                Value<int?> sourceRefId = const Value.absent(),
                Value<String?> outcomeNote = const Value.absent(),
                Value<String?> userNote = const Value.absent(),
                required int orderIndex,
                required DateTime createdAt,
                required DateTime updatedAt,
              }) => TasksCompanion.insert(
                id: id,
                projectId: projectId,
                phaseId: phaseId,
                milestoneId: milestoneId,
                title: title,
                description: description,
                status: status,
                priority: priority,
                effort: effort,
                dueDate: dueDate,
                sourceRefId: sourceRefId,
                outcomeNote: outcomeNote,
                userNote: userNote,
                orderIndex: orderIndex,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$TasksTable, TasksRow>(table),
                  $$TasksTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                projectId = false,
                phaseId = false,
                weeklyAssignmentsRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (weeklyAssignmentsRefs) db.weeklyAssignments,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (projectId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.projectId,
                            referencedTable: $$TasksTableReferences
                                ._projectIdTable(db),
                            referencedColumn: $$TasksTableReferences
                                ._projectIdTable(db)
                                .id,
                          ) as T;
                        }
                        if (phaseId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.phaseId,
                            referencedTable: $$TasksTableReferences
                                ._phaseIdTable(db),
                            referencedColumn: $$TasksTableReferences
                                ._phaseIdTable(db)
                                .id,
                          ) as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (weeklyAssignmentsRefs)
                        await $_getPrefetchedData<
                          TasksRow,
                          $TasksTable,
                          WeeklyAssignmentRow
                        >(
                          currentTable: table,
                          referencedTable: $$TasksTableReferences
                              ._weeklyAssignmentsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$TasksTableReferences(
                                db,
                                table,
                                p0,
                              ).weeklyAssignmentsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.taskId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$TasksTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TasksTable,
      TasksRow,
      $$TasksTableFilterComposer,
      $$TasksTableOrderingComposer,
      $$TasksTableAnnotationComposer,
      $$TasksTableCreateCompanionBuilder,
      $$TasksTableUpdateCompanionBuilder,
      (TasksRow, $$TasksTableReferences),
      TasksRow,
      PrefetchHooks Function({
        bool projectId,
        bool phaseId,
        bool weeklyAssignmentsRefs,
      })
    >;
typedef $$TaskDependenciesTableCreateCompanionBuilder =
    TaskDependenciesCompanion Function({
      Value<int> id,
      required int taskId,
      required int dependsOnTaskId,
    });
typedef $$TaskDependenciesTableUpdateCompanionBuilder =
    TaskDependenciesCompanion Function({
      Value<int> id,
      Value<int> taskId,
      Value<int> dependsOnTaskId,
    });

final class $$TaskDependenciesTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $TaskDependenciesTable,
          TaskDependencyRow
        > {
  $$TaskDependenciesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $TasksTable _taskIdTable(_$AppDatabase db) =>
      db.tasks.createAlias('task_dependencies__task_id__tasks__id');

  $$TasksTableProcessedTableManager get taskId {
    final $_column = $_itemColumn<int>('task_id')!;

    final manager = $$TasksTableTableManager(
      $_db,
      $_db.tasks,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_taskIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $TasksTable _dependsOnTaskIdTable(_$AppDatabase db) =>
      db.tasks.createAlias('task_dependencies__depends_on_task_id__tasks__id');

  $$TasksTableProcessedTableManager get dependsOnTaskId {
    final $_column = $_itemColumn<int>('depends_on_task_id')!;

    final manager = $$TasksTableTableManager(
      $_db,
      $_db.tasks,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_dependsOnTaskIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$TaskDependenciesTableFilterComposer
    extends Composer<_$AppDatabase, $TaskDependenciesTable> {
  $$TaskDependenciesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  $$TasksTableFilterComposer get taskId {
    final $$TasksTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.taskId,
      referencedTable: $db.tasks,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TasksTableFilterComposer(
            $db: $db,
            $table: $db.tasks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$TasksTableFilterComposer get dependsOnTaskId {
    final $$TasksTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.dependsOnTaskId,
      referencedTable: $db.tasks,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TasksTableFilterComposer(
            $db: $db,
            $table: $db.tasks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TaskDependenciesTableOrderingComposer
    extends Composer<_$AppDatabase, $TaskDependenciesTable> {
  $$TaskDependenciesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  $$TasksTableOrderingComposer get taskId {
    final $$TasksTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.taskId,
      referencedTable: $db.tasks,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TasksTableOrderingComposer(
            $db: $db,
            $table: $db.tasks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$TasksTableOrderingComposer get dependsOnTaskId {
    final $$TasksTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.dependsOnTaskId,
      referencedTable: $db.tasks,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TasksTableOrderingComposer(
            $db: $db,
            $table: $db.tasks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TaskDependenciesTableAnnotationComposer
    extends Composer<_$AppDatabase, $TaskDependenciesTable> {
  $$TaskDependenciesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  $$TasksTableAnnotationComposer get taskId {
    final $$TasksTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.taskId,
      referencedTable: $db.tasks,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TasksTableAnnotationComposer(
            $db: $db,
            $table: $db.tasks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$TasksTableAnnotationComposer get dependsOnTaskId {
    final $$TasksTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.dependsOnTaskId,
      referencedTable: $db.tasks,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TasksTableAnnotationComposer(
            $db: $db,
            $table: $db.tasks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TaskDependenciesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TaskDependenciesTable,
          TaskDependencyRow,
          $$TaskDependenciesTableFilterComposer,
          $$TaskDependenciesTableOrderingComposer,
          $$TaskDependenciesTableAnnotationComposer,
          $$TaskDependenciesTableCreateCompanionBuilder,
          $$TaskDependenciesTableUpdateCompanionBuilder,
          (TaskDependencyRow, $$TaskDependenciesTableReferences),
          TaskDependencyRow,
          PrefetchHooks Function({bool taskId, bool dependsOnTaskId})
        > {
  $$TaskDependenciesTableTableManager(
    _$AppDatabase db,
    $TaskDependenciesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TaskDependenciesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TaskDependenciesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TaskDependenciesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> taskId = const Value.absent(),
                Value<int> dependsOnTaskId = const Value.absent(),
              }) => TaskDependenciesCompanion(
                id: id,
                taskId: taskId,
                dependsOnTaskId: dependsOnTaskId,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int taskId,
                required int dependsOnTaskId,
              }) => TaskDependenciesCompanion.insert(
                id: id,
                taskId: taskId,
                dependsOnTaskId: dependsOnTaskId,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$TaskDependenciesTable, TaskDependencyRow>(table),
                  $$TaskDependenciesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({taskId = false, dependsOnTaskId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (taskId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.taskId,
                        referencedTable: $$TaskDependenciesTableReferences
                            ._taskIdTable(db),
                        referencedColumn: $$TaskDependenciesTableReferences
                            ._taskIdTable(db)
                            .id,
                      ) as T;
                    }
                    if (dependsOnTaskId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.dependsOnTaskId,
                        referencedTable: $$TaskDependenciesTableReferences
                            ._dependsOnTaskIdTable(db),
                        referencedColumn: $$TaskDependenciesTableReferences
                            ._dependsOnTaskIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$TaskDependenciesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TaskDependenciesTable,
      TaskDependencyRow,
      $$TaskDependenciesTableFilterComposer,
      $$TaskDependenciesTableOrderingComposer,
      $$TaskDependenciesTableAnnotationComposer,
      $$TaskDependenciesTableCreateCompanionBuilder,
      $$TaskDependenciesTableUpdateCompanionBuilder,
      (TaskDependencyRow, $$TaskDependenciesTableReferences),
      TaskDependencyRow,
      PrefetchHooks Function({bool taskId, bool dependsOnTaskId})
    >;
typedef $$SourceRefsTableCreateCompanionBuilder = SourceRefsCompanion Function({
  Value<int> id,
  required dom.SourceKind kind,
  required String quote,
  Value<String> aiReason,
  Value<int?> documentId,
  required DateTime createdAt,
});
typedef $$SourceRefsTableUpdateCompanionBuilder = SourceRefsCompanion Function({
  Value<int> id,
  Value<dom.SourceKind> kind,
  Value<String> quote,
  Value<String> aiReason,
  Value<int?> documentId,
  Value<DateTime> createdAt,
});

class $$SourceRefsTableFilterComposer
    extends Composer<_$AppDatabase, $SourceRefsTable> {
  $$SourceRefsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<dom.SourceKind, dom.SourceKind, String>
  get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<String> get quote => $composableBuilder(
    column: $table.quote,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get aiReason => $composableBuilder(
    column: $table.aiReason,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get documentId => $composableBuilder(
    column: $table.documentId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SourceRefsTableOrderingComposer
    extends Composer<_$AppDatabase, $SourceRefsTable> {
  $$SourceRefsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get quote => $composableBuilder(
    column: $table.quote,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get aiReason => $composableBuilder(
    column: $table.aiReason,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get documentId => $composableBuilder(
    column: $table.documentId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SourceRefsTableAnnotationComposer
    extends Composer<_$AppDatabase, $SourceRefsTable> {
  $$SourceRefsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumnWithTypeConverter<dom.SourceKind, String> get kind =>
      $composableBuilder(column: $table.kind, builder: (column) => column);

  GeneratedColumn<String> get quote =>
      $composableBuilder(column: $table.quote, builder: (column) => column);

  GeneratedColumn<String> get aiReason =>
      $composableBuilder(column: $table.aiReason, builder: (column) => column);

  GeneratedColumn<int> get documentId => $composableBuilder(
    column: $table.documentId,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$SourceRefsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SourceRefsTable,
          SourceRefRow,
          $$SourceRefsTableFilterComposer,
          $$SourceRefsTableOrderingComposer,
          $$SourceRefsTableAnnotationComposer,
          $$SourceRefsTableCreateCompanionBuilder,
          $$SourceRefsTableUpdateCompanionBuilder,
          (
            SourceRefRow,
            BaseReferences<_$AppDatabase, $SourceRefsTable, SourceRefRow>,
          ),
          SourceRefRow,
          PrefetchHooks Function()
        > {
  $$SourceRefsTableTableManager(_$AppDatabase db, $SourceRefsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SourceRefsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SourceRefsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SourceRefsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<dom.SourceKind> kind = const Value.absent(),
                Value<String> quote = const Value.absent(),
                Value<String> aiReason = const Value.absent(),
                Value<int?> documentId = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => SourceRefsCompanion(
                id: id,
                kind: kind,
                quote: quote,
                aiReason: aiReason,
                documentId: documentId,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required dom.SourceKind kind,
                required String quote,
                Value<String> aiReason = const Value.absent(),
                Value<int?> documentId = const Value.absent(),
                required DateTime createdAt,
              }) => SourceRefsCompanion.insert(
                id: id,
                kind: kind,
                quote: quote,
                aiReason: aiReason,
                documentId: documentId,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$SourceRefsTable, SourceRefRow>(table),
                  BaseReferences<_$AppDatabase, $SourceRefsTable, SourceRefRow>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SourceRefsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SourceRefsTable,
      SourceRefRow,
      $$SourceRefsTableFilterComposer,
      $$SourceRefsTableOrderingComposer,
      $$SourceRefsTableAnnotationComposer,
      $$SourceRefsTableCreateCompanionBuilder,
      $$SourceRefsTableUpdateCompanionBuilder,
      (
        SourceRefRow,
        BaseReferences<_$AppDatabase, $SourceRefsTable, SourceRefRow>,
      ),
      SourceRefRow,
      PrefetchHooks Function()
    >;
typedef $$WeekSettingsTableCreateCompanionBuilder =
    WeekSettingsCompanion Function({
      Value<int> id,
      required DateTime weekStart,
      required dom.CapacityLevel capacity,
    });
typedef $$WeekSettingsTableUpdateCompanionBuilder =
    WeekSettingsCompanion Function({
      Value<int> id,
      Value<DateTime> weekStart,
      Value<dom.CapacityLevel> capacity,
    });

class $$WeekSettingsTableFilterComposer
    extends Composer<_$AppDatabase, $WeekSettingsTable> {
  $$WeekSettingsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get weekStart => $composableBuilder(
    column: $table.weekStart,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<dom.CapacityLevel, dom.CapacityLevel, String>
  get capacity => $composableBuilder(
    column: $table.capacity,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );
}

class $$WeekSettingsTableOrderingComposer
    extends Composer<_$AppDatabase, $WeekSettingsTable> {
  $$WeekSettingsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get weekStart => $composableBuilder(
    column: $table.weekStart,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get capacity => $composableBuilder(
    column: $table.capacity,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$WeekSettingsTableAnnotationComposer
    extends Composer<_$AppDatabase, $WeekSettingsTable> {
  $$WeekSettingsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get weekStart =>
      $composableBuilder(column: $table.weekStart, builder: (column) => column);

  GeneratedColumnWithTypeConverter<dom.CapacityLevel, String> get capacity =>
      $composableBuilder(column: $table.capacity, builder: (column) => column);
}

class $$WeekSettingsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $WeekSettingsTable,
          WeekSettingRow,
          $$WeekSettingsTableFilterComposer,
          $$WeekSettingsTableOrderingComposer,
          $$WeekSettingsTableAnnotationComposer,
          $$WeekSettingsTableCreateCompanionBuilder,
          $$WeekSettingsTableUpdateCompanionBuilder,
          (
            WeekSettingRow,
            BaseReferences<_$AppDatabase, $WeekSettingsTable, WeekSettingRow>,
          ),
          WeekSettingRow,
          PrefetchHooks Function()
        > {
  $$WeekSettingsTableTableManager(_$AppDatabase db, $WeekSettingsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$WeekSettingsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$WeekSettingsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$WeekSettingsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<DateTime> weekStart = const Value.absent(),
                Value<dom.CapacityLevel> capacity = const Value.absent(),
              }) => WeekSettingsCompanion(
                id: id,
                weekStart: weekStart,
                capacity: capacity,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required DateTime weekStart,
                required dom.CapacityLevel capacity,
              }) => WeekSettingsCompanion.insert(
                id: id,
                weekStart: weekStart,
                capacity: capacity,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$WeekSettingsTable, WeekSettingRow>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $WeekSettingsTable,
                    WeekSettingRow
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$WeekSettingsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $WeekSettingsTable,
      WeekSettingRow,
      $$WeekSettingsTableFilterComposer,
      $$WeekSettingsTableOrderingComposer,
      $$WeekSettingsTableAnnotationComposer,
      $$WeekSettingsTableCreateCompanionBuilder,
      $$WeekSettingsTableUpdateCompanionBuilder,
      (
        WeekSettingRow,
        BaseReferences<_$AppDatabase, $WeekSettingsTable, WeekSettingRow>,
      ),
      WeekSettingRow,
      PrefetchHooks Function()
    >;
typedef $$WeeklyAssignmentsTableCreateCompanionBuilder =
    WeeklyAssignmentsCompanion Function({
      Value<int> id,
      required DateTime weekStart,
      required int taskId,
      required int projectId,
      required DateTime addedAt,
    });
typedef $$WeeklyAssignmentsTableUpdateCompanionBuilder =
    WeeklyAssignmentsCompanion Function({
      Value<int> id,
      Value<DateTime> weekStart,
      Value<int> taskId,
      Value<int> projectId,
      Value<DateTime> addedAt,
    });

final class $$WeeklyAssignmentsTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $WeeklyAssignmentsTable,
          WeeklyAssignmentRow
        > {
  $$WeeklyAssignmentsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $TasksTable _taskIdTable(_$AppDatabase db) =>
      db.tasks.createAlias('weekly_assignments__task_id__tasks__id');

  $$TasksTableProcessedTableManager get taskId {
    final $_column = $_itemColumn<int>('task_id')!;

    final manager = $$TasksTableTableManager(
      $_db,
      $_db.tasks,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_taskIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $ProjectsTable _projectIdTable(_$AppDatabase db) =>
      db.projects.createAlias('weekly_assignments__project_id__projects__id');

  $$ProjectsTableProcessedTableManager get projectId {
    final $_column = $_itemColumn<int>('project_id')!;

    final manager = $$ProjectsTableTableManager(
      $_db,
      $_db.projects,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_projectIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$WeeklyAssignmentsTableFilterComposer
    extends Composer<_$AppDatabase, $WeeklyAssignmentsTable> {
  $$WeeklyAssignmentsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get weekStart => $composableBuilder(
    column: $table.weekStart,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get addedAt => $composableBuilder(
    column: $table.addedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$TasksTableFilterComposer get taskId {
    final $$TasksTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.taskId,
      referencedTable: $db.tasks,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TasksTableFilterComposer(
            $db: $db,
            $table: $db.tasks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ProjectsTableFilterComposer get projectId {
    final $$ProjectsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.projectId,
      referencedTable: $db.projects,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProjectsTableFilterComposer(
            $db: $db,
            $table: $db.projects,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$WeeklyAssignmentsTableOrderingComposer
    extends Composer<_$AppDatabase, $WeeklyAssignmentsTable> {
  $$WeeklyAssignmentsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get weekStart => $composableBuilder(
    column: $table.weekStart,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get addedAt => $composableBuilder(
    column: $table.addedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$TasksTableOrderingComposer get taskId {
    final $$TasksTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.taskId,
      referencedTable: $db.tasks,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TasksTableOrderingComposer(
            $db: $db,
            $table: $db.tasks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ProjectsTableOrderingComposer get projectId {
    final $$ProjectsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.projectId,
      referencedTable: $db.projects,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProjectsTableOrderingComposer(
            $db: $db,
            $table: $db.projects,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$WeeklyAssignmentsTableAnnotationComposer
    extends Composer<_$AppDatabase, $WeeklyAssignmentsTable> {
  $$WeeklyAssignmentsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get weekStart =>
      $composableBuilder(column: $table.weekStart, builder: (column) => column);

  GeneratedColumn<DateTime> get addedAt =>
      $composableBuilder(column: $table.addedAt, builder: (column) => column);

  $$TasksTableAnnotationComposer get taskId {
    final $$TasksTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.taskId,
      referencedTable: $db.tasks,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TasksTableAnnotationComposer(
            $db: $db,
            $table: $db.tasks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ProjectsTableAnnotationComposer get projectId {
    final $$ProjectsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.projectId,
      referencedTable: $db.projects,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProjectsTableAnnotationComposer(
            $db: $db,
            $table: $db.projects,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$WeeklyAssignmentsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $WeeklyAssignmentsTable,
          WeeklyAssignmentRow,
          $$WeeklyAssignmentsTableFilterComposer,
          $$WeeklyAssignmentsTableOrderingComposer,
          $$WeeklyAssignmentsTableAnnotationComposer,
          $$WeeklyAssignmentsTableCreateCompanionBuilder,
          $$WeeklyAssignmentsTableUpdateCompanionBuilder,
          (WeeklyAssignmentRow, $$WeeklyAssignmentsTableReferences),
          WeeklyAssignmentRow,
          PrefetchHooks Function({bool taskId, bool projectId})
        > {
  $$WeeklyAssignmentsTableTableManager(
    _$AppDatabase db,
    $WeeklyAssignmentsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$WeeklyAssignmentsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$WeeklyAssignmentsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$WeeklyAssignmentsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<DateTime> weekStart = const Value.absent(),
                Value<int> taskId = const Value.absent(),
                Value<int> projectId = const Value.absent(),
                Value<DateTime> addedAt = const Value.absent(),
              }) => WeeklyAssignmentsCompanion(
                id: id,
                weekStart: weekStart,
                taskId: taskId,
                projectId: projectId,
                addedAt: addedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required DateTime weekStart,
                required int taskId,
                required int projectId,
                required DateTime addedAt,
              }) => WeeklyAssignmentsCompanion.insert(
                id: id,
                weekStart: weekStart,
                taskId: taskId,
                projectId: projectId,
                addedAt: addedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$WeeklyAssignmentsTable, WeeklyAssignmentRow>(
                    table,
                  ),
                  $$WeeklyAssignmentsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({taskId = false, projectId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (taskId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.taskId,
                        referencedTable: $$WeeklyAssignmentsTableReferences
                            ._taskIdTable(db),
                        referencedColumn: $$WeeklyAssignmentsTableReferences
                            ._taskIdTable(db)
                            .id,
                      ) as T;
                    }
                    if (projectId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.projectId,
                        referencedTable: $$WeeklyAssignmentsTableReferences
                            ._projectIdTable(db),
                        referencedColumn: $$WeeklyAssignmentsTableReferences
                            ._projectIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$WeeklyAssignmentsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $WeeklyAssignmentsTable,
      WeeklyAssignmentRow,
      $$WeeklyAssignmentsTableFilterComposer,
      $$WeeklyAssignmentsTableOrderingComposer,
      $$WeeklyAssignmentsTableAnnotationComposer,
      $$WeeklyAssignmentsTableCreateCompanionBuilder,
      $$WeeklyAssignmentsTableUpdateCompanionBuilder,
      (WeeklyAssignmentRow, $$WeeklyAssignmentsTableReferences),
      WeeklyAssignmentRow,
      PrefetchHooks Function({bool taskId, bool projectId})
    >;
typedef $$InboxItemsTableCreateCompanionBuilder = InboxItemsCompanion Function({
  Value<int> id,
  required dom.InboxKind kind,
  required String content,
  Value<String?> filePath,
  required dom.InboxStatus status,
  required DateTime createdAt,
});
typedef $$InboxItemsTableUpdateCompanionBuilder = InboxItemsCompanion Function({
  Value<int> id,
  Value<dom.InboxKind> kind,
  Value<String> content,
  Value<String?> filePath,
  Value<dom.InboxStatus> status,
  Value<DateTime> createdAt,
});

class $$InboxItemsTableFilterComposer
    extends Composer<_$AppDatabase, $InboxItemsTable> {
  $$InboxItemsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<dom.InboxKind, dom.InboxKind, String>
  get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<String> get content => $composableBuilder(
    column: $table.content,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get filePath => $composableBuilder(
    column: $table.filePath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<dom.InboxStatus, dom.InboxStatus, String>
  get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$InboxItemsTableOrderingComposer
    extends Composer<_$AppDatabase, $InboxItemsTable> {
  $$InboxItemsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get content => $composableBuilder(
    column: $table.content,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get filePath => $composableBuilder(
    column: $table.filePath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$InboxItemsTableAnnotationComposer
    extends Composer<_$AppDatabase, $InboxItemsTable> {
  $$InboxItemsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumnWithTypeConverter<dom.InboxKind, String> get kind =>
      $composableBuilder(column: $table.kind, builder: (column) => column);

  GeneratedColumn<String> get content =>
      $composableBuilder(column: $table.content, builder: (column) => column);

  GeneratedColumn<String> get filePath =>
      $composableBuilder(column: $table.filePath, builder: (column) => column);

  GeneratedColumnWithTypeConverter<dom.InboxStatus, String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$InboxItemsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $InboxItemsTable,
          InboxItemRow,
          $$InboxItemsTableFilterComposer,
          $$InboxItemsTableOrderingComposer,
          $$InboxItemsTableAnnotationComposer,
          $$InboxItemsTableCreateCompanionBuilder,
          $$InboxItemsTableUpdateCompanionBuilder,
          (
            InboxItemRow,
            BaseReferences<_$AppDatabase, $InboxItemsTable, InboxItemRow>,
          ),
          InboxItemRow,
          PrefetchHooks Function()
        > {
  $$InboxItemsTableTableManager(_$AppDatabase db, $InboxItemsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$InboxItemsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$InboxItemsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$InboxItemsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<dom.InboxKind> kind = const Value.absent(),
                Value<String> content = const Value.absent(),
                Value<String?> filePath = const Value.absent(),
                Value<dom.InboxStatus> status = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => InboxItemsCompanion(
                id: id,
                kind: kind,
                content: content,
                filePath: filePath,
                status: status,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required dom.InboxKind kind,
                required String content,
                Value<String?> filePath = const Value.absent(),
                required dom.InboxStatus status,
                required DateTime createdAt,
              }) => InboxItemsCompanion.insert(
                id: id,
                kind: kind,
                content: content,
                filePath: filePath,
                status: status,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$InboxItemsTable, InboxItemRow>(table),
                  BaseReferences<_$AppDatabase, $InboxItemsTable, InboxItemRow>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$InboxItemsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $InboxItemsTable,
      InboxItemRow,
      $$InboxItemsTableFilterComposer,
      $$InboxItemsTableOrderingComposer,
      $$InboxItemsTableAnnotationComposer,
      $$InboxItemsTableCreateCompanionBuilder,
      $$InboxItemsTableUpdateCompanionBuilder,
      (
        InboxItemRow,
        BaseReferences<_$AppDatabase, $InboxItemsTable, InboxItemRow>,
      ),
      InboxItemRow,
      PrefetchHooks Function()
    >;
typedef $$SourceDocumentsTableCreateCompanionBuilder =
    SourceDocumentsCompanion Function({
      Value<int> id,
      required String fileName,
      required String fileKind,
      Value<String?> filePath,
      Value<String?> extractedText,
      required DateTime importedAt,
    });
typedef $$SourceDocumentsTableUpdateCompanionBuilder =
    SourceDocumentsCompanion Function({
      Value<int> id,
      Value<String> fileName,
      Value<String> fileKind,
      Value<String?> filePath,
      Value<String?> extractedText,
      Value<DateTime> importedAt,
    });

class $$SourceDocumentsTableFilterComposer
    extends Composer<_$AppDatabase, $SourceDocumentsTable> {
  $$SourceDocumentsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get fileName => $composableBuilder(
    column: $table.fileName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get fileKind => $composableBuilder(
    column: $table.fileKind,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get filePath => $composableBuilder(
    column: $table.filePath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get extractedText => $composableBuilder(
    column: $table.extractedText,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get importedAt => $composableBuilder(
    column: $table.importedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SourceDocumentsTableOrderingComposer
    extends Composer<_$AppDatabase, $SourceDocumentsTable> {
  $$SourceDocumentsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get fileName => $composableBuilder(
    column: $table.fileName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get fileKind => $composableBuilder(
    column: $table.fileKind,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get filePath => $composableBuilder(
    column: $table.filePath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get extractedText => $composableBuilder(
    column: $table.extractedText,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get importedAt => $composableBuilder(
    column: $table.importedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SourceDocumentsTableAnnotationComposer
    extends Composer<_$AppDatabase, $SourceDocumentsTable> {
  $$SourceDocumentsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get fileName =>
      $composableBuilder(column: $table.fileName, builder: (column) => column);

  GeneratedColumn<String> get fileKind =>
      $composableBuilder(column: $table.fileKind, builder: (column) => column);

  GeneratedColumn<String> get filePath =>
      $composableBuilder(column: $table.filePath, builder: (column) => column);

  GeneratedColumn<String> get extractedText => $composableBuilder(
    column: $table.extractedText,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get importedAt => $composableBuilder(
    column: $table.importedAt,
    builder: (column) => column,
  );
}

class $$SourceDocumentsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SourceDocumentsTable,
          SourceDocumentRow,
          $$SourceDocumentsTableFilterComposer,
          $$SourceDocumentsTableOrderingComposer,
          $$SourceDocumentsTableAnnotationComposer,
          $$SourceDocumentsTableCreateCompanionBuilder,
          $$SourceDocumentsTableUpdateCompanionBuilder,
          (
            SourceDocumentRow,
            BaseReferences<
              _$AppDatabase,
              $SourceDocumentsTable,
              SourceDocumentRow
            >,
          ),
          SourceDocumentRow,
          PrefetchHooks Function()
        > {
  $$SourceDocumentsTableTableManager(
    _$AppDatabase db,
    $SourceDocumentsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SourceDocumentsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SourceDocumentsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SourceDocumentsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> fileName = const Value.absent(),
                Value<String> fileKind = const Value.absent(),
                Value<String?> filePath = const Value.absent(),
                Value<String?> extractedText = const Value.absent(),
                Value<DateTime> importedAt = const Value.absent(),
              }) => SourceDocumentsCompanion(
                id: id,
                fileName: fileName,
                fileKind: fileKind,
                filePath: filePath,
                extractedText: extractedText,
                importedAt: importedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String fileName,
                required String fileKind,
                Value<String?> filePath = const Value.absent(),
                Value<String?> extractedText = const Value.absent(),
                required DateTime importedAt,
              }) => SourceDocumentsCompanion.insert(
                id: id,
                fileName: fileName,
                fileKind: fileKind,
                filePath: filePath,
                extractedText: extractedText,
                importedAt: importedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$SourceDocumentsTable, SourceDocumentRow>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $SourceDocumentsTable,
                    SourceDocumentRow
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SourceDocumentsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SourceDocumentsTable,
      SourceDocumentRow,
      $$SourceDocumentsTableFilterComposer,
      $$SourceDocumentsTableOrderingComposer,
      $$SourceDocumentsTableAnnotationComposer,
      $$SourceDocumentsTableCreateCompanionBuilder,
      $$SourceDocumentsTableUpdateCompanionBuilder,
      (
        SourceDocumentRow,
        BaseReferences<_$AppDatabase, $SourceDocumentsTable, SourceDocumentRow>,
      ),
      SourceDocumentRow,
      PrefetchHooks Function()
    >;
typedef $$AiProposalsTableCreateCompanionBuilder =
    AiProposalsCompanion Function({
      Value<int> id,
      required String kind,
      required dom.ProposalStatus status,
      required String payloadJson,
      required String summary,
      required DateTime createdAt,
      Value<DateTime?> decidedAt,
    });
typedef $$AiProposalsTableUpdateCompanionBuilder =
    AiProposalsCompanion Function({
      Value<int> id,
      Value<String> kind,
      Value<dom.ProposalStatus> status,
      Value<String> payloadJson,
      Value<String> summary,
      Value<DateTime> createdAt,
      Value<DateTime?> decidedAt,
    });

class $$AiProposalsTableFilterComposer
    extends Composer<_$AppDatabase, $AiProposalsTable> {
  $$AiProposalsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<dom.ProposalStatus, dom.ProposalStatus, String>
  get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<String> get payloadJson => $composableBuilder(
    column: $table.payloadJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get summary => $composableBuilder(
    column: $table.summary,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get decidedAt => $composableBuilder(
    column: $table.decidedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$AiProposalsTableOrderingComposer
    extends Composer<_$AppDatabase, $AiProposalsTable> {
  $$AiProposalsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get payloadJson => $composableBuilder(
    column: $table.payloadJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get summary => $composableBuilder(
    column: $table.summary,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get decidedAt => $composableBuilder(
    column: $table.decidedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$AiProposalsTableAnnotationComposer
    extends Composer<_$AppDatabase, $AiProposalsTable> {
  $$AiProposalsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get kind =>
      $composableBuilder(column: $table.kind, builder: (column) => column);

  GeneratedColumnWithTypeConverter<dom.ProposalStatus, String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get payloadJson => $composableBuilder(
    column: $table.payloadJson,
    builder: (column) => column,
  );

  GeneratedColumn<String> get summary =>
      $composableBuilder(column: $table.summary, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get decidedAt =>
      $composableBuilder(column: $table.decidedAt, builder: (column) => column);
}

class $$AiProposalsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AiProposalsTable,
          AiProposalRow,
          $$AiProposalsTableFilterComposer,
          $$AiProposalsTableOrderingComposer,
          $$AiProposalsTableAnnotationComposer,
          $$AiProposalsTableCreateCompanionBuilder,
          $$AiProposalsTableUpdateCompanionBuilder,
          (
            AiProposalRow,
            BaseReferences<_$AppDatabase, $AiProposalsTable, AiProposalRow>,
          ),
          AiProposalRow,
          PrefetchHooks Function()
        > {
  $$AiProposalsTableTableManager(_$AppDatabase db, $AiProposalsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AiProposalsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AiProposalsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AiProposalsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> kind = const Value.absent(),
                Value<dom.ProposalStatus> status = const Value.absent(),
                Value<String> payloadJson = const Value.absent(),
                Value<String> summary = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime?> decidedAt = const Value.absent(),
              }) => AiProposalsCompanion(
                id: id,
                kind: kind,
                status: status,
                payloadJson: payloadJson,
                summary: summary,
                createdAt: createdAt,
                decidedAt: decidedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String kind,
                required dom.ProposalStatus status,
                required String payloadJson,
                required String summary,
                required DateTime createdAt,
                Value<DateTime?> decidedAt = const Value.absent(),
              }) => AiProposalsCompanion.insert(
                id: id,
                kind: kind,
                status: status,
                payloadJson: payloadJson,
                summary: summary,
                createdAt: createdAt,
                decidedAt: decidedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$AiProposalsTable, AiProposalRow>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $AiProposalsTable,
                    AiProposalRow
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$AiProposalsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AiProposalsTable,
      AiProposalRow,
      $$AiProposalsTableFilterComposer,
      $$AiProposalsTableOrderingComposer,
      $$AiProposalsTableAnnotationComposer,
      $$AiProposalsTableCreateCompanionBuilder,
      $$AiProposalsTableUpdateCompanionBuilder,
      (
        AiProposalRow,
        BaseReferences<_$AppDatabase, $AiProposalsTable, AiProposalRow>,
      ),
      AiProposalRow,
      PrefetchHooks Function()
    >;
typedef $$ProgressEventsTableCreateCompanionBuilder =
    ProgressEventsCompanion Function({
      Value<int> id,
      required dom.ProgressEventType type,
      Value<int?> projectId,
      Value<int?> taskId,
      Value<String> detail,
      required DateTime occurredAt,
    });
typedef $$ProgressEventsTableUpdateCompanionBuilder =
    ProgressEventsCompanion Function({
      Value<int> id,
      Value<dom.ProgressEventType> type,
      Value<int?> projectId,
      Value<int?> taskId,
      Value<String> detail,
      Value<DateTime> occurredAt,
    });

class $$ProgressEventsTableFilterComposer
    extends Composer<_$AppDatabase, $ProgressEventsTable> {
  $$ProgressEventsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<
    dom.ProgressEventType,
    dom.ProgressEventType,
    String
  >
  get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<int> get projectId => $composableBuilder(
    column: $table.projectId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get taskId => $composableBuilder(
    column: $table.taskId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get detail => $composableBuilder(
    column: $table.detail,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get occurredAt => $composableBuilder(
    column: $table.occurredAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ProgressEventsTableOrderingComposer
    extends Composer<_$AppDatabase, $ProgressEventsTable> {
  $$ProgressEventsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get projectId => $composableBuilder(
    column: $table.projectId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get taskId => $composableBuilder(
    column: $table.taskId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get detail => $composableBuilder(
    column: $table.detail,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get occurredAt => $composableBuilder(
    column: $table.occurredAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ProgressEventsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ProgressEventsTable> {
  $$ProgressEventsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumnWithTypeConverter<dom.ProgressEventType, String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<int> get projectId =>
      $composableBuilder(column: $table.projectId, builder: (column) => column);

  GeneratedColumn<int> get taskId =>
      $composableBuilder(column: $table.taskId, builder: (column) => column);

  GeneratedColumn<String> get detail =>
      $composableBuilder(column: $table.detail, builder: (column) => column);

  GeneratedColumn<DateTime> get occurredAt => $composableBuilder(
    column: $table.occurredAt,
    builder: (column) => column,
  );
}

class $$ProgressEventsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ProgressEventsTable,
          ProgressEventRow,
          $$ProgressEventsTableFilterComposer,
          $$ProgressEventsTableOrderingComposer,
          $$ProgressEventsTableAnnotationComposer,
          $$ProgressEventsTableCreateCompanionBuilder,
          $$ProgressEventsTableUpdateCompanionBuilder,
          (
            ProgressEventRow,
            BaseReferences<
              _$AppDatabase,
              $ProgressEventsTable,
              ProgressEventRow
            >,
          ),
          ProgressEventRow,
          PrefetchHooks Function()
        > {
  $$ProgressEventsTableTableManager(
    _$AppDatabase db,
    $ProgressEventsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ProgressEventsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ProgressEventsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ProgressEventsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<dom.ProgressEventType> type = const Value.absent(),
                Value<int?> projectId = const Value.absent(),
                Value<int?> taskId = const Value.absent(),
                Value<String> detail = const Value.absent(),
                Value<DateTime> occurredAt = const Value.absent(),
              }) => ProgressEventsCompanion(
                id: id,
                type: type,
                projectId: projectId,
                taskId: taskId,
                detail: detail,
                occurredAt: occurredAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required dom.ProgressEventType type,
                Value<int?> projectId = const Value.absent(),
                Value<int?> taskId = const Value.absent(),
                Value<String> detail = const Value.absent(),
                required DateTime occurredAt,
              }) => ProgressEventsCompanion.insert(
                id: id,
                type: type,
                projectId: projectId,
                taskId: taskId,
                detail: detail,
                occurredAt: occurredAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$ProgressEventsTable, ProgressEventRow>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $ProgressEventsTable,
                    ProgressEventRow
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ProgressEventsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ProgressEventsTable,
      ProgressEventRow,
      $$ProgressEventsTableFilterComposer,
      $$ProgressEventsTableOrderingComposer,
      $$ProgressEventsTableAnnotationComposer,
      $$ProgressEventsTableCreateCompanionBuilder,
      $$ProgressEventsTableUpdateCompanionBuilder,
      (
        ProgressEventRow,
        BaseReferences<_$AppDatabase, $ProgressEventsTable, ProgressEventRow>,
      ),
      ProgressEventRow,
      PrefetchHooks Function()
    >;
typedef $$ReviewSnapshotsTableCreateCompanionBuilder =
    ReviewSnapshotsCompanion Function({
      Value<int> id,
      required dom.ReviewScope scope,
      Value<int?> targetId,
      required DateTime periodStart,
      required DateTime periodEnd,
      required String storyJson,
      Value<String?> aiSummary,
      required DateTime createdAt,
    });
typedef $$ReviewSnapshotsTableUpdateCompanionBuilder =
    ReviewSnapshotsCompanion Function({
      Value<int> id,
      Value<dom.ReviewScope> scope,
      Value<int?> targetId,
      Value<DateTime> periodStart,
      Value<DateTime> periodEnd,
      Value<String> storyJson,
      Value<String?> aiSummary,
      Value<DateTime> createdAt,
    });

class $$ReviewSnapshotsTableFilterComposer
    extends Composer<_$AppDatabase, $ReviewSnapshotsTable> {
  $$ReviewSnapshotsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<dom.ReviewScope, dom.ReviewScope, String>
  get scope => $composableBuilder(
    column: $table.scope,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<int> get targetId => $composableBuilder(
    column: $table.targetId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get periodStart => $composableBuilder(
    column: $table.periodStart,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get periodEnd => $composableBuilder(
    column: $table.periodEnd,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get storyJson => $composableBuilder(
    column: $table.storyJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get aiSummary => $composableBuilder(
    column: $table.aiSummary,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ReviewSnapshotsTableOrderingComposer
    extends Composer<_$AppDatabase, $ReviewSnapshotsTable> {
  $$ReviewSnapshotsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get scope => $composableBuilder(
    column: $table.scope,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get targetId => $composableBuilder(
    column: $table.targetId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get periodStart => $composableBuilder(
    column: $table.periodStart,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get periodEnd => $composableBuilder(
    column: $table.periodEnd,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get storyJson => $composableBuilder(
    column: $table.storyJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get aiSummary => $composableBuilder(
    column: $table.aiSummary,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ReviewSnapshotsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ReviewSnapshotsTable> {
  $$ReviewSnapshotsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumnWithTypeConverter<dom.ReviewScope, String> get scope =>
      $composableBuilder(column: $table.scope, builder: (column) => column);

  GeneratedColumn<int> get targetId =>
      $composableBuilder(column: $table.targetId, builder: (column) => column);

  GeneratedColumn<DateTime> get periodStart => $composableBuilder(
    column: $table.periodStart,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get periodEnd =>
      $composableBuilder(column: $table.periodEnd, builder: (column) => column);

  GeneratedColumn<String> get storyJson =>
      $composableBuilder(column: $table.storyJson, builder: (column) => column);

  GeneratedColumn<String> get aiSummary =>
      $composableBuilder(column: $table.aiSummary, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$ReviewSnapshotsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ReviewSnapshotsTable,
          ReviewSnapshotRow,
          $$ReviewSnapshotsTableFilterComposer,
          $$ReviewSnapshotsTableOrderingComposer,
          $$ReviewSnapshotsTableAnnotationComposer,
          $$ReviewSnapshotsTableCreateCompanionBuilder,
          $$ReviewSnapshotsTableUpdateCompanionBuilder,
          (
            ReviewSnapshotRow,
            BaseReferences<
              _$AppDatabase,
              $ReviewSnapshotsTable,
              ReviewSnapshotRow
            >,
          ),
          ReviewSnapshotRow,
          PrefetchHooks Function()
        > {
  $$ReviewSnapshotsTableTableManager(
    _$AppDatabase db,
    $ReviewSnapshotsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ReviewSnapshotsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ReviewSnapshotsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ReviewSnapshotsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<dom.ReviewScope> scope = const Value.absent(),
                Value<int?> targetId = const Value.absent(),
                Value<DateTime> periodStart = const Value.absent(),
                Value<DateTime> periodEnd = const Value.absent(),
                Value<String> storyJson = const Value.absent(),
                Value<String?> aiSummary = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => ReviewSnapshotsCompanion(
                id: id,
                scope: scope,
                targetId: targetId,
                periodStart: periodStart,
                periodEnd: periodEnd,
                storyJson: storyJson,
                aiSummary: aiSummary,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required dom.ReviewScope scope,
                Value<int?> targetId = const Value.absent(),
                required DateTime periodStart,
                required DateTime periodEnd,
                required String storyJson,
                Value<String?> aiSummary = const Value.absent(),
                required DateTime createdAt,
              }) => ReviewSnapshotsCompanion.insert(
                id: id,
                scope: scope,
                targetId: targetId,
                periodStart: periodStart,
                periodEnd: periodEnd,
                storyJson: storyJson,
                aiSummary: aiSummary,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$ReviewSnapshotsTable, ReviewSnapshotRow>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $ReviewSnapshotsTable,
                    ReviewSnapshotRow
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ReviewSnapshotsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ReviewSnapshotsTable,
      ReviewSnapshotRow,
      $$ReviewSnapshotsTableFilterComposer,
      $$ReviewSnapshotsTableOrderingComposer,
      $$ReviewSnapshotsTableAnnotationComposer,
      $$ReviewSnapshotsTableCreateCompanionBuilder,
      $$ReviewSnapshotsTableUpdateCompanionBuilder,
      (
        ReviewSnapshotRow,
        BaseReferences<_$AppDatabase, $ReviewSnapshotsTable, ReviewSnapshotRow>,
      ),
      ReviewSnapshotRow,
      PrefetchHooks Function()
    >;
typedef $$SettingsTableCreateCompanionBuilder = SettingsCompanion Function({
  required String key,
  required String value,
  Value<int> rowid,
});
typedef $$SettingsTableUpdateCompanionBuilder = SettingsCompanion Function({
  Value<String> key,
  Value<String> value,
  Value<int> rowid,
});

class $$SettingsTableFilterComposer
    extends Composer<_$AppDatabase, $SettingsTable> {
  $$SettingsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SettingsTableOrderingComposer
    extends Composer<_$AppDatabase, $SettingsTable> {
  $$SettingsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SettingsTableAnnotationComposer
    extends Composer<_$AppDatabase, $SettingsTable> {
  $$SettingsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get key =>
      $composableBuilder(column: $table.key, builder: (column) => column);

  GeneratedColumn<String> get value =>
      $composableBuilder(column: $table.value, builder: (column) => column);
}

class $$SettingsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SettingsTable,
          Setting,
          $$SettingsTableFilterComposer,
          $$SettingsTableOrderingComposer,
          $$SettingsTableAnnotationComposer,
          $$SettingsTableCreateCompanionBuilder,
          $$SettingsTableUpdateCompanionBuilder,
          (Setting, BaseReferences<_$AppDatabase, $SettingsTable, Setting>),
          Setting,
          PrefetchHooks Function()
        > {
  $$SettingsTableTableManager(_$AppDatabase db, $SettingsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SettingsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SettingsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SettingsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> key = const Value.absent(),
            Value<String> value = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) => SettingsCompanion(key: key, value: value, rowid: rowid),
          createCompanionCallback: ({
            required String key,
            required String value,
            Value<int> rowid = const Value.absent(),
          }) => SettingsCompanion.insert(key: key, value: value, rowid: rowid),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$SettingsTable, Setting>(table),
                  BaseReferences<_$AppDatabase, $SettingsTable, Setting>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SettingsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SettingsTable,
      Setting,
      $$SettingsTableFilterComposer,
      $$SettingsTableOrderingComposer,
      $$SettingsTableAnnotationComposer,
      $$SettingsTableCreateCompanionBuilder,
      $$SettingsTableUpdateCompanionBuilder,
      (Setting, BaseReferences<_$AppDatabase, $SettingsTable, Setting>),
      Setting,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$ProjectsTableTableManager get projects =>
      $$ProjectsTableTableManager(_db, _db.projects);
  $$PhasesTableTableManager get phases =>
      $$PhasesTableTableManager(_db, _db.phases);
  $$MilestonesTableTableManager get milestones =>
      $$MilestonesTableTableManager(_db, _db.milestones);
  $$TasksTableTableManager get tasks =>
      $$TasksTableTableManager(_db, _db.tasks);
  $$TaskDependenciesTableTableManager get taskDependencies =>
      $$TaskDependenciesTableTableManager(_db, _db.taskDependencies);
  $$SourceRefsTableTableManager get sourceRefs =>
      $$SourceRefsTableTableManager(_db, _db.sourceRefs);
  $$WeekSettingsTableTableManager get weekSettings =>
      $$WeekSettingsTableTableManager(_db, _db.weekSettings);
  $$WeeklyAssignmentsTableTableManager get weeklyAssignments =>
      $$WeeklyAssignmentsTableTableManager(_db, _db.weeklyAssignments);
  $$InboxItemsTableTableManager get inboxItems =>
      $$InboxItemsTableTableManager(_db, _db.inboxItems);
  $$SourceDocumentsTableTableManager get sourceDocuments =>
      $$SourceDocumentsTableTableManager(_db, _db.sourceDocuments);
  $$AiProposalsTableTableManager get aiProposals =>
      $$AiProposalsTableTableManager(_db, _db.aiProposals);
  $$ProgressEventsTableTableManager get progressEvents =>
      $$ProgressEventsTableTableManager(_db, _db.progressEvents);
  $$ReviewSnapshotsTableTableManager get reviewSnapshots =>
      $$ReviewSnapshotsTableTableManager(_db, _db.reviewSnapshots);
  $$SettingsTableTableManager get settings =>
      $$SettingsTableTableManager(_db, _db.settings);
}
