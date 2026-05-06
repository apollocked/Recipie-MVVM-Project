// Helper to keep headers consistent
// ignore_for_file: deprecated_member_use

import 'package:dio_receipe/core/theme/app_theme.dart';
import 'package:flutter/material.dart';

Widget sectionHeader(String title) {
  return Text(
    title,
    style: TextStyle(
      fontWeight: FontWeight.w900,
      fontSize: 15,
      color: AppColors.primary.withOpacity(0.7),
      letterSpacing: 1,
    ),
  );
}
