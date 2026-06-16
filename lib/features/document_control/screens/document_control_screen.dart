import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../core/app_theme.dart';

class DocumentControlScreen extends StatelessWidget {
  const DocumentControlScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Mobilização PNR-000067",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
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
                onPressed: () {},
              ),
            ],
          ),
          const SizedBox(height: 32),
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: _buildDossierPanel(
                    "Condutores (SSMA)",
                    true,
                    FontAwesomeIcons.idCard,
                  ),
                ),
                const SizedBox(width: 32),
                Expanded(
                  child: _buildDossierPanel(
                    "Frota (Selos e Vistorias)",
                    false,
                    FontAwesomeIcons.truck,
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
  ) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              FaIcon(faIconData, color: AppTheme.textoPrincipal),
              const SizedBox(width: 12),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          if (isDriver) ...[
            _buildDocRow(
              "Carlos Mendes",
              "RAC 02 Expira em 5 dias",
              AppTheme.amareloVale,
            ),
            _buildDocRow(
              "Ana Souza",
              "TBSSMA e ASO Regulares",
              AppTheme.sucesso,
            ),
            _buildDocRow("Marcos Silva", "CNH Vencida", AppTheme.alertaCritico),
          ] else ...[
            _buildDocRow(
              "Van V-102",
              "Selo de Inspeção Válido",
              AppTheme.sucesso,
            ),
            _buildDocRow(
              "Ônibus B-300",
              "Pendente Laudo de Emissões",
              AppTheme.amareloVale,
            ),
          ],
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
          Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
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
