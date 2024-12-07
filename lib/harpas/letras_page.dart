import 'package:flutter/material.dart';
import 'package:trabalhofluter/model/Hino.dart';

class LetrasPage extends StatelessWidget {
  final Hino hino;

  const LetrasPage({super.key, required this.hino});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${hino.numero} - ${hino.title}'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(
          hino.letra,
          style: const TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}