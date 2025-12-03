class LemburModel {
  final int id;
  final String karKode;
  final String tanggal;
  final String jamMulai;
  final String jamSelesai;
  final String alasan;
  final String? keterangan;
  final String status;
  final String createdAt;
  final String updatedAt;

  // tambahan dari API detail
  final double? durasiJam;
  final String? durasiText;
  final bool? dapatDibatalkan;

  LemburModel({
    required this.id,
    required this.karKode,
    required this.tanggal,
    required this.jamMulai,
    required this.jamSelesai,
    required this.alasan,
    required this.keterangan,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    this.durasiJam,
    this.durasiText,
    this.dapatDibatalkan,
  });

  factory LemburModel.fromJson(Map<String, dynamic> json) {
    return LemburModel(
      id: json['id'],
      karKode: json['kar_kode'],
      tanggal: json['tanggal'],
      jamMulai: json['jam_mulai'],
      jamSelesai: json['jam_selesai'],
      alasan: json['alasan'],
      keterangan: json['keterangan'],
      status: json['status'],
      createdAt: json['created_at'] ?? "",
      updatedAt: json['updated_at'] ?? "",

      // property tambahan ketika ambil detail
      durasiJam: (json['durasi_jam'] != null)
          ? double.tryParse(json['durasi_jam'].toString())
          : null,

      durasiText: json['durasi_text'],
      dapatDibatalkan: json['dapat_dibatalkan'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "kar_kode": karKode,
      "tanggal": tanggal,
      "jam_mulai": jamMulai,
      "jam_selesai": jamSelesai,
      "alasan": alasan,
      "keterangan": keterangan,
      "status": status,
      "created_at": createdAt,
      "updated_at": updatedAt,
      "durasi_jam": durasiJam,
      "durasi_text": durasiText,
      "dapat_dibatalkan": dapatDibatalkan,
    };
  }
}
