import '../models/report_model.dart';

class ReportService {
  // Simulasi penarikan data dari backend REST API milik Deva
  Future<List<ReportModel>> fetchReports() async {
    // Simulasi delay jaringan (500ms)
    await Future.delayed(const Duration(milliseconds: 500));

    return [
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
  }
}