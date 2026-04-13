// ignore_for_file: deprecated_member_use

import 'dart:ui';
import 'package:dio_receipe/core/utils/colors.dart';
import 'package:dio_receipe/data/model/receipe_model.dart';
import 'package:dio_receipe/view_model/recepies_provider.dart';
import 'package:dio_receipe/views/widgets/custom_icon_design.dart';
import 'package:dio_receipe/views/widgets/resepie_detail_popup.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CustomReceipeList extends StatelessWidget {
  // Removed required favorites and recipeModel from constructor as Provider handles them
  const CustomReceipeList({
    super.key,
    ReceipeModel? receipeModel,
    required Set<int> favorites,
  });

  @override
  Widget build(BuildContext context) {
    // Listen to the provider
    final provider = context.watch<RecipeProvider>();
    final recipes = provider.recipeModel?.recipes ?? [];

    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 20),
      itemCount: recipes.length,
      itemBuilder: (context, index) {
        final recipe = recipes[index];
        // Fixed contains logic
        final isFav = provider.favorites.contains(recipe.id);

        return Container(
          height: 450,
          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(35),
            boxShadow: [
              BoxShadow(
                color: deepNavy.withOpacity(0.3),
                blurRadius: 25,
                offset: const Offset(0, 15),
              ),
            ],
          ),
          child: Stack(
            children: [
              // 1. Background Image
              Positioned.fill(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(35),
                  child: Image.network(
                    recipe.image ?? '',
                    fit: BoxFit.cover,
                    // Good practice to add a placeholder
                    errorBuilder: (context, error, stackTrace) =>
                        Container(color: Colors.grey),
                  ),
                ),
              ),

              // 2. Gradient Overlay
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(35),
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black.withOpacity(0.1),
                        Colors.transparent,
                        deepNavy.withOpacity(0.9),
                      ],
                    ),
                  ),
                ),
              ),

              // 3. Cuisine Tag
              Positioned(
                top: 20,
                left: 20,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 15,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 10,
                            offset: const Offset(0, 5),
                          ),
                        ],
                        color: Colors.white.withOpacity(0.3),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.3),
                        ),
                      ),
                      child: Text(
                        recipe.cuisine?.toUpperCase() ?? "",
                        style: const TextStyle(
                          color: Colors.black54,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              // 4. Favorite Button
              Positioned(
                top: 20,
                right: 20,
                child: FloatingActionButton.small(
                  backgroundColor: isFav ? Colors.redAccent : Colors.white,
                  elevation: 0,
                  // Simplified toggle call (isFav is already known inside the provider logic)
                  onPressed: () => provider.toggleFavorite(recipe.id ?? 0),
                  child: Icon(
                    isFav ? Icons.favorite : Icons.favorite_border,
                    color: isFav ? Colors.white : deepNavy,
                  ),
                ),
              ),

              // 5. Bottom Info Area
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    bottom: Radius.circular(35),
                  ),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                    child: Container(
                      padding: const EdgeInsets.all(25),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.1),
                        ),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            recipe.name ?? "",
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 26,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 15),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              customIcon(
                                Icons.timer,
                                "${recipe.cookTimeMinutes}m",
                              ),
                              customIcon(
                                Icons.local_fire_department,
                                "${recipe.caloriesPerServing} cal",
                              ),
                              customIcon(Icons.star, "${recipe.rating}"),
                            ],
                          ),
                          const SizedBox(height: 20),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: brandAmber,
                              foregroundColor: deepNavy,
                              minimumSize: const Size(double.infinity, 54),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18),
                              ),
                              elevation: 0,
                            ),
                            onPressed: () => showDetailsPopUp(recipe, context),
                            child: const Text(
                              "VIEW DETAILS",
                              style: TextStyle(
                                fontWeight: FontWeight.w900,
                                fontSize: 14,
                                letterSpacing: 1,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
