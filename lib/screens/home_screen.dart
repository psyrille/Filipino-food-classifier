import 'package:filipino_food_scanner/screens/login_screen.dart';
import 'package:filipino_food_scanner/screens/profile.dart';
import 'package:filipino_food_scanner/services/auth_service.dart';
import 'package:filipino_food_scanner/utils/allergen_database.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:io';
import 'result_screen.dart';
import '../services/ml_service.dart';
import 'package:provider/provider.dart';
import '../utils/food_database.dart';
import '../models/food_model.dart';
import 'package:geolocator/geolocator.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Position? _currentPosition;
  bool? isInBoundingBox;
  String? latitude;
  String? longitude;

  List<Map<String, dynamic>>? asfBoundingBox;
  List<Map<String, dynamic>>? redTideBoundingBox;

  final ImagePicker _picker = ImagePicker();
  bool _isProcessing = false;
  final SupabaseClient _supabase = Supabase.instance.client;

  // For Search
  late List<FoodModel> _filteredFoods;
  final _searchController = TextEditingController();

  final supabase = Supabase.instance.client;
  Session? get session => supabase.auth.currentSession;

  bool _isAsfArea = false;
  bool _isRedTideArea = false;

  @override
  void initState() {
    super.initState();
    getAsfAndRedTideLocation();
    // Load ML model on startup
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<MLService>().loadModel();
    });

    // Initialize food list
    _filteredFoods = FoodDatabase.getAllFoods();

    // Listen to search input
    _searchController.addListener(_filterFoods);
  }

  //Get supabase data asf and redtide
  Future<void> getAsfAndRedTideLocation() async {
    final asf = await _supabase.from('asf').select('''
      bounding_box
    ''');

    final redTide = await _supabase.from('redTide').select('''
      bounding_box
    ''');

    setState(() {
      asfBoundingBox = asf;
      redTideBoundingBox = redTide;
    });

    _getCurrentLocation();
  }

  bool isWithinBoundingBox({
    required List<String> boundingBox,
    required double latitude,
    required double longitude,
  }) {
    // Parse bounding box: [minLat, maxLat, minLng, maxLng]
    final double minLat = double.parse(boundingBox[0]);
    final double maxLat = double.parse(boundingBox[1]);
    final double minLng = double.parse(boundingBox[2]);
    final double maxLng = double.parse(boundingBox[3]);

    return latitude >= minLat &&
        latitude <= maxLat &&
        longitude >= minLng &&
        longitude <= maxLng;
  }

  Future<void> _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      await Geolocator.openLocationSettings();
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return;
    }

    try {
      final Position pos = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);

      setState(() {
        _currentPosition = pos;
      });

      _checkBoundingBoxMatch(pos.latitude, pos.longitude);
    } catch (e) {
      debugPrint('Error getting location: $e');
    }
  }

  void _checkBoundingBoxMatch(double lat, double lng) {
    bool underAsf = false;
    bool underRedTide = false;

    if (asfBoundingBox != null) {
      for (var item in asfBoundingBox!) {
        final box = item['bounding_box'];
        if (box != null) {
          List<String> parsedBox;

          if (box is String) {
            try {
              parsedBox = box
                  .replaceAll('[', '')
                  .replaceAll(']', '')
                  .split(',')
                  .map((e) => e.trim().replaceAll('"', ''))
                  .toList();
            } catch (_) {
              return;
            }
          } else if (box is List) {
            parsedBox = box.map((e) => e.toString()).toList();
          } else {
            return;
          }

          if (parsedBox.length == 4 &&
              isWithinBoundingBox(
                boundingBox: parsedBox,
                latitude: lat,
                longitude: lng,
              )) {
            underAsf = true;
            break;
          }
        }
      }
    }

    if (redTideBoundingBox != null) {
      for (var item in redTideBoundingBox!) {
        final box = item['bounding_box'];
        if (box != null) {
          List<String> parsedBox;

          if (box is String) {
            try {
              parsedBox = box
                  .replaceAll('[', '')
                  .replaceAll(']', '')
                  .split(',')
                  .map((e) => e.trim().replaceAll('"', ''))
                  .toList();
            } catch (_) {
              return;
            }
          } else if (box is List) {
            parsedBox = box.map((e) => e.toString()).toList();
          } else {
            return;
          }

          if (parsedBox.length == 4 &&
              isWithinBoundingBox(
                boundingBox: parsedBox,
                latitude: lat,
                longitude: lng,
              )) {
            underRedTide = true;
            break;
          }
        }
      }
    }

    setState(() {
      isInBoundingBox = underAsf || underRedTide;
      _isAsfArea = underAsf;
      _isRedTideArea = underRedTide;
    });
  }

  void _filterFoods() {
    final query = _searchController.text.toLowerCase().trim();
    final allFoods = FoodDatabase.getAllFoods();

    setState(() {
      if (query.isEmpty) {
        _filteredFoods = allFoods;
      } else {
        _filteredFoods = allFoods
            .where((food) => food.name.toLowerCase().contains(query))
            .toList();
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _showFoodModal(FoodModel food, List<String>? allergies) {
    List<String> foundAllergens = [];
    bool hasAllergen = false;

    if (allergies != null && allergies.isNotEmpty) {
      // Use the new allergen detection system
      final result = AllergenDatabase.checkIngredientsForAllergens(
        food.ingredients,
        allergies,
      );

      foundAllergens = result['foundAllergens'] ?? [];
      hasAllergen = foundAllergens.isNotEmpty;
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Dialog(
                      insetPadding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 40),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Container(
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                Color(0xFFFFF4E6),
                                Color(0xFFFFE8CC),
                                Color(0xFFFFDDB3),
                              ],
                            ),
                          ),
                          child: LayoutBuilder(
                            builder: (context, constraints) {
                              return ConstrainedBox(
                                constraints: BoxConstraints(
                                  maxHeight:
                                      MediaQuery.of(context).size.height * 0.8,
                                ),
                                child: Stack(
                                  children: [
                                    SingleChildScrollView(
                                      padding: const EdgeInsets.all(20),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          if (hasAllergen)
                                            Container(
                                              width: double.infinity,
                                              padding: const EdgeInsets.all(20),
                                              margin: const EdgeInsets.only(
                                                  bottom: 20),
                                              decoration: BoxDecoration(
                                                color: Colors.red.shade50,
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                                border: Border.all(
                                                    color: Colors.red,
                                                    width: 2),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Colors.red
                                                        .withOpacity(0.2),
                                                    blurRadius: 10,
                                                    offset: const Offset(0, 5),
                                                  ),
                                                ],
                                              ),
                                              child: Column(
                                                children: [
                                                  Row(
                                                    children: [
                                                      Container(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(12),
                                                        decoration:
                                                            const BoxDecoration(
                                                          color: Colors.red,
                                                          shape:
                                                              BoxShape.circle,
                                                        ),
                                                        child: const Icon(
                                                          Icons.warning_rounded,
                                                          color: Colors.white,
                                                          size: 30,
                                                        ),
                                                      ),
                                                      const SizedBox(width: 15),
                                                      const Expanded(
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Text(
                                                              '⚠️ ALLERGY WARNING!',
                                                              style: TextStyle(
                                                                fontSize: 20,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                color:
                                                                    Colors.red,
                                                              ),
                                                            ),
                                                            Text(
                                                              'This food contains allergens',
                                                              style: TextStyle(
                                                                fontSize: 14,
                                                                color:
                                                                    Colors.red,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  const SizedBox(height: 15),
                                                  Container(
                                                    width: double.infinity,
                                                    padding:
                                                        const EdgeInsets.all(
                                                            12),
                                                    decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                    ),
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        const Text(
                                                          'Detected Allergen Categories:',
                                                          style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: Colors.red,
                                                            fontSize: 16,
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                            height: 8),
                                                        Wrap(
                                                          spacing: 8,
                                                          runSpacing: 8,
                                                          children:
                                                              foundAllergens.map(
                                                                  (allergen) {
                                                            return Container(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .symmetric(
                                                                horizontal: 12,
                                                                vertical: 8,
                                                              ),
                                                              decoration:
                                                                  BoxDecoration(
                                                                color:
                                                                    Colors.red,
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            15),
                                                              ),
                                                              child: Row(
                                                                mainAxisSize:
                                                                    MainAxisSize
                                                                        .min,
                                                                children: [
                                                                  Text(
                                                                    AllergenDatabase
                                                                        .getAllergenIcon(
                                                                            allergen),
                                                                    style:
                                                                        const TextStyle(
                                                                      fontSize:
                                                                          16,
                                                                    ),
                                                                  ),
                                                                  const SizedBox(
                                                                      width: 6),
                                                                  Text(
                                                                    allergen,
                                                                    style:
                                                                        const TextStyle(
                                                                      color: Colors
                                                                          .white,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                    ),
                                                                  ),
                                                                  const SizedBox(
                                                                      width: 4),
                                                                  const Icon(
                                                                    Icons.close,
                                                                    color: Colors
                                                                        .white,
                                                                    size: 16,
                                                                  ),
                                                                ],
                                                              ),
                                                            );
                                                          }).toList(),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),

                                          // Image
                                          const SizedBox(height: 30),
                                          ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(15),
                                            child: Image.asset(
                                              food.imageUrl ??
                                                  'assets/images/food/no_image_food.png',
                                              height: 180,
                                              width: double.infinity,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                          const SizedBox(height: 20),
                                          Container(
                                            width: double.infinity,
                                            padding: const EdgeInsets.all(25),
                                            decoration: BoxDecoration(
                                              gradient: LinearGradient(
                                                colors: [
                                                  Colors.orange.shade600,
                                                  Colors.deepOrange.shade600,
                                                ],
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(25),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.orange
                                                      .withOpacity(0.3),
                                                  blurRadius: 20,
                                                  offset: const Offset(0, 10),
                                                ),
                                              ],
                                            ),
                                            child: Column(
                                              children: [
                                                Text(
                                                  food.name,
                                                  style: const TextStyle(
                                                    fontSize: 32,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                                const SizedBox(height: 7),
                                                Text(
                                                  food.description,
                                                  textAlign: TextAlign.center,
                                                  style: const TextStyle(
                                                    fontSize: 16,
                                                    color: Colors.white,
                                                    height: 1.5,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          const SizedBox(height: 20),
                                          Container(
                                            width: double.infinity,
                                            padding: const EdgeInsets.all(20),
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.black
                                                      .withOpacity(0.05),
                                                  blurRadius: 10,
                                                  offset: const Offset(0, 5),
                                                ),
                                              ],
                                            ),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                const Row(
                                                  children: [
                                                    Icon(Icons.list_alt,
                                                        color: Colors.orange),
                                                    SizedBox(width: 10),
                                                    Text(
                                                      'Ingredients',
                                                      style: TextStyle(
                                                        fontSize: 20,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color:
                                                            Color(0xFF2D1B00),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(height: 15),
                                                ...food.ingredients
                                                    .map((ingredient) {
                                                  // Check if this specific ingredient contains allergens
                                                  final ingredientAllergens =
                                                      allergies != null
                                                          ? AllergenDatabase
                                                              .detectAllergens(
                                                              ingredient,
                                                              allergies,
                                                            )
                                                          : <String>[];
                                                  final isAllergen =
                                                      ingredientAllergens
                                                          .isNotEmpty;

                                                  return Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            bottom: 8.0),
                                                    child: Row(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Container(
                                                          margin:
                                                              const EdgeInsets
                                                                  .only(
                                                                  top: 8,
                                                                  right: 12),
                                                          width: 8,
                                                          height: 8,
                                                          decoration:
                                                              BoxDecoration(
                                                            color: isAllergen
                                                                ? Colors.red
                                                                : Colors.orange,
                                                            shape:
                                                                BoxShape.circle,
                                                          ),
                                                        ),
                                                        Expanded(
                                                          child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Text(
                                                                ingredient,
                                                                style:
                                                                    TextStyle(
                                                                  fontSize: 16,
                                                                  color: isAllergen
                                                                      ? Colors
                                                                          .red
                                                                      : const Color(
                                                                          0xFF2D1B00),
                                                                  fontWeight: isAllergen
                                                                      ? FontWeight
                                                                          .bold
                                                                      : FontWeight
                                                                          .normal,
                                                                  height: 1.5,
                                                                ),
                                                              ),
                                                              if (isAllergen)
                                                                Padding(
                                                                  padding:
                                                                      const EdgeInsets
                                                                          .only(
                                                                          top:
                                                                              4),
                                                                  child: Wrap(
                                                                    spacing: 4,
                                                                    children:
                                                                        ingredientAllergens
                                                                            .map((cat) {
                                                                      return Container(
                                                                        padding:
                                                                            const EdgeInsets.symmetric(
                                                                          horizontal:
                                                                              6,
                                                                          vertical:
                                                                              2,
                                                                        ),
                                                                        decoration:
                                                                            BoxDecoration(
                                                                          color: Colors
                                                                              .red
                                                                              .shade100,
                                                                          borderRadius:
                                                                              BorderRadius.circular(8),
                                                                        ),
                                                                        child:
                                                                            Text(
                                                                          '${AllergenDatabase.getAllergenIcon(cat)} $cat',
                                                                          style:
                                                                              const TextStyle(
                                                                            fontSize:
                                                                                11,
                                                                            color:
                                                                                Colors.red,
                                                                            fontWeight:
                                                                                FontWeight.w600,
                                                                          ),
                                                                        ),
                                                                      );
                                                                    }).toList(),
                                                                  ),
                                                                ),
                                                            ],
                                                          ),
                                                        ),
                                                        if (isAllergen)
                                                          const Icon(
                                                            Icons
                                                                .warning_rounded,
                                                            color: Colors.red,
                                                            size: 20,
                                                          ),
                                                      ],
                                                    ),
                                                  );
                                                }).toList(),
                                              ],
                                            ),
                                          ),
                                          const SizedBox(height: 20),
                                        ],
                                      ),
                                    ),
                                    Positioned(
                                      right: 0,
                                      child: IconButton(
                                        icon: const Icon(Icons.close,
                                            color: Colors.grey),
                                        onPressed: () => Navigator.pop(context),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? image = await _picker.pickImage(
        source: source,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );

      if (image != null) {
        setState(() => _isProcessing = true);

        final mlService = context.read<MLService>();

        final result = await mlService.predictFood(File(image.path));

        setState(() => _isProcessing = false);

        if (result != null && mounted) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ResultScreen(
                result: result,
                imageFile: File(image.path),
              ),
            ),
          );
        }
      }
    } catch (e) {
      setState(() => _isProcessing = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final foods = _filteredFoods;
    final authService = context.watch<AuthService>();
    final user = authService.currentUser;

    final userName =
        user != null ? 'Hi, ${user.firstName}!' : 'Food classifier';

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 18),
            child: ClipOval(
              child: Container(
                width: 36,
                height: 36,
                color: Colors.white,
                child: IconButton(
                  padding: EdgeInsets.zero,
                  icon: const Icon(
                    Icons.person,
                    color: Colors.orange,
                    size: 20,
                  ),
                  onPressed: () {
                    if (mounted) {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                            builder: (_) => const ProfileScreen()),
                      );
                    }
                  },
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 16), // extra right padding
            child: ClipOval(
              child: Container(
                width: 36,
                height: 36,
                color: Colors.white,
                child: IconButton(
                  padding: EdgeInsets.zero,
                  icon: const Icon(
                    Icons.logout,
                    color: Colors.orange,
                    size: 20,
                  ),
                  onPressed: () {
                    if (mounted) {
                      final authService = AuthService();
                      authService.logout(context);
                    }
                  },
                ),
              ),
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          // Background image
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/bg/7.jpg'),
                opacity: 0.35,
                fit: BoxFit.cover,
              ),
            ),
          ),

          // Foreground content
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.only(top: kToolbarHeight + 20),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        ClipOval(
                          child: Image.asset(
                            'assets/images/logos/main.png',
                            width: 90,
                            height: 90,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(width: 15),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'BantayAllerji',
                                style: TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF2D1B00),
                                ),
                              ),
                              Text(
                                userName,
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.orange,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 30),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(30),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.orange.shade600,
                            Colors.deepOrange.shade600,
                          ],
                        ),
                        borderRadius: BorderRadius.circular(25),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.orange.withOpacity(0.3),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          if (_isAsfArea || _isRedTideArea) ...[
                            if (_isAsfArea)
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(15),
                                margin: const EdgeInsets.only(bottom: 10),
                                decoration: BoxDecoration(
                                  color: Colors.red.shade50,
                                  borderRadius: BorderRadius.circular(12),
                                  border:
                                      Border.all(color: Colors.red, width: 1.5),
                                ),
                                child: Row(
                                  children: const [
                                    Icon(Icons.warning_rounded,
                                        color: Colors.red),
                                    SizedBox(width: 10),
                                    Expanded(
                                      child: Text(
                                        'Your location is currently under ASF',
                                        style: TextStyle(
                                          color: Colors.red,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            if (_isRedTideArea)
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(15),
                                margin: const EdgeInsets.only(bottom: 10),
                                decoration: BoxDecoration(
                                  color: Colors.red.shade50,
                                  borderRadius: BorderRadius.circular(12),
                                  border:
                                      Border.all(color: Colors.red, width: 1.5),
                                ),
                                child: Row(
                                  children: const [
                                    Icon(Icons.warning_rounded,
                                        color: Colors.red),
                                    SizedBox(width: 10),
                                    Expanded(
                                      child: Text(
                                        'Your location is currently under Red Tide',
                                        style: TextStyle(
                                          color: Colors.red,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                          ],
                          const Icon(
                            Icons.camera_alt_rounded,
                            size: 80,
                            color: Colors.white,
                          ),
                          const SizedBox(height: 20),
                          const Text(
                            'Scan Filipino Food',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 10),
                          const Text(
                            'Take a photo or upload an image',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.white70,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 30),
                          Row(
                            children: [
                              Expanded(
                                child: ElevatedButton.icon(
                                  onPressed: _isProcessing
                                      ? null
                                      : () => _pickImage(ImageSource.camera),
                                  icon: const Icon(Icons.camera),
                                  label: const Text('Camera'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.white,
                                    foregroundColor: Colors.orange,
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 15),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 15),
                              Expanded(
                                child: ElevatedButton.icon(
                                  onPressed: _isProcessing
                                      ? null
                                      : () => _pickImage(ImageSource.gallery),
                                  icon: const Icon(Icons.photo_library),
                                  label: const Text('Gallery'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.white,
                                    foregroundColor: Colors.orange,
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 15),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 30),
                    const Text(
                      'Supported Filipino Foods',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2D1B00),
                      ),
                    ),
                    const SizedBox(height: 15),
                    TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        prefixIcon:
                            const Icon(Icons.search, color: Colors.orange),
                        hintText: 'Search',
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 16, horizontal: 20),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),
                    if (foods.isEmpty)
                      const Center(
                        child: Text(
                          'Food not supported yet.',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey,
                          ),
                        ),
                      )
                    else
                      GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate:
                            const SliverGridDelegateWithMaxCrossAxisExtent(
                          maxCrossAxisExtent: 220,
                          crossAxisSpacing: 15,
                          mainAxisSpacing: 15,
                          childAspectRatio: 0.8,
                        ),
                        itemCount: foods.length,
                        itemBuilder: (context, index) {
                          final food = foods[index];
                          return GestureDetector(
                            onTap: () => _showFoodModal(food, user?.allergies),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.05),
                                    blurRadius: 10,
                                    offset: const Offset(0, 5),
                                  ),
                                ],
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.fromLTRB(
                                        15, 0, 15, 15),
                                    child: ClipRRect(
                                      borderRadius:
                                          BorderRadiusGeometry.circular(12),
                                      child: Image.asset(
                                        food.imageUrl ??
                                            'assets/images/food/no_food_image.png',
                                        width: 130,
                                        height: 90,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8),
                                    child: Column(
                                      children: [
                                        Text(
                                          food.name,
                                          style: const TextStyle(
                                            fontSize: 17,
                                            fontWeight: FontWeight.w900,
                                            color: Color(0xFF2D1B00),
                                          ),
                                          textAlign: TextAlign.center,
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        const SizedBox(height: 7),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                  ],
                ),
              ),
            ),
          ),

          if (_isProcessing)
            Container(
              color: Colors.black54,
              child: const Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                    SizedBox(height: 20),
                    Text(
                      'Analyzing food...',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
