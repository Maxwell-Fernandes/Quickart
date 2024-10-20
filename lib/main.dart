import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:quickart_proj/pages/register_screen.dart';
import 'package:quickart_proj/provider/auth_provider.dart'
    as quickart_auth; // Use alias for AuthProvider
import 'package:quickart_proj/pages/home_page.dart';
import 'package:quickart_proj/pages/login_page.dart';
import 'package:quickart_proj/theme/splash_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
            create: (_) => quickart_auth.AuthProvider()), // Use the alias here
      ],
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: AuthWrapper(),
        title: "Quickart App",
      ),
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasData) {
          return const HomePage(); // User is logged in
        }
        return const RegisterScreen(); // Show LoginPage if user is not logged in
      },
    );
  }
}
