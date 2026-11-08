import 'package:flutter/material.dart';

import '../models/report_model.dart';
import '../services/report_service.dart';

class ReportStatusScreen extends StatefulWidget {
  const ReportStatusScreen({super.key});

  @override
  State<ReportStatusScreen> createState() => _ReportStatusScreenState();
}

class _ReportStatusScreenState extends State<ReportStatusScreen> {
  final ReportService _reportService = ReportService();

  late Future<List<ReportModel>> _reportsFuture;

  @override
  void initState() {
    super.initState();
    _loadReports();
  }

  void _loadReports() {
    _reportsFuture = _reportService.fetchReports();
  }

  Future<void> _refreshReports() async {
    setState(() {
      _loadReports();
    });

    await _reportsFuture;
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'baru':
        return Colors.orange;

      case 'lapangan':
      case 'tindak_lanjut':
        return Colors.blue;

      case 'selesai':
        return Colors.green;

      case 'tolak':
      case 'ditolak':
        return Colors.red;

      default:
        return Colors.grey;
    }
  }

  String _getStatusLabel(String status) {
    switch (status.toLowerCase()) {
      case 'baru':
        return 'Menunggu Verifikasi';

      case 'lapangan':
      case 'tindak_lanjut':
        return 'Tindak Lanjut';

      case 'selesai':
        return 'Selesai';

      case 'tolak':
      case 'ditolak':
        return 'Ditolak';

      default:
        return 'Tidak Diketahui';
    }
  }

  Widget _buildReportCard(ReportModel report) {
    final statusColor = _getStatusColor(report.status);

    return Card(
      margin: const EdgeInsets.only(bottom: 14),
      color: Colors.white,
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    report.id,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: statusColor.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    _getStatusLabel(report.status),
                    style: TextStyle(
                      color: statusColor,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            Text(
              report.title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 8),

            Row(
              children: [
                const Icon(
                  Icons.location_on_outlined,
                  size: 16,
                  color: Colors.grey,
                ),
                const SizedBox(width: 5),
                Expanded(
                  child: Text(
                    report.location,
                    style: const TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 5),

            Row(
              children: [
                const Icon(
                  Icons.calendar_today_outlined,
                  size: 15,
                  color: Colors.grey,
                ),
                const SizedBox(width: 5),
                Text(
                  report.date,
                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ],
            ),

            const SizedBox(height: 14),

            const Divider(height: 1),

            const SizedBox(height: 10),

            Row(
              children: [
                Icon(Icons.info_outline, color: statusColor, size: 18),
                const SizedBox(width: 7),
                Expanded(
                  child: Text(
                    'Status: ${_getStatusLabel(report.status)}',
                    style: TextStyle(
                      color: statusColor,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Status Laporan Saya',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFF123047),
        foregroundColor: Colors.white,
        elevation: 0,
      ),

      body: RefreshIndicator(
        onRefresh: _refreshReports,
        child: FutureBuilder<List<ReportModel>>(
          future: _reportsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                children: const [
                  SizedBox(height: 150),
                  Center(
                    child: Text(
                      'Gagal memuat laporan.',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                ],
              );
            }

            final reports = snapshot.data ?? [];

            if (reports.isEmpty) {
              return ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                children: const [
                  SizedBox(height: 150),
                  Icon(
                    Icons.description_outlined,
                    size: 60,
                    color: Colors.grey,
                  ),
                  SizedBox(height: 12),
                  Center(
                    child: Text(
                      'Belum ada laporan.',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                ],
              );
            }

            return ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(16),
              children: [
                const Text(
                  'Pantau perkembangan laporan lingkungan '
                  'yang telah kamu kirim.',
                  style: TextStyle(fontSize: 13, color: Colors.grey),
                ),

                const SizedBox(height: 18),

                Text(
                  '${reports.length} Laporan Saya',
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 12),

                ...reports.map(_buildReportCard),
              ],
            );
          },
        ),
      ),
    );
  }
}
