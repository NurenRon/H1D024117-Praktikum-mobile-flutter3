import 'dart:convert';

import 'package:tokokita/helpers/api.dart';
import 'package:tokokita/helpers/api_url.dart';
import 'package:tokokita/model/produk.dart';

class ProdukBloc {
  static Future<List<Produk>> getProduks() async {
    final String apiUrl = ApiUrl.listProduk;
    final response = await Api().get(apiUrl);
    final jsonObj = json.decode(response.body) as Map<String, dynamic>;
    final listProduk = (jsonObj['data'] as List<dynamic>? ?? []);
    return listProduk
        .map((item) => Produk.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  static Future<bool> addProduk({Produk? produk}) async {
    final String apiUrl = ApiUrl.createProduk;

    final body = {
      'kode_produk': produk!.kodeProduk,
      'nama_produk': produk.namaProduk,
      'harga': produk.hargaProduk.toString(),
    };

    final response = await Api().post(apiUrl, body);
    final jsonObj = json.decode(response.body) as Map<String, dynamic>;
    return jsonObj['status'] == true;
  }

  static Future<bool> updateProduk({required Produk produk}) async {
    final String apiUrl = ApiUrl.updateProduk(produk.id!);

    final body = {
      'kode_produk': produk.kodeProduk,
      'nama_produk': produk.namaProduk,
      'harga': produk.hargaProduk.toString(),
    };

    final response = await Api().put(apiUrl, body);
    final jsonObj = json.decode(response.body) as Map<String, dynamic>;
    return jsonObj['status'] == true;
  }

  static Future<bool> deleteProduk({int? id}) async {
    final String apiUrl = ApiUrl.deleteProduk(id!);

    final response = await Api().delete(apiUrl);
    final jsonObj = json.decode(response.body) as Map<String, dynamic>;
    return jsonObj['status'] == true && jsonObj['data'] == true;
  }
}
