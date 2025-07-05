import 'package:flutter/material.dart';
import '../models/match_model.dart';
import '../utils/app_theme.dart';

class MatchDetailsScreen extends StatelessWidget {
  final MatchModel match;

  const MatchDetailsScreen({super.key, required this.match});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Match Details'),
        backgroundColor: AppTheme.primaryColor,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildHeader(context),
            _buildCompatibilityScore(context),
            _buildScoreBreakdown(context),
            _buildMatchReasons(context),
            _buildPotentialIssues(context),
            _buildAIInsights(context),
            _buildRoomDetails(context),
            _buildActionButtons(context),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppTheme.primaryColor, AppTheme.secondaryColor],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 40,
            backgroundImage: match.user.profileImage != null 
              ? NetworkImage(match.user.profileImage!)
              : null,
            child: match.user.profileImage == null 
              ? Icon(Icons.person, size: 40, color: Colors.grey[600])
              : null,
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  match.user.name,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Text(
                  '${match.user.age} • ${match.user.occupation}',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white.withOpacity(0.9),
                  ),
                ),
                SizedBox(height: 4),
                Row(
                  children: [
                    Icon(Icons.star, color: Colors.yellow, size: 16),
                    Text(
                      ' ${match.user.rating.toStringAsFixed(1)}',
                      style: TextStyle(color: Colors.white),
                    ),
                    SizedBox(width: 16),
                    if (match.user.isVerified)
                      Row(
                        children: [
                          Icon(Icons.verified, color: Colors.green, size: 16),
                          Text(
                            ' Verified',
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCompatibilityScore(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(16),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            'Compatibility Score',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          SizedBox(height: 16),
          Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: 120,
                height: 120,
                child: CircularProgressIndicator(
                  value: match.compatibilityScore,
                  strokeWidth: 8,
                  backgroundColor: Colors.grey[300],
                  valueColor: AlwaysStoppedAnimation<Color>(
                    match.compatibilityScore > 0.8 ? Colors.green :
                    match.compatibilityScore > 0.6 ? Colors.orange : Colors.red,
                  ),
                ),
              ),
              Text(
                '${(match.compatibilityScore * 100).toInt()}%',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textPrimary,
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          Text(
            _getCompatibilityText(match.compatibilityScore),
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  String _getCompatibilityText(double score) {
    if (score > 0.8) return 'Excellent match! You share many compatible traits.';
    if (score > 0.6) return 'Good match with some areas to discuss.';
    return 'Moderate match. Consider discussing key differences.';
  }

  Widget _buildScoreBreakdown(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Compatibility Breakdown',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          SizedBox(height: 16),
          ...match.scoreBreakdown.entries.map((entry) {
            return _buildScoreBar(entry.key, entry.value);
          }),
        ],
      ),
    );
  }

  Widget _buildScoreBar(String label, double value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label.replaceAll('_', ' ').toUpperCase(),
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.textSecondary,
                ),
              ),
              Text(
                '${(value * 100).toInt()}%',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textPrimary,
                ),
              ),
            ],
          ),
          SizedBox(height: 4),
          LinearProgressIndicator(
            value: value,
            backgroundColor: Colors.grey[300],
            valueColor: AlwaysStoppedAnimation<Color>(
              value > 0.8 ? Colors.green :
              value > 0.6 ? Colors.orange : Colors.red,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMatchReasons(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(16),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.green.shade50,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.green.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.check_circle, color: Colors.green),
              SizedBox(width: 8),
              Text(
                'Why You Match',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: Colors.green.shade800,
                ),
              ),
            ],
          ),
          SizedBox(height: 12),
          ...match.matchReasons.map((reason) {
            return Padding(
              padding: EdgeInsets.symmetric(vertical: 4),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.check, size: 16, color: Colors.green),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      reason,
                      style: TextStyle(color: Colors.green.shade800),
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildPotentialIssues(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.orange.shade50,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.orange.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.warning, color: Colors.orange),
              SizedBox(width: 8),
              Text(
                'Points to Discuss',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: Colors.orange.shade800,
                ),
              ),
            ],
          ),
          SizedBox(height: 12),
          ...match.potentialIssues.map((issue) {
            return Padding(
              padding: EdgeInsets.symmetric(vertical: 4),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.info, size: 16, color: Colors.orange),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      issue,
                      style: TextStyle(color: Colors.orange.shade800),
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildAIInsights(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.blue.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.lightbulb, color: Colors.blue),
              SizedBox(width: 8),
              Text(
                'AI Insights',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: Colors.blue.shade800,
                ),
              ),
            ],
          ),
          SizedBox(height: 12),
          ...match.aiInsights.map((insight) {
            return Padding(
              padding: EdgeInsets.symmetric(vertical: 4),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.auto_awesome, size: 16, color: Colors.blue),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      insight as String,
                      style: TextStyle(color: Colors.blue.shade800),
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildRoomDetails(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(16),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Room Details',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          SizedBox(height: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              match.room.images.first,
              height: 200,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                height: 200,
                color: Colors.grey[300],
                child: Icon(Icons.home, size: 100, color: Colors.grey[600]),
              ),
            ),
          ),
          SizedBox(height: 16),
          Text(
            match.room.title,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          SizedBox(height: 8),
          Row(
            children: [
              Icon(Icons.location_on, size: 16, color: AppTheme.textSecondary),
              SizedBox(width: 4),
              Text(
                match.room.location,
                style: TextStyle(color: AppTheme.textSecondary),
              ),
            ],
          ),
          SizedBox(height: 8),
          Row(
            children: [
              Icon(Icons.attach_money, size: 16, color: AppTheme.textSecondary),
              SizedBox(width: 4),
              Text(
                '\$${match.room.rent.toStringAsFixed(0)}/month',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.primaryColor,
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          Text(
            'Sensor Data',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: _buildSensorCard(
                  'Noise Level',
                  '${match.room.sensorData.noiseLevel.toStringAsFixed(1)} dB',
                  Icons.volume_down,
                  Colors.blue,
                ),
              ),
              SizedBox(width: 8),
              Expanded(
                child: _buildSensorCard(
                  'Light Level',
                  '${match.room.sensorData.lightLevel.toStringAsFixed(0)} lux',
                  Icons.wb_sunny,
                  Colors.yellow,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSensorCard(String label, String value, IconData icon, Color color) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: AppTheme.textSecondary,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: AppTheme.textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: () => Navigator.pop(context),
              style: OutlinedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 16),
                side: BorderSide(color: AppTheme.primaryColor),
              ),
              child: Text('Maybe Later'),
            ),
          ),
          SizedBox(width: 16),
          Expanded(
            child: ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/chat');
              },
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 16),
              ),
              child: Text('Start Chat'),
            ),
          ),
        ],
      ),
    );
  }
}