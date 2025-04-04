import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

const String baseUrl = "https://jaylou-backend.onrender.com/";

class InsectDescriptionPage extends StatelessWidget {
  final Map<String, dynamic> insect;

  // Constructor to receive insect data
  const InsectDescriptionPage({super.key, required this.insect});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(insect['name'] ?? "Insect Details"),
        backgroundColor: const Color.fromRGBO(46, 125, 50, 1),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: CachedNetworkImage(
                  imageUrl: "$baseUrl${insect['image']}",
                  width: double.infinity,
                  height: 250,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Container(
                    width: double.infinity,
                    height: 250,
                    color: Colors.grey[300],
                  ),
                  errorWidget: (context, url, error) => const Icon(
                      Icons.image_not_supported,
                      size: 100,
                      color: Colors.red),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              insect['name'] ?? "Unknown",
              style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color.fromRGBO(46, 125, 50, 1)),
            ),
            const SizedBox(height: 10),
            Text(
              "Date: ${insect['date'] ?? "Unknown"}",
              style: TextStyle(fontSize: 16, color: Colors.grey[700]),
            ),
            const SizedBox(height: 15),
            const Text(
              "Description:",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 5),
            Text(
              insect['description'] ?? "No description available.",
              style: const TextStyle(fontSize: 16, color: Colors.black87),
            ),
          ],
        ),
      ),
    );
  }
}
