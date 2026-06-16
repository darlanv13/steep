import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../core/app_theme.dart';

class RegistrationsScreen extends StatefulWidget {
  const RegistrationsScreen({super.key});

  @override
  State<RegistrationsScreen> createState() => _RegistrationsScreenState();
}

class _RegistrationsScreenState extends State<RegistrationsScreen> {
  int _selectedTabIndex = 0;

  final List<String> _tabs = [
    "Motoristas",
    "Veículos",
    "Modelos de Veículos",
    "Placas",
    "Combustível",
    "Qtde. de Passageiros",
    "Análise de Riscos",
    "Metodologias (RCA)",
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Cadastros e Parâmetros (Qualidade)",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppTheme.textoPrincipal,
            ),
          ),
          const SizedBox(height: 24),
          // Tab bar
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: List.generate(_tabs.length, (index) {
                return _buildTabItem(index, _tabs[index]);
              }),
            ),
          ),
          const SizedBox(height: 24),
          // Content Area
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.black12),
              ),
              child: _buildFormContent(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabItem(int index, String title) {
    final isSelected = _selectedTabIndex == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedTabIndex = index;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        margin: const EdgeInsets.only(right: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.verdeVale : AppTheme.background,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? AppTheme.verdeVale : Colors.black12,
          ),
        ),
        child: Text(
          title,
          style: TextStyle(
            color: isSelected ? Colors.white : AppTheme.textoSecundario,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildFormContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Criar / Editar ${_tabs[_selectedTabIndex]}",
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppTheme.textoPrincipal,
              ),
            ),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.verdeVale,
              ),
              icon: const FaIcon(FontAwesomeIcons.plus, size: 14, color: Colors.white),
              label: const Text("Novo Registro", style: TextStyle(color: Colors.white)),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Nova entrada para ${_tabs[_selectedTabIndex]} criada! (Simulação)')),
                );
              },
            ),
          ],
        ),
        const SizedBox(height: 24),
        // Mock Form Fields
        Expanded(
          child: ListView(
            children: [
              _buildMockTextField("Nome / Descrição"),
              const SizedBox(height: 16),
              _buildMockTextField("Código Interno"),
              const SizedBox(height: 16),
              _buildMockTextField("Observações"),
              const SizedBox(height: 32),
              Align(
                alignment: Alignment.centerRight,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.verdeEscuro,
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  ),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Dados de ${_tabs[_selectedTabIndex]} salvos com sucesso! (Simulação)')),
                    );
                  },
                  child: const Text("Salvar Alterações", style: TextStyle(color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMockTextField(String label) {
    return TextField(
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        filled: true,
        fillColor: AppTheme.background,
      ),
    );
  }
}
