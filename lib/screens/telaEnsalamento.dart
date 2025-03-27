import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../widgets/boxCurso.dart';
import '../widgets/pesquisaCurso.dart';
import '../widgets/headerEnsalamento.dart';

class TelaEnsalamento extends StatefulWidget {
  const TelaEnsalamento({Key? key}) : super(key: key);

  @override
  _TelaEnsalamentoState createState() => _TelaEnsalamentoState();
}

class _TelaEnsalamentoState extends State<TelaEnsalamento> {
  final List<Map<String, dynamic>> salas = [
    {
      "sala": "ESW 5°",
      "turno": "Matutino",
      "horarios": ["Lab 1", "16C"]
    },
    {
      "sala": "ESW 4°",
      "turno": "Noturno",
      "horarios": ["16C", "Lab 1"]
    },
    {
      "sala": "ESW 3°",
      "turno": "Noturno",
      "horarios": ["Lab 6", "Lab 6"]
    },
    {
      "sala": "ESW 2° B",
      "turno": "Matutino",
      "horarios": ["Lab 5", "14D"]
    },
    {
      "sala": "ESW 1° A",
      "turno": "Matutino",
      "horarios": ["Lab 4", "Lab 4"]
    },
    {
      "sala": "ADS 1° A",
      "turno": "Noturno",
      "horarios": ["Lab 4", "Lab 4"]
    },
  ];

  String? _cursoSelecionado;
  String _nomeUsuario = "Carregando...";
  bool _mostrarFiltro = false;

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
    List<String> cursosDisponiveis = [
      "Todos",
      ...salas.map((sala) => sala["sala"] as String)
    ];

    List<Map<String, dynamic>> salasFiltradas =
        _cursoSelecionado == null || _cursoSelecionado == "Todos"
            ? salas
            : salas.where((sala) => sala["sala"] == _cursoSelecionado).toList();

    return Scaffold(
      body: Stack(
        children: [
          Column(
            children: [
              HeaderEnsalamento(nome: _nomeUsuario),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: PesquisaCurso(
                  cursos: cursosDisponiveis,
                  onCursoSelecionado: (curso) {
                    setState(() {
                      _cursoSelecionado = curso == "Todos" ? null : curso;
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
                  children: salasFiltradas
                      .map((sala) => BoxCurso(
                            title: sala["sala"],
                            horarios: List<String>.from(sala["horarios"]),
                          ))
                      .toList(),
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
                  color: Colors.black,
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
                        children: cursosDisponiveis.map((curso) {
                          return ListTile(
                            title: Text(curso),
                            onTap: () {
                              setState(() {
                                _cursoSelecionado =
                                    curso == "Todos" ? null : curso;
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
