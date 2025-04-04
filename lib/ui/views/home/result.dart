import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

import 'home_viewmodel.dart';

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

  Widget _buildSectionHeader(String title, IconData icon, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(width: 12),
          Text(
            title,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: color,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard(List<String> content, {bool isMainInfo = false}) {
    return Card(
      elevation: isMainInfo ? 8 : 4,
      shadowColor: isMainInfo ? Colors.green.withOpacity(0.4) : Colors.black26,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: isMainInfo
            ? BorderSide(color: Colors.green.shade700, width: 1.5)
            : BorderSide.none,
      ),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ...content.map((item) => Padding(
                  padding: const EdgeInsets.only(bottom: 12.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        isMainInfo ? Icons.check_circle : Icons.arrow_right,
                        size: isMainInfo ? 20 : 18,
                        color: isMainInfo
                            ? Colors.green.shade700
                            : Colors.grey.shade700,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          item,
                          style: TextStyle(
                            fontSize: isMainInfo ? 18 : 16,
                            fontWeight:
                                isMainInfo ? FontWeight.w600 : FontWeight.w400,
                            color: isMainInfo
                                ? Colors.green.shade800
                                : Colors.black87,
                            height: 1.4,
                          ),
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

  Widget _buildSeverityIndicator(String pestName) {
    // This is a simplistic approach - you would typically determine severity based on actual data
    int severity = (pestName.length % 3) + 1; // Mock severity calculation (1-3)

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            "Infestation Severity: ",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          Row(
            children: List.generate(3, (index) {
              return Icon(
                Icons.pest_control,
                size: 22,
                color: index < severity ? Colors.red : Colors.grey.shade300,
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildPesticideItem(String pesticide) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: const Icon(Icons.spa, color: Colors.green),
        title: Text(
          pesticide,
          style: const TextStyle(fontWeight: FontWeight.w500),
        ),
        trailing: const Icon(Icons.info_outline),
        onTap: () {
          // Could navigate to detailed pesticide information
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300.0,
            floating: false,
            pinned: true,
            backgroundColor: Colors.green.shade800,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                "Detected: $label",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white, // Set text color to white
                  fontSize: 14, // Adjust the font size as needed
                ),
              ),
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Image.file(
                    imageFile,
                    fit: BoxFit.cover,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withOpacity(0.7),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.share),
                onPressed: () {
                  // Implement share functionality
                },
              ),
              IconButton(
                icon: const Icon(Icons.bookmark_border),
                onPressed: () {
                  // Implement save/bookmark functionality
                },
              ),
            ],
          ),
          SliverToBoxAdapter(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.grey.shade50, Colors.grey.shade100],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 16),

                    // Main info card - combines pest name and basic description
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.green.shade700,
                            Colors.green.shade900
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.bug_report,
                                  color: Colors.white, size: 28),
                              const SizedBox(width: 10),
                              Text(
                                label,
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            description,
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                              height: 1.5,
                            ),
                          ),
                          const SizedBox(height: 10),
                          _buildSeverityIndicator(label),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Timeline indicator
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildTimelineItem("Detected", Icons.search, true),
                          _buildDivider(true),
                          _buildTimelineItem(
                              "Diagnosed", Icons.medical_information, true),
                          _buildDivider(true),
                          _buildTimelineItem("Treatment", Icons.healing, false),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Causes section
                    _buildSectionHeader("Possible Causes",
                        Icons.warning_amber_rounded, Colors.orange.shade700),
                    _buildInfoCard(possibleCauses),

                    const SizedBox(height: 16),

                    // Solutions section
                    _buildSectionHeader("Recommended Solutions",
                        Icons.lightbulb, Colors.blue.shade700),
                    _buildInfoCard(solutions, isMainInfo: true),

                    const SizedBox(height: 16),

                    // Pesticides section
                    _buildSectionHeader("Recommended Pesticides",
                        Icons.local_florist, Colors.purple.shade700),
                    Column(
                      children: recommendedPesticides
                          .map((pesticide) => _buildPesticideItem(pesticide))
                          .toList(),
                    ),

                    const SizedBox(height: 24),

                    // Action buttons

                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      // Floating Action Button with SpeedDial
      floatingActionButton: SpeedDial(
        animatedIcon: AnimatedIcons.menu_close,
        backgroundColor: Colors.green.shade700,
        foregroundColor: Colors.white,
        overlayColor: Colors.black,
        overlayOpacity: 0.5,
        elevation: 8.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        children: [
          SpeedDialChild(
            child: const Icon(Icons.camera_alt),
            label: 'Take New Photo',
            backgroundColor: Colors.green.shade600,
            labelStyle: const TextStyle(fontWeight: FontWeight.w500),
            onTap: () {
              viewModel.pickImage(ImageSource.camera, context);
            },
          ),
          SpeedDialChild(
            child: const Icon(Icons.photo_library),
            label: 'Upload from Gallery',
            backgroundColor: Colors.blue.shade700,
            labelStyle: const TextStyle(fontWeight: FontWeight.w500),
            onTap: () {
              viewModel.pickImage(ImageSource.gallery, context);
            },
          ),
          SpeedDialChild(
            child: const Icon(Icons.help_outline),
            label: 'Get Expert Help',
            backgroundColor: Colors.purple.shade700,
            labelStyle: const TextStyle(fontWeight: FontWeight.w500),
            onTap: () {
              // Contact expert functionality
            },
          ),
        ],
      ),
    );
  }

  Widget _buildTimelineItem(String label, IconData icon, bool isComplete) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: isComplete ? Colors.green.shade100 : Colors.grey.shade200,
            border: Border.all(
              color: isComplete ? Colors.green.shade700 : Colors.grey.shade400,
              width: 2,
            ),
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            color: isComplete ? Colors.green.shade700 : Colors.grey.shade600,
            size: 20,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: isComplete ? FontWeight.bold : FontWeight.normal,
            color: isComplete ? Colors.green.shade700 : Colors.grey.shade600,
          ),
        ),
      ],
    );
  }

  Widget _buildDivider(bool isComplete) {
    return Expanded(
      child: Container(
        height: 2,
        color: isComplete ? Colors.green.shade700 : Colors.grey.shade300,
      ),
    );
  }
}
