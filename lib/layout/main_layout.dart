import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import '../core/app_theme.dart';
import '../core/providers/filter_provider.dart';
import '../features/dashboard/screens/dashboard_screen.dart';
import '../features/quality_analysis/screens/advanced_quality_screen.dart';
import '../features/continuous_improvement/screens/action_plan_screen.dart';
import '../features/continuous_improvement/screens/risk_heatmap_screen.dart';
import '../features/continuous_improvement/screens/cost_analysis_screen.dart';
import '../features/maintenance/screens/predictive_maintenance_screen.dart';
import '../features/cross_analytics/screens/cross_analytics_screen.dart';

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
    const ActionPlanScreen(),
    const RiskHeatmapScreen(),
    const CostAnalysisScreen(),
    const PredictiveMaintenanceScreen(),
    const CrossAnalyticsScreen(),
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
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
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
                        _buildMenuItem(
                          6,
                          FontAwesomeIcons.listCheck,
                          "Planos de Ação (PDCA)",
                        ),
                        _buildMenuItem(
                          7,
                          FontAwesomeIcons.mapLocationDot,
                          "Heatmap de Riscos",
                        ),
                        _buildMenuItem(
                          8,
                          FontAwesomeIcons.sackDollar,
                          "Custos da Não-Qualidade",
                        ),
                        _buildMenuItem(
                          9,
                          FontAwesomeIcons.screwdriverWrench,
                          "Manutenção Preditiva",
                        ),
                        _buildMenuItem(
                          10,
                          FontAwesomeIcons.networkWired,
                          "Cross-Analytics",
                        ),
                      ],
                    ),
                  ),
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
                          Consumer<FilterProvider>(
                            builder: (context, filterProvider, child) {
                              return Row(
                                children: [
                                  _buildGlobalFilter("Turno", ["Manhã", "Tarde", "Noite"], filterProvider.shift, filterProvider.setShift),
                                  const SizedBox(width: 16),
                                  _buildGlobalFilter("Frota", ["Caminhões", "Escavadeiras", "Tratores"], filterProvider.fleet, filterProvider.setFleet),
                                  const SizedBox(width: 16),
                                  _buildGlobalFilter("Período", ["Hoje", "Últimos 7 dias", "Este Mês"], filterProvider.period, filterProvider.setPeriod),
                                ],
                              );
                            },
                          ),
                          const SizedBox(width: 24),
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
                Expanded(
                  child: Consumer<FilterProvider>(
                    builder: (context, filterProvider, child) {
                      if (filterProvider.isLoading) {
                        return const Center(
                          child: CircularProgressIndicator(color: AppTheme.verdeVale),
                        );
                      }
                      return _screens[_selectedIndex];
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGlobalFilter(String label, List<String> options, String currentValue, Function(String) onChanged) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: AppTheme.background,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.black12),
      ),
      child: Row(
        children: [
          Text(
            "$label: ",
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
          ),
          DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: currentValue,
              items: options.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value, style: const TextStyle(fontSize: 12)),
                );
              }).toList(),
              onChanged: (String? newValue) {
                if (newValue != null) {
                  onChanged(newValue);
                }
              },
              icon: const FaIcon(FontAwesomeIcons.chevronDown, size: 12),
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
