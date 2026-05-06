// ignore_for_file: deprecated_member_use

import 'package:dio_receipe/core/theme/app_theme.dart';
import 'package:dio_receipe/views/widgets/custom_popup.dart';
import 'package:flutter/material.dart';

Future<dynamic> showDetailsPopUp(dynamic recipe, BuildContext context) {
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    barrierLabel: "close",
    barrierColor: AppColors.accent.withAlpha(900),
    backgroundColor: AppColors.surface.withAlpha(720),
    builder: (context) => Container(
      height: MediaQuery.of(context).size.height * 0.85,
      decoration: const BoxDecoration(
        color: AppColors.transparent,
        borderRadius: BorderRadius.vertical(top: Radius.circular(35)),
      ),
      child: Column(
        children: [
          // Fixed Header Grabber
          const SizedBox(height: 12),
          Container(
            width: 50,
            height: 5,
            decoration: BoxDecoration(
              color: AppColors.border,
              borderRadius: BorderRadius.circular(10),
            ),
          ),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(25),
              child: CustomPopUp(recipe: recipe),
            ),
          ),
        ],
      ),
    ),
  );
}
