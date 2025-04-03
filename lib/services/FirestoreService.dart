import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Método para obter plantões agendados
  Stream<QuerySnapshot> getPlantoes() {
    return _db.collection('plantoes').snapshots();
  }

  // Adicionar um novo plantão
  Future<void> addPlantao(Map<String, dynamic> plantaoData) async {
    await _db.collection('plantoes').add(plantaoData);
  }
}
