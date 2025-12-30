import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import '../theme/app_theme.dart';
import '../services/location_service.dart';
import '../services/app_state.dart';
import 'package:geolocator/geolocator.dart';

class RouteTrackingScreen extends StatefulWidget {
  const RouteTrackingScreen({super.key});

  @override
  State<RouteTrackingScreen> createState() => _RouteTrackingScreenState();
}

class _RouteTrackingScreenState extends State<RouteTrackingScreen> {
  GoogleMapController? _mapController;
  Position? _currentPosition;
  final Set<Marker> _markers = {};
  final Set<Polyline> _polylines = {};

  static const CameraPosition _initialPosition = CameraPosition(
    target: LatLng(12.9716, 77.5946), // Bangalore coordinates
    zoom: 14.0,
  );

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  void _getCurrentLocation() async {
    final position = await LocationService.getCurrentLocation();
    if (position != null && mounted) {
      setState(() {
        _currentPosition = position;
      });

      _mapController?.animateCamera(
        CameraUpdate.newLatLng(LatLng(position.latitude, position.longitude)),
      );
    }
  }

  void _showStudentDialog(Map<String, dynamic> student, int index, AppState appState) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(student['name']),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Stop: ${student['stop']}'),
            Text('Time: ${student['time']}'),
            Text('Status: ${student['picked'] ? 'Picked Up' : 'Waiting'}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
          if (!student['picked'])
            ElevatedButton(
              onPressed: () {
                appState.toggleStudentPickup(index);
                Navigator.pop(context);
                setState(() {
                  _addPickupMarkers(appState);
                });
              },
              child: const Text('Mark as Picked Up'),
            ),
        ],
      ),
    );
  }

  void _addPickupMarkers(AppState appState) {
    _markers.clear();
    _polylines.clear();
    
    // Add bus location if available
    if (_currentPosition != null) {
      _markers.add(
        Marker(
          markerId: const MarkerId('bus_location'),
          position: LatLng(_currentPosition!.latitude, _currentPosition!.longitude),
          infoWindow: const InfoWindow(title: 'Bus Location'),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
        ),
      );
    }

    // Add pickup markers from student data
    List<LatLng> routePoints = [];
    for (int i = 0; i < appState.students.length; i++) {
      final student = appState.students[i];
      final position = LatLng(student['lat'], student['lng']);
      routePoints.add(position);
      
      _markers.add(
        Marker(
          markerId: MarkerId('pickup_$i'),
          position: position,
          infoWindow: InfoWindow(
            title: student['stop'],
            snippet: '${student['name']} - ${student['time']}',
          ),
          icon: BitmapDescriptor.defaultMarkerWithHue(
            student['picked'] ? BitmapDescriptor.hueGreen : BitmapDescriptor.hueRed,
          ),
          onTap: () => _showStudentDialog(student, i, appState),
        ),
      );
    }

    // Add school marker (final destination)
    final schoolLocation = LatLng(12.9820, 77.6020);
    routePoints.add(schoolLocation);
    _markers.add(
      Marker(
        markerId: const MarkerId('school'),
        position: schoolLocation,
        infoWindow: const InfoWindow(title: 'Santhanalakshmi Noble School'),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange),
      ),
    );

    // Create route polyline
    _polylines.add(
      Polyline(
        polylineId: const PolylineId('route'),
        points: routePoints,
        color: Colors.blue,
        width: 4,
        patterns: [PatternItem.dash(20), PatternItem.gap(10)],
      ),
    );
  }

  void _centerOnBus() {
    if (_currentPosition != null) {
      _mapController?.animateCamera(
        CameraUpdate.newLatLng(
          LatLng(_currentPosition!.latitude, _currentPosition!.longitude),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(
      builder: (context, appState, child) {
        // Update markers when build is called
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _addPickupMarkers(appState);
        });

        return Scaffold(
          body: Stack(
            children: [
              // Google Map
              GoogleMap(
                onMapCreated: (GoogleMapController controller) {
                  _mapController = controller;
                },
                initialCameraPosition: _initialPosition,
                markers: _markers,
                polylines: _polylines,
                myLocationEnabled: true,
                myLocationButtonEnabled: false,
                zoomControlsEnabled: false,
              ),

              // Back button
              Positioned(
                top: 50,
                left: 16,
                child: CircleAvatar(
                  backgroundColor: Colors.white,
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.black),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
              ),

              // Top overlay card
              Positioned(
                top: 50,
                left: 70,
                right: 16,
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppTheme.surfaceColor,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        spreadRadius: 1,
                        blurRadius: 4,
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        appState.routeName,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        appState.tripStatus,
                        style: TextStyle(
                          fontSize: 14,
                          color: appState.isTripActive ? Colors.green : Colors.orange,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Center on Bus floating button
              Positioned(
                bottom: 100,
                right: 16,
                child: FloatingActionButton.extended(
                  onPressed: _centerOnBus,
                  backgroundColor: AppTheme.primaryColor,
                  foregroundColor: Colors.white,
                  label: const Text(
                    'Center on Bus',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  icon: const Icon(Icons.my_location),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
