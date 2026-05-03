import 'package:dio_receipe/data/model/receipe_model.dart';

abstract class RecipeState {}

class RecipeInitial extends RecipeState {}

class RecipeLoading extends RecipeState {}

class RecipeLoaded extends RecipeState {
  final List<Recipes> recipes;
  final List<Recipes> filteredRecipes;
  final Set<int> favorites;
  final String searchQuery;
  final bool isSearching;

  RecipeLoaded({
    required this.recipes,
    required this.filteredRecipes,
    required this.favorites,
    this.searchQuery = "",
    this.isSearching = false,
  });
}

class RecipeError extends RecipeState {
  final String message;
  RecipeError(this.message);
}
