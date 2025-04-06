import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'utils/home.dart';
import 'utils/splash_video_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fusion IIIT',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      // Remove the home property since we're using initialRoute and routes
      navigatorObservers: [ExitConfirmationObserver()],
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashVideoScreen(),
        '/home': (context) => const ExitConfirmationWrapper(child: HomeScreen()),
      },
    );
  }
}

// Observer to track navigation history
class ExitConfirmationObserver extends NavigatorObserver {
  static bool isOnRootScreen = true;
  static final List<Route<dynamic>> _routes = [];
  
  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPush(route, previousRoute);
    _routes.add(route);
    _updateRootScreenState();
  }
  
  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPop(route, previousRoute);
    if (_routes.contains(route)) {
      _routes.remove(route);
    }
    _updateRootScreenState();
  }
  
  @override
  void didRemove(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didRemove(route, previousRoute);
    if (_routes.contains(route)) {
      _routes.remove(route);
    }
    _updateRootScreenState();
  }
  
  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
    if (oldRoute != null && _routes.contains(oldRoute)) {
      final index = _routes.indexOf(oldRoute);
      if (newRoute != null) {
        _routes[index] = newRoute;
      } else {
        _routes.removeAt(index);
      }
    } else if (newRoute != null) {
      _routes.add(newRoute);
    }
    _updateRootScreenState();
  }

  void _updateRootScreenState() {
    // If we're on the initial route or there's only one route left, we're on the root screen
    isOnRootScreen = _routes.isEmpty || _routes.length == 1;
    debugPrint('Route count: ${_routes.length}, isOnRootScreen: $isOnRootScreen');
  }
  
  // Reset route tracking (useful when app is restarted or when we need to force a reset)
  static void reset() {
    _routes.clear();
    isOnRootScreen = true;
  }
}

// Custom wrapper widget to handle the exit confirmation dialog
class ExitConfirmationWrapper extends StatefulWidget {
  final Widget child;
  
  const ExitConfirmationWrapper({
    Key? key, 
    required this.child
  }) : super(key: key);
  
  @override
  State<ExitConfirmationWrapper> createState() => _ExitConfirmationWrapperState();
}

class _ExitConfirmationWrapperState extends State<ExitConfirmationWrapper> {
  @override
  void initState() {
    super.initState();
    // Reset route tracking when wrapper is created
    ExitConfirmationObserver.reset();
  }
  
  Future<bool> _onWillPop() async {
    // Show exit dialog if on root screen
    if (ExitConfirmationObserver.isOnRootScreen) {
      bool shouldExit = await showDialog<bool>(
        context: context,
        barrierDismissible: false,
        builder: (context) => Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 8,
          backgroundColor: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.exit_to_app_rounded,
                  size: 48,
                  color: Colors.blue,
                ),
                const SizedBox(height: 16),
                const Text(
                  'Exit App?',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Are you sure you want to exit the app?',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(false),
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.grey[700],
                        backgroundColor: Colors.grey[200],
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text('Cancel'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop(true);
                        SystemNavigator.pop(); // Force close the app
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text('Exit'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ) ?? false;
      
      return shouldExit;
    } else {
      // If not on the root screen, just go back
      return true;
    }
  }

  @override
  Widget build(BuildContext context) {
    // Replaced 'PopScope' with 'WillPopScope' to handle back navigation properly
    return WillPopScope(
      onWillPop: _onWillPop,
      child: widget.child,
    );
  }
}
