import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../models/missao.dart';

class MissaoService {
  final CollectionReference<Map<String, dynamic>> _colecao =
      FirebaseFirestore.instance.collection('missoes');

  Stream<List<Missao>> listarMissoes() {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    return _colecao.where('usuarioId', isEqualTo: uid).snapshots().map(
          (snapshot) => snapshot.docs.map((d) => Missao.fromDoc(d)).toList(),
        );
  }

  Future<void> cadastrar(String titulo, int grau) {
    final missao = Missao(
      titulo: titulo,
      grau: grau,
      concluida: false,
      usuarioId: FirebaseAuth.instance.currentUser!.uid,
    );
    return _colecao.add(missao.toMap());
  }

  Future<void> atualizarConcluida(String id, bool concluida) {
    return _colecao.doc(id).update({'concluida': concluida});
  }

  Future<void> excluir(String id) {
    return _colecao.doc(id).delete();
  }
}
