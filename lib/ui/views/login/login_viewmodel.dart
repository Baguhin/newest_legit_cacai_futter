// ignore_for_file: unused_local_variable, use_build_context_synchronously, prefer_const_constructors

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:stacked/stacked.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginViewModel extends BaseViewModel {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  Future<void> login(BuildContext context) async {
    final email = emailController.text;
    final password = passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      _showDialog(context, 'Error', 'Email and password are required.');
      return;
    }

    // Prepare the login request
    final url = Uri.parse('http://192.168.1.124:3000/api/login');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        final token = jsonResponse['token'];
        final userName =
            jsonResponse['userName']; // Get the user's name from the response

        // Save the token and login status in SharedPreferences
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('auth_token', token);
        await prefs.setString('user_name', userName); // Save the user's name
        await prefs.setBool(
            'isLoggedIn', true); // Set the isLoggedIn flag to true

        // Show Snackbar instead of AlertDialog
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Login successful!'),
            duration: Duration(seconds: 2),
            backgroundColor: Colors.green,
          ),
        );

        // Navigate after showing Snackbar
        Future.delayed(Duration(seconds: 2), () {
          Navigator.pushReplacementNamed(context, '/navigationBarWithFAB');
        });
      } else {
        final errorResponse = jsonDecode(response.body);
        _showDialog(context, 'Login Failed', errorResponse['error']);
      }
    } catch (error) {
      _showDialog(context, 'Error', 'Failed to connect to the server.');
    }
  }

  // Helper to show dialogs and optionally navigate
  void _showDialog(BuildContext context, String title, String message,
      [VoidCallback? onDialogClose]) {
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
                  onDialogClose(); // Perform navigation if provided
                }
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}
