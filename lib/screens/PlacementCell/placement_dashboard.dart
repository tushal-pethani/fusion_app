import 'package:flutter/material.dart';
import '../../utils/sidebar.dart' as sidebar;
import '../../utils/gesture_sidebar.dart';
import '../../utils/home.dart'; // Import HomeScreen for navigation
import '../../utils/bottom_bar.dart'; // Import BottomBar
import '../../main.dart'; // Import ExitConfirmationWrapper
import 'view_jobs.dart';
import 'placement_schedule.dart'; // Import PlacementScheduleScreen
import 'upload_documents.dart'; // Import UploadDocumentsScreen
import 'upload_offer_letter.dart'; // Import UploadOfferLetterScreen
import 'view_applications.dart'; // Import ViewApplicationsScreen

class PlacementDashboard extends StatefulWidget {
  const PlacementDashboard({super.key});

  @override
  State<PlacementDashboard> createState() => _PlacementDashboardState();
}

class _PlacementDashboardState extends State<PlacementDashboard> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  void _handleNavigation(int index) {
    if (index == 37) {
      // Navigate to Placement Schedule instead of showing "coming soon" message
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const PlacementScheduleScreen(),
        ),
      );
    } else if (index == 38) {
      // Navigate to Upload Documents screen instead of showing "coming soon" message
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const UploadDocumentsScreen(),
        ),
      );
    } else if (index == 39) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const UploadOfferLetterScreen(),
        ),
      );
    } else if (index == 40) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const ViewJobsScreen(),
        ),
      );
    } else if (index == 41) {
      _showComingSoonSnackBar('Create Resume');
    } else if (index == 42) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const ViewApplicationsScreen(),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Navigating to ${_getScreenName(index)}'),
          duration: const Duration(seconds: 1),
        ),
      );
    }
  }

  void _showComingSoonSnackBar(String feature) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$feature coming soon!'),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  String _getScreenName(int index) {
    switch (index) {
      case 0:
        return 'Home';
      case 37:
        return 'View Placement Schedule';
      case 38:
        return 'Upload Documents';
      case 39:
        return 'Upload Offer Letter';
      case 40:
        return 'View Jobs';
      case 41:
        return 'Create Resume';
      case 42:
        return 'View Applications';
      default:
        return 'Unknown';
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvoked: (didPop) {
        if (didPop) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  const ExitConfirmationWrapper(child: HomeScreen()),
            ),
            (route) => false,
          );
        }
      },
      child: GestureSidebar(
        scaffoldKey: _scaffoldKey,
        child: Scaffold(
          key: _scaffoldKey,
          appBar: AppBar(
            title: const Text(
              'Placement Cell',
              style:
                  TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
            ),
            elevation: 0,
            backgroundColor: Colors.blue.shade700,
            leading: IconButton(
              icon: const Icon(Icons.menu, color: Colors.white),
              onPressed: () {
                _scaffoldKey.currentState!.openDrawer();
              },
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.notifications, color: Colors.white),
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          const ExitConfirmationWrapper(child: HomeScreen()),
                    ),
                    (route) => false,
                  );
                },
              ),
            ],
          ),
          drawer: sidebar.Sidebar(onItemSelected: _handleNavigation),
          body: Column(
            children: [
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.blue.shade700,
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(80),
                    bottomRight: Radius.circular(80),
                  ),
                ),
                padding: const EdgeInsets.only(
                    left: 20.0, right: 20.0, bottom: 6.0, top: 10.0),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ListView(
                    children: [
                      _buildDashboardCard(
                        icon: Icons.calendar_today,
                        label: 'View Placement Schedule',
                        color: Colors.orange,
                        onTap: () {
                          // Navigate directly to PlacementScheduleScreen
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  const PlacementScheduleScreen(),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 16.0),
                      _buildDashboardCard(
                        icon: Icons.upload_file,
                        label: 'Upload Documents',
                        color: Colors.green,
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                const UploadDocumentsScreen(),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16.0),
                      _buildDashboardCard(
                        icon: Icons.insert_drive_file,
                        label: 'Upload Offer Letter',
                        color: Colors.purple,
                        onTap: () => _handleNavigation(39),
                      ),
                      const SizedBox(height: 16.0),
                      _buildDashboardCard(
                        icon: Icons.work,
                        label: 'View Jobs',
                        color: Colors.blue,
                        onTap: () => _handleNavigation(40),
                      ),
                      const SizedBox(height: 16.0),
                      _buildDashboardCard(
                        icon: Icons.description,
                        label: 'Create Resume',
                        color: Colors.red,
                        onTap: () => _handleNavigation(41),
                      ),
                      const SizedBox(height: 16.0),
                      _buildDashboardCard(
                        icon: Icons.list_alt,
                        label: 'View Applications',
                        color: Colors.teal,
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                const ViewApplicationsScreen(),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          bottomNavigationBar: const BottomBar(currentIndex: 2),
        ),
      ),
    );
  }

  Widget _buildDashboardCard({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    Color cardColor = Colors.blue.shade700;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 100,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.0),
          gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [
              cardColor,
              cardColor.withOpacity(0.7),
            ],
          ),
          boxShadow: [
            BoxShadow(
              color: cardColor.withOpacity(0.4),
              blurRadius: 12,
              offset: const Offset(0, 6),
              spreadRadius: 2,
            ),
          ],
        ),
        child: Stack(
          children: [
            Positioned(
              right: -15,
              bottom: -15,
              child: Icon(
                icon,
                size: 100,
                color: Colors.white.withOpacity(0.15),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: cardColor.withOpacity(0.2),
                          blurRadius: 8,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Icon(
                      icon,
                      size: 30.0,
                      color: cardColor,
                    ),
                  ),
                  const SizedBox(width: 20.0),
                  Flexible(
                    child: Text(
                      label,
                      style: const TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 10.0),
                  Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.white.withOpacity(0.7),
                    size: 20.0,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
