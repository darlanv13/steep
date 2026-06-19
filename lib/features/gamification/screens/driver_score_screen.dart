import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:steep/core/app_theme.dart';

class DriverScoreScreen extends StatelessWidget {
  const DriverScoreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Score de Comportamento e Premiação",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 32),
          Expanded(
            child: Row(
              children: [
                // Coluna Esquerda: Pódio e Badges
                Expanded(
                  flex: 1,
                  child: Column(
                    children: [
                      // Pódio
                      Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: AppTheme.verdeEscuro,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          children: [
                            const FaIcon(
                              FontAwesomeIcons.trophy,
                              color: AppTheme.amareloVale,
                              size: 48,
                            ),
                            const SizedBox(height: 16),
                            const Text(
                              "Destaques do Mês",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 32),
                            _buildPodiumDriver(
                              "1º Ana Souza",
                              "98.5 pts",
                              AppTheme.amareloVale,
                            ),
                            _buildPodiumDriver(
                              "2º João Silva",
                              "95.0 pts",
                              Colors.grey[300]!,
                            ),
                            _buildPodiumDriver(
                              "3º Carlos Mendes",
                              "91.2 pts",
                              const Color(0xFFCD7F32),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 32),
                      // Badges/Conquistas
                      Expanded(
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Row(
                                children: [
                                  FaIcon(FontAwesomeIcons.award, color: AppTheme.verdeVale),
                                  SizedBox(width: 12),
                                  Text(
                                    "Badges de Qualidade (RCA)",
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 24),
                              Expanded(
                                child: ListView(
                                  children: [
                                    _buildBadgeItem(
                                      "Xerife da Qualidade",
                                      "Participou ativamente de 5 análises Ishikawa/5 Porquês neste mês.",
                                      FontAwesomeIcons.shieldHalved,
                                      AppTheme.amareloVale,
                                    ),
                                    _buildBadgeItem(
                                      "Mestre do Prazo",
                                      "Concluiu 100% dos Planos de Ação (PDCA) dentro do prazo.",
                                      FontAwesomeIcons.stopwatch,
                                      AppTheme.sucesso,
                                    ),
                                    _buildBadgeItem(
                                      "Olho de Águia",
                                      "Identificou e registrou 10 anomalias no DMS preventivamente.",
                                      FontAwesomeIcons.eye,
                                      Colors.purple,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 32),
                // Ranking Geral
                Expanded(
                  flex: 2,
                  child: Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: ListView(
                      children: [
                        const Text(
                          "Ranking Operacional da Frota",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 24),
                        _buildRankingRow("Ana Souza", "100%", "0", "0", 98.5),
                        _buildRankingRow("João Silva", "100%", "1", "0", 95.0),
                        _buildRankingRow(
                          "Marcos Paulo",
                          "80%",
                          "4",
                          "2",
                          72.0,
                          isAtRisk: true,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBadgeItem(String title, String desc, FaIconData icon, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: color,
            child: FaIcon(icon, color: Colors.white, size: 16),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: TextStyle(fontWeight: FontWeight.bold, color: color)),
                const SizedBox(height: 4),
                Text(desc, style: const TextStyle(fontSize: 12, color: AppTheme.textoSecundario)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPodiumDriver(String name, String score, Color medalColor) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white10,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            name,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          Row(
            children: [
              Text(
                score,
                style: TextStyle(
                  color: medalColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 8),
              FaIcon(FontAwesomeIcons.medal, color: medalColor, size: 16),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRankingRow(
    String name,
    String chk,
    String telemetria,
    String dms,
    double score, {
    bool isAtRisk = false,
  }) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              flex: 2,
              child: Text(
                name,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            Expanded(
              child: Column(
                children: [
                  const FaIcon(FontAwesomeIcons.clipboardCheck, size: 14),
                  Text(chk),
                ],
              ),
            ),
            Expanded(
              child: Column(
                children: [
                  const FaIcon(FontAwesomeIcons.gaugeHigh, size: 14),
                  Text(telemetria),
                ],
              ),
            ),
            Expanded(
              child: Column(
                children: [
                  const FaIcon(FontAwesomeIcons.eye, size: 14),
                  Text(dms),
                ],
              ),
            ),
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 4),
                decoration: BoxDecoration(
                  color: isAtRisk
                      ? AppTheme.alertaCritico.withValues(alpha: 0.1)
                      : AppTheme.sucesso.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(16),
                ),
                alignment: Alignment.center,
                child: Text(
                  "$score",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: isAtRisk ? AppTheme.alertaCritico : AppTheme.sucesso,
                  ),
                ),
              ),
            ),
          ],
        ),
        const Divider(height: 24),
      ],
    );
  }
}
