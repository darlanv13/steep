import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
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
            "Cross-Analytics: Correlação de Eventos DMS vs Interlock",
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
}
