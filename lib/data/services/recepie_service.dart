// ignore_for_file: unused_local_variable

import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:dio_receipe/data/model/receipe_model.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class RecepieService {
  final Dio dio;

  RecepieService([Dio? dio]) : dio = dio ?? Dio();
  String get _baseUrl => dotenv.env['API_URL'] ?? "";
  Future<ReceipeModel> getRecepie() async {
    try {
      Response apiResponse = await dio.get(_baseUrl);

      return ReceipeModel.fromJson(apiResponse.data);
    } catch (e) {
      log(e.toString());
      throw "The error is $e";
    }
  }
}
