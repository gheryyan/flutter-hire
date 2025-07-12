import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'components/custom_card.dart';
import 'detail_lowongan.dart';
import 'helpers/db_helper.dart';
import 'models/lowongan.dart';
import 'models/lamaran.dart';

class HomeMahasiswa extends StatefulWidget {
  const HomeMahasiswa({super.key});

  @override
  State<HomeMahasiswa> createState() => _HomeMahasiswaState();
}

class _HomeMahasiswaState extends State<HomeMahasiswa> {
  late Future<List<Lowongan>> _lowonganList;
  TextEditingController _searchController = TextEditingController();
  String _searchKeyword = '';

  @override
  void initState() {
    super.initState();
    _loadLowongan();
  }

  void _loadLowongan({String keyword = ''}) {
    setState(() {
      _searchKeyword = keyword;
      _lowonganList = DBHelper().getAllLowongan().then((list) {
        if (keyword.isEmpty) return list;
        return list.where((lowongan) =>
        lowongan.title.toLowerCase().contains(keyword.toLowerCase()) ||
            lowongan.company.toLowerCase().contains(keyword.toLowerCase()) ||
            lowongan.location.toLowerCase().contains(keyword.toLowerCase())
        ).toList();
      });
    });
  }

  void _applyToJob(Lowongan lowongan) async {
    final db = DBHelper();
    final prefs = await SharedPreferences.getInstance();
    final mahasiswaId = prefs.getInt('mahasiswa_id');

    if (mahasiswaId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Mahasiswa belum login')),
      );
      return;
    }

    final profil = await db.getProfilByMahasiswaId(mahasiswaId);

    if (profil == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profil mahasiswa belum diisi')),
      );
      return;
    }

    final sudahApply = await db.sudahApply(lowongan.id!, mahasiswaId);
    if (sudahApply) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Kamu sudah apply ke lowongan ini')),
      );
      return;
    }

    final lamaran = Lamaran(
      idLowongan: lowongan.id!,
      mahasiswaId: mahasiswaId,
      namaMahasiswa: profil.nama,
      status: 'Pending',
      title: lowongan.title,
      company: lowongan.company,
      location: lowongan.location,
    );

    await db.insertLamaran(lamaran);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Lamaran ke ${lowongan.title} berhasil dikirim!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Beranda Mahasiswa')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    decoration: const InputDecoration(
                      hintText: 'Cari lowongan...',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.search),
                    ),
                    onSubmitted: (value) {
                      _loadLowongan(keyword: value);
                    },
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () {
                    _loadLowongan(keyword: _searchController.text);
                  },
                  child: const Text('Cari'),
                ),
              ],
            ),
          ),
          Expanded(
            child: FutureBuilder<List<Lowongan>>(
              future: _lowonganList,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('Tidak ada lowongan yang ditemukan.'));
                }

                final jobs = snapshot.data!;
                return ListView.builder(
                  itemCount: jobs.length,
                  itemBuilder: (context, index) {
                    final job = jobs[index];
                    return CustomCard(
                      title: job.title,
                      subtitle: '${job.company} • ${job.location}',
                      buttonText: 'Apply',
                      onTap: () => _applyToJob(job),
                      onCardTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => DetailLowonganPage(lowongan: job),
                          ),
                        );
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
