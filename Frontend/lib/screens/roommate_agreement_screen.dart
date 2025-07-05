import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/match_model.dart';
import '../utils/app_theme.dart';

class RoommateAgreementScreen extends StatefulWidget {
  const RoommateAgreementScreen({super.key});

  @override
  _RoommateAgreementScreenState createState() => _RoommateAgreementScreenState();
}

class _RoommateAgreementScreenState extends State<RoommateAgreementScreen> {
  bool _isAgreed = false;
  bool _isLoading = false;
  List<AgreementSection> _sections = [];
  String? _error;

  @override
  void initState() {
    super.initState();
    _fetchAgreement();
  }

  Future<void> _fetchAgreement() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      final match = ModalRoute.of(context)?.settings.arguments as MatchModel?;
      if (match == null) {
        throw Exception('No match data provided');
      }
      final response = await http.post(
        Uri.parse('http://localhost:3000/api/agreements'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'userId': match.user,
          'roomId': match.room,
        }),
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        // Assuming the API returns a structured agreement with sections
        setState(() {
          _sections = [
            AgreementSection(
              title: 'Rent and Utilities',
              items: data['rentAndUtilities'] ?? [
                'Monthly rent: \$1,200 (split equally)',
                'Utilities: \$100-150 (split equally)',
                'Security deposit: \$600 each',
                'Rent due on 1st of each month',
              ],
              isExpanded: true,
            ),
            AgreementSection(
              title: 'Household Responsibilities',
              items: data['householdResponsibilities'] ?? [
                'Kitchen: Clean after use, weekly deep clean rotation',
                'Bathroom: Weekly cleaning rotation',
                'Common areas: Keep tidy, vacuum weekly',
                'Trash: Alternate taking out weekly',
                'Groceries: Split common items, label personal food',
              ],
              isExpanded: false,
            ),
            AgreementSection(
              title: 'House Rules',
              items: data['houseRules'] ?? [
                'Quiet hours: 10 PM - 8 AM on weekdays',
                'Guests: 48-hour notice for overnight guests',
                'Pets: No additional pets without mutual agreement',
                'Smoking: Not allowed inside the apartment',
                'Personal belongings: Respect each other\'s space',
              ],
              isExpanded: false,
            ),
            AgreementSection(
              title: 'Communication',
              items: data['communication'] ?? [
                'Monthly check-ins for any issues',
                'Use Smart Roomie app for household management',
                'Address conflicts promptly and respectfully',
                'Give 30 days notice before moving out',
              ],
              isExpanded: false,
            ),
            AgreementSection(
              title: 'Emergency Procedures',
              items: data['emergencyProcedures'] ?? [
                'Exchange emergency contact information',
                'Know location of circuit breaker and water shutoff',
                'Keep spare keys in secure, agreed location',
                'Notify roommate of extended absences',
              ],
              isExpanded: false,
            ),
          ];
        });
      } else {
        throw Exception('Failed to fetch agreement: ${response.statusCode}');
      }
    } catch (e) {
      setState(() {
        _error = 'Error: $e';
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Roommate Agreement'),
        backgroundColor: AppTheme.primaryColor,
        elevation: 0,
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(child: Text(_error!, style: TextStyle(fontSize: 16, color: Colors.red)))
              : Column(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        padding: EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Header
                            Container(
                              padding: EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: AppTheme.primaryColor.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                children: [
                                  Icon(Icons.description, color: AppTheme.primaryColor),
                                  SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Roommate Agreement',
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: AppTheme.textPrimary,
                                          ),
                                        ),
                                        Text(
                                          'AI-generated based on your preferences',
                                          style: TextStyle(
                                            color: AppTheme.textSecondary,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 24),

                            // Agreement sections
                            ..._sections.map((section) => _buildAgreementSection(section)),
                            SizedBox(height: 24),

                            // Signatures section
                            Card(
                              child: Padding(
                                padding: EdgeInsets.all(16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Digital Signatures',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: AppTheme.textPrimary,
                                      ),
                                    ),
                                    SizedBox(height: 16),
                                    _buildSignatureRow('You', 'Signed', true),
                                    _buildSignatureRow('Alex Thompson', 'Pending', false),
                                    SizedBox(height: 16),
                                    Text(
                                      'This agreement will be effective once both parties have signed.',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: AppTheme.textSecondary,
                                        fontStyle: FontStyle.italic,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Bottom actions
                    Container(
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppTheme.cardColor,
                        border: Border(top: BorderSide(color: AppTheme.borderColor)),
                      ),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Checkbox(
                                value: _isAgreed,
                                onChanged: (value) {
                                  setState(() {
                                    _isAgreed = value ?? false;
                                  });
                                },
                              ),
                              Expanded(
                                child: Text(
                                  'I agree to the terms and conditions outlined in this roommate agreement.',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: AppTheme.textPrimary,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 16),
                          Row(
                            children: [
                              Expanded(
                                child: OutlinedButton(
                                  onPressed: () {
                                    _showEditDialog();
                                  },
                                  child: Text('Request Changes'),
                                ),
                              ),
                              SizedBox(width: 12),
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: _isAgreed ? () {
                                    _signAgreement();
                                  } : null,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppTheme.primaryColor,
                                    foregroundColor: Colors.white,
                                  ),
                                  child: Text('Sign Agreement'),
                                ),
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

  Widget _buildAgreementSection(AgreementSection section) {
    return Card(
      margin: EdgeInsets.only(bottom: 12),
      child: ExpansionTile(
        title: Text(
          section.title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: AppTheme.textPrimary,
          ),
        ),
        initiallyExpanded: section.isExpanded,
        children: [
          Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: section.items.map((item) => Padding(
                padding: EdgeInsets.only(bottom: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: EdgeInsets.only(top: 8),
                      width: 4,
                      height: 4,
                      decoration: BoxDecoration(
                        color: AppTheme.primaryColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        item,
                        style: TextStyle(
                          color: AppTheme.textPrimary,
                          height: 1.5,
                        ),
                      ),
                    ),
                  ],
                ),
              )).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSignatureRow(String name, String status, bool isSigned) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            name,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: AppTheme.textPrimary,
            ),
          ),
          Row(
            children: [
              Icon(
                isSigned ? Icons.check_circle : Icons.pending,
                color: isSigned ? Colors.green : Colors.orange,
                size: 16,
              ),
              SizedBox(width: 4),
              Text(
                status,
                style: TextStyle(
                  color: isSigned ? Colors.green : Colors.orange,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showEditDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Request Changes'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('What would you like to change in this agreement?'),
            SizedBox(height: 16),
            TextField(
              maxLines: 3,
              decoration: InputDecoration(
                hintText: 'Describe the changes you\'d like to make...',
                border: OutlineInputBorder(),
              ),
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
              Navigator.pop(context);
              // Send change request
            },
            child: Text('Send Request'),
          ),
        ],
      ),
    );
  }

  void _signAgreement() {
    // Implement biometric verification
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.fingerprint, color: AppTheme.primaryColor),
            SizedBox(width: 8),
            Text('Biometric Verification'),
          ],
        ),
        content: Text('Please verify your identity to sign the agreement.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // Complete signing process
              _showSuccessDialog();
            },
            child: Text('Verify & Sign'),
          ),
        ],
      ),
    );
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.check_circle, color: Colors.green),
            SizedBox(width: 8),
            Text('Agreement Signed!'),
          ],
        ),
        content: Text('Your roommate agreement has been signed successfully. You\'ll be notified when your roommate signs as well.'),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushReplacementNamed(context, '/dashboard');
            },
            child: Text('Continue to Dashboard'),
          ),
        ],
      ),
    );
  }
}

class AgreementSection {
  final String title;
  final List<String> items;
  final bool isExpanded;

  AgreementSection({
    required this.title,
    required this.items,
    this.isExpanded = false,
  });
}