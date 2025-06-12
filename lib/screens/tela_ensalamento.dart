import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../widgets/box_curso.dart';
import '../widgets/pesquisa_curso.dart';
import '../widgets/header_ensalamento.dart';

class TelaEnsalamento extends StatefulWidget {
  const TelaEnsalamento({super.key});

  @override
  _TelaEnsalamentoState createState() => _TelaEnsalamentoState();
}

class _TelaEnsalamentoState extends State<TelaEnsalamento> {
  final supabase = Supabase.instance.client;
  List<Map<String, dynamic>> salas = [];
  String _cursoSelecionado = "Todos";
  String _nomeUsuario = "Carregando...";
  bool _mostrarFiltro = false;
  bool _carregando = true;

  @override
  void initState() {
    super.initState();
    _recuperarNome();
    _carregarSalas();
  }

  Future<void> _recuperarNome() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _nomeUsuario = prefs.getString('nomeUsuario') ?? "Usuário";
    });
  }

  Future<void> _carregarSalas() async {
    try {
      final ensalamentos = await supabase.from('Ensalamento').select();
      final turmas = await supabase.from('Turmas').select();
      final cursos = await supabase.from('Cursos').select();
      final salasDb = await supabase.from('Salas').select();

      final List<Map<String, dynamic>> data = [];

      for (final ensalamento in ensalamentos) {
        final turma1 = turmas.firstWhere(
          (t) =>
              t['ID_turma'].toString() == ensalamento['id_turma1'].toString(),
          orElse: () => {},
        );

        final turma2 = turmas.firstWhere(
          (t) =>
              t['ID_turma'].toString() == ensalamento['id_turma2'].toString(),
          orElse: () => {},
        );

        final curso1 = turma1.isNotEmpty
            ? cursos.firstWhere(
                (c) =>
                    c['ID_curso'].toString() == turma1['id_curso'].toString(),
                orElse: () => {},
              )
            : {};

        final curso2 = turma2.isNotEmpty
            ? cursos.firstWhere(
                (c) =>
                    c['ID_curso'].toString() == turma2['id_curso'].toString(),
                orElse: () => {},
              )
            : {};

        final sala = salasDb.firstWhere(
          (s) => s['ID_sala'].toString() == ensalamento['id_sala'].toString(),
          orElse: () => {},
        );

        data.add({
          "sala": sala.isNotEmpty
              ? "Sala ${sala['Numero']}${sala['Bloco'].toString().toUpperCase()}"
              : "Sala desconhecida",
          "turmas": [
            if (turma1.isNotEmpty && curso1.isNotEmpty)
              "${turma1['Semestre']}º${curso1['Sigla']}",
            if (turma2.isNotEmpty && curso2.isNotEmpty)
              "${turma2['Semestre']}º${curso2['Sigla']}",
          ],
        });
      }

      setState(() {
        salas = data;
        _carregando = false;
      });
    } catch (e) {
      print("Erro ao carregar dados: $e");
      setState(() {
        _carregando = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    List<String> cursosDisponiveis = [
      "Todos",
      ...{
        for (var sala in salas)
          ...sala["turmas"].map((t) => (t as String).split(" - ")[0])
      }
    ];

    List<Map<String, dynamic>> salasFiltradas = _cursoSelecionado == "Todos"
        ? salas
        : salas
            .where((sala) => sala["turmas"]
                .any((t) => (t as String).startsWith(_cursoSelecionado)))
            .toList();

    return Scaffold(
      body: _carregando
          ? const Center(child: CircularProgressIndicator())
          : Stack(
              children: [
                Column(
                  children: [
                    HeaderEnsalamento(nome: _nomeUsuario),
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: PesquisaCurso(
                        cursos: cursosDisponiveis.toSet().toList(),
                        onCursoSelecionado: (curso) {
                          setState(() {
                            _cursoSelecionado = curso ?? "Todos";
                          });
                        },
                        onAbrirFiltro: () {
                          setState(() {
                            _mostrarFiltro = !_mostrarFiltro;
                          });
                        },
                      ),
                    ),
                    const SizedBox(height: 10),
                    Expanded(
                      child: ListView(
                        children: salasFiltradas.map((sala) {
                          return BoxCurso(
                            title: sala["sala"],
                            cursos: List<String>.from(sala["turmas"]),
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ),
                if (_mostrarFiltro)
                  Positioned.fill(
                    top: 130,
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _mostrarFiltro = false;
                        });
                      },
                      child: Container(
                        color: Colors.black54,
                        child: Center(
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            width: 300,
                            height: 300,
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: ListView(
                              children: cursosDisponiveis
                                  .toSet()
                                  .toList()
                                  .map((curso) {
                                return ListTile(
                                  title: Text(curso),
                                  onTap: () {
                                    setState(() {
                                      _cursoSelecionado = curso;
                                      _mostrarFiltro = false;
                                    });
                                  },
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
    );
  }
}
