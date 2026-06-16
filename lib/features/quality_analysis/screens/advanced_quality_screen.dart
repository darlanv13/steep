import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../core/app_theme.dart';
import '../../../core/services/pdf_service.dart';

class AdvancedQualityScreen extends StatelessWidget {
  const AdvancedQualityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Engenharia de Qualidade e Análise de Causa Raiz (RCA)",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 32),
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
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
                        const SizedBox(height: 32),
                        // Gráfico de Pareto usando fl_chart
                        SizedBox(
                          height: 300,
                          child: BarChart(
                            BarChartData(
                              alignment: BarChartAlignment.spaceAround,
                              maxY: 100,
                              barTouchData: BarTouchData(enabled: false),
                              titlesData: FlTitlesData(
                                show: true,
                                bottomTitles: AxisTitles(
                                  sideTitles: SideTitles(
                                    showTitles: true,
                                    getTitlesWidget: (value, meta) {
                                      const titles = ['Frenagem', 'Velocidade', 'Fadiga', 'Outros'];
                                      if (value.toInt() >= 0 && value.toInt() < titles.length) {
                                        return Padding(
                                          padding: const EdgeInsets.only(top: 8.0),
                                          child: Text(
                                            titles[value.toInt()],
                                            style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
                                          ),
                                        );
                                      }
                                      return const Text('');
                                    },
                                    reservedSize: 28,
                                  ),
                                ),
                                leftTitles: AxisTitles(
                                  sideTitles: SideTitles(
                                    showTitles: true,
                                    reservedSize: 32,
                                    getTitlesWidget: (value, meta) {
                                      return Text('${value.toInt()}', style: const TextStyle(fontSize: 10));
                                    },
                                  ),
                                ),
                                topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                                rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                              ),
                              gridData: const FlGridData(show: false),
                              borderData: FlBorderData(show: false),
                              barGroups: [
                                BarChartGroupData(x: 0, barRods: [BarChartRodData(toY: 80, color: AppTheme.alertaCritico, width: 16, borderRadius: BorderRadius.circular(4))]),
                                BarChartGroupData(x: 1, barRods: [BarChartRodData(toY: 15, color: AppTheme.amareloVale, width: 16, borderRadius: BorderRadius.circular(4))]),
                                BarChartGroupData(x: 2, barRods: [BarChartRodData(toY: 3, color: AppTheme.verdeVale, width: 16, borderRadius: BorderRadius.circular(4))]),
                                BarChartGroupData(x: 3, barRods: [BarChartRodData(toY: 2, color: AppTheme.textoSecundario, width: 16, borderRadius: BorderRadius.circular(4))]),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 32),
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
                        const SizedBox(height: 32),
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
                        const SizedBox(height: 16),
                        SizedBox(
                          height: 120,
                          child: LineChart(
                            LineChartData(
                              gridData: const FlGridData(show: false),
                              titlesData: const FlTitlesData(show: false),
                              borderData: FlBorderData(show: false),
                              minX: 0,
                              maxX: 4,
                              minY: 0,
                              maxY: 60,
                              lineBarsData: [
                                LineChartBarData(
                                  spots: const [
                                    FlSpot(0, 50),
                                    FlSpot(1, 45),
                                    FlSpot(2, 35),
                                    FlSpot(3, 27),
                                  ],
                                  isCurved: true,
                                  color: AppTheme.sucesso,
                                  barWidth: 3,
                                  isStrokeCapRound: true,
                                  dotData: const FlDotData(show: true),
                                  belowBarData: BarAreaData(
                                    show: true,
                                    color: AppTheme.sucesso.withValues(alpha: 0.2),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          "Redução de 45% nas anomalias (Últimos 3 meses)",
                          style: TextStyle(color: AppTheme.sucesso, fontWeight: FontWeight.bold, fontSize: 12),
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
          const SizedBox(height: 32),
          // Plano de Ação 5W2H Section
          Container(
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
                      FontAwesomeIcons.clipboardList,
                      color: AppTheme.verdeVale,
                    ),
                    SizedBox(width: 12),
                    Text(
                      "Plano de Ação - 5W2H",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                const Text(
                  "Ações corretivas baseadas na Causa Raiz identificada.",
                  style: TextStyle(
                    color: AppTheme.textoSecundario,
                  ),
                ),
                const SizedBox(height: 24),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    headingRowColor: WidgetStateProperty.all(AppTheme.background),
                    columns: const [
                      DataColumn(label: Text('O Que (What)', style: TextStyle(fontWeight: FontWeight.bold))),
                      DataColumn(label: Text('Por Que (Why)', style: TextStyle(fontWeight: FontWeight.bold))),
                      DataColumn(label: Text('Onde (Where)', style: TextStyle(fontWeight: FontWeight.bold))),
                      DataColumn(label: Text('Quando (When)', style: TextStyle(fontWeight: FontWeight.bold))),
                      DataColumn(label: Text('Quem (Who)', style: TextStyle(fontWeight: FontWeight.bold))),
                      DataColumn(label: Text('Como (How)', style: TextStyle(fontWeight: FontWeight.bold))),
                      DataColumn(label: Text('Quanto (How Much)', style: TextStyle(fontWeight: FontWeight.bold))),
                      DataColumn(label: Text('Status', style: TextStyle(fontWeight: FontWeight.bold))),
                    ],
                    rows: [
                      _build5W2HRow(
                        "Criar POP de Aspersão",
                        "Evitar pista úmida excessiva pós-chuva",
                        "CCO / Mina",
                        "15/11/2023",
                        "João Silva (Eng. Minas)",
                        "Revisão técnica de manuais operacionais",
                        "R\$ 0,00 (HH Interno)",
                        "Em Andamento",
                        AppTheme.amareloVale,
                      ),
                      _build5W2HRow(
                        "Treinar Operadores de Pipa",
                        "Garantir entendimento do novo POP",
                        "Auditório da Mina",
                        "20/11/2023",
                        "Maria Souza (RH/Treinamento)",
                        "Workshops práticos de 4h",
                        "R\$ 2.500,00",
                        "Pendente",
                        AppTheme.alertaCritico,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
          // 5 Porquês (5 Whys) Section
          Container(
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
                      FontAwesomeIcons.circleQuestion,
                      color: AppTheme.verdeVale,
                    ),
                    SizedBox(width: 12),
                    Text(
                      "5 Porquês (Análise de Causa Raiz)",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                const Text(
                  "Problema: O caminhão freou bruscamente na Rampa Sul.",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.alertaCritico,
                  ),
                ),
                const SizedBox(height: 24),
                _buildWhyItem(
                  1,
                  "Por que o caminhão freou bruscamente?",
                  "Porque o sistema ABS detectou perda de tração e acionou frenagem de emergência.",
                ),
                _buildWhyItem(
                  2,
                  "Por que o ABS detectou perda de tração?",
                  "Porque a pista estava excessivamente úmida e escorregadia.",
                ),
                _buildWhyItem(
                  3,
                  "Por que a pista estava excessivamente úmida?",
                  "Porque o caminhão pipa aspergiu mais água do que o necessário.",
                ),
                _buildWhyItem(
                  4,
                  "Por que o caminhão pipa aspergiu mais água?",
                  "Porque o operador não ajustou o fluxo para as condições climáticas (já havia chovido).",
                ),
                _buildWhyItem(
                  5,
                  "Por que o operador não ajustou o fluxo?",
                  "Porque não há um POP (Procedimento Operacional Padrão) claro para ajuste de aspersão pós-chuva.",
                  isRootCause: true,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  DataRow _build5W2HRow(String what, String why, String where, String when, String who, String how, String howMuch, String status, Color statusColor) {
    return DataRow(
      cells: [
        DataCell(Text(what)),
        DataCell(Text(why)),
        DataCell(Text(where)),
        DataCell(Text(when)),
        DataCell(Text(who)),
        DataCell(Text(how)),
        DataCell(Text(howMuch)),
        DataCell(
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: statusColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(4),
              border: Border.all(color: statusColor),
            ),
            child: Text(
              status,
              style: TextStyle(
                color: statusColor,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildWhyItem(int number, String question, String answer, {bool isRootCause = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: isRootCause ? AppTheme.alertaCritico : AppTheme.verdeVale,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                number.toString(),
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  question,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textoPrincipal,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  answer,
                  style: TextStyle(
                    color: isRootCause ? AppTheme.alertaCritico : AppTheme.textoSecundario,
                    fontWeight: isRootCause ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
                if (isRootCause) ...[
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppTheme.alertaCritico.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(color: AppTheme.alertaCritico),
                    ),
                    child: const Text(
                      "Causa Raiz Identificada",
                      style: TextStyle(
                        color: AppTheme.alertaCritico,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
                ]
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
