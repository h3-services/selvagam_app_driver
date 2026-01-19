import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/app_theme.dart';
import '../services/app_state.dart';

class PickupListScreen extends StatelessWidget {
  const PickupListScreen({super.key});

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
                   const Text('Pickup List'),
                ],
              ),
            ),
            body: SafeArea(
              child: Column(
                children: [
                  const SizedBox(height: 10),
                  
                  // Summary Bar
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
                    child: AppTheme.professionalCard(
                      color: AppTheme.primaryColor,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Total Students',
                              style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
                            ),
                            Text(
                              '${appState.students.where((s) => s['picked']).length} / ${appState.students.length}',
                              style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  // Student List
                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
                      itemCount: appState.students.length,
                      itemBuilder: (context, index) {
                        final student = appState.students[index];
                        final bool isPicked = student['picked'];
                        
                        return Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          child: AppTheme.professionalCard(
                            color: isPicked ? Colors.white : Colors.white.withValues(alpha: 0.7),
                            child: ListTile(
                              contentPadding: const EdgeInsets.all(16),
                              leading: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: isPicked ? Colors.green.withValues(alpha: 0.1) : Colors.grey.withValues(alpha: 0.1),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  isPicked ? Icons.check_circle_rounded : Icons.person_outline_rounded,
                                  color: isPicked ? Colors.green : Colors.grey,
                                  size: 28,
                                ),
                              ),
                              title: Text(
                                student['name'],
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: isPicked ? AppTheme.textPrimary : AppTheme.textPrimary.withValues(alpha: 0.6),
                                  decoration: isPicked ? TextDecoration.lineThrough : null,
                                ),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(height: 4),
                                  Row(
                                    children: [
                                      const Icon(Icons.location_on_outlined, size: 14, color: AppTheme.textSecondary),
                                      const SizedBox(width: 4),
                                      Text(student['stop'], style: const TextStyle(fontSize: 13, color: AppTheme.textSecondary)),
                                    ],
                                  ),
                                  const SizedBox(height: 2),
                                  Row(
                                    children: [
                                      const Icon(Icons.access_time, size: 14, color: AppTheme.textSecondary),
                                      const SizedBox(width: 4),
                                      Text(student['time'], style: const TextStyle(fontSize: 13, color: AppTheme.textSecondary)),
                                    ],
                                  ),
                                ],
                              ),
                              trailing: Checkbox(
                                value: isPicked,
                                onChanged: (val) => appState.toggleStudentPickup(index),
                                activeColor: AppTheme.primaryColor,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                              ),
                              onTap: () => appState.toggleStudentPickup(index),
                            ),
                          ),
                        );
                      },
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
}
