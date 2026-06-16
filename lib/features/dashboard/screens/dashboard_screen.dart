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
    return SingleChildScrollView(
      padding: const EdgeInsets.all(32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Linha de KPIs
          Row(
            children: [
              Expanded(
                child: _buildKpiCard(
                  title: "Infrações de Telemetria",
                  value: "1.2%",
                  icon: FontAwesomeIcons.gaugeHigh,
                  color: AppTheme.alertaCritico,
                  subtitle: "Quebra de limites (RAC 02)",
                ),
              ),
              const SizedBox(width: 24),
              Expanded(
                child: _buildKpiCard(
                  title: "Ocorrências DMS",
                  value: "0.05",
                  icon: FontAwesomeIcons.eyeLowVision,
                  color: AppTheme.amareloVale,
                  subtitle: "Fadiga a cada 1000km",
                ),
              ),
              const SizedBox(width: 24),
              Expanded(
                child: _buildKpiCard(
                  title: "MTBF",
                  value: "450h",
                  icon: FontAwesomeIcons.screwdriverWrench,
                  color: AppTheme.sucesso,
                  subtitle: "Tempo livre de quebras",
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),

          // Integração dos Widgets Dinâmicos
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 2,
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
                    const CriticalAlertTrigger(), // Botão de simulação de alerta crítico
                  ],
                ),
              ),
              const SizedBox(width: 32),
              Expanded(
                flex: 1,
                child: Column(
                  children: [
                    const DmsEvidenceGallery(), // Galeria de evidências fotográficas
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildKpiCard({
    required String title,
    required String value,
    required FaIconData icon,
    required Color color,
    required String subtitle,
  }) {
    return Container(
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
              Text(
                title,
                style: const TextStyle(
                  color: AppTheme.textoSecundario,
                  fontWeight: FontWeight.w600,
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
          ),
        ],
      ),
    );
  }
}
