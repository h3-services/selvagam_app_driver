import 'package:flutter/foundation.dart';

class AppState extends ChangeNotifier {
  static final AppState _instance = AppState._internal();
  factory AppState() => _instance;
  AppState._internal();

  // Driver info
  String driverName = 'John Driver';
  String driverPhone = '+91 98765 43210';
  String busNumber = 'Bus #42';
  String routeName = 'Route A-Morning';

  // Trip state
  String _tripStatus = 'Not Started';
  bool _isTripActive = false;
  bool _isTripPaused = false;

  String get tripStatus => _tripStatus;
  bool get isTripActive => _isTripActive;
  bool get isTripPaused => _isTripPaused;

  void startTrip() {
    _tripStatus = 'In Progress';
    _isTripActive = true;
    _isTripPaused = false;
    notifyListeners();
  }

  void pauseTrip() {
    _tripStatus = 'Paused';
    _isTripPaused = true;
    notifyListeners();
  }

  void resumeTrip() {
    _tripStatus = 'In Progress';
    _isTripPaused = false;
    notifyListeners();
  }

  void endTrip() {
    _tripStatus = 'Completed';
    _isTripActive = false;
    _isTripPaused = false;
    notifyListeners();
  }

  void resetTrip() {
    _tripStatus = 'Not Started';
    _isTripActive = false;
    _isTripPaused = false;
    notifyListeners();
  }

  // Students data with coordinates
  List<Map<String, dynamic>> students = [
    {
      'name': 'Sarah Johnson',
      'stop': 'Main Street',
      'time': '7:30 AM',
      'picked': false,
      'lat': 12.9716,
      'lng': 77.5946,
    },
    {
      'name': 'Mike Chen',
      'stop': 'Oak Avenue',
      'time': '7:35 AM',
      'picked': false,
      'lat': 12.9750,
      'lng': 77.5980,
    },
    {
      'name': 'Emma Davis',
      'stop': 'Park Road',
      'time': '7:40 AM',
      'picked': false,
      'lat': 12.9680,
      'lng': 77.5900,
    },
    {
      'name': 'Alex Wilson',
      'stop': 'School Lane',
      'time': '7:45 AM',
      'picked': false,
      'lat': 12.9800,
      'lng': 77.6000,
    },
    {
      'name': 'Lisa Brown',
      'stop': 'Elm Street',
      'time': '7:50 AM',
      'picked': false,
      'lat': 12.9650,
      'lng': 77.5850,
    },
  ];

  void toggleStudentPickup(int index) {
    if (index >= 0 && index < students.length) {
      students[index]['picked'] = !students[index]['picked'];
      notifyListeners();
    }
  }

  String get nextPickup {
    final nextStudent = students.firstWhere(
      (student) => !student['picked'],
      orElse: () => {'name': 'All students picked up'},
    );
    return nextStudent['name'];
  }

  void updateRoute(String newRoute) {
    routeName = newRoute;
    _updateStudentsForRoute(newRoute);
    notifyListeners();
  }

  void _updateStudentsForRoute(String route) {
    switch (route) {
      case 'Route A - Main Street':
        students = [
          {'name': 'Sarah Johnson', 'stop': 'Main Street', 'time': '7:30 AM', 'picked': false, 'lat': 12.9716, 'lng': 77.5946},
          {'name': 'Mike Chen', 'stop': 'Oak Avenue', 'time': '7:35 AM', 'picked': false, 'lat': 12.9750, 'lng': 77.5980},
          {'name': 'Emma Davis', 'stop': 'Park Road', 'time': '7:40 AM', 'picked': false, 'lat': 12.9680, 'lng': 77.5900},
        ];
        break;
      case 'Route B - School Road':
        students = [
          {'name': 'Alex Wilson', 'stop': 'School Lane', 'time': '7:30 AM', 'picked': false, 'lat': 12.9800, 'lng': 77.6000},
          {'name': 'Lisa Brown', 'stop': 'Elm Street', 'time': '7:35 AM', 'picked': false, 'lat': 12.9650, 'lng': 77.5850},
          {'name': 'Tom White', 'stop': 'Pine Avenue', 'time': '7:40 AM', 'picked': false, 'lat': 12.9720, 'lng': 77.5920},
        ];
        break;
      case 'Route C - Park Avenue':
        students = [
          {'name': 'Anna Green', 'stop': 'Park Avenue', 'time': '7:30 AM', 'picked': false, 'lat': 12.9780, 'lng': 77.5960},
          {'name': 'John Blue', 'stop': 'Rose Street', 'time': '7:35 AM', 'picked': false, 'lat': 12.9700, 'lng': 77.5880},
          {'name': 'Mary Red', 'stop': 'Lily Road', 'time': '7:40 AM', 'picked': false, 'lat': 12.9760, 'lng': 77.5940},
        ];
        break;
    }
  }
}
