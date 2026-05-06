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
    on<FetchFavoritesEvent>(_onFetchFavorites);
  }

  List<Recipes> _getFavoriteList() {
    return _allRecipes
        .where((recipe) => _favorites.contains(recipe.id))
        .toList();
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
          favoriteRecipes: _getFavoriteList(),
          favorites: _favorites,
        ),
      );
    } catch (e) {
      emit(RecipeError(e.toString()));
    }
  }

  void _onToggleFavorite(ToggleFavoriteEvent event, Emitter<RecipeState> emit) {
    if (state is RecipeLoaded) {
      final currentState = state as RecipeLoaded;

      if (_favorites.contains(event.recipeId)) {
        _favorites.remove(event.recipeId);
      } else {
        _favorites.add(event.recipeId);
      }

      final favList = _getFavoriteList();

      emit(
        RecipeLoaded(
          recipes: _allRecipes,
          filteredRecipes: currentState.filteredRecipes,
          favoriteRecipes: favList,
          favorites: _favorites,
          searchQuery: currentState.searchQuery,
          isSearching: currentState.isSearching,
        ),
      );
    }
  }

  void _onFetchFavorites(FetchFavoritesEvent event, Emitter<RecipeState> emit) {
    if (state is RecipeLoaded) {
      final favList = _getFavoriteList();
      emit(
        RecipeLoaded(
          recipes: _allRecipes,
          filteredRecipes: favList,
          favoriteRecipes: favList,
          favorites: _favorites,
          isSearching: false,
        ),
      );
    }
  }

  Future<void> _onSearchRecipes(
    SearchRecipesEvent event,
    Emitter<RecipeState> emit,
  ) async {
    if (state is RecipeLoaded) {
      final currentState = state as RecipeLoaded;
      List<Recipes> filtered = event.query.isEmpty
          ? _allRecipes
          : _allRecipes
                .where(
                  (r) =>
                      r.name?.toLowerCase().contains(
                        event.query.toLowerCase(),
                      ) ??
                      false,
                )
                .toList();

      emit(
        RecipeLoaded(
          recipes: _allRecipes,
          filteredRecipes: filtered,
          favoriteRecipes: currentState.favoriteRecipes,
          favorites: _favorites,
          searchQuery: event.query,
          isSearching: currentState.isSearching,
        ),
      );
    }
  }

  void _onToggleSearch(ToggleSearchEvent event, Emitter<RecipeState> emit) {
    if (state is RecipeLoaded) {
      final currentState = state as RecipeLoaded;
      emit(
        RecipeLoaded(
          recipes: _allRecipes,
          filteredRecipes: currentState.filteredRecipes,
          favoriteRecipes: currentState.favoriteRecipes,
          favorites: _favorites,
          searchQuery: currentState.searchQuery,
          isSearching: !currentState.isSearching,
        ),
      );
    }
  }
}
