import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/app_theme.dart';
import '../services/app_state.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(
      builder: (context, appState, child) {
        return AppTheme.gradientBackground(
          child: Scaffold(
            appBar: AppBar(
              title: Row(
                children: [
                   Image.asset('assets/images/logo.png', height: 32),
                   const SizedBox(width: 12),
                   const Text('Dashboard'),
                ],
              ),
              actions: [
                Padding(
                  padding: const EdgeInsets.only(right: 16.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.5),
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.person, color: Colors.white, size: 28),
                      onPressed: () => Navigator.pushNamed(context, '/profile'),
                    ),
                  ),
                ),
              ],
            ),
            body: SafeArea(
              child: Column(
                children: [
                  // Content Area
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        children: [
                          // Driver Info Card
                          AppTheme.professionalCard(
                            child: Padding(
                              padding: const EdgeInsets.all(24),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        appState.driverName,
                                        style: const TextStyle(
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold,
                                          color: AppTheme.textPrimary,
                                        ),
                                      ),
                                      IconButton(
                                        onPressed: () => _showRouteSelection(context, appState),
                                        icon: const Icon(Icons.edit_road, size: 22, color: AppTheme.primaryColor),
                                      ),
                                    ],
                                  ),
                                  const Divider(height: 32, thickness: 1, color: Colors.black12),
                                  Row(
                                    children: [
                                      const Icon(Icons.directions_bus, size: 20, color: AppTheme.textSecondary),
                                      const SizedBox(width: 8),
                                      Text(
                                        appState.busNumber,
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                          color: AppTheme.textSecondary,
                                        ),
                                      ),
                                      const SizedBox(width: 16),
                                      const Icon(Icons.route, size: 20, color: AppTheme.textSecondary),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: Text(
                                          appState.routeName,
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                            color: AppTheme.textSecondary,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 24),

                          // Trip Status Card
                          AppTheme.glassmorphismCard(
                            gradientColors: AppTheme.timetableGradient,
                            child: Padding(
                              padding: const EdgeInsets.all(32),
                              child: Column(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withValues(alpha: 0.2),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Text(
                                      appState.tripStatus.toUpperCase(),
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                        letterSpacing: 1.2,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                  Text(
                                    appState.nextPickup,
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  const Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.access_time, size: 18, color: Colors.white70),
                                      const SizedBox(width: 8),
                                      Text(
                                        'Time: 7:30 AM',
                                        style: TextStyle(fontSize: 16, color: Colors.white70),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 24),

                          // Main Actions
                          if (!appState.isTripActive)
                            SizedBox(
                              width: double.infinity,
                              height: 64,
                              child: ElevatedButton.icon(
                                onPressed: () {
                                  appState.startTrip();
                                  WidgetsBinding.instance.addPostFrameCallback((_) {
                                    Navigator.pushNamed(context, '/route-tracking');
                                  });
                                },
                                icon: const Icon(Icons.play_arrow_rounded, size: 28),
                                label: const Text(
                                  'Start Trip',
                                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF27AE60),
                                  foregroundColor: Colors.white,
                                  elevation: 4,
                                ),
                              ),
                            ),
                          
                          if (appState.isTripActive) ...[
                            Row(
                              children: [
                                Expanded(
                                  child: SizedBox(
                                    height: 56,
                                    child: ElevatedButton.icon(
                                      onPressed: () {
                                        if (appState.isTripPaused) {
                                          appState.resumeTrip();
                                        } else {
                                          appState.pauseTrip();
                                        }
                                      },
                                      icon: Icon(appState.isTripPaused ? Icons.play_arrow : Icons.pause),
                                      label: Text(appState.isTripPaused ? 'Resume' : 'Pause'),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: const Color(0xFFF39C12),
                                        foregroundColor: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: SizedBox(
                                    height: 56,
                                    child: ElevatedButton.icon(
                                      onPressed: () {
                                        appState.endTrip();
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          const SnackBar(content: Text('Trip completed successfully')),
                                        );
                                      },
                                      icon: const Icon(Icons.stop),
                                      label: const Text('End Trip'),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: const Color(0xFFE74C3C),
                                        foregroundColor: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                          ],

                          const SizedBox(height: 16),
                          
                          // Secondary Action
                          SizedBox(
                            width: double.infinity,
                            height: 56,
                            child: ElevatedButton.icon(
                              onPressed: () => Navigator.pushNamed(context, '/route-tracking'),
                              icon: const Icon(Icons.map_outlined),
                              label: const Text(
                                'View Full Route',
                                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF1F1645),
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                elevation: 2,
                              ),
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
        );
      },
    );
  }

  void _showRouteSelection(BuildContext context, AppState appState) {
    final routes = ['Route A - Main Street', 'Route B - School Road', 'Route C - Park Avenue'];
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Route'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: routes.map((route) => ListTile(
            title: Text(route),
            onTap: () {
              appState.updateRoute(route);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Route changed to $route')),
              );
            },
          )).toList(),
        ),
      ),
    );
  }
}