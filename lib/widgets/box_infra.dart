import 'package:flutter/material.dart';

class BoxInfra extends StatefulWidget {
  final Map<String, dynamic> sala;

  const BoxInfra({super.key, required this.sala});

  @override
  State<BoxInfra> createState() => _BoxInfraState();
}

class _BoxInfraState extends State<BoxInfra>
    with SingleTickerProviderStateMixin {
  bool _isExpanded = false;

  String _formatNome() {
    final bloco = (widget.sala['Bloco'] ?? '').toString().toUpperCase();
    final numero = widget.sala['Numero'].toString();
    return bloco == 'LAB' ? '$numero$bloco' : '$bloco$numero';
  }

  Widget _buildStyledRow(String label, dynamic value,
      {bool isBoolean = false}) {
    Widget displayValue = isBoolean
        ? Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: value == true ? Colors.green[700] : Colors.redAccent[700],
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: Colors.white,
                width: 1,
              ),
            ),
            child: Text(
              value == true ? 'Sim' : 'Não',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          )
        : Text(
            value.toString(),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          );

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
          const SizedBox(width: 8),
          displayValue,
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final nomeSala = _formatNome();

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
      decoration: BoxDecoration(
        color: const Color(0xff7ecd73),
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            offset: Offset(1, 2),
            blurRadius: 4,
          )
        ],
      ),
      child: Column(
        children: [
          InkWell(
            onTap: () {
              setState(() => _isExpanded = !_isExpanded);
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    nomeSala,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  AnimatedRotation(
                    turns: _isExpanded ? 0.5 : 0.0,
                    duration: const Duration(milliseconds: 200),
                    child: const Icon(
                      Icons.expand_more,
                      size: 32,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
          AnimatedSize(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            child: ConstrainedBox(
              constraints: _isExpanded
                  ? const BoxConstraints()
                  : const BoxConstraints(maxHeight: 0),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                child: Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildStyledRow(
                                  'Cadeiras', widget.sala['Qt_cadeira']),
                              _buildStyledRow('Cadeiras PCD',
                                  widget.sala['Qt_cadeira_pcd'] ?? 0),
                              const Divider(color: Colors.white54),
                              _buildStyledRow('Tem TV:', widget.sala['Tv'],
                                  isBoolean: true),
                              _buildStyledRow(
                                  'Tem Projetor:', widget.sala['Projetor'],
                                  isBoolean: true),
                              _buildStyledRow('Tem Ar:', widget.sala['Ar'],
                                  isBoolean: true),
                            ],
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 12),
                          height: 80,
                          width: 1,
                          color: Colors.white54,
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildStyledRow(
                                  'Mesas', widget.sala['Qt_mesa'] ?? 0),
                              _buildStyledRow('Computadores',
                                  widget.sala['Qt_computador'] ?? 0),
                              const Divider(color: Colors.white54),
                              _buildStyledRow(
                                  'Com defeito:', widget.sala['Defeito_tv'],
                                  isBoolean: true),
                              _buildStyledRow('Com defeito:',
                                  widget.sala['Defeito_projetor'],
                                  isBoolean: true),
                              _buildStyledRow(
                                  'Com defeito:', widget.sala['Defeito_ar'],
                                  isBoolean: true),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    _buildStyledRow(
                        'Em manutenção', widget.sala['Defeito_manutencao'],
                        isBoolean: true),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
