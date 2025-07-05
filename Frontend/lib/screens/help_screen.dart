import 'package:flutter/material.dart';
import '../utils/app_theme.dart';

class HelpScreen extends StatelessWidget {
  final List<HelpItem> helpItems = [
    HelpItem(
      title: 'Getting Started',
      items: [
        'How to create your profile',
        'Setting up room preferences',
        'Understanding compatibility scores',
        'Verifying your identity',
      ],
    ),
    HelpItem(
      title: 'Room Scanning',
      items: [
        'How to use AR room scanning',
        'Understanding sensor data',
        'Creating accurate floor plans',
        'Troubleshooting scan issues',
      ],
    ),
    HelpItem(
      title: 'Matching & Communication',
      items: [
        'Finding compatible roommates',
        'Understanding match explanations',
        'Starting conversations',
        'Scheduling meetups',
      ],
    ),
    HelpItem(
      title: 'Safety & Privacy',
      items: [
        'Meeting safely in person',
        'Protecting your personal data',
        'Reporting inappropriate behavior',
        'Blocking unwanted contacts',
      ],
    ),
    HelpItem(
      title: 'Living Together',
      items: [
        'Setting up shared expenses',
        'Managing household chores',
        'Resolving conflicts',
        'Updating roommate agreements',
      ],
    ),
  ];

  HelpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Help & Support'),
        backgroundColor: AppTheme.primaryColor,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search Bar
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: AppTheme.cardColor,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppTheme.borderColor),
              ),
              child: Row(
                children: [
                  Icon(Icons.search, color: AppTheme.textSecondary),
                  SizedBox(width: 12),
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Search help topics...',
                        border: InputBorder.none,
                        hintStyle: TextStyle(color: AppTheme.textSecondary),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 24),

            // Quick Actions
            Text(
              'Quick Actions',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppTheme.textPrimary,
              ),
            ),
            SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildQuickActionCard(
                    icon: Icons.chat,
                    title: 'Live Chat',
                    subtitle: 'Get instant help',
                    onTap: () {},
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: _buildQuickActionCard(
                    icon: Icons.email,
                    title: 'Email Support',
                    subtitle: 'Send us a message',
                    onTap: () {},
                  ),
                ),
              ],
            ),
            SizedBox(height: 24),

            // Help Categories
            Text(
              'Help Categories',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppTheme.textPrimary,
              ),
            ),
            SizedBox(height: 16),
            ...helpItems.map((category) => _buildHelpCategory(category)),
            SizedBox(height: 24),

            // FAQ Section
            Text(
              'Frequently Asked Questions',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppTheme.textPrimary,
              ),
            ),
            SizedBox(height: 16),
            _buildFAQSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActionCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              Icon(icon, size: 32, color: AppTheme.primaryColor),
              SizedBox(height: 8),
              Text(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textPrimary,
                ),
              ),
              SizedBox(height: 4),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 12,
                  color: AppTheme.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHelpCategory(HelpItem category) {
    return Card(
      margin: EdgeInsets.only(bottom: 12),
      child: ExpansionTile(
        title: Text(
          category.title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: AppTheme.textPrimary,
          ),
        ),
        children: category.items.map((item) => ListTile(
          title: Text(item),
          trailing: Icon(Icons.arrow_forward_ios, size: 16),
          onTap: () {
            // Navigate to specific help topic
          },
        )).toList(),
      ),
    );
  }

  Widget _buildFAQSection() {
    return Column(
      children: [
        _buildFAQItem(
          question: 'How accurate is the compatibility scoring?',
          answer: 'Our AI analyzes over 50 lifestyle factors and uses machine learning to predict compatibility with 85% accuracy based on successful roommate matches.',
        ),
        _buildFAQItem(
          question: 'Is my personal data secure?',
          answer: 'Yes, we use end-to-end encryption for all communications and store minimal personal data. Your biometric data never leaves your device.',
        ),
        _buildFAQItem(
          question: 'What if I have issues with my roommate?',
          answer: 'Our AI conflict mediator can help resolve common issues, and our support team is available 24/7 for serious concerns.',
        ),
      ],
    );
  }

  Widget _buildFAQItem({required String question, required String answer}) {
    return Card(
      margin: EdgeInsets.only(bottom: 8),
      child: ExpansionTile(
        title: Text(
          question,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: AppTheme.textPrimary,
          ),
        ),
        children: [
          Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              answer,
              style: TextStyle(color: AppTheme.textSecondary),
            ),
          ),
        ],
      ),
    );
  }
}

class HelpItem {
  final String title;
  final List<String> items;

  HelpItem({required this.title, required this.items});
}