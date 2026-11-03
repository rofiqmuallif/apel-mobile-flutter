import 'package:apel_app/screens/create_report_screen.dart';
import 'package:flutter/material.dart';
import '../core/constants/colors.dart';
import 'admin/admin_dashboard_screen.dart';
import 'auth/login_screen.dart';
import 'profile/profile_and_reward_screen.dart';

class MainNavigationScreen extends StatefulWidget {
  final String userRole; // 'warga' atau 'admin'

  const MainNavigationScreen({super.key, required this.userRole});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 0;

  // Layar khusus Warga (3 Tab)
  final List<Widget> _wargaScreens = [
    const CreateReportScreen(),
    const PlaceholderStatusScreen(),
    const ProfileAndRewardScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    bool isAdmin = widget.userRole == 'admin';

    // JIKA ADMIN: Tampilkan Dashboard Admin langsung dengan tombol Keluar/Logout di AppBar
    if (isAdmin) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Portal Admin Desa'),
          backgroundColor: AppColors.primaryNavy,
          foregroundColor: Colors.white,
          actions: [
            IconButton(
              icon: const Icon(Icons.logout),
              tooltip: 'Keluar',
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                );
              },
            ),
          ],
        ),
        body: const AdminDashboardScreen(),
      );
    }

    // JIKA WARGA: Tampilkan 3 Tab Navigasi Utama
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _wargaScreens,
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
// TEMPORARY PLACEHOLDERS
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