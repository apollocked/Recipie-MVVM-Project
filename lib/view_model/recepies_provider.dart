import 'package:flutter/material.dart';
import 'package:dio_receipe/data/model/receipe_model.dart';
import 'package:dio_receipe/data/services/recepie_service.dart';

class RecipeProvider extends ChangeNotifier {
  ReceipeModel? _recipeModel;
  bool _isLoading = false;
  String? _errorMessage;

  // 1. Declare the favorites set
  final Set<int> _favorites = {};

  ReceipeModel? get recipeModel => _recipeModel;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // 2. Add a getter for favorites
  Set<int> get favorites => _favorites;

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

  // 3. The toggle logic is now connected to the _favorites set
  void toggleFavorite(int id) {
    if (_favorites.contains(id)) {
      _favorites.remove(id);
    } else {
      _favorites.add(id);
    }
    notifyListeners(); // This ensures the heart icon updates immediately
  }
}
