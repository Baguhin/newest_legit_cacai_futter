import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class RatingPage extends StatefulWidget {
  // Make userId optional with a default empty string
  final String userId;

  const RatingPage({super.key, this.userId = ''});

  @override
  _RatingPageState createState() => _RatingPageState();
}

class _RatingPageState extends State<RatingPage> {
  double _rating = 3;
  bool _isSubmitted = false;
  String _message = '';
  bool _isLoading = false;
  String _effectiveUserId = '';

  @override
  void initState() {
    super.initState();
    _initializeUserId();
  }

  // Initialize user ID from props or generate one if not available
  Future<void> _initializeUserId() async {
    if (widget.userId.isNotEmpty) {
      setState(() {
        _effectiveUserId = widget.userId;
      });
    } else {
      // Get stored ID or generate a new one
      final prefs = await SharedPreferences.getInstance();
      String storedId = prefs.getString('user_id') ?? '';

      if (storedId.isEmpty) {
        // Generate a simple unique ID based on timestamp if needed
        storedId = DateTime.now().millisecondsSinceEpoch.toString();
        await prefs.setString('user_id', storedId);
      }

      setState(() {
        _effectiveUserId = storedId;
      });
    }
  }

  Future<void> submitRating() async {
    // Validate user ID
    if (_effectiveUserId.isEmpty) {
      setState(() {
        _message = "User ID is missing. Please try again later.";
      });
      return;
    }

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
          "user_id": _effectiveUserId,
          "stars": _rating.toInt(),
          "allow_multiple":
              true, // Add flag to allow multiple ratings from same user
        }),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        setState(() {
          _isSubmitted = true;
          _message = "Thanks for your feedback!";
        });
      } else {
        setState(() {
          _message = data["message"] ?? "An error occurred. Please try again.";
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

  void resetForm() {
    setState(() {
      _isSubmitted = false;
      _rating = 3;
      _message = '';
    });
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
              // Show the current user ID for debugging (can be removed in production)
              if (_effectiveUserId.isNotEmpty) ...[
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    "User ID: $_effectiveUserId",
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[700],
                    ),
                  ),
                ),
                const SizedBox(height: 12),
              ],
              Expanded(
                child: Card(
                  elevation: 4,
                  shadowColor: Colors.black26,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    child: _isSubmitted
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

          // Updated text showing users can rate multiple times
          const Text(
            "You can provide feedback anytime! We value your ongoing input.",
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
                color: _isSubmitted ? Colors.green.shade50 : Colors.red.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                    color: _isSubmitted
                        ? Colors.green.shade200
                        : Colors.red.shade200),
              ),
              child: Text(
                _message,
                style: TextStyle(
                  color: _isSubmitted
                      ? Colors.green.shade700
                      : Colors.red.shade700,
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
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Success icon
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: const Color(0xFFE9F2FF),
              borderRadius: BorderRadius.circular(50),
            ),
            child: const Icon(
              Icons.check_circle_rounded,
              size: 60,
              color: Color(0xFF5271FF),
            ),
          ),

          const SizedBox(height: 24),

          // Thank you message
          const Text(
            "Thanks for your feedback!",
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Color(0xFF303030),
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 16),

          const Text(
            "We appreciate you taking the time to share your thoughts.",
            style: TextStyle(
              fontSize: 16,
              color: Color(0xFF6E6E6E),
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 40),

          // Buttons row
          Row(
            children: [
              // Rate again button
              Expanded(
                child: SizedBox(
                  height: 52,
                  child: OutlinedButton(
                    onPressed: resetForm,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFF5271FF),
                      side: const BorderSide(color: Color(0xFF5271FF)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      "Rate Again",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(width: 12),

              // Done button
              Expanded(
                child: SizedBox(
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
              ),
            ],
          ),
        ],
      ),
    );
  }
}
