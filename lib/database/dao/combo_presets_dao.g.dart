// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'combo_presets_dao.dart';

// ignore_for_file: type=lint
mixin _$ComboPresetsDaoMixin on DatabaseAccessor<AppDatabase> {
  $ComboPresetsTableTable get comboPresetsTable =>
      attachedDatabase.comboPresetsTable;
  ComboPresetsDaoManager get managers => ComboPresetsDaoManager(this);
}

class ComboPresetsDaoManager {
  final _$ComboPresetsDaoMixin _db;
  ComboPresetsDaoManager(this._db);
  $$ComboPresetsTableTableTableManager get comboPresetsTable =>
      $$ComboPresetsTableTableTableManager(
        _db.attachedDatabase,
        _db.comboPresetsTable,
      );
}

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(comboPresetsDao)
final comboPresetsDaoProvider = ComboPresetsDaoProvider._();

final class ComboPresetsDaoProvider
    extends
        $FunctionalProvider<ComboPresetsDao, ComboPresetsDao, ComboPresetsDao>
    with $Provider<ComboPresetsDao> {
  ComboPresetsDaoProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'comboPresetsDaoProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$comboPresetsDaoHash();

  @$internal
  @override
  $ProviderElement<ComboPresetsDao> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  ComboPresetsDao create(Ref ref) {
    return comboPresetsDao(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ComboPresetsDao value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ComboPresetsDao>(value),
    );
  }
}

String _$comboPresetsDaoHash() => r'1a83db5ffd3b5ced8d9ae55fa761cb4bf8f44edc';
