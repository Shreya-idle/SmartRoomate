import 'dart:async';
import 'dart:math';

import '../models/user_model.dart';
import '../models/room_model.dart';
import '../models/match_model.dart';

class AIService {
  static final AIService _instance = AIService._internal();
  factory AIService() => _instance;
  AIService._internal();

  Future<List<MatchModel>> findMatches(UserModel user, List<RoomModel> rooms) async {
    await Future.delayed(Duration(seconds: 2)); // Simulate AI processing

    List<MatchModel> matches = [];
    final random = Random();

    for (var room in rooms) {
      double compatibilityScore = _calculateCompatibilityScore(user, room);

      if (compatibilityScore > 0.6) {
        matches.add(MatchModel(
          id: 'match_${user.id}_${room.id}',
          user: user,
          room: room,
          compatibilityScore: compatibilityScore,
          scoreBreakdown: _generateScoreBreakdown(user, room),
          matchReasons: _generateMatchReasons(user, room),
          potentialIssues: _generatePotentialIssues(user, room),
          matchedAt: DateTime.now(),
          aiInsights: [],
        ));
      }
    }

    matches.sort((a, b) => b.compatibilityScore.compareTo(a.compatibilityScore));
    return matches;
  }

  double _calculateCompatibilityScore(UserModel user, RoomModel room) {
    final random = Random();
    double score = 0.6 + random.nextDouble() * 0.4; // 0.6-1.0

    // Budget compatibility
    if (room.rent <= user.preferences.budget) {
      score += 0.1;
    } else if (room.rent <= user.preferences.budget * 1.1) {
      score += 0.05;
    }

    // Noise level compatibility
    if (user.preferences.noiseLevel == 'quiet' && room.sensorData.noiseLevel < 40) {
      score += 0.1;
    } else if (user.preferences.noiseLevel == 'moderate' &&
        room.sensorData.noiseLevel >= 40 &&
        room.sensorData.noiseLevel < 60) {
      score += 0.1;
    } else if (user.preferences.noiseLevel == 'loud' && room.sensorData.noiseLevel >= 60) {
      score += 0.1;
    }

    return score.clamp(0.0, 1.0);
  }

  Map<String, double> _generateScoreBreakdown(UserModel user, RoomModel room) {
    final random = Random();
    return {
      'lifestyle': 0.7 + random.nextDouble() * 0.3,
      'cleanliness': 0.6 + random.nextDouble() * 0.4,
      'budget': 0.8 + random.nextDouble() * 0.2,
      'location': 0.7 + random.nextDouble() * 0.3,
      'noise_tolerance': 0.6 + random.nextDouble() * 0.4,
    };
  }

  List<String> _generateMatchReasons(UserModel user, RoomModel room) {
    return [
      'Both prefer quiet environments',
      'Similar sleep schedules',
      'Budget compatibility',
      'Shared interest in cleanliness',
      'Compatible social styles',
    ];
  }

  List<String> _generatePotentialIssues(UserModel user, RoomModel room) {
    return [
      'Different work schedules',
      'Pet preferences unclear',
      'Cooking frequency mismatch',
    ];
  }

  Future<String> generateConversationResponse(String userMessage) async {
    await Future.delayed(Duration(seconds: 1));

    // Mock AI responses
    final responses = [
      "That sounds great! I'd love to learn more about your living preferences.",
      "Based on what you've shared, I think we could be compatible roommates.",
      "I appreciate your honesty about your lifestyle. Communication is key!",
      "That's a fair concern. Let's discuss how we can address that.",
      "I'm excited about the possibility of living together!",
    ];

    return responses[Random().nextInt(responses.length)];
  }

  Future<Map<String, dynamic>> generateRoommateAgreement(UserModel user1, UserModel user2) async {
    await Future.delayed(Duration(seconds: 2));

    return {
      'rent_split': '50/50',
      'utilities_split': '50/50',
      'cleaning_schedule': 'Weekly rotation',
      'guest_policy': 'Notify 24 hours in advance',
      'quiet_hours': '10 PM - 8 AM',
      'shared_expenses': 'Groceries, cleaning supplies',
      'pet_policy': 'No pets without mutual agreement',
      'lease_terms': '12 months',
      'security_deposit': 'Split equally',
      'move_out_notice': '30 days',
    };
  }

  Future<String> getConflictResolutionAdvice(String userMessage) async {
    try {
      // Uncomment and configure if you have a real API:
      /*
      final response = await http.post(
        Uri.parse('https://api.x.ai/v1/completions'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer YOUR_XAI_API_KEY',
        },
        body: jsonEncode({
          'prompt': 'Provide conflict resolution advice for the following roommate issue: $userMessage',
          'max_tokens': 150,
          'temperature': 0.7,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['choices'][0]['text'].trim();
      } else {
        throw Exception('API request failed: ${response.statusCode}');
      }
      */
      throw Exception('API not configured');
    } catch (e) {
      // Fallback to mock response
      await Future.delayed(Duration(seconds: 1));
      final mockResponses = [
        "I understand your frustration with $userMessage. Try discussing it calmly with your roommate, suggesting a shared schedule to address this issue.",
        "For issues like $userMessage, consider setting clear expectations together and using a chore chart to ensure fairness.",
        "It sounds challenging to deal with $userMessage. A good approach is to have an open conversation and propose a compromise that works for both.",
        "To resolve $userMessage, try writing down your concerns and discussing them in a neutral setting to find a solution.",
        "Dealing with $userMessage can be tough. Suggest a roommate agreement to clarify responsibilities and prevent future conflicts.",
      ];
      return mockResponses[Random().nextInt(mockResponses.length)];
    }
  }
}