import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../core/app_theme.dart';

class CrossAnalyticsScreen extends StatelessWidget {
  const CrossAnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Dashboard de Qualidade e Cross-Analytics",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 32),

          // KPIs de Qualidade (PDCA Aggregated Metrics)
          Row(
            children: [
              Expanded(child: _buildKPICard("Índice de Atraso (PDCA)", "12%", FontAwesomeIcons.clockRotateLeft, AppTheme.alertaCritico)),
              const SizedBox(width: 16),
              Expanded(child: _buildKPICard("Causas Raiz Resolvidas (Act)", "78%", FontAwesomeIcons.checkDouble, AppTheme.sucesso)),
              const SizedBox(width: 16),
              Expanded(child: _buildKPICard("Eficácia das Ações (3 meses)", "92%", FontAwesomeIcons.bullseye, AppTheme.verdeVale)),
              const SizedBox(width: 16),
              Expanded(child: _buildKPICard("Planos Pendentes (Do)", "45", FontAwesomeIcons.listCheck, AppTheme.amareloVale)),
            ],
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Dispersão: Alertas de Fadiga x Freadas Bruscas (Por Operador)",
                  ),
                  const SizedBox(height: 32),
                  Expanded(
                    child: ScatterChart(
                      ScatterChartData(
                        scatterTouchData: ScatterTouchData(
                          enabled: true,
                          handleBuiltInTouches: true,
                          touchTooltipData: ScatterTouchTooltipData(
                            getTooltipItems: (ScatterSpot touchedBarSpot) {
                              return ScatterTooltipItem(
                                'Operador\nFadiga: ${touchedBarSpot.x.toInt()}\nFreadas: ${touchedBarSpot.y.toInt()}',
                                textStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                              );
                            },
                          ),
                        ),
                        scatterSpots: [
                          ScatterSpot(
                            2,
                            4,
                            dotPainter: FlDotCirclePainter(
                              color: AppTheme.amareloVale,
                              radius: 12,
                            ),
                          ),
                          ScatterSpot(
                            5,
                            7,
                            dotPainter: FlDotCirclePainter(
                              color: AppTheme.alertaCritico,
                              radius: 20,
                            ),
                          ),
                          ScatterSpot(
                            1,
                            1,
                            dotPainter: FlDotCirclePainter(
                              color: AppTheme.verdeVale,
                              radius: 8,
                            ),
                          ),
                          ScatterSpot(
                            8,
                            9,
                            dotPainter: FlDotCirclePainter(
                              color: AppTheme.alertaCritico,
                              radius: 25,
                            ),
                          ),
                          ScatterSpot(
                            3,
                            2,
                            dotPainter: FlDotCirclePainter(
                              color: AppTheme.verdeEscuro,
                              radius: 10,
                            ),
                          ),
                        ],
                        minX: 0,
                        maxX: 10,
                        minY: 0,
                        maxY: 10,
                        titlesData: FlTitlesData(
                          bottomTitles: AxisTitles(
                            axisNameWidget: const Text(
                              "Alertas de Fadiga (DMS)",
                            ),
                            sideTitles: SideTitles(showTitles: true),
                          ),
                          leftTitles: AxisTitles(
                            axisNameWidget: const Text(
                              "Freadas Bruscas (Interlock)",
                            ),
                            sideTitles: SideTitles(showTitles: true),
                          ),
                        ),
                      ),
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

  Widget _buildKPICard(String title, String value, FaIconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border(bottom: BorderSide(color: color, width: 4)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: AppTheme.textoSecundario,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textoPrincipal,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: FaIcon(icon, color: color, size: 24),
          ),
        ],
      ),
    );
  }
}
