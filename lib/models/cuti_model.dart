class Cuti {
  final int? id;
  final String nik;
  final String tanggalMulai;
  final String tanggalSelesai;
  final String alasan;
  final String status;

  Cuti({
    this.id,
    required this.nik,
    required this.tanggalMulai,
    required this.tanggalSelesai,
    required this.alasan,
    required this.status,
  });

  factory Cuti.fromJson(Map<String, dynamic> json) {
    return Cuti(
      id: json['id'],
      nik: json['nik'],
      tanggalMulai: json['tanggal_mulai'],
      tanggalSelesai: json['tanggal_selesai'],
      alasan: json['alasan'],
      status: json['status'],
    );
  }
}
