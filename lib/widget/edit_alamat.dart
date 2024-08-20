import 'package:dlh_project/constant/color.dart';
import 'package:flutter/material.dart';

class EditAlamatScreen extends StatefulWidget {
  final Map<String, dynamic> alamat;

  // Corrected constructor
  EditAlamatScreen({required this.alamat});

  @override
  _EditAlamatScreenState createState() => _EditAlamatScreenState();
}

class _EditAlamatScreenState extends State<EditAlamatScreen> {
  late TextEditingController _kecamatanController;
  late TextEditingController _kelurahanController;
  late TextEditingController _deskripsiController;

  @override
  void initState() {
    super.initState();

    // Initialize the controllers with the current values of the alamat data
    _kecamatanController =
        TextEditingController(text: widget.alamat['kecamatan']);
    _kelurahanController =
        TextEditingController(text: widget.alamat['kelurahan']);
    _deskripsiController =
        TextEditingController(text: widget.alamat['deskripsi']);
  }

  @override
  void dispose() {
    // Dispose the controllers when the widget is removed from the widget tree
    _kecamatanController.dispose();
    _kelurahanController.dispose();
    _deskripsiController.dispose();
    super.dispose();
  }

  void _saveChanges() {
    // Create a new map with the updated data
    final updatedAlamat = {
      'kecamatan': _kecamatanController.text,
      'kelurahan': _kelurahanController.text,
      'deskripsi': _deskripsiController.text,
      'kordinat':
          widget.alamat['kordinat'], // Preserve the original coordinates
    };

    // Handle the save logic, such as updating a list or database
    Navigator.of(context).pop(
        updatedAlamat); // Pass the updated data back when popping the screen
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: const Text(
          'Edit Alamat',
          textAlign: TextAlign.center,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            TextField(
              controller: _kecamatanController,
              decoration: const InputDecoration(
                labelText: 'Kecamatan',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _kelurahanController,
              decoration: const InputDecoration(
                labelText: 'Kelurahan',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _deskripsiController,
              decoration: const InputDecoration(
                labelText: 'Deskripsi',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveChanges,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
              ),
              child: const Text(
                'Save',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
