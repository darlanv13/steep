import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../core/app_theme.dart';

class MainLayout extends StatelessWidget {
  final Widget child;

  const MainLayout({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          // Menu Lateral
          Container(
            width: 280,
            color: AppTheme.verdeVale,
            child: Column(
              children: [
                const SizedBox(height: 50),
                const FaIcon(
                  FontAwesomeIcons.shieldHalved,
                  color: AppTheme.amareloVale,
                  size: 48,
                ),
                const SizedBox(height: 16),
                const Text(
                  "SGSV Mineração",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 40),

                _buildMenuItem(
                  FontAwesomeIcons.chartLine,
                  "Painel Executivo (BI)",
                  true,
                ),
                _buildMenuItem(
                  FontAwesomeIcons.route,
                  "Rotogramas e Cercas",
                  false,
                ),
                _buildMenuItem(
                  FontAwesomeIcons.clipboardCheck,
                  "Inspeção Pré-Uso",
                  false,
                ),
                _buildMenuItem(
                  FontAwesomeIcons.idCardClip,
                  "Controle Documental",
                  false,
                ),
                _buildMenuItem(
                  FontAwesomeIcons.towerBroadcast,
                  "Eventos IRIS",
                  false,
                ),
              ],
            ),
          ),

          // Área de Conteúdo
          Expanded(
            child: Column(
              children: [
                // TopBar
                Container(
                  height: 80,
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    border: Border(bottom: BorderSide(color: Colors.black12)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Visão Geral da Operação",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.textoPrincipal,
                        ),
                      ),
                      Row(
                        children: [
                          IconButton(
                            icon: const FaIcon(
                              FontAwesomeIcons.bell,
                              color: AppTheme.verdeVale,
                            ),
                            onPressed: () {},
                          ),
                          const SizedBox(width: 16),
                          const CircleAvatar(
                            backgroundColor: AppTheme.verdeEscuro,
                            child: FaIcon(
                              FontAwesomeIcons.userShield,
                              color: Colors.white,
                              size: 18,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Conteúdo Injetado (Telas)
                Expanded(child: child),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem(FaIconData faIconData, String title, bool isActive) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isActive ? AppTheme.verdeEscuro : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: FaIcon(faIconData),
        title: Text(
          title,
          style: TextStyle(
            color: isActive ? Colors.white : Colors.white70,
            fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        onTap: () {}, // Aqui futuramente você gerencia a navegação
      ),
    );
  }
}
