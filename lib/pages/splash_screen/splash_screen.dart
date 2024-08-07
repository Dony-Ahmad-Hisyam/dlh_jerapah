import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:dlh_project/constant/color.dart';
import 'package:dlh_project/pages/warga_screen/home.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      splash: Stack(
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
      nextScreen: const HomePage(),
      splashIconSize:
          double.infinity, // Ukuran splash screen agar sesuai dengan layar
      backgroundColor: Colors
          .transparent, // Latar belakang transparan agar latar belakang dari splash ditampilkan
      splashTransition:
          SplashTransition.fadeTransition, // Transisi splash screen
      duration: 3000, // Durasi splash screen dalam milidetik
    );
  }
}
