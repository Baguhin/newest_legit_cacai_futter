import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HeatmapScreen extends StatefulWidget {
  const HeatmapScreen({super.key});

  @override
  State<HeatmapScreen> createState() => _HeatmapScreenState();
}

class _HeatmapScreenState extends State<HeatmapScreen> {
  bool isLoading = true;
  dynamic heatmapData;

  @override
  void initState() {
    super.initState();
    _fetchHeatmapData();
  }

  Future<void> _fetchHeatmapData() async {
    try {
      final response = await http.get(
          Uri.parse('https://jaylou-backend.onrender.com/api/map/heatmap'));

      if (response.statusCode == 200) {
        setState(() {
          heatmapData = jsonDecode(response.body);
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Failed to load map data. Please try again.')),
        );
      }
    } catch (e) {
      debugPrint('Error fetching heatmap data: $e');
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Failed to load map data. Please try again.')),
      );
    }
  }

  Future<void> _reportIncident(BuildContext context) async {
    try {
      //Implementation for reporting incident.  Replace with actual code
      final response = await http.post(
          Uri.parse('https://jaylou-backend.onrender.com/api/map/report'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(<String, String>{'message': 'Incident Reported'}));

      if (response.statusCode != 200) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Failed to report incident')));
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('Incident Reported')));
      }
    } catch (e) {
      debugPrint('Error reporting incident: $e');
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to report incident')));
    }
  }

  Future<void> _fetchNearbyAlerts() async {
    //Implementation for fetching nearby alerts. Replace with actual code.
    try {
      final response = await http
          .get(Uri.parse('https://jaylou-backend.onrender.com/api/map/nearby'));
      if (response.statusCode != 200) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Failed to load nearby alerts')));
      }
    } catch (e) {
      debugPrint('Error fetching nearby alerts: $e');
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to load nearby alerts')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Heatmap'),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : heatmapData != null
              ? Center(
                  child: Text('Heatmap data: $heatmapData'),
                )
              : const Center(child: Text('No heatmap data available.')),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _reportIncident(context),
        tooltip: 'Report Incident',
        child: const Icon(Icons.report),
      ),
    );
  }
}
