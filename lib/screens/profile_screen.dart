import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/app_theme.dart';
import '../services/app_state.dart';
import '../services/auth_service.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

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
                   const Text('Profile'),
                ],
              ),
            ),
            body: SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  children: [
                    const SizedBox(height: 10),
                    const SizedBox(height: 40),
                    // Driver photo placeholder
                    Container(
                      width: 140,
                      height: 140,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.1),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          const Icon(Icons.person, size: 80, color: Color(0xFFE0E0E0)),
                          Positioned(
                            bottom: 5,
                            right: 5,
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: const BoxDecoration(
                                color: AppTheme.primaryColor,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.camera_alt, size: 20, color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 40),

                    // Driver information
                    AppTheme.professionalCard(
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          children: [
                            _buildProfileItem(Icons.badge_outlined, 'Driver Name', appState.driverName),
                            const Divider(height: 32, thickness: 0.5),
                            _buildProfileItem(Icons.phone_outlined, 'Phone', appState.driverPhone),
                            const Divider(height: 32, thickness: 0.5),
                            _buildProfileItem(Icons.directions_bus_outlined, 'Bus Number', appState.busNumber),
                            const Divider(height: 32, thickness: 0.5),
                            _buildProfileRouteItem(context, appState),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 48),

                    // Logout button
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton.icon(
                        onPressed: () => _confirmLogout(context, appState),
                        icon: const Icon(Icons.logout_rounded),
                        label: const Text(
                          'Logout',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFE74C3C),
                          foregroundColor: Colors.white,
                          elevation: 0,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // App version
                    const Text(
                      'App Version 1.0.0',
                      style: TextStyle(fontSize: 12, color: AppTheme.textSecondary, fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildProfileItem(IconData icon, String label, String value) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: AppTheme.primaryColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: AppTheme.primaryColor, size: 22),
        ),
        const SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: const TextStyle(fontSize: 12, color: AppTheme.textSecondary)),
            Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppTheme.textPrimary)),
          ],
        ),
      ],
    );
  }

  Widget _buildProfileRouteItem(BuildContext context, AppState appState) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: AppTheme.primaryColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: const Icon(Icons.route_outlined, color: AppTheme.primaryColor, size: 22),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Active Route', style: TextStyle(fontSize: 12, color: AppTheme.textSecondary)),
              Text(appState.routeName, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppTheme.textPrimary)),
            ],
          ),
        ),
        IconButton(
          onPressed: () => _showRouteSelection(context, appState),
          icon: const Icon(Icons.edit_note, color: AppTheme.primaryColor),
          tooltip: 'Change Route',
        ),
      ],
    );
  }

  void _confirmLogout(BuildContext context, AppState appState) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to securely logout from the app?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              await AuthService.logout();
              appState.resetTrip();
              if (context.mounted) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
                });
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFE74C3C), foregroundColor: Colors.white),
            child: const Text('Logout'),
          ),
        ],
      ),
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
