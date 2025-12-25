class Helpdesk {
  final int id;
  final String judul;
  final String deskripsi;
  final String kategori;
  final String status;
  final String prioritas;
  final DateTime tanggalDilaporkan;

  Helpdesk({
    required this.id,
    required this.judul,
    required this.deskripsi,
    required this.kategori,
    required this.status,
    required this.prioritas,
    required this.tanggalDilaporkan,
  });

  factory Helpdesk.fromJson(Map<String, dynamic> json) {
    return Helpdesk(
      id: json['id'],
      judul: json['judul'] ?? '',
      deskripsi: json['deskripsi'] ?? '',
      kategori: json['kategori'] ?? '-',
      status: json['status'] ?? '-',
      prioritas: json['prioritas'] ?? '-',
      tanggalDilaporkan:
      DateTime.parse(json['tanggal_dilaporkan']),
    );
  }

  /// ✅ FORMAT TANGGAL UNTUK UI
  String get tanggalFormatted {
    return
      "${tanggalDilaporkan.day.toString().padLeft(2, '0')}-"
          "${tanggalDilaporkan.month.toString().padLeft(2, '0')}-"
          "${tanggalDilaporkan.year}";
  }
}
