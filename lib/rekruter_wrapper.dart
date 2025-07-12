import 'package:flutter/material.dart';
import 'rekruter_home.dart';
import 'rekruter_status.dart';
import 'rekruter_profil.dart';

class RekruterWrapper extends StatefulWidget {
  const RekruterWrapper({super.key});

  @override
  State<RekruterWrapper> createState() => _RekruterWrapperState();
}

class _RekruterWrapperState extends State<RekruterWrapper> {
  int _currentIndex = 0;

  final List<Widget> _pages = const [
    RekruterHomePage(),
    RekruterStatus(),
    RekruterProfilPage(),
  ];

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
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.work), label: 'Lowongan'),
          BottomNavigationBarItem(icon: Icon(Icons.assignment), label: 'Status'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profil'),
        ],
      ),
    );
  }
}
