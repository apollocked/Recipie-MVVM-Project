import 'package:dio_receipe/core/utils/colors.dart';
import 'package:flutter/material.dart';

class EmptyRecipeState extends StatelessWidget {
  const EmptyRecipeState({super.key, required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Food/Dish related icon
          Icon(
            Icons.no_food_rounded,
            size: 80,
            color: brandAmber.withAlpha(900),
          ),
          const SizedBox(height: 20),
          Text(
            "No Dishes Found",
            style: TextStyle(
              color: deepNavy,
              fontSize: 20,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 50),
            child: Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(color: deepNavy.withAlpha(700), fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }
}
