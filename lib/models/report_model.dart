class ReportModel {
  final String id;          // Contoh: "#APEL-JTG-0042"[cite: 1]
  final String title;       // Contoh: "Rongsokan menutup bahu jalan"[cite: 1]
  final String location;    // Contoh: "Dusun 2 Jatingarang"[cite: 1]
  final String date;        // Contoh: "30 Oktober 2026"[cite: 1]
  final int disturbanceLevel; // Skala 1 - 5[cite: 1]
  final String status;      // "baru", "lapangan", "selesai", "tolak"[cite: 1]
  final String description; // Deskripsi rinci masalah[cite: 1]
  final String imageUrl;    // Path foto kejadian[cite: 1]

  ReportModel({
    required this.id,
    required this.title,
    required this.location,
    required this.date,
    required this.disturbanceLevel,
    required this.status,
    required this.description,
    required this.imageUrl,
  });

  // Konversi dari Map/JSON (Berguna saat tarik data dari API/Database)
  factory ReportModel.fromMap(Map<String, dynamic> map) {
    return ReportModel(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      location: map['location'] ?? '',
      date: map['date'] ?? '',
      disturbanceLevel: map['disturbanceLevel'] ?? 1,
      status: map['status'] ?? 'baru',
      description: map['description'] ?? '',
      imageUrl: map['imageUrl'] ?? '',
    );
  }

  // Konversi ke Map/JSON (Berguna saat kirim data ke API/Database)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'location': location,
      'date': date,
      'disturbanceLevel': disturbanceLevel,
      'status': status,
      'description': description,
      'imageUrl': imageUrl,
    };
  }
}