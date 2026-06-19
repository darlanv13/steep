import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import '../../../core/app_theme.dart';
import '../../../core/providers/filter_provider.dart';
import '../../../core/services/data_service.dart';

class KnowledgeBaseScreen extends StatefulWidget {
  const KnowledgeBaseScreen({super.key});

  @override
  State<KnowledgeBaseScreen> createState() => _KnowledgeBaseScreenState();
}

class _KnowledgeBaseScreenState extends State<KnowledgeBaseScreen> {
  final TextEditingController _searchCtrl = TextEditingController();

  List<Map<String, dynamic>> _allLessons = [];
  List<Map<String, dynamic>> _filteredLessons = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _searchCtrl.addListener(_filterLessons);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final filter = Provider.of<FilterProvider>(context, listen: true);
    _loadLessons(filter);
  }

  Future<void> _loadLessons(FilterProvider filter) async {
    if (!mounted) return;

    final service = Provider.of<DataService>(context, listen: false);
    final plans = await service.getActionPlans(filter.shift, filter.fleet, filter.period);

    if (mounted) {
      setState(() {
        _allLessons = plans.where((p) => p['pdcaPhase'] == 'Act').map((p) {
           return {
             "id": p['id'] ?? "ACT-${DateTime.now().millisecondsSinceEpoch.toString().substring(8)}",
             "title": p['title'] ?? "Sem Título",
             "area": p['fleet'] ?? "Geral",
             "author": p['responsible'] ?? "Sistema",
             "date": p['dueDate'] ?? "N/A",
             "tags": ["PDCA", "Concluído", p['shift'] ?? "Geral"],
           };
        }).toList();

        _filteredLessons = _allLessons;
        _isLoading = false;
      });
    }
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
            child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : _filteredLessons.isEmpty
              ? const Center(child: Text("Nenhuma lição aprendida (Fase Act) encontrada."))
              : ListView.builder(
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
