import 'package:flutter/material.dart';
import 'package:hire_app/rekruter_wrapper.dart';
import 'dart:async';
import 'helpers/db_helper.dart';
import 'home_wrapper.dart';
import 'login_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'models/mahasiswa.dart';


class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _startApp(); // Mulai dengan menjalankan insert dummy, lalu navigasi
  }

  void _startApp() async {
    await _insertDummyOnce(); // Tunggu sampai selesai
    _navigateToProperPage();  // Baru navigasi
  }

  Future<void> _insertDummyOnce() async {
    final db = DBHelper();

    final existing1 = await db.loginMahasiswa('mahasiswa1@example.com', '123456');
    if (existing1 == null) {
      await db.insertMahasiswa(
        Mahasiswa.minimal(email: 'mahasiswa1@example.com', password: '123456'),
      );
      print("✅ Mahasiswa 1 ditambahkan.");
    }

    final existing2 = await db.loginMahasiswa('mahasiswa2@example.com', '123456');
    if (existing2 == null) {
      await db.insertMahasiswa(
        Mahasiswa.minimal(email: 'mahasiswa2@example.com', password: '123456'),
      );
      print("✅ Mahasiswa 2 ditambahkan.");
    }

    final existing3 = await db.loginMahasiswa('mahasiswa3@example.com', '123456');
    if (existing3 == null) {
      await db.insertMahasiswa(
        Mahasiswa.minimal(email: 'mahasiswa3@example.com', password: 'xxxxxx'),
      );
      print("✅ Mahasiswa 3 ditambahkan.");
    }
  }



  void _navigateToProperPage() async {
    final prefs = await SharedPreferences.getInstance();
    final role = prefs.getString('role');

    Widget nextPage;

    if (role == 'rekruter') {
      nextPage = const RekruterWrapper();
    } else if (role == 'mahasiswa') {
      nextPage = const HomeMahasiswaWrapper();
    } else {
      nextPage = const LoginScreen();
    }

    // delay splash 2 detik
    Timer(const Duration(seconds: 4), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => nextPage),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color(0xFF11CAD5), // Warna khas kamu
      body: Center(
        child: Text(
          'Hire',
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }


}
