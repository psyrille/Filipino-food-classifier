class AllergenDatabase {
  // The 14 major food allergen categories
  static const List<String> allergenCategories = [
    'Molluscs',
    'Eggs',
    'Fish',
    'Lupin',
    'Soya',
    'Milk',
    'Peanuts',
    'Gluten',
    'Crustaceans',
    'Mustard',
    'Nuts',
    'Sesame',
    'Celery',
    'Sulphites',
  ];

  // Mapping of allergen categories to specific ingredients
  static final Map<String, List<String>> allergenMapping = {
    'Molluscs': [
      'molluscs',
      'mollusk',
      'snail',
      'snails',
      'whelk',
      'whelks',
      'squid',
      'pusit',
      'octopus',
      'oyster',
      'oysters',
      'clam',
      'clams',
      'mussel',
      'mussels',
      'scallop',
      'scallops',
      'abalone',
      'cuttlefish',
    ],
    'Eggs': [
      'egg',
      'eggs',
      'egg white',
      'egg yolk',
      'albumin',
      'mayonnaise',
      'meringue',
      'salted egg',
    ],
    'Fish': [
      'fish',
      'bangus',
      'milkfish',
      'tilapia',
      'tuna',
      'salmon',
      'dilis',
      'anchovies',
      'anchovy',
      'galunggong',
      'mackerel',
      'sardines',
      'fish sauce',
      'patis',
      'bagoong',
      'worcestershire sauce',
    ],
    'Lupin': [
      'lupin',
      'lupine',
      'lupin flour',
      'lupin bean',
    ],
    'Soya': [
      'soy',
      'soya',
      'soybean',
      'soy sauce',
      'tofu',
      'edamame',
      'miso',
      'tempeh',
      'soy milk',
    ],
    'Milk': [
      'milk',
      'dairy',
      'cream',
      'butter',
      'cheese',
      'yogurt',
      'whey',
      'lactose',
      'casein',
      'milk powder',
      'evaporated milk',
      'condensed milk',
      'leche flan',
    ],
    'Peanuts': [
      'peanut',
      'peanuts',
      'peanut butter',
      'groundnut',
      'mani',
    ],
    'Gluten': [
      'gluten',
      'wheat',
      'flour',
      'bread',
      'pasta',
      'noodles',
      'pancit',
      'barley',
      'rye',
      'oats',
      'rice flour',
      'glutinous rice',
    ],
    'Crustaceans': [
      'crab',
      'lobster',
      'prawn',
      'prawns',
      'shrimp',
      'hipon',
      'scampi',
      'crayfish',
      'langoustine',
      'alimango',
      'talangka',
    ],
    'Mustard': [
      'mustard',
      'mustard seed',
      'mustard powder',
      'dijon mustard',
    ],
    'Nuts': [
      'nut',
      'nuts',
      'almond',
      'almonds',
      'cashew',
      'cashews',
      'hazelnut',
      'hazelnuts',
      'walnut',
      'walnuts',
      'pecan',
      'pecans',
      'pistachio',
      'pistachios',
      'macadamia',
      'brazil nut',
      'pine nut',
    ],
    'Sesame': [
      'sesame',
      'sesame seed',
      'sesame seeds',
      'tahini',
      'lingga',
    ],
    'Celery': [
      'celery',
      'celeriac',
      'celery seed',
      'celery salt',
      'celery stalk',
      'celery leaves',
      'kinchay',
    ],
    'Sulphites': [
      'sulphites',
      'sulfites',
      'sulphur dioxide',
      'sulfur dioxide',
      'dried fruit',
      'raisins',
      'wine',
      'beer',
    ],
  };

  // Check if an ingredient contains any allergen
  static List<String> detectAllergens(
    String ingredient,
    List<String> userAllergens,
  ) {
    List<String> foundAllergens = [];
    String lowerIngredient = ingredient.toLowerCase().trim();

    for (String allergenCategory in userAllergens) {
      List<String>? specificAllergens = allergenMapping[allergenCategory];

      if (specificAllergens != null) {
        for (String specificAllergen in specificAllergens) {
          if (lowerIngredient.contains(specificAllergen.toLowerCase())) {
            if (!foundAllergens.contains(allergenCategory)) {
              foundAllergens.add(allergenCategory);
            }
            break; // Found match in this category, move to next category
          }
        }
      }
    }

    return foundAllergens;
  }

  // Check if a list of ingredients contains any user allergens
  static Map<String, List<String>> checkIngredientsForAllergens(
    List<String> ingredients,
    List<String> userAllergens,
  ) {
    Map<String, List<String>> result = {
      'foundAllergens': <String>[],
      'affectedIngredients': <String>[],
    };

    Set<String> foundAllergensSet = {};

    for (String ingredient in ingredients) {
      List<String> detected = detectAllergens(ingredient, userAllergens);

      if (detected.isNotEmpty) {
        foundAllergensSet.addAll(detected);
        result['affectedIngredients']!.add(ingredient);
      }
    }

    result['foundAllergens'] = foundAllergensSet.toList();

    return result;
  }

  // Get icon for allergen category (optional - for UI enhancement)
  static String getAllergenIcon(String category) {
    switch (category) {
      case 'Molluscs':
        return '🐚';
      case 'Eggs':
        return '🥚';
      case 'Fish':
        return '🐟';
      case 'Lupin':
        return '🫘';
      case 'Soya':
        return '🫘';
      case 'Milk':
        return '🥛';
      case 'Peanuts':
        return '🥜';
      case 'Gluten':
        return '🌾';
      case 'Crustaceans':
        return '🦞';
      case 'Mustard':
        return '🟡';
      case 'Nuts':
        return '🌰';
      case 'Sesame':
        return '⚪';
      case 'Celery':
        return '🥬';
      case 'Sulphites':
        return '🍇';
      default:
        return '⚠️';
    }
  }

  // Get description for allergen category
  static String getAllergenDescription(String category) {
    switch (category) {
      case 'Molluscs':
        return 'Including land snails, whelks and squid';
      case 'Eggs':
        return 'Can be found in cakes, sauces and pastries';
      case 'Fish':
        return 'Found in pizza, dressings and Worcestershire sauce';
      case 'Lupin':
        return 'Can be found in bread, pastries and pasta';
      case 'Soya':
        return 'Various beans including edamame and tofu';
      case 'Milk':
        return 'Butter, cheese, cream and milk powders contain milk';
      case 'Peanuts':
        return 'Can be found in cakes, biscuits and sauces';
      case 'Gluten':
        return 'In food made with flour such as pasta and bread';
      case 'Crustaceans':
        return 'Such as crab, lobster, prawns, shrimp and scampi';
      case 'Mustard':
        return 'Can be in liquid or powder form as well as seeds';
      case 'Nuts':
        return 'Including cashews, almonds and hazelnuts';
      case 'Sesame':
        return 'Found on burgers, bread sticks and salads';
      case 'Celery':
        return 'Including stalks, leaves, seeds and celeriac';
      case 'Sulphites':
        return 'Found in dried fruit like raisins and some drinks';
      default:
        return '';
    }
  }
}
