import 'package:flutter/material.dart';

class HeaderEnsalamento extends StatelessWidget {
  final String nome;

  const HeaderEnsalamento({Key? key, required this.nome}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 90,
      decoration: BoxDecoration(color: const Color(0xffe7972a)),
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Text(
        'Bem Vindo, $nome!',
        style: const TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
