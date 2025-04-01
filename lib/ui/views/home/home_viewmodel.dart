// ignore_for_file: use_build_context_synchronously

import 'dart:convert'; // Import for JSON encoding/decoding
import 'dart:io';
import 'package:cacai/ui/views/home/result.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:stacked/stacked.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:http/http.dart' as http; // Import HTTP package
import 'package:logger/logger.dart';
import 'package:image/image.dart' as img;

import '../noinsect.dart';
import 'proccessingpage.dart';

class HomeViewModel extends BaseViewModel {
  final Logger logger = Logger();
  File? filePath;
  String label = "Unknown";
  String description = "";
  List<String> possibleCauses = [];
  List<String> solutions = [];
  List<String> recommendedPesticides = [];
  late Interpreter _interpreter;
  bool isPickingImage = false;

  HomeViewModel() {
    _loadModel();
  }

  get counterLabel => null;

  get isLoading => null;

  Future<void> _loadModel() async {
    try {
      _interpreter = await Interpreter.fromAsset('assets/model.tflite');
      logger.i("Model loaded successfully.");
    } on PlatformException {
      logger.e("Failed to load model.");
    } catch (e) {
      logger.e("Error: $e");
    }
  }

  Future<void> pickImage(ImageSource source, BuildContext context) async {
    if (isPickingImage) return;

    try {
      isPickingImage = true;
      final pickedFile = await ImagePicker().pickImage(source: source);

      if (pickedFile != null) {
        filePath = File(pickedFile.path);
        notifyListeners();

        // ✅ Show Processing Page while analyzing
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const ProcessingPage()),
        );

        // ✅ Step 1: Check if the image contains an insect
        bool isInsectFound = await _checkIfInsectExists(filePath!);

        if (!isInsectFound) {
          // 🛑 Navigate to NoInsectPage if no insect is found
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const NoInsectPage()),
          );
          return;
        }

        // ✅ Step 2: If an insect is found, predict the insect
        await _predictImage(filePath!);

        // ✅ Step 3: Navigate to Results Page after analysis
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => ResultsPage(
              label: label, // The predicted label
              description: description, // The description
              possibleCauses: possibleCauses, // The possible causes
              solutions: solutions, // The solutions
              recommendedPesticides: recommendedPesticides, // The pesticides
              imageFile: filePath!, // The image file
              viewModel: this, // Passing the current viewModel instance
            ),
          ),
        );
      }
    } catch (e) {
      logger.e("Error picking image: $e");
    } finally {
      isPickingImage = false;
    }
  }

  Future<void> _predictImage(File image) async {
    try {
      var input = await _preprocessImage(image);

      var output =
          List.generate(1, (_) => List.filled(14, 0.0)); // Change 9 to 14

      _interpreter.run(input, output);

      List<double> outputList = List<double>.from(output[0]);

      int maxIndex = outputList.indexWhere(
          (value) => value == outputList.reduce((a, b) => a > b ? a : b));

      List<String> labels = [
        "Ants",
        "Aphids",
        "Cacao Fruit Fly",
        "Cacao Mirid Bug",
        "Cacao Weevils Borer",
        "Fungus Gnats",
        "Helopeltis",
        "Mealybugs",
        "Monolepta Beetles",
        "Orgyia Tussock Moth (Caterpillar)",
        "Sap-sucking Bugs",
        "Stem Borer",
        "Stink Bugs",
        "Whiteflies"
      ];

      label = labels[maxIndex]; // ✅ Set label after prediction
      notifyListeners();

      // ✅ Fetch AI-generated description based on the predicted insect
      await _fetchDataFromGemini(label);
    } catch (e) {
      logger.e("Error predicting image: $e");
      label = "Unknown";
      description = "Failed to predict insect.";
    }
    notifyListeners();
  }

  Future<void> _fetchDataFromGemini(String insectName) async {
    final String apiUrl =
        'https://41cc66e8-7337-47db-9bf1-b6d8b2644eeb-00-33j5pxrbyd20z.pike.replit.dev/api/insect-info/$insectName';

    try {
      print("🚀 Fetching data from: $apiUrl");

      final response = await http.get(Uri.parse(apiUrl));

      print("📥 Response Code: ${response.statusCode}");
      print("📥 Response Body: ${response.body}");

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);

        // ✅ Assign data to respective fields correctly
        description = data['description'] ?? "No description available.";
        possibleCauses = List<String>.from(data['possibleCauses'] ?? []);
        solutions = List<String>.from(data['solutions'] ?? []);
        recommendedPesticides =
            List<String>.from(data['recommendedPesticides'] ?? []);
      } else {
        description = "Failed to fetch data: ${response.statusCode}";
      }
    } catch (e) {
      print("❌ Error: $e");
      description = "Error connecting to backend: $e";
    }
    notifyListeners();
  }

  Future<bool> _checkIfInsectExists(File image) async {
    const String apiUrl =
        'https://41cc66e8-7337-47db-9bf1-b6d8b2644eeb-00-33j5pxrbyd20z.pike.replit.dev/api/detect-insect';

    try {
      print("🚀 Checking if the image contains an insect...");

      var request = http.MultipartRequest('POST', Uri.parse(apiUrl));
      request.files.add(await http.MultipartFile.fromPath('image', image.path));

      var response = await request.send();
      var responseBody = await response.stream.bytesToString();

      print("📥 Response: $responseBody");

      if (response.statusCode == 200) {
        var data = jsonDecode(responseBody);
        return data['isInsect'] ?? false;
      } else {
        print("❌ Failed to check for insect: ${response.statusCode}");
        return false;
      }
    } catch (e) {
      print("❌ Error checking for insect: $e");
      return false;
    }
  }

  Future<List<List<List<List<double>>>>> _preprocessImage(File image) async {
    final bytes = await image.readAsBytes();
    img.Image? originalImage = img.decodeImage(bytes);

    if (originalImage == null) {
      logger.e("Failed to decode image.");
      return [];
    }

    img.Image resizedImage =
        img.copyResize(originalImage, width: 224, height: 224);

    List<List<List<List<double>>>> inputList = List.generate(
      1,
      (i) => List.generate(
        224,
        (j) => List.generate(
          224,
          (k) {
            final pixel = resizedImage.getPixel(k, j);
            final r = pixel.r / 255.0;
            final g = pixel.g / 255.0;
            final b = pixel.b / 255.0;

            return [r, g, b];
          },
        ),
      ),
    );

    return inputList;
  }

  void incrementCounter() {}

  void showBottomSheet() {}
}
