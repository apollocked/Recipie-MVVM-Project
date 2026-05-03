import 'package:dio_receipe/core/utils/colors.dart';
import 'package:dio_receipe/view_model/recipe_bloc.dart';
import 'package:dio_receipe/view_model/recipe_event.dart';
import 'package:dio_receipe/view_model/recipe_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CustomSearchBar extends StatelessWidget {
  const CustomSearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RecipeBloc, RecipeState>(
      builder: (context, state) {
        if (state is RecipeLoaded) {
          if (state.isSearching) {
            return Container(
              margin: EdgeInsets.only(right: 10),
              width: MediaQuery.of(context).size.width * 0.65,
              decoration: BoxDecoration(
                color: bgSlate,
                borderRadius: BorderRadius.circular(12),
              ),
              child: TextField(
                onChanged: (value) {
                  context.read<RecipeBloc>().add(SearchRecipesEvent(value));
                },
                decoration: InputDecoration(
                  hintText: "Search recipes...",
                  suffixIcon: state.searchQuery.isNotEmpty
                      ? IconButton(
                          icon: Text("Clear"),
                          onPressed: () {
                            context.read<RecipeBloc>().add(
                              SearchRecipesEvent(""),
                            );
                          },
                        )
                      : IconButton(
                          icon: Icon(Icons.arrow_forward_ios, color: deepNavy),
                          onPressed: () {
                            context.read<RecipeBloc>().add(ToggleSearchEvent());
                          },
                        ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            );
          } else {
            // Show search icon when not searching
            return IconButton(
              icon: Icon(Icons.search, color: deepNavy),
              onPressed: () {
                context.read<RecipeBloc>().add(ToggleSearchEvent());
              },
            );
          }
        }
        return const SizedBox.shrink();
      },
    );
  }
}
