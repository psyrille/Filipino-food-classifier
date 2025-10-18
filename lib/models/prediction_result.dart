import 'food_model.dart';

class PredictionResult {
  final FoodModel food;
  final double confidence;
  final DateTime timestamp;

  PredictionResult({
    required this.food,
    required this.confidence,
    required this.timestamp,
  });

  bool get isConfident => confidence >= 0.6;
}
