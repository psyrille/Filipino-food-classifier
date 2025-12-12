import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';
import '../services/session_manager.dart';
import 'login_screen.dart';
import 'home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    try {
      print('🚀 Starting app initialization...');

      // STEP 1: Check local session FIRST (works offline)
      print('📱 Checking local session...');
      final hasLocalSession = await SessionManager.isLoggedIn();

      if (hasLocalSession) {
        print('✅ Local session found!');
        await SessionManager.debugPrintSession();

        // Initialize auth service (will load from local storage)
        final authService = context.read<AuthService>();
        await authService.initialize();

        // Small delay for splash effect
        await Future.delayed(const Duration(seconds: 1));

        if (!mounted) return;

        if (authService.isAuthenticated && authService.currentUser != null) {
          print('✅ User authenticated from local session, going to home');
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (_) => const HomeScreen()),
          );
          return;
        }
      }

      // STEP 2: No local session, try Supabase (requires internet)
      print('🌐 No local session, checking Supabase...');
      final authService = context.read<AuthService>();
      await authService.initialize();

      // Wait for splash effect
      await Future.delayed(const Duration(seconds: 1));

      if (!mounted) return;

      print(
          '🔍 Final check - Is Authenticated: ${authService.isAuthenticated}');
      print(
          '🔍 Final check - Current User: ${authService.currentUser?.email ?? "None"}');

      if (authService.isAuthenticated && authService.currentUser != null) {
        print('✅ User authenticated, navigating to home');
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const HomeScreen()),
        );
      } else {
        print('❌ User not authenticated, navigating to login');
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const LoginScreen()),
        );
      }
    } catch (e) {
      print('❌ Error during initialization: $e');

      // Last resort: check local session one more time
      final hasLocalSession = await SessionManager.isLoggedIn();
      final authService = context.read<AuthService>();

      if (hasLocalSession) {
        await authService.initialize();

        if (!mounted) return;

        if (authService.isAuthenticated) {
          print('✅ Recovered from error using local session');
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (_) => const HomeScreen()),
          );
          return;
        }
      }

      // If all else fails, go to login
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const LoginScreen()),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
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
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo
              Container(
                padding: const EdgeInsets.all(30),
                decoration: BoxDecoration(
                  color: Colors.orange.shade100,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.orange.withOpacity(0.3),
                      blurRadius: 30,
                      offset: const Offset(0, 15),
                    ),
                  ],
                ),
                child: ClipOval(
                  child: Image.asset(
                    'assets/images/logos/main.png',
                    width: 100,
                    height: 100,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(
                        Icons.restaurant,
                        size: 100,
                        color: Colors.orange,
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(height: 30),

              // App Name
              const Text(
                'BantayAllerji',
                style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2D1B00),
                ),
              ),
              const Text(
                'Food Scanner',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w500,
                  color: Colors.orange,
                ),
              ),
              const SizedBox(height: 50),

              // Loading Indicator
              const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.orange),
              ),
              const SizedBox(height: 20),
              const Text(
                'Initializing...',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
