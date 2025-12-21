import 'dart:convert';
import 'package:http/http.dart' as http;

class LemburService {
  static const String baseUrl = "http://10.237.26.124:8000/api";

  // ============================================================
  // 1️⃣ RIWAYAT LEMBUR
  // Route Laravel: GET /lembur/riwayat/all
  // ============================================================
  static Future<List<dynamic>> getRiwayat({required String token}) async {
    final url = Uri.parse('$baseUrl/lembur/riwayat/all');

    final response = await http.get(
      url,
      headers: {"Authorization": "Bearer $token", "Accept": "application/json"},
    );

    final body = jsonDecode(response.body);

    if (response.statusCode == 200 && body['success'] == true) {
      return body['data'] ?? [];
    }

    throw Exception(body['message'] ?? "Gagal mengambil riwayat lembur");
  }

  // ============================================================
  // 2️⃣ AJUKAN LEMBUR
  // Route Laravel: POST /lembur/pengajuan
  // ============================================================
  static Future<Map<String, dynamic>> addLembur({
    required String token,
    required Map<String, dynamic> data,
  }) async {
    final url = Uri.parse('$baseUrl/lembur/pengajuan');

    final response = await http.post(
      url,
      headers: {
        "Authorization": "Bearer $token",
        "Accept": "application/json",
        "Content-Type": "application/json",
      },
      body: jsonEncode(data),
    );

    return jsonDecode(response.body);
  }

  // ============================================================
  // 3️⃣ DETAIL LEMBUR
  // Route Laravel: GET /lembur/detail/{id}
  // ============================================================
  static Future<Map<String, dynamic>> getDetail({
    required String token,
    required int id,
  }) async {
    final url = Uri.parse('$baseUrl/lembur/detail/$id');

    final response = await http.get(
      url,
      headers: {"Authorization": "Bearer $token", "Accept": "application/json"},
    );

    final body = jsonDecode(response.body);

    if (response.statusCode == 200 && body['success'] == true) {
      return body['data'] ?? {};
    }

    throw Exception(body['message'] ?? "Gagal mengambil detail lembur");
  }

  // ============================================================
  // 4️⃣ BATALKAN LEMBUR
  // Route Laravel: DELETE /lembur/{id}
  // ============================================================
  static Future<Map<String, dynamic>> batalLembur({
    required String token,
    required int id,
  }) async {
    final url = Uri.parse('$baseUrl/lembur/$id');

    final response = await http.delete(
      url,
      headers: {"Authorization": "Bearer $token", "Accept": "application/json"},
    );

    return jsonDecode(response.body);
  }
}
