import 'dart:io';
import 'package:dlh_project/constant/color.dart';
import 'package:dlh_project/pages/warga_screen/home.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher.dart';

class SampahLiar extends StatefulWidget {
  const SampahLiar({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _SampahLiarState createState() => _SampahLiarState();
}

class _SampahLiarState extends State<SampahLiar> {
  final ImagePicker _picker = ImagePicker();
  XFile? _image;
  final TextEditingController _locationController = TextEditingController();
  String? _latitude;
  String? _longitude;
  bool _locationFetched = false;
  String? _locationUrl;
  bool _photoSelected = false;

  Future<void> _getImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      setState(() {
        _image = pickedFile;
        _photoSelected = true; // Set photoSelected to true
      });
    }
  }

  Future<void> _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      _showErrorDialog('Location services are not enabled');
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission != LocationPermission.whileInUse &&
          permission != LocationPermission.always) {
        _showErrorDialog('Location permissions are not granted');
        return;
      }
    }

    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      setState(() {
        _latitude = position.latitude.toString();
        _longitude = position.longitude.toString();
        _locationUrl =
            'geo:${position.latitude},${position.longitude}?q=${position.latitude},${position.longitude}';
        _locationController.text = 'Sudah mendapatkan lokasi Anda';
        _locationFetched = true;
      });
    } catch (e) {
      _showErrorDialog('Error getting location: $e');
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Error'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _launchURL() async {
    if (_locationUrl != null) {
      final url = _locationUrl!;
      try {
        if (await canLaunch(url)) {
          await launch(
            url,
            forceSafariVC: false,
            forceWebView: false,
          );
        } else {
          _showErrorDialog('Could not launch URL: $url');
        }
      } catch (e) {
        _showErrorDialog('Error launching URL: $e');
      }
    } else {
      _showErrorDialog('Location URL is null');
    }
  }

  @override
  void dispose() {
    _locationController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_locationUrl != null) {
      // Handle form submission logic here
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          'Sampah Liar',
          textAlign: TextAlign.center,
          style: TextStyle(
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
              decoration: BoxDecoration(
                color: red,
                borderRadius: BorderRadius.circular(10),
              ),
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    'Sampah Liar',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 20),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Image.asset(
                          'assets/images/sampahliar.png',
                          height: 100,
                        ),
                        const SizedBox(width: 5),
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Sampah liar adalah sampah yang dibuang sembarangan di tempat yang tidak semestinya tanpa pengelolaan yang benar, menyebabkan pencemaran dan membahayakan kesehatan.",
                                style: TextStyle(
                                    color: white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView(
                children: [
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Data Laporan',
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black),
                        ),
                        const SizedBox(height: 10),
                        const TextField(
                          decoration: InputDecoration(
                            labelText: 'No HP',
                            border: OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(height: 10),
                        TextField(
                          controller: _locationController,
                          decoration: InputDecoration(
                            labelText: 'Lokasi',
                            border: const OutlineInputBorder(),
                            suffixIcon: IconButton(
                              icon: _locationFetched
                                  ? const Icon(Icons.check_circle,
                                      color: Colors.green)
                                  : const Icon(Icons.location_on),
                              onPressed: _getCurrentLocation,
                            ),
                            hintText: _locationFetched
                                ? 'Sudah mendapatkan lokasi Anda'
                                : 'Belum mendapatkan lokasi',
                            hintStyle: TextStyle(
                              color:
                                  _locationFetched ? Colors.green : Colors.red,
                            ),
                          ),
                          readOnly: true,
                        ),
                        const SizedBox(height: 10),
                        if (_locationFetched)
                          TextButton(
                            onPressed: _launchURL,
                            child: const Text('Lihat Lokasi'),
                          ),
                        const SizedBox(height: 10),
                        TextField(
                          decoration: InputDecoration(
                            labelText: 'Foto Sampah',
                            border: const OutlineInputBorder(),
                            suffixIcon: IconButton(
                              icon: _photoSelected
                                  ? const Icon(Icons.check_circle,
                                      color: Colors.green)
                                  : const Icon(Icons.camera_alt),
                              onPressed: _getImage,
                            ),
                            hintText: _photoSelected
                                ? 'Sudah mendapatkan foto'
                                : 'Belum mendapatkan foto',
                            hintStyle: TextStyle(
                              color: _photoSelected ? Colors.green : Colors.red,
                            ),
                          ),
                          readOnly: true,
                        ),
                        const SizedBox(height: 10),
                        if (_photoSelected && _image != null)
                          Image.file(
                            File(_image!.path),
                            height: 200,
                            fit: BoxFit.cover,
                          ),
                        const SizedBox(height: 10),
                        const TextField(
                          maxLines: 3,
                          decoration: InputDecoration(
                            labelText: 'Deskripsi',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            BottomAppBar(
              color: Colors.transparent,
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    _submitForm();
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const HomePage()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: BlurStyle,
                  ),
                  child: const Text(
                    'Laporkan!',
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
