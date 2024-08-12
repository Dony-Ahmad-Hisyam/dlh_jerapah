import 'package:flutter/material.dart';
import 'package:dlh_project/constant/color.dart';
import 'package:dlh_project/widget/password_field.dart';

class AkunPetugas extends StatefulWidget {
  const AkunPetugas({super.key});

  @override
  _AkunPetugasState createState() => _AkunPetugasState();
}

class _AkunPetugasState extends State<AkunPetugas> {
  String _selectedAddress = 'Default';
  final List<String> _addresses = ['Rumah', 'Kantor', 'Kos'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          'Akun Petugas',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              height: 140,
              decoration: BoxDecoration(
                color: purple,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Center(
                child: Text(
                  'Informasi Akun Petugas',
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
              child: ListView(
                children: [
                  _buildInfoField(label: 'Nama', value: 'user123'),
                  _buildInfoField(label: 'Email', value: 'user@example.com'),
                  _buildInfoField(label: 'No. HP', value: '081234567890'),
                  _buildPasswordField(),
                ],
              ),
            ),
            ElevatedButton(
              onPressed: _showEditAllDialog,
              child: const Text('Edit Semua Data'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoField({required String label, required String value}) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5),
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '$label:',
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
          Text(
            value,
            style: const TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }

  Widget _buildPasswordField() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5),
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(10),
      ),
      child: PasswordField(
        onResetPassword: _showEditPasswordDialog,
      ),
    );
  }

  void _showEditPasswordDialog() {
    TextEditingController _passwordController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Ubah Password'),
          content: TextField(
            controller: _passwordController,
            decoration: const InputDecoration(
              labelText: 'Password Baru',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  // Implement logic to update password here
                });
                Navigator.of(context).pop();
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void _showEditAllDialog() {
    TextEditingController _usernameController =
        TextEditingController(text: 'user123');
    TextEditingController _emailController =
        TextEditingController(text: 'user@example.com');
    TextEditingController _phoneController =
        TextEditingController(text: '081234567890');

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              title: const Text('Edit Semua Data'),
              content: SingleChildScrollView(
                child: Column(
                  children: [
                    TextField(
                      controller: _usernameController,
                      decoration: const InputDecoration(labelText: 'Username'),
                    ),
                    TextField(
                      controller: _emailController,
                      decoration: const InputDecoration(labelText: 'Email'),
                    ),
                    TextField(
                      controller: _phoneController,
                      decoration: const InputDecoration(labelText: 'No. HP'),
                    ),
                    const SizedBox(height: 10),
                    const Text('Alamat:'),
                    const SizedBox(height: 10),
                    Column(
                      children: _addresses.map((address) {
                        return RadioListTile<String>(
                          title: Text(address),
                          value: address,
                          groupValue: _selectedAddress,
                          onChanged: (value) {
                            setState(() {
                              _selectedAddress = value!;
                            });
                          },
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    // No need to call setState here since state is already updated via StatefulBuilder
                  },
                  child: const Text('Save'),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
