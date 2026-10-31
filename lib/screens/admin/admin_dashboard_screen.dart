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
  // State Filter Aktif ('semua', 'baru', 'lapangan', 'selesai')
  String _selectedFilter = 'semua';

  // Sample data laporan awal
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

    // Filter daftar laporan berdasarkan filter chip yang dipilih
    List<ReportModel> filteredReports = reports.where((report) {
      if (_selectedFilter == 'semua') return true;
      return report.status == _selectedFilter;
    }).toList();

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

              // 3. Filter Chips
              _buildFilterChips(),
              const SizedBox(height: 16),

              // 4. Judul Seksi
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Daftar Laporan Masuk',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textMain,
                    ),
                  ),
                  Text(
                    '${filteredReports.length} Laporan',
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textMuted,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // 5. List Laporan Masuk
              filteredReports.isEmpty
                  ? Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(32),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppColors.borderLine),
                      ),
                      child: const Column(
                        children: [
                          Icon(Icons.inbox_outlined, size: 48, color: AppColors.textMuted),
                          SizedBox(height: 8),
                          Text(
                            'Tidak ada laporan pada kategori ini',
                            style: TextStyle(color: AppColors.textMuted, fontSize: 13),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: filteredReports.length,
                      itemBuilder: (context, index) {
                        final report = filteredReports[index];
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
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
        _buildStatCard('Baru', baru, AppColors.statusRed, 'baru'),
        const SizedBox(width: 8),
        _buildStatCard('Diproses', proses, AppColors.statusAmber, 'lapangan'),
        const SizedBox(width: 8),
        _buildStatCard('Selesai', selesai, AppColors.statusGreen, 'selesai'),
      ],
    );
  }

  Widget _buildStatCard(String label, int value, Color color, String filterKey) {
    bool isSelected = _selectedFilter == filterKey;
    return Expanded(
      child: InkWell(
        onTap: () {
          setState(() {
            _selectedFilter = isSelected ? 'semua' : filterKey;
          });
        },
        borderRadius: BorderRadius.circular(14),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
          decoration: BoxDecoration(
            color: isSelected ? color.withValues(alpha: 0.1) : AppColors.surface,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: isSelected ? color : AppColors.borderLine,
              width: isSelected ? 2 : 1,
            ),
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
      ),
    );
  }

  // Widget Filter Chips
  Widget _buildFilterChips() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _buildChip('Semua', 'semua'),
          const SizedBox(width: 8),
          _buildChip('Baru', 'baru'),
          const SizedBox(width: 8),
          _buildChip('Tindak Lanjut', 'lapangan'),
          const SizedBox(width: 8),
          _buildChip('Selesai', 'selesai'),
        ],
      ),
    );
  }

  Widget _buildChip(String label, String value) {
    bool isSelected = _selectedFilter == value;
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      selectedColor: AppColors.primaryTeal,
      backgroundColor: AppColors.surface,
      labelStyle: TextStyle(
        color: isSelected ? Colors.white : AppColors.textMain,
        fontWeight: FontWeight.bold,
        fontSize: 12,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(
          color: isSelected ? AppColors.primaryTeal : AppColors.borderLine,
        ),
      ),
      onSelected: (selected) {
        if (selected) {
          setState(() {
            _selectedFilter = value;
          });
        }
      },
    );
  }

  // Widget Item Kartu Laporan dengan Badge Status Dinamis
  Widget _buildReportItem(ReportModel report) {
    Color badgeColor;
    String statusText;

    switch (report.status) {
      case 'lapangan':
        badgeColor = AppColors.statusAmber;
        statusText = 'Diproses';
        break;
      case 'selesai':
        badgeColor = AppColors.statusGreen;
        statusText = 'Selesai';
        break;
      case 'tolak':
        badgeColor = Colors.grey;
        statusText = 'Ditolak';
        break;
      default:
        badgeColor = AppColors.statusRed;
        statusText = 'Baru';
    }

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
          final updatedReport = await Navigator.push<ReportModel>(
            context,
            MaterialPageRoute(
              builder: (context) => AdminDetailReportScreen(report: report),
            ),
          );

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
              // Header ID & Status Badge Dinamis
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
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: badgeColor.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          statusText,
                          style: TextStyle(
                            color: badgeColor,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.statusRed,
                          borderRadius: BorderRadius.circular(6),
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
                ],
              ),
              const SizedBox(height: 10),

              // Detail Gambar & Lokasi
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