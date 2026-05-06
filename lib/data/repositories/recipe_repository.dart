import 'package:dio_receipe/data/model/recipe_model.dart';
import 'package:dio_receipe/data/services/recipe_service.dart';

class RecipeRepository {
  final RecepieService _recipeService;

  RecipeRepository(this._recipeService);

  /// Fetches the recipe list and unwraps the model for the BLoC
  Future<List<Recipes>> getAllRecipes() async {
    try {
      final recipeModel = await _recipeService.getRecepie();
      return recipeModel.recipes ?? [];
    } catch (e) {
      throw Exception("Failed to fetch recipes: $e");
    }
  }
}
