import 'package:flutter/material.dart';
import 'package:dio_receipe/data/model/receipe_model.dart';
import 'package:dio_receipe/data/services/recepie_service.dart';

class RecipeProvider extends ChangeNotifier {
  ReceipeModel? _recipeModel;
  bool _isLoading = false;
  String? _errorMessage;
  bool _isSearching = false;
  bool get isSearching => _isSearching;
  String _searchQuery = '';
  String get searchQuery => _searchQuery;
  final Set<int> _favorites = {};

  ReceipeModel? get recipeModel => _recipeModel;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Set<int> get favorites => _favorites;
  void updateSearchQuery(String query) {
    if (query == _searchQuery) return;

    _searchQuery = query;
    notifyListeners();
  }

  void toggleSearch() {
    _isSearching = !_isSearching;
    notifyListeners();
  }

  List<Recipes> get filteredRecipes {
    if (_searchQuery.isEmpty) {
      return recipeModel?.recipes ?? [];
    }
    return (recipeModel?.recipes ?? [])
        .where(
          (recipe) =>
              recipe.name?.toLowerCase().contains(_searchQuery.toLowerCase()) ??
              false,
        )
        .toList();
  }

  Future<void> fetchRecipes() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      _recipeModel = await RecepieService().getRecepie();
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void toggleFavorite(int id) {
    if (_favorites.contains(id)) {
      _favorites.remove(id);
    } else {
      _favorites.add(id);
    }
    notifyListeners();
  }
}
