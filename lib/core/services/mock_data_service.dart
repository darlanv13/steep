import 'data_service.dart';

class MockDataService implements DataService {
  final List<Map<String, dynamic>> _plans = [
    {
      'title': 'Troca de Sensores ABS (Caminhão Fora de Estrada)',
      'responsible': 'João Silva',
      'status': 'Em Andamento',
      'progress': 0.6,
      'dueDate': '20/10/2026',
      'fleet': 'Caminhões',
      'shift': 'Noite'
    },
    {
      'title': 'Inspeção de Rolamentos (Tratores)',
      'responsible': 'Maria Souza',
      'status': 'Em Andamento',
      'progress': 0.6,
      'dueDate': '20/10/2026',
      'fleet': 'Tratores',
      'shift': 'Manhã'
    },
    {
      'title': 'Reciclagem de Rotograma da Rampa Sul',
      'responsible': 'Carlos Treinamentos',
      'status': 'Atrasado',
      'progress': 0.2,
      'dueDate': '10/10/2026',
      'fleet': 'Caminhões',
      'shift': 'Manhã'
    },
    {
      'title': 'Atualização de Firmware do IRIS',
      'responsible': 'Equipe de TI',
      'status': 'Concluído',
      'progress': 1.0,
      'dueDate': '01/10/2026',
      'fleet': 'Escavadeiras',
      'shift': 'Tarde'
    },
  ];

  @override
  Future<List<Map<String, dynamic>>> getActionPlans(String shift, String fleet, String period) async {
    // Simula tempo de rede
    await Future.delayed(const Duration(milliseconds: 500));
    return _plans.where((p) => p['fleet'] == fleet && p['shift'] == shift).toList();
  }

  @override
  Future<void> addActionPlan(Map<String, dynamic> plan) async {
    // Simula tempo de rede
    await Future.delayed(const Duration(milliseconds: 500));
    _plans.add(plan);
  }

  @override
  Future<List<Map<String, dynamic>>> getChecklists(String shift, String fleet) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return [
      {"title": "Sistema de Freios", "description": "Verificar pressão e resposta", "isApproved": true},
      {"title": "Pneus e Calibragem", "description": "Checar desgaste e pressão", "isApproved": true},
      {"title": "Luzes e Sinalização", "description": "Faróis, setas e giroflex", "isApproved": false},
      {"title": "Nível de Óleo", "description": "Motor e hidráulico", "isApproved": true},
      {"title": "Cintos de Segurança", "description": "Trava e conservação", "isApproved": true},
    ];
  }

  @override
  Future<List<Map<String, dynamic>>> getComplianceData(String fleet) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return [
      {"name": "Ana Souza (Operadora)", "status": "Aprovado/Válido", "statusColor": "success", "type": "driver"},
      {"name": "João Silva (Operador)", "status": "Aprovado/Válido", "statusColor": "success", "type": "driver"},
      {"name": "Marcos Paulo (Operador)", "status": "Vencido/Bloqueado", "statusColor": "critical", "type": "driver"},
      {"name": "Caminhão CAT-793 (Frota)", "status": "Licenciamento Válido", "statusColor": "success", "type": "vehicle"},
      {"name": "Escavadeira EX-02 (Frota)", "status": "Manutenção Atrasada", "statusColor": "warning", "type": "vehicle"},
    ];
  }

  @override
  Future<List<Map<String, dynamic>>> getGeofences() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return [
      {"name": "Rampa Sul (Descida)", "limit": "30 km/h", "severity": "warning"},
      {"name": "Área de Desmonte (Norte)", "limit": "20 km/h", "severity": "critical"},
      {"name": "Pátio de Estacionamento", "limit": "15 km/h", "severity": "low"},
    ];
  }

  @override
  Future<List<Map<String, dynamic>>> getIrisEvents() async {
    return [];
  }
}
