// // test_api.dart
// import 'package:filipino_food_scanner/services/api_service.dart';
// import 'dart:io';

// void main() async {
//   final apiService = ApiService();

//   // Test health check
//   print('Testing API health...');
//   bool isHealthy = await apiService.checkApiHealth();
//   print('API is ${isHealthy ? "healthy" : "not responding"}');

//   // Test get all foods
//   print('\nFetching all foods...');
//   final foods = await apiService.getAllFoods();
//   print('Found ${foods.length} foods');

//   // Test prediction (replace with actual image path)
//   // final imageFile = File('path/to/test/image.jpg');
//   // final result = await apiService.predictFood(imageFile);
//   // print('Prediction: ${result?.food.name}');
// }
