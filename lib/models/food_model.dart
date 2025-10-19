class FoodModel {
  final String id;
  final String name;
  final String description;
  final List<String> ingredients;
  final NutritionalInfo? nutritionalInfo;
  final String? imageUrl;

  FoodModel({
    required this.id,
    required this.name,
    this.imageUrl,
    required this.description,
    required this.ingredients,
    this.nutritionalInfo,
  });

  factory FoodModel.fromJson(Map<String, dynamic> json) {
    return FoodModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      imageUrl: json['imageUrl'],
      description: json['description'] ?? '',
      ingredients: List<String>.from(json['ingredients'] ?? []),
      nutritionalInfo: json['nutritionalInfo'] != null
          ? NutritionalInfo.fromJson(json['nutritionalInfo'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'ingredients': ingredients,
      'nutritionalInfo': nutritionalInfo?.toJson(),
      'imageUrl': imageUrl,
    };
  }
}

class NutritionalInfo {
  final int calories;
  final String protein;
  final String carbs;
  final String fat;

  NutritionalInfo({
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fat,
  });

  factory NutritionalInfo.fromJson(Map<String, dynamic> json) {
    return NutritionalInfo(
      calories: json['calories'] ?? 0,
      protein: json['protein'] ?? '0g',
      carbs: json['carbs'] ?? '0g',
      fat: json['fat'] ?? '0g',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'calories': calories,
      'protein': protein,
      'carbs': carbs,
      'fat': fat,
    };
  }
}
