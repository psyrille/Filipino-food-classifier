import '../models/food_model.dart';

class FoodDatabase {
  static final Map<String, FoodModel> foods = {
    'adobong_atay': FoodModel(
      id: 'adobong_atay',
      name: 'Adobong Atay',
      ingredients: [
        'Chicken Liver',
        'Soy Sauce',
        'Vinegar',
        'Garlic',
        'Bay Leaf',
        'Pepper'
      ],
    ),
    'adobong_manok': FoodModel(
      id: 'adobong_manok',
      name: 'Adobong Manok',
      ingredients: [
        'Chicken',
        'Soy Sauce',
        'Vinegar',
        'Garlic',
        'Bay Leaf',
        'Pepper'
      ],
    ),
    'adobong_pusit': FoodModel(
      id: 'adobong_pusit',
      name: 'Adobong Pusit',
      ingredients: [
        'Squid',
        'Soy Sauce',
        'Vinegar',
        'Garlic',
        'Onion',
        'Squid Ink'
      ],
    ),
    'adobong_sitaw': FoodModel(
      id: 'adobong_sitaw',
      name: 'Adobong Sitaw',
      ingredients: ['String Beans', 'Soy Sauce', 'Vinegar', 'Garlic'],
    ),
    'ampalaya_with_egg': FoodModel(
      id: 'ampalaya_with_egg',
      name: 'Ampalaya with Egg',
      ingredients: ['Bitter Melon', 'Eggs', 'Onion', 'Garlic', 'Oil'],
    ),
    'arroz_caldo': FoodModel(
      id: 'arroz_caldo',
      name: 'Arroz Caldo',
      ingredients: [
        'Rice',
        'Chicken',
        'Ginger',
        'Garlic',
        'Onion',
        'Fish Sauce'
      ],
    ),
    'atay_na_barbecue': FoodModel(
      id: 'atay_na_barbecue',
      name: 'Atay na Barbecue',
      ingredients: [
        'Chicken Liver',
        'Soy Sauce',
        'Banana Ketchup',
        'Sugar',
        'Garlic'
      ],
    ),
    'atsara': FoodModel(
      id: 'atsara',
      name: 'Atsara (Pickled Papaya)',
      ingredients: [
        'Green Papaya',
        'Vinegar',
        'Sugar',
        'Carrots',
        'Bell Pepper',
        'Raisins'
      ],
    ),
    'baklava': FoodModel(
      id: 'baklava',
      name: 'Baklava',
      ingredients: [
        'Phyllo Dough',
        'Walnuts',
        'Butter',
        'Honey',
        'Sugar Syrup'
      ],
    ),
    'balot': FoodModel(
      id: 'balot',
      name: 'Balot',
      ingredients: ['Fertilized Duck Egg', 'Salt'],
    ),
    'banana_cue': FoodModel(
      id: 'banana_cue',
      name: 'Banana Cue',
      ingredients: ['Saba Banana', 'Brown Sugar', 'Cooking Oil'],
    ),
    'banana_nut_cake': FoodModel(
      id: 'banana_nut_cake',
      name: 'Banana Nut Cake',
      ingredients: ['Banana', 'Flour', 'Eggs', 'Sugar', 'Butter', 'Nuts'],
    ),
    'bangus_sisig': FoodModel(
      id: 'bangus_sisig',
      name: 'Bangus Sisig',
      ingredients: ['Milkfish', 'Onion', 'Calamansi', 'Chili', 'Mayonnaise'],
    ),
    'batikon': FoodModel(
      id: 'batikon',
      name: 'Batikon',
      ingredients: ['Rice Flour', 'Sugar', 'Coconut Milk'],
    ),
    'beef_chicken_shawarma': FoodModel(
      id: 'beef_chicken_shawarma',
      name: 'Beef and Chicken Shawarma',
      ingredients: ['Beef', 'Chicken', 'Pita Bread', 'Garlic Sauce', 'Spices'],
    ),
    'beef_bulalo': FoodModel(
      id: 'beef_bulalo',
      name: 'Beef Bulalo',
      ingredients: ['Beef Shank', 'Corn', 'Cabbage', 'Peppercorn', 'Onion'],
    ),
    'beef_kaldereta': FoodModel(
      id: 'beef_kaldereta',
      name: 'Beef Kaldereta',
      ingredients: [
        'Beef',
        'Tomato Sauce',
        'Potatoes',
        'Carrots',
        'Bell Pepper'
      ],
    ),
    'beef_tacos': FoodModel(
      id: 'beef_tacos',
      name: 'Beef Tacos',
      ingredients: ['Ground Beef', 'Tortilla', 'Lettuce', 'Cheese', 'Tomato'],
    ),
    'bibingka': FoodModel(
      id: 'bibingka',
      name: 'Bibingka',
      ingredients: ['Rice Flour', 'Coconut Milk', 'Egg', 'Sugar', 'Salted Egg'],
    ),
    'bicol_express_bagoong': FoodModel(
      id: 'bicol_express_bagoong',
      name: 'Bicol Express with Bagoong',
      ingredients: ['Pork', 'Coconut Milk', 'Chili', 'Shrimp Paste', 'Garlic'],
    ),
    'bicol_express_no_bagoong': FoodModel(
      id: 'bicol_express_no_bagoong',
      name: 'Bicol Express without Bagoong',
      ingredients: ['Pork', 'Coconut Milk', 'Chili', 'Garlic'],
    ),
    'biko': FoodModel(
      id: 'biko',
      name: 'Biko',
      ingredients: ['Glutinous Rice', 'Coconut Milk', 'Brown Sugar'],
    ),
    'buko_pie': FoodModel(
      id: 'buko_pie',
      name: 'Buko Pie',
      ingredients: ['Young Coconut', 'Flour', 'Butter', 'Sugar', 'Milk'],
    ),
    'cassava_cake': FoodModel(
      id: 'cassava_cake',
      name: 'Cassava Cake',
      ingredients: ['Grated Cassava', 'Coconut Milk', 'Condensed Milk', 'Egg'],
    ),
    'cay_cay': FoodModel(
      id: 'cay_cay',
      name: 'Cay-Cay',
      ingredients: ['Glutinous Rice', 'Sugar', 'Oil'],
    ),
    'champorado': FoodModel(
      id: 'champorado',
      name: 'Champorado',
      ingredients: ['Rice', 'Cocoa Powder', 'Sugar', 'Milk'],
    ),
    'chop_suey_with_egg': FoodModel(
      id: 'chop_suey_with_egg',
      name: 'Chop Suey with Egg',
      ingredients: ['Mixed Vegetables', 'Egg', 'Garlic', 'Soy Sauce'],
    ),
    'chicken_curry': FoodModel(
      id: 'chicken_curry',
      name: 'Chicken Curry',
      ingredients: [
        'Chicken',
        'Coconut Milk',
        'Curry Powder',
        'Potatoes',
        'Carrots'
      ],
    ),
    'chicken_feet_adobo': FoodModel(
      id: 'chicken_feet_adobo',
      name: 'Chicken Feet Adobo',
      ingredients: ['Chicken Feet', 'Soy Sauce', 'Vinegar', 'Garlic'],
    ),
    'chicken_halal_samosa': FoodModel(
      id: 'chicken_halal_samosa',
      name: 'Chicken Halal Samosa',
      ingredients: ['Chicken', 'Flour', 'Onion', 'Spices'],
    ),
    'chicken_pastil': FoodModel(
      id: 'chicken_pastil',
      name: 'Chicken Pastil',
      ingredients: ['Chicken', 'Rice', 'Soy Sauce', 'Garlic'],
    ),
    'chocolate_moron': FoodModel(
      id: 'chocolate_moron',
      name: 'Chocolate Moron',
      ingredients: ['Rice Flour', 'Cocoa Powder', 'Coconut Milk', 'Sugar'],
    ),
    'cuchinta': FoodModel(
      id: 'cuchinta',
      name: 'Cuchinta',
      ingredients: ['Rice Flour', 'Brown Sugar', 'Lye Water'],
    ),
    'betamax': FoodModel(
      id: 'betamax',
      name: 'Betamax',
      ingredients: ['Chicken Blood', 'Vinegar', 'Garlic'],
    ),
    'kwek_kwek': FoodModel(
      id: 'kwek_kwek',
      name: 'Kwek Kwek',
      ingredients: ['Quail Eggs', 'Flour', 'Annatto', 'Oil'],
    ),
    'escabitchi': FoodModel(
      id: 'escabitchi',
      name: 'Escabitchi',
      ingredients: ['Fish', 'Vinegar', 'Onion', 'Bell Pepper'],
    ),
    'fishball': FoodModel(
      id: 'fishball',
      name: 'Fishball',
      ingredients: ['Fish Paste', 'Flour', 'Garlic', 'Salt'],
    ),
    'ginataang_nangka': FoodModel(
      id: 'ginataang_nangka',
      name: 'Ginataang Nangka',
      ingredients: ['Young Jackfruit', 'Coconut Milk', 'Garlic', 'Shrimp'],
    ),
    'ginataang_tilapia': FoodModel(
      id: 'ginataang_tilapia',
      name: 'Ginataang Tilapia',
      ingredients: ['Tilapia', 'Coconut Milk', 'Ginger', 'Garlic'],
    ),
    'ginisang_ampalaya': FoodModel(
      id: 'ginisang_ampalaya',
      name: 'Ginisang Ampalaya',
      ingredients: ['Bitter Melon', 'Egg', 'Onion', 'Garlic'],
    ),
    'ginataang_hipon': FoodModel(
      id: 'ginataang_hipon',
      name: 'Ginataang Hipon',
      ingredients: ['Shrimp', 'Coconut Milk', 'Garlic', 'Chili'],
    ),
    'grilled_chicken_liver': FoodModel(
      id: 'grilled_chicken_liver',
      name: 'Grilled Chicken Liver',
      ingredients: ['Chicken Liver', 'Salt', 'Pepper'],
    ),
    'grilled_shrimp': FoodModel(
      id: 'grilled_shrimp',
      name: 'Grilled Shrimp',
      ingredients: ['Shrimp', 'Garlic', 'Butter'],
    ),
    'halang_halang': FoodModel(
      id: 'halang_halang',
      name: 'Halang-Halang',
      ingredients: ['Chicken', 'Coconut Milk', 'Chili', 'Ginger'],
    ),
    'halo_halo': FoodModel(
      id: 'halo_halo',
      name: 'Halo-Halo',
      ingredients: ['Shaved Ice', 'Milk', 'Sweet Beans', 'Fruits', 'Ice Cream'],
    ),
    'inulukan': FoodModel(
      id: 'inulukan',
      name: 'Inulukan',
      ingredients: ['Crab Meat', 'Coconut Milk', 'Garlic'],
    ),
    'isaw': FoodModel(
      id: 'isaw',
      name: 'Isaw',
      ingredients: ['Chicken Intestines', 'Vinegar', 'Garlic'],
    ),
    'kalamay': FoodModel(
      id: 'kalamay',
      name: 'Kalamay (Ube flavor)',
      ingredients: ['Glutinous Rice Flour', 'Coconut Milk', 'Sugar', 'Ube'],
    ),
    'kapampangan_bopis': FoodModel(
      id: 'kapampangan_bopis',
      name: 'Kapampangan Bopis',
      ingredients: ['Pork Lungs', 'Vinegar', 'Garlic', 'Chili'],
    ),
    'pork_kare_kare': FoodModel(
      id: 'pork_kare_kare',
      name: 'Pork Kare-Kare',
      ingredients: ['Pork', 'Peanut Sauce', 'Eggplant', 'String Beans'],
    ),
    'kikiam': FoodModel(
      id: 'kikiam',
      name: 'Kikiam',
      ingredients: ['Ground Pork', 'Flour Wrapper', 'Garlic'],
    ),
    'kinilaw_tuna_gata': FoodModel(
      id: 'kinilaw_tuna_gata',
      name: 'Kinilaw na Tuna sa Gata',
      ingredients: ['Fresh Tuna', 'Vinegar', 'Coconut Milk', 'Ginger'],
    ),
    'laing': FoodModel(
      id: 'laing',
      name: 'Laing Bicol Express',
      ingredients: ['Dried Taro Leaves', 'Coconut Milk', 'Chili', 'Pork'],
    ),
    'lasagna': FoodModel(
      id: 'lasagna',
      name: 'Lasagna',
      ingredients: ['Lasagna Noodles', 'Ground Beef', 'Tomato Sauce', 'Cheese'],
    ),
    'lokot_lokot': FoodModel(
      id: 'lokot_lokot',
      name: 'Lokot-Lokot',
      ingredients: ['Rice Flour', 'Sugar', 'Oil'],
    ),
    'maja_blanca': FoodModel(
      id: 'maja_blanca',
      name: 'Maja Blanca',
      ingredients: ['Coconut Milk', 'Cornstarch', 'Sugar', 'Corn'],
    ),
    'menudo': FoodModel(
      id: 'menudo',
      name: 'Menudo',
      ingredients: ['Pork', 'Tomato Sauce', 'Potatoes', 'Carrots'],
    ),
    'niliggid': FoodModel(
      id: 'niliggid',
      name: 'Niliggid',
      ingredients: ['Sticky Rice', 'Coconut Milk', 'Sugar'],
    ),
    'paklay': FoodModel(
      id: 'paklay',
      name: 'Paklay',
      ingredients: ['Goat Meat', 'Pineapple', 'Vinegar', 'Garlic'],
    ),
    'pancit_bihon': FoodModel(
      id: 'pancit_bihon',
      name: 'Pancit Bihon',
      ingredients: ['Rice Noodles', 'Chicken', 'Vegetables', 'Soy Sauce'],
    ),
    'pancit_malabon': FoodModel(
      id: 'pancit_malabon',
      name: 'Pancit Malabon',
      ingredients: ['Thick Rice Noodles', 'Shrimp', 'Squid', 'Egg'],
    ),
    'picalong': FoodModel(
      id: 'picalong',
      name: 'Picalong',
      ingredients: ['Sticky Rice', 'Coconut Milk', 'Sugar'],
    ),
    'pichi_pichi': FoodModel(
      id: 'pichi_pichi',
      name: 'Pichi-Pichi',
      ingredients: ['Cassava', 'Sugar', 'Lye Water', 'Coconut'],
    ),
    'pickled_coconut': FoodModel(
      id: 'pickled_coconut',
      name: 'Pickled Coconut',
      ingredients: ['Young Coconut', 'Vinegar', 'Sugar'],
    ),
    'pinakbet': FoodModel(
      id: 'pinakbet',
      name: 'Pinakbet',
      ingredients: ['Mixed Vegetables', 'Shrimp Paste', 'Pork'],
    ),
    'piyanggang_manok': FoodModel(
      id: 'piyanggang_manok',
      name: 'Piyanggang Manok',
      ingredients: ['Chicken', 'Burnt Coconut', 'Ginger', 'Turmeric'],
    ),
    'piyaya_piaya': FoodModel(
      id: 'piyaya_piaya',
      name: 'Piyaya-Piaya',
      ingredients: ['Flour', 'Sugar', 'Butter'],
    ),
    'pochero': FoodModel(
      id: 'pochero',
      name: 'Pochero',
      ingredients: ['Beef', 'Banana', 'Tomato Sauce', 'Potatoes'],
    ),
    'pork_dinuguan': FoodModel(
      id: 'pork_dinuguan',
      name: 'Pork Dinuguan',
      ingredients: ['Pork', 'Pork Blood', 'Vinegar', 'Garlic'],
    ),
    'pork_embutido': FoodModel(
      id: 'pork_embutido',
      name: 'Pork Embutido',
      ingredients: ['Ground Pork', 'Egg', 'Raisins', 'Carrots'],
    ),
    'pork_humba': FoodModel(
      id: 'pork_humba',
      name: 'Pork Humba',
      ingredients: ['Pork Belly', 'Soy Sauce', 'Brown Sugar', 'Banana Blossom'],
    ),
    'pork_sinigang': FoodModel(
      id: 'pork_sinigang',
      name: 'Pork Sinigang',
      ingredients: ['Pork', 'Tamarind', 'Tomato', 'Vegetables'],
    ),
    'pork_steak': FoodModel(
      id: 'pork_steak',
      name: 'Pork Steak',
      ingredients: ['Pork Chop', 'Soy Sauce', 'Calamansi', 'Onion'],
    ),
    'puto_bumbong': FoodModel(
      id: 'puto_bumbong',
      name: 'Puto Bumbong',
      ingredients: ['Purple Rice', 'Coconut', 'Sugar'],
    ),
    'puto_cheese': FoodModel(
      id: 'puto_cheese',
      name: 'Puto Cheese',
      ingredients: ['Rice Flour', 'Sugar', 'Cheese'],
    ),
    'rice_suman': FoodModel(
      id: 'rice_suman',
      name: 'Rice Suman',
      ingredients: ['Glutinous Rice', 'Coconut Milk', 'Salt'],
    ),
    'salad_crab': FoodModel(
      id: 'salad_crab',
      name: 'Salad Crab',
      ingredients: ['Crab Meat', 'Mayonnaise', 'Lettuce'],
    ),
    'salvaro': FoodModel(
      id: 'salvaro',
      name: 'Salvaro',
      ingredients: ['Rice Flour', 'Sugar', 'Coconut Milk'],
    ),
    'sambulawan': FoodModel(
      id: 'sambulawan',
      name: 'Sambulawan',
      ingredients: ['Dried Fish', 'Salt'],
    ),
    'sapin_sapin': FoodModel(
      id: 'sapin_sapin',
      name: 'Sapin-Sapin',
      ingredients: ['Rice Flour', 'Coconut Milk', 'Sugar', 'Ube'],
    ),
    'sea_urchin': FoodModel(
      id: 'sea_urchin',
      name: 'Sea Urchin',
      ingredients: ['Sea Urchin Roe'],
    ),
    'seaweed_salad': FoodModel(
      id: 'seaweed_salad',
      name: 'Seaweed Salad',
      ingredients: ['Seaweed', 'Vinegar', 'Onion'],
    ),
    'spaghetti': FoodModel(
      id: 'spaghetti',
      name: 'Spaghetti',
      ingredients: ['Pasta', 'Tomato Sauce', 'Ground Meat', 'Cheese'],
    ),
    'squid_roll': FoodModel(
      id: 'squid_roll',
      name: 'Squid Roll',
      ingredients: ['Squid', 'Flour', 'Egg', 'Oil'],
    ),
    'sundot_kulangot': FoodModel(
      id: 'sundot_kulangot',
      name: 'Sundot Kulangot',
      ingredients: ['Brown Sugar', 'Coconut Milk'],
    ),
    'sweet_sour_fillet': FoodModel(
      id: 'sweet_sour_fillet',
      name: 'Sweet and Sour Fillet',
      ingredients: ['Fish Fillet', 'Vinegar', 'Sugar', 'Bell Pepper'],
    ),
    'tinolang_bangus': FoodModel(
      id: 'tinolang_bangus',
      name: 'Tinolang Bangus',
      ingredients: ['Milkfish', 'Ginger', 'Papaya', 'Fish Sauce'],
    ),
    'tinolang_manok': FoodModel(
      id: 'tinolang_manok',
      name: 'Tinolang Manok',
      ingredients: ['Chicken', 'Ginger', 'Papaya', 'Fish Sauce'],
    ),
    'tortang_dilis': FoodModel(
      id: 'tortang_dilis',
      name: 'Tortang Dilis',
      ingredients: ['Anchovies', 'Egg', 'Oil'],
    ),
    'tortang_okra': FoodModel(
      id: 'tortang_okra',
      name: 'Tortang Okra',
      ingredients: ['Okra', 'Egg', 'Oil'],
    ),
    'tortilla_de_patatas': FoodModel(
      id: 'tortilla_de_patatas',
      name: 'Tortilla De Patatas',
      ingredients: ['Potatoes', 'Egg', 'Olive Oil'],
    ),
    'tuna_kilawin': FoodModel(
      id: 'tuna_kilawin',
      name: 'Tuna Kilawin',
      ingredients: ['Fresh Tuna', 'Vinegar', 'Onion', 'Ginger'],
    ),
    'non_food': FoodModel(
      id: 'non_food',
      name: 'Non Food',
      ingredients: [],
    ),
    'otap': FoodModel(
      id: 'otap',
      name: 'Otap',
      ingredients: ['Flour', 'Sugar', 'Butter'],
    ),
    'lechon_baboy': FoodModel(
      id: 'lechon_baboy',
      name: 'Letchon Baboy',
      ingredients: ['Whole Pig', 'Salt', 'Spices'],
    ),
    'taho': FoodModel(
      id: 'taho',
      name: 'Taho',
      ingredients: ['Silken Tofu', 'Arnibal', 'Sago Pearls'],
    ),
    'tortang_talong': FoodModel(
      id: 'tortang_talong',
      name: 'Tortang Talong',
      ingredients: ['Eggplant', 'Egg', 'Oil'],
    ),
    'pork_sisig': FoodModel(
      id: 'pork_sisig',
      name: 'Pork Sisig',
      ingredients: ['Pork', 'Onion', 'Calamansi', 'Chili'],
    ),
    'sinigang_na_hipon': FoodModel(
      id: 'sinigang_na_hipon',
      name: 'Sinigang na Hipon',
      ingredients: ['Shrimp', 'Tamarind', 'Vegetables'],
    ),
    'dried_mango': FoodModel(
      id: 'dried_mango',
      name: 'Dried Mango',
      ingredients: ['Mango', 'Sugar', 'Citric Acid', 'Sulfur Dioxide'],
    ),
    'dried_papaya': FoodModel(
      id: 'dried_papaya',
      name: 'Dried Papaya',
      ingredients: ['Papaya', 'Sugar', 'Citric Acid', 'Sulfur Dioxide'],
    ),
    'dried_pineapple': FoodModel(
      id: 'dried_pineapple',
      name: 'Dried Pineapple',
      ingredients: ['Pineapple', 'Sugar', 'Citric Acid', 'Sulfur Dioxide'],
    ),
    'dried_jackfruit': FoodModel(
      id: 'dried_jackfruit',
      name: 'Dried Jackfruit',
      ingredients: ['Jackfruit', 'Sugar', 'Citric Acid', 'Sulfur Dioxide'],
    ),
    'dried_coconut': FoodModel(
      id: 'dried_coconut',
      name: 'Dried Coconut',
      ingredients: ['Coconut', 'Sugar', 'Citric Acid', 'Sulfur Dioxide'],
    ),
    'dried_banana': FoodModel(
      id: 'dried_banana',
      name: 'Dried Banana',
      ingredients: ['Banana', 'Sugar', 'Citric Acid', 'Sulfur Dioxide'],
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
