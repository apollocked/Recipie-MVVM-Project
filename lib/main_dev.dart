import 'package:dio_receipe/global.dart';
import 'package:dio_receipe/my_app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<void> main() async {
  Global.baseURL = "https//receipe-app-dio/dev/";
  await dotenv.load(fileName: ".env");
  runApp(const MyApp());
}
