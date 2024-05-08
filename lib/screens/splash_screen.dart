import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Add this import for SystemChrome
import 'package:madlyvpn/screens/home_screen.dart';
import 'package:get/get.dart';
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late Size mq;

  @override
  void initState() {
    super.initState();

    // Enable edge-to-edge system UI mode
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

    // Delay opening the HomePage by 2 seconds
    Future.delayed(const Duration(seconds: 2), () {
      Get.off(()=>HomeScreen());
    });
  }

  @override
  Widget build(BuildContext context) {
    mq = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.lightBlueAccent,
      body: Stack(
        children: [
          Positioned(
            top: mq.height * 0.2,
            width: mq.height * 0.5,
            left: mq.width * 0.0,
            child: Image.asset('assets/images/logo.png'),
          ),
          // Centered text
          Positioned(
            bottom: mq.height * 0.15,
            right: mq.width * 0.15,
            child: const Center(
              child: Text(
                'GET INFINITE WITH MORE ACCESS',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2.0
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
