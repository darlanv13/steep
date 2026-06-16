import 'package:flutter/material.dart';
import '../../../core/app_theme.dart';

class PredictiveMaintenanceScreen extends StatelessWidget {
  const PredictiveMaintenanceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Manutenção Preditiva & Saúde dos Ativos",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 32),
          Expanded(
            child: ListView(
              children: [
                _buildAssetCard("Caminhão FOR-04", 88, "Sistema Hidráulico", "Falha provável em 3 dias", true),
                _buildAssetCard("Trator TR-02", 45, "Rolamentos Mestre", "Atenção requerida (Temperatura alta)", false),
                _buildAssetCard("Escavadeira ESC-09", 98, "Sem anomalias", "Operando normalmente", false),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAssetCard(String name, int confidence, String system, String message, bool isCritical) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                Chip(
                  label: Text(
                    isCritical ? "Crítico" : (confidence < 90 ? "Alerta" : "Normal"),
                    style: const TextStyle(color: Colors.white),
                  ),
                  backgroundColor: isCritical
                      ? AppTheme.alertaCritico
                      : (confidence < 90 ? AppTheme.amareloVale : AppTheme.verdeVale),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text("Sistema Afetado: $system", style: const TextStyle(fontWeight: FontWeight.w500)),
            const SizedBox(height: 8),
            Text("Diagnóstico: $message", style: TextStyle(color: Colors.grey[700])),
            const SizedBox(height: 16),
            Row(
              children: [
                const Text("Confiança do Algoritmo: "),
                Expanded(
                  child: LinearProgressIndicator(
                    value: confidence / 100,
                    backgroundColor: Colors.grey[200],
                    color: AppTheme.verdeEscuro,
                  ),
                ),
                const SizedBox(width: 16),
                Text("$confidence%"),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
