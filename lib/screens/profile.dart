import 'package:filipino_food_scanner/screens/home_screen.dart';
import 'package:filipino_food_scanner/utils/allergen_database.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Set<String> _selectedAllergens = {};
  bool _isEditing = false;
  bool _hasChanges = false;

  @override
  void initState() {
    super.initState();
    _loadUserAllergies();
  }

  void _loadUserAllergies() {
    final box = Hive.box('userBox');
    final allergies = box.get('allergies', defaultValue: []);

    setState(() {
      _selectedAllergens = Set<String>.from(allergies);
    });
  }

  void _toggleAllergen(String allergen) {
    if (!_isEditing) return;

    setState(() {
      if (_selectedAllergens.contains(allergen)) {
        _selectedAllergens.remove(allergen);
      } else {
        _selectedAllergens.add(allergen);
      }
      _hasChanges = true;
    });
  }

  Future<void> _saveChanges() async {
    final box = Hive.box('userBox');

    setState(() => _isEditing = false);

    // Show loading
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(color: Colors.orange),
      ),
    );

    await Future.delayed(const Duration(milliseconds: 500));

    box.put('allergies', _selectedAllergens.toList());

    if (mounted) {
      Navigator.pop(context); // close loading
      setState(() => _hasChanges = false);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Row(
            children: [
              Icon(Icons.check_circle, color: Colors.white),
              SizedBox(width: 10),
              Text('Allergies updated successfully!'),
            ],
          ),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  void _cancelEditing() {
    setState(() {
      _isEditing = false;
      _hasChanges = false;
      _loadUserAllergies(); // Reload original data
    });
  }

  @override
  Widget build(BuildContext context) {
    final box = Hive.box('userBox');
    final allergies = box.get('allergies') ?? '';
    final firstName = box.get('first_name') ?? 'firstName';
    final middleName = box.get('middle_name') ?? '';
    final lastName = box.get('last_name') ?? 'lastName';

    final name = "$firstName $middleName $lastName";

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        leadingWidth: 64,
        leading: Padding(
          padding: const EdgeInsets.only(left: 18),
          child: Align(
            alignment: Alignment.centerLeft,
            child: SizedBox(
              width: 36,
              height: 36,
              child: Material(
                color: Colors.white,
                shape: const CircleBorder(),
                child: IconButton(
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  icon: const Icon(Icons.arrow_back,
                      color: Colors.orange, size: 20),
                  onPressed: () {
                    if (_hasChanges) {
                      // Show confirmation dialog
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Unsaved Changes'),
                          content: const Text(
                              'You have unsaved changes. Do you want to discard them?'),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text('Cancel'),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context); // Close dialog
                                Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                      builder: (_) => const HomeScreen()),
                                );
                              },
                              child: const Text('Discard',
                                  style: TextStyle(color: Colors.red)),
                            ),
                          ],
                        ),
                      );
                    } else {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (_) => const HomeScreen()),
                      );
                    }
                  },
                ),
              ),
            ),
          ),
        ),
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
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),

                  // Profile Header Card
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
                        Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: CircleAvatar(
                            radius: 50,
                            backgroundColor: Colors.orange.shade100,
                            child: Text(
                              firstName[0].toUpperCase(),
                              style: TextStyle(
                                fontSize: 40,
                                fontWeight: FontWeight.bold,
                                color: Colors.orange.shade700,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 15),
                        Text(
                          name,
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 5)
                      ],
                    ),
                  ),

                  const SizedBox(height: 30),

                  // Allergies Section
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
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
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Row(
                              children: [
                                Icon(Icons.warning_amber, color: Colors.orange),
                                SizedBox(width: 10),
                                Text(
                                  'Food Allergies',
                                  style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF2D1B00),
                                  ),
                                ),
                              ],
                            ),
                            if (!_isEditing)
                              IconButton(
                                onPressed: () {
                                  setState(() => _isEditing = true);
                                },
                                icon: const Icon(Icons.edit),
                                color: Colors.orange,
                                style: IconButton.styleFrom(
                                  backgroundColor: Colors.orange.shade50,
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 5),
                        Text(
                          _isEditing
                              ? 'Tap allergens to add or remove them'
                              : 'Based on the 14 major allergens',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade600,
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Allergen Grid
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: AllergenDatabase.allergenCategories
                              .map((allergen) {
                            final isSelected =
                                _selectedAllergens.contains(allergen);

                            return InkWell(
                              onTap: () => _toggleAllergen(allergen),
                              borderRadius: BorderRadius.circular(20),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 10,
                                ),
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? Colors.orange
                                      : (_isEditing
                                          ? Colors.grey.shade100
                                          : Colors.grey.shade200),
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
                                        fontSize: 14,
                                      ),
                                    ),
                                    if (isSelected) ...[
                                      const SizedBox(width: 4),
                                      Icon(
                                        _isEditing
                                            ? Icons.remove_circle
                                            : Icons.check_circle,
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

                        // Selected Allergens Details (when not editing)
                        if (!_isEditing && _selectedAllergens.isNotEmpty) ...[
                          const SizedBox(height: 20),
                          const Divider(),
                          const SizedBox(height: 15),
                          const Text(
                            'Your Allergen Details:',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF2D1B00),
                            ),
                          ),
                          const SizedBox(height: 10),
                          ..._selectedAllergens.map((allergen) {
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: Colors.orange.shade50,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Text(
                                      AllergenDatabase.getAllergenIcon(
                                          allergen),
                                      style: const TextStyle(fontSize: 20),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          allergen,
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                            color: Color(0xFF2D1B00),
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          AllergenDatabase
                                              .getAllergenDescription(allergen),
                                          style: TextStyle(
                                            fontSize: 13,
                                            color: Colors.grey.shade600,
                                            height: 1.4,
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

                        // No allergies message
                        if (!_isEditing && _selectedAllergens.isEmpty) ...[
                          const SizedBox(height: 20),
                          Center(
                            child: Column(
                              children: [
                                Icon(
                                  Icons.check_circle_outline,
                                  size: 60,
                                  color: Colors.green.shade300,
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  'No allergies registered',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey.shade600,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  'Tap the edit button to add allergies',
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.grey.shade500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 10),
                        ],

                        // Edit mode buttons
                        if (_isEditing) ...[
                          const SizedBox(height: 20),
                          Row(
                            children: [
                              Expanded(
                                child: OutlinedButton(
                                  onPressed: _cancelEditing,
                                  style: OutlinedButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 14),
                                    side: const BorderSide(
                                        color: Colors.grey, width: 2),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  child: const Text(
                                    'Cancel',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 15),
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: _hasChanges ? _saveChanges : null,
                                  style: ElevatedButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 14),
                                    backgroundColor: Colors.orange,
                                    disabledBackgroundColor:
                                        Colors.grey.shade300,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  child: const Text(
                                    'Save Changes',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Info Card
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(color: Colors.blue.shade200),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.info_outline, color: Colors.blue.shade700),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'Your allergen information helps us warn you about potentially harmful ingredients in Filipino dishes.',
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.blue.shade900,
                              height: 1.4,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
