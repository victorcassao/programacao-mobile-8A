import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:programacao_mobile_8A/data/receitas.dart';

class ReceitaService {
  // Referência para a coleção de receitas no Firestore
  final CollectionReference _receitasCollection = 
      FirebaseFirestore.instance.collection('receitas');

  // CREATE - Adicionar nova receita
  Future<void> adicionarReceita(Receita receita) async {
    try {
      await _receitasCollection.add(receita.toJson());
    } catch (e) {
      throw Exception('Erro ao adicionar receita: $e');
    }
  }

  // READ - Obter todas as receitas em tempo real
  Stream<List<Receita>> obterTodasReceitas() {
    return _receitasCollection
        .orderBy('titulo')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id; // Adicionar o ID do documento
        return Receita.fromJson(data);
      }).toList();
    });
  }

  // READ - Obter apenas receitas favoritas
  Stream<List<Receita>> obterReceitasFavoritas() {
    return _receitasCollection
        .where('estaFavoritada', isEqualTo: true)
        .orderBy('titulo')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id;
        return Receita.fromJson(data);
      }).toList();
    });
  }

  // READ - Obter uma receita específica
  Future<Receita?> obterReceitaPorId(String id) async {
    try {
      DocumentSnapshot doc = await _receitasCollection.doc(id).get();
      
      if (doc.exists) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id;
        return Receita.fromJson(data);
      }
      return null;
    } catch (e) {
      throw Exception('Erro ao obter receita: $e');
    }
  }

  // UPDATE - Atualizar receita completa
  Future<void> atualizarReceita(String id, Receita receita) async {
    try {
      await _receitasCollection.doc(id).update(receita.toJson());
    } catch (e) {
      throw Exception('Erro ao atualizar receita: $e');
    }
  }

  // UPDATE - Alternar favorito
  Future<void> alternarFavorito(String id, bool novoValor) async {
    try {
      await _receitasCollection.doc(id).update({
        'estaFavoritada': novoValor,
      });
    } catch (e) {
      throw Exception('Erro ao alterar favorito: $e');
    }
  }

  // DELETE - Excluir receita
  Future<void> excluirReceita(String id) async {
    try {
      await _receitasCollection.doc(id).delete();
    } catch (e) {
      throw Exception('Erro ao excluir receita: $e');
    }
  }

  // UTILITY - Buscar receitas por categoria
  Stream<List<Receita>> buscarPorCategoria(String categoria) {
    return _receitasCollection
        .where('categorias', arrayContains: categoria)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id;
        return Receita.fromJson(data);
      }).toList();
    });
  }

  // UTILITY - Buscar receitas por tempo de preparo máximo
  Stream<List<Receita>> buscarPorTempoPreparo(int tempoMaximo) {
    return _receitasCollection
        .where('tempoPreparo', isLessThanOrEqualTo: tempoMaximo)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id;
        return Receita.fromJson(data);
      }).toList();
    });
  }
}