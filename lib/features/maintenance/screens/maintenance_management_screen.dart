import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../core/app_theme.dart';

class MaintenanceManagementScreen extends StatelessWidget {
  const MaintenanceManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Ordens de Serviço Automáticas (O.S.)",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: AppTheme.sucesso.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Row(
                  children: [
                    FaIcon(
                      FontAwesomeIcons.wrench,
                      color: AppTheme.sucesso,
                      size: 16,
                    ),
                    SizedBox(width: 8),
                    Text(
                      "MTBF Atual: 450h",
                      style: TextStyle(
                        color: AppTheme.sucesso,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: _buildKanbanColumn(
                    "Pendentes (Intertravamento)",
                    AppTheme.alertaCritico,
                    [
                      _buildOsCard(
                        "OS-2041",
                        "V-102",
                        "Falha Cinto de 3 Pontos",
                        "Origem: Checklist Digital",
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildKanbanColumn(
                    "Em Execução (Oficina)",
                    AppTheme.amareloVale,
                    [
                      _buildOsCard(
                        "OS-2039",
                        "V-205",
                        "Troca Pastilhas de Freio",
                        "Origem: Preditiva (Quilometragem)",
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildKanbanColumn(
                    "Concluídas (Aguardando Liberação)",
                    AppTheme.verdeVale,
                    [
                      _buildOsCard(
                        "OS-2030",
                        "B-300",
                        "Calibração de Interlock",
                        "Origem: Rotina SSMA",
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildKanbanColumn(
    String title,
    Color headerColor,
    List<Widget> cards,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.background,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.black12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              FaIcon(FontAwesomeIcons.circleDot, color: headerColor, size: 16),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Expanded(child: ListView(children: cards)),
        ],
      ),
    );
  }

  Widget _buildOsCard(
    String osId,
    String vehicle,
    String issue,
    String origin,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  osId,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppTheme.verdeVale,
                  ),
                ),
                Text(
                  vehicle,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              issue,
              style: const TextStyle(
                fontSize: 16,
                color: AppTheme.textoPrincipal,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              origin,
              style: const TextStyle(
                fontSize: 12,
                color: AppTheme.textoSecundario,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
