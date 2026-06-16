import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'dms_detail_screen.dart';

class DmsEvidenceGallery extends StatelessWidget {
  final String eventId = "evt_9948_dms";

  const DmsEvidenceGallery({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Evidência de Distração (DMS)",
              style: TextStyle(
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
                    builder: (_) => DmsDetailScreen(eventId: eventId),
                  ),
                );
              },
              child: Hero(
                tag: eventId,
                child: Container(
                  height: 150,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.black87,
                    image: const DecorationImage(
                      image: NetworkImage(
                        'https://via.placeholder.com/400x200/1a1a1a/ffffff?text=Câmera+de+Cabine',
                      ),
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
