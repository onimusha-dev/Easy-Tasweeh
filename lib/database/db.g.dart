// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'db.dart';

// ignore_for_file: type=lint
class $CurrentCountTableTable extends CurrentCountTable
    with TableInfo<$CurrentCountTableTable, CurrentCountTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CurrentCountTableTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _targetCountMeta = const VerificationMeta(
    'targetCount',
  );
  @override
  late final GeneratedColumn<int> targetCount = GeneratedColumn<int>(
    'target_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _currentCountMeta = const VerificationMeta(
    'currentCount',
  );
  @override
  late final GeneratedColumn<int> currentCount = GeneratedColumn<int>(
    'current_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
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
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
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
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _dhikrIdMeta = const VerificationMeta(
    'dhikrId',
  );
  @override
  late final GeneratedColumn<String> dhikrId = GeneratedColumn<String>(
    'dhikr_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('subhanallah'),
  );
  static const VerificationMeta _comboNameMeta = const VerificationMeta(
    'comboName',
  );
  @override
  late final GeneratedColumn<String> comboName = GeneratedColumn<String>(
    'combo_name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _sessionModeMeta = const VerificationMeta(
    'sessionMode',
  );
  @override
  late final GeneratedColumn<String> sessionMode = GeneratedColumn<String>(
    'session_mode',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('single'),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    targetCount,
    currentCount,
    createdAt,
    updatedAt,
    dhikrId,
    comboName,
    sessionMode,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'current_count_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<CurrentCountTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('target_count')) {
      context.handle(
        _targetCountMeta,
        targetCount.isAcceptableOrUnknown(
          data['target_count']!,
          _targetCountMeta,
        ),
      );
    }
    if (data.containsKey('current_count')) {
      context.handle(
        _currentCountMeta,
        currentCount.isAcceptableOrUnknown(
          data['current_count']!,
          _currentCountMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    if (data.containsKey('dhikr_id')) {
      context.handle(
        _dhikrIdMeta,
        dhikrId.isAcceptableOrUnknown(data['dhikr_id']!, _dhikrIdMeta),
      );
    }
    if (data.containsKey('combo_name')) {
      context.handle(
        _comboNameMeta,
        comboName.isAcceptableOrUnknown(data['combo_name']!, _comboNameMeta),
      );
    }
    if (data.containsKey('session_mode')) {
      context.handle(
        _sessionModeMeta,
        sessionMode.isAcceptableOrUnknown(
          data['session_mode']!,
          _sessionModeMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CurrentCountTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CurrentCountTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      targetCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}target_count'],
      )!,
      currentCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}current_count'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      dhikrId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}dhikr_id'],
      )!,
      comboName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}combo_name'],
      ),
      sessionMode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}session_mode'],
      )!,
    );
  }

  @override
  $CurrentCountTableTable createAlias(String alias) {
    return $CurrentCountTableTable(attachedDatabase, alias);
  }
}

class CurrentCountTableData extends DataClass
    implements Insertable<CurrentCountTableData> {
  final int id;
  final int targetCount;
  final int currentCount;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String dhikrId;
  final String? comboName;
  final String sessionMode;
  const CurrentCountTableData({
    required this.id,
    required this.targetCount,
    required this.currentCount,
    required this.createdAt,
    required this.updatedAt,
    required this.dhikrId,
    this.comboName,
    required this.sessionMode,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['target_count'] = Variable<int>(targetCount);
    map['current_count'] = Variable<int>(currentCount);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    map['dhikr_id'] = Variable<String>(dhikrId);
    if (!nullToAbsent || comboName != null) {
      map['combo_name'] = Variable<String>(comboName);
    }
    map['session_mode'] = Variable<String>(sessionMode);
    return map;
  }

  CurrentCountTableCompanion toCompanion(bool nullToAbsent) {
    return CurrentCountTableCompanion(
      id: Value(id),
      targetCount: Value(targetCount),
      currentCount: Value(currentCount),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      dhikrId: Value(dhikrId),
      comboName: comboName == null && nullToAbsent
          ? const Value.absent()
          : Value(comboName),
      sessionMode: Value(sessionMode),
    );
  }

  factory CurrentCountTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CurrentCountTableData(
      id: serializer.fromJson<int>(json['id']),
      targetCount: serializer.fromJson<int>(json['targetCount']),
      currentCount: serializer.fromJson<int>(json['currentCount']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      dhikrId: serializer.fromJson<String>(json['dhikrId']),
      comboName: serializer.fromJson<String?>(json['comboName']),
      sessionMode: serializer.fromJson<String>(json['sessionMode']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'targetCount': serializer.toJson<int>(targetCount),
      'currentCount': serializer.toJson<int>(currentCount),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'dhikrId': serializer.toJson<String>(dhikrId),
      'comboName': serializer.toJson<String?>(comboName),
      'sessionMode': serializer.toJson<String>(sessionMode),
    };
  }

  CurrentCountTableData copyWith({
    int? id,
    int? targetCount,
    int? currentCount,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? dhikrId,
    Value<String?> comboName = const Value.absent(),
    String? sessionMode,
  }) => CurrentCountTableData(
    id: id ?? this.id,
    targetCount: targetCount ?? this.targetCount,
    currentCount: currentCount ?? this.currentCount,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    dhikrId: dhikrId ?? this.dhikrId,
    comboName: comboName.present ? comboName.value : this.comboName,
    sessionMode: sessionMode ?? this.sessionMode,
  );
  CurrentCountTableData copyWithCompanion(CurrentCountTableCompanion data) {
    return CurrentCountTableData(
      id: data.id.present ? data.id.value : this.id,
      targetCount: data.targetCount.present
          ? data.targetCount.value
          : this.targetCount,
      currentCount: data.currentCount.present
          ? data.currentCount.value
          : this.currentCount,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      dhikrId: data.dhikrId.present ? data.dhikrId.value : this.dhikrId,
      comboName: data.comboName.present ? data.comboName.value : this.comboName,
      sessionMode: data.sessionMode.present
          ? data.sessionMode.value
          : this.sessionMode,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CurrentCountTableData(')
          ..write('id: $id, ')
          ..write('targetCount: $targetCount, ')
          ..write('currentCount: $currentCount, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('dhikrId: $dhikrId, ')
          ..write('comboName: $comboName, ')
          ..write('sessionMode: $sessionMode')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    targetCount,
    currentCount,
    createdAt,
    updatedAt,
    dhikrId,
    comboName,
    sessionMode,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CurrentCountTableData &&
          other.id == this.id &&
          other.targetCount == this.targetCount &&
          other.currentCount == this.currentCount &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.dhikrId == this.dhikrId &&
          other.comboName == this.comboName &&
          other.sessionMode == this.sessionMode);
}

class CurrentCountTableCompanion
    extends UpdateCompanion<CurrentCountTableData> {
  final Value<int> id;
  final Value<int> targetCount;
  final Value<int> currentCount;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<String> dhikrId;
  final Value<String?> comboName;
  final Value<String> sessionMode;
  const CurrentCountTableCompanion({
    this.id = const Value.absent(),
    this.targetCount = const Value.absent(),
    this.currentCount = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.dhikrId = const Value.absent(),
    this.comboName = const Value.absent(),
    this.sessionMode = const Value.absent(),
  });
  CurrentCountTableCompanion.insert({
    this.id = const Value.absent(),
    this.targetCount = const Value.absent(),
    this.currentCount = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.dhikrId = const Value.absent(),
    this.comboName = const Value.absent(),
    this.sessionMode = const Value.absent(),
  });
  static Insertable<CurrentCountTableData> custom({
    Expression<int>? id,
    Expression<int>? targetCount,
    Expression<int>? currentCount,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<String>? dhikrId,
    Expression<String>? comboName,
    Expression<String>? sessionMode,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (targetCount != null) 'target_count': targetCount,
      if (currentCount != null) 'current_count': currentCount,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (dhikrId != null) 'dhikr_id': dhikrId,
      if (comboName != null) 'combo_name': comboName,
      if (sessionMode != null) 'session_mode': sessionMode,
    });
  }

  CurrentCountTableCompanion copyWith({
    Value<int>? id,
    Value<int>? targetCount,
    Value<int>? currentCount,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<String>? dhikrId,
    Value<String?>? comboName,
    Value<String>? sessionMode,
  }) {
    return CurrentCountTableCompanion(
      id: id ?? this.id,
      targetCount: targetCount ?? this.targetCount,
      currentCount: currentCount ?? this.currentCount,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      dhikrId: dhikrId ?? this.dhikrId,
      comboName: comboName ?? this.comboName,
      sessionMode: sessionMode ?? this.sessionMode,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (targetCount.present) {
      map['target_count'] = Variable<int>(targetCount.value);
    }
    if (currentCount.present) {
      map['current_count'] = Variable<int>(currentCount.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (dhikrId.present) {
      map['dhikr_id'] = Variable<String>(dhikrId.value);
    }
    if (comboName.present) {
      map['combo_name'] = Variable<String>(comboName.value);
    }
    if (sessionMode.present) {
      map['session_mode'] = Variable<String>(sessionMode.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CurrentCountTableCompanion(')
          ..write('id: $id, ')
          ..write('targetCount: $targetCount, ')
          ..write('currentCount: $currentCount, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('dhikrId: $dhikrId, ')
          ..write('comboName: $comboName, ')
          ..write('sessionMode: $sessionMode')
          ..write(')'))
        .toString();
  }
}

class $CountHistoryTableTable extends CountHistoryTable
    with TableInfo<$CountHistoryTableTable, CountHistoryTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CountHistoryTableTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _targetCountMeta = const VerificationMeta(
    'targetCount',
  );
  @override
  late final GeneratedColumn<int> targetCount = GeneratedColumn<int>(
    'target_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _currentCountMeta = const VerificationMeta(
    'currentCount',
  );
  @override
  late final GeneratedColumn<int> currentCount = GeneratedColumn<int>(
    'current_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
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
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
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
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _dhikrIdMeta = const VerificationMeta(
    'dhikrId',
  );
  @override
  late final GeneratedColumn<String> dhikrId = GeneratedColumn<String>(
    'dhikr_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('subhanallah'),
  );
  static const VerificationMeta _comboNameMeta = const VerificationMeta(
    'comboName',
  );
  @override
  late final GeneratedColumn<String> comboName = GeneratedColumn<String>(
    'combo_name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _sessionModeMeta = const VerificationMeta(
    'sessionMode',
  );
  @override
  late final GeneratedColumn<String> sessionMode = GeneratedColumn<String>(
    'session_mode',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('single'),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    targetCount,
    currentCount,
    createdAt,
    updatedAt,
    dhikrId,
    comboName,
    sessionMode,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'count_history_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<CountHistoryTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('target_count')) {
      context.handle(
        _targetCountMeta,
        targetCount.isAcceptableOrUnknown(
          data['target_count']!,
          _targetCountMeta,
        ),
      );
    }
    if (data.containsKey('current_count')) {
      context.handle(
        _currentCountMeta,
        currentCount.isAcceptableOrUnknown(
          data['current_count']!,
          _currentCountMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    if (data.containsKey('dhikr_id')) {
      context.handle(
        _dhikrIdMeta,
        dhikrId.isAcceptableOrUnknown(data['dhikr_id']!, _dhikrIdMeta),
      );
    }
    if (data.containsKey('combo_name')) {
      context.handle(
        _comboNameMeta,
        comboName.isAcceptableOrUnknown(data['combo_name']!, _comboNameMeta),
      );
    }
    if (data.containsKey('session_mode')) {
      context.handle(
        _sessionModeMeta,
        sessionMode.isAcceptableOrUnknown(
          data['session_mode']!,
          _sessionModeMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CountHistoryTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CountHistoryTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      targetCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}target_count'],
      )!,
      currentCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}current_count'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      dhikrId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}dhikr_id'],
      )!,
      comboName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}combo_name'],
      ),
      sessionMode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}session_mode'],
      )!,
    );
  }

  @override
  $CountHistoryTableTable createAlias(String alias) {
    return $CountHistoryTableTable(attachedDatabase, alias);
  }
}

class CountHistoryTableData extends DataClass
    implements Insertable<CountHistoryTableData> {
  final int id;
  final int targetCount;
  final int currentCount;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String dhikrId;
  final String? comboName;
  final String sessionMode;
  const CountHistoryTableData({
    required this.id,
    required this.targetCount,
    required this.currentCount,
    required this.createdAt,
    required this.updatedAt,
    required this.dhikrId,
    this.comboName,
    required this.sessionMode,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['target_count'] = Variable<int>(targetCount);
    map['current_count'] = Variable<int>(currentCount);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    map['dhikr_id'] = Variable<String>(dhikrId);
    if (!nullToAbsent || comboName != null) {
      map['combo_name'] = Variable<String>(comboName);
    }
    map['session_mode'] = Variable<String>(sessionMode);
    return map;
  }

  CountHistoryTableCompanion toCompanion(bool nullToAbsent) {
    return CountHistoryTableCompanion(
      id: Value(id),
      targetCount: Value(targetCount),
      currentCount: Value(currentCount),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      dhikrId: Value(dhikrId),
      comboName: comboName == null && nullToAbsent
          ? const Value.absent()
          : Value(comboName),
      sessionMode: Value(sessionMode),
    );
  }

  factory CountHistoryTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CountHistoryTableData(
      id: serializer.fromJson<int>(json['id']),
      targetCount: serializer.fromJson<int>(json['targetCount']),
      currentCount: serializer.fromJson<int>(json['currentCount']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      dhikrId: serializer.fromJson<String>(json['dhikrId']),
      comboName: serializer.fromJson<String?>(json['comboName']),
      sessionMode: serializer.fromJson<String>(json['sessionMode']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'targetCount': serializer.toJson<int>(targetCount),
      'currentCount': serializer.toJson<int>(currentCount),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'dhikrId': serializer.toJson<String>(dhikrId),
      'comboName': serializer.toJson<String?>(comboName),
      'sessionMode': serializer.toJson<String>(sessionMode),
    };
  }

  CountHistoryTableData copyWith({
    int? id,
    int? targetCount,
    int? currentCount,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? dhikrId,
    Value<String?> comboName = const Value.absent(),
    String? sessionMode,
  }) => CountHistoryTableData(
    id: id ?? this.id,
    targetCount: targetCount ?? this.targetCount,
    currentCount: currentCount ?? this.currentCount,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    dhikrId: dhikrId ?? this.dhikrId,
    comboName: comboName.present ? comboName.value : this.comboName,
    sessionMode: sessionMode ?? this.sessionMode,
  );
  CountHistoryTableData copyWithCompanion(CountHistoryTableCompanion data) {
    return CountHistoryTableData(
      id: data.id.present ? data.id.value : this.id,
      targetCount: data.targetCount.present
          ? data.targetCount.value
          : this.targetCount,
      currentCount: data.currentCount.present
          ? data.currentCount.value
          : this.currentCount,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      dhikrId: data.dhikrId.present ? data.dhikrId.value : this.dhikrId,
      comboName: data.comboName.present ? data.comboName.value : this.comboName,
      sessionMode: data.sessionMode.present
          ? data.sessionMode.value
          : this.sessionMode,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CountHistoryTableData(')
          ..write('id: $id, ')
          ..write('targetCount: $targetCount, ')
          ..write('currentCount: $currentCount, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('dhikrId: $dhikrId, ')
          ..write('comboName: $comboName, ')
          ..write('sessionMode: $sessionMode')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    targetCount,
    currentCount,
    createdAt,
    updatedAt,
    dhikrId,
    comboName,
    sessionMode,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CountHistoryTableData &&
          other.id == this.id &&
          other.targetCount == this.targetCount &&
          other.currentCount == this.currentCount &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.dhikrId == this.dhikrId &&
          other.comboName == this.comboName &&
          other.sessionMode == this.sessionMode);
}

class CountHistoryTableCompanion
    extends UpdateCompanion<CountHistoryTableData> {
  final Value<int> id;
  final Value<int> targetCount;
  final Value<int> currentCount;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<String> dhikrId;
  final Value<String?> comboName;
  final Value<String> sessionMode;
  const CountHistoryTableCompanion({
    this.id = const Value.absent(),
    this.targetCount = const Value.absent(),
    this.currentCount = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.dhikrId = const Value.absent(),
    this.comboName = const Value.absent(),
    this.sessionMode = const Value.absent(),
  });
  CountHistoryTableCompanion.insert({
    this.id = const Value.absent(),
    this.targetCount = const Value.absent(),
    this.currentCount = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.dhikrId = const Value.absent(),
    this.comboName = const Value.absent(),
    this.sessionMode = const Value.absent(),
  });
  static Insertable<CountHistoryTableData> custom({
    Expression<int>? id,
    Expression<int>? targetCount,
    Expression<int>? currentCount,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<String>? dhikrId,
    Expression<String>? comboName,
    Expression<String>? sessionMode,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (targetCount != null) 'target_count': targetCount,
      if (currentCount != null) 'current_count': currentCount,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (dhikrId != null) 'dhikr_id': dhikrId,
      if (comboName != null) 'combo_name': comboName,
      if (sessionMode != null) 'session_mode': sessionMode,
    });
  }

  CountHistoryTableCompanion copyWith({
    Value<int>? id,
    Value<int>? targetCount,
    Value<int>? currentCount,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<String>? dhikrId,
    Value<String?>? comboName,
    Value<String>? sessionMode,
  }) {
    return CountHistoryTableCompanion(
      id: id ?? this.id,
      targetCount: targetCount ?? this.targetCount,
      currentCount: currentCount ?? this.currentCount,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      dhikrId: dhikrId ?? this.dhikrId,
      comboName: comboName ?? this.comboName,
      sessionMode: sessionMode ?? this.sessionMode,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (targetCount.present) {
      map['target_count'] = Variable<int>(targetCount.value);
    }
    if (currentCount.present) {
      map['current_count'] = Variable<int>(currentCount.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (dhikrId.present) {
      map['dhikr_id'] = Variable<String>(dhikrId.value);
    }
    if (comboName.present) {
      map['combo_name'] = Variable<String>(comboName.value);
    }
    if (sessionMode.present) {
      map['session_mode'] = Variable<String>(sessionMode.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CountHistoryTableCompanion(')
          ..write('id: $id, ')
          ..write('targetCount: $targetCount, ')
          ..write('currentCount: $currentCount, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('dhikrId: $dhikrId, ')
          ..write('comboName: $comboName, ')
          ..write('sessionMode: $sessionMode')
          ..write(')'))
        .toString();
  }
}

class $ComboPresetsTableTable extends ComboPresetsTable
    with TableInfo<$ComboPresetsTableTable, ComboPresetsTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ComboPresetsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dhikrIdsMeta = const VerificationMeta(
    'dhikrIds',
  );
  @override
  late final GeneratedColumn<String> dhikrIds = GeneratedColumn<String>(
    'dhikr_ids',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _countsMeta = const VerificationMeta('counts');
  @override
  late final GeneratedColumn<String> counts = GeneratedColumn<String>(
    'counts',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _positionMeta = const VerificationMeta(
    'position',
  );
  @override
  late final GeneratedColumn<int> position = GeneratedColumn<int>(
    'position',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
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
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    dhikrIds,
    counts,
    position,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'combo_presets_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<ComboPresetsTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('dhikr_ids')) {
      context.handle(
        _dhikrIdsMeta,
        dhikrIds.isAcceptableOrUnknown(data['dhikr_ids']!, _dhikrIdsMeta),
      );
    } else if (isInserting) {
      context.missing(_dhikrIdsMeta);
    }
    if (data.containsKey('counts')) {
      context.handle(
        _countsMeta,
        counts.isAcceptableOrUnknown(data['counts']!, _countsMeta),
      );
    } else if (isInserting) {
      context.missing(_countsMeta);
    }
    if (data.containsKey('position')) {
      context.handle(
        _positionMeta,
        position.isAcceptableOrUnknown(data['position']!, _positionMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ComboPresetsTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ComboPresetsTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      dhikrIds: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}dhikr_ids'],
      )!,
      counts: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}counts'],
      )!,
      position: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}position'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $ComboPresetsTableTable createAlias(String alias) {
    return $ComboPresetsTableTable(attachedDatabase, alias);
  }
}

class ComboPresetsTableData extends DataClass
    implements Insertable<ComboPresetsTableData> {
  final String id;
  final String name;
  final String dhikrIds;
  final String counts;
  final int position;
  final DateTime createdAt;
  const ComboPresetsTableData({
    required this.id,
    required this.name,
    required this.dhikrIds,
    required this.counts,
    required this.position,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['dhikr_ids'] = Variable<String>(dhikrIds);
    map['counts'] = Variable<String>(counts);
    map['position'] = Variable<int>(position);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  ComboPresetsTableCompanion toCompanion(bool nullToAbsent) {
    return ComboPresetsTableCompanion(
      id: Value(id),
      name: Value(name),
      dhikrIds: Value(dhikrIds),
      counts: Value(counts),
      position: Value(position),
      createdAt: Value(createdAt),
    );
  }

  factory ComboPresetsTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ComboPresetsTableData(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      dhikrIds: serializer.fromJson<String>(json['dhikrIds']),
      counts: serializer.fromJson<String>(json['counts']),
      position: serializer.fromJson<int>(json['position']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'dhikrIds': serializer.toJson<String>(dhikrIds),
      'counts': serializer.toJson<String>(counts),
      'position': serializer.toJson<int>(position),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  ComboPresetsTableData copyWith({
    String? id,
    String? name,
    String? dhikrIds,
    String? counts,
    int? position,
    DateTime? createdAt,
  }) => ComboPresetsTableData(
    id: id ?? this.id,
    name: name ?? this.name,
    dhikrIds: dhikrIds ?? this.dhikrIds,
    counts: counts ?? this.counts,
    position: position ?? this.position,
    createdAt: createdAt ?? this.createdAt,
  );
  ComboPresetsTableData copyWithCompanion(ComboPresetsTableCompanion data) {
    return ComboPresetsTableData(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      dhikrIds: data.dhikrIds.present ? data.dhikrIds.value : this.dhikrIds,
      counts: data.counts.present ? data.counts.value : this.counts,
      position: data.position.present ? data.position.value : this.position,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ComboPresetsTableData(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('dhikrIds: $dhikrIds, ')
          ..write('counts: $counts, ')
          ..write('position: $position, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, name, dhikrIds, counts, position, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ComboPresetsTableData &&
          other.id == this.id &&
          other.name == this.name &&
          other.dhikrIds == this.dhikrIds &&
          other.counts == this.counts &&
          other.position == this.position &&
          other.createdAt == this.createdAt);
}

class ComboPresetsTableCompanion
    extends UpdateCompanion<ComboPresetsTableData> {
  final Value<String> id;
  final Value<String> name;
  final Value<String> dhikrIds;
  final Value<String> counts;
  final Value<int> position;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const ComboPresetsTableCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.dhikrIds = const Value.absent(),
    this.counts = const Value.absent(),
    this.position = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ComboPresetsTableCompanion.insert({
    required String id,
    required String name,
    required String dhikrIds,
    required String counts,
    this.position = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name),
       dhikrIds = Value(dhikrIds),
       counts = Value(counts);
  static Insertable<ComboPresetsTableData> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? dhikrIds,
    Expression<String>? counts,
    Expression<int>? position,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (dhikrIds != null) 'dhikr_ids': dhikrIds,
      if (counts != null) 'counts': counts,
      if (position != null) 'position': position,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ComboPresetsTableCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<String>? dhikrIds,
    Value<String>? counts,
    Value<int>? position,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return ComboPresetsTableCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      dhikrIds: dhikrIds ?? this.dhikrIds,
      counts: counts ?? this.counts,
      position: position ?? this.position,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (dhikrIds.present) {
      map['dhikr_ids'] = Variable<String>(dhikrIds.value);
    }
    if (counts.present) {
      map['counts'] = Variable<String>(counts.value);
    }
    if (position.present) {
      map['position'] = Variable<int>(position.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ComboPresetsTableCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('dhikrIds: $dhikrIds, ')
          ..write('counts: $counts, ')
          ..write('position: $position, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $CurrentCountTableTable currentCountTable =
      $CurrentCountTableTable(this);
  late final $CountHistoryTableTable countHistoryTable =
      $CountHistoryTableTable(this);
  late final $ComboPresetsTableTable comboPresetsTable =
      $ComboPresetsTableTable(this);
  late final CurrentCountDao currentCountDao = CurrentCountDao(
    this as AppDatabase,
  );
  late final CountHistoryDao countHistoryDao = CountHistoryDao(
    this as AppDatabase,
  );
  late final ComboPresetsDao comboPresetsDao = ComboPresetsDao(
    this as AppDatabase,
  );
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    currentCountTable,
    countHistoryTable,
    comboPresetsTable,
  ];
}

typedef $$CurrentCountTableTableCreateCompanionBuilder =
    CurrentCountTableCompanion Function({
      Value<int> id,
      Value<int> targetCount,
      Value<int> currentCount,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<String> dhikrId,
      Value<String?> comboName,
      Value<String> sessionMode,
    });
typedef $$CurrentCountTableTableUpdateCompanionBuilder =
    CurrentCountTableCompanion Function({
      Value<int> id,
      Value<int> targetCount,
      Value<int> currentCount,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<String> dhikrId,
      Value<String?> comboName,
      Value<String> sessionMode,
    });

class $$CurrentCountTableTableFilterComposer
    extends Composer<_$AppDatabase, $CurrentCountTableTable> {
  $$CurrentCountTableTableFilterComposer({
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

  ColumnFilters<int> get targetCount => $composableBuilder(
    column: $table.targetCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get currentCount => $composableBuilder(
    column: $table.currentCount,
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

  ColumnFilters<String> get dhikrId => $composableBuilder(
    column: $table.dhikrId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get comboName => $composableBuilder(
    column: $table.comboName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sessionMode => $composableBuilder(
    column: $table.sessionMode,
    builder: (column) => ColumnFilters(column),
  );
}

class $$CurrentCountTableTableOrderingComposer
    extends Composer<_$AppDatabase, $CurrentCountTableTable> {
  $$CurrentCountTableTableOrderingComposer({
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

  ColumnOrderings<int> get targetCount => $composableBuilder(
    column: $table.targetCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get currentCount => $composableBuilder(
    column: $table.currentCount,
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

  ColumnOrderings<String> get dhikrId => $composableBuilder(
    column: $table.dhikrId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get comboName => $composableBuilder(
    column: $table.comboName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sessionMode => $composableBuilder(
    column: $table.sessionMode,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CurrentCountTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $CurrentCountTableTable> {
  $$CurrentCountTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get targetCount => $composableBuilder(
    column: $table.targetCount,
    builder: (column) => column,
  );

  GeneratedColumn<int> get currentCount => $composableBuilder(
    column: $table.currentCount,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<String> get dhikrId =>
      $composableBuilder(column: $table.dhikrId, builder: (column) => column);

  GeneratedColumn<String> get comboName =>
      $composableBuilder(column: $table.comboName, builder: (column) => column);

  GeneratedColumn<String> get sessionMode => $composableBuilder(
    column: $table.sessionMode,
    builder: (column) => column,
  );
}

class $$CurrentCountTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CurrentCountTableTable,
          CurrentCountTableData,
          $$CurrentCountTableTableFilterComposer,
          $$CurrentCountTableTableOrderingComposer,
          $$CurrentCountTableTableAnnotationComposer,
          $$CurrentCountTableTableCreateCompanionBuilder,
          $$CurrentCountTableTableUpdateCompanionBuilder,
          (
            CurrentCountTableData,
            BaseReferences<
              _$AppDatabase,
              $CurrentCountTableTable,
              CurrentCountTableData
            >,
          ),
          CurrentCountTableData,
          PrefetchHooks Function()
        > {
  $$CurrentCountTableTableTableManager(
    _$AppDatabase db,
    $CurrentCountTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CurrentCountTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CurrentCountTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CurrentCountTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> targetCount = const Value.absent(),
                Value<int> currentCount = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<String> dhikrId = const Value.absent(),
                Value<String?> comboName = const Value.absent(),
                Value<String> sessionMode = const Value.absent(),
              }) => CurrentCountTableCompanion(
                id: id,
                targetCount: targetCount,
                currentCount: currentCount,
                createdAt: createdAt,
                updatedAt: updatedAt,
                dhikrId: dhikrId,
                comboName: comboName,
                sessionMode: sessionMode,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> targetCount = const Value.absent(),
                Value<int> currentCount = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<String> dhikrId = const Value.absent(),
                Value<String?> comboName = const Value.absent(),
                Value<String> sessionMode = const Value.absent(),
              }) => CurrentCountTableCompanion.insert(
                id: id,
                targetCount: targetCount,
                currentCount: currentCount,
                createdAt: createdAt,
                updatedAt: updatedAt,
                dhikrId: dhikrId,
                comboName: comboName,
                sessionMode: sessionMode,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$CurrentCountTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CurrentCountTableTable,
      CurrentCountTableData,
      $$CurrentCountTableTableFilterComposer,
      $$CurrentCountTableTableOrderingComposer,
      $$CurrentCountTableTableAnnotationComposer,
      $$CurrentCountTableTableCreateCompanionBuilder,
      $$CurrentCountTableTableUpdateCompanionBuilder,
      (
        CurrentCountTableData,
        BaseReferences<
          _$AppDatabase,
          $CurrentCountTableTable,
          CurrentCountTableData
        >,
      ),
      CurrentCountTableData,
      PrefetchHooks Function()
    >;
typedef $$CountHistoryTableTableCreateCompanionBuilder =
    CountHistoryTableCompanion Function({
      Value<int> id,
      Value<int> targetCount,
      Value<int> currentCount,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<String> dhikrId,
      Value<String?> comboName,
      Value<String> sessionMode,
    });
typedef $$CountHistoryTableTableUpdateCompanionBuilder =
    CountHistoryTableCompanion Function({
      Value<int> id,
      Value<int> targetCount,
      Value<int> currentCount,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<String> dhikrId,
      Value<String?> comboName,
      Value<String> sessionMode,
    });

class $$CountHistoryTableTableFilterComposer
    extends Composer<_$AppDatabase, $CountHistoryTableTable> {
  $$CountHistoryTableTableFilterComposer({
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

  ColumnFilters<int> get targetCount => $composableBuilder(
    column: $table.targetCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get currentCount => $composableBuilder(
    column: $table.currentCount,
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

  ColumnFilters<String> get dhikrId => $composableBuilder(
    column: $table.dhikrId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get comboName => $composableBuilder(
    column: $table.comboName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sessionMode => $composableBuilder(
    column: $table.sessionMode,
    builder: (column) => ColumnFilters(column),
  );
}

class $$CountHistoryTableTableOrderingComposer
    extends Composer<_$AppDatabase, $CountHistoryTableTable> {
  $$CountHistoryTableTableOrderingComposer({
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

  ColumnOrderings<int> get targetCount => $composableBuilder(
    column: $table.targetCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get currentCount => $composableBuilder(
    column: $table.currentCount,
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

  ColumnOrderings<String> get dhikrId => $composableBuilder(
    column: $table.dhikrId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get comboName => $composableBuilder(
    column: $table.comboName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sessionMode => $composableBuilder(
    column: $table.sessionMode,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CountHistoryTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $CountHistoryTableTable> {
  $$CountHistoryTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get targetCount => $composableBuilder(
    column: $table.targetCount,
    builder: (column) => column,
  );

  GeneratedColumn<int> get currentCount => $composableBuilder(
    column: $table.currentCount,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<String> get dhikrId =>
      $composableBuilder(column: $table.dhikrId, builder: (column) => column);

  GeneratedColumn<String> get comboName =>
      $composableBuilder(column: $table.comboName, builder: (column) => column);

  GeneratedColumn<String> get sessionMode => $composableBuilder(
    column: $table.sessionMode,
    builder: (column) => column,
  );
}

class $$CountHistoryTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CountHistoryTableTable,
          CountHistoryTableData,
          $$CountHistoryTableTableFilterComposer,
          $$CountHistoryTableTableOrderingComposer,
          $$CountHistoryTableTableAnnotationComposer,
          $$CountHistoryTableTableCreateCompanionBuilder,
          $$CountHistoryTableTableUpdateCompanionBuilder,
          (
            CountHistoryTableData,
            BaseReferences<
              _$AppDatabase,
              $CountHistoryTableTable,
              CountHistoryTableData
            >,
          ),
          CountHistoryTableData,
          PrefetchHooks Function()
        > {
  $$CountHistoryTableTableTableManager(
    _$AppDatabase db,
    $CountHistoryTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CountHistoryTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CountHistoryTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CountHistoryTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> targetCount = const Value.absent(),
                Value<int> currentCount = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<String> dhikrId = const Value.absent(),
                Value<String?> comboName = const Value.absent(),
                Value<String> sessionMode = const Value.absent(),
              }) => CountHistoryTableCompanion(
                id: id,
                targetCount: targetCount,
                currentCount: currentCount,
                createdAt: createdAt,
                updatedAt: updatedAt,
                dhikrId: dhikrId,
                comboName: comboName,
                sessionMode: sessionMode,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> targetCount = const Value.absent(),
                Value<int> currentCount = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<String> dhikrId = const Value.absent(),
                Value<String?> comboName = const Value.absent(),
                Value<String> sessionMode = const Value.absent(),
              }) => CountHistoryTableCompanion.insert(
                id: id,
                targetCount: targetCount,
                currentCount: currentCount,
                createdAt: createdAt,
                updatedAt: updatedAt,
                dhikrId: dhikrId,
                comboName: comboName,
                sessionMode: sessionMode,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$CountHistoryTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CountHistoryTableTable,
      CountHistoryTableData,
      $$CountHistoryTableTableFilterComposer,
      $$CountHistoryTableTableOrderingComposer,
      $$CountHistoryTableTableAnnotationComposer,
      $$CountHistoryTableTableCreateCompanionBuilder,
      $$CountHistoryTableTableUpdateCompanionBuilder,
      (
        CountHistoryTableData,
        BaseReferences<
          _$AppDatabase,
          $CountHistoryTableTable,
          CountHistoryTableData
        >,
      ),
      CountHistoryTableData,
      PrefetchHooks Function()
    >;
typedef $$ComboPresetsTableTableCreateCompanionBuilder =
    ComboPresetsTableCompanion Function({
      required String id,
      required String name,
      required String dhikrIds,
      required String counts,
      Value<int> position,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });
typedef $$ComboPresetsTableTableUpdateCompanionBuilder =
    ComboPresetsTableCompanion Function({
      Value<String> id,
      Value<String> name,
      Value<String> dhikrIds,
      Value<String> counts,
      Value<int> position,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });

class $$ComboPresetsTableTableFilterComposer
    extends Composer<_$AppDatabase, $ComboPresetsTableTable> {
  $$ComboPresetsTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get dhikrIds => $composableBuilder(
    column: $table.dhikrIds,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get counts => $composableBuilder(
    column: $table.counts,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get position => $composableBuilder(
    column: $table.position,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ComboPresetsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $ComboPresetsTableTable> {
  $$ComboPresetsTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get dhikrIds => $composableBuilder(
    column: $table.dhikrIds,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get counts => $composableBuilder(
    column: $table.counts,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get position => $composableBuilder(
    column: $table.position,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ComboPresetsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $ComboPresetsTableTable> {
  $$ComboPresetsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get dhikrIds =>
      $composableBuilder(column: $table.dhikrIds, builder: (column) => column);

  GeneratedColumn<String> get counts =>
      $composableBuilder(column: $table.counts, builder: (column) => column);

  GeneratedColumn<int> get position =>
      $composableBuilder(column: $table.position, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$ComboPresetsTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ComboPresetsTableTable,
          ComboPresetsTableData,
          $$ComboPresetsTableTableFilterComposer,
          $$ComboPresetsTableTableOrderingComposer,
          $$ComboPresetsTableTableAnnotationComposer,
          $$ComboPresetsTableTableCreateCompanionBuilder,
          $$ComboPresetsTableTableUpdateCompanionBuilder,
          (
            ComboPresetsTableData,
            BaseReferences<
              _$AppDatabase,
              $ComboPresetsTableTable,
              ComboPresetsTableData
            >,
          ),
          ComboPresetsTableData,
          PrefetchHooks Function()
        > {
  $$ComboPresetsTableTableTableManager(
    _$AppDatabase db,
    $ComboPresetsTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ComboPresetsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ComboPresetsTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ComboPresetsTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> dhikrIds = const Value.absent(),
                Value<String> counts = const Value.absent(),
                Value<int> position = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ComboPresetsTableCompanion(
                id: id,
                name: name,
                dhikrIds: dhikrIds,
                counts: counts,
                position: position,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                required String dhikrIds,
                required String counts,
                Value<int> position = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ComboPresetsTableCompanion.insert(
                id: id,
                name: name,
                dhikrIds: dhikrIds,
                counts: counts,
                position: position,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ComboPresetsTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ComboPresetsTableTable,
      ComboPresetsTableData,
      $$ComboPresetsTableTableFilterComposer,
      $$ComboPresetsTableTableOrderingComposer,
      $$ComboPresetsTableTableAnnotationComposer,
      $$ComboPresetsTableTableCreateCompanionBuilder,
      $$ComboPresetsTableTableUpdateCompanionBuilder,
      (
        ComboPresetsTableData,
        BaseReferences<
          _$AppDatabase,
          $ComboPresetsTableTable,
          ComboPresetsTableData
        >,
      ),
      ComboPresetsTableData,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$CurrentCountTableTableTableManager get currentCountTable =>
      $$CurrentCountTableTableTableManager(_db, _db.currentCountTable);
  $$CountHistoryTableTableTableManager get countHistoryTable =>
      $$CountHistoryTableTableTableManager(_db, _db.countHistoryTable);
  $$ComboPresetsTableTableTableManager get comboPresetsTable =>
      $$ComboPresetsTableTableTableManager(_db, _db.comboPresetsTable);
}

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(appDatabase)
final appDatabaseProvider = AppDatabaseProvider._();

final class AppDatabaseProvider
    extends $FunctionalProvider<AppDatabase, AppDatabase, AppDatabase>
    with $Provider<AppDatabase> {
  AppDatabaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'appDatabaseProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$appDatabaseHash();

  @$internal
  @override
  $ProviderElement<AppDatabase> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  AppDatabase create(Ref ref) {
    return appDatabase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AppDatabase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AppDatabase>(value),
    );
  }
}

String _$appDatabaseHash() => r'67f06207fff3a55949c4c4b67200f868a9b6acc8';
