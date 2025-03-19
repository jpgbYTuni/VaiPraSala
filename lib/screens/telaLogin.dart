import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../widgets/customTextField.dart';
import '../widgets/loginButton.dart';
import 'telaEnsalamento.dart';

class TelaLogin extends StatefulWidget {
  const TelaLogin({super.key});

  @override
  _TelaLoginState createState() => _TelaLoginState();
}

class _TelaLoginState extends State<TelaLogin> {
  final TextEditingController nomeController = TextEditingController();
  final TextEditingController codigoController = TextEditingController();

  Future<void> _salvarNome(String nome) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('nomeUsuario', nome);
  }

  void _login() {
    String nome = nomeController.text.trim();
    String codigo = codigoController.text.trim();

    if (nome.isNotEmpty && codigo.isNotEmpty) {
      _salvarNome(nome);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const TelaEnsalamento()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Preencha todos os campos para continuar!'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'images/logo.png',
                  width: 350,
                  fit: BoxFit.contain,
                ),
                const SizedBox(height: 40),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: Container(
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          offset: const Offset(20, 20),
                          color: Colors.grey,
                          blurRadius: 40.0,
                          spreadRadius: 0.005,
                        ),
                      ],
                    ),
                    child: Card(
                      color: const Color(0xffe7972a),
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
                              buttonColor: Colors.white,
                              onPressed: _login,
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
              padding: const EdgeInsets.only(bottom: 20),
              child: Image.network(
                'https://unicv.edu.br/wp-content/uploads/2020/12/logo-verde-280X100.png',
                width: 150,
                height: 50,
                fit: BoxFit.contain,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
