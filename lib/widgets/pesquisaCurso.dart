import 'package:flutter/material.dart';

class PesquisaCurso extends StatefulWidget {
  final List<String> cursos;
  final ValueChanged<String?> onCursoSelecionado;
  final VoidCallback onAbrirFiltro;

  const PesquisaCurso({
    Key? key,
    required this.cursos,
    required this.onCursoSelecionado,
    required this.onAbrirFiltro,
  }) : super(key: key);

  @override
  _PesquisaCursoState createState() => _PesquisaCursoState();
}

class _PesquisaCursoState extends State<PesquisaCurso> {
  final TextEditingController _controller = TextEditingController();
  bool _mostrarFiltro = false;
  OverlayEntry? _overlayEntry;
  List<String> _cursosFiltrados = [];

  @override
  void initState() {
    super.initState();
    _resetarCursos();
  }

  void _resetarCursos() {
    setState(() {
      _cursosFiltrados = widget.cursos;
    });
  }

  void _alternarFiltro() {
    if (_mostrarFiltro) {
      _fecharFiltro();
    } else {
      _abrirFiltro();
    }
  }

  void _abrirFiltro() {
    if (_mostrarFiltro) return;

    _overlayEntry = _criarOverlay();
    Overlay.of(context).insert(_overlayEntry!);

    setState(() {
      _mostrarFiltro = true;
    });
  }

  void _fecharFiltro() {
    if (!_mostrarFiltro) return;

    _overlayEntry?.remove();
    _overlayEntry = null;

    setState(() {
      _mostrarFiltro = false;
    });
  }

  void _filtrarCursos(String query) {
    setState(() {
      if (query.isEmpty) {
        _cursosFiltrados = [];
        _fecharFiltro();
      } else {
        _cursosFiltrados = widget.cursos
            .where((curso) => curso.toLowerCase().contains(query.toLowerCase()))
            .toList();
        _abrirFiltro();
      }
    });
  }

  OverlayEntry _criarOverlay() {
    return OverlayEntry(
      builder: (context) => Positioned(
        top: 140,
        left: 20,
        right: 20,
        child: Material(
          elevation: 8,
          borderRadius: BorderRadius.circular(8),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: _cursosFiltrados.isNotEmpty
                  ? _cursosFiltrados.map((curso) {
                      return ListTile(
                        title: Text(curso),
                        onTap: () {
                          String? selecionado = curso == "Todos" ? null : curso;
                          widget.onCursoSelecionado(selecionado);
                          _controller.text = selecionado ?? "";
                          _fecharFiltro();
                        },
                      );
                    }).toList()
                  : [
                      const Padding(
                        padding: EdgeInsets.all(10.0),
                        child: Text("Nenhum curso encontrado"),
                      )
                    ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: _controller,
                decoration: InputDecoration(
                  hintText: "Buscar curso...",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                ),
                onChanged: _filtrarCursos,
              ),
            ),
            IconButton(
              icon: const Icon(Icons.filter_list),
              onPressed: _alternarFiltro,
            ),
          ],
        ),
      ],
    );
  }
}
