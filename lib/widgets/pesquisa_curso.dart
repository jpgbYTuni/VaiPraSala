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
  final FocusNode _focusNode = FocusNode();
  OverlayEntry? _overlayEntry;
  List<String> _cursosFiltrados = [];

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      if (_focusNode.hasFocus) {
        _controller.clear();
        _cursosFiltrados = [];
        _fecharFiltro();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _abrirFiltroComTodosCursos() {
    _fecharFiltro();
    setState(() {
      _cursosFiltrados = widget.cursos;
    });
    _abrirFiltro();
  }

  void _filtrarCursos(String query) {
    if (query.isEmpty) {
      _fecharFiltro();
      return;
    }

    setState(() {
      _cursosFiltrados = widget.cursos
          .where((curso) => curso.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });

    _abrirFiltro();
  }

  void _abrirFiltro() {
    if (_overlayEntry != null) return;

    _overlayEntry = _criarOverlay();
    Overlay.of(context).insert(_overlayEntry!);
  }

  void _fecharFiltro() {
    _overlayEntry?.remove();
    _overlayEntry = null;
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
            child: _cursosFiltrados.isNotEmpty
                ? Column(
                    mainAxisSize: MainAxisSize.min,
                    children: _cursosFiltrados.map((curso) {
                      return ListTile(
                        title: Text(curso),
                        onTap: () {
                          widget.onCursoSelecionado(
                              curso == "Todos" ? null : curso);
                          _controller.text = curso;
                          _fecharFiltro();
                        },
                      );
                    }).toList(),
                  )
                : const Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Text("Nenhum curso encontrado"),
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
                focusNode: _focusNode,
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
              onPressed: _abrirFiltroComTodosCursos,
            ),
          ],
        ),
      ],
    );
  }
}
