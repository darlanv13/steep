import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../core/app_theme.dart';

class ChecklistScreen extends StatelessWidget {
  const ChecklistScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Container(
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Checklist Veicular (RAC 02)",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 24),

                  _buildChecklistItem(
                    FontAwesomeIcons.userGroup,
                    "Lotação Máxima",
                    "Limite de 9 ocupantes verificado?",
                    true,
                  ),
                  _buildChecklistItem(
                    FontAwesomeIcons.shield,
                    "Segurança Passiva",
                    "Cintos de 3 pontos funcionais em todas as posições?",
                    false,
                  ),
                  _buildChecklistItem(
                    FontAwesomeIcons.car,
                    "Sistemas Ativos",
                    "Inspeção tátil de freios e ABS aprovada?",
                    true,
                  ),

                  const Spacer(),
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.alertaCritico,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      icon: const FaIcon(
                        FontAwesomeIcons.lock,
                        color: Colors.white,
                      ),
                      label: const Text(
                        "Bloquear Veículo & Gerar O.S.",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      onPressed: () {},
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 32),
          Expanded(flex: 1, child: _buildConformidadePainel()),
        ],
      ),
    );
  }

  Widget _buildChecklistItem(
    FaIconData icon,
    String title,
    String desc,
    bool isApproved,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black12),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          FaIcon(icon, color: AppTheme.verdeVale),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Text(
                  desc,
                  style: const TextStyle(
                    color: AppTheme.textoSecundario,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: isApproved,
            activeColor: AppTheme.sucesso,
            inactiveThumbColor: AppTheme.alertaCritico,
            onChanged: (val) {},
          ),
        ],
      ),
    );
  }

  Widget _buildConformidadePainel() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppTheme.verdeEscuro,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Status do Condutor",
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 24),
          _buildDocStatus("CNH", true),
          _buildDocStatus("ASO Vigente", true),
          _buildDocStatus("TBSSMA", true),
          _buildDocStatus("Proficiência RAC 02", false),
          const SizedBox(height: 24),
          const Text(
            "O bloqueio sistêmico é acionado devido à expiração de treinamentos SSMA.",
            style: TextStyle(color: AppTheme.amareloVale, fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _buildDocStatus(String docName, bool isValid) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(docName, style: const TextStyle(color: Colors.white70)),
          FaIcon(
            isValid
                ? FontAwesomeIcons.circleCheck
                : FontAwesomeIcons.circleXmark,
            color: isValid ? AppTheme.sucesso : AppTheme.alertaCritico,
            size: 18,
          ),
        ],
      ),
    );
  }
}
