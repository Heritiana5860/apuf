import 'package:app/components/text.dart';
import 'package:flutter/material.dart';

class NoConnection extends StatefulWidget {
  const NoConnection({super.key});

  @override
  State<NoConnection> createState() => _NoConnectionState();
}

class _NoConnectionState extends State<NoConnection> {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.1),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                "assets/img/avatar.png",
                width: screenWidth * 0.6,
                height: screenHeight * 0.3,
              ),
              SizedBox(height: screenHeight * 0.03),
              TextWidget(
                label: "Connexion Perdue!",
                fontSize: screenWidth * 0.06,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
              SizedBox(height: screenHeight * 0.02),
              Text(
                "Vérifiez votre connexion internet et réessayez.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: screenWidth * 0.04,
                ),
              ),
              SizedBox(height: screenHeight * 0.04),
            ],
          ),
        ),
      ),
    );
  }
}
