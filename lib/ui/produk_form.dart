import 'package:flutter/material.dart';
import 'package:tokokita/bloc/produk_bloc.dart';
import 'package:tokokita/model/produk.dart';
import 'package:tokokita/ui/produk_page.dart';
import 'package:tokokita/widget/warning_dialog.dart';

class ProdukForm extends StatefulWidget {
  final Produk? produk;

  const ProdukForm({super.key, this.produk});

  @override
  ProdukFormState createState() => ProdukFormState();
}

class ProdukFormState extends State<ProdukForm> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  String judul = 'TAMBAH PRODUK';
  String tombolSubmit = 'SIMPAN';

  final _kodeProdukTextboxController = TextEditingController();
  final _namaProdukTextboxController = TextEditingController();
  final _hargaProdukTextboxController = TextEditingController();

  @override
  void initState() {
    super.initState();
    isUpdate();
  }

  @override
  void dispose() {
    _kodeProdukTextboxController.dispose();
    _namaProdukTextboxController.dispose();
    _hargaProdukTextboxController.dispose();
    super.dispose();
  }

  void isUpdate() {
    if (widget.produk != null) {
      setState(() {
        judul = 'UBAH PRODUK';
        tombolSubmit = 'UBAH';
        _kodeProdukTextboxController.text = widget.produk!.kodeProduk ?? '';
        _namaProdukTextboxController.text = widget.produk!.namaProduk ?? '';
        _hargaProdukTextboxController.text =
            widget.produk!.hargaProduk?.toString() ?? '';
      });
    } else {
      judul = 'TAMBAH PRODUK';
      tombolSubmit = 'SIMPAN';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(judul)),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                _kodeProdukTextField(),
                _namaProdukTextField(),
                _hargaProdukTextField(),
                const SizedBox(height: 16),
                _buttonSubmit(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Membuat Textbox Kode Produk
  Widget _kodeProdukTextField() {
    return TextFormField(
      decoration: const InputDecoration(labelText: 'Kode Produk'),
      keyboardType: TextInputType.text,
      controller: _kodeProdukTextboxController,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Kode Produk harus diisi';
        }
        return null;
      },
    );
  }

  // Membuat Textbox Nama Produk
  Widget _namaProdukTextField() {
    return TextFormField(
      decoration: const InputDecoration(labelText: 'Nama Produk'),
      keyboardType: TextInputType.text,
      controller: _namaProdukTextboxController,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Nama Produk harus diisi';
        }
        return null;
      },
    );
  }

  // Membuat Textbox Harga Produk
  Widget _hargaProdukTextField() {
    return TextFormField(
      decoration: const InputDecoration(labelText: 'Harga'),
      keyboardType: TextInputType.number,
      controller: _hargaProdukTextboxController,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Harga harus diisi';
        }
        if (int.tryParse(value) == null) {
          return 'Harga harus berupa angka';
        }
        return null;
      },
    );
  }

  // Membuat Tombol Simpan/Ubah
  Widget _buttonSubmit() {
    return OutlinedButton(
      onPressed: _isLoading
          ? null
          : () {
              final validate = _formKey.currentState!.validate();
              if (validate) {
                if (widget.produk != null) {
                  _ubah();
                } else {
                  _simpan();
                }
              }
            },
      child: _isLoading
          ? const SizedBox(
              width: 18,
              height: 18,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          : Text(tombolSubmit),
    );
  }

  Future<void> _simpan() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final createProduk = Produk(
        kodeProduk: _kodeProdukTextboxController.text,
        namaProduk: _namaProdukTextboxController.text,
        hargaProduk: int.parse(_hargaProdukTextboxController.text),
      );
      final sukses = await ProdukBloc.addProduk(produk: createProduk);
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
            description: 'Simpan gagal, silahkan coba lagi',
          ),
        );
      }
    } catch (error) {
      if (!mounted) return;
      showDialog(
        context: context,
        builder: (BuildContext dialogContext) => const WarningDialog(
          description: 'Simpan gagal, silahkan coba lagi',
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _ubah() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final updateProduk = Produk(
        id: widget.produk!.id,
        kodeProduk: _kodeProdukTextboxController.text,
        namaProduk: _namaProdukTextboxController.text,
        hargaProduk: int.parse(_hargaProdukTextboxController.text),
      );
      final sukses = await ProdukBloc.updateProduk(produk: updateProduk);
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
            description: 'Permintaan ubah data gagal, silahkan coba lagi',
          ),
        );
      }
    } catch (error) {
      if (!mounted) return;
      showDialog(
        context: context,
        builder: (BuildContext dialogContext) => const WarningDialog(
          description: 'Permintaan ubah data gagal, silahkan coba lagi',
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }
}
