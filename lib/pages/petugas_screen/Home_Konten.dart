import 'package:dlh_project/pages/petugas_screen/sampah.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';

Future<List<SampahData>> fetchSampahData() async {
  final prefs = await SharedPreferences.getInstance();
  final uptIdString = prefs.getString('upt_id');
  final uptId = int.tryParse(uptIdString ?? '0');

  if (uptId == 0) {
    throw Exception('User ID not found in SharedPreferences');
  }

  final urls = [
    'https://jera.kerissumenep.com/api/pengangkutan-sampah/history/by-upt/$uptId/pending',
    'https://jera.kerissumenep.com/api/pengangkutan-sampah/history/by-upt/$uptId/proses',
  ];

  List<SampahData> allData = [];

  for (String url in urls) {
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body)['data'];
      allData.addAll(data.map((item) => SampahData.fromJson(item)).toList());
    } else {
      throw Exception('Failed to load data from $url');
    }
  }

  // Balikkan daftar agar data terbaru tampil di atas
  allData.sort((a, b) => b.id.compareTo(a.id));

  return allData;
}

Future<void> updateStatus(int idSampah, int idUserPetugas) async {
  final url = Uri.parse(
      'https://jera.kerissumenep.com/api/pengangkutan-sampah/proses/$idSampah');
  final response = await http.post(
    url,
    headers: {
      'Content-Type': 'application/json',
    },
    body: jsonEncode({
      'id_user_petugas': idUserPetugas,
    }),
  );

  if (response.statusCode == 200) {
    print('Status updated successfully');
  } else {
    final errorMessage =
        jsonDecode(response.body)['message'] ?? 'Unknown error';
    throw Exception('Failed to update status: $errorMessage');
  }
}

class HomeKontenPetugas extends StatefulWidget {
  final String userName;
  final int userId;

  const HomeKontenPetugas({
    super.key,
    required this.userName,
    required this.userId,
  });

  @override
  _HomeKontenPetugasState createState() => _HomeKontenPetugasState();
}

class _HomeKontenPetugasState extends State<HomeKontenPetugas> {
  late Future<List<SampahData>> futureSampahData;

  @override
  void initState() {
    super.initState();
    futureSampahData = fetchSampahData();
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
                Flexible(
                  child: Text(
                    "Selamat Datang, ${widget.userName}!",
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Colors.black,
                    ),
                    softWrap: true,
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.green,
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
          const SizedBox(height: 15),
          FutureBuilder<List<SampahData>>(
            future: futureSampahData,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(child: Text('Tidak ada data Riwayat.'));
              } else {
                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    SampahData data = snapshot.data![index];
                    Color statusColor;

                    switch (data.status.toLowerCase()) {
                      case 'proses':
                        statusColor = Colors.yellow;
                        break;
                      case 'done':
                        statusColor = Colors.green;
                        break;
                      case 'pending':
                        statusColor = Colors.orange.shade300;
                        break;
                      case 'failed':
                        statusColor = Colors.red;
                        break;
                      default:
                        statusColor = Colors.grey;
                    }

                    return _buildOuterCard(
                      name: data.name,
                      namaUpt: data.namaUpt,
                      FotoSampah: data.fotoSampah,
                      phone: data.noHp,
                      status: data.status,
                      lokasi:
                          '${data.alamat.kelurahan}, ${data.alamat.kecamatan}, ${data.alamat.deskripsi}',
                      description: data.deskripsi,
                      mapUrl: data.alamat.kordinat,
                      idSampah: data.id,
                      idUserPetugas: widget.userId,
                      statusColor: statusColor,
                    );
                  },
                );
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildOuterCard({
    required String name,
    required String namaUpt,
    // ignore: non_constant_identifier_names
    required String FotoSampah,
    required String phone,
    required String status,
    required String lokasi,
    required String description,
    required String mapUrl,
    required int idSampah,
    required int idUserPetugas,
    required Color statusColor,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Card(
        color: Colors.blue,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        elevation: 8,
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
                fotoSampah: FotoSampah,
                namaUpt: namaUpt,
                phone: phone,
                status: status,
                lokasi: lokasi,
                description: description,
                mapUrl: mapUrl,
                idSampah: idSampah,
                idUserPetugas: idUserPetugas,
                statusColor: statusColor,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInnerCard({
    required String name,
    required String namaUpt,
    required String fotoSampah,
    required String phone,
    required String status,
    required String lokasi,
    required String description,
    required String mapUrl,
    required int idSampah,
    required int idUserPetugas,
    required Color statusColor,
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
              'Nama       : $name',
              style: const TextStyle(
                fontSize: 16,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'UPT          : $namaUpt',
              style: const TextStyle(
                fontSize: 16,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'No. Hp     : $phone',
              style: const TextStyle(
                fontSize: 16,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Text(
                  'Status      : ',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                  ),
                ),
                Flexible(
                  child: Container(
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
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Lokasi      : $lokasi',
              style: const TextStyle(
                fontSize: 16,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Deskripsi : $description',
              style: const TextStyle(
                fontSize: 16,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 8),
            if (fotoSampah.isNotEmpty)
              Image.network(
                'https://jera.kerissumenep.com/storage/foto-sampah/$fotoSampah',
                errorBuilder: (context, error, stackTrace) {
                  return const Text('Gambar tidak dapat ditampilkan');
                },
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                },
              )
            else
              const Text('Tidak ada foto tersedia.'),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: () => _openMap(mapUrl),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.green,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text('Buka Map'),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () =>
                      _showConfirmationDialog(context, idSampah, idUserPetugas),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.blueAccent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text('Update Proses'),
                ),
              ],
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  void _showConfirmationDialog(
      BuildContext context, int idSampah, int idUserPetugas) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Konfirmasi'),
          content: const Text(
              'Apakah Anda yakin ingin mengupdate status menjadi proses ?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Batal'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              child: const Text('Ya'),
              onPressed: () async {
                Navigator.of(context).pop(); // Close the dialog
                try {
                  // Menampilkan indikator snackbar sebelum memulai proses pembaruan status
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Memproses pembaruan status...')),
                  );

                  await updateStatus(idSampah, idUserPetugas);

                  // Menampilkan snackbar ketika pembaruan status berhasil
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Status berhasil diperbarui')),
                  );

                  // Memperbarui data setelah status diperbarui
                  setState(() {
                    futureSampahData = fetchSampahData();
                  });
                } catch (e) {
                  // Menampilkan snackbar ketika pembaruan status gagal
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Gagal memperbarui status: $e')),
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }

  void _openMap(String mapUrl) async {
    final Uri url = Uri.parse(mapUrl);
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      throw Exception('Could not launch $mapUrl');
    }
  }
}
