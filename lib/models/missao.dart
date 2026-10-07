import 'package:cloud_firestore/cloud_firestore.dart';

class Missao {
  final String? id;
  final String titulo;
  final int grau;
  final bool concluida;
  final String usuarioId;

  Missao({
    this.id,
    required this.titulo,
    required this.grau,
    required this.concluida,
    required this.usuarioId,
  });

  Map<String, dynamic> toMap() {
    return {
      'titulo': titulo,
      'grau': grau,
      'concluida': concluida,
      'usuarioId': usuarioId,
    };
  }

  factory Missao.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;
    return Missao(
      id: doc.id,
      titulo: data['titulo'] as String,
      grau: (data['grau'] as num).toInt(),
      concluida: data['concluida'] as bool,
      usuarioId: data['usuarioId'] as String,
    );
  }
}
