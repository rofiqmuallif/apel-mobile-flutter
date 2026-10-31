import 'package:flutter/material.dart';
import '../../core/constants/colors.dart';
import '../../models/report_model.dart';
import 'admin_detail_report_screen.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  // Sample data laporan awal sesuai prototipe
  List<ReportModel> reports = [
    ReportModel(
      id: '#APEL-JTG-0042',
      title: 'Rongsokan menutup bahu jalan',
      location: 'Dusun 2 Jatingarang',
      date: '30 Oktober 2026',
      disturbanceLevel: 5,
      status: 'baru',
      description: 'Tumpukan barang bekas memakan sebagian bahu jalan umum.',
      imageUrl: 'assets/images/scrap_sample.jpg',
    ),
    ReportModel(
      id: '#APEL-JTG-0041',
      title: 'Sampah liar di pinggir sungai',
      location: 'Dusun 1 Jatingarang',
      date: '29 Oktober 2026',
      disturbanceLevel: 3,
      status: 'lapangan',
      description: 'Ada tumpukan sampah plastik di dekat jembatan.',
      imageUrl: 'assets/images/scrap_sample.jpg',
    ),
    ReportModel(
      id: '#APEL-JTG-0039',
      title: 'Limbah rongsok meluber',
      location: 'Dusun 3 Jatingarang',
      date: '28 Oktober 2026',
      disturbanceLevel: 4,
      status: 'selesai',
      description: 'Barang rongsokan sudah dirapikan oleh pemilik.',
      imageUrl: 'assets/images/scrap_sample.jpg',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    // Hitung jumlah laporan berdasarkan status
    int countBaru = reports.where((r) => r.status == 'baru').length;
    int countProses = reports.where((r) => r.status == 'lapangan').length;
    int countSelesai = reports.where((r) => r.status == 'selesai').length;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Header Admin Desa
              _buildHeader(countBaru),
              const SizedBox(height: 16),

              // 2. Ringkasan Kartu Statistik
              _buildStatCards(countBaru, countProses, countSelesai),
              const SizedBox(height: 16),

              // 3. Judul Seksi
              const Text(
                'Daftar Laporan Masuk',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textMain,
                ),
              ),
              const SizedBox(height: 12),

              // 4. List Laporan Masuk
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: reports.length,
                itemBuilder: (context, index) {
                  final report = reports[index];
                  return _buildReportItem(report);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget Header Admin
  Widget _buildHeader(int notificationCount) {
    return Container(
      padding: const EdgeInsets.all(18.0),
      decoration: BoxDecoration(
        color: AppColors.primaryNavy,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                'Dashboard Admin',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 4),
              Text(
                'Desa Jatingarang, Kec. Bayan',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 13,
                ),
              ),
            ],
          ),
          // Ikon Lonceng Notifikasi
          Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.18),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.notifications_none,
                  color: Colors.white,
                  size: 24,
                ),
              ),
              if (notificationCount > 0)
                Positioned(
                  right: -2,
                  top: -2,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: AppColors.statusRed,
                      shape: BoxShape.circle,
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 18,
                      minHeight: 18,
                    ),
                    child: Text(
                      '$notificationCount',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  // Widget Kartu Statistik
  Widget _buildStatCards(int baru, int proses, int selesai) {
    return Row(
      children: [
        _buildStatCard('Baru', baru, AppColors.statusRed),
        const SizedBox(width: 8),
        _buildStatCard('Diproses', proses, AppColors.statusAmber),
        const SizedBox(width: 8),
        _buildStatCard('Selesai', selesai, AppColors.statusGreen),
      ],
    );
  }

  Widget _buildStatCard(String label, int value, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.borderLine),
        ),
        child: Column(
          children: [
            Text(
              '$value',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                color: AppColors.textMuted,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget Item Kartu Laporan
  Widget _buildReportItem(ReportModel report) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: AppColors.borderLine),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () async {
          // Buka Halaman Detail Admin & Tunggu Hasil Update Status
          final updatedReport = await Navigator.push<ReportModel>(
            context,
            MaterialPageRoute(
              builder: (context) => AdminDetailReportScreen(report: report),
            ),
          );

          // Jika ada perubahan status dari halaman detail, update UI
          if (updatedReport != null) {
            setState(() {
              int index = reports.indexWhere((r) => r.id == updatedReport.id);
              if (index != -1) {
                reports[index] = updatedReport;
              }
            });
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(14.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Baris ID dan Badge Tingkat Gangguan
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    report.id,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: AppColors.textMain,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.statusRed,
                      borderRadius: BorderRadius.circular(99),
                    ),
                    child: Text(
                      'Tingkat ${report.disturbanceLevel}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),

              // Ringkasan Foto dan Info Laporan
              Row(
                children: [
                  Container(
                    width: 70,
                    height: 70,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.image, color: Colors.grey),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          report.title,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 13.5,
                            color: AppColors.textMain,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '📍 ${report.location}\n📅 ${report.date}',
                          style: const TextStyle(
                            fontSize: 11.5,
                            color: AppColors.textMuted,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}