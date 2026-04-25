import 'package:package_info_plus/package_info_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Provider for the raw PackageInfo. 
/// Initialized in main() and overridden in ProviderScope.
final packageInfoProvider = Provider<PackageInfo>((ref) {
  throw UnimplementedError('packageInfoProvider must be overridden in main()');
});

/// Provider for a clean version string (e.g. "1.0.7").
final appVersionProvider = Provider<String>((ref) {
  final packageInfo = ref.watch(packageInfoProvider);
  return packageInfo.version;
});
