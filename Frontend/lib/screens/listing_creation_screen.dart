import 'package:flutter/material.dart';
import '../services/sensor_service.dart';
import '../utils/app_theme.dart';

class ListingCreationScreen extends StatefulWidget {
  const ListingCreationScreen({super.key});

  @override
  _ListingCreationScreenState createState() => _ListingCreationScreenState();
}

class _ListingCreationScreenState extends State<ListingCreationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _rentController = TextEditingController();
  final _locationController = TextEditingController();
  
  int _currentStep = 0;
  bool _isScanning = false;
  Map<String, dynamic>? _roomData;
  
  final SensorService _sensorService = SensorService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Listing'),
        backgroundColor: AppTheme.primaryColor,
        elevation: 0,
      ),
      body: Form(
        key: _formKey,
        child: Stepper(
          currentStep: _currentStep,
          onStepTapped: (step) => setState(() => _currentStep = step),
          controlsBuilder: (context, details) {
            return Row(
              children: [
                if (details.stepIndex < 3)
                  ElevatedButton(
                    onPressed: details.onStepContinue,
                    child: Text('Next'),
                  ),
                if (details.stepIndex == 3)
                  ElevatedButton(
                    onPressed: _submitListing,
                    child: Text('Create Listing'),
                  ),
                SizedBox(width: 8),
                if (details.stepIndex > 0)
                  TextButton(
                    onPressed: details.onStepCancel,
                    child: Text('Back'),
                  ),
              ],
            );
          },
          steps: [
            Step(
              title: Text('Basic Information'),
              content: _buildBasicInfoStep(),
              isActive: _currentStep >= 0,
            ),
            Step(
              title: Text('Room Details'),
              content: _buildRoomDetailsStep(),
              isActive: _currentStep >= 1,
            ),
            Step(
              title: Text('Sensor Scan'),
              content: _buildSensorScanStep(),
              isActive: _currentStep >= 2,
            ),
            Step(
              title: Text('Review & Publish'),
              content: _buildReviewStep(),
              isActive: _currentStep >= 3,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBasicInfoStep() {
    return Column(
      children: [
        TextFormField(
          controller: _titleController,
          decoration: InputDecoration(
            labelText: 'Listing Title',
            hintText: 'e.g., Spacious room in Manhattan',
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter a title';
            }
            return null;
          },
        ),
        SizedBox(height: 16),
        TextFormField(
          controller: _descriptionController,
          decoration: InputDecoration(
            labelText: 'Description',
            hintText: 'Describe your room and what you\'re looking for',
          ),
          maxLines: 3,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter a description';
            }
            return null;
          },
        ),
        SizedBox(height: 16),
        TextFormField(
          controller: _rentController,
          decoration: InputDecoration(
            labelText: 'Monthly Rent (\$)',
            hintText: '1200',
            prefixText: '\$',
          ),
          keyboardType: TextInputType.number,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter rent amount';
            }
            return null;
          },
        ),
        SizedBox(height: 16),
        TextFormField(
          controller: _locationController,
          decoration: InputDecoration(
            labelText: 'Location',
            hintText: 'Manhattan, NY',
            suffixIcon: Icon(Icons.location_on),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter location';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildRoomDetailsStep() {
    return Column(
      children: [
        Text(
          'Room Features',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        SizedBox(height: 16),
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          childAspectRatio: 2.5,
          children: [
            _buildFeatureChip('Private Bathroom', Icons.bathtub),
            _buildFeatureChip('Furnished', Icons.chair),
            _buildFeatureChip('Parking', Icons.local_parking),
            _buildFeatureChip('Balcony', Icons.balcony),
            _buildFeatureChip('AC', Icons.ac_unit),
            _buildFeatureChip('WiFi', Icons.wifi),
          ],
        ),
        SizedBox(height: 16),
        Text(
          'Amenities',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            'Gym', 'Pool', 'Laundry', 'Elevator', 'Security', 'Rooftop'
          ].map((amenity) => FilterChip(
            label: Text(amenity),
            selected: false,
            onSelected: (selected) {
              // Handle amenity selection
            },
          )).toList(),
        ),
      ],
    );
  }

  Widget _buildFeatureChip(String label, IconData icon) {
    return FilterChip(
      avatar: Icon(icon, size: 18),
      label: Text(label),
      selected: false,
      onSelected: (selected) {
        // Handle feature selection
      },
    );
  }

  Widget _buildSensorScanStep() {
    return Column(
      children: [
        Text(
          'AI-Powered Room Scan',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        SizedBox(height: 16),
        Text(
          'Use your phone\'s sensors to automatically capture room details',
          style: Theme.of(context).textTheme.bodyMedium,
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 32),
        if (_isScanning)
          Column(
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text('Scanning room...'),
            ],
          )
        else if (_roomData != null)
          _buildScanResults()
        else
          Column(
            children: [
              Icon(
                Icons.camera_alt,
                size: 80,
                color: AppTheme.primaryColor,
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: _startRoomScan,
                child: Text('Start Room Scan'),
              ),
              SizedBox(height: 16),
              Text(
                'This will measure room dimensions, noise levels, and lighting',
                style: Theme.of(context).textTheme.bodySmall,
                textAlign: TextAlign.center,
              ),
            ],
          ),
      ],
    );
  }

  Widget _buildScanResults() {
    return Column(
      children: [
        Text(
          'Scan Complete!',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        SizedBox(height: 16),
        Card(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                _buildScanResultRow('Room Size', '${_roomData!['dimensions'][0].toStringAsFixed(1)} × ${_roomData!['dimensions'][1].toStringAsFixed(1)} m'),
                _buildScanResultRow('Noise Level', '${_roomData!['noise_level'].toStringAsFixed(1)} dB'),
                _buildScanResultRow('Light Level', '${_roomData!['light_level'].toStringAsFixed(0)} lux'),
                _buildScanResultRow('Temperature', '${_roomData!['temperature'].toStringAsFixed(1)}°C'),
              ],
            ),
          ),
        ),
        SizedBox(height: 16),
        TextButton(
          onPressed: _startRoomScan,
          child: Text('Rescan Room'),
        ),
      ],
    );
  }

  Widget _buildScanResultRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text(value, style: TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildReviewStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Review Your Listing',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        SizedBox(height: 16),
        Card(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _titleController.text,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                SizedBox(height: 8),
                Text(
                  _descriptionController.text,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                SizedBox(height: 16),
                Row(
                  children: [
                    Icon(Icons.location_on, size: 16),
                    SizedBox(width: 4),
                    Text(_locationController.text),
                  ],
                ),
                SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.attach_money, size: 16),
                    SizedBox(width: 4),
                    Text('\$${_rentController.text}/month'),
                  ],
                ),
                if (_roomData != null) ...[
                  SizedBox(height: 16),
                  Text(
                    'AI-Generated Insights',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  SizedBox(height: 8),
                  Container(
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('✓ Quiet environment suitable for students'),
                        Text('✓ Good natural lighting throughout the day'),
                        Text('✓ Comfortable temperature range'),
                        Text('✓ Spacious room with good ventilation'),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _startRoomScan() async {
    setState(() => _isScanning = true);
    
    try {
      final roomData = await _sensorService.scanRoom();
      setState(() {
        _roomData = roomData;
        _isScanning = false;
      });
    } catch (e) {
      setState(() => _isScanning = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Scan failed. Please try again.')),
      );
    }
  }

  void _submitListing() {
    if (_formKey.currentState!.validate()) {
      // Handle listing submission
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Listing created successfully!')),
      );
      Navigator.pop(context);
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _rentController.dispose();
    _locationController.dispose();
    super.dispose();
  }
}
