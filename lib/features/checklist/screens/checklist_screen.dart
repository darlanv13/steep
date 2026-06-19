import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import '../../../core/app_theme.dart';
import '../../../core/providers/filter_provider.dart';
import '../../../core/services/data_service.dart';

class ChecklistScreen extends StatefulWidget {
  const ChecklistScreen({super.key});

  @override
  State<ChecklistScreen> createState() => _ChecklistScreenState();
}

class _ChecklistScreenState extends State<ChecklistScreen> {
  List<Map<String, dynamic>> _checklists = [];
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
    if (!mounted) return;

    if (_checklists.isEmpty) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) setState(() => _isLoading = true);
        });
    }

    final service = Provider.of<DataService>(context, listen: false);
    final data = await service.getChecklists(filter.shift, filter.fleet);

    if (mounted) {
      setState(() {
        _checklists = data;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width > 800;

    return Padding(
      padding: const EdgeInsets.all(32),
      child: Flex(
        direction: isDesktop ? Axis.horizontal : Axis.vertical,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: isDesktop ? 2 : 0,
            child: Container(
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    "Checklist Veicular (RAC 02)",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 24),

                  if (_isLoading && _checklists.isEmpty)
                    const Center(child: CircularProgressIndicator())
                  else if (_checklists.isEmpty)
                    const Text("Nenhum item de checklist encontrado.")
                  else
                    ...List.generate(_checklists.length, (index) {
                      final c = _checklists[index];
                      return _buildChecklistItem(
                        index,
                        FontAwesomeIcons.check,
                        c['title'] ?? 'Sem Título',
                        c['description'] ?? 'Sem descrição',
                        c['isApproved'] ?? false,
                      );
                    }),

                  const SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.alertaCritico,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      icon: const FaIcon(
                        FontAwesomeIcons.lock,
                        color: Colors.white,
                      ),
                      label: const Text(
                        "Bloquear Veículo & Gerar O.S.",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      onPressed: () {
                         ScaffoldMessenger.of(context).showSnackBar(
                           const SnackBar(content: Text('Comando de bloqueio enviado. O.S. gerada com sucesso!')),
                         );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (isDesktop) const SizedBox(width: 32) else const SizedBox(height: 32),
          Expanded(
            flex: isDesktop ? 1 : 0,
            child: _buildConformidadePainel()
          ),
        ],
      ),
    );
  }

  Widget _buildChecklistItem(
    int index,
    FaIconData icon,
    String title,
    String desc,
    bool isApproved,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: isApproved ? Colors.black12 : AppTheme.alertaCritico.withValues(alpha: 0.5)),
        borderRadius: BorderRadius.circular(12),
        color: isApproved ? Colors.transparent : AppTheme.alertaCritico.withValues(alpha: 0.05),
      ),
      child: Row(
        children: [
          FaIcon(isApproved ? icon : FontAwesomeIcons.triangleExclamation, color: isApproved ? AppTheme.verdeVale : AppTheme.alertaCritico),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Text(
                  desc,
                  style: const TextStyle(
                    color: AppTheme.textoSecundario,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: isApproved,
            activeThumbColor: AppTheme.sucesso,
            inactiveThumbColor: AppTheme.alertaCritico,
            onChanged: (val) {
              setState(() {
                _checklists[index]['isApproved'] = val;
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildConformidadePainel() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppTheme.verdeEscuro,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            "Status do Condutor",
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 24),
          _buildDocStatus("CNH", true),
          _buildDocStatus("ASO Vigente", true),
          _buildDocStatus("TBSSMA", true),
          _buildDocStatus("Proficiência RAC 02", false),
          const SizedBox(height: 24),
          const Text(
            "O bloqueio sistêmico é acionado devido à expiração de treinamentos SSMA.",
            style: TextStyle(color: AppTheme.amareloVale, fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _buildDocStatus(String docName, bool isValid) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(docName, style: const TextStyle(color: Colors.white70)),
          FaIcon(
            isValid
                ? FontAwesomeIcons.circleCheck
                : FontAwesomeIcons.circleXmark,
            color: isValid ? AppTheme.sucesso : AppTheme.alertaCritico,
            size: 18,
          ),
        ],
      ),
    );
  }
}
