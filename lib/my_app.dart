import 'package:dio_receipe/core/routes/app_route_config.dart';
import 'package:dio_receipe/core/theme/app_theme.dart';
import 'package:dio_receipe/data/services/recipe_service.dart';
import 'package:dio_receipe/data/repositories/recipe_repository.dart'; // Import this!
import 'package:dio_receipe/global.dart';
import 'package:dio_receipe/logic/providers/theme_provider.dart';
import 'package:dio_receipe/logic/receipe_bloc/recipe_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.global, required this.prefs});
  final SharedPreferences prefs;
  final Global global;

  @override
  build(BuildContext context) {
    return MultiProvider(
      providers: [
        BlocProvider(
          create: (context) {
            final service = RecepieService(baseURL: global.baseURL);
            final repository = RecipeRepository(service);

            return RecipeBloc(recipeRepository: repository, prefs: prefs);
          },
        ),
        ChangeNotifierProvider(create: (context) => ThemeProvider()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp.router(
            title: 'Recipe App',
            routerConfig: MyAppRouter.returnRouter(global),
            debugShowCheckedModeBanner: global.flavorName == 'DEVELOPMENT',
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: themeProvider.themeMode,
          );
        },
      ),
    );
  }
}
