import 'package:flutter/material.dart';
import 'package:tokokita/bloc/produk_bloc.dart';
import 'package:tokokita/model/produk.dart';
import 'package:tokokita/ui/produk_form.dart';
import 'package:tokokita/ui/produk_page.dart';
import 'package:tokokita/widget/warning_dialog.dart';

class ProdukDetail extends StatefulWidget {
  final Produk? produk;

  const ProdukDetail({super.key, this.produk});

  @override
  ProdukDetailState createState() => ProdukDetailState();
}

class ProdukDetailState extends State<ProdukDetail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Produk'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Text(
                'Kode : ${widget.produk!.kodeProduk}',
                style: const TextStyle(fontSize: 20.0),
              ),
              Text(
                'Nama : ${widget.produk!.namaProduk}',
                style: const TextStyle(fontSize: 18.0),
              ),
              Text(
                'Harga : Rp. ${widget.produk!.hargaProduk.toString()}',
                style: const TextStyle(fontSize: 18.0),
              ),
              const SizedBox(height: 16),
              _tombolHapusEdit(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _tombolHapusEdit() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Tombol Edit
        OutlinedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ProdukForm(
                  produk: widget.produk!,
                ),
              ),
            );
          },
          child: const Text('EDIT'),
        ),
        const SizedBox(width: 8),
        // Tombol Hapus
        OutlinedButton(
          onPressed: confirmHapus,
          child: const Text('DELETE'),
        ),
      ],
    );
  }

  void confirmHapus() {
    final AlertDialog alertDialog = AlertDialog(
      content: const Text('Yakin ingin menghapus data ini?'),
      actions: [
        // tombol hapus
        OutlinedButton(
          child: const Text('Ya'),
          onPressed: () async {
            Navigator.pop(context);
            try {
              final sukses =
                  await ProdukBloc.deleteProduk(id: widget.produk!.id);
              if (!mounted) return;
              if (sukses) {
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => const ProdukPage()),
                  (route) => false,
                );
              } else {
                showDialog(
                  context: context,
                  builder: (BuildContext dialogContext) => const WarningDialog(
                    description: 'Hapus gagal, silahkan coba lagi',
                  ),
                );
              }
            } catch (error) {
              if (!mounted) return;
              showDialog(
                context: context,
                builder: (BuildContext dialogContext) => const WarningDialog(
                  description: 'Hapus gagal, silahkan coba lagi',
                ),
              );
            }
          },
        ),
        // tombol batal
        OutlinedButton(
          child: const Text('Batal'),
          onPressed: () => Navigator.pop(context),
        ),
      ],
    );

    showDialog(builder: (context) => alertDialog, context: context);
  }
}
