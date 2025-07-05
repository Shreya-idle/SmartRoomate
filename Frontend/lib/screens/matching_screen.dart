import 'package:flutter/material.dart';
import '../models/user_model.dart';

class MatchCard extends StatelessWidget {
  final UserModel user;
  final VoidCallback onSwipeLeft;
  final VoidCallback onSwipeRight;

  const MatchCard({
    super.key,
    required this.user,
    required this.onSwipeLeft,
    required this.onSwipeRight,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.85,
      height: MediaQuery.of(context).size.height * 0.6,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Profile image or placeholder
          ClipRRect(
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            child: user.profileImage != null
                ? Image.network(
                    user.profileImage!,
                    height: 200,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      height: 200,
                      color: Colors.grey[300],
                      child: Icon(Icons.person, size: 100, color: Colors.grey[600]),
                    ),
                  )
                : Container(
                    height: 200,
                    color: Colors.grey[300],
                    child: Icon(Icons.person, size: 100, color: Colors.grey[600]),
                  ),
          ),
          // User details
          Positioned(
            top: 220,
            left: 16,
            right: 16,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user.name,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF667eea),
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Age: ${user.age}',
                  style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                ),
                Text(
                  'Occupation: ${user.occupation}',
                  style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                ),
                Text(
                  'Budget: \$${user.preferences.budget}',
                  style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                ),
                SizedBox(height: 8),
                Text(
                  user.bio,
                  style: TextStyle(fontSize: 14, color: Colors.grey[800]),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          // Swipe indicators
          Positioned(
            bottom: 16,
            left: 16,
            child: GestureDetector(
              onTap: onSwipeLeft,
              child: Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.red[100],
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.close, color: Colors.red, size: 24),
              ),
            ),
          ),
          Positioned(
            bottom: 16,
            right: 16,
            child: GestureDetector(
              onTap: onSwipeRight,
              child: Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.green[100],
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.favorite, color: Colors.green, size: 24),
              ),
            ),
          ),
        ],
      ),
    );
  }
}