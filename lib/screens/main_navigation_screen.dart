import 'package:flutter/material.dart';
import '../core/constants/colors.dart';
import 'admin/admin_dashboard_screen.dart';

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({Key? key}) : super(key: key);

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 2; // Default ke Tab Admin (Punya Rofiq)

  // Daftar Layar Utama Aplikasi APEL
  final List<Widget> _screens = [
    const PlaceholderLaporScreen(),   // Tab 1: Punya Dika (Form Lapor)
    const PlaceholderStatusScreen(),  // Tab 2: Punya Deva (Status Tracker)
    const AdminDashboardScreen(),     // Tab 3: Punya Rofiq (Dashboard Admin)
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        selectedItemColor: AppColors.primaryTeal,
        unselectedItemColor: AppColors.textMuted,
        backgroundColor: AppColors.surface,
        type: BottomNavigationBarType.fixed,
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
        unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.add_circle_outline),
            activeIcon: Icon(Icons.add_circle),
            label: 'Lapor',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.access_time_outlined),
            activeIcon: Icon(Icons.access_time_filled),
            label: 'Status',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard_outlined),
            activeIcon: Icon(Icons.dashboard),
            label: 'Admin',
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// TEMPORARY PLACEHOLDERS (Nanti diganti saat Dika & Deva selesai push kode)
// ---------------------------------------------------------------------------

class PlaceholderLaporScreen extends StatelessWidget {
  const PlaceholderLaporScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lapor Masalah Lingkungan'),
        backgroundColor: AppColors.primaryNavy,
      ),
      body: const Center(
        child: Text(
          'Halaman Form Lapor\n(Sedang dikembangkan oleh Dika)',
          textAlign: TextAlign.center,
          style: TextStyle(color: AppColors.textMuted, fontSize: 16),
        ),
      ),
    );
  }
}

class PlaceholderStatusScreen extends StatelessWidget {
  const PlaceholderStatusScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Status Laporan Saya'),
        backgroundColor: AppColors.primaryNavy,
      ),
      body: const Center(
        child: Text(
          'Halaman Status Tracking\n(Sedang dikembangkan oleh Deva)',
          textAlign: TextAlign.center,
          style: TextStyle(color: AppColors.textMuted, fontSize: 16),
        ),
      ),
    );
  }
}