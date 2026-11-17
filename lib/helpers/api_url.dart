import 'package:flutter/foundation.dart';

class ApiUrl {
  static String get baseUrl {
    const envBaseUrl = String.fromEnvironment('API_BASE_URL');
    if (envBaseUrl.isNotEmpty) {
      return envBaseUrl;
    }
    // Android emulator mengakses localhost komputer host melalui 10.0.2.2.
    // Jika memakai XAMPP (C:\xampp\htdocs\toko-api), ubah ke:
    // - Android Emulator: 'http://10.0.2.2/toko-api/public'
    // - Web / Desktop   : 'http://localhost/toko-api/public'
    if (!kIsWeb && defaultTargetPlatform == TargetPlatform.android) {
      return 'http://10.0.2.2:8080';
    }
    return 'http://localhost:8080';
  }

  static String get registrasi => '$baseUrl/registrasi';
  static String get login => '$baseUrl/login';
  static String get listProduk => '$baseUrl/produk';
  static String get createProduk => '$baseUrl/produk';

  static String updateProduk(int id) {
    return '$baseUrl/produk/$id';
  }

  static String showProduk(int id) {
    return '$baseUrl/produk/$id';
  }

  static String deleteProduk(int id) {
    return '$baseUrl/produk/$id';
  }
}
