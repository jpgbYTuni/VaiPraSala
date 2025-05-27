import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/login_button.dart';
import '../widgets/login_button_infra.dart';
import 'tela_ensalamento.dart';
import 'tela_infra.dart';

class TelaLogin extends StatefulWidget {
  const TelaLogin({super.key});

  @override
  _TelaLoginState createState() => _TelaLoginState();
}

class _TelaLoginState extends State<TelaLogin> {
  final TextEditingController nomeController = TextEditingController();
  final TextEditingController codigoController = TextEditingController();
  bool modoInfra = false;

  final supabase = Supabase.instance.client;

  Future<void> _salvarNome(String nome) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('nomeUsuario', nome);
  }

  Future<void> _realizarLogin() async {
    String nome = nomeController.text.trim();
    String codigoTexto = codigoController.text.trim();

    if (codigoTexto.isEmpty) {
      _mostrarErro("Preencha o código!");
      return;
    }

    if (modoInfra && nome.isEmpty) {
      _mostrarErro("Preencha o RA!");
      return;
    }

    int? codigo = int.tryParse(codigoTexto);
    if (codigo == null) {
      _mostrarErro("Código inválido.");
      return;
    }

    try {
      final response = await supabase
          .from('Usuarios')
          .select()
          .eq('Codigo', codigo)
          .maybeSingle();

      if (response == null) {
        _mostrarErro("Código não encontrado.");
        return;
      }

      final tipo = response['Tipo'];
      final nomeBanco = response['Nome'];

      if (modoInfra) {
        if (tipo == 'Infra') {
          final raBanco = response['RA'] ?? '';

          String raDigitado = nome.replaceAll('-', '').toLowerCase();
          String raSalvo = raBanco.toString().replaceAll('-', '').toLowerCase();

          if (raDigitado != raSalvo) {
            _mostrarErro("RA inválido para esse código.");
            return;
          }

          await _salvarNome(nomeBanco);
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const Telainfra()),
          );
        } else {
          _mostrarErro("Código inválido para login Infra.");
        }
      } else {
        if (tipo == 'Aluno') {
          final nomeFinal = nome.isNotEmpty ? nome : nomeBanco;
          await _salvarNome(nomeFinal);
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const TelaEnsalamento()),
          );
        } else if (tipo == 'Professor') {
          await _salvarNome(nomeBanco);
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const TelaEnsalamento()),
          );
        } else {
          _mostrarErro("Código não permitido nesta tela.");
        }
      }
    } catch (e) {
      _mostrarErro("Erro ao acessar o banco: ${e.toString()}");
    }
  }

  void _mostrarErro(String mensagem) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(mensagem),
        backgroundColor: Colors.red,
      ),
    );
  }

  void _alternarModoInfra() {
    setState(() {
      modoInfra = !modoInfra;
      nomeController.clear();
      codigoController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    Color cardColor =
        modoInfra ? const Color(0xff51703C) : const Color(0xffe7972a);
    Color buttonColor = Colors.white;
    Color fundoCor =
        modoInfra ? const Color.fromARGB(255, 199, 199, 199) : Colors.white;
    Color sombraLogin =
        modoInfra ? const Color.fromARGB(255, 114, 114, 114) : Colors.grey;
    Color botaoInfra =
        modoInfra ? const Color(0xffe7972a) : const Color(0xff51703C);

    return Scaffold(
      backgroundColor: fundoCor,
      body: Stack(
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 100),
                  child: Image.asset(
                    modoInfra ? 'images/logo_verde.png' : 'images/logo.png',
                    key: ValueKey<bool>(modoInfra),
                    width: 350,
                  ),
                ),
                Text(
                  modoInfra ? 'INFRA' : ' ',
                  style: TextStyle(
                      color: modoInfra
                          ? const Color(0xff51703C)
                          : const Color(0xffe7972a),
                      fontSize: 25,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 40),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: Container(
                    constraints: const BoxConstraints(maxWidth: 500),
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          offset: const Offset(20, 20),
                          color: sombraLogin,
                          blurRadius: 40.0,
                          spreadRadius: 0.005,
                        ),
                      ],
                    ),
                    child: Card(
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 400),
                        curve: Curves.easeInOut,
                        decoration: BoxDecoration(
                          color: cardColor,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                              child: CustomTextField(
                                label: modoInfra ? 'RA' : 'Nome (Opcional)',
                                isNumeric: false,
                                controller: nomeController,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                              child: CustomTextField(
                                label: modoInfra
                                    ? 'Código de Acesso'
                                    : 'Código de Acesso',
                                isNumeric: true,
                                controller: codigoController,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 16),
                              child: ButtonLogin(
                                text: 'Login',
                                buttonWidth: 100,
                                buttonHeight: 30,
                                buttonColor: buttonColor,
                                onPressed: _realizarLogin,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 60),
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 500),
                child: Image.network(
                  'https://unicv.edu.br/wp-content/uploads/2020/12/logo-verde-280X100.png',
                  width: 150,
                  height: 50,
                  fit: BoxFit.contain,
                  key: ValueKey<bool>(modoInfra),
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: ButtonInfra(
                text: modoInfra ? 'Voltar' : 'Infra',
                buttonWidth: 100,
                buttonHeight: 30,
                buttonColor: botaoInfra,
                onPressed: _alternarModoInfra,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
