import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTextStyles {
  static const appTitle = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w800,
    color: AppColors.primaryRed,
  );

  static const title = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.w900,
    color: AppColors.textDark,
  );

  static const sectionTitle = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w900,
    color: AppColors.textDark,
  );

  static const label = TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w700,
    color: AppColors.textDark,
  );

  static const body = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: AppColors.textGrey,
  );

  static const small = TextStyle(
    fontSize: 10,
    fontWeight: FontWeight.w500,
    color: AppColors.textGrey,
  );

  static const button = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w800,
    color: Colors.white,
  );
}