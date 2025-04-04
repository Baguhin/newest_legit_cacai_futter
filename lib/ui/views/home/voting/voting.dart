import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PestMapPage extends StatefulWidget {
  const PestMapPage({super.key});

  @override
  State<PestMapPage> createState() => _PestMapPageState();
}

class _PestMapPageState extends State<PestMapPage> {
  Set<Circle> heatmapCircles = {};
  Set<Marker> markers = {};
  bool isLoading = true;

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
        final data = json.decode(response.body);
        setState(() {
          heatmapCircles = _createHeatmapCircles(data);
          isLoading = false;
        });
      }
    } catch (e) {
      debugPrint('Error fetching heatmap data: $e');
    }
  }

  Set<Circle> _createHeatmapCircles(List<dynamic> data) {
    return data.map((point) {
      return Circle(
        circleId: CircleId(point['_id'].toString()),
        center: LatLng(
          point['points'][0]['coordinates'][1],
          point['points'][0]['coordinates'][0],
        ),
        radius: 1000, // meters
        fillColor: Colors.red.withOpacity(0.3),
        strokeWidth: 0,
      );
    }).toSet();
  }

  Future<void> _reportPest(LatLng location) async {
    try {
      await http.post(
        Uri.parse('https://jaylou-backend.onrender.com/api/map/report'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'pestId': '123', // Replace with actual pest ID
          'longitude': location.longitude,
          'latitude': location.latitude,
        }),
      );
      _fetchHeatmapData(); // Refresh map
    } catch (e) {
      debugPrint('Error reporting pest: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pest Map'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _fetchHeatmapData,
          ),
        ],
      ),
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: const CameraPosition(
              target: LatLng(0, 0),
              zoom: 2,
            ),
            circles: heatmapCircles,
            markers: markers,
            onTap: (LatLng location) {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Report Pest'),
                  content: const Text(
                      'Would you like to report a pest at this location?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () {
                        _reportPest(location);
                        Navigator.pop(context);
                      },
                      child: const Text('Report'),
                    ),
                  ],
                ),
              );
            },
          ),
          if (isLoading)
            const Center(
              child: CircularProgressIndicator(),
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Show trend alerts
          showModalBottomSheet(
            context: context,
            builder: (context) => FutureBuilder(
              future: http.get(Uri.parse(
                  'https://jaylou-backend.onrender.com/api/map/nearby')),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }
                final alerts = json.decode(snapshot.data!.body);
                return ListView.builder(
                  itemCount: alerts.length,
                  itemBuilder: (context, index) {
                    final alert = alerts[index];
                    return ListTile(
                      leading: const Icon(Icons.warning),
                      title: Text(alert['title']),
                      subtitle: Text(alert['description']),
                    );
                  },
                );
              },
            ),
          );
        },
        child: const Icon(Icons.notifications),
      ),
    );
  }
}
