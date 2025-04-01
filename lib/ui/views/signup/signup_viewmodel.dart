import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:stacked/stacked.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../login/login_view.dart';

class SignupViewModel extends BaseViewModel {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  Future<void> signup(BuildContext parentContext) async {
    final name = nameController.text;
    final email = emailController.text;
    final password = passwordController.text;
    final confirmPassword = confirmPasswordController.text;

    if (name.isEmpty ||
        email.isEmpty ||
        password.isEmpty ||
        confirmPassword.isEmpty) {
      _showDialog(parentContext, 'Error', 'All fields are required.');
      return;
    }

    if (password != confirmPassword) {
      _showDialog(parentContext, 'Error', 'Passwords do not match.');
      return;
    }

    final url = Uri.parse('http://192.168.43.161:3000/api/signup');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'name': name, 'email': email, 'password': password}),
      );

      if (response.statusCode == 201) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setBool('isLoggedIn', true);

        _showDialog(parentContext, 'Success', 'Account created successfully!',
            () {
          navigateToLogin(parentContext);
        });
      } else {
        final errorResponse = jsonDecode(response.body);
        _showDialog(parentContext, 'Signup Failed', errorResponse['error']);
      }
    } catch (error) {
      _showDialog(parentContext, 'Error', 'Failed to connect to the server.');
    }
  }

  void _showDialog(BuildContext context, String title, String message,
      [VoidCallback? onDialogClose]) {
    if (!context.mounted) {
      return; // Ensure the context is valid before proceeding
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                if (onDialogClose != null) {
                  onDialogClose();
                }
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void navigateToLogin(BuildContext context) {
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) {
          return const LoginView(); // Navigate to LoginView
        },
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(1.0, 0.0); // Slide from the right
          const end = Offset.zero; // End position
          const curve = Curves.easeInOut;
          var tween =
              Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
          var offsetAnimation = animation.drive(tween);

          return SlideTransition(position: offsetAnimation, child: child);
        },
      ),
    );
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }
}
