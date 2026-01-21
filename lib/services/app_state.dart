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
  String _selectedTripType = 'Morning';
  DateTime? _tripStartTime;
  final List<Map<String, dynamic>> _tripHistory = [];

  String get tripStatus => _tripStatus;
  bool get isTripActive => _isTripActive;
  bool get isTripPaused => _isTripPaused;
  String get selectedTripType => _selectedTripType;
  List<Map<String, dynamic>> get tripHistory => _tripHistory;

  List<String> get availableRoutes {
    if (_selectedTripType == 'Morning') {
      return ['Route A - Main Street', 'Route B - School Road', 'Route C - Park Avenue'];
    } else {
      return ['Route A - Evening Drop-off', 'Route B - School Exit', 'Route C - Sunset Blvd'];
    }
  }

  void startTrip() {
    _tripStatus = 'In Progress';
    _isTripActive = true;
    _isTripPaused = false;
    _tripStartTime = DateTime.now();
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
    if (_isTripActive) {
      final endTime = DateTime.now();
      _tripHistory.insert(0, {
        'date': '${endTime.day}/${endTime.month}/${endTime.year}',
        'startTime': '${_tripStartTime?.hour}:${_tripStartTime?.minute.toString().padLeft(2, '0')}',
        'endTime': '${endTime.hour}:${endTime.hour}:${endTime.minute.toString().padLeft(2, '0')}',
        'route': routeName,
        'type': _selectedTripType,
        'studentsPicked': students.where((s) => s['picked']).length,
        'totalStudents': students.length,
      });
    }
    _tripStatus = 'Completed';
    _isTripActive = false;
    _isTripPaused = false;
    _tripStartTime = null;
    notifyListeners();
  }

  void resetTrip() {
    _tripStatus = 'Not Started';
    _isTripActive = false;
    _isTripPaused = false;
    notifyListeners();
  }

  void setTripType(String type) {
    if (_selectedTripType == type) return;
    
    String oldType = _selectedTripType;
    _selectedTripType = type;
    
    // Map current route to its counterpart in the new trip type
    if (type == 'Morning') {
      if (routeName.contains('Evening Drop-off')) routeName = 'Route A - Main Street';
      else if (routeName.contains('School Exit')) routeName = 'Route B - School Road';
      else if (routeName.contains('Sunset Blvd')) routeName = 'Route C - Park Avenue';
      else routeName = 'Route A - Main Street';
    } else {
      if (routeName.contains('Main Street')) routeName = 'Route A - Evening Drop-off';
      else if (routeName.contains('School Road')) routeName = 'Route B - School Exit';
      else if (routeName.contains('Park Avenue')) routeName = 'Route C - Sunset Blvd';
      else routeName = 'Route A - Evening Drop-off';
    }
    
    _updateStudentsForRoute(routeName);
    resetTrip();
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

  String get nextPickupTime {
    final nextStudent = students.firstWhere(
      (student) => !student['picked'],
      orElse: () => {'time': '--:--'},
    );
    return nextStudent['time'];
  }

  void updateRoute(String newRoute) {
    routeName = newRoute;
    _updateStudentsForRoute(newRoute);
    notifyListeners();
  }

  void _updateStudentsForRoute(String route) {
    final morningTimes = ['7:30 AM', '7:35 AM', '7:40 AM', '7:45 AM', '7:50 AM'];
    final eveningTimes = ['3:30 PM', '3:35 PM', '3:40 PM', '3:45 PM', '3:50 PM'];
    final times = _selectedTripType == 'Morning' ? morningTimes : eveningTimes;

    switch (route) {
      case 'Route A - Main Street':
        students = [
          {'name': 'Sarah Johnson', 'stop': 'Main Street', 'time': times[0], 'picked': false, 'lat': 12.9716, 'lng': 77.5946},
          {'name': 'Mike Chen', 'stop': 'Oak Avenue', 'time': times[1], 'picked': false, 'lat': 12.9750, 'lng': 77.5980},
          {'name': 'Emma Davis', 'stop': 'Park Road', 'time': times[2], 'picked': false, 'lat': 12.9680, 'lng': 77.5900},
        ];
        break;
      case 'Route A - Evening Drop-off':
        students = [
          {'name': 'David Miller', 'stop': 'Market Square', 'time': times[0], 'picked': false, 'lat': 12.9716, 'lng': 77.5946},
          {'name': 'James Wilson', 'stop': 'North Plaza', 'time': times[1], 'picked': false, 'lat': 12.9750, 'lng': 77.5980},
          {'name': 'Robert Taylor', 'stop': 'East Gate', 'time': times[2], 'picked': false, 'lat': 12.9680, 'lng': 77.5900},
        ];
        break;
      case 'Route B - School Road':
        students = [
          {'name': 'Alex Wilson', 'stop': 'School Lane', 'time': times[0], 'picked': false, 'lat': 12.9800, 'lng': 77.6000},
          {'name': 'Lisa Brown', 'stop': 'Elm Street', 'time': times[1], 'picked': false, 'lat': 12.9650, 'lng': 77.5850},
          {'name': 'Tom White', 'stop': 'Pine Avenue', 'time': times[2], 'picked': false, 'lat': 12.9720, 'lng': 77.5920},
        ];
        break;
      case 'Route B - School Exit':
        students = [
          {'name': 'Kevin Hart', 'stop': 'Exit Point 1', 'time': times[0], 'picked': false, 'lat': 12.9800, 'lng': 77.6000},
          {'name': 'Brian Tracy', 'stop': 'Highway Jct', 'time': times[1], 'picked': false, 'lat': 12.9650, 'lng': 77.5850},
          {'name': 'Chris Evans', 'stop': 'Valley View', 'time': times[2], 'picked': false, 'lat': 12.9720, 'lng': 77.5920},
        ];
        break;
      case 'Route C - Park Avenue':
        students = [
          {'name': 'Anna Green', 'stop': 'Park Avenue', 'time': times[0], 'picked': false, 'lat': 12.9780, 'lng': 77.5960},
          {'name': 'John Blue', 'stop': 'Rose Street', 'time': times[1], 'picked': false, 'lat': 12.9700, 'lng': 77.5880},
          {'name': 'Mary Red', 'stop': 'Lily Road', 'time': times[2], 'picked': false, 'lat': 12.9760, 'lng': 77.5940},
        ];
        break;
      case 'Route C - Sunset Blvd':
        students = [
          {'name': 'Zoe Kravitz', 'stop': 'Sunset Blvd 10', 'time': times[0], 'picked': false, 'lat': 12.9780, 'lng': 77.5960},
          {'name': 'Will Smith', 'stop': 'Fresh Prince Dr', 'time': times[1], 'picked': false, 'lat': 12.9700, 'lng': 77.5880},
          {'name': 'Tom Cruise', 'stop': 'Mission St', 'time': times[2], 'picked': false, 'lat': 12.9760, 'lng': 77.5940},
        ];
        break;
    }
  }
}
