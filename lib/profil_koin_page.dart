import 'package:flutter/material.dart';

class ProfilKoinPage extends StatefulWidget {
  const ProfilKoinPage({super.key});

  @override
  State<ProfilKoinPage> createState() => _ProfilKoinPageState();
}

class _ProfilKoinPageState extends State<ProfilKoinPage> {
  int jumlahKoin = 1250;

  // Menggunakan var agar aman tanpa simbol < > yang sering bikin error
  var riwayatList = [
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
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Berhasil! Laporan divalidasi Admin, +100 Poin ditambahkan.'),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _bukaKatalogVoucher() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Katalog Voucher Koperasi Desa (Kopdes)',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1565C0),
                ),
              ),
              const SizedBox(height: 12),
              const Text('Tukar koinmu dengan berbagai penawaran menarik:'),
              const SizedBox(height: 16),
              ListTile(
                leading: const Icon(Icons.card_giftcard, color: Color(0xFF1565C0), size: 30),
                title: const Text('Voucher Sembako Desa (Rp 20.000)'),
                subtitle: const Text('Biaya: 500 Poin'),
                trailing: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1565C0),
                  ),
                  onPressed: () {
                    if (jumlahKoin >= 500) {
                      setState(() {
                        jumlahKoin -= 500;
                        riwayatList.insert(0, {
                          'title': 'Tukar Voucher Sembako Desa',
                          'date': 'Hari Ini',
                          'points': '-500 Poin',
                          'isPositive': false,
                        });
                      });
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Penukaran Voucher Berhasil!')),
                      );
                    } else {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Koin Anda tidak cukup!'),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  },
                  child: const Text('Tukar', style: TextStyle(color: Colors.white)),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: const Text(
          'Profil & Koin Kopdes',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFF1565C0),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withValues(alpha: 0.1),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Row(
                children: [
                  const CircleAvatar(
                    radius: 30,
                    backgroundColor: Color(0xFF1565C0),
                    child: Icon(Icons.person, size: 35, color: Colors.white),
                  ),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'Nofal (Warga / Anggota)',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Desa Jatingarang, Kec. Bayen',
                        style: TextStyle(color: Colors.grey, fontSize: 13),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF1565C0), Color(0xFF42A5F5)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.blue.withValues(alpha: 0.25),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Total Koin Kopdes Anda',
                    style: TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '$jumlahKoin Poin',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Poin otomatis bertambah dari validasi admin dan bisa ditukar voucher.',
                    style: TextStyle(color: Colors.white60, fontSize: 12),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _bukaKatalogVoucher,
                icon: const Icon(Icons.card_giftcard, color: Colors.white),
                label: const Text(
                  'Buka Katalog Penukaran Voucher',
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1565C0),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: _simulasiValidasiAdmin,
                icon: const Icon(Icons.check_circle_outline, color: Color(0xFF1565C0)),
                label: const Text(
                  'Simulasi Laporan Divalidasi Admin (+100 Poin)',
                  style: TextStyle(
                    color: Color(0xFF1565C0),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Color(0xFF1565C0)),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Riwayat & Aktivitas Koin',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 12),
            ...riwayatList.map(
              (item) => _buildRiwayatCard(
                title: item['title'].toString(),
                date: item['date'].toString(),
                points: item['points'].toString(),
                isPositive: item['isPositive'] as bool,
              ),
            ),
          ],
        ),
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
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 4),
              Text(date, style: const TextStyle(color: Colors.grey, fontSize: 12)),
            ],
          ),
          Text(
            points,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
              color: isPositive ? Colors.green : Colors.red,
            ),
          ),
        ],
      ),
    );
  }
}