import 'package:flutter/material.dart';
import 'core/constants/colors.dart';
import 'screens/main_navigation_screen.dart';

void main() {
  runApp(const ApelApp());
}

class ApelApp extends StatelessWidget {
  const ApelApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'APEL - Aplikasi Pelaporan Lingkungan',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: AppColors.background,
        primaryColor: AppColors.primaryTeal,
        fontFamily: 'Plus Jakarta Sans', // Jika sudah memasang font
      ),
      home: const MainNavigationScreen(),
    );
  }
}