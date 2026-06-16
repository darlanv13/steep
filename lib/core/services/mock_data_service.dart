class MockDataService {
  static List<Map<String, dynamic>> getActionPlans(String shift, String fleet, String period) {
    // Simulando dados que mudam baseados no filtro selecionado no TopBar
    final isNight = shift == 'Noite';
    final isTruck = fleet == 'Caminhões';

    return [
      {
        'title': isTruck ? 'Troca de Sensores ABS (Caminhão Fora de Estrada)' : 'Inspeção de Rolamentos (Tratores)',
        'responsible': isNight ? 'João Silva (Turno C)' : 'Maria Souza (Turno A)',
        'status': 'Em Andamento',
        'progress': 0.6,
        'dueDate': '20/10/2026'
      },
      {
        'title': 'Reciclagem de Rotograma da Rampa Sul',
        'responsible': 'Carlos Treinamentos',
        'status': 'Atrasado',
        'progress': 0.2,
        'dueDate': '10/10/2026'
      },
      {
        'title': 'Atualização de Firmware do IRIS',
        'responsible': 'Equipe de TI',
        'status': 'Concluído',
        'progress': 1.0,
        'dueDate': '01/10/2026'
      },
    ];
  }
}
