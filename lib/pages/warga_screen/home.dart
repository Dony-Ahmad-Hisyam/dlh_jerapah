import 'dart:ffi';

import 'package:dlh_project/constant/color.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'home_konten.dart'; // Pastikan path ini benar
import 'berita.dart'; // Import halaman lain yang digunakan
import 'akun.dart';
import 'history.dart';
import 'uptd.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  String? userName;
  int? userId;
  bool _isLoggedIn = false;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userName = prefs.getString('user_name') ?? 'Guest';
      userId = prefs.getInt('user_id') ?? 0;
      _isLoggedIn = userName != 'Guest';
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> _pages = [
      HomeKonten(
        userName: userName ?? 'Guest',
        userId: userId ?? 0,
      ),
      if (_isLoggedIn) const History(),
      const Berita(),
      const Uptd(),
      const Akun(),
    ];

    final List<BottomNavigationBarItem> _bottomNavigationBarItems = [
      const BottomNavigationBarItem(
        icon: Icon(Icons.home),
        label: 'Home',
      ),
      if (_isLoggedIn)
        const BottomNavigationBarItem(
          // Tampilkan Riwayat jika login
          icon: Icon(Icons.history),
          label: 'Riwayat',
        ),
      const BottomNavigationBarItem(
        icon: Icon(Icons.newspaper),
        label: 'Berita',
      ),
      const BottomNavigationBarItem(
        icon: Icon(Icons.location_on_rounded),
        label: 'UPTD/TPS',
      ),
      const BottomNavigationBarItem(
        icon: Icon(Icons.person),
        label: 'Akun',
      ),
    ];

    return Scaffold(
      body: SafeArea(
        child: _pages[_selectedIndex],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: _bottomNavigationBarItems,
        currentIndex: _selectedIndex,
        selectedItemColor: BlurStyle,
        unselectedItemColor: grey,
        onTap: _onItemTapped,
        showUnselectedLabels: true,
        selectedLabelStyle: const TextStyle(fontSize: 12),
        unselectedLabelStyle: const TextStyle(fontSize: 12),
        type: BottomNavigationBarType.fixed,
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
}
