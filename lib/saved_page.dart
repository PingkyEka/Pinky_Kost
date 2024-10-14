// ignore_for_file: unused_import, library_private_types_in_public_api

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'dart:io';
import 'package:kost/profile_page.dart';
import 'home_page.dart'; // Import HomePage untuk fungsi favorit

class SavedPage extends StatefulWidget {
  const SavedPage({super.key});

  @override
  _SavedPageState createState() => _SavedPageState();
}

class _SavedPageState extends State<SavedPage> {
  final List<Map<String, dynamic>> _savedKostList = [];

  @override
  void initState() {
    super.initState();
    _loadFavoriteData();
  }

  Future<void> _loadFavoriteData() async {
    final prefs = await SharedPreferences.getInstance();
    final String? savedString = prefs.getString('savedKostList');

    if (savedString != null) {
      final List<dynamic> savedData = jsonDecode(savedString);
      setState(() {
        _savedKostList.clear();
        for (var item in savedData) {
          _savedKostList.add(Map<String, dynamic>.from(item));
        }
      });
    }
  }

  Future<void> _saveFavoriteData() async {
    final prefs = await SharedPreferences.getInstance();
    final String savedKostString = jsonEncode(_savedKostList);
    prefs.setString('savedKostList', savedKostString);
  }

  void _removeFromFavorites(Map<String, dynamic> kost) {
    setState(() {
      _savedKostList.removeWhere((item) => mapEquals(item, kost));
      _saveFavoriteData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFC0CB), // Warna latar belakang Scaffold
      appBar: AppBar(
        title: const Text('Tersimpan'),
      ),
      body: _savedKostList.isEmpty
          ? const Center(child: Text('Belum ada data tersimpan'))
          : ListView.builder(
              itemCount: _savedKostList.length,
              itemBuilder: (context, index) {
                final kost = _savedKostList[index];
                return Card(
                  margin: const EdgeInsets.all(8),
                  color: const Color.fromARGB(
                      255, 180, 203, 233), // Warna latar belakang Card
                  child: ListTile(
                    leading: kost['image'] != null
                        ? Image.file(
                            File(kost['image']),
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
                          )
                        : const Icon(Icons.image),
                    title: Text(kost['namaKost'] ?? ''),
                    subtitle: Text(
                        '${kost['harga']}\n${kost['alamat']}\n${kost['noHandphone']}'),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete,
                          color: Color.fromARGB(255, 58, 190, 10)),
                      onPressed: () {
                        _removeFromFavorites(kost);
                      },
                    ),
                    isThreeLine: true,
                  ),
                );
              },
            ),
    );
  }
}
