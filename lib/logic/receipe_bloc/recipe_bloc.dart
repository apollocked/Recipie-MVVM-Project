import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio_receipe/data/model/recipe_model.dart';
import 'package:dio_receipe/data/repositories/recipe_repository.dart';
import 'recipe_event.dart';
import 'recipe_state.dart';

class RecipeBloc extends Bloc<RecipeEvent, RecipeState> {
  final RecipeRepository recipeRepository;
  final SharedPreferences prefs; // Inject SharedPreferences

  List<Recipes> _allRecipes = [];
  Set<int> _favorites = {};

  static const String _favoritesKey = 'saved_favorites_key';

  RecipeBloc({required this.recipeRepository, required this.prefs})
    : super(RecipeInitial()) {
    _loadFavorites(); // Load saved favorites immediately upon creation

    on<FetchRecipesEvent>(_onFetchRecipes);
    on<SearchRecipesEvent>(_onSearchRecipes);
    on<ToggleSearchEvent>(_onToggleSearch);
    on<ToggleFavoriteEvent>(_onToggleFavorite);
    on<FetchFavoritesEvent>(_onFetchFavorites);
  }

  //  SharedPreferences Logic to save and load favorites

  void _loadFavorites() {
    final List<String>? savedFavs = prefs.getStringList(_favoritesKey);
    if (savedFavs != null) {
      // Convert the List<String> back to a Set<int>
      _favorites = savedFavs.map((id) => int.parse(id)).toSet();
    }
  }

  Future<void> _saveFavorites() async {
    // Convert the Set<int> into a List<String> for storage
    final List<String> favStrings = _favorites
        .map((id) => id.toString())
        .toList();
    await prefs.setStringList(_favoritesKey, favStrings);
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
      _allRecipes = await recipeRepository.getAllRecipes();
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
      await _saveFavorites();

      emit(
        RecipeLoaded(
          recipes: _allRecipes,
          filteredRecipes: currentState.filteredRecipes,
          favoriteRecipes: _getFavoriteList(),
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
