import 'package:dio_receipe/views/layout/custom_appbar.dart';
import 'package:dio_receipe/views/widgets/empty_state.dart';
import 'package:dio_receipe/views/widgets/reciept_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// Replace with your actual paths
import 'package:dio_receipe/view_model/recipe_bloc.dart';
import 'package:dio_receipe/view_model/recipe_state.dart';

class LikedReciepesPage extends StatelessWidget {
  const LikedReciepesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar('Liked Reciepes'),
      body: BlocBuilder<RecipeBloc, RecipeState>(
        builder: (context, state) {
          // 1. Show loading indicator while fetching
          if (state is RecipeLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          // 2. Build the list if state is Loaded
          if (state is RecipeLoaded) {
            final likedRecipes = state.favoriteRecipes;

            if (likedRecipes.isEmpty) {
              return EmptyRecipeState(message: "You have no favorite recipes");
            }

            return ListView.builder(
              itemCount: likedRecipes.length,
              itemBuilder: (context, index) {
                final recipe = likedRecipes[index];
                return RecieptCard(
                  recipe: recipe,
                  isFav:
                      true, // Since it's the favorites page, they are all liked
                );
              },
            );
          }

          // 3. Handle errors
          if (state is RecipeError) {
            return Center(child: Text("Error: ${state.message}"));
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}
