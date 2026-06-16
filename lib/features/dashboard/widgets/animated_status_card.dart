import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class AnimatedStatusCard extends StatefulWidget {
  final String driverName;
  final String vehicleId;

  const AnimatedStatusCard({super.key,
    required this.driverName,
    required this.vehicleId,
  });

  @override
  State<AnimatedStatusCard> createState() => _AnimatedStatusCardState();
}

class _AnimatedStatusCardState extends State<AnimatedStatusCard> {
  bool isCompliant = true;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          isCompliant = !isCompliant;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
        margin: const EdgeInsets.symmetric(vertical: 8.0),
        padding: const EdgeInsets.all(20.0),
        decoration: BoxDecoration(
          color: isCompliant ? Colors.white : const Color(0xFFFDECEA),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isCompliant
                ? const Color(0xFF27AE60)
                : const Color(0xFFE74C3C),
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              transitionBuilder: (Widget child, Animation<double> animation) {
                return ScaleTransition(scale: animation, child: child);
              },
              child: FaIcon(
                isCompliant
                    ? FontAwesomeIcons.circleCheck
                    : FontAwesomeIcons.triangleExclamation,
                key: ValueKey<bool>(isCompliant),
                color: isCompliant
                    ? const Color(0xFF27AE60)
                    : const Color(0xFFE74C3C),
                size: 32,
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Condutor: ${widget.driverName} | ${widget.vehicleId}",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Color(0xFF2C3E50),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    isCompliant
                        ? "Interlock liberado. Telemetria normal."
                        : "Falha Crítica. Partida bloqueada.",
                    style: TextStyle(
                      color: isCompliant
                          ? const Color(0xFF7F8C8D)
                          : const Color(0xFFE74C3C),
                      fontWeight: isCompliant
                          ? FontWeight.normal
                          : FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
