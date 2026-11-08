import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import '../auth/login_screen.dart';

class ProfileAndRewardScreen extends StatefulWidget {
  const ProfileAndRewardScreen({super.key});

  @override
  State<ProfileAndRewardScreen> createState() => _ProfileAndRewardScreenState();
}

class _ProfileAndRewardScreenState extends State<ProfileAndRewardScreen> {
  static const Color _blue = Color(0xFF1565C0);

  int jumlahKoin = 750;
  String namaUser = 'Warga Desa Jatingarang';
  String lokasiUser = 'Desa Jatingarang';
  Uint8List? _fotoProfil;

  final ImagePicker _imagePicker = ImagePicker();

  final List<Map<String, dynamic>> riwayatList = [
    {
      'title': 'Bonus Laporan Kebersihan',
      'date': '28 Oktober 2026',
      'points': '+100 Poin',
      'isPositive': true,
    },
    {
      'title': 'Penukaran Voucher Sembako Desa',
      'date': '25 Oktober 2026',
      'points': '-500 Poin',
      'isPositive': false,
    },
  ];

  Future<void> _konfirmasiLogout() async {
    final bool? keluar = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Konfirmasi Logout'),
        content: const Text('Apakah Anda yakin ingin keluar dari akun?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Logout'),
          ),
        ],
      ),
    );

    if (keluar == true && mounted) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const LoginScreen()),
        (route) => false,
      );
    }
  }

  void _pesan(String pesan, {bool error = false}) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(pesan),
        backgroundColor: error ? Colors.red.shade700 : Colors.green.shade700,
      ),
    );
  }

  Future<void> _pilihFoto(ImageSource source) async {
    try {
      final XFile? hasil = await _imagePicker.pickImage(
        source: source,
        imageQuality: 80,
        maxWidth: 1000,
      );
      if (hasil == null) return;
      final bytes = await hasil.readAsBytes();
      if (!mounted) return;
      setState(() => _fotoProfil = bytes);
    } catch (e) {
      _pesan('Foto tidak dapat diambil. Periksa izin kamera/galeri perangkat.', error: true);
    }
  }

  void _bukaPilihanFoto() {
    showModalBottomSheet<void>(
      context: context,
      builder: (sheetContext) => SafeArea(
        child: Wrap(
          children: [
            const ListTile(
              title: Text('Ubah Foto Profil', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
            ListTile(
              leading: const Icon(Icons.photo_camera_outlined, color: _blue),
              title: const Text('Ambil dari kamera'),
              onTap: () {
                Navigator.pop(sheetContext);
                _pilihFoto(ImageSource.camera);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library_outlined, color: _blue),
              title: const Text('Pilih dari galeri'),
              onTap: () {
                Navigator.pop(sheetContext);
                _pilihFoto(ImageSource.gallery);
              },
            ),
            if (_fotoProfil != null)
              ListTile(
                leading: const Icon(Icons.delete_outline, color: Colors.red),
                title: const Text('Hapus foto profil'),
                onTap: () {
                  Navigator.pop(sheetContext);
                  setState(() => _fotoProfil = null);
                },
              ),
          ],
        ),
      ),
    );
  }

  Future<String?> _ambilLokasi() async {
    if (kIsWeb) {
      _pesan(
        'Untuk fitur alamat otomatis, jalankan aplikasi pada perangkat Android.',
        error: true,
      );
      return null;
    }

    try {
      final bool layananAktif = await Geolocator.isLocationServiceEnabled();
      if (!layananAktif) {
        _pesan('GPS perangkat belum aktif. Aktifkan lokasi lalu coba lagi.', error: true);
        return null;
      }

      LocationPermission izin = await Geolocator.checkPermission();
      if (izin == LocationPermission.denied) {
        izin = await Geolocator.requestPermission();
      }

      if (izin == LocationPermission.denied) {
        _pesan('Izin lokasi ditolak. Izinkan akses lokasi untuk menggunakan GPS.', error: true);
        return null;
      }

      if (izin == LocationPermission.deniedForever) {
        _pesan('Izin lokasi ditolak permanen. Aktifkan melalui Pengaturan aplikasi.', error: true);
        return null;
      }

      final Position posisi = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
        ),
      );

      // Koordinat tetap menjadi alamat cadangan jika reverse geocoding gagal.
      String alamat =
          '${posisi.latitude.toStringAsFixed(5)}, ${posisi.longitude.toStringAsFixed(5)}';

      try {
        final geocoding = Geocoding();
        final placemarks = await geocoding.placemarkFromCoordinates(
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
          ].where((v) => v != null && v.trim().isNotEmpty).toList();

          if (bagian.isNotEmpty) {
            alamat = bagian.join(', ');
          }
        }
      } catch (_) {
        // Jika alamat tidak berhasil diterjemahkan, gunakan koordinat GPS.
      }

      if (!mounted) return null;
      return alamat;
    } catch (_) {
      if (mounted) {
        _pesan(
          'Gagal mengambil lokasi. Coba periksa GPS dan koneksi internet.',
          error: true,
        );
      }
      return null;
    }
  }

  void _bukaDialogEditProfil() {
    final nameController = TextEditingController(text: namaUser);
    final locationController = TextEditingController(text: lokasiUser);
    bool sedangMengambilLokasi = false;

    showDialog<void>(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (dialogContext, setDialogState) => AlertDialog(
          title: const Text(
            'Edit Profil Warga',
            style: TextStyle(
              color: _blue,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  textCapitalization: TextCapitalization.words,
                  decoration: const InputDecoration(
                    labelText: 'Nama & Peran',
                    prefixIcon: Icon(Icons.person_outline),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: locationController,
                  textCapitalization: TextCapitalization.words,
                  decoration: const InputDecoration(
                    labelText: 'Lokasi / Desa',
                    prefixIcon: Icon(Icons.location_on_outlined),
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: sedangMengambilLokasi
                        ? null
                        : () async {
                            setDialogState(() {
                              sedangMengambilLokasi = true;
                            });

                            final alamat = await _ambilLokasi();

                            // Jangan memperbarui dialog jika pengguna sudah menutupnya.
                            if (!dialogContext.mounted) return;

                            if (alamat != null && alamat.isNotEmpty) {
                              locationController.text = alamat;
                            }

                            setDialogState(() {
                              sedangMengambilLokasi = false;
                            });
                          },
                    icon: sedangMengambilLokasi
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.my_location),
                    label: Text(
                      sedangMengambilLokasi
                          ? 'Mengambil lokasi...'
                          : 'Gunakan Lokasi Saya',
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'GPS memerlukan izin lokasi dan layanan lokasi perangkat yang aktif.',
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Batal'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: _blue,
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                final namaBaru = nameController.text.trim();
                final lokasiBaru = locationController.text.trim();

                if (namaBaru.isEmpty || lokasiBaru.isEmpty) {
                  _pesan('Nama dan lokasi tidak boleh kosong.', error: true);
                  return;
                }

                setState(() {
                  namaUser = namaBaru;
                  lokasiUser = lokasiBaru;
                });

                Navigator.pop(dialogContext);
                _pesan('Profil berhasil diperbarui.');
              },
              child: const Text('Simpan'),
            ),
          ],
        ),
      ),
    ).then((_) {
      nameController.dispose();
      locationController.dispose();
    });
  }

  void _simulasiValidasiAdmin() {
    setState(() {
      jumlahKoin += 100;
      riwayatList.insert(0, {
        'title': 'Validasi Laporan Lingkungan (Admin)',
        'date': 'Hari Ini',
        'points': '+100 Poin',
        'isPositive': true,
      });
    });
    _pesan('Simulasi berhasil: +100 poin ditambahkan.');
  }

  void _tukarVoucher({required String nama, required int biaya}) {
    if (jumlahKoin < biaya) {
      Navigator.pop(context);
      _pesan('Koin Anda tidak cukup untuk menukar voucher ini.', error: true);
      return;
    }
    setState(() {
      jumlahKoin -= biaya;
      riwayatList.insert(0, {
        'title': 'Penukaran $nama',
        'date': 'Hari Ini',
        'points': '-$biaya Poin',
        'isPositive': false,
      });
    });
    Navigator.pop(context);
    _pesan('Penukaran voucher berhasil (simulasi).');
  }

  void _bukaKatalogVoucher() {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (sheetContext) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Katalog Voucher Koperasi Desa (Kopdes)', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: _blue)),
              const SizedBox(height: 8),
              const Text('Tukar koinmu dengan berbagai penawaran menarik:'),
              const SizedBox(height: 12),
              _voucherTile('Voucher Sembako Desa', 'Rp 20.000', 500, Icons.shopping_basket_outlined),
              _voucherTile('Voucher Belanja Kopdes', 'Rp 40.000', 1000, Icons.storefront_outlined),
              _voucherTile('Voucher Produk Desa', 'Rp 30.000', 750, Icons.card_giftcard),
            ],
          ),
        ),
      ),
    );
  }

  Widget _voucherTile(String nama, String nilai, int biaya, IconData ikon) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(ikon, color: _blue, size: 30),
      title: Text('$nama ($nilai)'),
      subtitle: Text('Biaya: $biaya Poin'),
      trailing: ElevatedButton(
        style: ElevatedButton.styleFrom(backgroundColor: _blue, foregroundColor: Colors.white),
        onPressed: () => _tukarVoucher(nama: nama, biaya: biaya),
        child: const Text('Tukar'),
      ),
    );
  }

  Widget _buildRiwayatCard({
    required String title,
    required String date,
    required String points,
    required bool isPositive,
  }) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14, color: Colors.black87)),
                const SizedBox(height: 4),
                Text(date, style: const TextStyle(color: Colors.grey, fontSize: 12)),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Text(points, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: isPositive ? Colors.green : Colors.red)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: const Text('Profil & Koin Kopdes', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: _blue,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          PopupMenuButton<String>(
            tooltip: 'Menu lainnya',
            icon: const Icon(Icons.more_vert, color: Colors.white),
            onSelected: (value) {
              if (value == 'logout') _konfirmasiLogout();
            },
            itemBuilder: (context) => const [
              PopupMenuItem<String>(
                value: 'logout',
                child: Row(
                  children: [
                    Icon(Icons.logout, color: Colors.red),
                    SizedBox(width: 10),
                    Text('Logout'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InkWell(
              onTap: _bukaDialogEditProfil,
              borderRadius: BorderRadius.circular(12),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.blue.shade100, width: 1.5),
                  boxShadow: [BoxShadow(color: Colors.grey.withValues(alpha: 0.1), spreadRadius: 2, blurRadius: 5, offset: const Offset(0, 3))],
                ),
                child: Row(
                  children: [
                    Stack(
                      children: [
                        CircleAvatar(
                          radius: 30,
                          backgroundColor: _blue,
                          backgroundImage: _fotoProfil == null ? null : MemoryImage(_fotoProfil!),
                          child: _fotoProfil == null ? const Icon(Icons.person, size: 35, color: Colors.white) : null,
                        ),
                        Positioned(
                          right: 0,
                          bottom: 0,
                          child: InkWell(
                            onTap: _bukaPilihanFoto,
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                              child: const Icon(Icons.camera_alt, size: 16, color: _blue),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(namaUser, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87)),
                          const SizedBox(height: 4),
                          Text(lokasiUser, style: const TextStyle(color: Colors.grey, fontSize: 13)),
                          const SizedBox(height: 5),
                          const Text('Ketuk untuk edit profil', style: TextStyle(color: _blue, fontSize: 11)),
                        ],
                      ),
                    ),
                    const Icon(Icons.edit_outlined, color: _blue, size: 20),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(colors: [_blue, Color(0xFF42A5F5)], begin: Alignment.topLeft, end: Alignment.bottomRight),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [BoxShadow(color: Colors.blue.withValues(alpha: 0.25), blurRadius: 8, offset: const Offset(0, 4))],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Total Koin Kopdes Anda', style: TextStyle(color: Colors.white70, fontSize: 14)),
                  const SizedBox(height: 8),
                  Text('$jumlahKoin Poin', style: const TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  const Text('Poin pada tampilan ini masih berupa data simulasi.', style: TextStyle(color: Colors.white70, fontSize: 12)),
                ],
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _bukaKatalogVoucher,
                icon: const Icon(Icons.card_giftcard, color: Colors.white),
                label: const Text('Buka Katalog Penukaran Voucher', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                style: ElevatedButton.styleFrom(backgroundColor: _blue, padding: const EdgeInsets.symmetric(vertical: 14), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: _simulasiValidasiAdmin,
                icon: const Icon(Icons.check_circle_outline, color: _blue),
                label: const Text('Simulasi Laporan Divalidasi Admin (+100 Poin)', style: TextStyle(color: _blue, fontWeight: FontWeight.bold)),
                style: OutlinedButton.styleFrom(side: const BorderSide(color: _blue), padding: const EdgeInsets.symmetric(vertical: 12), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
              ),
            ),
            const SizedBox(height: 24),
            const Text('Riwayat & Aktivitas Koin', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87)),
            const SizedBox(height: 12),
            ...riwayatList.map((item) => _buildRiwayatCard(
                  title: item['title'].toString(),
                  date: item['date'].toString(),
                  points: item['points'].toString(),
                  isPositive: item['isPositive'] as bool,
                )),
          ],
        ),
      ),
    );
  }
}