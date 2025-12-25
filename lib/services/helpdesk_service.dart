import 'dart:convert';
import 'package:http/http.dart' as http;

class HelpdeskService {
  static const String baseUrl = "http://10.237.26.124:8000/api";

  // ===============================
  // ✅ LIST HELP DESK
  // ===============================
  static Future<List<dynamic>> getAllHelpdesk(String token) async {
    final url = Uri.parse('$baseUrl/mobile/helpdesk');

    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      },
    );

    final body = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return body['data'] ?? [];
    }

    throw Exception(body['message'] ?? 'Gagal mengambil data helpdesk');
  }

  // ===============================
  // ✅ CREATE HELP DESK (FIX)
  // ===============================
  static Future<Map<String, dynamic>> addHelpdesk({
    required String token,
    required String judul,
    required String deskripsi,
    required String kategori,
    required String prioritas,
  }) async {
    final url = Uri.parse('$baseUrl/mobile/helpdesk');

    final response = await http.post(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'judul': judul,
        'deskripsi': deskripsi,
        'kategori': kategori,
        'prioritas': prioritas,
      }),
    );

    final body = jsonDecode(response.body);

    return {
      'success': response.statusCode == 201,
      'message': body['message'] ?? 'Gagal mengajukan helpdesk',
      'data': body['data'],
    };
  }

  // ===============================
  // ✅ DETAIL HELP DESK
  // ===============================
  static Future<Map<String, dynamic>> getDetail({
    required String token,
    required int id,
  }) async {
    final url = Uri.parse('$baseUrl/mobile/helpdesk/$id');

    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      },
    );

    final body = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return body['data'] ?? {};
    }

    throw Exception(body['message'] ?? 'Gagal mengambil detail helpdesk');
  }
}
