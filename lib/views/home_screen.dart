// ignore_for_file: must_be_immutable, deprecated_member_use

import 'package:dio_receipe/core/utils/colors.dart';
import 'package:dio_receipe/data/model/receipe_model.dart';
import 'package:dio_receipe/view_model/recepies_provider.dart';
import 'package:dio_receipe/views/widgets/custom_recepie_list.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  ReceipeModel? receipeModel;

  final Set<int> _favorites = {};

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<RecipeProvider>();
    return Scaffold(
      backgroundColor: bgSlate,
      appBar: AppBar(
        toolbarHeight: 80,
        backgroundColor: brandAmber,
        elevation: 0,
        title: Text(
          "RECIPES",
          style: TextStyle(
            color: deepNavy,
            fontWeight: FontWeight.w900,
            letterSpacing: 2,
            fontSize: 20,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.search, color: deepNavy),
            onPressed: () {},
          ),
        ],
      ),
      body: provider.isLoading
          ? Center(child: CircularProgressIndicator(color: brandAmber))
          : provider.errorMessage != null
          ? Center(child: Text("Error: ${provider.errorMessage}"))
          : CustomReceipeList(
              receipeModel: receipeModel,
              favorites: _favorites,
            ),
    );
  }
}
