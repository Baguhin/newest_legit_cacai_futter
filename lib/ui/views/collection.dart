import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';

import 'addinsect.dart';
import 'collectiondescription.dart';

const String baseUrl =
    "https://41cc66e8-7337-47db-9bf1-b6d8b2644eeb-00-33j5pxrbyd20z.pike.replit.dev";

class CollectionPage extends StatefulWidget {
  const CollectionPage({super.key});

  @override
  _CollectionPageState createState() => _CollectionPageState();
}

class _CollectionPageState extends State<CollectionPage> {
  List<dynamic> insects = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _showShimmerBeforeLoading();
  }

  Future<void> _showShimmerBeforeLoading() async {
    await Future.delayed(const Duration(seconds: 2)); // Simulates shimmer delay
    fetchInsects();
  }

  Future<void> fetchInsects() async {
    try {
      final response = await http.get(Uri.parse("$baseUrl/api/insects"));
      if (response.statusCode == 200) {
        if (mounted) {
          // Check if the widget is still mounted
          setState(() {
            insects = json.decode(response.body);
            isLoading = false;
          });
        }
      } else {
        throw Exception("Failed to load insects");
      }
    } catch (e) {
      if (mounted) {
        // Check if the widget is still mounted
        setState(() => isLoading = false);
      }
      print("❌ Error fetching insects: $e");
    }
  }

  Future<void> _deleteInsect(int insectId, int index) async {
    final url = "$baseUrl/api/delete-insect/$insectId";
    print("🟢 Sending DELETE request to: $url");

    try {
      final response = await http.delete(Uri.parse(url));

      print("🔴 Response Status Code: ${response.statusCode}");
      print("🔴 Response Body: ${response.body}");

      if (response.statusCode == 200) {
        if (mounted) {
          setState(() {
            insects.removeAt(index);
          });
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("✅ Insect deleted successfully!")),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("❌ Failed to delete insect")),
        );
      }
    } catch (e) {
      print("❌ Error deleting insect: $e");
    }
  }

  // Method to open the Add Insect form
  void _openAddInsectForm() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return const AddInsectForm();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60), // Adjust height as needed
        child: ClipRRect(
          borderRadius: const BorderRadius.vertical(
            bottom: Radius.circular(20), // Set the radius for rounded corners
          ),
          child: AppBar(
            title: const Text("Insect Collection",
                style: TextStyle(color: Colors.white)),
            backgroundColor: const Color.fromRGBO(46, 125, 50, 1),
            centerTitle: true,
            actions: [
              IconButton(
                icon: const Icon(Icons.add,
                    color: Colors.white), // Set icon color to white
                onPressed:
                    _openAddInsectForm, // Opens the AddInsectForm when pressed
              ),
            ],
          ),
        ),
      ),
      body: isLoading ? _buildShimmerList() : _buildInsectList(),
    );
  }

  Widget _buildInsectList() {
    return insects.isEmpty
        ? const Center(
            child: Text("No insects found",
                style: TextStyle(fontSize: 16, color: Colors.grey)),
          )
        : Padding(
            padding: const EdgeInsets.all(12.0),
            child: ListView.builder(
              itemCount: insects.length,
              itemBuilder: (context, index) {
                final insect = insects[index];
                return Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  elevation: 3,
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(12),
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: CachedNetworkImage(
                        imageUrl: "$baseUrl${insect['image']}",
                        width: 60,
                        height: 60,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => _shimmerImage(),
                        errorWidget: (context, url, error) => const Icon(
                            Icons.image_not_supported,
                            size: 40,
                            color: Colors.red),
                      ),
                    ),
                    title: Text(
                      insect['name'] ?? "Unknown",
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    subtitle: Text(
                      insect['date'] ?? "",
                      style: const TextStyle(
                          color: Colors.teal, fontWeight: FontWeight.bold),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              InsectDescriptionPage(insect: insect),
                        ),
                      );
                    },
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () {
                        _deleteInsect(
                            insect['id'], index); // Delete insect when pressed
                      },
                    ),
                  ),
                );
              },
            ),
          );
  }

  Widget _buildShimmerList() {
    return ListView.builder(
      itemCount: 6,
      itemBuilder: (context, index) {
        return Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          elevation: 3,
          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
          child: ListTile(
            contentPadding: const EdgeInsets.all(12),
            leading: _shimmerImage(),
            title: _shimmerBox(width: 120, height: 16),
            subtitle: _shimmerBox(width: 100, height: 14),
          ),
        );
      },
    );
  }

  Widget _shimmerImage() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  Widget _shimmerBox({double width = 100, double height = 14}) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(8)),
      ),
    );
  }
}
