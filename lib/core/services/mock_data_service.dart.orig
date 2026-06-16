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
}
