import 'package:dio_receipe/data/services/recepie_service.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    getReceipeData();
  }

  Future<void> getReceipeData() async {
    await RecepieService().getRecepie();
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
