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

  @override
  Future<List<Map<String, dynamic>>> getChecklists(String shift, String fleet) async {
    try {
      final snapshot = await _firestore.collection('checklists').where('shift', isEqualTo: shift).where('fleet', isEqualTo: fleet).get();
      return snapshot.docs.map((doc) => doc.data()).toList();
    } catch (e) {
      return [];
    }
  }

  @override
  Future<List<Map<String, dynamic>>> getComplianceData(String fleet) async {
    try {
      final snapshot = await _firestore.collection('compliance_data').where('fleet', isEqualTo: fleet).get();
      return snapshot.docs.map((doc) => doc.data()).toList();
    } catch (e) {
      return [];
    }
  }

  @override
  Future<List<Map<String, dynamic>>> getGeofences() async {
    try {
      final snapshot = await _firestore.collection('geofences').get();
      return snapshot.docs.map((doc) => doc.data()).toList();
    } catch (e) {
      return [];
    }
  }

  @override
  Future<List<Map<String, dynamic>>> getIrisEvents() async {
    try {
      final snapshot = await _firestore.collection('iris_events').get();
      return snapshot.docs.map((doc) => doc.data()).toList();
    } catch (e) {
      return [];
    }
  }
}
