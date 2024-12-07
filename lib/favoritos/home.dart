import 'package:flutter/material.dart';
import 'package:trabalhofluter/model/hino_list.dart';
import 'package:trabalhofluter/model/Hino.dart';
import 'package:trabalhofluter/harpas/letras_page.dart';
import 'package:provider/provider.dart';
import 'package:trabalhofluter/favoritos/FavoritosProvider.dart';

class FavoritosHomePage extends StatefulWidget {
  const FavoritosHomePage({super.key});

  @override
  _FavoritosHomePageState createState() => _FavoritosHomePageState();
}

class _FavoritosHomePageState extends State<FavoritosHomePage> {
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
        title: const Text('Favoritos'),
      ),
      body: FutureBuilder<List<Hino>>(
        future: futureHinos,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Não há favoritos disponíveis'));
          } else {
            final favoritos = context.watch<FavoritosProvider>().favoritos;
            final favoritosHinos = snapshot.data!.where((hino) => favoritos.contains(hino.title)).toList();

            return ListView.builder(
              itemCount: favoritosHinos.length,
              itemBuilder: (context, index) {
                final hino = favoritosHinos[index];
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
                          icon: const Icon(Icons.delete),
                          onPressed: () {
                            context.read<FavoritosProvider>().removeFavorito(hino.title);
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