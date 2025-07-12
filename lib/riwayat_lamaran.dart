import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'components/custom_card.dart';
import 'helpers/db_helper.dart';
import 'models/lamaran.dart';

class RiwayatLamaran extends StatefulWidget {
  const RiwayatLamaran({super.key});

  @override
  State<RiwayatLamaran> createState() => RiwayatLamaranState();
}

class RiwayatLamaranState extends State<RiwayatLamaran> with AutomaticKeepAliveClientMixin {
  late Future<List<Lamaran>> riwayat;

  @override
  void initState() {
    super.initState();
    refreshData();
  }
  Color getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'diterima':
        return Colors.green;
      case 'ditolak':
        return Colors.red;
      case 'pending':
      default:
        return Colors.orange;
    }
  }



  void refreshData() async {
    final prefs = await SharedPreferences.getInstance();
    final mahasiswaId = prefs.getInt('mahasiswa_id');
    debugPrint('[RIWAYAT] mahasiswaId: $mahasiswaId');

    if (mahasiswaId == null) {
      setState(() {
        riwayat = Future.value([]); // Supaya FutureBuilder tetap bisa nge-refresh
      });
      return;
    }

    setState(() {
      riwayat = DBHelper().getLamaranByMahasiswaId(mahasiswaId);
    });
  }


  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Jika ingin refresh tiap kali halaman aktif, bisa panggil refreshData
    // Tapi hati-hati, ini bisa dipanggil berulang kali, bisa dikondisikan dengan flag jika perlu
    // refreshData();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Riwayat Lamaran')),
      body: FutureBuilder<List<Lamaran>>(
        future: riwayat,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Belum ada lamaran yang dikirim.'));
          }

          final data = snapshot.data!;
          return ListView.builder(
            itemCount: data.length,
            itemBuilder: (context, index) {
              final lamaran = data[index];
              return CustomCard(
                title: lamaran.title ?? 'Tanpa Judul',
                subtitle: '${lamaran.company} • ${lamaran.location}',
                statusText: 'Status: ${lamaran.status}',
                statusColor: getStatusColor(lamaran.status),
                buttonText: 'Hapus',
                onTap: () async {
                  await DBHelper().deleteLamaran(lamaran.id!);
                  refreshData();
                },
                onCardTap: () {},
              );

            },
          );
        },
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}


