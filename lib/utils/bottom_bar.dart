import 'package:flutter/material.dart';
import 'home.dart';
import 'profile.dart';
import 'search_screen.dart';
import '../main.dart';  // Import main.dart for ExitConfirmationWrapper

class BottomBar extends StatelessWidget {
  final int currentIndex;
  
  const BottomBar({
    Key? key, 
    this.currentIndex = 0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.book),
          label: 'Courses',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.search),
          label: 'Search',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'Profile',
        ),
      ],
      currentIndex: currentIndex,
      selectedItemColor: Colors.blue,
      unselectedItemColor: Colors.grey,
      showUnselectedLabels: true,
      onTap: (index) {
        if (index == currentIndex) return;
        
        if (index == 0) {
          // If already at root (no previous routes), don't do anything
          if (Navigator.of(context).canPop() == false) return;
          
          // Navigate to HomeScreen with ExitConfirmationWrapper to ensure exit dialog works
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => const ExitConfirmationWrapper(child: HomeScreen()),
            ),
            (route) => false, // Remove all previous routes
          );
        } else if (index == 1) {
          // Show coming soon message for Courses
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Courses feature will be implemented soon!'),
              duration: Duration(seconds: 2),
            ),
          );
        } else if (index == 2) {
          // Don't push a new route if we're already on search screen
          if (currentIndex == 2) return;
          
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const SearchScreen(autoFocusSearch: false)),
          );
        } else if (index == 3) {
          // Don't push a new route if we're already on profile screen
          if (currentIndex == 3) return;
          
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ProfileScreen()),
          );
        }
      },
    );
  }
}