class MockDataService {
  static final List<Map<String, dynamic>> _plans = [
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

  static List<Map<String, dynamic>> getActionPlans(String shift, String fleet, String period) {
    return _plans.where((p) => p['fleet'] == fleet && p['shift'] == shift).toList();
  }

  static void addActionPlan(Map<String, dynamic> plan) {
    _plans.add(plan);
  }
}
