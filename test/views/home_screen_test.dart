// ignore_for_file: deprecated_member_use

import 'package:dio_receipe/data/model/receipe_model.dart';
import 'package:dio_receipe/view_model/receipe_bloc/recipe_bloc.dart';
import 'package:dio_receipe/view_model/receipe_bloc/recipe_event.dart';
import 'package:dio_receipe/view_model/receipe_bloc/recipe_state.dart';
import 'package:dio_receipe/views/Pages/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

// Mock class that extends Mock and implements RecipeBloc
class MockRecipeBloc extends Mock implements RecipeBloc {}

void main() {
  late MockRecipeBloc recipeBloc;

  setUp(() {
    recipeBloc = MockRecipeBloc();
  });

  Widget createWidgetUnderTest() {
    return BlocProvider<RecipeBloc>(
      create: (_) => recipeBloc,
      child: const MaterialApp(home: HomeScreen(flavorName: 'test')),
    );
  }

  group('HomeScreen Initial State', () {
    testWidgets('dispatches FetchRecipesEvent when state is RecipeInitial', (
      tester,
    ) async {
      // Arrange
      when(() => recipeBloc.state).thenReturn(RecipeInitial());
      when(
        () => recipeBloc.stream,
      ).thenAnswer((_) => Stream.value(RecipeInitial()));

      // Act
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump();

      // Assert
      verify(
        () => recipeBloc.add(any(that: isA<FetchRecipesEvent>())),
      ).called(1);
    });
  });

  group('HomeScreen Loading State', () {
    testWidgets('displays CircularProgressIndicator when loading', (
      tester,
    ) async {
      // Arrange
      when(() => recipeBloc.state).thenReturn(RecipeLoading());
      when(
        () => recipeBloc.stream,
      ).thenAnswer((_) => Stream.value(RecipeLoading()));

      // Act
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump();

      // Assert
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });
  });

  group('HomeScreen Error State', () {
    testWidgets('displays error message when state is RecipeError', (
      tester,
    ) async {
      // Arrange
      when(() => recipeBloc.state).thenReturn(RecipeError('Network Error'));
      when(
        () => recipeBloc.stream,
      ).thenAnswer((_) => Stream.value(RecipeError('Network Error')));

      // Act
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump();

      // Assert
      expect(find.text('Error: Network Error'), findsOneWidget);
    });
  });

  group('HomeScreen Loaded State', () {
    testWidgets('displays empty message when no recipes found', (tester) async {
      // Arrange
      final loadedState = RecipeLoaded(
        recipes: const [],
        filteredRecipes: const [],
        favorites: const {},
        searchQuery: '',
        isSearching: false,
        favoriteRecipes: [],
      );
      when(() => recipeBloc.state).thenReturn(loadedState);
      when(
        () => recipeBloc.stream,
      ).thenAnswer((_) => Stream.value(loadedState));

      // Act
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump();

      // Assert
      expect(find.text('No recipes found'), findsOneWidget);
    });

    testWidgets('displays recipe list when recipes are available', (
      tester,
    ) async {
      // Arrange
      final testRecipe = Recipes(
        id: 1,
        name: 'Pasta Carbonara',
        cuisine: 'Italian',
        difficulty: 'Medium',
        rating: 4.5,
        cookTimeMinutes: 30,
        caloriesPerServing: 450,
        image: 'https://example.com/pasta.jpg',
        ingredients: ['Pasta', 'Eggs', 'Bacon'],
        instructions: ['Boil pasta', 'Mix eggs', 'Combine'],
      );

      final loadedState = RecipeLoaded(
        recipes: [testRecipe],
        filteredRecipes: [testRecipe],
        favorites: const {},
        searchQuery: '',
        isSearching: false,
        favoriteRecipes: [],
      );
      when(() => recipeBloc.state).thenReturn(loadedState);
      when(
        () => recipeBloc.stream,
      ).thenAnswer((_) => Stream.value(loadedState));

      // Act
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump();

      // Assert
      expect(find.byType(ListView), findsOneWidget);
    });

    testWidgets('displays app bar with correct title', (tester) async {
      // Arrange
      final loadedState = RecipeLoaded(
        recipes: const [],
        filteredRecipes: const [],
        favorites: const {},
        searchQuery: '',
        isSearching: false,
        favoriteRecipes: [],
      );
      when(() => recipeBloc.state).thenReturn(loadedState);
      when(
        () => recipeBloc.stream,
      ).thenAnswer((_) => Stream.value(loadedState));

      // Act
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump();

      // Assert
      expect(find.text('RECIPES'), findsOneWidget);
    });
  });

  group('HomeScreen Refresh Indicator', () {
    testWidgets('triggers FetchRecipesEvent on pull to refresh', (
      tester,
    ) async {
      // Arrange
      final loadedState = RecipeLoaded(
        favoriteRecipes: [],
        recipes: const [],
        filteredRecipes: const [],
        favorites: const {},
        searchQuery: '',
        isSearching: false,
      );
      when(() => recipeBloc.state).thenReturn(loadedState);
      when(
        () => recipeBloc.stream,
      ).thenAnswer((_) => Stream.value(loadedState));

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump();

      // Act - Perform the pull to refresh
      await tester.drag(find.byType(RefreshIndicator), const Offset(0, 300));
      await tester.pump();

      // Assert
      verify(
        () => recipeBloc.add(any(that: isA<FetchRecipesEvent>())),
      ).called(1);
    });
  });

  group('HomeScreen Search Functionality', () {
    testWidgets('shows search icon when not searching', (tester) async {
      // Arrange
      final loadedState = RecipeLoaded(
        recipes: const [],
        filteredRecipes: const [],
        favorites: const {},
        searchQuery: '',
        isSearching: false,
        favoriteRecipes: [],
      );
      when(() => recipeBloc.state).thenReturn(loadedState);
      when(
        () => recipeBloc.stream,
      ).thenAnswer((_) => Stream.value(loadedState));

      // Act
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump();

      // Assert
      expect(find.byIcon(Icons.search), findsOneWidget);
    });

    testWidgets('shows search field when searching', (tester) async {
      // Arrange
      final searchingState = RecipeLoaded(
        recipes: const [],
        filteredRecipes: const [],
        favorites: const {},
        searchQuery: '',
        isSearching: true,
        favoriteRecipes: [],
      );
      when(() => recipeBloc.state).thenReturn(searchingState);
      when(
        () => recipeBloc.stream,
      ).thenAnswer((_) => Stream.value(searchingState));

      // Act
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump();

      // Assert
      expect(find.byType(TextField), findsOneWidget);
    });

    testWidgets('dispatches SearchRecipesEvent when text changes', (
      tester,
    ) async {
      // Arrange
      final searchingState = RecipeLoaded(
        recipes: const [],
        filteredRecipes: const [],
        favorites: const {},
        searchQuery: '',
        isSearching: true,
        favoriteRecipes: [],
      );
      when(() => recipeBloc.state).thenReturn(searchingState);
      when(
        () => recipeBloc.stream,
      ).thenAnswer((_) => Stream.value(searchingState));

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump();

      // Act - Type in the search field
      await tester.enterText(find.byType(TextField), 'pasta');
      await tester.pump();

      // Assert
      verify(
        () => recipeBloc.add(any(that: isA<SearchRecipesEvent>())),
      ).called(1);
    });
  });
}
