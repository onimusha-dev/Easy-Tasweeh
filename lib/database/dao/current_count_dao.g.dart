// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'current_count_dao.dart';

// ignore_for_file: type=lint
mixin _$CurrentCountDaoMixin on DatabaseAccessor<AppDatabase> {
  $CurrentCountTableTable get currentCountTable =>
      attachedDatabase.currentCountTable;
  CurrentCountDaoManager get managers => CurrentCountDaoManager(this);
}

class CurrentCountDaoManager {
  final _$CurrentCountDaoMixin _db;
  CurrentCountDaoManager(this._db);
  $$CurrentCountTableTableTableManager get currentCountTable =>
      $$CurrentCountTableTableTableManager(
        _db.attachedDatabase,
        _db.currentCountTable,
      );
}

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(currentCountDao)
final currentCountDaoProvider = CurrentCountDaoProvider._();

final class CurrentCountDaoProvider
    extends
        $FunctionalProvider<CurrentCountDao, CurrentCountDao, CurrentCountDao>
    with $Provider<CurrentCountDao> {
  CurrentCountDaoProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'currentCountDaoProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$currentCountDaoHash();

  @$internal
  @override
  $ProviderElement<CurrentCountDao> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  CurrentCountDao create(Ref ref) {
    return currentCountDao(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(CurrentCountDao value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<CurrentCountDao>(value),
    );
  }
}

String _$currentCountDaoHash() => r'0bbef0ad0c920f9d463d8573ef06e58618e3fe86';
