class Absensi {
  final String id;
  final String tanggal;
  final String jamMasuk;
  final String? jamKeluar;
  final String status;

  Absensi({
    required this.id,
    required this.tanggal,
    required this.jamMasuk,
    this.jamKeluar,
    required this.status,
  });

  factory Absensi.fromJson(Map<String, dynamic> json) {
    return Absensi(
      id: json['id'],
      tanggal: json['tanggal'],
      jamMasuk: json['jam_masuk'],
      jamKeluar: json['jam_keluar'],
      status: json['status'],
    );
  }
}
