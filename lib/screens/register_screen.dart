import 'package:filipino_food_scanner/screens/login_screen.dart';
import 'package:flutter/material.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _firstNameController = TextEditingController();
  final _middleNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _contactController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

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
        _allergyControllers.removeAt(index);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background gradient
          Container(
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
          ),

          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 40),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Header
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.orange.shade100,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Icon(
                            Icons.restaurant,
                            size: 60,
                            color: Colors.orange,
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
                        _firstNameController, 'First Name', Icons.person),
                    const SizedBox(height: 15),
                    _buildTextField(_middleNameController, 'Middle Name',
                        Icons.person_outline),
                    const SizedBox(height: 15),
                    _buildTextField(_lastNameController, 'Last Name',
                        Icons.person_2_outlined),
                    const SizedBox(height: 15),
                    _buildTextField(_emailController, 'Email', Icons.email,
                        TextInputType.emailAddress),
                    const SizedBox(height: 15),
                    _buildTextField(_contactController, 'Contact Number',
                        Icons.phone, TextInputType.phone),
                    const SizedBox(height: 20),

                    // --- Password Fields ---
                    _buildPasswordField(
                      controller: _passwordController,
                      label: 'Password',
                      isVisible: _isPasswordVisible,
                      onToggle: () => setState(
                          () => _isPasswordVisible = !_isPasswordVisible),
                    ),
                    const SizedBox(height: 15),
                    _buildPasswordField(
                      controller: _confirmPasswordController,
                      label: 'Confirm Password',
                      isVisible: _isConfirmPasswordVisible,
                      onToggle: () => setState(() => _isConfirmPasswordVisible =
                          !_isConfirmPasswordVisible),
                    ),

                    const SizedBox(height: 25),

                    // --- Allergies Section ---
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Allergies',
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
                      children:
                          List.generate(_allergyControllers.length, (index) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  controller: _allergyControllers[index],
                                  decoration: InputDecoration(
                                    hintText: 'Enter allergy...',
                                    prefixIcon: const Icon(Icons.warning_amber,
                                        color: Colors.orange),
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
                              ),
                              if (_allergyControllers.length > 1)
                                IconButton(
                                  onPressed: () => _removeAllergyField(index),
                                  icon: const Icon(Icons.remove_circle,
                                      color: Colors.redAccent),
                                ),
                            ],
                          ),
                        );
                      }),
                    ),

                    const SizedBox(height: 30),

                    // --- Register Button ---
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          // Handle registration logic
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange.shade600,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          elevation: 5,
                        ),
                        child: const Text(
                          'Register',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
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
        ],
      ),
    );
  }

  // 🔸 Reusable text field builder
  Widget _buildTextField(
      TextEditingController controller, String label, IconData icon,
      [TextInputType keyboardType = TextInputType.text]) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
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

  // 🔸 Password field with visibility toggle
  Widget _buildPasswordField({
    required TextEditingController controller,
    required String label,
    required bool isVisible,
    required VoidCallback onToggle,
  }) {
    return TextField(
      controller: controller,
      obscureText: !isVisible,
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
