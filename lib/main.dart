import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'config/supabase_config.dart';
import 'screens/splash_screen.dart';
import 'services/ml_service.dart';
import 'services/auth_service.dart';
import 'screens/login_screen.dart';
import 'screens/reset_password_screen.dart';
import 'screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Supabase
  await Supabase.initialize(
    url: SupabaseConfig.supabaseUrl,
    anonKey: SupabaseConfig.supabaseAnonKey,
    authOptions: const FlutterAuthClientOptions(
      authFlowType: AuthFlowType.pkce, // More secure auth flow
    ),
  );

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  @override
  void initState() {
    super.initState();
    _setupAuthListener();
  }

  void _setupAuthListener() {
    // Listen for auth state changes
    Supabase.instance.client.auth.onAuthStateChange.listen((data) {
      final event = data.event;

      print('🔐 Auth event: $event'); // Debug log

      // When user clicks the password reset link in their email
      if (event == AuthChangeEvent.passwordRecovery) {
        print('🔄 Password recovery detected - navigating to reset screen');

        // Navigate to reset password screen
        navigatorKey.currentState?.pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => const ResetPasswordScreen()),
          (route) => false, // Remove all previous routes
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthService()),
        ChangeNotifierProvider(create: (_) => MLService()),
      ],
      child: MaterialApp(
        title: 'BantayAllerji',
        debugShowCheckedModeBanner: false,
        navigatorKey: navigatorKey, // 👈 Important: Add navigator key
        theme: ThemeData(
          primarySwatch: Colors.orange,
          scaffoldBackgroundColor: const Color(0xFFFFF8F0),
          textTheme: GoogleFonts.poppinsTextTheme(),
          useMaterial3: true,
        ),
        home: const SplashScreen(),
        routes: {
          '/login': (context) => const LoginScreen(),
          '/reset-password': (context) => const ResetPasswordScreen(),
          '/home': (context) => const HomeScreen(),
        },
      ),
    );
  }
}
