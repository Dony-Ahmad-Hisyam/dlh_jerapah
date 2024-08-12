import 'package:dlh_project/pages/warga_screen/Berita.dart';
import 'package:dlh_project/pages/warga_screen/sampah_liar.dart';
import 'package:dlh_project/pages/warga_screen/sampah_terpilah.dart';
import 'package:flutter/material.dart';
import 'package:dlh_project/constant/color.dart';

class HomeKontenPetugas extends StatelessWidget {
  const HomeKontenPetugas({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.only(top: 27, left: 20),
            alignment: Alignment.centerLeft,
            child: const Text(
              "Selamat Datang!",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Colors.black,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10, right: 10, top: 13),
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: purple,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 21, top: 30, bottom: 30),
                    child: Image.asset(
                      'assets/images/logo.png',
                      width: 90,
                      height: 80,
                    ),
                  ),
                  const Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(left: 1),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            'Jerapah',
                            style: TextStyle(
                              fontSize: 24,
                              color: white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(height: 5),
                          Text(
                            '( Jemput Ragam Sampah )',
                            style: TextStyle(
                              fontSize: 16,
                              color: white,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 15),
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: ListView(
                shrinkWrap:
                    true, // Needed to allow ListView within SingleChildScrollView
                physics:
                    const NeverScrollableScrollPhysics(), // Prevent scrolling inside ListView
                children: [
                  _buildOuterCard(
                    name: "Username",
                    phone: "0928329032323",
                    status: "Menunggu Konfirmasi",
                    location: "Cilegon bersinar rt/rw 2/1",
                    description: "sampah kardus 30kg",
                  ),
                  // You can add more outer cards here
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOuterCard({
    required String name,
    required String phone,
    required String status,
    required String location,
    required String description,
  }) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      elevation: 8,
      color: purple,
      margin: const EdgeInsets.symmetric(vertical: 12),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Sampah Terpilah',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 10),
            _buildInnerCard(
              name: name,
              phone: phone,
              status: status,
              location: location,
              description: description,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInnerCard({
    required String name,
    required String phone,
    required String status,
    required String location,
    required String description,
  }) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Nama   : $name',
              style: const TextStyle(
                fontSize: 16,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'No. Hp  : $phone',
              style: const TextStyle(
                fontSize: 16,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Text(
                  'Status  : ',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.yellow,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Text(
                    status,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Lokasi  : $location',
              style: const TextStyle(
                fontSize: 16,
                color: Colors.black,
              ),
            ),
            const Text("lihat Lokasi"),
            const SizedBox(height: 8),
            Text(
              'Deskripsi: $description',
              style: const TextStyle(
                fontSize: 16,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
