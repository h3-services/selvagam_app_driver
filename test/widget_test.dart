import 'package:flutter_test/flutter_test.dart';
import 'package:selvagam_driver_app/services/app_state.dart';

void main() {
  group('App State Tests', () {
    setUp(() {
      // Reset the singleton state before each test
      final appState = AppState();
      appState.resetTrip();
      // Reset all students to not picked
      for (int i = 0; i < appState.students.length; i++) {
        if (appState.students[i]['picked'] == true) {
          appState.toggleStudentPickup(i);
        }
      }
    });

    test('AppState initializes with correct default values', () {
      final appState = AppState();

      expect(appState.driverName, 'John Driver');
      expect(appState.busNumber, 'Bus #42');
      expect(appState.routeName, 'Route A-Morning');
      expect(appState.tripStatus, 'Not Started');
      expect(appState.isTripActive, false);
      expect(appState.isTripPaused, false);
    });

    test('Trip state changes work correctly', () {
      final appState = AppState();

      // Start trip
      appState.startTrip();
      expect(appState.tripStatus, 'In Progress');
      expect(appState.isTripActive, true);
      expect(appState.isTripPaused, false);

      // Pause trip
      appState.pauseTrip();
      expect(appState.tripStatus, 'Paused');
      expect(appState.isTripPaused, true);

      // Resume trip
      appState.resumeTrip();
      expect(appState.tripStatus, 'In Progress');
      expect(appState.isTripPaused, false);

      // End trip
      appState.endTrip();
      expect(appState.tripStatus, 'Completed');
      expect(appState.isTripActive, false);
    });

    test('Student pickup toggle works', () {
      final appState = AppState();

      expect(appState.students[0]['picked'], false);

      appState.toggleStudentPickup(0);
      expect(appState.students[0]['picked'], true);

      appState.toggleStudentPickup(0);
      expect(appState.students[0]['picked'], false);
    });

    test('Next pickup returns correct student', () {
      final appState = AppState();

      // Initially, first student should be next pickup
      expect(appState.nextPickup, 'Sarah Johnson');

      // After picking up first student, next should be second
      appState.toggleStudentPickup(0);
      expect(appState.nextPickup, 'Mike Chen');

      // After picking up all students
      for (int i = 1; i < appState.students.length; i++) {
        appState.toggleStudentPickup(i);
      }
      expect(appState.nextPickup, 'All students picked up');
    });

    test('Students list has correct initial data', () {
      final appState = AppState();

      expect(appState.students.length, 5);
      expect(appState.students[0]['name'], 'Sarah Johnson');
      expect(appState.students[0]['stop'], 'Main Street');
      expect(appState.students[0]['time'], '7:30 AM');
      expect(appState.students[0]['picked'], false);
    });
  });
}
