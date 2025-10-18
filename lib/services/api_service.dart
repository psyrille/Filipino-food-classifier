import 'dart:io';
import 'package:dio/dio.dart';
import '../models/food_model.dart';
import '../models/prediction_result.dart';

class ApiService {
  static const String baseUrl =
      'https://teachablemachine.withgoogle.com/models/NxEmQ60XO/';
  late final Dio _dio;

  ApiService() {
    _dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        headers: {
          'Accept': 'application/json',
        },
      ),
    );

    // Add interceptor for logging (optional)
    _dio.interceptors.add(
      LogInterceptor(
        requestBody: true,
        responseBody: true,
        error: true,
      ),
    );
  }

  // Predict food from image
  Future<PredictionResult?> predictFood(File imageFile) async {
    try {
      FormData formData = FormData.fromMap({
        'image': await MultipartFile.fromFile(
          imageFile.path,
          filename: 'food.jpg',
        ),
      });

      final response = await _dio.post(
        '/predict',
        data: formData,
      );

      if (response.statusCode == 200 && response.data['success']) {
        final foodData = response.data['details'];

        final food = FoodModel(
          id: response.data['food'] ?? '',
          name: foodData['name'] ?? '',
          description: foodData['description'] ?? '',
          ingredients: List<String>.from(foodData['ingredients'] ?? []),
          nutritionalInfo: foodData['nutritionalInfo'] != null
              ? NutritionalInfo.fromJson(foodData['nutritionalInfo'])
              : null,
          imageUrl: foodData['imageUrl'],
        );

        return PredictionResult(
          food: food,
          confidence: (response.data['confidence'] ?? 0.0).toDouble(),
          timestamp: DateTime.now(),
        );
      }

      return null;
    } on DioException catch (e) {
      _handleDioError(e);
      return null;
    } catch (e) {
      print('Unexpected error: $e');
      return null;
    }
  }

  // Get all foods
  Future<List<FoodModel>> getAllFoods() async {
    try {
      final response = await _dio.get('/foods');

      if (response.statusCode == 200) {
        final List<dynamic> foodsJson = response.data['foods'] ?? [];
        return foodsJson.map((json) => FoodModel.fromJson(json)).toList();
      }

      return [];
    } on DioException catch (e) {
      _handleDioError(e);
      return [];
    }
  }

  // Get food by ID
  Future<FoodModel?> getFoodById(String foodId) async {
    try {
      final response = await _dio.get('/foods/$foodId');

      if (response.statusCode == 200) {
        return FoodModel.fromJson(response.data);
      }

      return null;
    } on DioException catch (e) {
      _handleDioError(e);
      return null;
    }
  }

  // Submit feedback
  Future<bool> submitFeedback({
    required String foodId,
    required bool isCorrect,
    String? actualFood,
    String? comments,
  }) async {
    try {
      final response = await _dio.post('/feedback', data: {
        'foodId': foodId,
        'isCorrect': isCorrect,
        'actualFood': actualFood,
        'comments': comments,
        'timestamp': DateTime.now().toIso8601String(),
      });

      return response.statusCode == 200;
    } catch (e) {
      print('Error submitting feedback: $e');
      return false;
    }
  }

  // Handle Dio errors
  void _handleDioError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        print('Connection timeout');
        break;
      case DioExceptionType.badResponse:
        print('Bad response: ${error.response?.statusCode}');
        break;
      case DioExceptionType.cancel:
        print('Request cancelled');
        break;
      case DioExceptionType.connectionError:
        print('No internet connection');
        break;
      default:
        print('Error: ${error.message}');
    }
  }
}
