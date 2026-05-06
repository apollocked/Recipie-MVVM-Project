import 'package:bloc_test/bloc_test.dart';
import 'package:dio_receipe/data/model/recipe_model.dart';
import 'package:dio_receipe/data/repositories/recipe_repository.dart'; //
import 'package:dio_receipe/logic/receipe_bloc/recipe_bloc.dart';
import 'package:dio_receipe/logic/receipe_bloc/recipe_event.dart';
import 'package:dio_receipe/logic/receipe_bloc/recipe_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockRecipeRepository extends Mock implements RecipeRepository {}

void main() {
  late RecipeBloc recipeBloc;
  late MockRecipeRepository mockRecipeRepository;

  setUp(() {
    mockRecipeRepository = MockRecipeRepository();
    // Update: Inject the mock repository
    recipeBloc = RecipeBloc(mockRecipeRepository);
  });

  tearDown(() {
    recipeBloc.close();
  });

  // Mock Data
  final tRecipes = [Recipes(id: 1, name: 'Pasta')];

  group('RecipeBloc Tests', () {
    test('initial state should be RecipeInitial', () {
      expect(recipeBloc.state, isA<RecipeInitial>());
    });

    blocTest<RecipeBloc, RecipeState>(
      'emits [RecipeLoading, RecipeLoaded] when FetchRecipesEvent is successful',
      build: () {
        // Update: Mock the repository method, which returns List<Recipes>
        when(
          () => mockRecipeRepository.getAllRecipes(),
        ).thenAnswer((_) async => tRecipes);
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
        // Update: Mocking the repository failure
        when(
          () => mockRecipeRepository.getAllRecipes(),
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
          () => mockRecipeRepository.getAllRecipes(),
        ).thenAnswer((_) async => tRecipes);
        return recipeBloc;
      },
      act: (bloc) async {
        bloc.add(FetchRecipesEvent());
        bloc.add(SearchRecipesEvent('non-existent'));
      },
      skip: 2,
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
          () => mockRecipeRepository.getAllRecipes(),
        ).thenAnswer((_) async => tRecipes);
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
