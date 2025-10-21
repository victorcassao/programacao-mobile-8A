import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  
  final CollectionReference _receitasCollection =
      FirebaseFirestore.instance.collection('receitas');

  
  Future<void> adicionarReceita(Map<String, dynamic> receita) async {
    try {
      await _receitasCollection.add({
        ...receita,
      });
    } catch (e) {
      throw Exception('Erro ao adicionar receita: $e');
    }
  }
}
