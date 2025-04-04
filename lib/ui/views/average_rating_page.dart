import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AverageRatingPage extends StatefulWidget {
  const AverageRatingPage({super.key});

  @override
  _AverageRatingPageState createState() => _AverageRatingPageState();
}

class _AverageRatingPageState extends State<AverageRatingPage> {
  double average = 0.0;
  int total = 0;
  bool isLoading = true; // For loading state
  String errorMessage = '';

  Future<void> fetchAverage() async {
    final url =
        Uri.parse("https://jaylou-backend.onrender.com/api/get-average-rating");

    setState(() {
      isLoading = true; // Start loading
      errorMessage = ''; // Clear any previous error
    });

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          average = double.tryParse(data["average_rating"].toString()) ?? 0.0;
          total = int.tryParse(data["total_ratings"].toString()) ?? 0;
          isLoading = false; // Data loaded
        });
      } else {
        setState(() {
          errorMessage = 'Failed to fetch data. Please try again.';
          isLoading = false; // Stop loading in case of error
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Error: $e';
        isLoading = false; // Stop loading in case of error
      });
    }
  }

  @override
  void initState() {
    super.initState();
    fetchAverage();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("App Rating Summary")),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text("⭐ Average Rating", style: TextStyle(fontSize: 24)),
              const SizedBox(height: 20),
              isLoading
                  ? CircularProgressIndicator(
                      color: Colors.green,
                    )
                  : Column(
                      children: [
                        Text(
                          average.toStringAsFixed(1),
                          style: const TextStyle(
                            fontSize: 48,
                            color: Colors.amber,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          "Based on $total rating(s)",
                          style: const TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
              const SizedBox(height: 20),
              if (errorMessage.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    errorMessage,
                    style: const TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: fetchAverage,
                icon: const Icon(Icons.refresh),
                label: const Text("Refresh"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  elevation: 5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
