import 'package:dio_receipe/global.dart';
import 'package:dio_receipe/my_app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<void> main() async {
  final global = Global(flavorName: "DEV");
  await dotenv.load(fileName: ".env");
  runApp(MyApp(global: global));
}
