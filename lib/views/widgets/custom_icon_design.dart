import 'package:dio_receipe/core/utils/colors.dart';
import 'package:flutter/material.dart';

Widget customIcon(IconData icon, String label) => Row(
  children: [
    Icon(icon, color: brandAmber, size: 22),
    const SizedBox(width: 4),
    Text(
      label,
      style: const TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.w600,
        fontSize: 14,
      ),
    ),
  ],
);
