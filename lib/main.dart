import 'package:flutter/material.dart';
import 'profil_koin_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'APEL Desa Jatingarang',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: const Color(0xFFF8F9FA),
      ),
      home: const MainNavigationPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MainNavigationPage extends StatefulWidget {
  const MainNavigationPage({super.key});

  @override
  State<MainNavigationPage> createState() => _MainNavigationPageState();
}

class _MainNavigationPageState extends State<MainNavigationPage> {
  // Indeks 2 diarahkan langsung ke halaman Profil & Koin Kopdes (Modul Nofal)
  int _currentIndex = 2;

  final List<Widget> _pages = [
    const Center(child: Text('Halaman Lapor Lingkungan')),
    const Center(child: Text('Halaman Status Tracking (Deva)')),
    const ProfilKoinPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        selectedItemColor: const Color(0xFF1565C0),
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.add_circle_outline),
            label: 'Lapor',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.track_changes),
            label: 'Status',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.monetization_on_outlined),
            label: 'Koin Kopdes',
          ),
        ],
      ),
    );
  }
}