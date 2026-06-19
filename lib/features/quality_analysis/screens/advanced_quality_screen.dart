import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:provider/provider.dart';
import '../../../core/app_theme.dart';
import '../../../core/services/data_service.dart';
import '../../../core/services/pdf_service.dart';

class AdvancedQualityScreen extends StatefulWidget {
  const AdvancedQualityScreen({super.key});

  @override
  State<AdvancedQualityScreen> createState() => _AdvancedQualityScreenState();
}

class _AdvancedQualityScreenState extends State<AdvancedQualityScreen> {
  List<Map<String, dynamic>> _whys = [];
  List<Map<String, dynamic>> _ishikawaCauses = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    if (!mounted) return;

    final service = Provider.of<DataService>(context, listen: false);
    final analyses = await service.getRcaAnalyses();

    if (mounted) {
      setState(() {
        _whys = analyses.where((a) => a['type'] == '5whys').toList();
        _whys.sort((a, b) => (a['number'] as int).compareTo(b['number'] as int));

        _ishikawaCauses = analyses.where((a) => a['type'] == 'ishikawa').map((a) {
          return {
            'id': a['id'],
            'category': a['category'],
            'cause': a['cause'],
            'color': Color(a['colorValue'] as int),
          };
        }).toList();

        _isLoading = false;
      });
    }
  }

  // Estado para o 5W2H (Mock, uma vez que vem de ActionPlanScreen na realidade)
  final List<Map<String, dynamic>> _actions = [
    {
      "what": "Criar POP de Aspersão",
      "why": "Evitar pista úmida excessiva pós-chuva",
      "where": "CCO / Mina",
      "when": "15/11/2023",
      "who": "João Silva (Eng. Minas)",
      "how": "Revisão técnica de manuais operacionais",
      "howMuch": "R\$ 0,00 (HH Interno)",
      "status": "Em Andamento",
      "statusColor": AppTheme.amareloVale,
      "pdcaPhase": "Plan",
      "pdcaColor": Colors.blue,
    },
    {
      "what": "Treinar Operadores de Pipa",
      "why": "Garantir entendimento do novo POP",
      "where": "Auditório da Mina",
      "when": "20/11/2023",
      "who": "Maria Souza (RH/Treinamento)",
      "how": "Workshops práticos de 4h",
      "howMuch": "R\$ 2.500,00",
      "status": "Pendente",
      "statusColor": AppTheme.alertaCritico,
      "pdcaPhase": "Do",
      "pdcaColor": Colors.orange,
    },
  ];

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                            ElevatedButton.icon(
                              onPressed: () => _showAddIshikawaDialog(),
                              icon: const Icon(Icons.add, color: Colors.white, size: 16),
                              label: const Text("Adicionar Causa", style: TextStyle(color: Colors.white)),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        ..._ishikawaCauses.map((i) => _buildFishboneCategory(
                              i['category'],
                              i['cause'],
                              i['color'] as Color,
                            )),
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
                            await PdfService.generateAndPrintUnifiedDossier(
                              whys: _whys,
                              actions: _actions,
                            );
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
          // Matriz de Risco (Probabilidade x Impacto / FMEA)
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
                      FontAwesomeIcons.tableCells,
                      color: AppTheme.verdeVale,
                    ),
                    SizedBox(width: 12),
                    Text(
                      "Matriz de Risco (Probabilidade x Impacto)",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                const Text(
                  "Avaliação de severidade e ocorrência das anomalias registradas.",
                  style: TextStyle(color: AppTheme.textoSecundario),
                ),
                const SizedBox(height: 24),
                Center(
                  child: Container(
                    constraints: const BoxConstraints(maxWidth: 400),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            const SizedBox(width: 60), // Espaço para rótulo Y
                            Expanded(child: _buildHeatmapCell("Baixo", "Baixo", AppTheme.sucesso.withValues(alpha: 0.5), "2")),
                            Expanded(child: _buildHeatmapCell("Médio", "Baixo", AppTheme.amareloVale.withValues(alpha: 0.5), "5")),
                            Expanded(child: _buildHeatmapCell("Alto", "Baixo", AppTheme.amareloVale, "12")),
                          ],
                        ),
                        Row(
                          children: [
                            const SizedBox(
                              width: 60,
                              child: Text("Médio", textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                            ),
                            Expanded(child: _buildHeatmapCell("Baixo", "Médio", AppTheme.sucesso, "4")),
                            Expanded(child: _buildHeatmapCell("Médio", "Médio", AppTheme.amareloVale, "18")),
                            Expanded(child: _buildHeatmapCell("Alto", "Médio", AppTheme.alertaCritico.withValues(alpha: 0.8), "8")),
                          ],
                        ),
                        Row(
                          children: [
                            const SizedBox(
                              width: 60,
                              child: Text("Alto\n(Impacto)", textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                            ),
                            Expanded(child: _buildHeatmapCell("Baixo", "Alto", AppTheme.amareloVale, "1")),
                            Expanded(child: _buildHeatmapCell("Médio", "Alto", AppTheme.alertaCritico.withValues(alpha: 0.8), "3")),
                            Expanded(child: _buildHeatmapCell("Alto", "Alto", AppTheme.alertaCritico, "5 (Crítico)")),
                          ],
                        ),
                        const SizedBox(height: 8),
                        const Row(
                          children: [
                            SizedBox(width: 60),
                            Expanded(child: Text("Baixo", textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12))),
                            Expanded(child: Text("Médio", textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12))),
                            Expanded(child: Text("Alto\n(Probabilidade)", textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12))),
                          ],
                        )
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                    ElevatedButton.icon(
                      onPressed: () => _showAddActionDialog(),
                      icon: const Icon(Icons.add, color: Colors.white, size: 16),
                      label: const Text("Adicionar Ação", style: TextStyle(color: Colors.white)),
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
                      DataColumn(label: Text('Fase PDCA', style: TextStyle(fontWeight: FontWeight.bold))),
                    ],
                    rows: _actions.map((a) => _build5W2HRow(
                          a['what'],
                          a['why'],
                          a['where'],
                          a['when'],
                          a['who'],
                          a['how'],
                          a['howMuch'],
                          a['status'],
                          a['statusColor'],
                          a['pdcaPhase'],
                          a['pdcaColor'],
                        )).toList(),
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                    ElevatedButton.icon(
                      onPressed: () => _showAddWhyDialog(),
                      icon: const Icon(Icons.add, color: Colors.white, size: 16),
                      label: const Text("Adicionar Porquê", style: TextStyle(color: Colors.white)),
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
                ..._whys.map((w) => _buildWhyItem(
                      w['number'],
                      w['question'],
                      w['answer'],
                      isRootCause: w['isRootCause'],
                    )),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // DIÁLOGOS DE INTERATIVIDADE
  void _showAddWhyDialog() {
    final questionCtrl = TextEditingController();
    final answerCtrl = TextEditingController();
    bool isRoot = false;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(builder: (context, setDialogState) {
          return AlertDialog(
            title: const Text("Adicionar Porquê"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: questionCtrl,
                  decoration: const InputDecoration(labelText: "Pergunta (Por que...)"),
                ),
                TextField(
                  controller: answerCtrl,
                  decoration: const InputDecoration(labelText: "Resposta"),
                ),
                CheckboxListTile(
                  title: const Text("É a Causa Raiz?"),
                  value: isRoot,
                  onChanged: (val) => setDialogState(() => isRoot = val ?? false),
                ),
              ],
            ),
            actions: [
              TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancelar")),
              ElevatedButton(
                onPressed: () async {
                  if (questionCtrl.text.isNotEmpty && answerCtrl.text.isNotEmpty) {
                    final newWhy = {
                      "type": "5whys",
                      "number": _whys.length + 1,
                      "question": questionCtrl.text,
                      "answer": answerCtrl.text,
                      "isRootCause": isRoot,
                    };

                    setState(() {
                      _whys.add(newWhy);
                    });

                    final service = Provider.of<DataService>(context, listen: false);
                    await service.addRcaAnalysis(newWhy);

                    if (context.mounted) {
                      Navigator.pop(context);
                    }
                  }
                },
                child: const Text("Salvar", style: TextStyle(color: Colors.white)),
              ),
            ],
          );
        });
      },
    );
  }

  void _showAddActionDialog() {
    final whatCtrl = TextEditingController();
    final whoCtrl = TextEditingController();
    String pdcaPhase = "Plan";

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(builder: (context, setDialogState) {
          return AlertDialog(
            title: const Text("Nova Ação (5W2H)"),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(controller: whatCtrl, decoration: const InputDecoration(labelText: "O Que (What)")),
                  TextField(controller: whoCtrl, decoration: const InputDecoration(labelText: "Quem (Who)")),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    initialValue: pdcaPhase,
                    decoration: const InputDecoration(labelText: "Fase PDCA"),
                    items: const [
                      DropdownMenuItem(value: "Plan", child: Text("Plan")),
                      DropdownMenuItem(value: "Do", child: Text("Do")),
                      DropdownMenuItem(value: "Check", child: Text("Check")),
                      DropdownMenuItem(value: "Act", child: Text("Act")),
                    ],
                    onChanged: (val) => setDialogState(() => pdcaPhase = val ?? "Plan"),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancelar")),
              ElevatedButton(
                onPressed: () {
                  if (whatCtrl.text.isNotEmpty) {
                    setState(() {
                      _actions.add({
                        "what": whatCtrl.text,
                        "why": "Definido em RCA",
                        "where": "Mina",
                        "when": "TBD",
                        "who": whoCtrl.text.isEmpty ? "Não definido" : whoCtrl.text,
                        "how": "Conforme diretrizes",
                        "howMuch": "TBD",
                        "status": "Pendente",
                        "statusColor": AppTheme.alertaCritico,
                        "pdcaPhase": pdcaPhase,
                        "pdcaColor": pdcaPhase == "Plan" ? Colors.blue : (pdcaPhase == "Do" ? Colors.orange : (pdcaPhase == "Check" ? Colors.purple : AppTheme.sucesso)),
                      });
                    });
                    Navigator.pop(context);
                  }
                },
                child: const Text("Salvar", style: TextStyle(color: Colors.white)),
              ),
            ],
          );
        });
      },
    );
  }

  void _showAddIshikawaDialog() {
    final causeCtrl = TextEditingController();
    String category = "Máquina";

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(builder: (context, setDialogState) {
          return AlertDialog(
            title: const Text("Adicionar Causa - Ishikawa"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                DropdownButtonFormField<String>(
                  initialValue: category,
                  decoration: const InputDecoration(labelText: "Categoria (6M)"),
                  items: const [
                    DropdownMenuItem(value: "Máquina", child: Text("Máquina")),
                    DropdownMenuItem(value: "Mão de Obra", child: Text("Mão de Obra")),
                    DropdownMenuItem(value: "Meio Ambiente", child: Text("Meio Ambiente")),
                    DropdownMenuItem(value: "Método", child: Text("Método")),
                    DropdownMenuItem(value: "Medida", child: Text("Medida")),
                    DropdownMenuItem(value: "Material", child: Text("Material")),
                  ],
                  onChanged: (val) => setDialogState(() => category = val ?? "Máquina"),
                ),
                TextField(
                  controller: causeCtrl,
                  decoration: const InputDecoration(labelText: "Descrição da Causa"),
                ),
              ],
            ),
            actions: [
              TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancelar")),
              ElevatedButton(
                onPressed: () async {
                  if (causeCtrl.text.isNotEmpty) {
                    Color color = AppTheme.textoSecundario;
                    if (category == "Mão de Obra") color = AppTheme.alertaCritico;
                    if (category == "Máquina" || category == "Método") color = AppTheme.amareloVale;
                    if (category == "Meio Ambiente") color = AppTheme.verdeEscuro;

                    final newIshikawa = {
                      "type": "ishikawa",
                      "category": category,
                      "cause": causeCtrl.text,
                      "colorValue": color.toARGB32(),
                    };

                    setState(() {
                      _ishikawaCauses.add({
                        "category": category,
                        "cause": causeCtrl.text,
                        "color": color,
                      });
                    });

                    final service = Provider.of<DataService>(context, listen: false);
                    await service.addRcaAnalysis(newIshikawa);

                    if (context.mounted) {
                      Navigator.pop(context);
                    }
                  }
                },
                child: const Text("Salvar", style: TextStyle(color: Colors.white)),
              ),
            ],
          );
        });
      },
    );
  }

  Widget _buildHeatmapCell(String prob, String impact, Color color, String count) {
    return Container(
      height: 80,
      margin: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.black12),
      ),
      child: Center(
        child: Text(
          count,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
      ),
    );
  }

  DataRow _build5W2HRow(String what, String why, String where, String when, String who, String how, String howMuch, String status, Color statusColor, String pdcaPhase, Color pdcaColor) {
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
        DataCell(
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: pdcaColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              pdcaPhase,
              style: const TextStyle(
                color: Colors.white,
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
