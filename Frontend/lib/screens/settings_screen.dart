import 'package:flutter/material.dart';
import '../utils/app_theme.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notificationsEnabled = true;
  bool _locationEnabled = true;
  bool _biometricEnabled = true;
  bool _darkModeEnabled = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
        backgroundColor: AppTheme.primaryColor,
        elevation: 0,
      ),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          _buildSectionHeader('Privacy & Security'),
          _buildSwitchTile(
            'Enable Notifications',
            'Receive match alerts and messages',
            _notificationsEnabled,
            (value) => setState(() => _notificationsEnabled = value),
            Icons.notifications,
          ),
          _buildSwitchTile(
            'Location Services',
            'Use location for better matching',
            _locationEnabled,
            (value) => setState(() => _locationEnabled = value),
            Icons.location_on,
          ),
          _buildSwitchTile(
            'Biometric Authentication',
            'Use Face ID/Fingerprint for security',
            _biometricEnabled,
            (value) => setState(() => _biometricEnabled = value),
            Icons.fingerprint,
          ),
          SizedBox(height: 24),
          _buildSectionHeader('Appearance'),
          _buildSwitchTile(
            'Dark Mode',
            'Switch to dark theme',
            _darkModeEnabled,
            (value) => setState(() => _darkModeEnabled = value),
            Icons.dark_mode,
          ),
          SizedBox(height: 24),
          _buildSectionHeader('Account'),
          _buildSettingsTile(
            'Edit Profile',
            'Update your personal information',
            Icons.person,
            () => Navigator.pushNamed(context, '/profile-setup'),
          ),
          _buildSettingsTile(
            'Matching Preferences',
            'Update your roommate preferences',
            Icons.tune,
            () {},
          ),
          _buildSettingsTile(
            'Verification',
            'Verify your identity',
            Icons.verified_user,
            () {},
          ),
          SizedBox(height: 24),
          _buildSectionHeader('Support'),
          _buildSettingsTile(
            'Help Center',
            'Get help and support',
            Icons.help,
            () => Navigator.pushNamed(context, '/help'),
          ),
          _buildSettingsTile(
            'Report Issue',
            'Report a problem or bug',
            Icons.bug_report,
            () {},
          ),
          _buildSettingsTile(
            'Terms of Service',
            'Read our terms and conditions',
            Icons.description,
            () {},
          ),
          _buildSettingsTile(
            'Privacy Policy',
            'Read our privacy policy',
            Icons.privacy_tip,
            () {},
          ),
          SizedBox(height: 24),
          _buildSectionHeader('Account Actions'),
          _buildSettingsTile(
            'Sign Out',
            'Sign out of your account',
            Icons.logout,
            () => _showSignOutDialog(),
            isDestructive: true,
          ),
          _buildSettingsTile(
            'Delete Account',
            'Permanently delete your account',
            Icons.delete_forever,
            () => _showDeleteAccountDialog(),
            isDestructive: true,
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: AppTheme.primaryColor,
        ),
      ),
    );
  }

  Widget _buildSwitchTile(
    String title,
    String subtitle,
    bool value,
    ValueChanged<bool> onChanged,
    IconData icon,
  ) {
    return Card(
      margin: EdgeInsets.only(bottom: 8),
      child: SwitchListTile(
        title: Text(title),
        subtitle: Text(subtitle),
        value: value,
        onChanged: onChanged,
        secondary: Icon(icon, color: AppTheme.primaryColor),
      ),
    );
  }

  Widget _buildSettingsTile(
    String title,
    String subtitle,
    IconData icon,
    VoidCallback onTap, {
    bool isDestructive = false,
  }) {
    return Card(
      margin: EdgeInsets.only(bottom: 8),
      child: ListTile(
        title: Text(
          title,
          style: TextStyle(
            color: isDestructive ? Colors.red : AppTheme.textPrimary,
          ),
        ),
        subtitle: Text(subtitle),
        leading: Icon(
          icon,
          color: isDestructive ? Colors.red : AppTheme.primaryColor,
        ),
        trailing: Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }

  void _showSignOutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Sign Out'),
        content: Text('Are you sure you want to sign out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushNamedAndRemoveUntil(
                context,
                '/onboarding',
                (route) => false,
              );
            },
            child: Text('Sign Out'),
          ),
        ],
      ),
    );
  }

  void _showDeleteAccountDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete Account'),
        content: Text(
          'Are you sure you want to delete your account? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Account deletion requested')),
              );
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: Text('Delete'),
          ),
        ],
      ),
    );
  }
}