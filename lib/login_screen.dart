import 'package:flutter/material.dart';
import 'home_wrapper.dart';
import 'rekruter_wrapper.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../helpers/db_helper.dart';
import '../models/mahasiswa.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  String _selectedRole = 'mahasiswa'; // default

  void handleLogin() async {
    String email = emailController.text.trim();
    String password = passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Email dan password wajib diisi")),
      );
      return;
    }

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('role', _selectedRole);

    if (_selectedRole == 'rekruter') {

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const RekruterWrapper()),
      );
    } else {
      final db = DBHelper();
      Mahasiswa? mahasiswa = await db.loginMahasiswa(email, password);

      if (mahasiswa != null) {
        await prefs.setString('nama_mahasiswa', mahasiswa.nama); // simpan nama
        await prefs.setInt('mahasiswa_id', mahasiswa.id!);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const HomeMahasiswaWrapper()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Login mahasiswa gagal.")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Password'),
            ),
            const SizedBox(height: 20),
            DropdownButton<String>(
              value: _selectedRole,
              items: const [
                DropdownMenuItem(value: 'mahasiswa', child: Text('Mahasiswa')),
                DropdownMenuItem(value: 'rekruter', child: Text('Rekruter')),
              ],
              onChanged: (value) {
                setState(() {
                  _selectedRole = value!;
                });
              },
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: handleLogin,
              child: const Text('Login'),
            ),
          ],
        ),
      ),
    );
  }
}
