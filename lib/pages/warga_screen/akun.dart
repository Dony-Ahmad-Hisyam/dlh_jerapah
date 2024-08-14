import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dlh_project/constant/color.dart';
import 'package:dlh_project/pages/form_opening/login.dart';
import 'package:dlh_project/pages/warga_screen/password_reset.dart';

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
  bool _isLoggedIn = false;

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
      _isLoggedIn = userName != 'Guest';
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
        child: _isLoggedIn ? _buildLoggedInContent() : _buildLoginButton(),
      ),
    );
  }

  Widget _buildLoggedInContent() {
    return Column(
      children: [
        _buildHeader(),
        const SizedBox(height: 10),
        Expanded(
          child: ListView(
            children: [
              _buildInfoField(label: 'Nama', value: userName),
              _buildInfoField(label: 'Email', value: userEmail),
              _buildInfoField(label: 'No. HP', value: userPhone),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 5),
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Alamat:',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const PasswordReset(),
                          ),
                        );
                      },
                      child: const Icon(Icons.add_location),
                    ),
                  ],
                ),
              ),
              Container(
                  margin: const EdgeInsets.symmetric(vertical: 5),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Ganti Password:',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const PasswordReset(),
                            ),
                          );
                        },
                        child: const Text(
                          'Reset',
                          style: TextStyle(fontSize: 16, color: red),
                        ),
                      )
                    ],
                  )),
            ],
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: _buildEditAllButton(),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _buildLogoutButton(),
            ),
          ],
        ),
        const SizedBox(height: 10),
      ],
    );
  }

  Widget _buildLoginButton() {
    return Center(
      child: ElevatedButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const Login(),
            ),
          );
        },
        child: const Text('Login'),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      height: 140,
      decoration: BoxDecoration(
        color: BlurStyle,
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
      child: const Text(
        'Logout',
        style: TextStyle(color: Colors.white),
      ),
    );
  }

  void _showEditAllDialog() {
    TextEditingController usernameController =
        TextEditingController(text: userName);
    TextEditingController emailController =
        TextEditingController(text: userEmail);
    TextEditingController phoneController =
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
                      controller: usernameController,
                      decoration: const InputDecoration(labelText: 'Username'),
                    ),
                    TextField(
                      controller: emailController,
                      decoration: const InputDecoration(labelText: 'Email'),
                    ),
                    TextField(
                      controller: phoneController,
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
                      userName = usernameController.text;
                      userEmail = emailController.text;
                      userPhone = phoneController.text;
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
      // ignore: use_build_context_synchronously
      context,
      MaterialPageRoute(builder: (context) => const Login()),
    );
  }
}
