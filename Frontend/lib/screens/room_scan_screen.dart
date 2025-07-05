import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../services/sensor_service.dart';
import '../widgets/ar_overlay.dart';

class RoomScanScreen extends StatefulWidget {
  const RoomScanScreen({super.key});

  @override
  _RoomScanScreenState createState() => _RoomScanScreenState();
}

class _RoomScanScreenState extends State<RoomScanScreen>
    with TickerProviderStateMixin {
  final SensorService _sensorService = SensorService();

  late AnimationController _scanController;
  late AnimationController _pulseController;
  late Animation<double> _scanAnimation;
  late Animation<double> _pulseAnimation;

  bool _isScanning = false;
  bool _scanComplete = false;
  final List<String> _measuredFeatures = [];
  Map<String, dynamic> _roomData = {};

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _initializeSensors();
  }

  void _initializeAnimations() {
    _scanController = AnimationController(
      duration: Duration(seconds: 2),
      vsync: this,
    );

    _pulseController = AnimationController(
      duration: Duration(seconds: 1),
      vsync: this,
    );

    _scanAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(
      parent: _scanController,
      curve: Curves.easeInOut,
    ));

    _pulseAnimation = Tween<double>(
      begin: 0.8,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));
  }

  void _initializeSensors() {
    _sensorService.startSensorCollection();
  }

  void _startRoomScan() {
    setState(() {
      _isScanning = true;
      _measuredFeatures.clear();
      _roomData.clear();
    });

    _scanController.forward();
    _pulseController.repeat(reverse: true);

    _simulateRoomScanning();
  }

  void _simulateRoomScanning() {
    final features = [
      'Measuring room dimensions...',
      'Detecting natural light levels...',
      'Analyzing ambient noise...',
      'Mapping furniture layout...',
      'Calculating floor space...',
      'Identifying ventilation...',
      'Measuring ceiling height...',
      'Finalizing room profile...'
    ];

    for (int i = 0; i < features.length; i++) {
      Future.delayed(Duration(milliseconds: 800 * (i + 1)), () {
        if (mounted) {
          setState(() {
            _measuredFeatures.add(features[i]);
          });

          if (i == features.length - 1) {
            _completeScan();
          }
        }
      });
    }
  }

  void _completeScan() async {
    try {
      final roomData = await _sensorService.scanRoom();
      setState(() {
        _isScanning = false;
        _scanComplete = true;
        _roomData = {
          'dimensions': '${roomData['dimensions'][0].toStringAsFixed(1)}x${roomData['dimensions'][1].toStringAsFixed(1)} feet',
          'area': '${(roomData['dimensions'][0] * roomData['dimensions'][1]).toStringAsFixed(1)} sq ft',
          'lightLevel': '${roomData['light_level'].toStringAsFixed(0)} lux',
          'noiseLevel': '${roomData['noise_level'].toStringAsFixed(0)} dB',
          'ceilingHeight': '${roomData['dimensions'][2].toStringAsFixed(1)} feet',
          'windows': roomData['features'].contains('window') ? 1 : 0,
          'naturalLight': roomData['light_level'] > 300 ? 'Excellent' : 'Moderate',
          'ventilation': roomData['features'].contains('window') ? 'Good' : 'Average',
        };
      });
    } catch (e) {
      setState(() {
        _isScanning = false;
        _scanComplete = true;
        _roomData = {
          'error': 'Failed to scan room: $e',
        };
      });
    }
    _scanController.stop();
    _pulseController.stop();
  }

  @override
  void dispose() {
    _scanController.dispose();
    _pulseController.dispose();
    _sensorService.stopSensorCollection();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text('Room Scan'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Stack(
        children: [
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black,
                  Colors.grey[900]!,
                  Colors.black,
                ],
              ),
            ),
            child: CustomPaint(
              painter: RoomScanPainter(
                scanProgress: _scanAnimation.value,
                isScanning: _isScanning,
              ),
            ),
          ),
          AROverlay(
            isScanning: _isScanning,
            scanProgress: _scanAnimation.value,
            roomData: _roomData,
          ),
          if (!_isScanning && !_scanComplete)
            Positioned(
              bottom: 80,
              left: 0,
              right: 0,
              child: Center(
                child: AnimatedBuilder(
                  animation: _pulseAnimation,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: _isScanning ? 1.0 : _pulseAnimation.value,
                      child: GestureDetector(
                        onTap: _startRoomScan,
                        child: Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            color: Color(0xFF667eea),
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Color(0xFF667eea).withOpacity(0.3),
                                blurRadius: 20,
                                spreadRadius: 5,
                              ),
                            ],
                          ),
                          child: Icon(
                            Icons.camera_alt,
                            color: Colors.white,
                            size: 40,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          if (_isScanning)
            Positioned(
              bottom: 100,
              left: 20,
              right: 20,
              child: Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.8),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    LinearProgressIndicator(
                      value: _scanAnimation.value,
                      backgroundColor: Colors.grey[700],
                      valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF667eea)),
                    ),
                    SizedBox(height: 16),
                    ..._measuredFeatures.map((feature) => Padding(
                          padding: EdgeInsets.symmetric(vertical: 2),
                          child: Row(
                            children: [
                              Icon(
                                Icons.check_circle,
                                color: Color(0xFF667eea),
                                size: 16,
                              ),
                              SizedBox(width: 8),
                              Text(
                                feature,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        )),
                    SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF667eea),
                        padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                      ),
                      child: Text(
                        'Create Listing',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          if (_scanComplete)
            Positioned(
              bottom: 100,
              left: 20,
              right: 20,
              child: Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.8),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.check_circle,
                      color: Colors.green,
                      size: 48,
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Room Scan Complete!',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 12),
                    ...(_roomData.entries.map((entry) => Padding(
                          padding: EdgeInsets.symmetric(vertical: 2),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                entry.key,
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 14,
                                ),
                              ),
                              Text(
                                entry.value.toString(),
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ))),
                    SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF667eea),
                        padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                      ),
                      child: Text(
                        'Done',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class RoomScanPainter extends CustomPainter {
  final double scanProgress;
  final bool isScanning;

  RoomScanPainter({
    required this.scanProgress,
    required this.isScanning,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Color(0xFF667eea).withOpacity(0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width, size.height) / 3;

    if (isScanning) {
      for (int i = 0; i < 3; i++) {
        final animatedRadius = radius * (1 + (scanProgress + i * 0.3) % 1);
        final opacity = 1 - ((scanProgress + i * 0.3) % 1);

        paint.color = Color(0xFF667eea).withOpacity(opacity * 0.5);
        canvas.drawCircle(center, animatedRadius, paint);
      }
    }

    paint.color = Color(0xFF667eea);
    paint.strokeWidth = 4;

    final bracketSize = 30.0;
    final corners = [
      Offset(50, 100),
      Offset(size.width - 50, 100),
      Offset(50, size.height - 100),
      Offset(size.width - 50, size.height - 100),
    ];

    for (final corner in corners) {
      if (corner == corners[0]) {
        canvas.drawLine(corner, Offset(corner.dx + bracketSize, corner.dy), paint);
        canvas.drawLine(corner, Offset(corner.dx, corner.dy + bracketSize), paint);
      } else if (corner == corners[1]) {
        canvas.drawLine(corner, Offset(corner.dx - bracketSize, corner.dy), paint);
        canvas.drawLine(corner, Offset(corner.dx, corner.dy + bracketSize), paint);
      } else if (corner == corners[2]) {
        canvas.drawLine(corner, Offset(corner.dx + bracketSize, corner.dy), paint);
        canvas.drawLine(corner, Offset(corner.dx, corner.dy - bracketSize), paint);
      } else if (corner == corners[3]) {
        canvas.drawLine(corner, Offset(corner.dx - bracketSize, corner.dy), paint);
        canvas.drawLine(corner, Offset(corner.dx, corner.dy - bracketSize), paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}