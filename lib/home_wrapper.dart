import 'package:flutter/material.dart';
import 'home_mahasiswa.dart';
import 'riwayat_lamaran.dart';
import 'profil_mahasiswa.dart';

class HomeMahasiswaWrapper extends StatefulWidget {
  const HomeMahasiswaWrapper({super.key});

  @override
  State<HomeMahasiswaWrapper> createState() => _HomeMahasiswaWrapperState();
}

class _HomeMahasiswaWrapperState extends State<HomeMahasiswaWrapper> {
  int _currentIndex = 0;

  // Tambahkan GlobalKey
  final GlobalKey<RiwayatLamaranState> riwayatKey = GlobalKey();

  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      const HomeMahasiswa(),
      RiwayatLamaran(key: riwayatKey),
      const ProfilMahasiswaPage(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          if (index == 1) {
            // Jika pindah ke Riwayat, panggil refresh
            riwayatKey.currentState?.refreshData();
          }

          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Beranda'),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: 'Riwayat'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profil'),
        ],
      ),
    );
  }
}

