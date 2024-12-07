import 'dart:convert';
import 'package:http/http.dart' as http;
import 'Hino.dart';

Future<List<Hino>> fetchHinos() async {
  final response = await http.get(Uri.parse('http://overclock.kinghost.net:21055/hinos'));

  if (response.statusCode == 200) {
    List<dynamic> data = jsonDecode(response.body);
    return data.map((item) {
      return Hino(
        title: item['titulo'] ?? 'Sem titulos',
        numero: item['numero'] ?? 0,
        letra: (item['letra'] as List<dynamic>).join('\n'),
      );
    }).toList();
  } else {
    throw Exception('Falha ao carregar as harpas');
  }
}