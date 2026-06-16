import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../core/app_theme.dart';

class IrisEventsScreen extends StatelessWidget {
  const IrisEventsScreen({Key? key}) : super(key: key);

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
                  onPressed: () {},
                ),
              ],
            ),
            const SizedBox(height: 32),
            Expanded(
              child: ListView(
                children: [
                  _buildEventTableRow(
                    "EVT-091",
                    "Telemetria",
                    "Excesso de Velocidade",
                    "Requer 5W2H",
                    AppTheme.alertaCritico,
                  ),
                  _buildEventTableRow(
                    "EVT-092",
                    "DMS",
                    "Micropestanejo Detectado",
                    "Pendente Análise",
                    AppTheme.amareloVale,
                  ),
                  _buildEventTableRow(
                    "EVT-093",
                    "Checklist",
                    "Pneu Careca - V-40",
                    "O.S. Aberta",
                    AppTheme.sucesso,
                  ),
                ],
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
                color: statusColor.withOpacity(0.1),
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
