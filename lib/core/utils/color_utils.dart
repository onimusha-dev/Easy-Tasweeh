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

Color setPercentageCompletionColor(double percentage) {
  if (percentage < 25) {
    return Colors.redAccent;
  } else if (percentage < 50) {
    return Colors.orangeAccent;
  } else if (percentage < 75) {
    return Colors.amberAccent;
  } else {
    return Colors.greenAccent;
  }
}
