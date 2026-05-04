// ignore_for_file: deprecated_member_use

import 'package:dio_receipe/core/utils/colors.dart';
import 'package:dio_receipe/data/model/receipe_model.dart';
import 'package:dio_receipe/views/widgets/header_widget.dart';
import 'package:flutter/material.dart';

class CustomPopUp extends StatelessWidget {
  const CustomPopUp({super.key, required this.recipe});
  final Recipes recipe;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title: Bold and clear
        Text(
          recipe.name ?? "",
          style: TextStyle(
            color: deepNavy,
            fontSize: 24, // Increased for clarity
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          "${recipe.cuisine} • ${recipe.difficulty}".toUpperCase(),
          style: TextStyle(
            color: brandAmber,
            fontWeight: FontWeight.bold,
            fontSize: 13,
            letterSpacing: 1.2,
          ),
        ),
        const Divider(height: 40, thickness: 1),

        // Section: Ingredients
        sectionHeader("INGREDIENTS"),
        const SizedBox(height: 15),
        ...recipe.ingredients!.map(
          (item) => Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.check_circle_outline, color: brandAmber, size: 18),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    item,
                    style: const TextStyle(
                      fontSize: 16, // Highly readable size
                      color: Colors.black87,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 30),

        // Section: Instructions
        sectionHeader("INSTRUCTIONS"),
        const SizedBox(height: 15),
        ...recipe.instructions!.asMap().entries.map(
          (entry) => Padding(
            padding: const EdgeInsets.only(bottom: 18),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 12,
                  backgroundColor: brandAmber.withOpacity(0.2),
                  child: Text(
                    "${entry.key + 1}",
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: deepNavy,
                    ),
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: Text(
                    entry.value,
                    style: const TextStyle(
                      fontSize: 16, // Increased for clarity
                      height: 1.5,
                      color: Colors.black87,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 40),
      ],
    );
  }
}
