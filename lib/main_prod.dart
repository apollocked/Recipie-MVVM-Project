import 'package:dio_receipe/global.dart';
import 'package:dio_receipe/my_app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env.prod");
  final global = Global(
    flavorName: dotenv.env['FLAVOR'] ?? "PRODUCTION",
    baseURL: dotenv.env['API_URL'] ?? "",
  );

  runApp(MyApp(global: global));
}
