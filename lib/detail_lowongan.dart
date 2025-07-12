import 'package:flutter/material.dart';
import 'models/lowongan.dart';

class DetailLowonganPage extends StatelessWidget {
  final Lowongan lowongan;

  const DetailLowonganPage({super.key, required this.lowongan});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(lowongan.title)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              lowongan.company,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text('Lokasi: ${lowongan.location}'),
            const SizedBox(height: 16),
            const Text(
              'Detail Pekerjaan',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            Text(lowongan.detail.isNotEmpty ? lowongan.detail : 'Tidak ada detail tersedia.'),
          ],
        ),
      ),
    );
  }
}
