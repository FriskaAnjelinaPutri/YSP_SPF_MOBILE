import 'package:apk_absebsi/models/absensi_model.dart';

class AbsensiHistory {
  final Map<String, dynamic> summary;
  final List<Absensi> history;

  AbsensiHistory({
    required this.summary,
    required this.history,
  });

  factory AbsensiHistory.fromJson(Map<String, dynamic> json) {
    return AbsensiHistory(
      summary: json['summary'] as Map<String, dynamic>,
      history:
          (json['data'] as List)
              .map((item) => Absensi.fromJson(item as Map<String, dynamic>))
              .toList(),
    );
  }
}
