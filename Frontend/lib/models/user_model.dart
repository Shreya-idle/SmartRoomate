// user_model.dart
class UserModel {
  final String id;
  final String name;
  final int age;
  final String occupation;
  final String email;
  final String bio;
  final String? profileImage; // Made nullable and added getter
  final double rating;
  final bool isVerified;
  final UserPreferences preferences;
  final List<String> interests;
  final String location;

  UserModel({
    required this.id,
    required this.name,
    required this.age,
    required this.occupation,
    required this.bio,
    this.profileImage, 
    required this.email,
    required this.rating,
    required this.isVerified,
    required this.preferences,
    required this.interests,
    required this.location,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'age': age,
      'occupation': occupation,
      'bio': bio,
      'profileImage': profileImage,
      'rating': rating,
      'isVerified': isVerified,
      'preferences': preferences.toJson(),
      'interests': interests,
      'location': location,
    };
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      name: json['name'],
      age: json['age'],
      occupation: json['occupation'],
      bio: json['bio'],
      profileImage: json['profileImage'],
      email: json['email'],
      rating: json['rating']?.toDouble() ?? 0.0,
      isVerified: json['isVerified'] ?? false,
      preferences: UserPreferences.fromJson(json['preferences']),
      interests: List<String>.from(json['interests'] ?? []),
      location: json['location'] ?? '',
    );
  }
}

class UserPreferences {
  final double budget;
  final String noiseLevel; // 'quiet', 'moderate', 'loud'
  final String lightLevel; // 'dim', 'moderate', 'bright'
  final String socialLevel; // 'introvert', 'mixed', 'extrovert'
  final String cleanlinessLevel; // 'relaxed', 'moderate', 'strict'
  final List<String> dealBreakers;
  final String sleepSchedule; // 'early', 'normal', 'late'
  final bool petsAllowed;
  final bool smokingAllowed;
  final String guestPolicy; // 'never', 'occasionally', 'frequently'

  UserPreferences({
    required this.budget,
    required this.noiseLevel,
    required this.lightLevel,
    required this.socialLevel,
    required this.cleanlinessLevel,
    required this.dealBreakers,
    required this.sleepSchedule,
    required this.petsAllowed,
    required this.smokingAllowed,
    required this.guestPolicy,
  });

  Map<String, dynamic> toJson() {
    return {
      'budget': budget,
      'noiseLevel': noiseLevel,
      'lightLevel': lightLevel,
      'socialLevel': socialLevel,
      'cleanlinessLevel': cleanlinessLevel,
      'dealBreakers': dealBreakers,
      'sleepSchedule': sleepSchedule,
      'petsAllowed': petsAllowed,
      'smokingAllowed': smokingAllowed,
      'guestPolicy': guestPolicy,
    };
  }

  factory UserPreferences.fromJson(Map<String, dynamic> json) {
    return UserPreferences(
      budget: json['budget']?.toDouble() ?? 0.0,
      noiseLevel: json['noiseLevel'] ?? 'moderate',
      lightLevel: json['lightLevel'] ?? 'moderate',
      socialLevel: json['socialLevel'] ?? 'mixed',
      cleanlinessLevel: json['cleanlinessLevel'] ?? 'moderate',
      dealBreakers: List<String>.from(json['dealBreakers'] ?? []),
      sleepSchedule: json['sleepSchedule'] ?? 'normal',
      petsAllowed: json['petsAllowed'] ?? false,
      smokingAllowed: json['smokingAllowed'] ?? false,
      guestPolicy: json['guestPolicy'] ?? 'occasionally',
    );
  }
}