import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../core/app_theme.dart';

class InterlockHistoryScreen extends StatelessWidget {
  const InterlockHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Auditoria de Interlock (Ignição Etílica)",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 24),
          // Filtros
          Row(
            children: [
              Expanded(child: _buildFilterInput("Data Inicial")),
              const SizedBox(width: 16),
              Expanded(child: _buildFilterInput("Data Final")),
              const SizedBox(width: 16),
              Expanded(child: _buildFilterInput("Matrícula Condutor")),
              const SizedBox(width: 16),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.verdeVale,
                  padding: const EdgeInsets.all(20),
                ),
                onPressed: () {},
                child: const FaIcon(
                  FontAwesomeIcons.magnifyingGlass,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),
          // Tabela de Histórico
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: ListView(
                children: [
                  _buildInterlockRow(
                    "15/06/2026 06:15",
                    "João Silva",
                    "V-102",
                    "0,00 mg/L",
                    true,
                  ),
                  _buildInterlockRow(
                    "15/06/2026 06:22",
                    "Carlos Mendes",
                    "V-205",
                    "0,15 mg/L",
                    false,
                  ),
                  _buildInterlockRow(
                    "15/06/2026 06:30",
                    "Ana Souza",
                    "V-310",
                    "0,00 mg/L",
                    true,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterInput(String hint) {
    return TextField(
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget _buildInterlockRow(
    String date,
    String driver,
    String vehicle,
    String cas,
    bool passed,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border(
          left: BorderSide(
            color: passed ? AppTheme.sucesso : AppTheme.alertaCritico,
            width: 4,
          ),
        ),
        color: AppTheme.background,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              date,
              style: const TextStyle(color: AppTheme.textoSecundario),
            ),
          ),
          Expanded(
            child: Text(
              driver,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(child: Text(vehicle)),
          Expanded(
            child: Row(
              children: [
                FaIcon(
                  FontAwesomeIcons.wineGlassEmpty,
                  size: 16,
                  color: passed ? AppTheme.sucesso : AppTheme.alertaCritico,
                ),
                const SizedBox(width: 8),
                Text(
                  cas,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: passed ? AppTheme.sucesso : AppTheme.alertaCritico,
                  ),
                ),
              ],
            ),
          ),
          FaIcon(
            passed ? FontAwesomeIcons.circleCheck : FontAwesomeIcons.lock,
            color: passed ? AppTheme.sucesso : AppTheme.alertaCritico,
          ),
        ],
      ),
    );
  }
}
