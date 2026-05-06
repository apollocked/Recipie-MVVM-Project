import 'package:dio_receipe/global.dart';
import 'package:dio_receipe/my_app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  await dotenv.load(fileName: ".env.dev");
  final global = Global(
    flavorName: dotenv.env['FLAVOR'] ?? "DEVELOPMENT",
    baseURL: dotenv.env['API_URL'] ?? "",
  );

  runApp(MyApp(global: global, prefs: prefs));
}
