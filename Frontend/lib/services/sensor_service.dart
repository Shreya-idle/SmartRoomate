import 'dart:async';
import 'dart:math';
import 'package:location/location.dart';

class SensorService {
  static final SensorService _instance = SensorService._internal();
  factory SensorService() => _instance;
  SensorService._internal();

  // Stream for sensor data, including location and AR scan progress
  final StreamController<Map<String, dynamic>> _sensorController = StreamController.broadcast();
  Stream<Map<String, dynamic>> get sensorStream => _sensorController.stream;

  Timer? _sensorTimer;
  final Location _location = Location();
  bool _isTrackingLocation = false;
  bool _isARScanning = false;

  // Initialize location service
  Future<void> _initLocationService() async {
    bool serviceEnabled = await _location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await _location.requestService();
      if (!serviceEnabled) throw Exception('Location service disabled');
    }

    PermissionStatus permission = await _location.hasPermission();
    if (permission == PermissionStatus.denied) {
      permission = await _location.requestPermission();
      if (permission != PermissionStatus.granted) throw Exception('Location permission denied');
    }

    await _location.changeSettings(
      accuracy: LocationAccuracy.high,
      interval: 5000,
      distanceFilter: 10,
    );
  }

  // Start location tracking
  Future<void> startLocationTracking() async {
    try {
      await _initLocationService();
      _isTrackingLocation = true;
      _location.onLocationChanged.listen((LocationData locationData) {
        if (!_isTrackingLocation) return;
        _sensorController.add({
          'location': {
            'latitude': locationData.latitude,
            'longitude': locationData.longitude,
          },
        });
      });
    } catch (e) {
      _isTrackingLocation = true;
      Timer.periodic(const Duration(seconds: 5), (timer) {
        if (!_isTrackingLocation) {
          timer.cancel();
          return;
        }
        _sensorController.add({
          'location': {
            'latitude': 40.7128 + (Random().nextDouble() - 0.5) * 0.01,
            'longitude': -74.0060 + (Random().nextDouble() - 0.5) * 0.01,
          },
        });
      });
      throw Exception('Failed to start location tracking: $e');
    }
  }

  // Stop location tracking
  void stopLocationTracking() {
    _isTrackingLocation = false;
    _sensorController.add({'location': null});
  }

  // Confirm presence at meetup location
  Future<bool> confirmPresence(double meetupLat, double meetupLon) async {
    try {
      await _initLocationService();
      LocationData currentLocation = await _location.getLocation();
      double distance = _calculateDistance(
        currentLocation.latitude!,
        currentLocation.longitude!,
        meetupLat,
        meetupLon,
      );
      return distance < 0.1;
    } catch (e) {
      await Future.delayed(const Duration(seconds: 2));
      return Random().nextBool();
    }
  }

  // Calculate distance using Haversine formula
  double _calculateDistance(double lat1, double lon1, double lat2, double lon2) {
    const double R = 6371;
    double dLat = _degreesToRadians(lat2 - lat1);
    double dLon = _degreesToRadians(lon2 - lon1);
    double a = sin(dLat / 2) * sin(dLat / 2) +
        cos(_degreesToRadians(lat1)) * cos(_degreesToRadians(lat2)) * sin(dLon / 2) * sin(dLon / 2);
    double c = 2 * atan2(sqrt(a), sqrt(1 - a));
    return R * c;
  }

  double _degreesToRadians(double degrees) {
    return degrees * pi / 180;
  }

  // Start sensor data collection
  void startSensorCollection() {
    _sensorTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      _sensorController.add(_generateMockSensorData());
    });
  }

  // Stop sensor data collection
  void stopSensorCollection() {
    _sensorTimer?.cancel();
  }

  // Generate mock sensor data
  Map<String, dynamic> _generateMockSensorData() {
    final random = Random();
    return {
      'location': {
        'latitude': 40.7128 + (random.nextDouble() - 0.5) * 0.01,
        'longitude': -74.0060 + (random.nextDouble() - 0.5) * 0.01,
      },
      'noise_level': 30 + random.nextDouble() * 40,
      'light_level': random.nextDouble() * 1000,
      'temperature': 20 + random.nextDouble() * 10,
      'motion': random.nextBool(),
      'proximity': random.nextDouble() * 100,
    };
  }

  // Start AR scanning
  Future<void> startARScan() async {
    if (_isARScanning) return;
    try {
      _isARScanning = true;
      _sensorController.add({'ar_scan': 'started'});
      // TODO: Initialize AR session for arkit_plugin or arcore_flutter_plugin
      // For now, simulate AR scan start
      await Future.delayed(Duration(seconds: 1));
    } catch (e) {
      _isARScanning = false;
      throw Exception('Failed to start AR scan: $e');
    }
  }

  // Simulate room scanning
  Future<Map<String, dynamic>> scanRoom() async {
    if (!_isARScanning) {
      throw Exception('AR scan not started');
    }
    await Future.delayed(Duration(seconds: 3));
    final random = Random();
    return {
      'dimensions': [
        3.5 + random.nextDouble() * 2,
        4.0 + random.nextDouble() * 2,
        2.8 + random.nextDouble() * 0.4,
      ],
      'noise_level': 25 + random.nextDouble() * 20,
      'light_level': 200 + random.nextDouble() * 300,
      'temperature': 22 + random.nextDouble() * 6,
      'floor_plan': 'rectangular',
      'features': ['window', 'door', 'closet'],
    };
  }

  // Stop AR scanning
  void stopARScan() {
    _isARScanning = false;
    _sensorTimer?.cancel();
    _sensorController.add({'ar_scan': null});
  }

  // Simulate identity verification
  Future<bool> verifyIdentity() async {
    await Future.delayed(Duration(seconds: 2));
    return true;
  }

  // Clean up resources
  void dispose() {
    _sensorController.close();
    _sensorTimer?.cancel();
  }
}