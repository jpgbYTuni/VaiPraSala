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
  String _tipoUsuario = "";
  int? _idUsuario;
  bool _mostrarFiltro = false;
  bool _carregando = true;

  @override
  void initState() {
    super.initState();
    _recuperarDadosUsuario();
  }

  Future<void> _recuperarDadosUsuario() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String nome = prefs.getString('nomeUsuario') ?? "Usuário";
    String tipo = prefs.getString('tipoUsuario') ?? "";
    setState(() {
      _nomeUsuario = nome;
      _tipoUsuario = tipo;
    });
    await _carregarSalas(nome);
  }

  Future<void> _carregarSalas(String nomeUsuario) async {
    try {
      final usuario = await supabase
          .from('Usuarios')
          .select('Codigo')
          .eq('Nome', nomeUsuario)
          .maybeSingle();

      if (usuario == null) {
        setState(() {
          salas = [];
          _carregando = false;
        });
        return;
      }

      final codigoUsuario = usuario['Codigo'];
      _idUsuario = codigoUsuario;

      final ensalamentos = await supabase.from('Ensalamento').select();
      final turmas = await supabase.from('Turmas').select();
      final cursos = await supabase.from('Cursos').select();
      final salasDb = await supabase.from('Salas').select();

      final List<Map<String, dynamic>> data = [];

      for (final ensalamento in ensalamentos) {
        if (_tipoUsuario == 'Professor') {
          final prof1 = ensalamento['codigo_usuario_prof1']?.toString();
          final prof2 = ensalamento['codigo_usuario_prof2']?.toString();
          final idUsuarioStr = _idUsuario?.toString();

          if (prof1 != idUsuarioStr && prof2 != idUsuarioStr) continue;
        }

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
          : salasFiltradas.isEmpty
              ? Column(
                  children: [
                    HeaderEnsalamento(nome: _nomeUsuario),
                    const SizedBox(height: 20),
                    Expanded(
                      child: Center(
                        child: Text(
                          "Sem Aula Hoje 😎",
                          style: TextStyle(
                            fontSize: 24,
                            color: Colors.grey,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ],
                )
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
                  ],
                ),
    );
  }
}
