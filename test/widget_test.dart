import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tokokita/main.dart';
import 'package:tokokita/model/login.dart';
import 'package:tokokita/model/produk.dart';
import 'package:tokokita/ui/produk_detail.dart';

void main() {
  test('Model fromJson parses string numbers from PHP API safely', () {
    final login = Login.fromJson({
      'code': 200,
      'status': true,
      'data': {
        'token': 'abc123token',
        'user': {'id': '1', 'email': 'admin@admin.com'},
      },
    });
    expect(login.code, 200);
    expect(login.status, true);
    expect(login.token, 'abc123token');
    expect(login.userID, 1);
    expect(login.userEmail, 'admin@admin.com');

    final produk = Produk.fromJson({
      'id': '5',
      'kode_produk': 'A001',
      'nama_produk': 'Kamera',
      'harga': '5000000',
    });
    expect(produk.id, 5);
    expect(produk.kodeProduk, 'A001');
    expect(produk.namaProduk, 'Kamera');
    expect(produk.hargaProduk, 5000000);
  });

  testWidgets('App shows LoginPage when no token and navigates to Registrasi', (
    WidgetTester tester,
  ) async {
    SharedPreferences.setMockInitialValues({});
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    expect(find.widgetWithText(ElevatedButton, 'Login'), findsOneWidget);

    await tester.tap(find.text('Registrasi'));
    await tester.pumpAndSettle();

    expect(find.text('Konfirmasi Password'), findsOneWidget);
  });

  testWidgets('ProdukDetail navigates to ProdukForm in UBAH mode', (
    WidgetTester tester,
  ) async {
    final produk = Produk(
      id: 1,
      kodeProduk: 'A001',
      namaProduk: 'Kamera',
      hargaProduk: 5000000,
    );
    await tester.pumpWidget(MaterialApp(home: ProdukDetail(produk: produk)));

    expect(find.text('Kode : A001'), findsOneWidget);
    await tester.tap(find.text('EDIT'));
    await tester.pumpAndSettle();

    expect(find.text('UBAH PRODUK'), findsOneWidget);
    expect(find.text('UBAH'), findsOneWidget);
  });
}
