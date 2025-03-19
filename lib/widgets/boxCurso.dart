import 'package:flutter/material.dart';

class BoxCurso extends StatefulWidget {
  final String title;
  final List<String> horarios;

  const BoxCurso({
    Key? key,
    required this.title,
    required this.horarios,
  }) : super(key: key);

  @override
  _BoxCursoState createState() => _BoxCursoState();
}

class _BoxCursoState extends State<BoxCurso> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 16),
      decoration: BoxDecoration(
        color: Color(0xff7ecd73),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          InkWell(
            onTap: () {
              setState(() {
                _isExpanded = !_isExpanded;
              });
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  Icon(
                    _isExpanded
                        ? Icons.expand_more_outlined
                        : Icons.chevron_right_outlined,
                    size: 40,
                    color: Color(0xff51703C),
                  ),
                ],
              ),
            ),
          ),
          if (_isExpanded)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              child: Column(
                children: List.generate(widget.horarios.length, (index) {
                  return Column(
                    children: [
                      Text(
                        "${index + 1}° Horário",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Center(
                          child: Text(
                            widget.horarios[index],
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                    ],
                  );
                }),
              ),
            ),
        ],
      ),
    );
  }
}
