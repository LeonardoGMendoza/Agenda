import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:agenda/ui/calendario_page.dart';
import 'package:agenda/ui/plantao_page.dart'; // Importa a nova tela

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    _testFirestore();
  }

  void _testFirestore() async {
    try {
      await FirebaseFirestore.instance.collection("test").add({
        "message": "Firebase Web funcionando!",
        "timestamp": FieldValue.serverTimestamp(),
      });
      print("Firestore conectado com sucesso!");
    } catch (e) {
      print("Erro ao conectar com Firestore: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Home")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildButton(
              text: "Abrir Calendário",
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CalendarioPage()),
              ),
            ),
            SizedBox(height: 20),
            _buildButton(
              text: "Ver Plantões",
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => PlantaoPage()),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildButton({required String text, required VoidCallback onPressed}) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
      child: Text(text),
    );
  }
}
