// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'count_history_dao.dart';

// ignore_for_file: type=lint
mixin _$CountHistoryDaoMixin on DatabaseAccessor<AppDatabase> {
  $CountHistoryTableTable get countHistoryTable =>
      attachedDatabase.countHistoryTable;
  CountHistoryDaoManager get managers => CountHistoryDaoManager(this);
}

class CountHistoryDaoManager {
  final _$CountHistoryDaoMixin _db;
  CountHistoryDaoManager(this._db);
  $$CountHistoryTableTableTableManager get countHistoryTable =>
      $$CountHistoryTableTableTableManager(
        _db.attachedDatabase,
        _db.countHistoryTable,
      );
}

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(countHistoryDao)
final countHistoryDaoProvider = CountHistoryDaoProvider._();

final class CountHistoryDaoProvider
    extends
        $FunctionalProvider<CountHistoryDao, CountHistoryDao, CountHistoryDao>
    with $Provider<CountHistoryDao> {
  CountHistoryDaoProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'countHistoryDaoProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$countHistoryDaoHash();

  @$internal
  @override
  $ProviderElement<CountHistoryDao> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  CountHistoryDao create(Ref ref) {
    return countHistoryDao(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(CountHistoryDao value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<CountHistoryDao>(value),
    );
  }
}

String _$countHistoryDaoHash() => r'2fe3e1154dde1c181081be7a23492596cb4e500d';
