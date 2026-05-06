abstract class RecipeEvent {}

class FetchRecipesEvent extends RecipeEvent {}

class SearchRecipesEvent extends RecipeEvent {
  final String query;
  SearchRecipesEvent(this.query);
}

class ToggleSearchEvent extends RecipeEvent {}

class FetchFavoritesEvent extends RecipeEvent {}

class ToggleFavoriteEvent extends RecipeEvent {
  final int recipeId;
  ToggleFavoriteEvent(this.recipeId);
}
