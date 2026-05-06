import 'package:dio_receipe/core/theme/app_theme.dart';
import 'package:flutter/material.dart';

Widget customIcon(IconData icon, String label) => Row(
  children: [
    Icon(icon, color: AppColors.accent, size: 22),
    const SizedBox(width: 4),
    Text(
      label,
      style: const TextStyle(
        color: AppColors.textLight,
        fontWeight: FontWeight.w600,
        fontSize: 14,
      ),
    ),
  ],
);
