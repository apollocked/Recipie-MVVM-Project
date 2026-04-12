// ignore_for_file: unused_local_variable

import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class RecepieService {
  final dio = Dio();
  String get _baseUrl => dotenv.env['API_URL'] ?? "";
  Future<void> getRecepie() async {
    Response apiResponse = await dio.get(_baseUrl);
    log(apiResponse.data.toString());
  }
}
