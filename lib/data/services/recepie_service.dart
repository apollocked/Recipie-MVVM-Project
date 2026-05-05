import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:dio_receipe/data/model/receipe_model.dart';

class RecepieService {
  final dio = Dio();
  final String baseURL;
  RecepieService({required this.baseURL});

  String get _baseUrl => baseURL;

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
