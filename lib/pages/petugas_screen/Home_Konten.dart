import 'package:dlh_project/pages/petugas_screen/penimbangan.dart';
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

Future<void> updateStatus(
    int idSampah, int idUserPetugas, String action) async {
  final prefs = await SharedPreferences.getInstance();
  final String? token = prefs.getString('token');

  final String apiUrl =
      'https://jera.kerissumenep.com/api/pengangkutan-sampah/proses/$idSampah';

  final Map<String, String> headers = {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer $token',
  };

  final Map<String, dynamic> body = {
    'id_user_petugas': idUserPetugas,
  };

  try {
    // Send the POST request
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: headers,
      body: json.encode(body),
    );

    if (response.statusCode == 200) {
      print('Status updated successfully.');
    } else {
      // Handle the error
      final errorMessage =
          jsonDecode(response.body)['message'] ?? 'Unknown error';
      throw Exception('Failed to update status: $errorMessage');
    }
  } catch (e) {
    // Handle any exceptions
    throw Exception('Error updating status: $e');
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
                      case 'pending':
                        statusColor = Colors.orange.shade300;
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
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Sampah Terpilah',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        _showDeleteConfirmationDialog(context);
                      },
                      icon: const Icon(Icons.delete),
                      color: Colors.red,
                      hoverColor: Colors.red.shade700,
                      focusColor: Colors.red,
                      splashColor: Colors.red.shade200,
                    )
                  ],
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
    // Determine button text and onPressed function based on status
    String buttonText;
    void Function()? buttonOnPressed;

    if (status.toLowerCase() == 'pending') {
      buttonText = 'Proses';
      buttonOnPressed = () => _showConfirmationDialog(
            context,
            idSampah,
            idUserPetugas,
            'proses',
          );
    } else if (status.toLowerCase() == 'proses') {
      buttonText = 'Done';
      buttonOnPressed = () => _showConfirmationDialog(
            context,
            idSampah,
            idUserPetugas,
            'done',
          );
    } else {
      buttonText = 'Status Unknown';
      buttonOnPressed = null;
    }

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
                      color: statusColor,
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
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 5),
                    child: ElevatedButton(
                      onPressed: () => _openMap(mapUrl),
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.green,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 13),
                      ),
                      child: const Text(
                        'Buka Map',
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    child: ElevatedButton(
                      onPressed: buttonOnPressed,
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.blueAccent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      child: Text(
                        buttonText,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showConfirmationDialog(
      BuildContext context, int idSampah, int idUserPetugas, String action) {
    String dialogTitle;
    String dialogContent;

    switch (action) {
      case 'proses':
        dialogTitle = 'Konfirmasi Proses';
        dialogContent =
            'Apakah Anda yakin ingin mengupdate status menjadi proses?';
        break;
      case 'done':
        dialogTitle = 'Konfirmasi Done';
        dialogContent =
            'Apakah Anda yakin ingin mengupdate status menjadi done? Pastikan data penimbangan sudah diisi.';
        break;
      default:
        dialogTitle = 'Konfirmasi';
        dialogContent = 'Apakah Anda yakin ingin melanjutkan tindakan ini?';
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(dialogTitle),
          content: Text(dialogContent),
          actions: <Widget>[
            TextButton(
              child: const Text('Batal'),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
            ElevatedButton(
              child: const Text('Ya'),
              onPressed: () async {
                Navigator.of(context).pop(); // Close the dialog

                if (action == 'done') {
                  // Navigate to Penimbangan screen
                  bool isDataFilled = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Penimbangan(idSampah: idSampah),
                    ),
                  );

                  if (!isDataFilled) {
                    // Show a message if data is not filled
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                            'Silakan isi data penimbangan terlebih dahulu.'),
                      ),
                    );
                    return;
                  }
                }

                // Show a loading snackbar
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Memproses pembaruan status...'),
                  ),
                );

                try {
                  // Perform the status update based on action
                  if (action == 'proses') {
                    await updateStatus(idSampah, idUserPetugas, 'proses');
                  } else if (action == 'done') {
                    await updateStatus(idSampah, idUserPetugas, 'done');
                  }

                  // Show success snackbar
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Status berhasil diperbarui'),
                    ),
                  );

                  // Refresh data after status update
                  setState(() {
                    futureSampahData = fetchSampahData();
                  });
                } catch (e) {
                  // Show error snackbar
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Gagal memperbarui status: $e'),
                    ),
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
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not launch map: $mapUrl')),
      );
    }
  }

  void _showDeleteConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Konfirmasi Hapus'),
          content: const Text(
              'Apakah Anda yakin ingin menghapus permohonan sampah ini?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Batal'),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
            ElevatedButton(
              child: const Text('Hapus'),
              onPressed: () {
                // Perform the delete action here

                Navigator.of(context).pop(); // Close the dialog
              },
            ),
          ],
        );
      },
    );
  }
}
