import 'package:flutter/material.dart';
import 'package:tokokita/bloc/logout_bloc.dart';
import 'package:tokokita/bloc/produk_bloc.dart';
import 'package:tokokita/model/produk.dart';
import 'package:tokokita/ui/login_page.dart';
import 'package:tokokita/ui/produk_detail.dart';
import 'package:tokokita/ui/produk_form.dart';

class ProdukPage extends StatefulWidget {
  const ProdukPage({super.key});

  @override
  ProdukPageState createState() => ProdukPageState();
}

class ProdukPageState extends State<ProdukPage> {
  late Future<List<Produk>> _futureProduk;

  @override
  void initState() {
    super.initState();
    _loadProduk();
  }

  void _loadProduk() {
    _futureProduk = ProdukBloc.getProduks();
  }

  Future<void> _refreshProduk() async {
    setState(() {
      _loadProduk();
    });
    await _futureProduk;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('List Produk'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20.0),
            child: GestureDetector(
              child: const Icon(Icons.add, size: 26.0),
              onTap: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ProdukForm()),
                );
                if (mounted) {
                  setState(() {
                    _loadProduk();
                  });
                }
              },
            ),
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            ListTile(
              title: const Text('Logout'),
              trailing: const Icon(Icons.logout),
              onTap: () async {
                await LogoutBloc.logout();
                if (!context.mounted) return;
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => const LoginPage()),
                  (route) => false,
                );
              },
            ),
          ],
        ),
      ),
      body: FutureBuilder<List<Produk>>(
        future: _futureProduk,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Gagal memuat data produk:\n${snapshot.error}',
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: _refreshProduk,
                      child: const Text('Coba Lagi'),
                    ),
                  ],
                ),
              ),
            );
          }
          final list = snapshot.data ?? [];
          if (list.isEmpty) {
            return RefreshIndicator(
              onRefresh: _refreshProduk,
              child: ListView(
                children: const [
                  SizedBox(height: 120),
                  Center(child: Text('Belum ada data produk')),
                ],
              ),
            );
          }
          return RefreshIndicator(
            onRefresh: _refreshProduk,
            child: ListProduk(list: list),
          );
        },
      ),
    );
  }
}

class ListProduk extends StatelessWidget {
  final List<Produk> list;

  const ListProduk({super.key, required this.list});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: list.length,
      itemBuilder: (context, i) {
        return ItemProduk(produk: list[i]);
      },
    );
  }
}

class ItemProduk extends StatelessWidget {
  final Produk produk;

  const ItemProduk({super.key, required this.produk});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProdukDetail(produk: produk),
          ),
        );
      },
      child: Card(
        child: ListTile(
          title: Text(produk.namaProduk ?? ''),
          subtitle: Text(produk.hargaProduk?.toString() ?? ''),
        ),
      ),
    );
  }
}
