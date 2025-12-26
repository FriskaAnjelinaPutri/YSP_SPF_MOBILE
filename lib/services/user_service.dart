import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/user_model.dart';

class UserService {
  // Base URL langsung di sini
  final String baseUrl = 'http://10.101.157.163:8000/api'; // ganti sesuai URL API Laravel-mu
  final String token;

  UserService({required this.token});

  // Ambil profile
  Future<UserModel> getProfile() async {
    final response = await http.get(
      Uri.parse('$baseUrl/user/profile'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return UserModel.fromJson(data);
    } else {
      throw Exception('Gagal mengambil profile');
    }
  }

  // Update profile
  Future<UserModel> updateProfile({
    String? email,
    String? password,
    String? passwordConfirmation,
  }) async {
    final response = await http.put(
      Uri.parse('$baseUrl/user/update'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: json.encode({
        if (email != null) 'email': email,
        if (password != null) 'password': password,
        if (passwordConfirmation != null) 'password_confirmation': passwordConfirmation,
      }),
    );

    final data = json.decode(response.body);

    if (response.statusCode == 200 && data['user'] != null) {
      return UserModel.fromJson(data['user']);
    } else {
      throw Exception(data['message'] ?? 'Gagal update profile');
    }
  }
}
