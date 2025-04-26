import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:rise/layout/home_screen_layout.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 4), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeScreenLayout()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        child: Stack(
          children: [
            Center(
              child: Lottie.asset(
                "assets/lottie/Animation.json",
                width: 300,
                height: 300,
                fit: BoxFit.fill,
                repeat: true,
                reverse: true,
                animate: true,
              ),
            ),
            Positioned(
              bottom: 0,
              child: Lottie.asset(
                "assets/lottie/fire.json",
                width: MediaQuery.of(context).size.width,
                height: 500,
                fit: BoxFit.fill,
                repeat: true,
                reverse: true,
                animate: true,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
