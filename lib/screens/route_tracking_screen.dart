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
          appBar: AppBar(
            title: Row(
              children: [
                Image.asset('assets/images/logo.png', height: 32),
                const SizedBox(width: 12),
                const Text('Route Tracking'),
              ],
            ),
          ),
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

              // Top overlay card
              Positioned(
                top: 20,
                left: 16,
                right: 16,
                child: AppTheme.professionalCard(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    child: Row(
                      children: [
                        const Icon(Icons.route_rounded, color: AppTheme.primaryColor),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                appState.routeName,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: AppTheme.textPrimary,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                appState.tripStatus,
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: AppTheme.textSecondary,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // Bottom Control Panel
              Positioned(
                bottom: 30,
                left: 16,
                right: 16,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    // Center on Bus Button
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: FloatingActionButton.extended(
                        heroTag: 'center_bus',
                        onPressed: _centerOnBus,
                        backgroundColor: AppTheme.primaryColor,
                        foregroundColor: Colors.white,
                        elevation: 4,
                        icon: const Icon(Icons.my_location),
                        label: const Text('Center on Bus'),
                      ),
                    ),
                    
                    // Route Progress Card
                    AppTheme.professionalCard(
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'Route Progress',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: AppTheme.textPrimary,
                                  ),
                                ),
                                Text(
                                  '${appState.students.where((s) => s['picked']).length} / ${appState.students.length}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: AppTheme.primaryColor,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: LinearProgressIndicator(
                                value: appState.students.isEmpty 
                                  ? 0 
                                  : appState.students.where((s) => s['picked']).length / appState.students.length,
                                backgroundColor: AppTheme.primaryColor.withValues(alpha: 0.1),
                                valueColor: const AlwaysStoppedAnimation<Color>(AppTheme.primaryColor),
                                minHeight: 8,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
