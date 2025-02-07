import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:app/services/connectivity_wrapper.dart';
import 'package:flutter/material.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: AnimatedSplashScreen(
        duration: 5000,
        splash: Center(
          child: TweenAnimationBuilder(
            tween: Tween<double>(begin: 0, end: 1),
            duration: const Duration(seconds: 2),
            builder: (BuildContext context, double value, Widget? child) {
              return Transform.rotate(
                angle: value * 6.283,
                child: child,
              );
            },
            child: Image.asset('assets/img/logoapu.jpeg'),
          ),
        ),
        nextScreen: const ConnectivityWrapper(),
        splashTransition: SplashTransition.fadeTransition,
        backgroundColor: Colors.white,
      ),
    );
  }
}
