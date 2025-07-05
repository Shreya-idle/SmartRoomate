import 'package:flutter/material.dart';
import '../utils/app_theme.dart';
import '../services/sensor_service.dart';
import '../models/match_model.dart';

class MeetupScreen extends StatefulWidget {
  final MatchModel match;

  const MeetupScreen({super.key, required this.match});

  @override
  _MeetupScreenState createState() => _MeetupScreenState();
}

class _MeetupScreenState extends State<MeetupScreen> {
  final SensorService _sensorService = SensorService();
  bool _isLocationShared = false;
  bool _isMeetupActive = false;
  String _meetupLocation = ''; // Format: "lat,lon" (e.g., "40.7128,-74.0060")
  DateTime? _meetupTime;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Meet ${widget.match.user.name}'),
        backgroundColor: AppTheme.primaryColor,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildMeetupCard(),
            SizedBox(height: 16),
            _buildLocationSection(),
            SizedBox(height: 16),
            _buildSafetySection(),
            SizedBox(height: 16),
            _buildActionButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildMeetupCard() {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: AppTheme.primaryColor,
                  child: Text(
                    widget.match.user.name[0].toUpperCase(),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.match.user.name,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '${widget.match.compatibilityScore}% match',
                        style: TextStyle(
                          color: AppTheme.primaryColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        widget.match.user.location,
                        style: TextStyle(
                          color: AppTheme.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            Text(
              'Meetup Details',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            if (_meetupTime != null && _meetupLocation.isNotEmpty) ...[
              Row(
                children: [
                  Icon(Icons.access_time, color: AppTheme.primaryColor),
                  SizedBox(width: 8),
                  Text('${_meetupTime!.day}/${_meetupTime!.month} at ${_meetupTime!.hour}:${_meetupTime!.minute.toString().padLeft(2, '0')}'),
                ],
              ),
              SizedBox(height: 8),
              Row(
                children: [
                  Icon(Icons.location_on, color: AppTheme.primaryColor),
                  SizedBox(width: 8),
                  Expanded(child: Text('Location: $_meetupLocation')),
                ],
              ),
            ] else ...[
              Text(
                'No meetup scheduled yet',
                style: TextStyle(color: AppTheme.textSecondary),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildLocationSection() {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Safe Location Sharing',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Share your location temporarily during the meetup for safety.',
              style: TextStyle(color: AppTheme.textSecondary),
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Location Sharing'),
                Switch(
                  value: _isLocationShared,
                  onChanged: (value) {
                    setState(() {
                      _isLocationShared = value;
                    });
                    if (value) {
                      _startLocationSharing();
                    } else {
                      _stopLocationSharing();
                    }
                  },
                  activeColor: AppTheme.primaryColor,
                ),
              ],
            ),
            if (_isLocationShared) ...[
              SizedBox(height: 8),
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(Icons.check_circle, color: Colors.green),
                    SizedBox(width: 8),
                    Text(
                      'Location shared with ${widget.match.user.name}',
                      style: TextStyle(color: Colors.green.shade700),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildSafetySection() {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Safety Tips',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            _buildSafetyTip('Meet in a public place'),
            _buildSafetyTip('Let someone know your plans'),
            _buildSafetyTip('Keep emergency contacts handy'),
            _buildSafetyTip('Trust your instincts'),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                _showEmergencyContacts();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                minimumSize: Size(double.infinity, 40),
              ),
              child: Text('Emergency Contacts'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSafetyTip(String tip) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(Icons.check, color: Colors.green, size: 16),
          SizedBox(width: 8),
          Expanded(child: Text(tip)),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Column(
      children: [
        ElevatedButton(
          onPressed: _isMeetupActive ? null : _scheduleMeetup,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppTheme.primaryColor,
            minimumSize: Size(double.infinity, 50),
          ),
          child: Text('Schedule Meetup'),
        ),
        SizedBox(height: 12),
        if (_isMeetupActive) ...[
          ElevatedButton(
            onPressed: _confirmMeetup,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              minimumSize: Size(double.infinity, 50),
            ),
            child: Text('Confirm Meetup'),
          ),
          SizedBox(height: 12),
        ],
        OutlinedButton(
          onPressed: () {
            Navigator.pushNamed(context, '/chat');
          },
          style: OutlinedButton.styleFrom(
            minimumSize: Size(double.infinity, 50),
          ),
          child: Text('Send Message'),
        ),
      ],
    );
  }

  void _startLocationSharing() async {
    try {
      await _sensorService.startLocationTracking();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Location sharing started')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to start location sharing')),
      );
    }
  }

  void _stopLocationSharing() {
    _sensorService.stopLocationTracking();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Location sharing stopped')),
    );
  }

  void _scheduleMeetup() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Schedule Meetup'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              decoration: InputDecoration(
                labelText: 'Meeting Location (lat,lon)',
                hintText: 'e.g., 40.7128,-74.0060',
              ),
              onChanged: (value) {
                _meetupLocation = value;
              },
            ),
            SizedBox(height: 16),
            ListTile(
              leading: Icon(Icons.access_time),
              title: Text('Select Time'),
              onTap: () async {
                final time = await showTimePicker(
                  context: context,
                  initialTime: TimeOfDay.now(),
                );
                if (time != null) {
                  setState(() {
                    _meetupTime = DateTime.now().copyWith(
                      hour: time.hour,
                      minute: time.minute,
                    );
                  });
                }
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (_meetupLocation.isNotEmpty) {
                setState(() {
                  _isMeetupActive = true;
                });
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Meetup scheduled!')),
                );
              }
            },
            child: Text('Schedule'),
          ),
        ],
      ),
    );
  }

  void _confirmMeetup() async {
    try {
      final coords = _meetupLocation.split(',');
      if (coords.length != 2) {
        throw Exception('Invalid location format. Use lat,lon (e.g., 40.7128,-74.0060)');
      }
      final double meetupLat = double.parse(coords[0]);
      final double meetupLon = double.parse(coords[1]);
      bool isPresent = await _sensorService.confirmPresence(meetupLat, meetupLon);
      if (isPresent) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Meetup confirmed! Both parties are present.')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('You are not at the meetup location.')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to confirm meetup: $e')),
      );
    }
  }

  void _showEmergencyContacts() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Emergency Contacts'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.call),
              title: Text('Emergency Services'),
              subtitle: Text('911'),
              onTap: () {
                // Call emergency services
              },
            ),
            ListTile(
              leading: Icon(Icons.person),
              title: Text('Trusted Contact'),
              subtitle: Text('Add emergency contact'),
              onTap: () {
                // Add emergency contact
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Close'),
          ),
        ],
      ),
    );
  }
}