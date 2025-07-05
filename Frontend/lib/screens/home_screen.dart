import 'package:flutter/material.dart';
import '../models/match_model.dart';
import '../models/user_model.dart';
import '../models/room_model.dart';

class RecentMatches extends StatelessWidget {
  const RecentMatches({super.key});

  @override
  Widget build(BuildContext context) {
    // Corrected mock data with proper UserModel and UserPreferences fields
    final mockMatches = [
      MatchModel(
        id: 'match1',
        user: UserModel(
          id: 'user1',
          name: 'John Doe',
          age: 25,
          occupation: 'Software Engineer',
          bio: 'Friendly and tidy engineer looking for a quiet place to study',
          profileImage: null,
          email: 'john@example.com',
          rating: 4.8,
          isVerified: true,
          preferences: UserPreferences(
            budget: 1300.0,
            noiseLevel: 'quiet',
            lightLevel: 'bright',
            socialLevel: 'mixed',
            cleanlinessLevel: 'strict',
            dealBreakers: ['Smoking', 'Loud Music'],
            sleepSchedule: 'late',
            petsAllowed: true,
            smokingAllowed: false,
            guestPolicy: 'occasionally',
          ),
          interests: ['Reading', 'Hiking', 'Gaming'],
          location: 'Manhattan, NY',
        ),
        room: RoomModel(
          id: 'room1',
          title: 'Cozy Downtown Studio',
          description: 'Spacious room with great natural light and city view',
          rent: 1200.0,
          location: 'Manhattan, NY',
          dimensions: RoomDimensions(length: 10, width: 12, height: 8),
          amenities: ['WiFi', 'Parking', 'Gym', 'Laundry'],
          images: [],
          sensorData: SensorData(
            noiseLevel: 35.0,
            lightLevel: 500,
            temperature: 22.5,
            locationAccuracy: 'High',
            measuredAt: DateTime.now(),
          ),
          ownerId: 'owner1',
          isAvailable: true,
          createdAt: DateTime.now(),
          isVerified: true,
        ),
        compatibilityScore: 0.92,
        scoreBreakdown: {
          'lifestyle': 0.85,
          'cleanliness': 0.95,
          'budget': 0.90,
          'location': 0.88,
          'noise_preference': 0.95,
        },
        matchReasons: [
          'Similar sleep schedule preference',
          'Budget perfectly aligns',
          'Room noise level (35dB) matches your quiet preference',
          'Both value cleanliness highly'
        ],
        potentialIssues: [
          'Different social activity levels',
          'Pet preferences need discussion'
        ],
        aiInsights: [
          AIInsight(
            category: 'Lifestyle Compatibility',
            explanation: 'Both prefer quiet environments and value personal space',
            confidence: 0.92,
            supportingFactors: ['Sensor data shows 35dB average', 'Both night owls'],
          ),
          AIInsight(
            category: 'Financial Compatibility',
            explanation: 'Budget ranges overlap perfectly with room rent',
            confidence: 0.95,
            supportingFactors: ['Room: \$1200', 'Budget: \$1000-\$1500'],
          ),
        ],
        matchedAt: DateTime.now(),
        chatId: 'chat_${DateTime.now().millisecondsSinceEpoch}',
      ),
    ];

    return Container(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Recent Smart Matches',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: Color(0xFF667eea),
            ),
          ),
          SizedBox(height: 16),
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: mockMatches.length,
            itemBuilder: (context, index) {
              final match = mockMatches[index];
              return Card(
                elevation: 4,
                margin: EdgeInsets.only(bottom: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  contentPadding: EdgeInsets.all(16),
                  leading: Stack(
                    children: [
                      CircleAvatar(
                        radius: 30,
                        backgroundColor: Color(0xFF667eea),
                        child: Text(
                          match.user.name[0],
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ),
                      if (match.user.isVerified)
                        Positioned(
                          right: 0,
                          bottom: 0,
                          child: Container(
                            padding: EdgeInsets.all(2),
                            decoration: BoxDecoration(
                              color: Colors.green,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.verified,
                              color: Colors.white,
                              size: 16,
                            ),
                          ),
                        ),
                    ],
                  ),
                  title: Row(
                    children: [
                      Text(
                        match.user.name,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(width: 8),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: Color(0xFF667eea).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          '${(match.compatibilityScore * 100).toStringAsFixed(0)}% match',
                          style: TextStyle(
                            color: Color(0xFF667eea),
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 4),
                      Text(
                        'Room: ${match.room.title}',
                        style: TextStyle(fontWeight: FontWeight.w500),
                      ),
                      SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(Icons.volume_down, size: 16, color: Colors.grey[600]),
                          SizedBox(width: 4),
                          Text(
                            '${match.room.sensorData.noiseLevel.toStringAsFixed(0)}dB',
                            style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                          ),
                          SizedBox(width: 16),
                          Icon(Icons.wb_sunny, size: 16, color: Colors.grey[600]),
                          SizedBox(width: 4),
                          Text(
                            '${match.room.sensorData.lightLevel} lux',
                            style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                          ),
                        ],
                      ),
                      if (match.aiInsights.isNotEmpty) ...[
                        SizedBox(height: 8),
                        Container(
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.blue.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'AI Insight:',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                  color: Colors.blue[800],
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                match.aiInsights.first.explanation,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.blue[700],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                  trailing: Icon(
                    Icons.arrow_forward_ios,
                    color: Color(0xFF667eea),
                  ),
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      '/match-details',
                      arguments: match,
                    );
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}