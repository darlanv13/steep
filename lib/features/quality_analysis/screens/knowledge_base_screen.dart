import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../core/app_theme.dart';

class KnowledgeBaseScreen extends StatefulWidget {
  const KnowledgeBaseScreen({super.key});

  @override
  State<KnowledgeBaseScreen> createState() => _KnowledgeBaseScreenState();
}

class _KnowledgeBaseScreenState extends State<KnowledgeBaseScreen> {
  final TextEditingController _searchCtrl = TextEditingController();

  // Mock data representing resolved Action Plans (Phase: Act)
  final List<Map<String, dynamic>> _allLessons = [
    {
      "id": "POP-001",
      "title": "Procedimento de Aspersão Pós-Chuva",
      "area": "Rampa Sul",
      "author": "João Silva",
      "date": "15/11/2023",
      "tags": ["Pista Úmida", "Frenagem", "Interlock"]
    },
    {
      "id": "POP-002",
      "title": "Ajuste de Carga de Escavadeira",
      "area": "Mina Norte",
      "author": "Marcos Paulo",
      "date": "02/10/2023",
      "tags": ["Sobrecarga", "Manutenção Preditiva"]
    },
    {
      "id": "POP-003",
      "title": "Protocolo de Alerta de Fadiga (DMS)",
      "area": "CCO",
      "author": "Ana Souza",
      "date": "20/08/2023",
      "tags": ["Fadiga", "DMS", "Segurança"]
    },
  ];

  List<Map<String, dynamic>> _filteredLessons = [];

  @override
  void initState() {
    super.initState();
    _filteredLessons = _allLessons;
    _searchCtrl.addListener(_filterLessons);
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  void _filterLessons() {
    final query = _searchCtrl.text.toLowerCase();
    setState(() {
      _filteredLessons = _allLessons.where((l) {
        return l['title'].toString().toLowerCase().contains(query) ||
               l['tags'].join(" ").toLowerCase().contains(query) ||
               l['area'].toString().toLowerCase().contains(query);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Repositório de Lições Aprendidas (Knowledge Base)",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            "Consulte Procedimentos (POPs) gerados a partir de planos PDCA concluídos (Fase Act).",
            style: TextStyle(color: AppTheme.textoSecundario),
          ),
          const SizedBox(height: 32),

          // Search Bar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.black12),
            ),
            child: TextField(
              controller: _searchCtrl,
              decoration: const InputDecoration(
                icon: FaIcon(FontAwesomeIcons.magnifyingGlass, size: 16, color: AppTheme.verdeVale),
                border: InputBorder.none,
                hintText: "Buscar por título, área ou tags (ex: Fadiga, Pista Úmida)...",
              ),
            ),
          ),

          const SizedBox(height: 32),

          // List View
          Expanded(
            child: ListView.builder(
              itemCount: _filteredLessons.length,
              itemBuilder: (context, index) {
                final lesson = _filteredLessons[index];
                return _buildLessonCard(lesson);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLessonCard(Map<String, dynamic> lesson) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        side: const BorderSide(color: Colors.black12),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    "${lesson['id']} - ${lesson['title']}",
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppTheme.verdeVale),
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () {}, // Action to open PDF or Details
                  icon: const FaIcon(FontAwesomeIcons.filePdf, size: 14, color: Colors.white),
                  label: const Text("Visualizar POP", style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                const FaIcon(FontAwesomeIcons.locationDot, size: 14, color: AppTheme.textoSecundario),
                const SizedBox(width: 8),
                Text("Área: ${lesson['area']}", style: const TextStyle(color: AppTheme.textoSecundario)),
                const SizedBox(width: 24),
                const FaIcon(FontAwesomeIcons.userPen, size: 14, color: AppTheme.textoSecundario),
                const SizedBox(width: 8),
                Text("Autor: ${lesson['author']}", style: const TextStyle(color: AppTheme.textoSecundario)),
                const SizedBox(width: 24),
                const FaIcon(FontAwesomeIcons.calendarCheck, size: 14, color: AppTheme.textoSecundario),
                const SizedBox(width: 8),
                Text("Data de Efetivação: ${lesson['date']}", style: const TextStyle(color: AppTheme.textoSecundario)),
              ],
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              children: (lesson['tags'] as List<String>).map((t) {
                return Chip(
                  label: Text(t, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                  backgroundColor: AppTheme.background,
                  side: const BorderSide(color: Colors.black12),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
