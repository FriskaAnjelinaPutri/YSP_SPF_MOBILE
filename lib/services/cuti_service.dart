import 'dart:convert';
import 'package:http/http.dart' as http;

class CutiService {
  // ✅ Ganti sesuai IP Backend kamu
  static const String baseUrl = "http://10.0.2.2:8000/api";

  // ✅ Ambil semua riwayat cuti berdasarkan kar_kode
  static Future<List<dynamic>> getAllCuti(String token, String karKode) async {
    final url = Uri.parse('$baseUrl/cuti/riwayat/all?kar_kode=$karKode');

    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      },
    );

    final body = jsonDecode(response.body);

    if (response.statusCode == 200 && body['success'] == true) {
      return body['data'] ?? [];
    }

    throw Exception(body['message'] ?? "Gagal mengambil data cuti");
  }

  // ✅ Ajukan cuti baru
  static Future<Map<String, dynamic>> addCuti({
    required String token,
    required String karKode,
    required Map<String, dynamic> data,
  }) async {
    // ✅ Tambahkan kar_kode
    data['kar_kode'] = karKode;

    final url = Uri.parse('$baseUrl/cuti/pengajuan');

    final response = await http.post(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(data),
    );

    final body = jsonDecode(response.body);

    return {
      "success": body['success'] ?? false,
      "message": body['message'] ?? "Gagal mengajukan cuti",
    };
  }

  // ✅ Detail cuti berdasarkan ID
  static Future<Map<String, dynamic>> getDetail({
    required String token,
    required int id,
    required String karKode,
  }) async {
    final url = Uri.parse('$baseUrl/cuti/detail/$id?kar_kode=$karKode');

    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      },
    );

    final body = jsonDecode(response.body);

    if (response.statusCode == 200 && body['success'] == true) {
      return body['data'] ?? {};
    }

    throw Exception(body['message'] ?? "Gagal mengambil detail cuti");
  }

  // ✅ Batalkan cuti (sesuai pemanggilan di CutiDetailScreen)
  static Future<Map<String, dynamic>> batalCuti({
    required String token,
    required String id,
    required String karKode,
  }) async {
    final url = Uri.parse('$baseUrl/cuti/$id?kar_kode=$karKode');

    final response = await http.delete(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      },
    );

    final body = jsonDecode(response.body);

    return {
      "success": body['success'] ?? false,
      "message": body['message'] ?? "Gagal membatalkan cuti",
    };
  }
}
