import 'package:flutter/material.dart';
import '../utils/app_theme.dart';
import '../services/sensor_service.dart';

// Define enums and models
enum VerificationStatus { Verified, Pending, Unverified }

class UserPreferences {
  final int cleanliness;
  final int socialStyle;
  final int noiseLevel;
  final bool petsAllowed;
  final bool smokingAllowed;
  final String sleepSchedule;
  final String budget;
  final String moveInDate;
  final List<String> dealBreakers;

  UserPreferences({
    required this.cleanliness,
    required this.socialStyle,
    required this.noiseLevel,
    required this.petsAllowed,
    required this.smokingAllowed,
    required this.sleepSchedule,
    required this.budget,
    required this.moveInDate,
    required this.dealBreakers,
  });
}

class RoomDimensions {
  final double length;
  final double width;
  final double height;
  double get area => length * width;

  RoomDimensions({
    required this.length,
    required this.width,
    required this.height,
  });
}

class RoomModel {
  final String id;
  final String title;
  final String description;
  final double rent;
  final String location;
  final RoomDimensions dimensions;
  final List<String> amenities;
  final List<String> images;
  final double noiseLevel;
  final int lightLevel;
  final String ownerId;
  final bool isAvailable;
  final DateTime createdAt;

  RoomModel({
    required this.id,
    required this.title,
    required this.description,
    required this.rent,
    required this.location,
    required this.dimensions,
    required this.amenities,
    required this.images,
    required this.noiseLevel,
    required this.lightLevel,
    required this.ownerId,
    required this.isAvailable,
    required this.createdAt,
  });
}

class UserModel {
  final String id;
  final String name;
  final String age; // Using String to avoid potential type mismatch; can be int if preferred
  final String email;
  final String bio;
  final String phone;
  final String occupation;
  final String interests; // Using String to align with previous error context
  final UserPreferences preferences;
  final VerificationStatus verificationStatus;
  final String location;
  final String? profileImageUrl; // Changed to match UI code

  UserModel({
    required this.id,
    required this.name,
    required this.age,
    required this.email,
    required this.bio,
    required this.phone,
    required this.occupation,
    required this.interests,
    required this.preferences,
    required this.verificationStatus,
    required this.location,
    this.profileImageUrl,
  });
}

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({super.key});

  @override
  _UserProfileScreenState createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  final SensorService _sensorService = SensorService();
  UserModel? currentUser;
  bool _isVerified = false;
  bool _isScanning = false;
  double _scanProgress = 0.0;
  bool _scanCompleted = false;
  RoomModel? _scannedRoom;

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  void _loadUserProfile() {
    setState(() {
      currentUser = UserModel(
        id: '1',
        name: 'John Doe',
        age: '26',
        email: 'john.doe@example.com',
        bio: 'Software developer looking for a quiet roommate',
        phone: '123-456-7890',
        occupation: 'Software Developer',
        interests: 'Coding, Music, Hiking', // Joined list into a string
        preferences: UserPreferences(
          cleanliness: 4,
          socialStyle: 3,
          noiseLevel: 2,
          petsAllowed: true,
          smokingAllowed: false,
          sleepSchedule: '10 PM - 6 AM',
          budget: '\$1200-\$1500',
          moveInDate: '2025-08-01',
          dealBreakers: ['Smoking', 'Loud music after 11 PM'],
        ),
        verificationStatus: VerificationStatus.Verified, // Fixed enum reference
        location: 'Manhattan, NY',
        profileImageUrl: null,
      );
      _isVerified = currentUser!.verificationStatus == VerificationStatus.Verified;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Profile'),
        backgroundColor: AppTheme.primaryColor,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {
              Navigator.pushNamed(context, '/profile-setup');
            },
          ),
        ],
      ),
      body: currentUser == null
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                children: [
                  _buildProfileHeader(),
                  _buildPersonalInfo(),
                  _buildPreferences(),
                  _buildVerificationStatus(),
                  _buildActionButtons(),
                  if (_scanCompleted) _buildResultsSection(),
                ],
              ),
            ),
    );
  }

  Widget _buildProfileHeader() {
    return Container(
      padding: EdgeInsets.all(20),
      color: AppTheme.primaryColor,
      child: Column(
        children: [
          CircleAvatar(
            radius: 50,
            backgroundColor: Colors.white,
            child: currentUser!.profileImageUrl != null
                ? ClipOval(
                    child: Image.network(
                      currentUser!.profileImageUrl!,
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                    ),
                  )
                : Icon(
                    Icons.person,
                    size: 60,
                    color: AppTheme.primaryColor,
                  ),
          ),
          SizedBox(height: 16),
          Text(
            currentUser!.name,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          Text(
            '${currentUser!.age} years old',
            style: TextStyle(
              fontSize: 16,
              color: Colors.white70,
            ),
          ),
          SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.location_on, color: Colors.white70, size: 16),
              SizedBox(width: 4),
              Text(
                currentUser!.location,
                style: TextStyle(color: Colors.white70),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPersonalInfo() {
    return Card(
      margin: EdgeInsets.all(16),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'About Me',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(currentUser!.bio),
            SizedBox(height: 8),
            Text('Phone: ${currentUser!.phone}'),
            Text('Occupation: ${currentUser!.occupation}'),
            Text('Interests: ${currentUser!.interests}'),
            SizedBox(height: 16),
            Text(
              'Scan Progress: ${(_scanProgress * 100).toInt()}%',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppTheme.primaryColor,
              ),
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: _isScanning ? null : _startScan,
                  icon: Icon(Icons.play_arrow),
                  label: Text('Start Scan'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryColor,
                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: _isScanning ? _stopScan : null,
                  icon: Icon(Icons.stop),
                  label: Text('Stop Scan'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPreferences() {
    return Card(
      margin: EdgeInsets.all(16),
      child: Padding(
        padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Preferences',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          Text('Cleanliness: ${currentUser!.preferences.cleanliness}/5'),
          Text('Social Style: ${currentUser!.preferences.socialStyle}/5'),
          Text('Noise Level: ${currentUser!.preferences.noiseLevel}/5'),
          Text('Pets Allowed: ${currentUser!.preferences.petsAllowed ? 'Yes' : 'No'}'),
          Text('Smoking Allowed: ${currentUser!.preferences.smokingAllowed ? 'Yes' : 'No'}'),
          Text('Sleep Schedule: ${currentUser!.preferences.sleepSchedule}'),
          Text('Budget: ${currentUser!.preferences.budget}'),
          Text('Move-in Date: ${currentUser!.preferences.moveInDate}'),
          Text('Deal Breakers: ${currentUser!.preferences.dealBreakers.join(', ')}'),
        ],
      ),
    ));
  }

  Widget _buildVerificationStatus() {
    return Card(
      margin: EdgeInsets.all(16),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Verification Status',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Row(
              children: [
                Icon(
                  _isVerified ? Icons.check_circle : Icons.warning,
                  color: _isVerified ? Colors.green : Colors.orange,
                ),
                SizedBox(width: 8),
                Text(
                  _isVerified ? 'Verified' : 'Not Verified',
                  style: TextStyle(
                    fontSize: 16,
                    color: _isVerified ? Colors.green : Colors.orange,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons() {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        children: [
          ElevatedButton(
            onPressed: () {
              Navigator.pushNamed(context, '/listing-creation');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryColor,
              minimumSize: Size(double.infinity, 50),
            ),
            child: Text('Create New Listing'),
          ),
          SizedBox(height: 8),
          OutlinedButton(
            onPressed: () {
              Navigator.pushNamed(context, '/match-results');
            },
            style: OutlinedButton.styleFrom(
              side: BorderSide(color: AppTheme.primaryColor),
              minimumSize: Size(double.infinity, 50),
            ),
            child: Text('View Matches'),
          ),
        ],
      ),
    );
  }

  Widget _buildResultsSection() {
    return Container(
      padding: EdgeInsets.all(16),
      child: Card(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Scan Results',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 16),
              if (_scannedRoom != null) ...[
                _buildResultRow('Room Size', '${_scannedRoom!.dimensions.length}x${_scannedRoom!.dimensions.width} ft'),
                _buildResultRow('Area', '${_scannedRoom!.dimensions.area} sq ft'),
                _buildResultRow('Noise Level', '${_scannedRoom!.noiseLevel} dB'),
                _buildResultRow('Natural Light', '${_scannedRoom!.lightLevel}/5'),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/listing-creation');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryColor,
                    minimumSize: Size(double.infinity, 50),
                  ),
                  child: Text('Create Listing'),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildResultRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: AppTheme.primaryColor,
            ),
          ),
        ],
      ),
    );
  }

  void _startScan() async {
    setState(() {
      _isScanning = true;
      _scanProgress = 0.0;
      _scanCompleted = false;
    });

    try {
      await _sensorService.startARScan();

      // Simulate scanning progress
      for (int i = 0; i <= 100; i++) {
        await Future.delayed(Duration(milliseconds: 50));
        setState(() {
          _scanProgress = i / 100.0;
        });
      }

      // Generate mock scan results
      _scannedRoom = RoomModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: 'Scanned Room',
        description: 'Auto-generated room description',
        rent: 1200,
        location: 'Manhattan, NY',
        dimensions: RoomDimensions(
          length: 12.5,
          width: 10.0,
          height: 9.0,
        ),
        amenities: ['Natural Light', 'Quiet Area'],
        images: [],
        noiseLevel: 35,
        lightLevel: 4,
        ownerId: currentUser!.id,
        isAvailable: true,
        createdAt: DateTime.now(),
      );

      setState(() {
        _isScanning = false;
        _scanCompleted = true;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Room scan completed successfully!')),
      );
    } catch (e) {
      setState(() {
        _isScanning = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Scan failed: ${e.toString()}')),
      );
    }
  }

  void _stopScan() {
    setState(() {
      _isScanning = false;
      _scanProgress = 0.0;
      _scanCompleted = false;
    });
    _sensorService.stopARScan();
  }
}

class ScanningOverlayPainter extends CustomPainter {
  final double progress;

  ScanningOverlayPainter(this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.blue.withOpacity(0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width / 2) * progress;

    canvas.drawCircle(center, radius, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}