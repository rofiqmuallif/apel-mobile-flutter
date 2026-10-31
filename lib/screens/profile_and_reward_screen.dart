import 'package:flutter/material.dart';
import '../../core/constants/colors.dart';

class ProfileAndRewardScreen extends StatelessWidget {
  const ProfileAndRewardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Profil & Koin Kopdes'),
        backgroundColor: AppColors.primaryNavy,
        foregroundColor: Colors.white,
      ),
      body: const Center(
        child: Text(
          'Halaman Koin Kopdes & Profil\n(Sedang dikembangkan oleh Nofal)',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: AppColors.textMuted,
            fontSize: 16,
            height: 1.5,
          ),
        ),
      ),
    );
  }
}