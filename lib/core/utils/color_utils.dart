import 'package:easy_tasbeeh/core/theme/schemes/app_colors.dart';
import 'package:flutter/material.dart';

/// Returns a Color based on the provided string name.
/// If the color name is not recognized or null, returns Colors.white by default.
Color setIconsColor(String? color) {
  switch (color?.toLowerCase()) {
    case 'blue':
      return Colors.blue;
    case 'green':
      return Colors.green;
    case 'red':
      return Colors.red;
    case 'yellow':
      return Colors.yellow;
    case 'purple':
      return Colors.purple;
    case 'orange':
      return Colors.orange;
    case 'pink':
      return Colors.pink;
    case 'brown':
      return Colors.brown;
    case 'grey':
      return Colors.grey;
    case 'black':
      return Colors.black;
    case 'white':
      return Colors.white;
    default:
      return Colors.white;
  }
}

Color setPercentageCompletionColor(BuildContext context, double percentage) {
  if (percentage < 25) {
    // Explicit vibrant red to ensure it doesn't look like yellow/amber
    return const Color(0xFFE53935);
  } else if (percentage < 50) {
    return AppIconColors.orange(context);
  } else if (percentage < 75) {
    return AppIconColors.amber(context);
  } else {
    return AppIconColors.green(context);
  }
}
