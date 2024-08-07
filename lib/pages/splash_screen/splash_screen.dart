import 'package:dlh_project/constant/color.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background color
          Container(
            color: purple,
          ),
          // Top logo
          Positioned(
            top: 226,
            left: 0,
            right: 0,
            child: Image.asset(
              "assets/icons/logo.png",
              height: 113,
            ),
          ),
          // Center text
          const Center(
            child: Text(
              'JERAPAH',
              style: TextStyle(
                fontSize: 56,
                color: white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
