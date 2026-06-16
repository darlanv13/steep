import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import '../../../core/app_theme.dart';
import '../../../core/providers/filter_provider.dart';
import '../../../core/services/data_service.dart';

class DocumentControlScreen extends StatefulWidget {
  const DocumentControlScreen({super.key});

  @override
  State<DocumentControlScreen> createState() => _DocumentControlScreenState();
}

class _DocumentControlScreenState extends State<DocumentControlScreen> {
  List<Map<String, dynamic>> _complianceData = [];
  bool _isLoading = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final filter = Provider.of<FilterProvider>(context, listen: true);
    _loadData(filter);
  }

  Future<void> _loadData(FilterProvider filter) async {
    if (!mounted) return;

    if (_complianceData.isEmpty) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) setState(() => _isLoading = true);
        });
    }

    final service = Provider.of<DataService>(context, listen: false);
    final data = await service.getComplianceData(filter.fleet);

    if (mounted) {
      setState(() {
        _complianceData = data;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width > 800;

    // Separa os dados entre motoristas e veículos baseando-se em um campo 'type' (ex: 'driver' ou 'vehicle')
    final drivers = _complianceData.where((d) => d['type'] == 'driver').toList();
    final vehicles = _complianceData.where((d) => d['type'] == 'vehicle').toList();

    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Flexible(
                child: Text(
                  "Mobilização PNR-000067",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.verdeVale,
                  padding: const EdgeInsets.all(16),
                ),
                icon: const FaIcon(
                  FontAwesomeIcons.rotate,
                  color: Colors.white,
                ),
                label: const Text(
                  "Sincronizar Global Access",
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () {
                   ScaffoldMessenger.of(context).showSnackBar(
                     const SnackBar(content: Text('Sincronização com o sistema Global Access iniciada.')),
                   );
                },
              ),
            ],
          ),
          const SizedBox(height: 32),
          Expanded(
            child: _isLoading && _complianceData.isEmpty
              ? const Center(child: CircularProgressIndicator())
              : Flex(
              direction: isDesktop ? Axis.horizontal : Axis.vertical,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: isDesktop ? 1 : 0,
                  child: _buildDossierPanel(
                    "Condutores (SSMA)",
                    true,
                    FontAwesomeIcons.idCard,
                    drivers,
                  ),
                ),
                if (isDesktop) const SizedBox(width: 32) else const SizedBox(height: 32),
                Expanded(
                  flex: isDesktop ? 1 : 0,
                  child: _buildDossierPanel(
                    "Frota (Selos e Vistorias)",
                    false,
                    FontAwesomeIcons.truck,
                    vehicles,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDossierPanel(
    String title,
    bool isDriver,
    FaIconData faIconData,
    List<Map<String, dynamic>> items,
  ) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              FaIcon(faIconData, color: AppTheme.textoPrincipal),
              const SizedBox(width: 12),
              Flexible(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          if (items.isEmpty)
            const Text("Nenhum dado encontrado para o filtro atual.")
          else
            ...items.map((item) {
                Color c = AppTheme.sucesso;
                if (item['statusColor'] == 'warning') c = AppTheme.amareloVale;
                if (item['statusColor'] == 'critical') c = AppTheme.alertaCritico;
                return _buildDocRow(
                  item['name'] ?? 'Sem Nome',
                  item['status'] ?? 'Sem Status',
                  c,
                );
            }),
        ],
      ),
    );
  }

  Widget _buildDocRow(String name, String status, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black12),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: Text(name, style: const TextStyle(fontWeight: FontWeight.bold), overflow: TextOverflow.ellipsis),
          ),
          const SizedBox(width: 8),
          Row(
            children: [
              Text(
                status,
                style: TextStyle(
                  color: color,
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 12),
              FaIcon(
                FontAwesomeIcons.circleExclamation,
                color: color,
                size: 16,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
