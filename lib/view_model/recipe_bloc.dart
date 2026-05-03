import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio_receipe/data/model/receipe_model.dart';
import 'package:dio_receipe/data/services/recepie_service.dart';
import 'recipe_event.dart';
import 'recipe_state.dart';

class RecipeBloc extends Bloc<RecipeEvent, RecipeState> {
  final RecepieService recipeService;
  List<Recipes> _allRecipes = [];
  final Set<int> _favorites = {};

  RecipeBloc(this.recipeService) : super(RecipeInitial()) {
    on<FetchRecipesEvent>(_onFetchRecipes);
    on<SearchRecipesEvent>(_onSearchRecipes);
    on<ToggleSearchEvent>(_onToggleSearch);
    on<ToggleFavoriteEvent>(_onToggleFavorite);
  }

  Future<void> _onFetchRecipes(
    FetchRecipesEvent event,
    Emitter<RecipeState> emit,
  ) async {
    emit(RecipeLoading());
    try {
      final recipeModel = await recipeService.getRecepie();
      _allRecipes = recipeModel.recipes ?? [];
      emit(
        RecipeLoaded(
          recipes: _allRecipes,
          filteredRecipes: _allRecipes,
          favorites: _favorites,
        ),
      );
    } catch (e) {
      emit(RecipeError(e.toString()));
    }
  }

  Future<void> _onSearchRecipes(
    SearchRecipesEvent event,
    Emitter<RecipeState> emit,
  ) async {
    if (state is RecipeLoaded) {
      final currentState = state as RecipeLoaded;
      late List<Recipes> filtered;

      if (event.query.isEmpty) {
        filtered = _allRecipes;
      } else {
        filtered = _allRecipes
            .where(
              (recipe) =>
                  recipe.name?.toLowerCase().contains(
                    event.query.toLowerCase(),
                  ) ??
                  false,
            )
            .toList();
      }

      emit(
        RecipeLoaded(
          recipes: _allRecipes,
          filteredRecipes: filtered,
          favorites: _favorites,
          searchQuery: event.query,
          isSearching: currentState.isSearching,
        ),
      );
    }
  }

  Future<void> _onToggleSearch(
    ToggleSearchEvent event,
    Emitter<RecipeState> emit,
  ) async {
    if (state is RecipeLoaded) {
      final currentState = state as RecipeLoaded;
      emit(
        RecipeLoaded(
          recipes: _allRecipes,
          filteredRecipes: currentState.filteredRecipes,
          favorites: _favorites,
          searchQuery: currentState.searchQuery,
          isSearching: !currentState.isSearching,
        ),
      );
    }
  }

  Future<void> _onToggleFavorite(
    ToggleFavoriteEvent event,
    Emitter<RecipeState> emit,
  ) async {
    if (state is RecipeLoaded) {
      final currentState = state as RecipeLoaded;
      if (_favorites.contains(event.recipeId)) {
        _favorites.remove(event.recipeId);
      } else {
        _favorites.add(event.recipeId);
      }

      emit(
        RecipeLoaded(
          recipes: _allRecipes,
          filteredRecipes: currentState.filteredRecipes,
          favorites: _favorites,
          searchQuery: currentState.searchQuery,
          isSearching: currentState.isSearching,
        ),
      );
    }
  }
}
