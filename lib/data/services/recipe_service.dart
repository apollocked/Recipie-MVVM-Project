import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:dio_receipe/data/model/recipe_model.dart';

class RecepieService {
  final Dio _dio = Dio();
  final String baseURL;

  RecepieService({required this.baseURL});

  /// Fetches raw recipe data from the provided environment URL
  Future<ReceipeModel> getRecepie() async {
    try {
      // Uses the baseURL passed from main_dev.dart or main_prod.dart
      final response = await _dio.get(baseURL);

      if (response.statusCode == 200) {
        return ReceipeModel.fromJson(response.data);
      } else {
        throw Exception(
          "Failed to load recipes: Status ${response.statusCode}",
        );
      }
    } on DioException catch (e) {
      log("Dio Error: ${e.message}");
      throw "Network error: ${e.response?.data['message'] ?? e.message}";
    } catch (e) {
      log("Unexpected Error: $e");
      throw "An unexpected error occurred: $e";
    }
  }
}
