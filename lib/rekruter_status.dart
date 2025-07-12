import 'package:flutter/material.dart';
import 'detail_mahasiswa.dart';
import 'helpers/db_helper.dart';
import 'models/lamaran.dart';

class RekruterStatus extends StatefulWidget {
  const RekruterStatus({super.key});

  @override
  State<RekruterStatus> createState() => _RekruterStatusState();
}

class _RekruterStatusState extends State<RekruterStatus> {
  late Future<List<Lamaran>> _lamaranList;

  @override
  void initState() {
    super.initState();
    _loadLamaran();
  }

  void _loadLamaran() {
    setState(() {
      _lamaranList = DBHelper().getAllLamaran();
    });
  }

  void _ubahStatus(int id, String statusBaru) async {
    final db = DBHelper();
    await db.updateStatusLamaran(id, statusBaru);
    _loadLamaran();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Status Lamaran Masuk')),
      body: FutureBuilder<List<Lamaran>>(
        future: _lamaranList,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Belum ada lamaran masuk.'));
          }

          final list = snapshot.data!;
          return ListView.builder(
            itemCount: list.length,
            itemBuilder: (context, index) {
              final lamaran = list[index];
              return ListTile(
                title: Text(lamaran.namaMahasiswa),
                subtitle: Text('Lowongan: ${lamaran.title ?? lamaran.idLowongan.toString()}'),
                trailing: DropdownButton<String>(
                  value: lamaran.status,
                  items: ['Pending', 'Diterima', 'Ditolak']
                      .map((status) => DropdownMenuItem(
                    value: status,
                    child: Text(status),
                  ))
                      .toList(),
                  onChanged: (value) {
                    if (value != null) {
                      _ubahStatus(lamaran.id!, value);
                    }
                  },
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => DetailMahasiswaPage(mahasiswaId: lamaran.mahasiswaId),
                    ),
                  );
                },
              );

            },
          );
        },
      ),
    );
  }
}
