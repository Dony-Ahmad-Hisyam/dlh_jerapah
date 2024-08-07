import 'package:flutter/material.dart';

class Berita extends StatelessWidget {
  const Berita({super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double padding = 10.0; // Total padding 5+5=10
    double imageWidth = screenWidth - padding; // Lebar gambar dengan padding

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: const Text(
          'Berita',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontWeight: FontWeight.w700,
            color: Colors.black,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(5),
        children: [
          Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Gambar pertama
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: AspectRatio(
                    aspectRatio: 16 / 9, // Rasio aspek default gambar
                    child: Image.asset(
                      "assets/images/kantor.jpg",
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: imageWidth,
                  child: const Text(
                    "Kantor",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 5),
                SizedBox(
                  width: imageWidth,
                  child: const Text(
                    "Kantor (serapan dari bahasa Belanda kantoor, yang diturunkan dari bahasa Prancis comptoir) adalah sebutan untuk tempat yang digunakan untuk perniagaan. Kantor juga dapat merujuk kepada organisasi atau badan yang menyediakan pelayanan tertentu.",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 20),
                // Gambar kedua
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: AspectRatio(
                    aspectRatio: 16 / 9, // Rasio aspek default gambar
                    child: Image.asset(
                      "assets/images/pegawai.jpg",
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: imageWidth,
                  child: const Text(
                    "Pegawai",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 5),
                SizedBox(
                  width: imageWidth,
                  child: const Text(
                    "Pegawai adalah seseorang yang bekerja untuk orang lain atau perusahaan dan mendapatkan upah atau gaji sebagai imbalan atas pekerjaannya.",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 20),
                // Gambar ketiga
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: AspectRatio(
                    aspectRatio: 16 / 9, // Rasio aspek default gambar
                    child: Image.asset(
                      "assets/images/rapat.jpg",
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: imageWidth,
                  child: const Text(
                    "Rapat",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 5),
                SizedBox(
                  width: imageWidth,
                  child: const Text(
                    "Rapat adalah pertemuan dua orang atau lebih untuk membahas atau memutuskan suatu masalah. Rapat sering diadakan untuk membahas masalah pekerjaan atau organisasi.",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
