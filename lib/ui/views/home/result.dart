import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

import 'home_viewmodel.dart'; // Import the SpeedDial package

class ResultsPage extends StatelessWidget {
  final String label;
  final String description;
  final List<String> possibleCauses;
  final List<String> solutions;
  final List<String> recommendedPesticides;
  final File imageFile;
  final HomeViewModel viewModel;

  const ResultsPage({
    super.key,
    required this.label,
    required this.description,
    required this.possibleCauses,
    required this.solutions,
    required this.recommendedPesticides,
    required this.imageFile,
    required this.viewModel,
  });

  Widget buildInfoCard(
      String title, List<String> content, IconData icon, Color color) {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: color, size: 24),
                const SizedBox(width: 10),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: color,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ...content.map((item) => Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.circle, size: 10, color: Colors.grey),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          item,
                          style: const TextStyle(
                              fontSize: 16, color: Colors.black87),
                        ),
                      ),
                    ],
                  ),
                )),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Cacao Pest Detection Result"),
        backgroundColor: Colors.green.shade700,
        centerTitle: true,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.grey.shade100, Colors.grey.shade400],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Card(
                  elevation: 15,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24)),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(24),
                    child: Image.file(
                      imageFile,
                      height: 300,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(height: 25),
                buildInfoCard("Detected Pest", [label], Icons.bug_report,
                    Colors.teal.shade800),
                const SizedBox(height: 12),
                buildInfoCard("Description", [description], Icons.description,
                    Colors.blue.shade700),
                const SizedBox(height: 12),
                buildInfoCard("Possible Causes", possibleCauses,
                    Icons.warning_amber_rounded, Colors.orange.shade700),
                const SizedBox(height: 12),
                buildInfoCard("Solutions", solutions, Icons.lightbulb,
                    Colors.green.shade700),
                const SizedBox(height: 12),
                buildInfoCard("Recommended Pesticides", recommendedPesticides,
                    Icons.local_florist, Colors.purple.shade700),
              ],
            ),
          ),
        ),
      ),
      // Floating Action Button with SpeedDial
      floatingActionButton: SpeedDial(
        animatedIcon: AnimatedIcons.add_event,
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        children: [
          SpeedDialChild(
            child: const Icon(Icons.camera_alt),
            label: 'Camera',
            backgroundColor: Colors.green,
            onTap: () {
              viewModel.pickImage(ImageSource.camera, context);
            },
          ),
          SpeedDialChild(
            child: const Icon(Icons.photo_library),
            label: 'Upload',
            backgroundColor: Colors.blue,
            onTap: () {
              viewModel.pickImage(ImageSource.gallery, context);
            },
          ),
        ],
      ),
    );
  }
}
