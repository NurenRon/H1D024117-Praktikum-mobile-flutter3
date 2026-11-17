import 'dart:convert';

import 'package:tokokita/helpers/api.dart';
import 'package:tokokita/helpers/api_url.dart';
import 'package:tokokita/model/registrasi.dart';

class RegistrasiBloc {
  static Future<Registrasi> registrasi({
    String? nama,
    String? email,
    String? password,
  }) async {
    final String apiUrl = ApiUrl.registrasi;

    final body = {
      'nama': nama,
      'email': email,
      'password': password,
    };

    final response = await Api().post(apiUrl, body);
    final jsonObj = json.decode(response.body) as Map<String, dynamic>;
    return Registrasi.fromJson(jsonObj);
  }
}
