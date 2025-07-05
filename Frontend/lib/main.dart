import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import './screens/splash_screen.dart';
import './screens/profile_setup_screen.dart';
import './screens/room_scan_screen.dart';
import './screens/onboarding_screen.dart';
import './screens/chat_screen.dart';
import './screens/dashboard_screen.dart';
import './screens/listing_creation_screen.dart';
import './screens/match_details_screen.dart' as match_details;
import './screens/roommate_agreement_screen.dart';
import './screens/settings_screen.dart';
import './screens/notification_screen.dart';
import './screens/help_screen.dart';
import './utils/app_theme.dart';
import './screens/home_screen.dart'; 


import './models/match_model.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(SmartRoomieApp());
}

class SmartRoomieApp extends StatelessWidget {
  const SmartRoomieApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Smart Roomie',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      home: SplashScreen(),
      routes: {
        '/splash': (context) => SplashScreen(),
        '/onboarding': (context) => OnboardingScreen(),
        // '/onboarding': (context) => OnboardingScreen(),
        '/profile-setup': (context) => ProfileSetupScreen(),
        '/room-scan': (context) => RoomScanScreen(),
        // '/matching': (context) => MatchingScreen(),
        '/chat': (context) {
          final args = ModalRoute.of(context)?.settings.arguments;
          if (args is MatchModel) {
            return ChatScreen(match: args);
          }
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: No match provided for chat')),
          );
          return HomeScreen();
        },
        '/dashboard': (context) => DashboardScreen(),
        '/listing-creation': (context) => ListingCreationScreen(),
        '/match-details': (context) {
          final args = ModalRoute.of(context)?.settings.arguments;
          if (args is MatchModel) {
            return match_details.MatchDetailsScreen(match: args);
          }
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: No match provided for match details')),
          );
          return HomeScreen();
        },
        '/roommate-agreement': (context) => RoommateAgreementScreen(),
        '/settings': (context) => SettingsScreen(),
        '/notifications': (context) => NotificationsScreen(),
        '/help': (context) => HelpScreen(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
      ),
      body: RecentMatches(), // Uses your existing RecentMatches widget
    );
  }
}