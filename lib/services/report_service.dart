import '../models/report_model.dart';

class ReportService {
  static int totalKoin = 750;

  // Menyimpan ID laporan yang sudah pernah diklaim.
  static final Set<String> _claimedReportIds = {};

  // Data sementara untuk pengujian aplikasi.
  static final List<ReportModel> _reports = [
    ReportModel(
      id: '#APEL-JTG-0042',
      title: 'Rongsokan menutup bahu jalan',
      location: 'Dusun 2 Jatingarang',
      date: '30 Oktober 2026',
      disturbanceLevel: 5,
      status: 'baru',
      description:
          'Tumpukan barang bekas memakan sebagian bahu jalan umum.',
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

  Future<List<ReportModel>> fetchReports() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return List<ReportModel>.from(_reports);
  }

  Future<void> addReport(ReportModel report) async {
    _reports.insert(0, report);
  }

  String generateReportId() {
    final nextNumber = 43 + (_reports.length - 3);
    return '#APEL-JTG-${nextNumber.toString().padLeft(4, '0')}';
  }

  List<ReportModel> getCompletedUnclaimedReports() {
    return _reports.where((report) {
      return report.status.toLowerCase() == 'selesai' &&
          !_claimedReportIds.contains(report.id);
    }).toList();
  }

  Future<bool> claimReward(String reportId) async {
    final reportExists = _reports.any(
      (report) =>
          report.id == reportId &&
          report.status.toLowerCase() == 'selesai',
    );

    if (!reportExists || _claimedReportIds.contains(reportId)) {
      return false;
    }

    _claimedReportIds.add(reportId);
    totalKoin += 1200;
    return true;
  }
}
