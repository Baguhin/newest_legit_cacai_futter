// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'signup_viewmodel.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart'; // Import FontAwesomeIcons

class SignupView extends StackedView<SignupViewModel> {
  const SignupView({super.key});

  @override
  Widget builder(
      BuildContext context, SignupViewModel viewModel, Widget? child) {
    return Scaffold(
      resizeToAvoidBottomInset: true, // Allows body to resize for keyboard
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image:
                AssetImage('assets/images/background.png'), // Background image
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25.0),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 40),
                  // Heading Text for the Screen
                  const Text(
                    'Create an Account',
                    style: TextStyle(
                      fontSize: 34,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 30),
                  // Add Name TextField
                  _buildTextField(viewModel.nameController, 'Full Name',
                      Icons.person_outline),
                  const SizedBox(height: 20),
                  _buildTextField(viewModel.emailController, 'Email Address',
                      Icons.email_outlined),
                  const SizedBox(height: 20),
                  _buildPasswordField(viewModel.passwordController, 'Password',
                      Icons.lock_outline),
                  const SizedBox(height: 20),
                  _buildPasswordField(viewModel.confirmPasswordController,
                      'Confirm Password', Icons.lock_outline),
                  const SizedBox(height: 40),
                  // Social Media Icons Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: const Icon(FontAwesomeIcons.facebook),
                        onPressed: () {
                          // Handle Facebook login/signup
                        },
                        color: const Color.fromARGB(
                            255, 245, 246, 247), // Facebook color
                        iconSize: 30,
                      ),
                      const SizedBox(width: 20),
                      IconButton(
                        icon: const Icon(FontAwesomeIcons.google),
                        onPressed: () {
                          // Handle Google login/signup
                        },
                        color: const Color.fromARGB(
                            255, 247, 245, 245), // Google color
                        iconSize: 30,
                      ),
                      const SizedBox(width: 20),
                      IconButton(
                        icon: const Icon(FontAwesomeIcons.twitter),
                        onPressed: () {
                          // Handle Twitter login/signup
                        },
                        color: const Color.fromARGB(
                            255, 243, 244, 245), // Twitter color
                        iconSize: 30,
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          const Color(0xFF3D5B27), // Match the color
                      padding: const EdgeInsets.symmetric(
                          vertical: 15, horizontal: 30),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      elevation: 6,
                    ),
                    onPressed: () =>
                        viewModel.signup(context), // Pass context to signup
                    child: const Text(
                      'Sign Up',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 18), // White text color
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextButton(
                    onPressed: () => viewModel.navigateToLogin(context),
                    child: const Text(
                      'Already have an account? Login',
                      style: TextStyle(
                        color: Color(0xFF3D5B27), // Consistent with theme color
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Password field with show/hide password toggle
  Widget _buildPasswordField(
      TextEditingController controller, String label, IconData icon) {
    bool _obscureText = true;

    return StatefulBuilder(
      builder: (context, setState) {
        return Card(
          elevation: 8,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          child: TextField(
            controller: controller,
            obscureText: _obscureText,
            style: const TextStyle(color: Colors.black),
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              labelText: label,
              labelStyle: const TextStyle(color: Color(0xFF3D5B27)),
              prefixIcon: Icon(icon, color: const Color(0xFF3D5B27)),
              suffixIcon: IconButton(
                icon: Icon(
                  _obscureText ? Icons.visibility_off : Icons.visibility,
                  color: const Color(0xFF3D5B27),
                ),
                onPressed: () {
                  setState(() {
                    _obscureText = !_obscureText;
                  });
                },
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: const BorderSide(color: Color(0xFF3D5B27)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: const BorderSide(color: Color(0xFF3D5B27)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide:
                    const BorderSide(color: Color(0xFF3D5B27), width: 2),
              ),
            ),
          ),
        );
      },
    );
  }

  // TextField widget to build reusable input fields
  Widget _buildTextField(
      TextEditingController controller, String label, IconData icon,
      {bool obscureText = false}) {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        style: const TextStyle(color: Colors.black),
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          labelText: label,
          labelStyle: const TextStyle(color: Color(0xFF3D5B27)),
          prefixIcon: Icon(icon, color: const Color(0xFF3D5B27)),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: const BorderSide(color: Color(0xFF3D5B27)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: const BorderSide(color: Color(0xFF3D5B27)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: const BorderSide(color: Color(0xFF3D5B27), width: 2),
          ),
        ),
      ),
    );
  }

  @override
  SignupViewModel viewModelBuilder(BuildContext context) => SignupViewModel();
}
