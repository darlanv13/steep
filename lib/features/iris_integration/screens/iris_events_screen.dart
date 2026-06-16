import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import '../../../core/app_theme.dart';
import '../../../core/services/data_service.dart';

class IrisEventsScreen extends StatefulWidget {
  const IrisEventsScreen({super.key});

  @override
  State<IrisEventsScreen> createState() => _IrisEventsScreenState();
}

class _IrisEventsScreenState extends State<IrisEventsScreen> {
  List<Map<String, dynamic>> _events = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    if (!mounted) return;

    final service = Provider.of<DataService>(context, listen: false);
    final data = await service.getIrisEvents();

    if (mounted) {
      setState(() {
        _events = data;
        _isLoading = false;
      });
    }
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
                  "Eventos Pendentes de Exportação (IRIS)",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.textoPrincipal,
                    padding: const EdgeInsets.all(16),
                  ),
                  icon: const FaIcon(
                    FontAwesomeIcons.fileExport,
                    color: Colors.white,
                  ),
                  label: const Text(
                    "Exportar Lote Criptografado",
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () {
                     ScaffoldMessenger.of(context).showSnackBar(
                       const SnackBar(content: Text('Exportação criptografada iniciada com sucesso!')),
                     );
                  },
                ),
              ],
            ),
            const SizedBox(height: 32),
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _events.isEmpty
                      ? const Center(child: Text("Nenhum evento IRIS pendente."))
                      : ListView.builder(
                          itemCount: _events.length,
                          itemBuilder: (context, index) {
                            final e = _events[index];
                            Color c = AppTheme.amareloVale;
                            if (e['severity'] == 'high') c = AppTheme.alertaCritico;
                            if (e['severity'] == 'low') c = AppTheme.sucesso;

                            return _buildEventTableRow(
                              e['id'] ?? 'EVT-???',
                              e['type'] ?? 'Desconhecido',
                              e['description'] ?? 'Sem descrição',
                              e['action'] ?? 'Pendente',
                              c,
                            );
                          },
                        ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEventTableRow(
    String id,
    String tipo,
    String descricao,
    String acao,
    Color statusColor,
  ) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        side: const BorderSide(color: Colors.black12),
        borderRadius: BorderRadius.circular(8),
      ),
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: statusColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                id,
                style: TextStyle(
                  color: statusColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(width: 24),
            Expanded(
              flex: 1,
              child: Text(
                tipo,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            Expanded(
              flex: 2,
              child: Text(
                descricao,
                style: const TextStyle(color: AppTheme.textoSecundario),
              ),
            ),
            Expanded(
              flex: 1,
              child: Text(
                acao,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            OutlinedButton(
              onPressed: () {},
              child: const Text(
                "Abrir 5W2H",
                style: TextStyle(color: AppTheme.verdeVale),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
