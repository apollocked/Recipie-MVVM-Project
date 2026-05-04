import 'package:dio_receipe/data/services/recepie_service.dart';
import 'package:dio_receipe/global.dart';
import 'package:dio_receipe/view_model/recipe_bloc.dart';
import 'package:dio_receipe/views/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.global});
  final Global global;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RecipeBloc(RecepieService(baseURL: global.baseURL)),
      child: MaterialApp(
        title: 'Recipe App',
        home: HomeScreen(flavorName: global.flavorName),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
