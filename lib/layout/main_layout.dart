import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import '../core/app_theme.dart';
import '../core/providers/filter_provider.dart';
import '../features/dashboard/screens/dashboard_screen.dart';
import '../features/quality_analysis/screens/advanced_quality_screen.dart';
import '../features/dashboard/screens/geofence_screen.dart';
import '../features/checklist/screens/checklist_screen.dart';
import '../features/document_control/screens/document_control_screen.dart';
import '../features/iris_integration/screens/iris_events_screen.dart';
import '../features/continuous_improvement/screens/action_plan_screen.dart';
import '../features/continuous_improvement/screens/risk_heatmap_screen.dart';
import '../features/continuous_improvement/screens/cost_analysis_screen.dart';
import '../features/maintenance/screens/predictive_maintenance_screen.dart';
import '../features/cross_analytics/screens/cross_analytics_screen.dart';
import '../features/quality_analysis/screens/knowledge_base_screen.dart';
import '../features/admin/screens/admin_panel_screen.dart';
import '../core/providers/auth_provider.dart';

class MainLayout extends StatefulWidget {
  const MainLayout({super.key});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  int _selectedIndex = 0;

  Widget _buildDrawerContent(AuthProvider authProvider) {
    return Container(
      width: 220,
      color: AppTheme.verdeVale,
      child: Column(
        children: [
          const SizedBox(height: 50),
          const FaIcon(
            FontAwesomeIcons.shieldHalved,
            color: AppTheme.amareloVale,
            size: 36,
          ),
          const SizedBox(height: 16),
          const Text(
            "SGSV Mineração",
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
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
                  _buildMenuItem(
                    11,
                    FontAwesomeIcons.bookOpenReader,
                    "Lições Aprendidas",
                  ),
                  if (authProvider.userRole == 'admin')
                    _buildMenuItem(
                      12,
                      FontAwesomeIcons.usersGear,
                      "Painel de Cadastros",
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: true);
    final userRole = authProvider.userRole;

    final List<Widget> screens = [
      const DashboardScreen(),
      const GeofenceScreen(),
      const ChecklistScreen(),
      const DocumentControlScreen(),
      const IrisEventsScreen(),
      const AdvancedQualityScreen(),
      const ActionPlanScreen(),
      const RiskHeatmapScreen(),
      const CostAnalysisScreen(),
      const PredictiveMaintenanceScreen(),
      const CrossAnalyticsScreen(),
      const KnowledgeBaseScreen(),
      if (userRole == 'admin') const AdminPanelScreen(),
    ];

    if (_selectedIndex >= screens.length) {
       _selectedIndex = 0;
    }

    return Scaffold(
      drawer: MediaQuery.of(context).size.width < 800
          ? _buildDrawerContent(authProvider)
          : null,
      body: Row(
        children: [
          if (MediaQuery.of(context).size.width >= 800) _buildDrawerContent(authProvider),

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
                      Row(
                        children: [
                          if (MediaQuery.of(context).size.width < 800)
                            Builder(
                              builder: (context) => IconButton(
                                icon: const Icon(Icons.menu),
                                onPressed: () {
                                  Scaffold.of(context).openDrawer();
                                },
                              ),
                            ),
                          if (MediaQuery.of(context).size.width >= 1000)
                            const Text(
                              "Visão Geral da Operação",
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w600,
                                color: AppTheme.textoPrincipal,
                              ),
                            ),
                        ],
                      ),
                      Expanded(
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          reverse: true,
                          child: Row(
                            children: [
                              Consumer<FilterProvider>(
                                builder: (context, filterProvider, child) {
                                  return Row(
                                    children: [
                                      _buildGlobalFilter(
                                        "Turno",
                                        ["Manhã", "Tarde", "Noite"],
                                        filterProvider.shift,
                                        filterProvider.setShift,
                                      ),
                                      const SizedBox(width: 16),
                                      _buildGlobalFilter(
                                        "Frota",
                                        [
                                          "Caminhões",
                                          "Escavadeiras",
                                          "Tratores",
                                        ],
                                        filterProvider.fleet,
                                        filterProvider.setFleet,
                                      ),
                                      const SizedBox(width: 16),
                                      _buildGlobalFilter(
                                        "Período",
                                        ["Hoje", "Últimos 7 dias", "Este Mês"],
                                        filterProvider.period,
                                        filterProvider.setPeriod,
                                      ),
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
                              PopupMenuButton<String>(
                                icon: const CircleAvatar(
                                  backgroundColor: AppTheme.verdeEscuro,
                                  child: FaIcon(
                                    FontAwesomeIcons.userShield,
                                    color: Colors.white,
                                    size: 18,
                                  ),
                                ),
                                onSelected: (value) {
                                  if (value == 'logout') {
                                    authProvider.logout();
                                  }
                                },
                                itemBuilder: (BuildContext context) {
                                  return [
                                    const PopupMenuItem<String>(
                                      value: 'logout',
                                      child: Row(
                                        children: [
                                          Icon(Icons.logout, size: 16),
                                          SizedBox(width: 8),
                                          Text('Sair do Sistema'),
                                        ],
                                      ),
                                    ),
                                  ];
                                },
                              ),
                            ],
                          ),
                        ),
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
                          child: CircularProgressIndicator(
                            color: AppTheme.verdeVale,
                          ),
                        );
                      }
                      return screens[_selectedIndex];
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

  Widget _buildGlobalFilter(
    String label,
    List<String> options,
    String currentValue,
    Function(String) onChanged,
  ) {
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
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: isActive ? AppTheme.verdeEscuro : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListTile(
        leading: FaIcon(
          faIconData,
          size: 18,
          color: isActive ? Colors.white : Colors.white70,
        ),
        title: Text(
          title,
          style: TextStyle(
            color: isActive ? Colors.white : Colors.white70,
            fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
            fontSize: 13,
          ),
        ),
        onTap: () {
          setState(() {
            _selectedIndex = index;
          });
          if (MediaQuery.of(context).size.width < 800) {
            Navigator.of(context).pop(); // Close drawer on selection
          }
        },
      ),
    );
  }
}
