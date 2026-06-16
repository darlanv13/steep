import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../core/app_theme.dart';

class GeofenceScreen extends StatelessWidget {
  const GeofenceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Área do Mapa (Simulação Visual)
          Expanded(
            flex: 2,
            child: Container(
              height: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                image: const DecorationImage(
                  image: NetworkImage(
                    'https://via.placeholder.com/800x600/e0e0e0/808080?text=Mapa+Topográfico+da+Cava+(Offline)',
                  ),
                  fit: BoxFit.cover,
                ),
                border: Border.all(color: Colors.black12),
              ),
              child: Stack(
                children: [
                  Positioned(
                    top: 20,
                    right: 20,
                    child: FloatingActionButton(
                      backgroundColor: AppTheme.verdeVale,
                      onPressed: () {},
                      child: const FaIcon(
                        FontAwesomeIcons.drawPolygon,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 32),
          // Painel de Controle de Cercas
          Expanded(
            flex: 1,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Zonas de Controle Ativas",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                _buildGeofenceCard(
                  "Rampa Sul - Declive Severo",
                  "Máx: 30 km/h",
                  AppTheme.alertaCritico,
                ),
                _buildGeofenceCard(
                  "Área de Transbordo Principal",
                  "Máx: 40 km/h",
                  AppTheme.amareloVale,
                ),
                _buildGeofenceCard(
                  "Acesso Portaria 2",
                  "Máx: 60 km/h",
                  AppTheme.sucesso,
                ),
                const SizedBox(height: 32),
                const Text(
                  "Veículos em Zona de Alerta",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                _buildVehicleInZone(
                  "V-102 (João Silva)",
                  "Rampa Sul",
                  "28 km/h",
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGeofenceCard(String name, String limit, Color statusColor) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: FaIcon(FontAwesomeIcons.mapLocationDot, color: statusColor),
        title: Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text("Limite: $limit"),
        trailing: const FaIcon(
          FontAwesomeIcons.ellipsisVertical,
          color: AppTheme.textoSecundario,
        ),
      ),
    );
  }

  Widget _buildVehicleInZone(String vehicle, String zone, String speed) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.amareloVale.withOpacity(0.1),
        border: Border(left: BorderSide(color: AppTheme.amareloVale, width: 4)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                vehicle,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                zone,
                style: const TextStyle(
                  color: AppTheme.textoSecundario,
                  fontSize: 12,
                ),
              ),
            ],
          ),
          Text(
            speed,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: AppTheme.amareloVale,
            ),
          ),
        ],
      ),
    );
  }
}
