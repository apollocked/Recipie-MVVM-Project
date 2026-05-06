import 'package:dio_receipe/core/theme/app_theme.dart';
import 'package:dio_receipe/logic/receipe_bloc/recipe_bloc.dart';
import 'package:dio_receipe/logic/receipe_bloc/recipe_event.dart';
import 'package:dio_receipe/logic/receipe_bloc/recipe_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CustomSearchBar extends StatefulWidget {
  const CustomSearchBar({super.key});

  @override
  State<CustomSearchBar> createState() => _CustomSearchBarState();
}

class _CustomSearchBarState extends State<CustomSearchBar>
    with SingleTickerProviderStateMixin {
  AnimationController? controller;
  Animation<double>? animation;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    animation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(parent: controller!, curve: Curves.easeOut));
  }

  @override
  void dispose() {
    controller!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<RecipeBloc, RecipeState>(
      listenWhen: (prev, current) =>
          prev is RecipeLoaded &&
          current is RecipeLoaded &&
          prev.isSearching != current.isSearching,
      listener: (context, state) {
        if (state is RecipeLoaded && state.isSearching) {
          controller!.reset();
          controller!.forward();
        }
      },
      builder: (context, state) {
        if (state is RecipeLoaded) {
          if (state.isSearching) {
            return AnimatedBuilder(
              animation: controller!,
              builder: (BuildContext context, _) {
                return Container(
                  margin: const EdgeInsets.only(right: 10, bottom: 4),
                  width:
                      MediaQuery.of(context).size.width *
                      0.6 *
                      animation!.value,
                  decoration: BoxDecoration(
                    color: AppColors.background,
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
                              icon: const Text("Clear"),
                              onPressed: () {
                                context.read<RecipeBloc>().add(
                                  SearchRecipesEvent(""),
                                );
                              },
                            )
                          : IconButton(
                              icon: Icon(
                                Icons.arrow_forward_ios,
                                color: AppColors.primary,
                              ),
                              onPressed: () {
                                context.read<RecipeBloc>().add(
                                  ToggleSearchEvent(),
                                );
                              },
                            ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                );
              },
            );
          } else {
            return IconButton(
              icon: Icon(Icons.search, color: AppColors.primary),
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
