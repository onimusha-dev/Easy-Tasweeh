// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'count_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(countRepository)
final countRepositoryProvider = CountRepositoryProvider._();

final class CountRepositoryProvider
    extends
        $FunctionalProvider<CountRepository, CountRepository, CountRepository>
    with $Provider<CountRepository> {
  CountRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'countRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$countRepositoryHash();

  @$internal
  @override
  $ProviderElement<CountRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  CountRepository create(Ref ref) {
    return countRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(CountRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<CountRepository>(value),
    );
  }
}

String _$countRepositoryHash() => r'd93d14d2f764bcb1a264cc5db184bdb9d51dede2';
