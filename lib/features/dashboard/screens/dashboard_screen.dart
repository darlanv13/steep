import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../core/app_theme.dart';
import '../widgets/animated_status_card.dart';
import '../widgets/critical_alert_trigger.dart';
import '../../dms_monitoring/widgets/dms_evidence_gallery.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Pegando a largura da tela para ajustes responsivos
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth > 1100; // Ponto de quebra para layout web

    return SingleChildScrollView(
      padding: const EdgeInsets.all(32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Layout Responsivo: Wrap no lugar de Row pura para não estourar lateralmente
          Wrap(
            spacing: 24,
            runSpacing: 24,
            children: [
              _buildResponsiveKpiCard(
                context: context,
                title: "Infrações de Telemetria",
                value: "1.2%",
                icon: FontAwesomeIcons.gaugeHigh,
                color: AppTheme.alertaCritico,
                subtitle: "Quebra de limites (RAC 02)",
              ),
              _buildResponsiveKpiCard(
                context: context,
                title: "Ocorrências DMS",
                value: "0.05",
                icon: FontAwesomeIcons.eyeLowVision,
                color: AppTheme.amareloVale,
                subtitle: "Fadiga a cada 1000km",
              ),
              _buildResponsiveKpiCard(
                context: context,
                title: "MTBF",
                value: "450h",
                icon: FontAwesomeIcons.screwdriverWrench,
                color: AppTheme.sucesso,
                subtitle: "Tempo livre de quebras",
              ),
            ],
          ),
          const SizedBox(height: 32),

          // Ajuste de grid flexível
          Flex(
            direction: isDesktop ? Axis.horizontal : Axis.vertical,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: isDesktop ? 2 : 0,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Monitoramento em Tempo Real",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    const AnimatedStatusCard(
                      driverName: "João Silva",
                      vehicleId: "V-102",
                    ),
                    const AnimatedStatusCard(
                      driverName: "Carlos Mendes",
                      vehicleId: "V-205",
                    ),
                    const SizedBox(height: 24),
                    const CriticalAlertTrigger(),
                  ],
                ),
              ),
              if (isDesktop)
                const SizedBox(width: 32)
              else
                const SizedBox(height: 32),
              Expanded(
                flex: isDesktop ? 1 : 0,
                child: const Column(children: [DmsEvidenceGallery()]),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildResponsiveKpiCard({
    required BuildContext context,
    required String title,
    required String value,
    required FaIconData icon,
    required Color color,
    required String subtitle,
  }) {
    // Calcula uma largura baseada no tamanho da tela (aprox. 3 colunas em monitores grandes, 1 ou 2 em menores)
    double width = MediaQuery.of(context).size.width;
    double cardWidth = width > 1100
        ? (width - 360 - 48) / 3
        : (width > 800 ? (width - 340) / 2 : width);

    return Container(
      width: cardWidth,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppTheme.cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border(left: BorderSide(color: color, width: 4)),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Text(
                  title,
                  style: const TextStyle(
                    color: AppTheme.textoSecundario,
                    fontWeight: FontWeight.w600,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              FaIcon(icon, color: color, size: 20),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            value,
            style: const TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: AppTheme.textoPrincipal,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            style: const TextStyle(
              fontSize: 12,
              color: AppTheme.textoSecundario,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
