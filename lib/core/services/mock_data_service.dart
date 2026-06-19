import 'data_service.dart';

class MockDataService implements DataService {
  final List<Map<String, dynamic>> _plans = [
    {
      'id': 'plan_1',
      'title': 'Troca de Sensores ABS (Caminhão Fora de Estrada)',
      'responsible': 'João Silva',
      'status': 'Em Andamento',
      'progress': 0.6,
      'dueDate': '20/10/2026',
      'fleet': 'Caminhões',
      'shift': 'Noite',
      'pdcaPhase': 'Plan',
      'evidences': <String>[],
      'studies': <String>[],
      'history': <String>[],
    },
    {
      'id': 'plan_2',
      'title': 'Inspeção de Rolamentos (Tratores)',
      'responsible': 'Maria Souza',
      'status': 'Em Andamento',
      'progress': 0.6,
      'dueDate': '20/10/2026',
      'fleet': 'Tratores',
      'shift': 'Manhã',
      'pdcaPhase': 'Do',
      'evidences': <String>[],
      'studies': <String>[],
      'history': <String>[],
    },
    {
      'id': 'plan_3',
      'title': 'Reciclagem de Rotograma da Rampa Sul',
      'responsible': 'Carlos Treinamentos',
      'status': 'Atrasado',
      'progress': 0.2,
      'dueDate': '10/10/2026',
      'fleet': 'Caminhões',
      'shift': 'Manhã',
      'pdcaPhase': 'Check',
      'evidences': <String>[],
      'studies': <String>[],
      'history': <String>[],
    },
    {
      'id': 'plan_4',
      'title': 'Atualização de Firmware do IRIS',
      'responsible': 'Equipe de TI',
      'status': 'Concluído',
      'progress': 1.0,
      'dueDate': '01/10/2026',
      'fleet': 'Escavadeiras',
      'shift': 'Tarde',
      'pdcaPhase': 'Act',
      'evidences': <String>[],
      'studies': <String>[],
      'history': <String>[],
    },
  ];

  final List<Map<String, dynamic>> _checklists = [
    {"id": "chk_1", "title": "Sistema de Freios", "description": "Verificar pressão e resposta", "isApproved": true},
    {"id": "chk_2", "title": "Pneus e Calibragem", "description": "Checar desgaste e pressão", "isApproved": true},
    {"id": "chk_3", "title": "Luzes e Sinalização", "description": "Faróis, setas e giroflex", "isApproved": false},
    {"id": "chk_4", "title": "Nível de Óleo", "description": "Motor e hidráulico", "isApproved": true},
    {"id": "chk_5", "title": "Cintos de Segurança", "description": "Trava e conservação", "isApproved": true},
  ];

  final List<Map<String, dynamic>> _compliance = [
    {"id": "comp_1", "name": "Ana Souza (Operadora)", "status": "Aprovado/Válido", "statusColor": "success", "type": "driver"},
    {"id": "comp_2", "name": "João Silva (Operador)", "status": "Aprovado/Válido", "statusColor": "success", "type": "driver"},
    {"id": "comp_3", "name": "Marcos Paulo (Operador)", "status": "Vencido/Bloqueado", "statusColor": "critical", "type": "driver"},
    {"id": "comp_4", "name": "Caminhão CAT-793 (Frota)", "status": "Licenciamento Válido", "statusColor": "success", "type": "vehicle"},
    {"id": "comp_5", "name": "Escavadeira EX-02 (Frota)", "status": "Manutenção Atrasada", "statusColor": "warning", "type": "vehicle"},
  ];

  final List<Map<String, dynamic>> _geofences = [
    {"id": "geo_1", "name": "Rampa Sul (Descida)", "limit": "30 km/h", "severity": "warning"},
    {"id": "geo_2", "name": "Área de Desmonte (Norte)", "limit": "20 km/h", "severity": "critical"},
    {"id": "geo_3", "name": "Pátio de Estacionamento", "limit": "15 km/h", "severity": "low"},
  ];

  final List<Map<String, dynamic>> _rcaAnalyses = [
    {
      "id": "rca_1",
      "type": "5whys",
      "number": 1,
      "question": "Por que o caminhão freou bruscamente?",
      "answer": "Porque o sistema ABS detectou perda de tração e acionou frenagem de emergência.",
      "isRootCause": false,
    },
    {
      "id": "rca_2",
      "type": "5whys",
      "number": 2,
      "question": "Por que o ABS detectou perda de tração?",
      "answer": "Porque a pista estava excessivamente úmida e escorregadia.",
      "isRootCause": false,
    },
    {
      "id": "rca_3",
      "type": "ishikawa",
      "category": "Máquina",
      "cause": "Falha sistêmica no ABS atestada via telemetria.",
      "colorValue": 0xFFF4A900 // AppTheme.amareloVale.value
    },
    {
      "id": "rca_4",
      "type": "ishikawa",
      "category": "Mão de Obra",
      "cause": "Fadiga detectada pelo sistema DMS na 8ª hora.",
      "colorValue": 0xFFE74C3C // AppTheme.alertaCritico.value
    }
  ];

  @override
  Future<List<Map<String, dynamic>>> getActionPlans(String shift, String fleet, String period) async {
    // Simula tempo de rede
    await Future.delayed(const Duration(milliseconds: 500));
    return _plans.where((p) => p['fleet'] == fleet && p['shift'] == shift).toList();
  }

  @override
  Future<void> addActionPlan(Map<String, dynamic> plan) async {
    await Future.delayed(const Duration(milliseconds: 500));
    plan['id'] = 'plan_${DateTime.now().millisecondsSinceEpoch}';
    _plans.add(plan);
  }

  @override
  Future<void> updateActionPlan(String id, Map<String, dynamic> updates) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final index = _plans.indexWhere((p) => p['id'] == id);
    if (index != -1) {
      _plans[index].addAll(updates);
    }
  }

  @override
  Future<List<Map<String, dynamic>>> getChecklists(String shift, String fleet) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return List.from(_checklists);
  }

  @override
  Future<void> updateChecklist(String id, Map<String, dynamic> updates) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final index = _checklists.indexWhere((c) => c['id'] == id);
    if (index != -1) {
      _checklists[index].addAll(updates);
    }
  }

  @override
  Future<List<Map<String, dynamic>>> getComplianceData(String fleet) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return List.from(_compliance);
  }

  @override
  Future<void> updateComplianceData(String id, Map<String, dynamic> updates) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final index = _compliance.indexWhere((c) => c['id'] == id);
    if (index != -1) {
      _compliance[index].addAll(updates);
    }
  }

  @override
  Future<List<Map<String, dynamic>>> getGeofences() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return List.from(_geofences);
  }

  @override
  Future<void> addGeofence(Map<String, dynamic> geofence) async {
    await Future.delayed(const Duration(milliseconds: 300));
    geofence['id'] = 'geo_${DateTime.now().millisecondsSinceEpoch}';
    _geofences.add(geofence);
  }

  @override
  Future<void> updateGeofence(String id, Map<String, dynamic> updates) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final index = _geofences.indexWhere((g) => g['id'] == id);
    if (index != -1) {
      _geofences[index].addAll(updates);
    }
  }

  @override
  Future<List<Map<String, dynamic>>> getIrisEvents() async {
    return [];
  }

  @override
  Future<List<Map<String, dynamic>>> getRcaAnalyses() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return List.from(_rcaAnalyses);
  }

  @override
  Future<void> addRcaAnalysis(Map<String, dynamic> analysis) async {
    await Future.delayed(const Duration(milliseconds: 300));
    analysis['id'] = 'rca_${DateTime.now().millisecondsSinceEpoch}';
    _rcaAnalyses.add(analysis);
  }

  @override
  Future<void> updateRcaAnalysis(String id, Map<String, dynamic> updates) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final index = _rcaAnalyses.indexWhere((r) => r['id'] == id);
    if (index != -1) {
      _rcaAnalyses[index].addAll(updates);
    }
  }
}
