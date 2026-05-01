import 'package:easy_tasbeeh/core/theme/schemes/app_colors.dart';
import 'package:flutter/material.dart';

class DhikrUtils {
  static Color getCategoryColor(BuildContext context, String? category) {
    switch (category?.toLowerCase()) {
      case 'praise':
        return AppIconColors.sage(context);
      case 'gratitude':
        return AppIconColors.green(context);
      case 'greatness':
        return AppIconColors.amber(context);
      case 'faith':
        return AppIconColors.blue(context);
      case 'forgiveness':
        return AppIconColors.purple(context);
      case 'submission':
        return AppIconColors.coral(context);
      case 'blessings':
        return AppIconColors.pink(context);
      case 'start':
        return AppIconColors.orange(context);
      case 'names of allah':
        return AppIconColors.gray(context);
      default:
        return AppIconColors.sage(context);
    }
  }

  static String toLocalizedDigits(int number) {
    return number.toString();
  }
}
