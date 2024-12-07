import 'dart:convert'; // Para manipular JSON
import 'dart:math'; // Para gerar valores aleatórios
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class PalavraHomepage extends StatefulWidget {
  const PalavraHomepage({super.key});

  @override
  _PalavraHomepageState createState() => _PalavraHomepageState();
}

class _PalavraHomepageState extends State<PalavraHomepage> {
  Map<String, dynamic>? itemAleatorio;
  List<String> favoritos = [];

  @override
  void initState() {
    super.initState();
    _fetchDados();
    _readFavoritos();
  }

  Future<void> _fetchDados() async {
    final numeroAleatorio = Random().nextInt(8) + 1; // Gera um número aleatório de 1 a 8
    final apiUrl = 'http://overclock.kinghost.net:21055/hinos/$numeroAleatorio'; // URL da API com o número aleatório
    final dados = await buscarDadosDaAPI(apiUrl);

    setState(() {
      itemAleatorio = dados;
    });
  }

  Future<Map<String, dynamic>> buscarDadosDaAPI(String url) async {
    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        print('Erro na requisição: ${response.statusCode}');
        return {'titulo': 'Erro ao buscar dados da API.'};
      }
    } catch (e) {
      print('Erro ao conectar com a API: $e');
      return {'titulo': 'Erro ao conectar com a API.'};
    }
  }

  Future<void> _readFavoritos() async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/favoritos.txt');
    if (await file.exists()) {
      final contents = await file.readAsString();
      setState(() {
        favoritos = contents.split('\n').where((line) => line.isNotEmpty).toList();
      });
    }
  }

  Future<void> _saveFavoritos() async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/favoritos.txt');
    await file.writeAsString(favoritos.join('\n'));
  }

  void _addFavorito(String id, String titulo) async {
    final favorito = '$id|$titulo';
    if (favoritos.contains(favorito)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('O hino "$titulo" já está na lista de favoritos.')),
      );
      return;
    }

    final shouldAdd = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Adicionar aos Favoritos'),
        content: const Text('Deseja adicionar este hino à lista de favoritos?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Não'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Sim'),
          ),
        ],
      ),
    );

    if (shouldAdd == true) {
      setState(() {
        favoritos.add(favorito);
      });
      _saveFavoritos();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Hino "$titulo" adicionado aos favoritos.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Palavra do Dia'),
      ),
      body: Center(
        child: itemAleatorio != null
            ? ListView.builder(
          itemCount: 1,
          itemBuilder: (context, index) {
            final id = itemAleatorio!['id'].toString();
            final titulo = itemAleatorio!['titulo'] ?? '';
            final letra = itemAleatorio!['letra'] is List
                ? (itemAleatorio!['letra'] as List).join('\n')
                : itemAleatorio!['letra'] ?? '';
            final isFavorito = favoritos.contains('$id|$titulo');
            return Card(
              margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              child: ListTile(
                title: Text(titulo),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.info),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => LyricsPage(
                              titulo: titulo,
                              letra: letra,
                            ),
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
                        _addFavorito(id, titulo);
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        )
            : const CircularProgressIndicator(),
      ),
    );
  }
}

class LyricsPage extends StatelessWidget {
  final String titulo;
  final String letra;

  const LyricsPage({super.key, required this.titulo, required this.letra});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(titulo),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(
          letra,
          style: const TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}