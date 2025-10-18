import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:image/image.dart' as img;
import '../models/prediction_result.dart';
import '../models/food_model.dart';
import '../utils/food_database.dart';

class MLService extends ChangeNotifier {
  Interpreter? _interpreter;
  List<String> _labels = [];
  bool _isModelLoaded = false;

  bool get isModelLoaded => _isModelLoaded;
  List<String> get labels => _labels;

  // Load TFLite model and labels
  Future<void> loadModel() async {
    try {
      print('📦 Loading TFLite model...');

      // Load the model
      _interpreter = await Interpreter.fromAsset('assets/model/model.tflite');

      // Load labels
      final labelsData = await rootBundle.loadString('assets/labels.txt');
      _labels = labelsData
          .split('\n')
          .where((l) => l.trim().isNotEmpty)
          .map((l) => l.trim())
          .toList();

      _isModelLoaded = true;
      notifyListeners();

      print('✅ Model loaded successfully!');
      print('📊 Input shape: ${_interpreter!.getInputTensors()}');
      print('📊 Output shape: ${_interpreter!.getOutputTensors()}');
      print('🏷️  ${_labels.length} classes loaded');
    } catch (e) {
      print('❌ Error loading model: $e');
      print('⚠️  Make sure model.tflite is in assets/model/');

      // Load labels anyway
      try {
        final labelsData = await rootBundle.loadString('assets/labels.txt');
        _labels =
            labelsData.split('\n').where((l) => l.trim().isNotEmpty).toList();
      } catch (e2) {
        _labels = [
          'Adobong Manok',
          'Adobong Pusit',
          'Bangus Sisig',
          'Bibingka',
          'Chicken Curry',
          'Humba',
          'Kinilaw na Dilis',
          'Otap',
          'Pork Sisig',
          'Sinigang na Hipon',
          'Taho',
          'Halo Halo',
          'Biko',
          'Champorado',
          'Lechon Baboy',
          'Pork Dinuguan',
          'Calamay',
          'Ube Moron',
          'Tortang Talong',
          'Beef Bulalo',
          'Chopsuey w/ egg',
          'Pinakbet',
          'Chicken Kare-kare',
          'Palitaw'
        ];
      }

      _isModelLoaded = false;
      notifyListeners();
    }
  }

  // Main prediction method
  Future<PredictionResult?> predictFood(File imageFile) async {
    if (!_isModelLoaded || _interpreter == null) {
      await loadModel();
    }

    if (_interpreter == null) {
      print('⚠️  Model not loaded, using simulation');
      return await _simulatePrediction();
    }

    try {
      print('🔍 Analyzing image with TFLite...');

      // Read and decode image
      final bytes = await imageFile.readAsBytes();
      img.Image? image = img.decodeImage(bytes);

      if (image == null) {
        print('❌ Could not decode image');
        return null;
      }

      // Preprocess image
      final input = _preprocessImage(image);

      // Prepare output buffer
      var output =
          List.filled(_labels.length, 0.0).reshape([1, _labels.length]);

      // Run inference
      _interpreter!.run(input, output);

      // Get predictions
      final probabilities = output[0] as List<double>;

      // Find best prediction
      double maxProb = 0;
      int maxIndex = 0;

      for (int i = 0; i < probabilities.length; i++) {
        if (probabilities[i] > maxProb) {
          maxProb = probabilities[i];
          maxIndex = i;
        }

        // Print top 5 predictions
        if (probabilities[i] > 0.01) {
          print(
              '  [$i] ${_labels[i]}: ${(probabilities[i] * 100).toStringAsFixed(1)}%');
        }
      }

      if (maxIndex < _labels.length) {
        final predictedLabel = _labels[maxIndex];
        print(
            '🎯 PREDICTION: $predictedLabel (${(maxProb * 100).toStringAsFixed(1)}%)');

        FoodModel? food = _findFoodByLabel(predictedLabel);
        if (food == null) {
          food = _createFallbackFood(predictedLabel);
        }

        return PredictionResult(
          food: food,
          confidence: maxProb,
          timestamp: DateTime.now(),
        );
      }

      return null;
    } catch (e) {
      print('❌ Prediction error: $e');
      return await _simulatePrediction();
    }
  }

  // Preprocess image for model (224x224, normalized)
  List<List<List<List<double>>>> _preprocessImage(img.Image image) {
    // Resize to 224x224
    final resized = img.copyResize(image, width: 224, height: 224);

    // Convert to normalized float array [1, 224, 224, 3]
    List<List<List<double>>> imageMatrix = [];

    for (int y = 0; y < 224; y++) {
      List<List<double>> row = [];
      for (int x = 0; x < 224; x++) {
        final pixel = resized.getPixel(x, y);
        // Normalize to [0, 1]
        row.add([
          pixel.r / 255.0,
          pixel.g / 255.0,
          pixel.b / 255.0,
        ]);
      }
      imageMatrix.add(row);
    }

    return [imageMatrix];
  }

  // Simulate prediction (fallback)
  Future<PredictionResult> _simulatePrediction() async {
    await Future.delayed(const Duration(seconds: 2));

    String randomLabel = _labels[DateTime.now().millisecond % _labels.length];
    double randomConfidence = 0.75 + (DateTime.now().millisecond % 20) / 100;

    print(
        '🎲 SIMULATED: $randomLabel (${(randomConfidence * 100).toStringAsFixed(1)}%)');

    FoodModel? food = _findFoodByLabel(randomLabel);
    if (food == null) {
      food = _createFallbackFood(randomLabel);
    }

    return PredictionResult(
      food: food,
      confidence: randomConfidence,
      timestamp: DateTime.now(),
    );
  }

  // Find food in database
  FoodModel? _findFoodByLabel(String label) {
    final cleanLabel = label.trim().toLowerCase();

    // Try by ID
    final foodById = FoodDatabase.getFoodById(cleanLabel.replaceAll(' ', '_'));
    if (foodById != null) return foodById;

    // Try by name
    final foodByName = FoodDatabase.getFoodByName(label);
    if (foodByName != null) return foodByName;

    // Try partial match
    final allFoods = FoodDatabase.getAllFoods();
    for (var food in allFoods) {
      if (food.name.toLowerCase().contains(cleanLabel) ||
          cleanLabel.contains(food.name.toLowerCase())) {
        return food;
      }
    }

    return null;
  }

  // Create fallback food
  FoodModel _createFallbackFood(String label) {
    return FoodModel(
      id: label.toLowerCase().replaceAll(' ', '_'),
      name: label,
      description: 'A delicious Filipino dish recognized by our scanner.',
      ingredients: [
        'Traditional Filipino ingredients',
        'Fresh local vegetables',
        'Authentic spices and seasonings',
      ],
      nutritionalInfo: NutritionalInfo(
        calories: 300,
        protein: '20g',
        carbs: '35g',
        fat: '12g',
      ),
    );
  }

  @override
  void dispose() {
    _interpreter?.close();
    super.dispose();
  }
}
