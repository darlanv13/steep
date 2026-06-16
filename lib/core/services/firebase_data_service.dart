import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'data_service.dart';

class FirebaseDataService implements DataService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instanceFor(app: Firebase.app(), databaseId: 'steepdb');

  @override
  Future<List<Map<String, dynamic>>> getActionPlans(String shift, String fleet, String period) async {
    try {
      final snapshot = await _firestore
          .collection('action_plans')
          .where('shift', isEqualTo: shift)
          .where('fleet', isEqualTo: fleet)
          .get();

      return snapshot.docs.map((doc) => doc.data()).toList();
    } on FirebaseException catch (e) {
      if (e.code == 'failed-precondition') {
        debugPrint("====== AVISO DE ÍNDICE DO FIREBASE ======");
        debugPrint("O índice do Firestore não existe para esta consulta composta.");
        debugPrint("Por favor, acesse o link abaixo para criar o índice automaticamente:");
        debugPrint(e.message);
        debugPrint("=========================================");
        throw Exception("Índice do Firestore ausente. Verifique o console para obter o link de criação.");
      }
      rethrow;
    }
  }

  @override
  Future<void> addActionPlan(Map<String, dynamic> plan) async {
    // Ao inserir em uma coleção que não existe, o Firestore a cria automaticamente
    await _firestore.collection('action_plans').add(plan);
  }
}
