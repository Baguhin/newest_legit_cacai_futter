import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class PestDetailPage extends StatelessWidget {
  final Map pest;
  const PestDetailPage({super.key, required this.pest});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green.shade100,
      appBar: AppBar(
        title: Text(
          pest["name"],
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.green.shade800,
        centerTitle: true,
        elevation: 5,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Image with animation
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 10,
                      spreadRadius: 2,
                      offset: Offset(2, 4),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.network(
                    'https://jaylou-backend.onrender.com${pest["image"]}',
                    width: double.infinity,
                    height: 250,
                    fit: BoxFit.cover,
                  ),
                ),
              )
                  .animate()
                  .fade(duration: 700.ms)
                  .scaleY(begin: 0.95, end: 1.0, curve: Curves.easeOut),

              const SizedBox(height: 20),

              // Pest Name
              Text(
                pest["name"],
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Colors.green.shade900,
                ),
              ),
              const SizedBox(height: 12),

              // Description inside a Card
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                elevation: 4,
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    pest["description"] ?? "No description available",
                    textAlign: TextAlign.justify,
                    style: TextStyle(fontSize: 16, color: Colors.grey.shade800),
                  ),
                ),
              ).animate().fade(duration: 600.ms).slideY(
                  begin: 0.2, end: 0.0, curve: Curves.easeOut), // ✅ Fixed
            ],
          ),
        ),
      ),
    );
  }
}
