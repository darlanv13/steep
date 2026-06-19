import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/app_theme.dart';
import 'core/providers/filter_provider.dart';
import 'core/providers/auth_provider.dart';
import 'core/providers/mock_auth_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'core/services/data_service.dart';
import 'core/services/mock_data_service.dart';
import 'core/services/firebase_data_service.dart';
import 'layout/main_layout.dart';
import 'features/auth/screens/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Try to initialize Firebase. If config is missing, it will throw an error,
  // but we can gracefully catch it or let the developer know they need `flutterfire configure`.
  try {
    await Firebase.initializeApp();
  } catch (e) {
    debugPrint(
      "Firebase initialization failed. Please run 'flutterfire configure'. Error: $e",
    );
  }

  // Change to true to use real Firebase services
  const bool useFirebase = false;

  runApp(
    MultiProvider(
      providers: [
        Provider<DataService>(
          create: (_) => useFirebase ? FirebaseDataService() : MockDataService(),
        ),
        ChangeNotifierProvider(create: (_) => FilterProvider()),
        ChangeNotifierProvider<AuthProvider>(
          create: (_) {
             if (useFirebase) return AuthProvider();
             final mock = MockAuthProvider();
             mock.setAuthState(false, 'operador');
             return mock;
          },
        ),
      ],
      child: const SgsvApp(),
    ),
  );
}

class SgsvApp extends StatelessWidget {
  const SgsvApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SGSV Mineração - VPS Vale',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.theme,
      home: Consumer<AuthProvider>(
        builder: (context, auth, child) {
          if (auth.isLoading) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }
          if (auth.isAuthenticated) {
            return const MainLayout();
          }
          return const LoginScreen();
        },
      ),
    );
  }
}
