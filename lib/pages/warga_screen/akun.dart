import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dlh_project/constant/color.dart';
import 'package:dlh_project/pages/form_opening/login.dart';
import 'package:dlh_project/widget/address_field.dart';
import 'package:dlh_project/widget/password_field.dart';

class Akun extends StatefulWidget {
  const Akun({super.key});

  @override
  _AkunState createState() => _AkunState();
}

class _AkunState extends State<Akun> {
  String userName = 'Guest';
  String userEmail = 'user@example.com';
  String userPhone = '081234567890';
  String _selectedAddress = 'Default';
  final List<String> _addresses = ['Rumah', 'Kantor', 'Kos'];

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userName = prefs.getString('user_name') ?? 'Guest';
      userEmail = prefs.getString('user_email') ?? 'user@example.com';
      userPhone = prefs.getString('user_phone') ?? '081234567890';
      _selectedAddress = prefs.getString('selected_address') ?? 'Default';
      _addresses.addAll(prefs.getStringList('addresses') ?? []);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          'Akun',
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
            _buildHeader(),
            const SizedBox(height: 10),
            Expanded(
              child: ListView(
                children: [
                  _buildInfoField(label: 'Nama', value: userName),
                  _buildInfoField(label: 'Email', value: userEmail),
                  _buildInfoField(label: 'No. HP', value: userPhone),
                  _buildAddressField(),
                  _buildPasswordField(),
                ],
              ),
            ),
            _buildEditAllButton(),
            const SizedBox(height: 10),
            _buildLogoutButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      height: 140,
      decoration: BoxDecoration(
        color: purple,
        borderRadius: BorderRadius.circular(10),
      ),
      child: const Center(
        child: Text(
          'Informasi Akun',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 24,
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
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

  Widget _buildAddressField() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5),
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(10),
      ),
      child: AddressField(
        selectedAddress: _selectedAddress,
        onAddAddress: _showAddAddressDialog,
        onEditAddress: _showEditAddressDialog,
        onDeleteAddress: _showDeleteAddressDialog,
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

  Widget _buildEditAllButton() {
    return ElevatedButton(
      onPressed: _showEditAllDialog,
      child: const Text('Edit Semua Data'),
    );
  }

  Widget _buildLogoutButton() {
    return ElevatedButton(
      onPressed: _logout,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.red,
      ),
      child: const Text('Logout'),
    );
  }

  void _showEditAddressDialog(String address) {
    TextEditingController addressController =
        TextEditingController(text: address);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Edit Alamat'),
          content: TextField(
            controller: addressController,
            decoration: const InputDecoration(labelText: 'Alamat Baru'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  String newAddress = addressController.text;
                  if (newAddress.isNotEmpty) {
                    int index = _addresses.indexOf(address);
                    if (index != -1) {
                      _addresses[index] = newAddress;
                      _selectedAddress = newAddress;
                    }
                  }
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

  void _showDeleteAddressDialog(String address) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Hapus Alamat'),
          content: const Text('Apakah Anda yakin ingin menghapus alamat ini?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  _addresses.remove(address);
                  if (_addresses.isNotEmpty) {
                    _selectedAddress = _addresses.first;
                  } else {
                    _selectedAddress = 'Default';
                  }
                });
                Navigator.of(context).pop();
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  void _showAddAddressDialog() {
    TextEditingController _addressController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Tambah Alamat'),
          content: TextField(
            controller: _addressController,
            decoration: const InputDecoration(labelText: 'Alamat Baru'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  String newAddress = _addressController.text;
                  if (newAddress.isNotEmpty) {
                    _addresses.add(newAddress);
                    _selectedAddress = newAddress; // Update selected address
                  }
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
              onPressed: () => Navigator.of(context).pop(),
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
        TextEditingController(text: userName);
    TextEditingController _emailController =
        TextEditingController(text: userEmail);
    TextEditingController _phoneController =
        TextEditingController(text: userPhone);

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
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () {
                    setState(() {
                      userName = _usernameController.text;
                      userEmail = _emailController.text;
                      userPhone = _phoneController.text;
                      // Save updated data to SharedPreferences
                      _saveUserData();
                    });
                    Navigator.of(context).pop();
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

  void _saveUserData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_name', userName);
    await prefs.setString('user_email', userEmail);
    await prefs.setString('user_phone', userPhone);
    await prefs.setString('selected_address', _selectedAddress);
    await prefs.setStringList('addresses', _addresses);
  }

  Future<void> _logout() async {
    final prefs = await SharedPreferences.getInstance();

    // Clear all data from SharedPreferences
    await prefs.clear();

    // Navigate back to login page
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const Login()),
    );
  }
}
