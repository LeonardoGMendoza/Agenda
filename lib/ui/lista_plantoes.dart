import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../services/FirestoreService.dart';
class ListaPlantoesPage extends StatelessWidget {
  final FirestoreService _firestoreService = FirestoreService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Plantões Agendados")),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestoreService.getPlantoes(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text("Nenhum plantão agendado."));
          }

          var plantoes = snapshot.data!.docs;

          return ListView.builder(
            itemCount: plantoes.length,
            itemBuilder: (context, index) {
              var plantao = plantoes[index];
              var dataFormatada = DateTime.parse(plantao['data']).toLocal();

              return Card(
                child: ListTile(
                  title: Text(plantao['nomeEnfermeira']),
                  subtitle: Text(
                    "Data: ${dataFormatada.day}/${dataFormatada.month}/${dataFormatada.year}\n"
                        "Horário: ${plantao['horarioInicio']} - ${plantao['horarioFim']}\n"
                        "Local: ${plantao['local']}",
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
