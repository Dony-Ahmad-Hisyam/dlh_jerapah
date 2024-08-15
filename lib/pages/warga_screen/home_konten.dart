import 'package:dlh_project/pages/form_opening/login.dart';
import 'package:flutter/material.dart';
import 'package:dlh_project/pages/warga_screen/Berita.dart';
import 'package:dlh_project/pages/warga_screen/sampah_liar.dart';
import 'package:dlh_project/pages/warga_screen/sampah_terpilah.dart';
import 'package:dlh_project/constant/color.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeKonten extends StatefulWidget {
  final int userId;

  const HomeKonten({super.key, required this.userId, required String userName});

  @override
  State<HomeKonten> createState() => _HomeKontenState();
}

class _HomeKontenState extends State<HomeKonten> {
  String? userName;

  @override
  void initState() {
    super.initState();
    _loadUserName();
  }

  Future<void> _loadUserName() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userName = prefs.getString('user_name') ?? 'Guest';
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.only(top: 27, left: 20, right: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Selamat Datang, ${userName ?? 'Guest'}!",
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: green,
                    borderRadius: BorderRadius.circular(8.0),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 6.0,
                        offset: Offset(2, 2),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
                    child: Text(
                      "${widget.userId}",
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10, right: 10, top: 13),
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: BlurStyle,
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
          const SizedBox(height: 10),
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
                          if (userName == 'Guest') {
                            _showLoginRequiredDialog(context);
                          } else {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const SampahTerpilah(),
                              ),
                            );
                          }
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
                              const SizedBox(width: 1),
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
                              const SizedBox(width: 1),
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
          const SizedBox(height: 2),
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
                          color: BlurStyle,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 7),
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
                        "Dinas Lingkungan Hidup Kota Cilegon. 140 likes. Alamat : Jl. Kubang Laban No. 1 Bendung Karet ( samping perumahan Pondok Cilegon Indah )",
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
                        "Hadir dalam kegiatan pengembangan pengolahan sampah di daerah terpencil dan pesisir",
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
          ),
          const SizedBox(height: 50),
        ],
      ),
    );
  }

  void _showLoginRequiredDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Login Diperlukan"),
          content: const Text(
              "Anda harus login terlebih dahulu untuk mengakses fitur ini."),
          actions: <Widget>[
            TextButton(
              child: const Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
