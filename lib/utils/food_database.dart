import '../models/food_model.dart';

class FoodDatabase {
  static final Map<String, FoodModel> foods = {
    'adobong_manok': FoodModel(
      id: 'adobong_bilat',
      name: 'Adobong Manok',
      imageUrl: 'assets/images/food/adobong_manok.jpg',
      description:
          'Filipino chicken adobo cooked in soy sauce, vinegar, and garlic',
      ingredients: [
        'Chicken',
        'Soy Sauce',
        'Vinegar',
        'Garlic',
        'Bay Leaves',
        'Black Pepper'
      ],
      nutritionalInfo: NutritionalInfo(
          calories: 350, protein: '28g', carbs: '12g', fat: '22g'),
    ),
    'adobong_pusit': FoodModel(
      id: 'adobong_pusit',
      name: 'Adobong Pusit',
      imageUrl: 'assets/images/food/adobong_pusit.jpg',
      description: 'Squid cooked adobo-style with its own ink',
      ingredients: [
        'Squid',
        'Soy Sauce',
        'Vinegar',
        'Garlic',
        'Onions',
        'Squid Ink'
      ],
      nutritionalInfo: NutritionalInfo(
          calories: 280, protein: '25g', carbs: '8g', fat: '15g'),
    ),
    'bangus_sisig': FoodModel(
      id: 'bangus_sisig',
      name: 'Bangus Sisig',
      imageUrl: 'assets/images/food/bangus_sisig.jpg',
      description: 'Sizzling milkfish dish with onions and chili peppers',
      ingredients: [
        'Milkfish (Bangus)',
        'Onions',
        'Chili Peppers',
        'Calamansi',
        'Soy Sauce',
        'Mayonnaise'
      ],
      nutritionalInfo: NutritionalInfo(
          calories: 380, protein: '30g', carbs: '10g', fat: '25g'),
    ),
    'bibingka': FoodModel(
      id: 'bibingka',
      name: 'Bibingka',
      imageUrl: 'assets/images/food/bibingka.jpg',
      description:
          'Traditional Filipino rice cake topped with salted egg and cheese',
      ingredients: [
        'Rice Flour',
        'Coconut Milk',
        'Eggs',
        'Sugar',
        'Salted Egg',
        'Cheese'
      ],
      nutritionalInfo: NutritionalInfo(
          calories: 250, protein: '8g', carbs: '35g', fat: '10g'),
    ),
    'chicken_curry': FoodModel(
      id: 'chicken_curry',
      name: 'Chicken Curry',
      imageUrl: 'assets/images/food/chicken_curry.jpg',
      description:
          'Filipino-style chicken curry with coconut milk and vegetables',
      ingredients: [
        'Chicken',
        'Curry Powder',
        'Coconut Milk',
        'Potatoes',
        'Carrots',
        'Bell Peppers'
      ],
      nutritionalInfo: NutritionalInfo(
          calories: 400, protein: '32g', carbs: '25g', fat: '20g'),
    ),
    'humba': FoodModel(
      id: 'humba',
      name: 'Humba',
      imageUrl: 'assets/images/food/humba.jpg',
      description: 'Braised pork belly in a sweet and savory sauce',
      ingredients: [
        'Pork Belly',
        'Soy Sauce',
        'Vinegar',
        'Brown Sugar',
        'Fermented Black Beans',
        'Bay Leaves'
      ],
      nutritionalInfo: NutritionalInfo(
          calories: 450, protein: '25g', carbs: '20g', fat: '32g'),
    ),
    'kinilaw_na_dilis': FoodModel(
      id: 'kinilaw_na_dilis',
      name: 'Kinilaw na Dilis',
      imageUrl: 'assets/images/food/kinilaw_na_dilis.jpg',
      description: 'Fresh anchovies ceviche with vinegar and spices',
      ingredients: [
        'Fresh Anchovies',
        'Vinegar',
        'Onions',
        'Ginger',
        'Chili Peppers',
        'Calamansi'
      ],
      nutritionalInfo: NutritionalInfo(
          calories: 180, protein: '22g', carbs: '5g', fat: '8g'),
    ),
    'otap': FoodModel(
      id: 'otap',
      name: 'Otap',
      imageUrl: 'assets/images/food/otap.jpg',
      description: 'Crispy oval-shaped puff pastry with sugar coating',
      ingredients: [
        'Flour',
        'Butter',
        'Sugar',
        'Salt',
        'Egg',
        'Shrimp',
        'Squid'
      ],
      nutritionalInfo: NutritionalInfo(
          calories: 200, protein: '3g', carbs: '28g', fat: '9g'),
    ),
    'pork_sisig': FoodModel(
      id: 'pork_sisig',
      name: 'Pork Sisig',
      imageUrl: 'assets/images/food/pork_sisig.jpg',
      description: 'Sizzling chopped pork with onions, perfect with rice',
      ingredients: [
        'Pork Face/Ears',
        'Liver',
        'Onions',
        'Chili',
        'Calamansi',
        'Egg',
        'Mayonnaise'
      ],
      nutritionalInfo: NutritionalInfo(
          calories: 420, protein: '24g', carbs: '8g', fat: '33g'),
    ),
    'sinigang_na_hipon': FoodModel(
      id: 'sinigang_na_hipon',
      name: 'Sinigang na Hipon',
      imageUrl: 'assets/images/food/sinigang_na_hipon.jpg',
      description: 'Sour shrimp soup with tamarind and vegetables',
      ingredients: [
        'Shrimp',
        'Tamarind',
        'Tomatoes',
        'Kangkong',
        'Radish',
        'String Beans',
        'Fish Sauce'
      ],
      nutritionalInfo: NutritionalInfo(
          calories: 220, protein: '25g', carbs: '15g', fat: '8g'),
    ),
    'taho': FoodModel(
      id: 'taho',
      name: 'Taho',
      imageUrl: 'assets/images/food/taho.jpg',
      description: 'Sweet tofu dessert with arnibal and sago pearls',
      ingredients: [
        'Silken Tofu',
        'Brown Sugar Syrup (Arnibal)',
        'Sago Pearls'
      ],
      nutritionalInfo: NutritionalInfo(
          calories: 180, protein: '8g', carbs: '30g', fat: '4g'),
    ),
    'halo_halo': FoodModel(
      id: 'halo_halo',
      name: 'Halo Halo',
      imageUrl: 'assets/images/food/halo_halo.jpg',
      description:
          'Popular Filipino dessert with shaved ice and mixed ingredients',
      ingredients: [
        'Shaved Ice',
        'Evaporated Milk',
        'Sweet Beans',
        'Nata de Coco',
        'Ube',
        'Leche Flan',
        'Ice Cream'
      ],
      nutritionalInfo: NutritionalInfo(
          calories: 320, protein: '6g', carbs: '58g', fat: '9g'),
    ),
    'biko': FoodModel(
      id: 'biko',
      name: 'Biko',
      imageUrl: 'assets/images/food/biko.jpg',
      description: 'Sweet sticky rice cake with coconut milk',
      ingredients: [
        'Glutinous Rice',
        'Coconut Milk',
        'Brown Sugar',
        'Coconut Cream (Latik)'
      ],
      nutritionalInfo: NutritionalInfo(
          calories: 280, protein: '4g', carbs: '52g', fat: '8g'),
    ),
    'champorado': FoodModel(
      id: 'champorado',
      name: 'Champorado',
      imageUrl: 'assets/images/food/champorado.jpg',
      description: 'Chocolate rice porridge, perfect for breakfast',
      ingredients: [
        'Glutinous Rice',
        'Cocoa Powder',
        'Sugar',
        'Evaporated Milk'
      ],
      nutritionalInfo: NutritionalInfo(
          calories: 290, protein: '6g', carbs: '54g', fat: '6g'),
    ),
    'lechon_baboy': FoodModel(
      id: 'lechon_baboy',
      name: 'Lechon Baboy',
      imageUrl: 'assets/images/food/lechon_baboy.jpg',
      description: 'Roasted whole pig, crispy skin and tender meat',
      ingredients: [
        'Whole Pig',
        'Lemongrass',
        'Garlic',
        'Onions',
        'Salt',
        'Pepper',
        'Bay Leaves'
      ],
      nutritionalInfo: NutritionalInfo(
          calories: 480, protein: '30g', carbs: '0g', fat: '38g'),
    ),
    'pork_dinuguan': FoodModel(
      id: 'pork_dinuguan',
      name: 'Pork Dinuguan',
      imageUrl: 'assets/images/food/pork_dinuguan.jpg',
      description: 'Savory pork blood stew with vinegar and spices',
      ingredients: [
        'Pork',
        'Pork Blood',
        'Vinegar',
        'Garlic',
        'Onions',
        'Chili Peppers',
        'Fish Sauce'
      ],
      nutritionalInfo: NutritionalInfo(
          calories: 340, protein: '28g', carbs: '12g', fat: '20g'),
    ),
    'calamay': FoodModel(
      id: 'calamay',
      name: 'Calamay',
      imageUrl: 'assets/images/food/calamay.jpg',
      description: 'Sticky sweet delicacy made from coconut milk and rice',
      ingredients: ['Glutinous Rice', 'Coconut Milk', 'Brown Sugar'],
      nutritionalInfo: NutritionalInfo(
          calories: 260, protein: '3g', carbs: '48g', fat: '7g'),
    ),
    'ube_moron': FoodModel(
      id: 'ube_moron',
      name: 'Ube Moron',
      imageUrl: 'assets/images/food/ube_moron.jpg',
      description: 'Purple yam rice cake wrapped in banana leaves',
      ingredients: [
        'Glutinous Rice',
        'Ube (Purple Yam)',
        'Coconut Milk',
        'Sugar',
        'Banana Leaves'
      ],
      nutritionalInfo: NutritionalInfo(
          calories: 270, protein: '4g', carbs: '50g', fat: '6g'),
    ),
    'tortang_talong': FoodModel(
      id: 'tortang_talong',
      name: 'Tortang Talong',
      imageUrl: 'assets/images/food/tortang_talong.jpg',
      description: 'Eggplant omelet, simple and delicious',
      ingredients: ['Eggplant', 'Eggs', 'Garlic', 'Onions', 'Salt', 'Pepper'],
      nutritionalInfo: NutritionalInfo(
          calories: 150, protein: '8g', carbs: '12g', fat: '8g'),
    ),
    'beef_bulalo': FoodModel(
      id: 'beef_bulalo',
      name: 'Beef Bulalo',
      imageUrl: 'assets/images/food/beef_bulalo.jpg',
      description: 'Hearty beef bone marrow soup with vegetables',
      ingredients: [
        'Beef Shanks',
        'Bone Marrow',
        'Corn',
        'Cabbage',
        'Bok Choy',
        'Onions',
        'Fish Sauce'
      ],
      nutritionalInfo: NutritionalInfo(
          calories: 380, protein: '32g', carbs: '15g', fat: '22g'),
    ),
    'chopsuey_w_egg': FoodModel(
      id: 'chopsuey_w_egg',
      name: 'Chopsuey w/ egg',
      imageUrl: 'assets/images/food/chopsuey_with_egg.jpg',
      description: 'Stir-fried mixed vegetables with meat and egg',
      ingredients: [
        'Cabbage',
        'Carrots',
        'Broccoli',
        'Cauliflower',
        'Pork',
        'Shrimp',
        'Egg',
        'Oyster Sauce'
      ],
      nutritionalInfo: NutritionalInfo(
          calories: 280, protein: '18g', carbs: '20g', fat: '14g'),
    ),
    'pinakbet': FoodModel(
      id: 'pinakbet',
      name: 'Pinakbet',
      imageUrl: 'assets/images/food/pinakbet.jpg',
      description: 'Mixed vegetables with shrimp paste',
      ingredients: [
        'Squash',
        'Eggplant',
        'Okra',
        'String Beans',
        'Bitter Gourd',
        'Tomatoes',
        'Shrimp Paste'
      ],
      nutritionalInfo: NutritionalInfo(
          calories: 180, protein: '8g', carbs: '25g', fat: '6g'),
    ),
    'chicken_kare_kare': FoodModel(
      id: 'chicken_kare_kare',
      name: 'Chicken Kare-kare',
      imageUrl: 'assets/images/food/chicken_kare_kare.jpg',
      description: 'Chicken in rich peanut sauce with vegetables',
      ingredients: [
        'Chicken',
        'Peanut Butter',
        'Ground Rice',
        'Eggplant',
        'String Beans',
        'Banana Heart',
        'Bagoong'
      ],
      nutritionalInfo: NutritionalInfo(
          calories: 420, protein: '30g', carbs: '22g', fat: '26g'),
    ),
    'palitaw': FoodModel(
      id: 'palitaw',
      name: 'Palitaw',
      imageUrl: 'assets/images/food/palitaw.jpg',
      description: 'Sweet rice cakes coated with coconut, sugar, and sesame',
      ingredients: [
        'Glutinous Rice Flour',
        'Water',
        'Grated Coconut',
        'Sugar',
        'Sesame Seeds'
      ],
      nutritionalInfo: NutritionalInfo(
          calories: 200, protein: '3g', carbs: '38g', fat: '5g'),
    ),
  };

  static FoodModel? getFoodById(String id) {
    return foods[id];
  }

  static List<FoodModel> getAllFoods() {
    return foods.values.toList();
  }

  static FoodModel? getFoodByName(String name) {
    final cleanName = name.toLowerCase().trim();
    for (var food in foods.values) {
      if (food.name.toLowerCase() == cleanName) {
        return food;
      }
    }
    return null;
  }
}
