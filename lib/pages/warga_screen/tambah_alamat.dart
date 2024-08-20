import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert'; // Untuk jsonEncode
import 'package:shared_preferences/shared_preferences.dart';
import 'package:geolocator/geolocator.dart'; // Untuk mengambil lokasi
import 'package:dlh_project/constant/color.dart';
import 'package:url_launcher/url_launcher.dart'; // Untuk membuka Google Maps

class TambahAlamat extends StatefulWidget {
  const TambahAlamat({super.key});

  @override
  _TambahAlamatState createState() => _TambahAlamatState();
}

class _TambahAlamatState extends State<TambahAlamat> {
  final TextEditingController _kecamatanController = TextEditingController();
  final TextEditingController _kelurahanController = TextEditingController();
  final TextEditingController _deskripsiController = TextEditingController();

  String? _kordinat;
  bool _isLoading = false;

  Future<void> _getCurrentLocation() async {
    setState(() {
      _isLoading = true;
    });

    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      setState(() {
        _kordinat =
            "https://www.google.com/maps/search/?api=1&query=${position.latitude},${position.longitude}";
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal mendapatkan lokasi: $e')),
      );
    }
  }

  Future<void> _tambahAlamat() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt('user_id');
    final token = prefs.getString('token');

    if (userId == null || token == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('ID pengguna atau token tidak ditemukan')),
      );
      return;
    }

    final kecamatan = _kecamatanController.text;
    final kelurahan = _kelurahanController.text;
    final deskripsi = _deskripsiController.text;

    if (kecamatan.isEmpty ||
        kelurahan.isEmpty ||
        _kordinat == null ||
        deskripsi.isEmpty) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Semua field harus diisi dan lokasi harus diambil')),
      );
      return;
    }

    final url = Uri.parse('https://jera.kerissumenep.com/api/alamat/store');
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'id_user': userId,
        'kecamatan': kecamatan,
        'kelurahan': kelurahan,
        'kordinat': _kordinat,
        'deskripsi': deskripsi,
      }),
    );

    if (response.statusCode == 201) {
      final responseData = jsonDecode(response.body);
      if (responseData['success']) {
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(responseData['message'])),
        );
        // ignore: use_build_context_synchronously
        Navigator.pop(context); // Kembali ke halaman sebelumnya
      } else {
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content:
                  Text(responseData['message'] ?? 'Gagal menambah alamat')),
        );
      }
    } else {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Gagal menambah alamat. Coba lagi.')),
      );
    }
  }

  void _lihatLokasi() async {
    if (_kordinat != null) {
      if (await canLaunch(_kordinat!)) {
        await launch(_kordinat!);
      } else {
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Tidak dapat membuka peta.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: const Text(
          'Tambah Alamat',
          textAlign: TextAlign.center,
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 40),
              TextField(
                controller: _kecamatanController,
                decoration: const InputDecoration(
                  labelText: 'Kecamatan',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16.0),
              TextField(
                controller: _kelurahanController,
                decoration: const InputDecoration(
                  labelText: 'Kelurahan',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16.0),
              TextField(
                controller: _deskripsiController,
                decoration: const InputDecoration(
                  labelText: 'Deskripsi ( Rumah, Toko, Kantor )',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16.0),
              Row(
                children: [
                  ElevatedButton(
                    onPressed: _isLoading ? null : _getCurrentLocation,
                    child: _isLoading
                        ? const CircularProgressIndicator(
                            color: Colors.white,
                          )
                        : const Text('Dapatkan Lokasi'),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      _kordinat == null
                          ? "Lokasi belum diambil"
                          : "Alamat Sudah diambil",
                      style: TextStyle(
                        color: _kordinat == null ? Colors.red : Colors.green,
                      ),
                    ),
                  ),
                ],
              ),
              if (_kordinat != null)
                Align(
                  alignment: Alignment.centerLeft,
                  child: TextButton(
                    onPressed: _lihatLokasi,
                    child: const Text('Lihat Lokasi'),
                  ),
                ),
              const SizedBox(height: 24.0),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _tambahAlamat,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: BlurStyle,
                  ),
                  child: const Text(
                    'Simpan Alamat',
                    style: TextStyle(color: white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
