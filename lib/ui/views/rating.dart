import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class RatingPage extends StatefulWidget {
  final String userId;

  const RatingPage({super.key, required this.userId});

  @override
  _RatingPageState createState() => _RatingPageState();
}

class _RatingPageState extends State<RatingPage> {
  double _rating = 3;
  bool _hasRated = false;
  String _message = '';
  bool _isLoading = false;
  bool _checkingPreviousRating = true;

  @override
  void initState() {
    super.initState();
    // Check if user has already rated when page loads
    _checkPreviousRating();
  }

  // Check if user has already submitted a rating
  Future<void> _checkPreviousRating() async {
    setState(() {
      _checkingPreviousRating = true;
    });

    final url = Uri.parse("https://jaylou-backend.onrender.com/api/rate-app");

    try {
      // We're using a POST request with the user_id to check if they've already rated
      // In a real app, you might want a separate GET endpoint for this check
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "user_id": widget.userId,
          "stars": 0, // Dummy value that will be rejected by backend validation
        }),
      );

      final data = jsonDecode(response.body);

      // If we get a 409 conflict error, user has already rated
      if (response.statusCode == 409) {
        setState(() {
          _hasRated = true;
          _message = data["message"] ?? "You have already rated the app.";
        });
      }
    } catch (e) {
      // If check fails, we'll still allow rating but might get rejected on submit
      setState(() {
        _message = "";
      });
    } finally {
      setState(() {
        _checkingPreviousRating = false;
      });
    }
  }

  Future<void> submitRating() async {
    setState(() {
      _isLoading = true;
      _message = '';
    });

    final url = Uri.parse("https://jaylou-backend.onrender.com/api/rate-app");

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "user_id": widget.userId,
          "stars": _rating.toInt(),
        }),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        setState(() {
          _hasRated = true;
          _message = "Thanks for your feedback!";
        });
      } else {
        setState(() {
          if (response.statusCode == 409) {
            _hasRated = true;
            _message = data["message"] ?? "You have already rated the app.";
          } else {
            _message =
                data["message"] ?? "An error occurred. Please try again.";
          }
        });
      }
    } catch (e) {
      setState(() {
        _message = "Connection error. Please try again.";
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text(
          "Rate Our App",
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(20),
          width: double.infinity,
          child: Column(
            children: [
              const SizedBox(height: 20),
              Expanded(
                child: Card(
                  elevation: 4,
                  shadowColor: Colors.black26,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: _checkingPreviousRating
                      ? _buildLoadingState()
                      : AnimatedSwitcher(
                          duration: const Duration(milliseconds: 300),
                          child: _hasRated
                              ? _buildThankYouMessage()
                              : _buildRatingForm(),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            color: Color(0xFF5271FF),
          ),
          SizedBox(height: 16),
          Text(
            "Checking rating status...",
            style: TextStyle(
              color: Color(0xFF6E6E6E),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRatingForm() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 30),
      width: double.infinity,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Header illustration
          Image.asset(
            'assets/images/feedback.png', // Add an image to your assets
            height: 120,
            width: 120,
            errorBuilder: (context, error, stackTrace) => const Icon(
              Icons.rate_review_rounded,
              size: 80,
              color: Color(0xFF5271FF),
            ),
          ),
          const SizedBox(height: 24),

          // Title
          const Text(
            "How's your experience?",
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: Color(0xFF303030),
            ),
          ),

          const SizedBox(height: 8),

          // Subtitle
          const Text(
            "Your feedback helps us improve",
            style: TextStyle(
              fontSize: 16,
              color: Color(0xFF6E6E6E),
              fontWeight: FontWeight.w400,
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 28),

          // Rating bar
          RatingBar.builder(
            initialRating: 3,
            minRating: 1,
            maxRating: 5,
            glow: false,
            allowHalfRating: false,
            itemSize: 48,
            unratedColor: Colors.grey[300],
            itemBuilder: (context, _) => const Icon(
              Icons.star_rounded,
              color: Color(0xFFFFC319),
            ),
            onRatingUpdate: (rating) => _rating = rating,
          ),

          const SizedBox(height: 40),

          // Text indicating one-time rating
          const Text(
            "You can only rate the app once",
            style: TextStyle(
              fontSize: 14,
              color: Color(0xFF6E6E6E),
              fontStyle: FontStyle.italic,
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 16),

          // Submit button
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              onPressed: _isLoading ? null : submitRating,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF5271FF),
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                disabledBackgroundColor:
                    const Color(0xFF5271FF).withOpacity(0.6),
              ),
              child: _isLoading
                  ? const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2.5,
                      ),
                    )
                  : const Text(
                      "Submit",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
            ),
          ),

          if (_message.isNotEmpty) ...[
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
              decoration: BoxDecoration(
                color: Colors.red.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.red.shade200),
              ),
              child: Text(
                _message,
                style: TextStyle(
                  color: Colors.red.shade700,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],

          const Spacer(),

          // Skip option
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              "Maybe later",
              style: TextStyle(
                color: Color(0xFF6E6E6E),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildThankYouMessage() {
    final bool isErrorMessage = _message != "Thanks for your feedback!";

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Success or info icon
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: isErrorMessage
                  ? const Color(0xFFFFF3E0) // Light orange for warning
                  : const Color(0xFFE9F2FF), // Light blue for success
              borderRadius: BorderRadius.circular(50),
            ),
            child: Icon(
              isErrorMessage
                  ? Icons.info_outline_rounded
                  : Icons.check_circle_rounded,
              size: 60,
              color: isErrorMessage
                  ? Colors.orange // Orange for warning
                  : const Color(0xFF5271FF), // Blue for success
            ),
          ),

          const SizedBox(height: 24),

          // Thank you or info message
          Text(
            _message,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Color(0xFF303030),
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 16),

          Text(
            isErrorMessage
                ? "You can only submit one rating per user."
                : "We appreciate you taking the time to share your thoughts.",
            style: const TextStyle(
              fontSize: 16,
              color: Color(0xFF6E6E6E),
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 40),

          // Done button
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF5271FF),
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                "Done",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
