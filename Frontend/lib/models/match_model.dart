import 'user_model.dart';
import 'room_model.dart';

class AIInsight {
  final String category;
  final String explanation;
  final double confidence;
  final List<String> supportingFactors;

  AIInsight({
    required this.category,
    required this.explanation,
    required this.confidence,
    required this.supportingFactors,
  });

  Map<String, dynamic> toJson() => {
    'category': category,
    'explanation': explanation,
    'confidence': confidence,
    'supportingFactors': supportingFactors,
  };

  factory AIInsight.fromJson(Map<String, dynamic> json) => AIInsight(
    category: json['category'],
    explanation: json['explanation'],
    confidence: json['confidence'],
    supportingFactors: List<String>.from(json['supportingFactors']),
  );
}

class MatchModel {
  final String id;
  final UserModel user;
  final RoomModel room;
  final double compatibilityScore;
  final Map<String, double> scoreBreakdown;
  final List<String> matchReasons;
  final List<String> potentialIssues;
  final List<AIInsight> aiInsights;
  final DateTime matchedAt;
  final String? chatId; // For integrated chat functionality

  MatchModel({
    required this.id,
    required this.user,
    required this.room,
    required this.compatibilityScore,
    required this.scoreBreakdown,
    required this.matchReasons,
    required this.potentialIssues,
    required this.aiInsights,
    required this.matchedAt,
    this.chatId,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'user': user.toJson(),
    'room': room.toJson(),
    'compatibilityScore': compatibilityScore,
    'scoreBreakdown': scoreBreakdown,
    'matchReasons': matchReasons,
    'potentialIssues': potentialIssues,
    'aiInsights': aiInsights.map((insight) => insight.toJson()).toList(),
    'matchedAt': matchedAt.toIso8601String(),
    'chatId': chatId,
  };

  factory MatchModel.fromJson(Map<String, dynamic> json) => MatchModel(
    id: json['id'],
    user: UserModel.fromJson(json['user']),
    room: RoomModel.fromJson(json['room']),
    compatibilityScore: json['compatibilityScore'],
    scoreBreakdown: Map<String, double>.from(json['scoreBreakdown']),
    matchReasons: List<String>.from(json['matchReasons']),
    potentialIssues: List<String>.from(json['potentialIssues']),
    aiInsights: (json['aiInsights'] as List)
        .map((insight) => AIInsight.fromJson(insight))
        .toList(),
    matchedAt: DateTime.parse(json['matchedAt']),
    chatId: json['chatId'],
  );
}