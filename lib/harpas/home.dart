import 'package:flutter/material.dart';
import 'package:trabalhofluter/model/hino_list.dart';
import 'package:trabalhofluter/model/Hino.dart';
import 'package:trabalhofluter/harpas/letras_page.dart';
import 'package:provider/provider.dart';
import 'package:trabalhofluter/favoritos/FavoritosProvider.dart';

class HarpasHomePage extends StatefulWidget {
  const HarpasHomePage({super.key});

  @override
  _HarpasHomePageState createState() => _HarpasHomePageState();
}

class _HarpasHomePageState extends State<HarpasHomePage> {
  late Future<List<Hino>> futureHinos;

  @override
  void initState() {
    super.initState();
    futureHinos = fetchHinos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Harpas'),
      ),
      body: FutureBuilder<List<Hino>>(
        future: futureHinos,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Não há harpas disponíveis'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final hino = snapshot.data![index];
                final isFavorito = context.watch<FavoritosProvider>().favoritos.contains(hino.title);
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: ListTile(
                    title: Text('${hino.numero} - ${hino.title}'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.info),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => LetrasPage(hino: hino),
                              ),
                            );
                          },
                        ),
                        IconButton(
                          icon: Icon(
                            isFavorito ? Icons.favorite : Icons.favorite_border,
                            color: isFavorito ? Colors.red : null,
                          ),
                          onPressed: () {
                            if (isFavorito) {
                              context.read<FavoritosProvider>().removeFavorito(hino.title);
                            } else {
                              context.read<FavoritosProvider>().addFavorito(hino.title);
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}