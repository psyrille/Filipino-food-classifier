// import 'package:filipino_food_scanner/screens/register_screen.dart';
import 'package:filipino_food_scanner/config/supabase_config.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';
// import 'config/supabase_config.dart';
import 'screens/splash_screen.dart';
import 'services/ml_service.dart';
import 'services/auth_service.dart';
import 'screens/login_screen.dart';
import 'screens/reset_password_screen.dart';
import 'screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    // Initialize Supabase with persistent storage
    await Supabase.initialize(
      url: SupabaseConfig.supabaseUrl,
      anonKey: SupabaseConfig.supabaseAnonKey,
      authOptions: const FlutterAuthClientOptions(
        authFlowType: AuthFlowType.pkce, // More secure auth flow
      ),
      // Enable debug mode to see what's happening
      debug: true,
    );

    print('✅ Supabase initialized successfully');

    // Check if there's an existing session
    final session = Supabase.instance.client.auth.currentSession;
    if (session != null) {
      print('📱 Existing session found: ${session.user.email}');
      print('🕐 Expires at: ${session.expiresAt}');
      print('📊 Is expired: ${session.isExpired}');
    } else {
      print('ℹ️ No existing session found');
    }
  } catch (e) {
    print('❌ Error initializing Supabase: $e');
  }

  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Hive.openBox('userBox');

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
    // _setupAuthListener();
  }

  // void _setupAuthListener() {
  //   // Listen for auth state changes
  //   // Supabase.instance.client.auth.onAuthStateChange.listen((data) {
  //   //   final event = data.event;

  //   //   print('🔐 Auth event: $event');

  //   //   // When user clicks the password reset link in their email
  //   //   if (event == AuthChangeEvent.passwordRecovery) {
  //   //     print('🔄 Password recovery detected - navigating to reset screen');

  //   //     // Navigate to reset password screen
  //   //     navigatorKey.currentState?.pushAndRemoveUntil(
  //   //       MaterialPageRoute(builder: (_) => const ResetPasswordScreen()),
  //   //       (route) => false,
  //   //     );
  //   //   }

  //   //   // When token is refreshed, log it
  //   //   if (event == AuthChangeEvent.tokenRefreshed) {
  //   //     print('🔄 Token refreshed successfully');
  //   //   }

  //   //   // When user signs out
  //   //   if (event == AuthChangeEvent.signedOut) {
  //   //     print('👋 User signed out');
  //   //   }
  //   // });

  //   var box = Hive.box('userBox');
  //   bool hasUser = box.containsKey('name');

  //   if (!hasUser) {
  //     MaterialPageRoute(builder: (_) => const RegisterScreen());
  //   } else {
  //     MaterialPageRoute(builder: (_) => const HomeScreen());
  //   }
  // }

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
        navigatorKey: navigatorKey,
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
