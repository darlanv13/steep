import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CriticalAlertTrigger extends StatelessWidget {
  const CriticalAlertTrigger({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFE74C3C),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        icon: const FaIcon(
          FontAwesomeIcons.triangleExclamation,
          color: Colors.white,
        ),
        label: const Text(
          "Simular Violação de Cerca (Geofence)",
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
        onPressed: () => _showCriticalDialog(context),
      ),
    );
  }

  void _showCriticalDialog(BuildContext context) {
    showGeneralDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black.withValues(alpha: 0.8),
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (context, animation, secondaryAnimation) {
        return ScaleTransition(
          scale: CurveTween(curve: Curves.easeOutBack).animate(animation),
          child: AlertDialog(
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            title: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE74C3C).withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const FaIcon(
                    FontAwesomeIcons.carBurst,
                    color: Color(0xFFE74C3C),
                    size: 28,
                  ),
                ),
                const SizedBox(width: 16),
                const Expanded(
                  child: Text(
                    "Anomalia Grave Detectada",
                    style: TextStyle(
                      color: Color(0xFFE74C3C),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            content: const Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Veículo leve V-205 violou o limite de velocidade na Rampa Sul da cava principal.",
                  style: TextStyle(fontSize: 16, color: Color(0xFF2C3E50)),
                ),
                SizedBox(height: 16),
                Text(
                  "Ação Imediata Necessária:",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2C3E50),
                  ),
                ),
                Text(
                  "É obrigatório registrar uma Não Conformidade e gerar o Plano de Ação 5W2H para liberação.",
                  style: TextStyle(color: Color(0xFF7F8C8D)),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text(
                  "Acompanhar Rota",
                  style: TextStyle(color: Color(0xFF7F8C8D)),
                ),
              ),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF007A53),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                icon: const FaIcon(
                  FontAwesomeIcons.fileSignature,
                  color: Colors.white,
                  size: 16,
                ),
                label: const Text(
                  "Abrir Plano de Ação",
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
