import 'package:flutter/material.dart';
import '../utils/app_theme.dart';

class ProfileSetupScreen extends StatefulWidget {
  const ProfileSetupScreen({super.key});

  @override
  _ProfileSetupScreenState createState() => _ProfileSetupScreenState();
}

class _ProfileSetupScreenState extends State<ProfileSetupScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  final int _totalPages = 4;

  // Form data
  String _name = '';
  int _age = 25;
  String _occupation = '';
  String _bio = '';
  final List<String> _interests = [];
  final Map<String, dynamic> _preferences = {};
  final Map<String, dynamic> _lifestyle = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile Setup'),
        backgroundColor: AppTheme.primaryColor,
        elevation: 0,
      ),
      body: Column(
        children: [
          // Progress indicator
          Container(
            padding: EdgeInsets.all(16),
            child: Row(
              children: List.generate(_totalPages, (index) => Expanded(
                child: Container(
                  height: 4,
                  margin: EdgeInsets.symmetric(horizontal: 2),
                  decoration: BoxDecoration(
                    color: index <= _currentPage ? AppTheme.primaryColor : AppTheme.borderColor,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              )),
            ),
          ),
          Expanded(
            child: PageView(
              controller: _pageController,
              onPageChanged: (page) {
                setState(() {
                  _currentPage = page;
                });
              },
              children: [
                _buildBasicInfoPage(),
                _buildInterestsPage(),
                _buildPreferencesPage(),
                _buildLifestylePage(),
              ],
            ),
          ),
          // Navigation buttons
          Container(
            padding: EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (_currentPage > 0)
                  TextButton(
                    onPressed: () {
                      _pageController.previousPage(
                        duration: Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    },
                    child: Text('Previous'),
                  )
                else
                  SizedBox(width: 80),
                ElevatedButton(
                  onPressed: _currentPage == _totalPages - 1 ? _completeSetup : () {
                    _pageController.nextPage(
                      duration: Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryColor,
                    foregroundColor: Colors.white,
                  ),
                  child: Text(_currentPage == _totalPages - 1 ? 'Complete' : 'Next'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBasicInfoPage() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Tell us about yourself',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppTheme.textPrimary,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'This helps us find you the perfect roommate match',
            style: TextStyle(
              color: AppTheme.textSecondary,
              fontSize: 16,
            ),
          ),
          SizedBox(height: 32),
          
          // Profile photo
          Center(
            child: Stack(
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundColor: AppTheme.primaryColor.withOpacity(0.1),
                  child: Icon(
                    Icons.person,
                    size: 50,
                    color: AppTheme.primaryColor,
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    padding: EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryColor,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.camera_alt,
                      size: 20,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 32),
          
          // Name field
          TextField(
            decoration: InputDecoration(
              labelText: 'Full Name',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.person),
            ),
            onChanged: (value) {
              setState(() {
                _name = value;
              });
            },
          ),
          SizedBox(height: 16),
          
          // Age slider
          Text(
            'Age: $_age',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppTheme.textPrimary,
            ),
          ),
          Slider(
            value: _age.toDouble(),
            min: 18,
            max: 65,
            divisions: 47,
            onChanged: (value) {
              setState(() {
                _age = value.round();
              });
            },
          ),
          SizedBox(height: 16),
          
          // Occupation field
          TextField(
            decoration: InputDecoration(
              labelText: 'Occupation',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.work),
            ),
            onChanged: (value) {
              setState(() {
                _occupation = value;
              });
            },
          ),
          SizedBox(height: 16),
          
          // Bio field
          TextField(
            maxLines: 3,
            decoration: InputDecoration(
              labelText: 'Bio (optional)',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.edit),
              hintText: 'Tell potential roommates about yourself...',
            ),
            onChanged: (value) {
              setState(() {
                _bio = value;
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildInterestsPage() {
    final List<String> availableInterests = [
      'Cooking', 'Fitness', 'Music', 'Movies', 'Reading', 'Gaming',
      'Travel', 'Art', 'Photography', 'Sports', 'Yoga', 'Dancing',
      'Hiking', 'Technology', 'Fashion', 'Gardening', 'Pets', 'Wine',
    ];

    return SingleChildScrollView(
      padding: EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'What are your interests?',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppTheme.textPrimary,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Select interests that match your personality',
            style: TextStyle(
              color: AppTheme.textSecondary,
              fontSize: 16,
            ),
          ),
          SizedBox(height: 32),
          
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: availableInterests.map((interest) {
              final isSelected = _interests.contains(interest);
              return FilterChip(
                label: Text(interest),
                selected: isSelected,
                onSelected: (selected) {
                  setState(() {
                    if (selected) {
                      _interests.add(interest);
                    } else {
                      _interests.remove(interest);
                    }
                  });
                },
                selectedColor: AppTheme.primaryColor.withOpacity(0.2),
                checkmarkColor: AppTheme.primaryColor,
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildPreferencesPage() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Room Preferences',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppTheme.textPrimary,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Let us know what you\'re looking for',
            style: TextStyle(
              color: AppTheme.textSecondary,
              fontSize: 16,
            ),
          ),
          SizedBox(height: 32),
          
          // Budget range
          Text(
            'Budget Range (\$${_preferences['budgetMin']?.round() ?? 500} - \$${_preferences['budgetMax']?.round() ?? 2000})',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppTheme.textPrimary,
            ),
          ),
          RangeSlider(
            values: RangeValues(
              _preferences['budgetMin']?.toDouble() ?? 500,
              _preferences['budgetMax']?.toDouble() ?? 2000,
            ),
            min: 300,
            max: 5000,
            divisions: 94,
            onChanged: (values) {
              setState(() {
                _preferences['budgetMin'] = values.start;
                _preferences['budgetMax'] = values.end;
              });
            },
          ),
          SizedBox(height: 24),
          
          // Location preferences
          Text(
            'Preferred Areas',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppTheme.textPrimary,
            ),
          ),
          SizedBox(height: 8),
          TextField(
            decoration: InputDecoration(
              labelText: 'Enter neighborhoods or areas',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.location_on),
            ),
          ),
          SizedBox(height: 24),
          
          // Move-in date
          Text(
            'Move-in Date',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppTheme.textPrimary,
            ),
          ),
          SizedBox(height: 8),
          TextField(
            decoration: InputDecoration(
              labelText: 'Select date',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.calendar_today),
            ),
            readOnly: true,
            onTap: () async {
              final date = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime.now(),
                lastDate: DateTime.now().add(Duration(days: 365)),
              );
              if (date != null) {
                setState(() {
                  _preferences['moveInDate'] = date;
                });
              }
            },
          ),
          SizedBox(height: 24),
          
          // Lease duration
          Text(
            'Lease Duration',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppTheme.textPrimary,
            ),
          ),
          SizedBox(height: 8),
          DropdownButtonFormField<String>(
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.schedule),
            ),
            items: [
              '3 months',
              '6 months',
              '1 year',
              '2 years',
              'Month-to-month',
            ].map((duration) => DropdownMenuItem(
              value: duration,
              child: Text(duration),
            )).toList(),
            onChanged: (value) {
              setState(() {
                _preferences['leaseDuration'] = value;
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildLifestylePage() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Lifestyle Preferences',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppTheme.textPrimary,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Help us understand your living habits',
            style: TextStyle(
              color: AppTheme.textSecondary,
              fontSize: 16,
            ),
          ),
          SizedBox(height: 32),
          
          // Cleanliness level
          _buildLifestyleSlider(
            'Cleanliness Level',
            'Very messy',
            'Extremely clean',
            _lifestyle['cleanliness']?.toDouble() ?? 5,
            (value) {
              setState(() {
                _lifestyle['cleanliness'] = value;
              });
            },
          ),
          SizedBox(height: 24),
          
          // Noise tolerance
          _buildLifestyleSlider(
            'Noise Tolerance',
            'Very quiet',
            'Love parties',
            _lifestyle['noiseTolerance']?.toDouble() ?? 5,
            (value) {
              setState(() {
                _lifestyle['noiseTolerance'] = value;
              });
            },
          ),
          SizedBox(height: 24),
          
          // Social level
          _buildLifestyleSlider(
            'Social Level',
            'Keep to myself',
            'Very social',
            _lifestyle['socialLevel']?.toDouble() ?? 5,
            (value) {
              setState(() {
                _lifestyle['socialLevel'] = value;
              });
            },
          ),
          SizedBox(height: 24),
          
          // Sleep schedule
          Text(
            'Sleep Schedule',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppTheme.textPrimary,
            ),
          ),
          SizedBox(height: 8),
          DropdownButtonFormField<String>(
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.bedtime),
            ),
            items: [
              'Early bird (sleep before 10 PM)',
              'Normal (10 PM - 12 AM)',
              'Night owl (after 12 AM)',
              'Irregular schedule',
            ].map((schedule) => DropdownMenuItem(
              value: schedule,
              child: Text(schedule),
            )).toList(),
            onChanged: (value) {
              setState(() {
                _lifestyle['sleepSchedule'] = value;
              });
            },
          ),
          SizedBox(height: 24),
          
          // Smoking preference
          Text(
            'Smoking',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppTheme.textPrimary,
            ),
          ),
          SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: RadioListTile<String>(
                  title: Text('Non-smoker'),
                  value: 'non-smoker',
                  groupValue: _lifestyle['smoking'],
                  onChanged: (value) {
                    setState(() {
                      _lifestyle['smoking'] = value;
                    });
                  },
                ),
              ),
              Expanded(
                child: RadioListTile<String>(
                  title: Text('Smoker'),
                  value: 'smoker',
                  groupValue: _lifestyle['smoking'],
                  onChanged: (value) {
                    setState(() {
                      _lifestyle['smoking'] = value;
                    });
                  },
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          
          // Pets
          Text(
            'Pets',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppTheme.textPrimary,
            ),
          ),
          SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: RadioListTile<String>(
                  title: Text('Have pets'),
                  value: 'have-pets',
                  groupValue: _lifestyle['pets'],
                  onChanged: (value) {
                    setState(() {
                      _lifestyle['pets'] = value;
                    });
                  },
                ),
              ),
              Expanded(
                child: RadioListTile<String>(
                  title: Text('No pets'),
                  value: 'no-pets',
                  groupValue: _lifestyle['pets'],
                  onChanged: (value) {
                    setState(() {
                      _lifestyle['pets'] = value;
                    });
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLifestyleSlider(
    String title,
    String minLabel,
    String maxLabel,
    double value,
    Function(double) onChanged,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$title: ${value.round()}/10',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppTheme.textPrimary,
          ),
        ),
        SizedBox(height: 8),
        Slider(
          value: value,
          min: 1,
          max: 10,
          divisions: 9,
          onChanged: onChanged,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(minLabel, style: TextStyle(fontSize: 12, color: AppTheme.textSecondary)),
            Text(maxLabel, style: TextStyle(fontSize: 12, color: AppTheme.textSecondary)),
          ],
        ),
      ],
    );
  }

  void _completeSetup() {
    // Save profile data and navigate to home
    Navigator.pushReplacementNamed(context, '/home');
  }
}