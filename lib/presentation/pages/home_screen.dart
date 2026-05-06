// ignore_for_file: must_be_immutable, deprecated_member_use

import 'package:dio_receipe/core/theme/app_theme.dart';
import 'package:dio_receipe/logic/receipe_bloc/recipe_bloc.dart';
import 'package:dio_receipe/logic/receipe_bloc/recipe_event.dart';
import 'package:dio_receipe/logic/receipe_bloc/recipe_state.dart';
import 'package:dio_receipe/presentation/layout/custom_appbar.dart';
import 'package:dio_receipe/presentation/widgets/custom_recepie_list.dart';
import 'package:dio_receipe/presentation/widgets/custom_search_bar.dart';
import 'package:dio_receipe/presentation/widgets/empty_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key, required this.flavorName});
  final String flavorName;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar('Recipes - $flavorName', child: CustomSearchBar()),

      body: RefreshIndicator(
        onRefresh: () async {
          context.read<RecipeBloc>().add(FetchRecipesEvent());
        },
        child: BlocBuilder<RecipeBloc, RecipeState>(
          builder: (context, state) {
            if (state is RecipeInitial) {
              context.read<RecipeBloc>().add(FetchRecipesEvent());
              return const SizedBox.shrink();
            }

            if (state is RecipeLoading) {
              return Center(
                child: CircularProgressIndicator(color: AppColors.accent),
              );
            }

            if (state is RecipeError) {
              return Center(child: Text("Error: ${state.message}"));
            }

            if (state is RecipeLoaded) {
              return state.filteredRecipes.isEmpty
                  ? EmptyRecipeState(
                      message:
                          "Your search didn't serve up any results. Try a different recipe name!",
                    )
                  : CustomReceipeList(filteredRecipes: state.filteredRecipes);
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
