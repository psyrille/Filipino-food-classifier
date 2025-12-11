import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';
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
  final _emailController = TextEditingController();
  final _contactController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  Future<void> _requestLocationPermission() async {
    // Check permission
    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.deniedForever) {
      // User permanently denied permission
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
              "Location permission permanently denied. Please enable it in Settings."),
        ),
      );
      return;
    }

    // Check if location services (GPS) are enabled
    bool isLocationEnabled = await Geolocator.isLocationServiceEnabled();

    if (!isLocationEnabled) {
      await Geolocator.openLocationSettings();
      return;
    }

    // Everything OK → ask for current location (optional)
    final position = await Geolocator.getCurrentPosition();

    print("Location granted: ${position.latitude}, ${position.longitude}");

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Location access enabled!"),
      ),
    );
  }

  // List of allergy text fields
  final List<TextEditingController> _allergyControllers = [
    TextEditingController()
  ];

  void _addAllergyField() {
    setState(() {
      _allergyControllers.add(TextEditingController());
    });
  }

  void _removeAllergyField(int index) {
    setState(() {
      if (_allergyControllers.length > 1) {
        _allergyControllers[index].dispose();
        _allergyControllers.removeAt(index);
      }
    });
  }

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return;

    // Check password match
    if (_passwordController.text != _confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Passwords do not match'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Collect allergies from all text fields (filter out empty ones)
    final allergies = _allergyControllers
        .map((controller) => controller.text.trim())
        .where((text) => text.isNotEmpty)
        .toList();

    print('📋 Allergies to save: $allergies'); // Debug

    final authService = context.read<AuthService>();

    final error = await authService.register(
      context: context,
      email: _emailController.text.trim(),
      password: _passwordController.text,
      firstName: _firstNameController.text.trim(),
      middleName: _middleNameController.text.trim().isEmpty
          ? null
          : _middleNameController.text.trim(),
      lastName: _lastNameController.text.trim(),
      contactNo: _contactController.text.trim().isEmpty
          ? null
          : _contactController.text.trim(),
      allergies: allergies, // 🎯 ARRAY OF STRINGS
    );

    if (mounted) {
      if (error == null) {
        // Success - navigate to home
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return const AlertDialog(
              title: Text("Success"),
              content: Text("You have successfully registered!"),
            );
          },
        );
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const HomeScreen()),
        );
      }
    }
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _middleNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _contactController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    for (var controller in _allergyControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authService = context.watch<AuthService>();

    return Scaffold(
      body: Stack(
        children: [
          // Background gradient
          // Container(
          //   decoration: const BoxDecoration(
          //     gradient: LinearGradient(
          //       begin: Alignment.topLeft,
          //       end: Alignment.bottomRight,
          //       colors: [
          //         Color(0xFFFFF4E6),
          //         Color(0xFFFFE8CC),
          //         Color(0xFFFFDDB3),
          //       ],
          //     ),
          //   ),
          // ),
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

                      // --- Personal Info Fields ---
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
                      _buildTextField(
                        controller: _emailController,
                        label: 'Email',
                        icon: Icons.email,
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your email';
                          }
                          if (!value.contains('@')) {
                            return 'Please enter a valid email';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 15),
                      _buildTextField(
                        controller: _contactController,
                        label: 'Contact Number (Optional)',
                        icon: Icons.phone,
                        keyboardType: TextInputType.phone,
                      ),
                      const SizedBox(height: 20),

                      // --- Password Fields ---
                      _buildPasswordField(
                        controller: _passwordController,
                        label: 'Password',
                        isVisible: _isPasswordVisible,
                        onToggle: () => setState(
                            () => _isPasswordVisible = !_isPasswordVisible),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a password';
                          }
                          if (value.length < 6) {
                            return 'Password must be at least 6 characters';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 15),
                      _buildPasswordField(
                        controller: _confirmPasswordController,
                        label: 'Confirm Password',
                        isVisible: _isConfirmPasswordVisible,
                        onToggle: () => setState(() =>
                            _isConfirmPasswordVisible =
                                !_isConfirmPasswordVisible),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please confirm your password';
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 25),

                      // --- Allergies Section ---
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.7),
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(color: Colors.orange.shade200),
                        ),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'What are your allergies?',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF2D1B00),
                                  ),
                                ),
                                IconButton(
                                  onPressed: _addAllergyField,
                                  icon: const Icon(Icons.add_circle,
                                      color: Colors.orange, size: 30),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),

                            // Dynamic allergy inputs
                            Column(
                              children: List.generate(
                                  _allergyControllers.length, (index) {
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 10),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: TextField(
                                          controller:
                                              _allergyControllers[index],
                                          decoration: InputDecoration(
                                            hintText:
                                                'e.g., Peanuts, Shrimp, Squid',
                                            prefixIcon: const Icon(
                                                Icons.warning_amber,
                                                color: Colors.orange),
                                            filled: true,
                                            fillColor: Colors.white,
                                            contentPadding:
                                                const EdgeInsets.symmetric(
                                                    vertical: 16,
                                                    horizontal: 20),
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                              borderSide: BorderSide.none,
                                            ),
                                          ),
                                        ),
                                      ),
                                      if (_allergyControllers.length > 1)
                                        IconButton(
                                          onPressed: () =>
                                              _removeAllergyField(index),
                                          icon: const Icon(Icons.remove_circle,
                                              color: Colors.redAccent),
                                        ),
                                    ],
                                  ),
                                );
                              }),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 20),

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
                                // Circular info icon
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

                                // Expandable text
                                Expanded(
                                  child: Text(
                                    'For Red tide and ASF warnings, kindly turn-on your device location.',
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF2D1B00),
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 12),

                            // Turn On Location Button
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

                      // --- Register Button ---
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

                      // --- Login Link ---
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "Already have an account?",
                            style: TextStyle(
                              color: Color(0xFF2D1B00),
                              fontSize: 14,
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                    builder: (_) => const LoginScreen()),
                              );
                            },
                            child: const Text(
                              "Login",
                              style: TextStyle(
                                color: Colors.orange,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
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

  // 🔸 Reusable text field builder with validation
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

  // 🔸 Password field with visibility toggle and validation
  Widget _buildPasswordField({
    required TextEditingController controller,
    required String label,
    required bool isVisible,
    required VoidCallback onToggle,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: !isVisible,
      validator: validator,
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.lock, color: Colors.orange),
        suffixIcon: IconButton(
          icon: Icon(isVisible ? Icons.visibility : Icons.visibility_off,
              color: Colors.orange),
          onPressed: onToggle,
        ),
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
}
