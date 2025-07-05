import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/match_model.dart';
import '../utils/app_theme.dart';

class MatchDetailsScreen extends StatelessWidget {
  const MatchDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final MatchModel match = ModalRoute.of(context)?.settings.arguments as MatchModel;

    return Scaffold(
      appBar: AppBar(
        title: Text('Match Details'),
        backgroundColor: AppTheme.primaryColor,
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              match.user.name,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppTheme.primaryColor,
              ),
            ),
            SizedBox(height: 8),
            Text('Age: ${match.user.age}'),
            Text('Occupation: ${match.user.occupation}'),
            Text('Budget: ${match.user.preferences.budget}'),
            Text('Bio: ${match.user.bio}'),
            SizedBox(height: 16),
            Text(
              'Room: ${match.room.title}',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text('Rent: \$${match.room.rent}'),
            Text('Location: ${match.room.location}'),
            SizedBox(height: 16),
            Text(
              'Compatibility Score: ${(match.compatibilityScore * 100).toStringAsFixed(0)}%',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text('Reasons for Match:', style: TextStyle(fontWeight: FontWeight.bold)),
            ...match.matchReasons.map((reason) => Text('• $reason')),
            SizedBox(height: 8),
            Text('Potential Issues:', style: TextStyle(fontWeight: FontWeight.bold)),
            ...match.potentialIssues.map((issue) => Text('• $issue')),
            Spacer(),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(
                  context,
                  '/chat',
                  arguments: match,
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryColor,
                padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
              ),
              child: Text('Start Chat'),
            ),
          ],
        ),
      ),
    );
  }
}

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _controller = TextEditingController();
  bool _isLoading = false;

  Future<void> _completeOnboarding() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final response = await http.post(
        Uri.parse('http://localhost:3000/api/onboarding'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'userId': '1', // Replace with actual user ID (e.g., from Firebase Auth)
          'conversation': _controller.text,
        }),
      );
      if (response.statusCode == 200) {
        Navigator.pushReplacementNamed(context, '/profile-setup');
      } else {
        throw Exception('Failed to complete onboarding');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Welcome to Smart Roomie'),
        backgroundColor: AppTheme.primaryColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.home, size: 80, color: AppTheme.primaryColor),
            const SizedBox(height: 32),
            const Text(
              'Find your perfect roommate and room!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            const Text(
              'Tell us about your preferences (e.g., cleanliness, pets, noise tolerance):',
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _controller,
              maxLines: 5,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'E.g., I prefer a quiet space, no pets, budget \$1000-\$1500',
              ),
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: _isLoading ? null : _completeOnboarding,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryColor,
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
              ),
              child: _isLoading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text('Get Started'),
            ),
          ],
        ),
      ),
    );
  }
}