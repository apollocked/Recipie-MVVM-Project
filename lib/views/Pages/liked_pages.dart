import 'package:dio_receipe/views/layout/custom_appbar.dart';
import 'package:dio_receipe/views/widgets/empty_state.dart';
import 'package:dio_receipe/views/widgets/reciept_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// Replace with your actual paths
import 'package:dio_receipe/view_model/receipe_bloc/recipe_bloc.dart';
import 'package:dio_receipe/view_model/receipe_bloc/recipe_state.dart';

class LikedReciepesPage extends StatelessWidget {
  const LikedReciepesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar('Liked Reciepes'),
      body: BlocBuilder<RecipeBloc, RecipeState>(
        builder: (context, state) {
          if (state is RecipeLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is RecipeLoaded) {
            final likedRecipes = state.favoriteRecipes;

            if (likedRecipes.isEmpty) {
              return EmptyRecipeState(message: "You have no favorite recipes");
            }

            return ListView.builder(
              itemCount: likedRecipes.length,
              itemBuilder: (context, index) {
                final recipe = likedRecipes[index];
                return RecieptCard(recipe: recipe, isFav: true);
              },
            );
          }

          if (state is RecipeError) {
            return Center(child: Text("Error: ${state.message}"));
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
