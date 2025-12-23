import 'package:flutter/material.dart';
import 'package:apk_absebsi/screens/absen_keluar_screen.dart';
import 'package:apk_absebsi/screens/absen_masuk_screen.dart';
import 'package:apk_absebsi/screens/login_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // ⬅️ INI PENTING
      title: 'YSP Flutter App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const LoginScreen(),
      routes: {
        '/absen-masuk': (context) => const AbsenMasukScreen(),
        '/absen-keluar': (context) => const AbsenKeluarScreen(),
      },
    );
  }
}
