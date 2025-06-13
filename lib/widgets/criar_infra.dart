import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../widgets/button.dart';

class CardCriarEditarSala extends StatefulWidget {
  final Map<String, dynamic>? salaExistente;

  const CardCriarEditarSala({super.key, this.salaExistente});

  @override
  State<CardCriarEditarSala> createState() => _CardCriarEditarSalaState();
}

class _CardCriarEditarSalaState extends State<CardCriarEditarSala> {
  final supabase = Supabase.instance.client;
  final _formKey = GlobalKey<FormState>();

  final _blocoController = TextEditingController();
  final _numeroController = TextEditingController();
  final _cadeirasController = TextEditingController();
  final _pcdController = TextEditingController();
  final _computadoresController = TextEditingController();

  bool tv = false, ar = false, projetor = false;
  bool defeitoTv = false,
      defeitoAr = false,
      defeitoProjetor = false,
      manutencao = false;

  @override
  void initState() {
    super.initState();
    final s = widget.salaExistente;
    if (s != null) {
      _blocoController.text = s['Bloco'] ?? '';
      _numeroController.text = s['Numero'].toString();
      _cadeirasController.text = s['Qt_cadeiras'].toString();
      _pcdController.text = (s['Qt_cadeiras_pcd'] ?? '').toString();
      _computadoresController.text = (s['Qt_computadores'] ?? '').toString();
      tv = s['Tv'] ?? false;
      ar = s['Ar'] ?? false;
      projetor = s['Projetor'] ?? false;
      defeitoTv = s['Defeito_tv'] ?? false;
      defeitoAr = s['Defeito_ar'] ?? false;
      defeitoProjetor = s['Defeito_projetor'] ?? false;
      manutencao = s['Defeito_manutencao'] ?? false;
    }
  }

  Future<void> _salvarSala() async {
    if (!_formKey.currentState!.validate()) return;

    final data = {
      'Bloco': _blocoController.text.toUpperCase(),
      'Numero': int.parse(_numeroController.text),
      'Qt_cadeiras': int.parse(_cadeirasController.text),
      'Qt_cadeiras_pcd': int.tryParse(_pcdController.text),
      'Qt_computadores': int.tryParse(_computadoresController.text),
      'Tv': tv,
      'Ar': ar,
      'Projetor': projetor,
      'Defeito_tv': defeitoTv,
      'Defeito_ar': defeitoAr,
      'Defeito_projetor': defeitoProjetor,
      'Defeito_manutencao': manutencao,
    };

    if (widget.salaExistente != null) {
      await supabase.from('Salas').update(data).match({
        'Bloco': widget.salaExistente!['Bloco'],
        'Numero': widget.salaExistente!['Numero'],
      });
    } else {
      await supabase.from('Salas').insert(data);
    }

    if (context.mounted) Navigator.pop(context);
  }

  Widget _buildSwitch(String label, bool value, Function(bool) onChanged) {
    return SwitchListTile(
      title: Text(label,
          style: const TextStyle(color: Colors.white, fontSize: 16)),
      value: value,
      onChanged: onChanged,
      contentPadding: EdgeInsets.zero,
      activeColor: Colors.white,
    );
  }

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: Colors.white),
      enabledBorder: const UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.white54),
      ),
      focusedBorder: const UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.white),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: const Color(0xff7ecd73),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                widget.salaExistente != null ? 'Editar Sala' : 'Nova Sala',
                style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _blocoController,
                decoration: _inputDecoration('Bloco'),
                style: const TextStyle(color: Colors.white),
                validator: (v) => v!.isEmpty ? 'Informe o bloco' : null,
              ),
              TextFormField(
                controller: _numeroController,
                decoration: _inputDecoration('Número'),
                style: const TextStyle(color: Colors.white),
                keyboardType: TextInputType.number,
                validator: (v) => v!.isEmpty ? 'Informe o número' : null,
              ),
              TextFormField(
                controller: _cadeirasController,
                decoration: _inputDecoration('Qt. Cadeiras'),
                style: const TextStyle(color: Colors.white),
                keyboardType: TextInputType.number,
                validator: (v) => v!.isEmpty ? 'Informe a quantidade' : null,
              ),
              TextFormField(
                controller: _pcdController,
                decoration: _inputDecoration('Qt. Cadeiras PCD'),
                style: const TextStyle(color: Colors.white),
                keyboardType: TextInputType.number,
              ),
              TextFormField(
                controller: _computadoresController,
                decoration: _inputDecoration('Qt. Computadores'),
                style: const TextStyle(color: Colors.white),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 20),
              const Text('Equipamentos',
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold)),
              _buildSwitch('TV', tv, (v) => setState(() => tv = v)),
              _buildSwitch(
                  'Ar-condicionado', ar, (v) => setState(() => ar = v)),
              _buildSwitch(
                  'Projetor', projetor, (v) => setState(() => projetor = v)),
              const Divider(color: Colors.white70),
              const Text('Defeitos',
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold)),
              _buildSwitch('Defeito na TV', defeitoTv,
                  (v) => setState(() => defeitoTv = v)),
              _buildSwitch('Defeito no Ar', defeitoAr,
                  (v) => setState(() => defeitoAr = v)),
              _buildSwitch('Defeito no Projetor', defeitoProjetor,
                  (v) => setState(() => defeitoProjetor = v)),
              _buildSwitch('Em manutenção', manutencao,
                  (v) => setState(() => manutencao = v)),
              const SizedBox(height: 20),
              Button(
                text: widget.salaExistente != null
                    ? 'Salvar Alterações'
                    : 'Criar Sala',
                onPressed: _salvarSala,
                buttonWidth: 140,
                buttonHeight: 45,
                buttonColor: Colors.white,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
