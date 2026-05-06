import 'package:dio_receipe/core/routes/app_route_config.dart';
import 'package:dio_receipe/core/theme/app_theme.dart';
import 'package:dio_receipe/data/services/recepie_service.dart';
import 'package:dio_receipe/global.dart';
import 'package:dio_receipe/view_model/providers/theme_provider.dart';
import 'package:dio_receipe/view_model/receipe_bloc/recipe_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.global});

  final Global global;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        BlocProvider(
          // Using the baseURL from your Global configuration
          create: (context) =>
              RecipeBloc(RecepieService(baseURL: global.baseURL)),
        ),
        ChangeNotifierProvider(create: (context) => ThemeProvider()),
      ],
      // Use Consumer here to safely listen to the ThemeProvider
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp.router(
            title: 'Recipe App',
            routerConfig: MyAppRouter.returnRouter(global),
            debugShowCheckedModeBanner: global.flavorName == 'DEVELOPMENT',

            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            // Now this context is a child of MultiProvider, so it works!
            themeMode: themeProvider.themeMode,
          );
        },
      ),
    );
  }
}
