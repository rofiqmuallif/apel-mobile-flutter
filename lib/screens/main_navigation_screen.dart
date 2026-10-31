import 'package:flutter/material.dart';
import '../core/constants/colors.dart';
import 'admin/admin_dashboard_screen.dart';
import 'profile_and_reward_screen.dart';

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

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
    const ProfileAndRewardScreen(),   // Tab 4: Punya Nofal (Koin Kopdes & Profil)
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
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11),
        unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 11),
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
          BottomNavigationBarItem(
            icon: Icon(Icons.monetization_on_outlined),
            activeIcon: Icon(Icons.monetization_on),
            label: 'Koin Kopdes',
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// TEMPORARY PLACEHOLDERS (Nanti diganti saat Dika, Deva & Nofal selesai push)
// ---------------------------------------------------------------------------

class PlaceholderLaporScreen extends StatelessWidget {
  const PlaceholderLaporScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lapor Masalah Lingkungan'),
        backgroundColor: AppColors.primaryNavy,
        foregroundColor: Colors.white,
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
  const PlaceholderStatusScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Status Laporan Saya'),
        backgroundColor: AppColors.primaryNavy,
        foregroundColor: Colors.white,
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

class PlaceholderKoinScreen extends StatelessWidget {
  const PlaceholderKoinScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil & Koin Kopdes'),
        backgroundColor: AppColors.primaryNavy,
        foregroundColor: Colors.white,
      ),
      body: const Center(
        child: Text(
          'Halaman Koin Kopdes & Profil\n(Sedang dikembangkan oleh Nofal)',
          textAlign: TextAlign.center,
          style: TextStyle(color: AppColors.textMuted, fontSize: 16),
        ),
      ),
    );
  }
}