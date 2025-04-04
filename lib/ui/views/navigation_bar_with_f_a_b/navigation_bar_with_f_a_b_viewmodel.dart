// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stacked/stacked.dart';
import 'package:http/http.dart' as http; // Ensure to import the http package

class NavigationBarWithFABViewModel extends BaseViewModel {
  final ZoomDrawerController _zoomDrawerController = ZoomDrawerController();
  int _pageIndex = 0; // Default page index to show HomePage

  int get pageIndex => _pageIndex;
  ZoomDrawerController get zoomDrawerController => _zoomDrawerController;

  void setPageIndex(int index) {
    _pageIndex = index;
    notifyListeners();
  }

  void toggleDrawer() {
    _zoomDrawerController.toggle?.call();
  }

  Future<void> logout(BuildContext context) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');

      // Check if token exists before proceeding with logout
      if (token == null) {
        _showDialog(context, 'Error', 'No token found. Please log in again.');
        return;
      }

      // Define the logout URL
      final url = Uri.parse('https://jaylou-backend.onrender.com/api/logout');

      // Make the logout request with the token in headers
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      // Handle logout success
      if (response.statusCode == 200) {
        // Remove the token and set isLoggedIn to false only after a successful logout
        await prefs.remove('auth_token');
        await prefs.setBool('isLoggedIn', false);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Logout successful!'),
              duration: Duration(seconds: 2),
              backgroundColor: Colors.green),
        );

        Future.delayed(const Duration(seconds: 2), () {
          Navigator.of(context).pushReplacementNamed('/login');
        });
      } else {
        final errorResponse = jsonDecode(response.body);
        _showDialog(context, 'Logout Failed', errorResponse['error']);
      }
    } catch (error) {
      _showDialog(context, 'Error', 'Failed to connect to the server.');
    }
  }

  // Helper to show dialogs
  void _showDialog(BuildContext context, String title, String message) {
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
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
