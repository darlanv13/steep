import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import '../../../core/services/data_service.dart';
import 'dms_detail_screen.dart';

class DmsEvidenceGallery extends StatefulWidget {
  const DmsEvidenceGallery({super.key});

  @override
  State<DmsEvidenceGallery> createState() => _DmsEvidenceGalleryState();
}

class _DmsEvidenceGalleryState extends State<DmsEvidenceGallery> {
  String _eventId = "evt_9948_dms";
  String _title = "Evidência de Distração (DMS)";
  String _imageUrl = "https://via.placeholder.com/400x200/1a1a1a/ffffff?text=Câmera+de+Cabine";
  bool _isLoading = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadEvents();
  }

  Future<void> _loadEvents() async {
    if (!mounted) return;

    final service = Provider.of<DataService>(context, listen: false);
    final events = await service.getIrisEvents();

    if (mounted) {
      setState(() {
        if (events.isNotEmpty) {
          final event = events.first;
          _eventId = event['id'] ?? "evt_${DateTime.now().millisecondsSinceEpoch}";
          _title = event['title'] ?? "Evidência de Fadiga (DMS)";
          _imageUrl = event['imageUrl'] ?? _imageUrl;
        }
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Card(
        child: Padding(
          padding: EdgeInsets.all(32.0),
          child: Center(child: CircularProgressIndicator()),
        ),
      );
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2C3E50),
              ),
            ),
            const SizedBox(height: 16),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => DmsDetailScreen(eventId: _eventId, imageUrl: _imageUrl),
                  ),
                );
              },
              child: Hero(
                tag: _eventId,
                child: Container(
                  height: 150,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.black87,
                    image: DecorationImage(
                      image: NetworkImage(_imageUrl),
                      fit: BoxFit.cover,
                      opacity: 0.7,
                    ),
                  ),
                  child: const Center(
                    child: FaIcon(
                      FontAwesomeIcons.magnifyingGlassPlus,
                      color: Colors.white,
                      size: 32,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
