import 'package:flutter/material.dart';
import 'app_colors.dart';

abstract class BaseColorScheme {
  Brightness get brightness;
  ColorScheme get colorScheme;
  AppColors get appColors;
  
  Color get textPrimary;
  Color get textSecondary;
  Color get surface;
  Color get card;
  Color get border;
  Color get divider;
}
