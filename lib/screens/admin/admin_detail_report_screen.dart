import 'package:flutter/material.dart';
import '../../core/constants/colors.dart';
import '../../models/report_model.dart';

class AdminDetailReportScreen extends StatefulWidget {
  final ReportModel report;

  const AdminDetailReportScreen({super.key, required this.report});

  @override
  State<AdminDetailReportScreen> createState() => _AdminDetailReportScreenState();
}

class _AdminDetailReportScreenState extends State<AdminDetailReportScreen> {
  late String _selectedStatus;

  @override
  void initState() {
    super.initState();
    _selectedStatus = widget.report.status;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(widget.report.id),
        backgroundColor: AppColors.primaryNavy,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Kartu Detail Laporan
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.borderLine),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Gambar Laporan
                  Container(
                    height: 180,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.image, size: 50, color: Colors.grey),
                  ),
                  const SizedBox(height: 16),

                  // Judul & Lokasi
                  Text(
                    widget.report.title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textMain,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '📍 ${widget.report.location}',
                    style: const TextStyle(color: AppColors.textMuted, fontSize: 13),
                  ),
                  Text(
                    '📅 ${widget.report.date}',
                    style: const TextStyle(color: AppColors.textMuted, fontSize: 13),
                  ),
                  const Divider(height: 24),

                  // Deskripsi
                  const Text(
                    'Deskripsi Kejadian:',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    widget.report.description,
                    style: const TextStyle(color: AppColors.textMain, fontSize: 13.5),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Form Status & Aksi Admin
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.borderLine),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Status Laporan',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                  const SizedBox(height: 8),

                  // Dropdown Status
                  DropdownButtonFormField<String>(
                    initialValue: _selectedStatus,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    items: const [
                      DropdownMenuItem(
                        value: 'baru',
                        child: Text('Baru – menunggu verifikasi'),
                      ),
                      DropdownMenuItem(
                        value: 'lapangan',
                        child: Text('Tindak lanjut lapangan'),
                      ),
                      DropdownMenuItem(
                        value: 'selesai',
                        child: Text('Selesai – jalan bersih'),
                      ),
                      DropdownMenuItem(
                        value: 'tolak',
                        child: Text('Ditolak'),
                      ),
                    ],
                    onChanged: (val) {
                      if (val != null) {
                        setState(() {
                          _selectedStatus = val;
                        });
                      }
                    },
                  ),
                  const SizedBox(height: 16),

                  // Tombol Verifikasi
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryTeal,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () {
                        // Simpan perubahan dan kembali ke Dashboard
                        final updated = ReportModel(
                          id: widget.report.id,
                          title: widget.report.title,
                          location: widget.report.location,
                          date: widget.report.date,
                          disturbanceLevel: widget.report.disturbanceLevel,
                          status: _selectedStatus,
                          description: widget.report.description,
                          imageUrl: widget.report.imageUrl,
                        );
                        Navigator.pop(context, updated);
                      },
                      child: const Text(
                        'Verifikasi & Simpan Perubahan',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}