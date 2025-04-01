// ignore_for_file: unused_element

import 'package:cacai/chatbot.dart';
import 'package:cacai/ui/views/startup/onboarding.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cacai/ui/views/login/login_view.dart'; // Import your LoginView
import 'package:cacai/ui/views/signup/signup_view.dart'; // Import your SignupView

import 'package:cacai/ui/views/home/home_view.dart'; // Import your HomeView
import 'package:cacai/ui/views/navigation_bar_with_f_a_b/navigation_bar_with_f_a_b_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: FutureBuilder<bool>(
        future: _checkLoginStatus(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasData && snapshot.data == true) {
            return const BottomNavDrawer(); // User is logged in
          } else {
            return const OnboardingScreen(); // User is not logged in, show LoginView
          }
        },
      ),
      routes: {
        '/signup': (context) => const SignupView(),

        '/scanner': (context) => const HomeView(),
        '/login': (context) => const LoginView(), // Add this line
        '/collection': (context) => const GeminiChatPage(),
        '/navigationBarWithFAB': (context) =>
            const BottomNavDrawer(), // Route for NavigationBarWithFAB
      },
    );
  }

  // Initialization function that includes a delay for the splash screen
  Future<bool> _initializeApp() async {
    await Future.delayed(
        const Duration(seconds: 2)); // Display splash screen for 2 seconds
    return _checkLoginStatus();
  }

  Future<bool> _checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool('isLoggedIn') ?? false;
  }
}
