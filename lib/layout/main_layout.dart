import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../core/app_theme.dart';
import '../features/dashboard/screens/dashboard_screen.dart';
import '../features/quality_analysis/screens/advanced_quality_screen.dart';

class MainLayout extends StatefulWidget {
  const MainLayout({Key? key}) : super(key: key);

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const DashboardScreen(),
    const Center(child: Text("Rotogramas e Cercas (Em desenvolvimento)")),
    const Center(child: Text("Inspeção Pré-Uso (Em desenvolvimento)")),
    const Center(child: Text("Controle Documental (Em desenvolvimento)")),
    const Center(child: Text("Eventos IRIS (Em desenvolvimento)")),
    const AdvancedQualityScreen(),
  ];

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
                  0,
                  FontAwesomeIcons.chartLine,
                  "Painel Executivo (BI)",
                ),
                _buildMenuItem(
                  1,
                  FontAwesomeIcons.route,
                  "Rotogramas e Cercas",
                ),
                _buildMenuItem(
                  2,
                  FontAwesomeIcons.clipboardCheck,
                  "Inspeção Pré-Uso",
                ),
                _buildMenuItem(
                  3,
                  FontAwesomeIcons.idCardClip,
                  "Controle Documental",
                ),
                _buildMenuItem(
                  4,
                  FontAwesomeIcons.towerBroadcast,
                  "Eventos IRIS",
                ),
                _buildMenuItem(
                  5,
                  FontAwesomeIcons.chartPie,
                  "Melhoria Contínua / RCA",
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
                Expanded(child: _screens[_selectedIndex]),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem(int index, FaIconData faIconData, String title) {
    bool isActive = _selectedIndex == index;
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
        onTap: () {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }
}
