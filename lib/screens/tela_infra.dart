import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../widgets/header_ensalamento.dart';

class Telainfra extends StatefulWidget {
  const Telainfra({super.key});

  @override
  _TelaInfraState createState() => _TelaInfraState();
}

class _TelaInfraState extends State<Telainfra> {
  String _nomeUsuario = "Carregando...";

  @override
  void initState() {
    super.initState();
    _recuperarNome();
  }

  Future<void> _recuperarNome() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _nomeUsuario = prefs.getString('nomeUsuario') ?? "Usuário";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color.fromARGB(255, 199, 199, 199),
        body: Stack(
          children: [
            Column(
              children: [
                HeaderEnsalamento(nome: _nomeUsuario),
                const SizedBox(height: 10),
                Padding(
                  padding: EdgeInsetsGeometry.all(2),
                  child: Text('infra'),
                )
              ],
            ),
          ],
        ));
  }
}
