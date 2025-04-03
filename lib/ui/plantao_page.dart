import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Importação do FirebaseAuth

class PlantaoPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Plantões Agendados"),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            // Voltar para a tela de calendário corretamente
            Navigator.pushNamed(context, "/calendar");
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: () async {
              await FirebaseAuth.instance.signOut(); // Faz logout do usuário
              Navigator.pushNamedAndRemoveUntil(context, "/login", (route) => false);
            },
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('plantoes').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text("Nenhum plantão encontrado"));
          }

          var plantaoDocs = snapshot.data!.docs;

          return ListView.builder(
            itemCount: plantaoDocs.length,
            itemBuilder: (context, index) {
              var plantao = plantaoDocs[index];
              var dataString = plantao['data'];

              // Verifica se a data está no formato correto e converte
              String formattedDate = "Data inválida";
              try {
                DateTime date = DateTime.parse(dataString);
                formattedDate = DateFormat('dd/MM/yyyy HH:mm').format(date);
              } catch (e) {
                print("Erro ao formatar data: $e");
              }

              return ListTile(
                title: Text("Plantão"),
                subtitle: Text("Data: $formattedDate"),
                trailing: IconButton(
                  icon: Icon(Icons.delete, color: Colors.red),
                  onPressed: () async {
                    await FirebaseFirestore.instance
                        .collection('plantoes')
                        .doc(plantao.id)
                        .delete();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Plantão removido")),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
