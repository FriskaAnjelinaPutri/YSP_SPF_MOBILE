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
      id: json['id'].toString(), // int → String
      tanggal: json['tanggal'].toString(),
      jamMasuk:
          json['check_in']?.toString() ?? '-', // nama field sesuai backend
      jamKeluar: json['check_out']?.toString(), // bisa null
      status: json['status'].toString(),
    );
  }
}
