import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Uptd extends StatefulWidget {
  const Uptd({super.key});

  @override
  _UptdState createState() => _UptdState();
}

class _UptdState extends State<Uptd> {
  final String baseUrl = "https://jera.kerissumenep.com/api/kecamatan";
  late Future<List<Map<String, dynamic>>> _kecamatanData;

  @override
  void initState() {
    super.initState();
    _kecamatanData = fetchKecamatanData();
  }

  Future<List<Map<String, dynamic>>> fetchKecamatanData() async {
    final response = await http.get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final List<Map<String, dynamic>> kecamatanList = [];

      for (var item in data['data']) {
        kecamatanList.add({
          'id': item['id'],
          'nama_kecamatan': item['nama_kecamatan'],
          'upt': item['upt']['nama_upt'],
        });
      }
      return kecamatanList;
    } else {
      throw Exception('Failed to load kecamatan data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          'UPTD/TPS',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: Colors.black,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              height: 140,
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 57, 87, 254),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Center(
                child: Text(
                  'Daftar Wilayah\nUPTD/TPS',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 24,
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: FutureBuilder<List<Map<String, dynamic>>>(
                future: _kecamatanData,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text('No data available'));
                  }

                  final kecamatanList = snapshot.data!;

                  return ListView.builder(
                    itemCount: kecamatanList.length,
                    itemBuilder: (context, index) {
                      final kecamatan = kecamatanList[index];
                      return _buildCard(
                        kecamatan['upt'],
                        [kecamatan['nama_kecamatan']],
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCard(String title, List<String> items) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 5),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 5),
            for (var item in items)
              Text(
                item,
                style: const TextStyle(fontSize: 16),
              ),
          ],
        ),
      ),
    );
  }
}
