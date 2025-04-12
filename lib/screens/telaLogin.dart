import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../widgets/customTextField.dart';
import '../widgets/loginButton.dart';
import 'telaEnsalamento.dart';
import 'telaInfra.dart';

class TelaLogin extends StatefulWidget {
  const TelaLogin({super.key});

  @override
  _TelaLoginState createState() => _TelaLoginState();
}

class _TelaLoginState extends State<TelaLogin> {
  final TextEditingController nomeController = TextEditingController();
  final TextEditingController codigoController = TextEditingController();
  bool modoInfra = false;

  Future<void> _salvarNome(String nome) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('nomeUsuario', nome);
  }

  void _realizarLogin() {
    String nome = nomeController.text.trim();
    String codigo = codigoController.text.trim();

    if (nome.isNotEmpty && codigo.isNotEmpty) {
      _salvarNome(nome);
      if (modoInfra) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const Telainfra()),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const TelaEnsalamento()),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Preencha todos os campos para continuar!'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _alternarModoInfra() {
    setState(() {
      modoInfra = !modoInfra;
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
                Image.asset(
                  modoInfra ? 'images/logo_verde.png' : 'images/logo.png',
                  width: 350,
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
                      color: cardColor,
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                            child: CustomTextField(
                              label: 'Nome',
                              isNumeric: false,
                              controller: nomeController,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                            child: CustomTextField(
                              label: 'Código',
                              isNumeric: true,
                              controller: codigoController,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 16),
                            child: Button(
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
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 60),
              child: Image.network(
                'https://unicv.edu.br/wp-content/uploads/2020/12/logo-verde-280X100.png',
                width: 150,
                height: 50,
                fit: BoxFit.contain,
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Button(
                text: 'Infra',
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
