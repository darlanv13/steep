import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import '../../../core/app_theme.dart';
import '../../../core/providers/filter_provider.dart';
import '../../../core/services/data_service.dart';
import '../../../core/services/pdf_service.dart';

class ActionPlanScreen extends StatefulWidget {
  const ActionPlanScreen({super.key});

  @override
  State<ActionPlanScreen> createState() => _ActionPlanScreenState();
}

class _ActionPlanScreenState extends State<ActionPlanScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _respController = TextEditingController();

  List<Map<String, dynamic>> _plans = [];
  bool _isLoading = true;
  bool _isKanbanView = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final filter = Provider.of<FilterProvider>(context, listen: true);
    _loadData(filter);
  }

  Future<void> _loadData(FilterProvider filter) async {
    // Avoid setting state if the widget was disposed
    if (!mounted) return;

    // We only set loading if we don't already have plans to prevent flashing, or if it's the first load
    if (_plans.isEmpty) {
        // Can't set state during build phase, and didChangeDependencies could be called during build
        WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) setState(() => _isLoading = true);
        });
    }

    final service = Provider.of<DataService>(context, listen: false);

    final data = await service.getActionPlans(filter.shift, filter.fleet, filter.period);

    if (mounted) {
      setState(() {
        _plans = data;
        _isLoading = false;
      });
    }
  }

  void _showAddPlanModal() {
    String selectedPdcaPhase = "Plan";

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (context, setDialogState) {
          return AlertDialog(
            title: const Text("Novo Plano de Ação (PDCA)"),
            content: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: _titleController,
                    decoration: const InputDecoration(labelText: "Título da Ação"),
                    validator: (v) => v!.isEmpty ? "Campo obrigatório" : null,
                  ),
                  TextFormField(
                    controller: _respController,
                    decoration: const InputDecoration(labelText: "Responsável"),
                    validator: (v) => v!.isEmpty ? "Campo obrigatório" : null,
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    initialValue: selectedPdcaPhase,
                    decoration: const InputDecoration(labelText: "Fase PDCA Inicial"),
                    items: const [
                      DropdownMenuItem(value: "Plan", child: Text("Plan")),
                      DropdownMenuItem(value: "Do", child: Text("Do")),
                      DropdownMenuItem(value: "Check", child: Text("Check")),
                      DropdownMenuItem(value: "Act", child: Text("Act")),
                    ],
                    onChanged: (val) {
                      if (val != null) setDialogState(() => selectedPdcaPhase = val);
                    },
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text("Cancelar"),
              ),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    final filter = Provider.of<FilterProvider>(context, listen: false);
                    final service = Provider.of<DataService>(context, listen: false);
                    final scaffoldMessenger = ScaffoldMessenger.of(context);

                    final newPlan = {
                      'title': _titleController.text,
                      'responsible': _respController.text,
                      'status': 'Em Andamento',
                      'progress': 0.0,
                      'dueDate': 'A Definir',
                      'fleet': filter.fleet,
                      'shift': filter.shift,
                      'pdcaPhase': selectedPdcaPhase,
                      'evidences': <String>[],
                      'studies': <String>[],
                    };

                    Navigator.of(context).pop();

                    await service.addActionPlan(newPlan);
                    await _loadData(filter);

                    if (mounted) {
                       scaffoldMessenger.showSnackBar(
                         const SnackBar(content: Text('Plano adicionado com sucesso!')),
                       );
                    }

                    _titleController.clear();
                    _respController.clear();
                  }
                },
                child: const Text("Salvar"),
              ),
            ],
          );
        });
      },
    );
  }

  void _showPlanDetailsModal(Map<String, dynamic> plan) {
    // Para simplificar a demonstração, gerenciamos o estado mock localmente.
    // Em produção isso faria um PUT/Update via DataService.
    List<String> evidences = plan['evidences'] != null ? List<String>.from(plan['evidences']) : [];
    List<String> studies = plan['studies'] != null ? List<String>.from(plan['studies']) : [];
    List<String> history = plan['history'] != null ? List<String>.from(plan['history']) : [
      "[${DateTime.now().subtract(const Duration(days: 2)).toString().substring(0, 16)}] Plano Criado",
    ];
    double currentProgress = (plan['progress'] ?? 0.0) as double;
    String currentPhase = plan['pdcaPhase'] ?? 'Plan';

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (context, setDialogState) {
          return AlertDialog(
            title: Text("Detalhes do Plano: ${plan['title']}"),
            content: SizedBox(
              width: 600,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text("Responsável: ${plan['responsible']}", style: const TextStyle(fontWeight: FontWeight.bold)),
                    Text("Status Atual: ${plan['status']}"),
                    const SizedBox(height: 16),
                    const Text("Fase PDCA Atual", style: TextStyle(fontWeight: FontWeight.bold)),
                    DropdownButton<String>(
                      value: currentPhase,
                      isExpanded: true,
                      items: const [
                        DropdownMenuItem(value: "Plan", child: Text("Plan")),
                        DropdownMenuItem(value: "Do", child: Text("Do")),
                        DropdownMenuItem(value: "Check", child: Text("Check")),
                        DropdownMenuItem(value: "Act", child: Text("Act")),
                      ],
                      onChanged: (val) {
                        if (val != null && val != currentPhase) {
                          setDialogState(() {
                            currentPhase = val;
                            history.insert(0, "[${DateTime.now().toString().substring(0, 16)}] Fase alterada para $val");
                          });
                        }
                      },
                    ),
                    const SizedBox(height: 16),
                    Text("Evolução do Progresso: ${(currentProgress * 100).toInt()}%", style: const TextStyle(fontWeight: FontWeight.bold)),
                    Slider(
                      value: currentProgress,
                      min: 0,
                      max: 1,
                      divisions: 10,
                      activeColor: AppTheme.verdeVale,
                      onChangeEnd: (val) {
                         setDialogState(() {
                           history.insert(0, "[${DateTime.now().toString().substring(0, 16)}] Progresso alterado para ${(val * 100).toInt()}%");
                         });
                      },
                      onChanged: (val) {
                        setDialogState(() => currentProgress = val);
                      },
                    ),
                    const Divider(height: 32),
                    const Text("Evidências (Anexos Reais)", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    const SizedBox(height: 8),
                    ...evidences.map((e) => ListTile(
                          leading: const FaIcon(FontAwesomeIcons.image, size: 16, color: AppTheme.verdeEscuro),
                          title: Text(e, style: const TextStyle(fontSize: 12)),
                        )),
                    ElevatedButton.icon(
                      onPressed: () async {
                        final picker = ImagePicker();
                        final pickedFile = await picker.pickImage(source: ImageSource.gallery);
                        if (pickedFile != null) {
                          setDialogState(() {
                            evidences.add(pickedFile.name);
                            history.insert(0, "[${DateTime.now().toString().substring(0, 16)}] Evidência anexada: ${pickedFile.name}");
                          });
                        }
                      },
                      icon: const Icon(Icons.upload_file, size: 16),
                      label: const Text("Buscar da Galeria"),
                    ),
                    const Divider(height: 32),
                    const Text("Estudos e Falhas Associados (RCA)", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    const SizedBox(height: 8),
                    ...studies.map((s) => ListTile(
                          leading: const FaIcon(FontAwesomeIcons.fileContract, size: 16, color: AppTheme.amareloVale),
                          title: Text(s, style: const TextStyle(fontSize: 12)),
                        )),
                    ElevatedButton.icon(
                      onPressed: () {
                        setDialogState(() {
                          final newStudy = "Análise Ishikawa / 5 Porquês - #${DateTime.now().minute}";
                          studies.add(newStudy);
                          history.insert(0, "[${DateTime.now().toString().substring(0, 16)}] Estudo vinculado: $newStudy");
                        });
                      },
                      icon: const Icon(Icons.link, size: 16),
                      label: const Text("Vincular Estudo"),
                    ),
                    const Divider(height: 32),
                    const Text("Linha do Tempo (Histórico)", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    const SizedBox(height: 8),
                    Container(
                      height: 120,
                      decoration: BoxDecoration(
                        color: AppTheme.background,
                        border: Border.all(color: Colors.black12),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: ListView.builder(
                        itemCount: history.length,
                        itemBuilder: (context, idx) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            child: Row(
                              children: [
                                const Icon(Icons.history, size: 12, color: AppTheme.textoSecundario),
                                const SizedBox(width: 8),
                                Expanded(child: Text(history[idx], style: const TextStyle(fontSize: 12, color: AppTheme.textoPrincipal))),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () async {
                   // Adicionamos os dados reais do plano que devem ser exportados (simulando que estão no DB)
                   plan['pdcaPhase'] = currentPhase;
                   plan['progress'] = currentProgress;
                   plan['evidences'] = evidences;
                   plan['studies'] = studies;
                   plan['history'] = history;

                   await PdfService.generateActionPlanReport(plan);
                },
                child: const Text("Exportar Dossiê do Plano (PDF)", style: TextStyle(color: AppTheme.verdeVale)),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Fechar"),
              ),
              ElevatedButton(
                onPressed: () async {
                  final service = Provider.of<DataService>(context, listen: false);
                  final planId = plan['id'];

                  setState(() {
                    final planIndex = _plans.indexWhere((p) => p['id'] == planId);
                    if (planIndex != -1) {
                      _plans[planIndex]['pdcaPhase'] = currentPhase;
                      _plans[planIndex]['progress'] = currentProgress;
                      _plans[planIndex]['evidences'] = evidences;
                      _plans[planIndex]['studies'] = studies;
                      _plans[planIndex]['history'] = history;
                    }
                  });

                  if (planId != null) {
                    await service.updateActionPlan(planId, {
                      'pdcaPhase': currentPhase,
                      'progress': currentProgress,
                      'evidences': evidences,
                      'studies': studies,
                      'history': history,
                    });
                  }

                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Evolução salva com sucesso!")));
                    Navigator.pop(context);
                  }
                },
                child: const Text("Salvar Evolução"),
              ),
            ],
          );
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Container(
        padding: const EdgeInsets.all(32),
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
                const Text(
                  "Acompanhamento de Planos de Ação (RCA & Inspeções)",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        setState(() {
                          _isKanbanView = !_isKanbanView;
                        });
                      },
                      icon: FaIcon(_isKanbanView ? FontAwesomeIcons.list : FontAwesomeIcons.tableColumns, color: AppTheme.verdeVale),
                      tooltip: _isKanbanView ? "Mudar para Lista" : "Mudar para Kanban",
                    ),
                    const SizedBox(width: 16),
                    ElevatedButton.icon(
                      onPressed: _showAddPlanModal,
                      icon: const FaIcon(FontAwesomeIcons.plus, color: Colors.white, size: 16),
                      label: const Text("Novo Plano (PDCA)", style: TextStyle(color: Colors.white)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.verdeVale,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 32),
            Expanded(
              child: _isLoading && _plans.isEmpty
                  ? const Center(child: CircularProgressIndicator())
                  : _plans.isEmpty
                      ? const Center(child: Text("Nenhum plano encontrado para este filtro."))
                      : _isKanbanView
                          ? _buildKanbanBoard()
                          : ListView.builder(
                              itemCount: _plans.length,
                              itemBuilder: (context, index) {
                                final p = _plans[index];
                                return _buildPlanCard(p);
                              },
                            ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildKanbanBoard() {
    final planItems = _plans.where((p) => p['pdcaPhase'] == 'Plan').toList();
    final doItems = _plans.where((p) => p['pdcaPhase'] == 'Do').toList();
    final checkItems = _plans.where((p) => p['pdcaPhase'] == 'Check').toList();
    final actItems = _plans.where((p) => p['pdcaPhase'] == 'Act').toList();

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: _buildKanbanColumn("Plan", Colors.blue, planItems)),
        const SizedBox(width: 16),
        Expanded(child: _buildKanbanColumn("Do", Colors.orange, doItems)),
        const SizedBox(width: 16),
        Expanded(child: _buildKanbanColumn("Check", Colors.purple, checkItems)),
        const SizedBox(width: 16),
        Expanded(child: _buildKanbanColumn("Act", AppTheme.sucesso, actItems)),
      ],
    );
  }

  Widget _buildKanbanColumn(String title, Color color, List<Map<String, dynamic>> items) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppTheme.background,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.black12),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            width: double.infinity,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: color.withValues(alpha: 0.5)),
            ),
            child: Text(
              "$title (${items.length})",
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.bold, color: color),
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              itemCount: items.length,
              itemBuilder: (context, index) {
                return _buildPlanCard(items[index]);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlanCard(Map<String, dynamic> plan) {
    final title = plan['title'] ?? '';
    final responsible = plan['responsible'] ?? '';
    final status = plan['status'] ?? '';
    final progress = (plan['progress'] ?? 0.0) as double;
    final dueDate = plan['dueDate'] ?? '';
    final pdcaPhase = plan['pdcaPhase'] ?? 'Plan';

    Color statusColor = AppTheme.sucesso;
    if (status == "Atrasado") statusColor = AppTheme.alertaCritico;
    if (status == "Em Andamento") statusColor = AppTheme.amareloVale;

    Color pdcaColor = Colors.blue;
    if (pdcaPhase == "Do") pdcaColor = Colors.orange;
    if (pdcaPhase == "Check") pdcaColor = Colors.purple;
    if (pdcaPhase == "Act") pdcaColor = AppTheme.sucesso;

    return InkWell(
      onTap: () => _showPlanDetailsModal(plan),
      child: Card(
        elevation: 0,
        margin: const EdgeInsets.only(bottom: 16),
        shape: RoundedRectangleBorder(
          side: const BorderSide(color: Colors.black12),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      title,
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(right: 8),
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: pdcaColor,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      pdcaPhase,
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: statusColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      status,
                      style: TextStyle(color: statusColor, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  const FaIcon(FontAwesomeIcons.userTag, size: 16, color: AppTheme.textoSecundario),
                  const SizedBox(width: 8),
                  Text("Resp: $responsible", style: const TextStyle(color: AppTheme.textoSecundario)),
                  const SizedBox(width: 24),
                  const FaIcon(FontAwesomeIcons.calendarDay, size: 16, color: AppTheme.textoSecundario),
                  const SizedBox(width: 8),
                  Text("Prazo: $dueDate", style: const TextStyle(color: AppTheme.textoSecundario)),
                ],
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Text("${(progress * 100).toInt()}% Concluído", style: const TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(width: 16),
                  Expanded(
                    child: LinearProgressIndicator(
                      value: progress,
                      backgroundColor: Colors.black12,
                      color: statusColor,
                      minHeight: 8,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
