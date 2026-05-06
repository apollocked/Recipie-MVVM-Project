import 'package:dio_receipe/data/model/recipe_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ReceipeModel Tests', () {
    final Map<String, dynamic> mockJson = {
      "recipes": [
        {
          "id": 1,
          "name": "Classic Margherita Pizza",
          "ingredients": ["Pizza dough", "Tomato sauce", "Fresh mozzarella"],
          "instructions": ["Preheat oven", "Spread sauce", "Bake"],
          "prepTimeMinutes": 15,
          "cookTimeMinutes": 20,
          "servings": 4,
          "difficulty": "Easy",
          "cuisine": "Italian",
          "caloriesPerServing": 300,
          "tags": ["Pizza", "Italian"],
          "userId": 45,
          "image": "https://example.com/image.jpg",
          "rating": 4.8,
          "reviewCount": 120,
          "mealType": ["Dinner"],
        },
      ],
      "total": 1,
      "skip": 0,
      "limit": 10,
    };

    test('fromJson should create a valid model from Map', () {
      // Act
      final model = ReceipeModel.fromJson(mockJson);

      // Assert
      expect(model.total, 1);
      expect(model.recipes, isNotNull);
      expect(model.recipes!.length, 1);

      final recipe = model.recipes![0];
      expect(recipe.id, 1);
      expect(recipe.name, "Classic Margherita Pizza");
      expect(recipe.ingredients, contains("Pizza dough"));
      expect(recipe.rating, 4.8);
      expect(recipe.mealType, isA<List<String>>());
    });

    test('toJson should convert model back to a valid Map', () {
      // Arrange
      final model = ReceipeModel.fromJson(mockJson);

      // Act
      final jsonOutput = model.toJson();

      // Assert
      expect(jsonOutput['total'], mockJson['total']);
      expect(jsonOutput['recipes'][0]['name'], mockJson['recipes'][0]['name']);
      expect(jsonOutput['recipes'][0]['ingredients'], isA<List<String>>());
    });

    test('should handle null values gracefully', () {
      // Arrange
      final Map<String, dynamic> emptyJson = {
        "recipes": null,
        "total": 0,
        "skip": 0,
        "limit": 0,
      };

      // Act
      final model = ReceipeModel.fromJson(emptyJson);

      // Assert
      expect(model.recipes, isNull);
      expect(model.total, 0);
    });

    test('Recipes.fromJson should correctly cast List types', () {
      // This tests the .cast<String>() logic in your model
      final recipeJson = mockJson['recipes'][0];
      final recipe = Recipes.fromJson(recipeJson);
      expect(recipe.ingredients, isA<List<String>>());
      expect(recipe.instructions, isA<List<String>>());
      expect(recipe.tags, isA<List<String>>());
      expect(recipe.mealType, isA<List<String>>());
    });
  });
}
