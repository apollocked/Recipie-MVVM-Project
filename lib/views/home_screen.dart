// ignore_for_file: must_be_immutable, deprecated_member_use

import 'package:dio_receipe/core/utils/colors.dart';
import 'package:dio_receipe/view_model/recipe_bloc.dart';
import 'package:dio_receipe/view_model/recipe_event.dart';
import 'package:dio_receipe/view_model/recipe_state.dart';
import 'package:dio_receipe/views/widgets/custom_recepie_list.dart';
import 'package:dio_receipe/views/widgets/custom_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgSlate,
      appBar: AppBar(
        toolbarHeight: 80,
        backgroundColor: brandAmber,
        elevation: 0,
        title: Text(
          "RECIPES",
          style: TextStyle(
            color: deepNavy,
            fontWeight: FontWeight.w900,
            letterSpacing: 2,
            fontSize: 20,
          ),
        ),
        actions: [CustomSearchBar()],
      ),
      body: BlocBuilder<RecipeBloc, RecipeState>(
        builder: (context, state) {
          if (state is RecipeInitial) {
            context.read<RecipeBloc>().add(FetchRecipesEvent());
            return const SizedBox.shrink();
          }

          if (state is RecipeLoading) {
            return Center(child: CircularProgressIndicator(color: brandAmber));
          }

          if (state is RecipeError) {
            return Center(child: Text("Error: ${state.message}"));
          }

          if (state is RecipeLoaded) {
            return state.filteredRecipes.isEmpty
                ? const Center(child: Text("No recipes found"))
                : CustomReceipeList(filteredRecipes: state.filteredRecipes);
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}
