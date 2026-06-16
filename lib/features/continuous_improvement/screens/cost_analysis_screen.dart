import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../core/app_theme.dart';

class CostAnalysisScreen extends StatelessWidget {
  const CostAnalysisScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Custos da Não-Qualidade (Impacto Financeiro)",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 32),
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      children: [
                        const Text("Custos por Natureza (R\$)", style: TextStyle(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 32),
                        Expanded(
                          child: BarChart(
                            BarChartData(
                              barTouchData: BarTouchData(
                                touchTooltipData: BarTouchTooltipData(
                                  getTooltipItem: (group, groupIndex, rod, rodIndex) {
                                    return BarTooltipItem(
                                      'R\$ ${rod.toY.toInt()}',
                                      const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                    );
                                  },
                                ),
                              ),
                              alignment: BarChartAlignment.spaceAround,
                              barGroups: [
                                BarChartGroupData(x: 0, barRods: [BarChartRodData(toY: 8000, color: AppTheme.alertaCritico)]),
                                BarChartGroupData(x: 1, barRods: [BarChartRodData(toY: 12000, color: AppTheme.amareloVale)]),
                                BarChartGroupData(x: 2, barRods: [BarChartRodData(toY: 3000, color: AppTheme.verdeVale)]),
                              ],
                              titlesData: FlTitlesData(
                                bottomTitles: AxisTitles(
                                  sideTitles: SideTitles(
                                    showTitles: true,
                                    getTitlesWidget: (double value, TitleMeta meta) {
                                      switch (value.toInt()) {
                                        case 0: return const Text('Acidentes');
                                        case 1: return const Text('Máq. Parada');
                                        case 2: return const Text('Retrabalho');
                                        default: return const Text('');
                                      }
                                    },
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 32),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      children: [
                        const Text("Distribuição por Frota", style: TextStyle(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 32),
                        Expanded(
                          child: PieChart(
                            PieChartData(
                              pieTouchData: PieTouchData(
                                touchCallback: (FlTouchEvent event, pieTouchResponse) {},
                              ),
                              sections: [
                                PieChartSectionData(value: 40, title: 'Caminhões', color: AppTheme.amareloVale, radius: 60),
                                PieChartSectionData(value: 30, title: 'Tratores', color: AppTheme.verdeEscuro, radius: 60),
                                PieChartSectionData(value: 30, title: 'Escav.', color: AppTheme.verdeVale, radius: 60),
                              ],
                            ),
                          ),
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
}
