import 'package:flutter/material.dart';

class AddressField extends StatelessWidget {
  final String selectedAddress;
  final VoidCallback onAddAddress;
  final ValueChanged<String> onEditAddress;
  final ValueChanged<String> onDeleteAddress;

  const AddressField({
    super.key,
    required this.selectedAddress,
    required this.onAddAddress,
    required this.onEditAddress,
    required this.onDeleteAddress,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              'Alamat: $selectedAddress',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.location_on),
            onPressed: () {
              onEditAddress(selectedAddress);
            },
          ),
          IconButton(
            icon: const Icon(Icons.add_location),
            onPressed: () {
              onAddAddress();
            },
          ),
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              onEditAddress(selectedAddress);
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              onDeleteAddress(selectedAddress);
            },
          ),
        ],
      ),
    );
  }
}
