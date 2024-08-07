import 'package:flutter/material.dart';

class Akun extends StatelessWidget {
  const Akun({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Akun'),
      ),
      body: const Center(
        child: Text('Akun Page'),
      ),
    );
  }
}
