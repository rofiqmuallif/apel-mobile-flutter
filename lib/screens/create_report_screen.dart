import 'dart:io';

import 'package:apel_app/models/form_model.dart';
import 'package:apel_app/models/report_model.dart';
import 'package:apel_app/services/report_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class CreateReportScreen extends StatefulWidget {
  const CreateReportScreen({super.key});

  @override
  State<CreateReportScreen> createState() =>
      _CreateReportScreenState();
}

class _CreateReportScreenState extends State<CreateReportScreen> {
  final _formKey = GlobalKey<FormState>();
  final _descController = TextEditingController();
  final _addressController = TextEditingController();
  final _imagePicker = ImagePicker();

  final ReportService _reportService = ReportService();

  File? _photo;
  double? _severity;

  double? _latitude;
  double? _longitude;

  bool _isSubmitting = false;
  bool _isGettingLocation = false;

  final DateTime _reportDate = DateTime.now();

  @override
  void dispose() {
    _descController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  // ============ FORMAT TANGGAL ============

  String get _formattedDate {
    const bulan = [
      'Januari',
      'Februari',
      'Maret',
      'April',
      'Mei',
      'Juni',
      'Juli',
      'Agustus',
      'September',
      'Oktober',
      'November',
      'Desember',
    ];

    return '${_reportDate.day} '
        '${bulan[_reportDate.month - 1]} '
        '${_reportDate.year}';
  }

  // ============ IMAGE PICKER ============

  Future<void> _pickImage(ImageSource source) async {
    try {
      if (source == ImageSource.camera) {
        final status = await Permission.camera.request();

        if (!status.isGranted) {
          _showSnack(
            'Izin kamera ditolak. Aktifkan di pengaturan.',
          );
          return;
        }
      }

      final picked = await _imagePicker.pickImage(
        source: source,
        imageQuality: 75,
        maxWidth: 1600,
      );

      if (!mounted) return;

      if (picked != null) {
        setState(() {
          _photo = File(picked.path);
        });
      }
    } on PlatformException catch (e) {
      if (mounted) {
        _showSnack('Gagal mengambil gambar: ${e.message}');
      }
    } catch (e) {
      if (mounted) {
        _showSnack('Terjadi kesalahan saat mengambil foto.');
      }
    }
  }

  void _showImageSourceSheet() {
    showModalBottomSheet(
      context: context,
      builder: (_) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Ambil dari Kamera'),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.camera);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Pilih dari Galeri'),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.gallery);
              },
            ),
            if (_photo != null)
              ListTile(
                leading: const Icon(
                  Icons.delete,
                  color: Colors.red,
                ),
                title: const Text(
                  'Hapus Foto',
                  style: TextStyle(color: Colors.red),
                ),
                onTap: () {
                  Navigator.pop(context);
                  setState(() => _photo = null);
                },
              ),
          ],
        ),
      ),
    );
  }

  // ============ AMBIL LOKASI GPS ============

  Future<void> _ambilLokasi() async {
    if (_isGettingLocation) return;

    setState(() => _isGettingLocation = true);

    try {
      final layananAktif =
          await Geolocator.isLocationServiceEnabled();

      if (!layananAktif) {
        throw Exception(
          'GPS perangkat belum aktif. Aktifkan lokasi HP.',
        );
      }

      LocationPermission izin =
          await Geolocator.checkPermission();

      if (izin == LocationPermission.denied) {
        izin = await Geolocator.requestPermission();
      }

      if (izin == LocationPermission.denied) {
        throw Exception('Izin lokasi belum diberikan.');
      }

      if (izin == LocationPermission.deniedForever) {
        throw Exception(
          'Izin lokasi ditolak permanen. Aktifkan melalui pengaturan aplikasi.',
        );
      }

      final posisi = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          timeLimit: Duration(seconds: 25),
        ),
      );

      String alamat =
          '${posisi.latitude.toStringAsFixed(5)}, '
          '${posisi.longitude.toStringAsFixed(5)}';

      try {
        final geocoding = Geocoding();

        final placemarks =
            await geocoding.placemarkFromCoordinates(
          posisi.latitude,
          posisi.longitude,
        );

        if (placemarks.isNotEmpty) {
          final p = placemarks.first;

          final bagian = <String?>[
            p.street,
            p.subLocality,
            p.locality,
            p.subAdministrativeArea,
            p.administrativeArea,
          ].where(
            (v) => v != null && v.trim().isNotEmpty,
          ).toList();

          if (bagian.isNotEmpty) {
            alamat = bagian.join(', ');
          }
        }
      } catch (_) {
        // Gunakan koordinat jika alamat tidak berhasil ditemukan.
      }

      if (!mounted) return;

      setState(() {
        _latitude = posisi.latitude;
        _longitude = posisi.longitude;
        _addressController.text = alamat;
      });

      _showSnack('Lokasi berhasil ditemukan.');
    } catch (e) {
      if (mounted) {
        _showSnack(
          e.toString().replaceFirst('Exception: ', ''),
          color: Colors.red,
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isGettingLocation = false);
      }
    }
  }

  // ============ SUBMIT LAPORAN ============

  Future<void> _submit() async {
    FocusScope.of(context).unfocus();

    if (_severity == null) {
      _showSnack(
        'Silakan pilih skala gangguan terlebih dahulu.',
        color: Colors.orange.shade800,
      );
      return;
    }

    if (!_formKey.currentState!.validate()) return;

    if (_photo == null) {
      _showSnack(
        'Mohon unggah foto kejadian.',
        color: Colors.orange.shade800,
      );
      return;
    }

    if (_addressController.text.trim().isEmpty) {
      _showSnack(
        'Mohon isi lokasi laporan terlebih dahulu.',
        color: Colors.orange.shade800,
      );
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      final deskripsi = _descController.text.trim();

      final judul = deskripsi.length > 40
          ? '${deskripsi.substring(0, 40)}...'
          : deskripsi;

      final report = ReportModel(
        id: _reportService.generateReportId(),
        title: judul,
        location: _addressController.text.trim(),
        date: _formattedDate,
        disturbanceLevel: _severity!.round(),
        status: 'baru',
        description: deskripsi,
        imageUrl: _photo!.path,
      );

      // Masukkan laporan ke daftar ReportService.
      await _reportService.addReport(report);

      final formModel = FormModel(
        photo: _photo,
        severityScale: _severity!.round(),
        description: deskripsi,
        latitude: _latitude,
        longitude: _longitude,
        address: _addressController.text.trim(),
        reportDate: _reportDate,
      );

      if (!mounted) return;

      setState(() => _isSubmitting = false);

      _showDialogSuccess(formModel, report.id);
    } catch (e) {
      if (!mounted) return;

      setState(() => _isSubmitting = false);

      _showSnack(
        'Gagal mengirim laporan: $e',
        color: Colors.red,
      );
    }
  }

  // ============ SNACKBAR ============

  void _showSnack(String msg, {Color? color}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: color,
      ),
    );
  }

  // ============ DIALOG SUKSES ============

  void _showDialogSuccess(FormModel report, String reportId) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => AlertDialog(
        icon: const Icon(
          Icons.check_circle,
          color: Colors.green,
          size: 48,
        ),
        title: const Text('Laporan Terkirim'),
        content: Text(
          'Laporan berhasil dikirim.\n\n'
          'ID: $reportId\n\n'
          'Skala Gangguan: ${report.severityScale}/5\n\n'
          'Lokasi: ${report.address ?? "-"}\n\n'
          'Tanggal: $_formattedDate',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(dialogContext);

              if (!mounted) return;

              setState(() {
                _photo = null;
                _severity = null;
                _latitude = null;
                _longitude = null;
                _descController.clear();
                _addressController.clear();
              });
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  // ============ UI HELPERS ============

  String get _severityLabel {
    if (_severity == null) return 'Belum dipilih';

    switch (_severity!.round()) {
      case 1:
        return 'Ringan';
      case 2:
        return 'Agak Ringan';
      case 3:
        return 'Sedang';
      case 4:
        return 'Mengganggu';
      case 5:
        return 'Sangat Mengganggu';
      default:
        return '-';
    }
  }

  Color get _severityColor {
    if (_severity == null) return Colors.grey;

    return Color.lerp(
      Colors.green,
      Colors.red,
      (_severity! - 1) / 4,
    )!;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Buat Laporan'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _buildPhotoSection(),
              const SizedBox(height: 24),
              _buildSeveritySection(),
              const SizedBox(height: 24),
              _buildDescriptionSection(),
              const SizedBox(height: 24),
              _buildLocationSection(),
              const SizedBox(height: 24),
              _buildDateSection(),
              const SizedBox(height: 32),
              _buildSubmitButton(),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  // ============ FOTO ============

  Widget _buildPhotoSection() {
    return _SectionCard(
      icon: Icons.photo_camera,
      title: 'Foto Kejadian',
      child: AspectRatio(
        aspectRatio: 16 / 10,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: _showImageSourceSheet,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: _photo != null
                    ? Colors.transparent
                    : Colors.grey.shade300,
                width: 2,
              ),
              image: _photo != null
                  ? DecorationImage(
                      image: FileImage(_photo!),
                      fit: BoxFit.cover,
                    )
                  : null,
            ),
            child: _photo == null
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.add_a_photo_outlined,
                        size: 48,
                        color: Colors.grey.shade500,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Ketuk untuk ambil / pilih foto',
                        style: TextStyle(
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  )
                : Align(
                    alignment: Alignment.topRight,
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: CircleAvatar(
                        backgroundColor: Colors.black54,
                        radius: 18,
                        child: IconButton(
                          padding: EdgeInsets.zero,
                          icon: const Icon(
                            Icons.edit,
                            color: Colors.white,
                            size: 18,
                          ),
                          onPressed: _showImageSourceSheet,
                        ),
                      ),
                    ),
                  ),
          ),
        ),
      ),
    );
  }

  // ============ SKALA GANGGUAN ============

  Widget _buildSeveritySection() {
    return _SectionCard(
      icon: Icons.speed,
      title: 'Skala Gangguan Jalan',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    activeTrackColor: _severityColor,
                    thumbColor: _severityColor,
                    inactiveTrackColor: Colors.grey.shade300,
                    trackHeight: 6,
                  ),
                  child: Slider(
                    min: 1,
                    max: 5,
                    divisions: 4,
                    value: _severity ?? 1,
                    label: _severityLabel,
                    onChanged: (v) {
                      setState(() => _severity = v);
                    },
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: _severityColor.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  _severity == null
                      ? '--'
                      : _severity!.round().toString(),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: _severityColor,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Ringan',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                  ),
                ),
                Text(
                  _severityLabel,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: _severityColor,
                  ),
                ),
                Text(
                  'Sangat Mengganggu',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
          if (_severity == null)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Row(
                children: [
                  Icon(
                    Icons.info_outline,
                    size: 14,
                    color: Colors.orange.shade800,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'Geser slider untuk memilih skala',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.orange.shade800,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  // ============ DESKRIPSI ============

  Widget _buildDescriptionSection() {
    return _SectionCard(
      icon: Icons.description_outlined,
      title: 'Deskripsi Masalah',
      child: TextFormField(
        controller: _descController,
        maxLines: 4,
        maxLength: 500,
        textInputAction: TextInputAction.newline,
        decoration: InputDecoration(
          hintText:
              'Contoh: Jalan berlubang cukup dalam di depan SD Negeri 05, '
              'membahayakan pengendara motor saat malam hari...',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          filled: true,
          fillColor: Colors.grey.shade50,
        ),
        validator: (v) {
          if (v == null || v.trim().isEmpty) {
            return 'Deskripsi wajib diisi';
          }

          if (v.trim().length < 10) {
            return 'Deskripsi minimal 10 karakter';
          }

          return null;
        },
      ),
    );
  }

  // ============ LOKASI TANPA GOOGLE MAPS ============

  Widget _buildLocationSection() {
    return _SectionCard(
      icon: Icons.location_on_outlined,
      title: 'Lokasi Laporan',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormField(
            controller: _addressController,
            maxLines: 2,
            decoration: InputDecoration(
              hintText: 'Alamat lokasi kejadian',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              filled: true,
              fillColor: Colors.grey.shade50,
            ),
            validator: (v) {
              if (v == null || v.trim().isEmpty) {
                return 'Lokasi laporan wajib diisi';
              }

              return null;
            },
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed:
                  _isGettingLocation ? null : _ambilLokasi,
              icon: _isGettingLocation
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                      ),
                    )
                  : const Icon(Icons.my_location),
              label: Text(
                _isGettingLocation
                    ? 'Mengambil lokasi...'
                    : 'Gunakan Lokasi Saya',
              ),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Lokasi dapat diisi otomatis melalui GPS atau ditulis manual.',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }

  // ============ TANGGAL ============

  Widget _buildDateSection() {
    return _SectionCard(
      icon: Icons.calendar_today_outlined,
      title: 'Tanggal Laporan',
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 15,
        ),
        decoration: BoxDecoration(
          color: Colors.grey.shade50,
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(
              Icons.calendar_month,
              color: Colors.blue.shade700,
            ),
            const SizedBox(width: 12),
            Text(
              _formattedDate,
              style: const TextStyle(fontSize: 15),
            ),
          ],
        ),
      ),
    );
  }

  // ============ TOMBOL KIRIM ============

  Widget _buildSubmitButton() {
    return SizedBox(
      height: 52,
      child: ElevatedButton.icon(
        onPressed: _isSubmitting ? null : _submit,
        icon: _isSubmitting
            ? const SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              )
            : const Icon(Icons.send),
        label: Text(
          _isSubmitting
              ? 'Mengirim...'
              : 'Kirim Laporan Resmi',
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue.shade700,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

// ============ WIDGET HELPER ============

class _SectionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final Widget child;

  const _SectionCard({
    required this.icon,
    required this.title,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              icon,
              size: 20,
              color: Colors.blue.shade700,
            ),
            const SizedBox(width: 8),
            Text(
              title,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        child,
      ],
    );
  }
}
