import 'package:bloc_test/bloc_test.dart';
import 'package:dio_receipe/data/model/receipe_model.dart';
import 'package:dio_receipe/data/services/recepie_service.dart';
import 'package:dio_receipe/view_model/recipe_bloc.dart';
import 'package:dio_receipe/view_model/recipe_event.dart';
import 'package:dio_receipe/view_model/recipe_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockRecipeService extends Mock implements RecepieService {}

void main() {
  late RecipeBloc recipeBloc;
  late MockRecipeService mockRecipeService;

  setUp(() {
    mockRecipeService = MockRecipeService();
    recipeBloc = RecipeBloc(mockRecipeService);
  });

  tearDown(() {
    recipeBloc.close();
  });

  // Mock Data
  final tRecipe = Recipes(id: 1, name: 'Pasta');
  final tRecipeModel = ReceipeModel(recipes: [tRecipe]);

  group('RecipeBloc Tests', () {
    test('initial state should be RecipeInitial', () {
      expect(recipeBloc.state, isA<RecipeInitial>());
    });

    blocTest<RecipeBloc, RecipeState>(
      'emits [RecipeLoading, RecipeLoaded] when FetchRecipesEvent is successful',
      build: () {
        // Mocking the service response
        when(
          () => mockRecipeService.getRecepie(),
        ).thenAnswer((_) async => tRecipeModel);
        return recipeBloc;
      },
      act: (bloc) => bloc.add(FetchRecipesEvent()),
      expect: () => [
        isA<RecipeLoading>(),
        isA<RecipeLoaded>().having((s) => s.recipes.length, 'count', 1),
      ],
    );

    blocTest<RecipeBloc, RecipeState>(
      'emits [RecipeLoading, RecipeError] when FetchRecipesEvent fails',
      build: () {
        when(
          () => mockRecipeService.getRecepie(),
        ).thenThrow(Exception('Network Error'));
        return recipeBloc;
      },
      act: (bloc) => bloc.add(FetchRecipesEvent()),
      expect: () => [
        isA<RecipeLoading>(),
        isA<RecipeError>().having(
          (s) => s.message,
          'message',
          'Exception: Network Error',
        ),
      ],
    );

    blocTest<RecipeBloc, RecipeState>(
      'emits updated RecipeLoaded with filtered list when SearchRecipesEvent is added',
      build: () {
        when(
          () => mockRecipeService.getRecepie(),
        ).thenAnswer((_) async => tRecipeModel);
        return recipeBloc;
      },
      act: (bloc) async {
        bloc.add(FetchRecipesEvent()); // First get data
        bloc.add(SearchRecipesEvent('non-existent'));
      },
      skip: 2, // Skip Initial -> Loading -> Loaded
      expect: () => [
        isA<RecipeLoaded>().having(
          (s) => s.filteredRecipes,
          'filtered',
          isEmpty,
        ),
      ],
    );

    blocTest<RecipeBloc, RecipeState>(
      'emits RecipeLoaded with updated favorites when ToggleFavoriteEvent is added',
      build: () {
        when(
          () => mockRecipeService.getRecepie(),
        ).thenAnswer((_) async => tRecipeModel);
        return recipeBloc;
      },
      act: (bloc) async {
        bloc.add(FetchRecipesEvent());
        bloc.add(ToggleFavoriteEvent(1));
      },
      skip: 2,
      expect: () => [
        isA<RecipeLoaded>().having(
          (s) => s.favorites.contains(1),
          'contains id 1',
          true,
        ),
      ],
    );
  });
}
