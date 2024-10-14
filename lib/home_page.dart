// ignore_for_file: library_private_types_in_public_api, sort_child_properties_last

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'dart:io';
import 'package:kost/profile_page.dart';
import 'package:kost/saved_page.dart';
import 'add_page.dart' show AddPage;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<Map<String, dynamic>> _kostList = [];
  final List<Map<String, dynamic>> _savedKostList = [];

  @override
  void initState() {
    super.initState();
    _loadData();
    _loadFavoriteData();
  }

  Future<void> _loadData() async {
    final prefs = await SharedPreferences.getInstance();
    final String? kostString = prefs.getString('kostList');

    if (kostString != null) {
      final List<dynamic> kostData = jsonDecode(kostString);
      setState(() {
        _kostList.clear();
        for (var item in kostData) {
          _kostList.add(Map<String, dynamic>.from(item));
        }
      });
    }
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

  Future<void> _saveData() async {
    final prefs = await SharedPreferences.getInstance();
    final String kostString = jsonEncode(_kostList);
    prefs.setString('kostList', kostString);
  }

  Future<void> _saveFavoriteData() async {
    final prefs = await SharedPreferences.getInstance();
    final String savedKostString = jsonEncode(_savedKostList);
    prefs.setString('savedKostList', savedKostString);
  }

  void _toggleFavorite(Map<String, dynamic> kost) {
    setState(() {
      if (_savedKostList.any((item) => mapEquals(item, kost))) {
        _savedKostList.removeWhere((item) => mapEquals(item, kost));
      } else {
        _savedKostList.add(kost);
      }
      _saveFavoriteData();
    });
  }

  Future<void> _navigateToAddPage() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddPage()),
    );

    if (result != null && result is Map<String, dynamic>) {
      setState(() {
        _kostList.add(result);
      });
      _saveData();
    }
  }

  bool _isFavorited(Map<String, dynamic> kost) {
    return _savedKostList.any((item) => mapEquals(item, kost));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFC0CB), // Warna latar belakang Scaffold
      appBar: AppBar(
        title: const Text('PINKYKOST'),
        backgroundColor: const Color(0xFFFF5DA1),
      ),
      body: _kostList.isEmpty
          ? const Center(
              child: Text(
                'Belum ada data kost',
                style: TextStyle(color: Color(0xFFFF5DA1)),
              ),
            )
          : ListView.builder(
              itemCount: _kostList.length,
              itemBuilder: (context, index) {
                final kost = _kostList[index];
                final isFavorited = _isFavorited(kost);
                return Card(
                  margin: const EdgeInsets.all(8),
                  color: const Color.fromARGB(255, 180, 203, 233),
                  child: ListTile(
                    leading: kost['image'] != null
                        ? Image.file(
                            File(kost['image']),
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
                          )
                        : const Icon(Icons.image, color: Color(0xFFFF5DA1)),
                    title: Text(
                      kost['namaKost'] ?? '',
                      style: const TextStyle(color: Color(0xFFFF5DA1)),
                    ),
                    subtitle: Text(
                      '${kost['harga']}\n${kost['alamat']}\n${kost['noHandphone']}',
                      style: const TextStyle(color: Colors.black54),
                    ),
                    trailing: IconButton(
                      icon: Icon(
                        isFavorited ? Icons.favorite : Icons.favorite_border,
                        color: isFavorited
                            ? const Color.fromARGB(255, 236, 62, 74)
                            : null,
                      ),
                      onPressed: () {
                        _toggleFavorite(kost);
                      },
                    ),
                    isThreeLine: true,
                  ),
                );
              },
            ),
      bottomNavigationBar: BottomAppBar(
        color: const Color(0xFFFF5DA1),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            InkWell(
              onTap: () {
                Navigator.pushReplacementNamed(context, '/');
              },
              child: const Padding(
                padding: EdgeInsets.all(8.0),
                child: Icon(Icons.home, color: Colors.white),
              ),
              borderRadius: BorderRadius.circular(16),
              splashColor: Colors.white54,
            ),
            InkWell(
              onTap: _navigateToAddPage,
              child: const Padding(
                padding: EdgeInsets.all(8.0),
                child: Icon(Icons.add, color: Colors.white),
              ),
              borderRadius: BorderRadius.circular(16),
              splashColor: Colors.white54,
            ),
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SavedPage()),
                );
              },
              child: const Padding(
                padding: EdgeInsets.all(8.0),
                child: Icon(Icons.save, color: Colors.white),
              ),
              borderRadius: BorderRadius.circular(16),
              splashColor: Colors.white54,
            ),
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ProfilePage()),
                );
              },
              child: const Padding(
                padding: EdgeInsets.all(8.0),
                child: Icon(Icons.person, color: Colors.white),
              ),
              borderRadius: BorderRadius.circular(16),
              splashColor: Colors.white54,
            ),
          ],
        ),
      ),
    );
  }
}
