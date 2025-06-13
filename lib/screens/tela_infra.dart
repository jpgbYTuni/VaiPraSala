import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../widgets/header_ensalamento.dart';
import '../widgets/box_infra.dart';
import '../widgets/criar_infra.dart';

class Telainfra extends StatefulWidget {
  const Telainfra({super.key});

  @override
  _TelaInfraState createState() => _TelaInfraState();
}

class _TelaInfraState extends State<Telainfra> {
  String _nomeUsuario = "Carregando...";
  List<Map<String, dynamic>> salas = [];

  @override
  void initState() {
    super.initState();
    _recuperarNome();
    _fetchSalas();
  }

  Future<void> _recuperarNome() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _nomeUsuario = prefs.getString('nomeUsuario') ?? "Usuário";
    });
  }

  Future<void> _fetchSalas() async {
    try {
      final response = await Supabase.instance.client
          .from('Salas')
          .select()
          .order('Bloco')
          .order('Numero');

      setState(() {
        salas = List<Map<String, dynamic>>.from(response);
      });
    } catch (e) {
      debugPrint('Erro ao buscar salas: $e');
    }
  }

  Future<void> _abrirCriarSala() async {
    await showDialog(
      context: context,
      builder: (context) => CardCriarEditarSala(),
    );
    _fetchSalas();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 199, 199, 199),
      floatingActionButton: FloatingActionButton(
        onPressed: _abrirCriarSala,
        backgroundColor: Color(0xffe7972a),
        foregroundColor: Colors.white,
        child: const Icon(Icons.add),
      ),
      body: Stack(
        children: [
          Column(
            children: [
              HeaderEnsalamento(nome: _nomeUsuario),
              const SizedBox(height: 10),
              Expanded(
                child: ListView(
                  children: salas
                      .where((sala) =>
                          sala['Bloco'].toString().toUpperCase() != 'LAB')
                      .map((sala) => BoxInfra(
                            key: Key('${sala['Bloco']}${sala['Numero']}'),
                            sala: sala,
                          ))
                      .toList(),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
