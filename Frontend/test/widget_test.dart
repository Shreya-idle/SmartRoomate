import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smartroom/screens/user_profile_screen.dart'; // Adjust path as needed

void main() {
  testWidgets('UserProfileScreen renders correctly', (WidgetTester tester) async {
    // Build the UserProfileScreen widget
    await tester.pumpWidget(
      MaterialApp(
        home: UserProfileScreen(),
      ),
    );

    // Wait for the UI to settle (e.g., after loading user profile)
    await tester.pumpAndSettle();

    // Verify that the profile screen displays the user's name
    expect(find.text('John Doe'), findsOneWidget);

    // Verify that the location is displayed
    expect(find.text('Manhattan, NY'), findsOneWidget);

    // Verify that the "About Me" section is present
    expect(find.text('About Me'), findsOneWidget);

    // Verify that the scan buttons are present
    expect(find.text('Start Scan'), findsOneWidget);
    expect(find.text('Stop Scan'), findsOneWidget);

    // Verify that the verification status is displayed
    expect(find.text('Verification Status'), findsOneWidget);
    expect(find.text('Verified'), findsOneWidget);
  });
}