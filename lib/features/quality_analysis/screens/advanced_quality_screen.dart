import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../core/app_theme.dart';
import '../../../core/services/pdf_service.dart';

class AdvancedQualityScreen extends StatelessWidget {
  const AdvancedQualityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Engenharia de Qualidade e Análise de Causa Raiz (RCA)",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 32),
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Diagrama de Pareto Simulado
                Expanded(
                  flex: 1,
                  child: Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Row(
                          children: [
                            FaIcon(
                              FontAwesomeIcons.chartColumn,
                              color: AppTheme.verdeVale,
                            ),
                            SizedBox(width: 12),
                            Text(
                              "Gráfico de Pareto (Anomalias)",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          "80% das frenagens bruscas concentram-se na Rampa Sul e em 20% do contingente.",
                          style: TextStyle(color: AppTheme.textoSecundario),
                        ),
                        const Spacer(),
                        // Placeholder elegante para o gráfico
                        Center(
                          child: Container(
                            height: 200,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: AppTheme.background,
                              border: Border.all(color: Colors.black12),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Center(
                              child: FaIcon(
                                FontAwesomeIcons.chartLine,
                                size: 64,
                                color: AppTheme.textoSecundario,
                              ),
                            ),
                          ),
                        ),
                        const Spacer(),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 32),
                // Diagrama de Ishikawa (Espinha de Peixe)
                Expanded(
                  flex: 1,
                  child: Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Row(
                          children: [
                            FaIcon(
                              FontAwesomeIcons.fishFins,
                              color: AppTheme.verdeVale,
                            ),
                            SizedBox(width: 12),
                            Text(
                              "Diagrama de Ishikawa",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        _buildFishboneCategory(
                          "Máquina",
                          "Falha sistêmica no ABS atestada via telemetria.",
                          AppTheme.amareloVale,
                        ),
                        _buildFishboneCategory(
                          "Meio Ambiente",
                          "Pista de minério umedecida reduzindo aderência.",
                          AppTheme.verdeEscuro,
                        ),
                        _buildFishboneCategory(
                          "Mão de Obra",
                          "Fadiga detectada pelo sistema DMS na 8ª hora.",
                          AppTheme.alertaCritico,
                        ),
                        _buildFishboneCategory(
                          "Método",
                          "Rotograma com limite de velocidade superestimado.",
                          AppTheme.amareloVale,
                        ),
                        const Spacer(),
                        const Divider(),
                        const Row(
                          children: [
                            FaIcon(
                              FontAwesomeIcons.arrowTrendDown,
                              color: AppTheme.verdeVale,
                            ),
                            SizedBox(width: 12),
                            Text(
                              "Eficácia (Acompanhamento Temporal)",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Container(
                          height: 80,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: AppTheme.background,
                            border: Border.all(color: Colors.black12),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Center(
                            child: Text(
                              "Gráfico de Série Temporal - Redução de 45% nos últimos 3 meses",
                              style: TextStyle(
                                color: AppTheme.textoSecundario,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.textoPrincipal,
                            minimumSize: const Size(double.infinity, 50),
                          ),
                          icon: const FaIcon(
                            FontAwesomeIcons.filePdf,
                            color: Colors.white,
                          ),
                          label: const Text(
                            "Exportar Dossiê Unificado (RCA + Câmeras + Interlock)",
                            style: TextStyle(color: Colors.white),
                          ),
                          onPressed: () async {
                            await PdfService.generateAndPrintUnifiedDossier();
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFishboneCategory(String category, String cause, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              category,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              cause,
              style: const TextStyle(
                color: AppTheme.textoPrincipal,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
