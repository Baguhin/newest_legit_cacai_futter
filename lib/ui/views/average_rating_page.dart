import 'package:cacai/ui/views/rating.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

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
  String userId = '';

  @override
  void initState() {
    super.initState();
    _getUserId();
    fetchAverage();
  }

  Future<void> _getUserId() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final storedId = prefs.getString('user_id') ?? '';
      setState(() {
        userId = storedId;
      });
    } catch (e) {
      // Handle error silently
    }
  }

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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("App Rating Summary"),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.star_rounded,
                            color: Colors.amber[600],
                            size: 36,
                          ),
                          const SizedBox(width: 12),
                          const Text(
                            "Average Rating",
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF303030),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 30),
                      isLoading
                          ? const CircularProgressIndicator(
                              color: Color(0xFF5271FF),
                            )
                          : Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment:
                                      CrossAxisAlignment.baseline,
                                  textBaseline: TextBaseline.alphabetic,
                                  children: [
                                    Text(
                                      average.toStringAsFixed(1),
                                      style: TextStyle(
                                        fontSize: 72,
                                        color: Colors.amber[700],
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      " / 5",
                                      style: TextStyle(
                                        fontSize: 30,
                                        color: Colors.grey[600],
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 16),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 8,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.grey[100],
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  child: Text(
                                    "Based on $total rating(s)",
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.grey[700],
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                      if (errorMessage.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 16.0),
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.red.shade50,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.red.shade200),
                            ),
                            child: Text(
                              errorMessage,
                              style: TextStyle(
                                color: Colors.red.shade700,
                                fontWeight: FontWeight.w500,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      const SizedBox(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          OutlinedButton.icon(
                            onPressed: fetchAverage,
                            icon: const Icon(Icons.refresh),
                            label: const Text("Refresh"),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: const Color(0xFF5271FF),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 24,
                                vertical: 12,
                              ),
                            ),
                          ),
                          ElevatedButton.icon(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      RatingPage(userId: userId),
                                ),
                              ).then((_) => fetchAverage());
                            },
                            icon: const Icon(Icons.star_outline),
                            label: const Text("Rate Now"),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF5271FF),
                              foregroundColor: Colors.white,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 24,
                                vertical: 12,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                "You can rate our app multiple times!",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
