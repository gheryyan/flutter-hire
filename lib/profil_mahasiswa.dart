import 'package:flutter/material.dart';
import 'package:hire_app/riwayat_lamaran.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../helpers/db_helper.dart';
import '../models/profil.dart';
import 'login_screen.dart';

class ProfilMahasiswaPage extends StatefulWidget {
  const ProfilMahasiswaPage({super.key});

  @override
  State<ProfilMahasiswaPage> createState() => _ProfilMahasiswaPageState();
}

class _ProfilMahasiswaPageState extends State<ProfilMahasiswaPage> {
  final _formKey = GlobalKey<FormState>();
  final _namaCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _noHpCtrl = TextEditingController();
  final _kampusCtrl = TextEditingController();
  final _pengalamanKerjaCtrl = TextEditingController();

  ProfilMahasiswa? currentProfil;

  @override
  void initState() {
    super.initState();
    _loadProfil();
  }

  void _loadProfil() async {
    final prefs = await SharedPreferences.getInstance();
    final id = prefs.getInt('mahasiswa_id');
    if (id == null) return;

    final profil = await DBHelper().getProfilByMahasiswaId(id);
    print("Profil dari database: ${profil?.toMap()}");

    if (profil != null) {
      setState(() {
        currentProfil = profil;
        _namaCtrl.text = profil.nama;
        _emailCtrl.text = profil.email;
        _noHpCtrl.text = profil.noHp;
        _kampusCtrl.text = profil.kampus;
        _pengalamanKerjaCtrl.text = profil.pengalamanKerja;
      });
    }
  }

  void _simpanProfil() async {
    if (_formKey.currentState!.validate()) {
      final prefs = await SharedPreferences.getInstance();
      final mahasiswaId = prefs.getInt('mahasiswa_id');

      final profil = ProfilMahasiswa(
        id: currentProfil?.id,
        nama: _namaCtrl.text,
        email: _emailCtrl.text,
        noHp: _noHpCtrl.text,
        kampus: _kampusCtrl.text,
        pengalamanKerja: _pengalamanKerjaCtrl.text,
        mahasiswaId: mahasiswaId,
      );

      if (currentProfil == null) {
        print("INSERT profil baru: ${profil.toMap()}");
        await DBHelper().insertProfil(profil);
      } else {
        print("UPDATE profil ID ${profil.id}");
        await DBHelper().updateProfil(profil);
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profil disimpan!')),
      );

      setState(() {
        currentProfil = profil;
      });
    }
  }



  @override
    Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(title: const Text('Profil Mahasiswa')),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                TextFormField(
                  controller: _namaCtrl,
                  decoration: const InputDecoration(labelText: 'Nama'),
                  validator: (value) =>
                  value!.isEmpty
                      ? 'Nama wajib diisi'
                      : null,
                ),
                TextFormField(
                  controller: _emailCtrl,
                  decoration: const InputDecoration(labelText: 'Email'),
                  validator: (value) =>
                  value!.isEmpty
                      ? 'Email wajib diisi'
                      : null,
                ),
                TextFormField(
                  controller: _noHpCtrl,
                  decoration: const InputDecoration(labelText: 'No HP'),
                ),
                TextFormField(
                  controller: _kampusCtrl,
                  decoration: const InputDecoration(labelText: 'Kampus'),
                ),
                TextFormField(
                  controller: _pengalamanKerjaCtrl,
                  decoration: const InputDecoration(
                      labelText: 'Pengalaman Kerja'),
                  maxLines: 4,
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: _simpanProfil,
                  child: const Text('Simpan Profil'),
                ),
                const SizedBox(height: 10),
                OutlinedButton(
                  onPressed: () async {
                    final prefs = await SharedPreferences.getInstance();
                    await prefs.remove('role');
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (_) => const LoginScreen()),
                    );
                  },
                  child: const Text('Logout'),
                ),

              ],
            ),
          ),
        ),
      );
    }
  }
