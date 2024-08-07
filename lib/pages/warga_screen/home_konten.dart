import 'package:dlh_project/pages/warga_screen/Berita.dart';
import 'package:dlh_project/pages/warga_screen/sampah_liar.dart';
import 'package:dlh_project/pages/warga_screen/sampah_terpilah.dart';
import 'package:flutter/material.dart';
import 'package:dlh_project/constant/color.dart';

class HomeKonten extends StatelessWidget {
  const HomeKonten({super.key});

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
          const SizedBox(
            height: 15,
          ),
          // foto Instansi
          Container(
            padding: const EdgeInsets.only(left: 10, right: 10),
            height: 174,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                Image.asset("assets/images/kantor.jpg"),
                const SizedBox(width: 10),
                Image.asset("assets/images/pegawai.jpg"),
                const SizedBox(width: 10),
                Image.asset("assets/images/rapat.jpg"),
              ],
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Container(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                Container(
                  alignment: Alignment.topLeft,
                  child: const Text(
                    "Layanan Sampah",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.w700),
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const SampahTerpilah(),
                            ),
                          );
                        },
                        child: Container(
                          height: 80,
                          decoration: BoxDecoration(
                            color: Colors.green,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Padding(
                                padding: EdgeInsets.only(left: 7),
                              ),
                              Image.asset(
                                "assets/images/sampah.png",
                                height: 70,
                              ),
                              const SizedBox(width: 10),
                              const Text(
                                "Sampah\nTerpilah",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.normal,
                                  fontSize: 18,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const SampahLiar(),
                            ),
                          );
                        },
                        child: Container(
                          height: 80,
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Padding(
                                padding: EdgeInsets.only(left: 7),
                              ),
                              Image.asset(
                                "assets/images/sampahliar.png",
                                height: 80,
                              ),
                              const SizedBox(width: 10),
                              const Text(
                                "Sampah\nLiar",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.normal,
                                  fontSize: 18,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 2,
          ),
          // berita
          Container(
            padding: const EdgeInsets.only(left: 10, right: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Padding(
                  padding: EdgeInsets.only(left: 5),
                  child: Text(
                    "Berita",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Colors.black,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const Berita(),
                      ),
                    );
                  },
                  child: Container(
                    decoration: const BoxDecoration(
                      color: softPurple,
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                    ),
                    child: const Padding(
                      padding: EdgeInsets.all(8),
                      child: Text(
                        "Semua",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: purple,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 7,
          ),
          Container(
            padding: const EdgeInsets.only(left: 10, right: 10),
            height: 250,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                Column(
                  children: [
                    Image.asset(
                      "assets/images/kantor.jpg",
                      height: 160,
                      width: 250,
                      fit: BoxFit.cover,
                    ),
                    const SizedBox(height: 5),
                    const SizedBox(
                      width: 250,
                      child: Text(
                        "Dinas Lingkungan Hidup (DLH) Kota Cilegon, bentuk tim khusus penanganan sampah di setiap sungai di Kota Cilegon,",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 10),
                Column(
                  children: [
                    Image.asset(
                      "assets/images/pegawai.jpg",
                      height: 160,
                      width: 250,
                      fit: BoxFit.cover,
                    ),
                    const SizedBox(height: 5),
                    const SizedBox(
                      width: 250,
                      child: Text(
                        "Dinas Lingkungan Hidup Kota Cilegon. 140 likes. Alamat : Jl. Kubang Laban No. 1 Bendung Karet ( samping pasar Hewan Kp. Kubang Laban )",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 10),
                Column(
                  children: [
                    Image.asset(
                      "assets/images/rapat.jpg",
                      height: 160,
                      width: 250,
                      fit: BoxFit.cover,
                    ),
                    const SizedBox(height: 5),
                    const SizedBox(
                      width: 250,
                      child: Text(
                        "Kantor (serapan dari bahasa Belanda kantoor, yang diturunkan dari bahasa Prancis comptoir) adalah sebutan untuk tempat yang digunakan untuk perniagaan",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
