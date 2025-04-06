import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'home.dart';

class SplashVideoScreen extends StatefulWidget {
  const SplashVideoScreen({Key? key}) : super(key: key);

  @override
  State<SplashVideoScreen> createState() => _SplashVideoScreenState();
}

class _SplashVideoScreenState extends State<SplashVideoScreen> with SingleTickerProviderStateMixin {
  late VideoPlayerController _controller;
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;
  bool _isVideoInitialized = false;

  @override
  void initState() {
    super.initState();

    // Initialize fade animation
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeIn,
    );

    // Preload the video during the splash screen phase
    _controller = VideoPlayerController.asset('assets/Splash_video.mp4')
      ..initialize().then((_) {
        setState(() {
          _isVideoInitialized = true;
          _fadeController.forward(); // Start fade-in animation
          _controller.play();
        });

        // Listen for video completion
        _controller.addListener(() {
          if (_controller.value.position >= _controller.value.duration) {
            // Navigate to home screen immediately when video completes
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => const HomeScreen(),
              ),
            );
          }
        });
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: _isVideoInitialized
            ? FadeTransition(
                opacity: _fadeAnimation,
                child: AspectRatio(
                  aspectRatio: _controller.value.aspectRatio,
                  child: VideoPlayer(_controller),
                ),
              )
            : AspectRatio(
                aspectRatio: 16 / 9, // Match the video aspect ratio
                child: Image.asset(
                  'assets/image.png', // Placeholder image
                  fit: BoxFit.cover,
                ),
              ),
      ),
    );
  }
}