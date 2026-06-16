import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/providers/filter_provider.dart';
import '../../../core/services/mock_data_service.dart';
import '../../../core/app_theme.dart';

class ActionPlanScreen extends StatelessWidget {
  const ActionPlanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final filter = Provider.of<FilterProvider>(context);
    final plans = MockDataService.getActionPlans(filter.shift, filter.fleet, filter.period);

    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Planos de Ação (PDCA / 5W2H) - Contexto: ${filter.shift} / ${filter.fleet}",
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 32),
          Expanded(
            child: ListView.builder(
              itemCount: plans.length,
              itemBuilder: (context, index) {
                final plan = plans[index];
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
                          : (isDelayed ? AppTheme.alertaCritico : AppTheme.amareloVale),
                      child: Icon(
                        isDone ? Icons.check : (isDelayed ? Icons.warning : Icons.engineering),
                        color: Colors.white,
                      ),
                    ),
                    title: Text(plan['title'], style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 8),
                        Text("Responsável: ${plan['responsible']} | Prazo: ${plan['dueDate']}"),
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
                        color: isDelayed ? AppTheme.alertaCritico : AppTheme.textoSecundario,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
