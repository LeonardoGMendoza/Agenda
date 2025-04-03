import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'signup_page.dart';
import 'Home_Page.dart';
import 'package:agenda/ui/calendario_page.dart'; // Certifique-se de que este caminho está correto
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  late SharedPreferences _sharedPreferences;

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    showDialog(
      context: context,
      barrierDismissible: false, // Impede o usuário de fechar o alerta
      builder: (context) => Center(
        child: CircularProgressIndicator(),
      ),
    );

    setState(() {
      _isLoading = true;
    });

    try {
      var result = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      _sharedPreferences = await SharedPreferences.getInstance();
      _sharedPreferences.setString("Token", result.user!.uid);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Login realizado com sucesso!")),
      );

      Navigator.of(context).pop(); // Fecha o AlertDialog
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => CalendarioPage()), // Redireciona para a tela do calendário
      );
    } on FirebaseAuthException catch (e) {
      Navigator.of(context).pop(); // Fecha o AlertDialog ao capturar um erro

      String errorMessage = "Erro ao fazer login.";
      if (e.code == 'user-not-found') {
        errorMessage = "Usuário não encontrado.";
      } else if (e.code == 'wrong-password') {
        errorMessage = "Senha incorreta.";
      } else if (e.code == 'invalid-email') {
        errorMessage = "E-mail inválido.";
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMessage)),
      );
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 50),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('./assets/images/logo.png',
            height: 120,
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText: "E-mail",
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.person),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "O e-mail é obrigatório.";
                    }
                    return null;
                  },
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: "Senha",
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.lock),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "A senha é obrigatória.";
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                _isLoading
                    ? CircularProgressIndicator()
                    : ElevatedButton(
                  onPressed: _login,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    minimumSize: Size(double.infinity, 50),
                  ),
                  child: Text(
                    'Entrar',
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
                SizedBox(height: 10),
                TextButton(
                  onPressed: () {
                    // Adicione a lógica para recuperação de senha aqui
                  },
                  child: Text(
                    'Esqueceu a senha?',
                    style: TextStyle(color: Colors.blue),
                  ),
                ),
                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SignUpPage()),
                    );
                  },
                  child: Text("Criar nova conta"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
