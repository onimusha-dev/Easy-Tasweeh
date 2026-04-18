import 'package:easy_tasweeh/core/models/dhikr_model.dart';
import 'package:flutter_riverpod/legacy.dart';

final currentDhikrProvider = StateProvider<DhikrItem>((ref) {
  return dhikrList.first;
});
