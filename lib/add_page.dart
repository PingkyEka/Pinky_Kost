// ignore_for_file: library_private_types_in_public_api, unused_field, use_build_context_synchronously

import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AddPage extends StatefulWidget {
  const AddPage({super.key});

  @override
  _AddPageState createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> {
  final TextEditingController _namaKostController = TextEditingController();
  final TextEditingController _hargaController = TextEditingController();
  final TextEditingController _fasilitasController = TextEditingController();
  final TextEditingController _alamatController = TextEditingController();
  final TextEditingController _noHandphoneController = TextEditingController();

  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        setState(() {
          _selectedImage = File(image.path);
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal mengambil gambar: $e')),
      );
    }
  }

  void _saveData() {
    if (kDebugMode) {
      print(
          "data yang disimpan: ${_namaKostController.text}, ${_hargaController.text}, ${_fasilitasController.text}, ${_alamatController.text}, ${_noHandphoneController.text}");
    }

    if (_selectedImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Harap unggah foto sebelum menyimpan')),
      );
      return;
    }

    final Map<String, dynamic> data = {
      'namaKost': _namaKostController.text,
      'harga': _hargaController.text,
      'fasilitas': _fasilitasController.text,
      'alamat': _alamatController.text,
      'noHandphone': _noHandphoneController.text,
      'image': _selectedImage!.path,
    };

    Navigator.pop(context, data);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Posting Info Kost'),
      ),
      body: Container(
        color: const Color(0xFFFFC0CB), // Warna latar belakang #FFC0CB
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: _namaKostController,
                  decoration: const InputDecoration(
                    labelText: 'Nama Kost',
                    prefixIcon: Icon(Icons.home),
                  ),
                ),
                TextField(
                  controller: _hargaController,
                  decoration: const InputDecoration(
                    labelText: 'Harga',
                    prefixIcon: Icon(Icons.attach_money),
                  ),
                ),
                TextField(
                  controller: _fasilitasController,
                  decoration: const InputDecoration(
                    labelText: 'Fasilitas',
                    prefixIcon: Icon(Icons.local_offer),
                  ),
                ),
                TextField(
                  controller: _alamatController,
                  decoration: const InputDecoration(
                    labelText: 'Alamat',
                    prefixIcon: Icon(Icons.location_on),
                  ),
                ),
                TextField(
                  controller: _noHandphoneController,
                  decoration: const InputDecoration(
                    labelText: 'No Handphone',
                    prefixIcon: Icon(Icons.phone),
                  ),
                ),
                const SizedBox(height: 20),
                TextButton(
                  onPressed: _pickImage,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 128, 188, 223),
                  ),
                  child: const Text('Upload Foto'),
                ),
                if (_selectedImage != null)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Image.file(
                      _selectedImage!,
                      height: 150,
                    ),
                  )
                else
                  const Text(
                    'Belum ada foto yang dipilih',
                    style: TextStyle(color: Color.fromARGB(255, 57, 54, 54)),
                  ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _saveData,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 128, 188, 223),
                  ),
                  child: const Text('Simpan'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
