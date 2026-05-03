import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:dio_receipe/data/model/receipe_model.dart';
import 'package:dio_receipe/data/services/recepie_service.dart'; // Adjust path if needed

class MockDio extends Mock implements Dio {}

void main() {
  late MockDio mockDio;
  late RecepieService recepieService;

  setUp(() async {
    // FIX: Initialize dotenv with an empty string to prevent NotInitializedError
    // We use loadForTest with empty strings so it doesn't look for a physical file
    await dotenv.load(
      mergeWith: {
        'API_URL': '', // Provide the empty fallback string directly
      },
    );

    mockDio = MockDio();
    recepieService = RecepieService(mockDio);
  });

  tearDown(() {
    dotenv.clean();
  });

  group('getRecepie', () {
    test('should return ReceipeModel when API call is successful', () async {
      // Arrange: Put the minimum required JSON
      final mockJsonData = <String, dynamic>{};
      // Mock the empty string URL that dotenv is now safely providing
      when(() => mockDio.get('')).thenAnswer(
        (_) async => Response(
          data: mockJsonData,
          statusCode: 200,
          requestOptions: RequestOptions(path: ''),
        ),
      );

      // Act
      final result = await recepieService.getRecepie();

      // Assert
      expect(result, isA<ReceipeModel>());
      verify(() => mockDio.get('')).called(1);
    });

    test('should throw error when DioException occurs', () async {
      // Arrange
      when(() => mockDio.get('')).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: ''),
          error: 'Network error',
        ),
      );

      // Act & Assert
      expect(() => recepieService.getRecepie(), throwsA(isA<String>()));
    });

    test('should throw error when any other exception occurs', () async {
      // Arrange
      when(() => mockDio.get('')).thenThrow(Exception('Unknown error'));

      // Act & Assert
      expect(() => recepieService.getRecepie(), throwsA(isA<String>()));
    });
  });
}
