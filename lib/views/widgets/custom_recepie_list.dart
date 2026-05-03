// ignore_for_file: deprecated_member_use

import 'package:dio_receipe/data/model/receipe_model.dart';
import 'package:dio_receipe/view_model/recipe_bloc.dart';
import 'package:dio_receipe/view_model/recipe_state.dart';
import 'package:dio_receipe/views/widgets/reciept_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CustomReceipeList extends StatelessWidget {
  final List<Recipes> filteredRecipes;

  const CustomReceipeList({super.key, required this.filteredRecipes});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RecipeBloc, RecipeState>(
      builder: (context, state) {
        if (state is! RecipeLoaded) {
          return const SizedBox.shrink();
        }

        return ListView.builder(
          padding: const EdgeInsets.symmetric(vertical: 20),
          itemCount: filteredRecipes.length,
          itemBuilder: (context, index) {
            final recipe = filteredRecipes[index];
            final isFav = state.favorites.contains(recipe.id);

            return RecieptCard(recipe: recipe, isFav: isFav);
          },
        );
      },
    );
  }
}
