import 'package:dlh_project/constant/color.dart';
import 'package:dlh_project/pages/petugas_screen/Home_Konten.dart';
import 'package:dlh_project/pages/petugas_screen/akun_petugas.dart';
import 'package:dlh_project/pages/warga_screen/berita.dart';
import 'package:dlh_project/pages/warga_screen/akun.dart';
import 'package:dlh_project/pages/warga_screen/history.dart';
import 'package:dlh_project/pages/warga_screen/home_konten.dart';
import 'package:dlh_project/pages/warga_screen/uptd.dart';
import 'package:flutter/material.dart';

class HomePetugasPage extends StatefulWidget {
  const HomePetugasPage({super.key});

  @override
  State<HomePetugasPage> createState() => _HomePetugasPageState();
}

class _HomePetugasPageState extends State<HomePetugasPage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = const [
    HomeKontenPetugas(),
    History(),
    Uptd(),
    AkunPetugas(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: _pages[_selectedIndex],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'Riwayat',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.location_on_rounded),
            label: 'UPTD/TPS',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Akun',
          ),
        ],
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
}
