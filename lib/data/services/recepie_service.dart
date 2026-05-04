import 'package:dio/dio.dart';
import 'package:dio_receipe/data/model/receipe_model.dart';

class RecepieService {
  final Dio dio;
  final String baseUrl; // Add this field

  // Update the constructor to require the baseUrl
  RecepieService({required this.baseUrl, Dio? dio}) : dio = dio ?? Dio();

  Future<ReceipeModel> getRecepie() async {
    try {
      // Use the injected baseUrl instead of reaching into dotenv directly
      Response apiResponse = await dio.get(baseUrl);

      return ReceipeModel.fromJson(apiResponse.data);
    } catch (e) {
      throw "The error is $e";
    }
  }
}
