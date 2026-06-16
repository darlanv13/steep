import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/providers/filter_provider.dart';
import '../../../core/services/data_service.dart';
import '../../../core/app_theme.dart';

class ActionPlanScreen extends StatefulWidget {
  const ActionPlanScreen({super.key});

  @override
  State<ActionPlanScreen> createState() => _ActionPlanScreenState();
}

class _ActionPlanScreenState extends State<ActionPlanScreen> {
  List<Map<String, dynamic>> _plans = [];
  bool _isLoading = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _fetchPlans();
  }

  Future<void> _fetchPlans() async {
    final filter = Provider.of<FilterProvider>(context, listen: false);
    final dataService = Provider.of<DataService>(context, listen: false);

    if (mounted) setState(() => _isLoading = true);

    try {
      final newPlans = await dataService.getActionPlans(
        filter.shift,
        filter.fleet,
        filter.period,
      );
      if (mounted) {
        setState(() {
          _plans = newPlans;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Erro ao carregar dados: $e"),
            backgroundColor: AppTheme.alertaCritico,
          ),
        );
      }
    }
  }

  void _showAddPlanDialog(
    BuildContext context,
    FilterProvider filter,
    DataService dataService,
  ) {
    final titleController = TextEditingController();
    final responsibleController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Novo Plano de Ação (PDCA)"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(labelText: "O Quê? (Ação)"),
              ),
              TextField(
                controller: responsibleController,
                decoration: const InputDecoration(
                  labelText: "Quem? (Responsável)",
                ),
              ),
              const SizedBox(height: 16),
              Text(
                "Frota: ${filter.fleet} | Turno: ${filter.shift}",
                style: const TextStyle(color: Colors.grey),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancelar"),
            ),
            ElevatedButton(
              onPressed: () async {
                if (titleController.text.isNotEmpty &&
                    responsibleController.text.isNotEmpty) {
                  try {
                    await dataService.addActionPlan({
                      'title': titleController.text,
                      'responsible': responsibleController.text,
                      'status': 'Em Andamento',
                      'progress': 0.0,
                      'dueDate': 'TBD',
                      'fleet': filter.fleet,
                      'shift': filter.shift,
                    });
                    if (mounted) {
                      Navigator.pop(context);
                      _fetchPlans();
                    }
                  } catch (e) {
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("Erro ao salvar: $e"),
                          backgroundColor: AppTheme.alertaCritico,
                        ),
                      );
                    }
                  }
                }
              },
              child: const Text("Salvar"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final filter = Provider.of<FilterProvider>(context);
    final dataService = Provider.of<DataService>(context);

    // Watch for provider error messages
    if (filter.errorMessage != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(filter.errorMessage!),
            backgroundColor: AppTheme.alertaCritico,
          ),
        );
        filter.clearError();
      });
    }

    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddPlanDialog(context, filter, dataService),
        backgroundColor: AppTheme.verdeVale,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text("Novo Plano", style: TextStyle(color: Colors.white)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Planos de Ação (PDCA / 5W2H) - Contexto: ${filter.shift} / ${filter.fleet}",
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 32),
            if (_isLoading || filter.isLoading)
              const Expanded(
                child: Center(
                  child: CircularProgressIndicator(color: AppTheme.verdeVale),
                ),
              )
            else if (_plans.isEmpty)
              const Expanded(
                child: Center(
                  child: Text("Nenhum plano para os filtros selecionados."),
                ),
              )
            else
              Expanded(
                child: ListView.builder(
                  itemCount: _plans.length,
                  itemBuilder: (context, index) {
                    final plan = _plans[index];
                    final isDelayed = plan['status'] == 'Atrasado';
                    final isDone = plan['status'] == 'Concluído';

                    return Card(
                      margin: const EdgeInsets.only(bottom: 16),
                      color: Colors.white,
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(16),
                        leading: CircleAvatar(
                          backgroundColor: isDone
                              ? AppTheme.verdeEscuro
                              : (isDelayed
                                    ? AppTheme.alertaCritico
                                    : AppTheme.amareloVale),
                          child: Icon(
                            isDone
                                ? Icons.check
                                : (isDelayed
                                      ? Icons.warning
                                      : Icons.engineering),
                            color: Colors.white,
                          ),
                        ),
                        title: Text(
                          plan['title'],
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 8),
                            Text(
                              "Responsável: ${plan['responsible']} | Prazo: ${plan['dueDate']}",
                            ),
                            const SizedBox(height: 8),
                            LinearProgressIndicator(
                              value: plan['progress'],
                              backgroundColor: Colors.grey[200],
                              color: AppTheme.verdeVale,
                            ),
                          ],
                        ),
                        trailing: Text(
                          plan['status'],
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: isDelayed
                                ? AppTheme.alertaCritico
                                : AppTheme.textoSecundario,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}
