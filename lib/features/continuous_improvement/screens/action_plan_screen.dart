import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import '../../../core/app_theme.dart';
import '../../../core/providers/filter_provider.dart';
import '../../../core/services/data_service.dart';

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
    showDialog(
      context: context,
      builder: (BuildContext context) {
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
                  };

                  Navigator.of(context).pop();

                  await service.addActionPlan(newPlan);
                  await _loadData(filter);

                  if (mounted) {
                     scaffoldMessenger.showSnackBar(
                       const SnackBar(content: Text('Plano adicionado e sincronizado com Firestore!')),
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
                ElevatedButton.icon(
                  onPressed: _showAddPlanModal,
                  icon: const FaIcon(FontAwesomeIcons.plus, color: Colors.white),
                  label: const Text("Novo Plano (PDCA)", style: TextStyle(color: Colors.white)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.verdeVale,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),
            Expanded(
              child: _isLoading && _plans.isEmpty
                  ? const Center(child: CircularProgressIndicator())
                  : _plans.isEmpty
                      ? const Center(child: Text("Nenhum plano encontrado para este filtro."))
                      : ListView.builder(
                          itemCount: _plans.length,
                          itemBuilder: (context, index) {
                            final p = _plans[index];
                            return _buildPlanCard(
                              p['title'] ?? '',
                              p['responsible'] ?? '',
                              p['status'] ?? '',
                              (p['progress'] as num?)?.toDouble() ?? 0.0,
                              p['dueDate'] ?? '',
                            );
                          },
                        ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlanCard(String title, String responsible, String status, double progress, String dueDate) {
    Color statusColor = AppTheme.sucesso;
    if (status == "Atrasado") statusColor = AppTheme.alertaCritico;
    if (status == "Em Andamento") statusColor = AppTheme.amareloVale;

    return Card(
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
    );
  }
}
