import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'views/detail.dart';

class PestListHomePage extends StatefulWidget {
  const PestListHomePage({super.key});

  @override
  _PestListHomePageState createState() => _PestListHomePageState();
}

class _PestListHomePageState extends State<PestListHomePage> {
  List pests = [];
  List filteredPests = [];
  bool isLoading = true;

  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchPests();

    // Add listener for search input
    _searchController.addListener(() {
      filterPests(_searchController.text);
    });
  }

  Future<void> fetchPests() async {
    final response = await http
        .get(Uri.parse('https://jaylou-backend.onrender.com/api/pests'));

    if (response.statusCode == 200) {
      if (mounted) {
        setState(() {
          pests = json.decode(response.body);
          filteredPests = pests; // Initialize filteredPests with all pests
          isLoading = false;
        });
      }
    } else {
      throw Exception('Failed to load pests');
    }
  }

  void filterPests(String query) {
    List filteredList = pests.where((pest) {
      return pest["name"].toLowerCase().contains(query.toLowerCase());
    }).toList();

    if (mounted) {
      setState(() {
        filteredPests = filteredList;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green.shade50,
      body: Column(
        children: [
          _buildHeader(),
          Expanded(
            child: isLoading ? _buildShimmerEffect() : _buildPestGrid(),
          ),
        ],
      ),
    );
  }

  // Header with search bar
  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(
          horizontal: 16, vertical: 24), // Increased padding
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.green.shade600, Colors.green.shade800],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Pest Library",
            style: TextStyle(
              fontSize: 28, // Increased font size
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: "Search for pests...",
              filled: true,
              fillColor: Colors.white,
              prefixIcon: Icon(Icons.search, color: Colors.green.shade800),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: 16), // Increased padding for better UX
            ),
          ),
        ],
      ),
    );
  }

  // Pest grid to display pests
  Widget _buildPestGrid() {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 0.85,
        ),
        itemCount: filteredPests.length,
        itemBuilder: (context, index) {
          final pest = filteredPests[index];
          return _buildPestCard(pest);
        },
      ),
    );
  }

  // Pest card layout
  Widget _buildPestCard(Map pest) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          PageRouteBuilder(
            transitionDuration: const Duration(milliseconds: 600),
            pageBuilder: (context, animation, secondaryAnimation) =>
                PestDetailPage(pest: pest),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              return FadeTransition(opacity: animation, child: child);
            },
          ),
        );
      },
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        elevation: 8, // Increased elevation for a more elevated look
        shadowColor: Colors.green.shade200, // Added shadow color
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(15)),
                child: Image.network(
                  'https://jaylou-backend.onrender.com${pest["image"]}',
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => const Icon(
                      Icons.bug_report,
                      size: 50,
                      color: Colors.grey),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text(
                pest["name"],
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.green.shade900,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Shimmer effect while loading data
  Widget _buildShimmerEffect() {
    return GridView.builder(
      padding: const EdgeInsets.all(12),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.8,
      ),
      itemCount: 6,
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: Colors.grey.shade300,
          highlightColor: Colors.grey.shade100,
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            elevation: 6,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: Container(
                    color: Colors.white,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Container(
                    height: 20,
                    width: double.infinity,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
