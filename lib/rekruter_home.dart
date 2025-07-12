import 'package:flutter/material.dart';
import 'components/custom_card.dart';
import 'models/lowongan.dart';
import 'helpers/db_helper.dart';

class RekruterHomePage extends StatefulWidget {
  const RekruterHomePage({super.key});

  @override
  State<RekruterHomePage> createState() => _RekruterHomePageState();
}

class _RekruterHomePageState extends State<RekruterHomePage> {
  late Future<List<Lowongan>> _lowonganList;

  final _formKey = GlobalKey<FormState>();
  final _titleCtrl = TextEditingController();
  final _companyCtrl = TextEditingController();
  final _locationCtrl = TextEditingController();
  final _detailCtrl = TextEditingController();


  @override
  void initState() {
    super.initState();
    _loadLowongan();
  }

  void _loadLowongan() {
    _lowonganList = DBHelper().getAllLowongan();
  }

  void _simpanLowongan({Lowongan? editData}) async {
    if (_formKey.currentState!.validate()) {
      final newData = Lowongan(
        id: editData?.id,
        title: _titleCtrl.text,
        company: _companyCtrl.text,
        location: _locationCtrl.text,
        detail: _detailCtrl.text,
      );

      if (editData == null) {
        await DBHelper().insertLowongan(newData);
      } else {
        await DBHelper().updateLowongan(newData);
      }

      setState(() {
        _loadLowongan();
      });

      Navigator.of(context).pop();
    }
  }

  void _hapusLowongan(int id) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hapus Lowongan'),
        content: const Text('Yakin ingin menghapus lowongan ini?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await DBHelper().deleteLowongan(id);
      setState(() {
        _loadLowongan(); // Refresh list
      });
    }
  }
  void _showActionDialog(Lowongan job) {
    showModalBottomSheet(
      context: context,
      builder: (_) => Padding(
        padding: const EdgeInsets.all(16.0),
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.edit),
              title: const Text('Edit Lowongan'),
              onTap: () {
                Navigator.pop(context);
                _showFormDialog(editData: job);
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete, color: Colors.red),
              title: const Text('Hapus Lowongan', style: TextStyle(color: Colors.red)),
              onTap: () {
                Navigator.pop(context);
                _hapusLowongan(job.id!);
              },
            ),
          ],
        ),
      ),
    );
  }




  void _showFormDialog({Lowongan? editData}) {
    if (editData != null) {
      _titleCtrl.text = editData.title;
      _companyCtrl.text = editData.company;
      _locationCtrl.text = editData.location;
      _detailCtrl.text = editData.detail ?? '';
    } else {
      _titleCtrl.clear();
      _companyCtrl.clear();
      _locationCtrl.clear();
      _detailCtrl.clear();
    }

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(editData == null ? 'Tambah Lowongan' : 'Edit Lowongan'),
        content: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: _titleCtrl,
                  decoration: const InputDecoration(labelText: 'Judul'),
                  validator: (value) => value!.isEmpty ? 'Wajib diisi' : null,
                ),
                TextFormField(
                  controller: _companyCtrl,
                  decoration: const InputDecoration(labelText: 'Perusahaan'),
                  validator: (value) => value!.isEmpty ? 'Wajib diisi' : null,
                ),
                TextFormField(
                  controller: _locationCtrl,
                  decoration: const InputDecoration(labelText: 'Lokasi'),
                ),
                TextFormField(
                  controller: _detailCtrl,
                  decoration: const InputDecoration(labelText: 'Detail Pekerjaan'),
                  maxLines: 3,
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Batal')),
          ElevatedButton(
            onPressed: () => _simpanLowongan(editData: editData),
            child: Text(editData == null ? 'Simpan' : 'Update'),
          ),
        ],
      ),
    );
  }


  @override
  void dispose() {
    _titleCtrl.dispose();
    _companyCtrl.dispose();
    _locationCtrl.dispose();
    _detailCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kelola Lowongan'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                const Expanded(
                  child: Text(
                    'Daftar Lowongan',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: _showFormDialog,
                )
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
                  return const Center(child: Text('Belum ada lowongan.'));
                }

                final list = snapshot.data!;
                return ListView.builder(
                  itemCount: list.length,
                  itemBuilder: (context, index) {
                    final job = list[index];
                    return CustomCard(
                      title: job.title,
                      subtitle: '${job.company} • ${job.location}',
                      buttonText: 'Edit / Hapus',
                      onTap: () => _showActionDialog(job),
                      onCardTap: () {}, // bisa isi detail
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
