import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../widgets/boxCurso.dart';
import '../widgets/pesquisaCurso.dart';
import '../widgets/headerEnsalamento.dart';

class Telainfra extends StatefulWidget {
  const Telainfra({Key? key}) : super(key: key);

  @override
  _TelaInfraState createState() => _TelaInfraState();
}

class _TelaInfraState extends State<Telainfra> {
  final List<Map<String, dynamic>> salas = [
    {
      "curso": "ESW",
      "periodo": "5°",
      "turma": "Único",
      "turno": "Matutino",
      "horarios": ["Lab 1", "16C"]
    },
    {
      "curso": "ESW",
      "periodo": "4°",
      "turma": "Único",
      "turno": "Noturno",
      "horarios": ["16C", "Lab 1"]
    },
    {
      "curso": "ESW",
      "periodo": "3°",
      "turma": "Único",
      "turno": "Noturno",
      "horarios": ["Lab 6", "Lab 6"]
    },
    {
      "curso": "ESW",
      "periodo": "2°",
      "turma": "B",
      "turno": "Matutino",
      "horarios": ["Lab 5", "14D"]
    },
    {
      "curso": "ESW",
      "periodo": "1°",
      "turma": "A",
      "turno": "Matutino",
      "horarios": ["Lab 4", "Lab 4"]
    },
    {
      "curso": "ADS",
      "periodo": "1°",
      "turma": "A",
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
      ...salas.map((sala) => sala["curso"] as String)
    ];

    List<Map<String, dynamic>> salasFiltradas = _cursoSelecionado == null ||
            _cursoSelecionado == "Todos"
        ? salas
        : salas.where((sala) => sala["curso"] == _cursoSelecionado).toList();

    return Scaffold(
      backgroundColor: Colors.black,
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
                  children: salasFiltradas.map((sala) {
                    String titulo = "${sala["curso"]} ${sala["periodo"]}";
                    if (sala["turma"] != "Único") {
                      titulo += " - ${sala["turma"]}";
                    }
                    return BoxCurso(
                      title: titulo,
                      horarios: List<String>.from(sala["horarios"]),
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
