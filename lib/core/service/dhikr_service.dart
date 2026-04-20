import 'package:easy_tasweeh/core/models/dhikr_model.dart';
import 'package:easy_tasweeh/core/service/settings_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final currentDhikrProvider = Provider<DhikrItem>((ref) {
  final lastDhikrId = ref.watch(settingsProvider.select((s) => s.lastDhikrId));
  return dhikrList.firstWhere(
    (d) => d.id == lastDhikrId,
    orElse: () => dhikrList.first,
  );
});
