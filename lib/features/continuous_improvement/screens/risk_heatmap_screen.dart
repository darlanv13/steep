import 'package:flutter/material.dart';
import '../../../core/app_theme.dart';

class RiskHeatmapScreen extends StatelessWidget {
  const RiskHeatmapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Heatmap Analítico (Zonas de Risco Operacional)",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 32),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  const Text("Mapa de Calor da Mina (Representação em Grid)"),
                  const SizedBox(height: 16),
                  Expanded(
                    child: GridView.builder(
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 5,
                        crossAxisSpacing: 8,
                        mainAxisSpacing: 8,
                      ),
                      itemCount: 25,
                      itemBuilder: (context, index) {
                        // Simulando zonas quentes
                        Color cellColor = AppTheme.background;
                        String label = "Seguro";
                        if (index == 7 || index == 12) {
                          cellColor = AppTheme.alertaCritico.withOpacity(0.8);
                          label = "Risco Alto\n(DMS)";
                        } else if (index == 2 || index == 21 || index == 22) {
                          cellColor = AppTheme.amareloVale.withOpacity(0.8);
                          label = "Atenção\n(Buracos)";
                        }

                        return Container(
                          decoration: BoxDecoration(
                            color: cellColor,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.black12),
                          ),
                          child: Center(
                            child: Text(
                              "Setor ${index + 1}\n$label",
                              textAlign: TextAlign.center,
                              style: const TextStyle(fontSize: 12),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
