import 'package:flutter/material.dart';
import 'package:quickart_proj/theme/gradient_background.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:quickart_proj/pages/home_page.dart';
import 'package:quickart_proj/pages/login_page.dart';
import 'package:quickart_proj/main.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToNextScreen();
  }

  void _navigateToNextScreen() async {
    await Future.delayed(
        const Duration(seconds: 10)); // Duration for splash screen
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => AuthWrapper(), // Navigate to AuthWrapper
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GradientBackground(
      child: Scaffold(
        backgroundColor:
            Colors.transparent, // Make sure the scaffold is transparent
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Image widget for your logo
              Image.asset(
                'images/quickart_logo.png', // Your logo path
                height: 200, // Adjust the height as needed
                width: 300, // Adjust the width as needed
              ),
              const SizedBox(height: 20), // Space between image and text
              const Text(
                'Welcome to Quickart!',
                style: TextStyle(
                  fontSize: 24,
                  color: Color.fromARGB(255, 0, 0, 0),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
