import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';
import '../utils/allergen_database.dart';
import 'login_screen.dart';
import 'home_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _middleNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  // final _emailController = TextEditingController();
  final _contactController = TextEditingController();
  // final _passwordController = TextEditingController();
  // final _confirmPasswordController = TextEditingController();

  // bool _isPasswordVisible = false;
  // bool _isConfirmPasswordVisible = false;

  // Selected allergens using the 14 standard categories
  Set<String> _selectedAllergens = {};

  Future<void> _requestLocationPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
              "Location permission permanently denied. Please enable it in Settings."),
        ),
      );
      return;
    }

    bool isLocationEnabled = await Geolocator.isLocationServiceEnabled();

    if (!isLocationEnabled) {
      await Geolocator.openLocationSettings();
      return;
    }

    final position = await Geolocator.getCurrentPosition();
    print("Location granted: ${position.latitude}, ${position.longitude}");

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Location access enabled!"),
      ),
    );
  }

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return;

    var box = Hive.box('userBox');

    box.put('first_name', _firstNameController.text.trim());
    box.put('middle_name', _middleNameController.text.trim());
    box.put('last_name', _lastNameController.text.trim());
    box.put('allergies', _selectedAllergens.toList());

    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (_) => HomeScreen()));

    // final authService = context.read<AuthService>();

    // final error = await authService.register(
    //   context: context,
    //   email: _emailController.text.trim(),
    //   firstName: _firstNameController.text.trim(),
    //   middleName: _middleNameController.text.trim().isEmpty
    //       ? null
    //       : _middleNameController.text.trim(),
    //   lastName: _lastNameController.text.trim(),
    //   contactNo: _contactController.text.trim().isEmpty
    //       ? null
    //       : _contactController.text.trim(),
    //   allergies: _selectedAllergens.toList(), // Send selected categories
    // );

    // if (mounted) {
    //   if (error == null) {
    //     showDialog(
    //       context: context,
    //       builder: (BuildContext context) {
    //         return const AlertDialog(
    //           title: Text("Success"),
    //           content: Text("You have successfully registered!"),
    //         );
    //       },
    //     );
    //     Navigator.of(context).pushReplacement(
    //       MaterialPageRoute(builder: (_) => const HomeScreen()),
    //     );
    //   }
    // }
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _middleNameController.dispose();
    _lastNameController.dispose();
    // _emailController.dispose();
    _contactController.dispose();
    // _passwordController.dispose();
    // _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authService = context.watch<AuthService>();

    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/bg/2.jpg'),
                opacity: 0.25,
                fit: BoxFit.cover,
              ),
            ),
          ),
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 40),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Header
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ClipOval(
                            child: Image.asset(
                              'assets/images/logos/main.png',
                              width: 150,
                              height: 150,
                              fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(height: 15),
                          const Text(
                            'BantayAllerji',
                            style: TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF2D1B00),
                            ),
                          ),
                          const Text(
                            'Register',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w500,
                              color: Colors.orange,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 40),

                      // Personal Info Fields
                      _buildTextField(
                        controller: _firstNameController,
                        label: 'First Name',
                        icon: Icons.person,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your first name';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 15),
                      _buildTextField(
                        controller: _middleNameController,
                        label: 'Middle Name (Optional)',
                        icon: Icons.person_outline,
                      ),
                      const SizedBox(height: 15),
                      _buildTextField(
                        controller: _lastNameController,
                        label: 'Last Name',
                        icon: Icons.person_2_outlined,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your last name';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 15),
                      // _buildTextField(
                      //   controller: _emailController,
                      //   label: 'Email',
                      //   icon: Icons.email,
                      //   keyboardType: TextInputType.emailAddress,
                      //   validator: (value) {
                      //     if (value == null || value.isEmpty) {
                      //       return 'Please enter your email';
                      //     }
                      //     if (!value.contains('@')) {
                      //       return 'Please enter a valid email';
                      //     }
                      //     return null;
                      //   },
                      // ),
                      // const SizedBox(height: 15),
                      // _buildTextField(
                      //   controller: _contactController,
                      //   label: 'Contact Number (Optional)',
                      //   icon: Icons.phone,
                      //   keyboardType: TextInputType.phone,
                      // ),
                      // const SizedBox(height: 20),

                      // Password Fields
                      // _buildPasswordField(
                      //   controller: _passwordController,
                      //   label: 'Password',
                      //   isVisible: _isPasswordVisible,
                      //   onToggle: () => setState(
                      //       () => _isPasswordVisible = !_isPasswordVisible),
                      //   validator: (value) {
                      //     if (value == null || value.isEmpty) {
                      //       return 'Please enter a password';
                      //     }
                      //     if (value.length < 6) {
                      //       return 'Password must be at least 6 characters';
                      //     }
                      //     return null;
                      //   },
                      // ),
                      // const SizedBox(height: 15),
                      // _buildPasswordField(
                      //   controller: _confirmPasswordController,
                      //   label: 'Confirm Password',
                      //   isVisible: _isConfirmPasswordVisible,
                      //   onToggle: () => setState(() =>
                      //       _isConfirmPasswordVisible =
                      //           !_isConfirmPasswordVisible),
                      //   validator: (value) {
                      //     if (value == null || value.isEmpty) {
                      //       return 'Please confirm your password';
                      //     }
                      //     return null;
                      //   },
                      // ),

                      // const SizedBox(height: 25),

                      // Allergies Section with 14 Categories
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.7),
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(color: Colors.orange.shade200),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.warning_amber,
                                    color: Colors.orange),
                                const SizedBox(width: 10),
                                const Expanded(
                                  child: Text(
                                    'Select Your Food Allergies',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF2D1B00),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 5),
                            Text(
                              'Based on the 14 major allergens',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey.shade600,
                              ),
                            ),
                            const SizedBox(height: 15),

                            // Grid of allergen checkboxes
                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: AllergenDatabase.allergenCategories
                                  .map((allergen) {
                                final isSelected =
                                    _selectedAllergens.contains(allergen);

                                return InkWell(
                                  onTap: () {
                                    setState(() {
                                      if (isSelected) {
                                        _selectedAllergens.remove(allergen);
                                      } else {
                                        _selectedAllergens.add(allergen);
                                      }
                                    });
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 8,
                                    ),
                                    decoration: BoxDecoration(
                                      color: isSelected
                                          ? Colors.orange
                                          : Colors.white,
                                      borderRadius: BorderRadius.circular(20),
                                      border: Border.all(
                                        color: isSelected
                                            ? Colors.orange
                                            : Colors.grey.shade300,
                                        width: 2,
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          AllergenDatabase.getAllergenIcon(
                                              allergen),
                                          style: const TextStyle(fontSize: 16),
                                        ),
                                        const SizedBox(width: 6),
                                        Text(
                                          allergen,
                                          style: TextStyle(
                                            color: isSelected
                                                ? Colors.white
                                                : const Color(0xFF2D1B00),
                                            fontWeight: isSelected
                                                ? FontWeight.bold
                                                : FontWeight.normal,
                                          ),
                                        ),
                                        if (isSelected) ...[
                                          const SizedBox(width: 4),
                                          const Icon(
                                            Icons.check_circle,
                                            color: Colors.white,
                                            size: 16,
                                          ),
                                        ],
                                      ],
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),

                            if (_selectedAllergens.isNotEmpty) ...[
                              const SizedBox(height: 15),
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Colors.orange.shade50,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '${_selectedAllergens.length} allergen(s) selected',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.orange,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    ..._selectedAllergens.map((allergen) {
                                      return Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 4),
                                        child: Row(
                                          children: [
                                            Text(
                                              AllergenDatabase.getAllergenIcon(
                                                  allergen),
                                              style:
                                                  const TextStyle(fontSize: 14),
                                            ),
                                            const SizedBox(width: 8),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    allergen,
                                                    style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontSize: 13,
                                                    ),
                                                  ),
                                                  Text(
                                                    AllergenDatabase
                                                        .getAllergenDescription(
                                                            allergen),
                                                    style: TextStyle(
                                                      fontSize: 11,
                                                      color:
                                                          Colors.grey.shade600,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    }).toList(),
                                  ],
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Location Permission Container
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.7),
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(color: Colors.orange.shade200),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: const BoxDecoration(
                                    color: Colors.orange,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.info,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                const Expanded(
                                  child: Text(
                                    'For Red tide and ASF warnings, kindly turn-on your device location.',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF2D1B00),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                ElevatedButton.icon(
                                  onPressed: _requestLocationPermission,
                                  icon: const Icon(Icons.location_on,
                                      color: Colors.white),
                                  label: const Text(
                                    "Turn On Location",
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.orange,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20, vertical: 14),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 30),

                      // Register Button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: authService.isLoading ? null : _register,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange.shade600,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            elevation: 5,
                          ),
                          child: authService.isLoading
                              ? const CircularProgressIndicator(
                                  color: Colors.white)
                              : const Text(
                                  'Register',
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                        ),
                      ),

                      const SizedBox(height: 25),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      validator: validator,
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: Colors.orange),
        hintText: label,
        filled: true,
        fillColor: Colors.white,
        contentPadding:
            const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  // Widget _buildPasswordField({
  //   required TextEditingController controller,
  //   required String label,
  //   required bool isVisible,
  //   required VoidCallback onToggle,
  //   String? Function(String?)? validator,
  // }) {
  //   return TextFormField(
  //     controller: controller,
  //     obscureText: !isVisible,
  //     validator: validator,
  //     decoration: InputDecoration(
  //       prefixIcon: const Icon(Icons.lock, color: Colors.orange),
  //       suffixIcon: IconButton(
  //         icon: Icon(isVisible ? Icons.visibility : Icons.visibility_off,
  //             color: Colors.orange),
  //         onPressed: onToggle,
  //       ),
  //       hintText: label,
  //       filled: true,
  //       fillColor: Colors.white,
  //       contentPadding:
  //           const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
  //       border: OutlineInputBorder(
  //         borderRadius: BorderRadius.circular(15),
  //         borderSide: BorderSide.none,
  //       ),
  //     ),
  //   );
  // }
}
