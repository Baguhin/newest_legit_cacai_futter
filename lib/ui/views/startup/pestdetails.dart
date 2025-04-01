import 'package:flutter/material.dart';

class PestDetailsPage extends StatelessWidget {
  final Map<String, dynamic> pest;

  const PestDetailsPage({super.key, required this.pest});

  @override
  Widget build(BuildContext context) {
    final imageUrl = "http://localhost:3000${pest['image']}";

    return Scaffold(
      appBar: AppBar(title: Text(pest['name'])),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(imageUrl, height: 200, fit: BoxFit.cover),
              ),
            ),
            const SizedBox(height: 20),
            const Text("Description",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Text(pest['description']),
          ],
        ),
      ),
    );
  }
}
