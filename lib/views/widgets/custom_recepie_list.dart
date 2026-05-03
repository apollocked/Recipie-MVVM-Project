// ignore_for_file: deprecated_member_use

import 'package:dio_receipe/data/model/receipe_model.dart';
import 'package:dio_receipe/view_model/recepies_provider.dart';
import 'package:dio_receipe/views/widgets/reciept_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CustomReceipeList extends StatelessWidget {
  final List<Recipes> recipes;
  const CustomReceipeList({
    super.key,
    ReceipeModel? receipeModel,
    required Set<int> favorites,
    required this.recipes,
  });

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<RecipeProvider>(context);

    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 20),
      itemCount: recipes.length,
      itemBuilder: (context, index) {
        final recipe = recipes[index];
        // Fixed contains logic
        final isFav = provider.favorites.contains(recipe.id);

        return RecieptCard(recipe: recipe, isFav: isFav, provider: provider);
      },
    );
  }
}
