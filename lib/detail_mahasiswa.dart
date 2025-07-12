import 'package:flutter/material.dart';
import 'models/profil.dart';
import 'helpers/db_helper.dart';

class DetailMahasiswaPage extends StatelessWidget {
  final int mahasiswaId;

  const DetailMahasiswaPage({super.key, required this.mahasiswaId});

  Future<ProfilMahasiswa?> _getProfil() async {
    return await DBHelper().getProfilByMahasiswaId(mahasiswaId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Detail Mahasiswa')),
      body: FutureBuilder<ProfilMahasiswa?>(
        future: _getProfil(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data == null) {
            return const Center(child: Text('Profil tidak ditemukan.'));
          }

          final profil = snapshot.data!;
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Nama: ${profil.nama}', style: const TextStyle(fontSize: 18)),
                const SizedBox(height: 8),
                Text('Email: ${profil.email}'),
                const SizedBox(height: 8),
                Text('No HP: ${profil.noHp}'),
                const SizedBox(height: 8),
                Text('Kampus: ${profil.kampus}'),
                const SizedBox(height: 16),
                const Text('Pengalaman Kerja:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text(profil.pengalamanKerja.isNotEmpty ? profil.pengalamanKerja : 'Belum diisi.'),
              ],
            ),
          );
        },
      ),
    );
  }
}
