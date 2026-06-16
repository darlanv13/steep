import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';

import '../../../core/app_theme.dart';
import '../../../core/services/data_service.dart';

class GeofenceScreen extends StatefulWidget {
  const GeofenceScreen({super.key});

  @override
  State<GeofenceScreen> createState() => _GeofenceScreenState();
}

class _GeofenceScreenState extends State<GeofenceScreen> {
  List<Map<String, dynamic>> _geofences = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    if (!mounted) return;

    final service = Provider.of<DataService>(context, listen: false);
    final data = await service.getGeofences();

    if (mounted) {
      setState(() {
        _geofences = data;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width > 800;

    return Padding(
      padding: const EdgeInsets.all(32),
      child: Flex(
        direction: isDesktop ? Axis.horizontal : Axis.vertical,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Área do Mapa
          Expanded(
            flex: isDesktop ? 2 : 0,
            child: Container(
              height: isDesktop ? double.infinity : 400,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.black12),
              ),
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: FlutterMap(
                      options: const MapOptions(
                        initialCenter: LatLng(-19.8157, -43.9542), // Coordenada genérica de mineração (BH region placeholder)
                        initialZoom: 12.0,
                      ),
                      children: [
                        TileLayer(
                          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                          userAgentPackageName: 'com.example.steep',
                        ),
                        // Caso a gente tenha poligonos no geofence data poderiamos adiciona-los aqui
                      ],
                    ),
                  ),
                  Positioned(
                    top: 20,
                    right: 20,
                    child: FloatingActionButton(
                      backgroundColor: AppTheme.verdeVale,
                      onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Modo de desenho de cerca ativado.')),
                          );
                      },
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
          if (isDesktop) const SizedBox(width: 32) else const SizedBox(height: 32),
          // Painel de Controle de Cercas
          Expanded(
            flex: isDesktop ? 1 : 0,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  "Zonas de Controle Ativas",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                if (_isLoading)
                  const CircularProgressIndicator()
                else if (_geofences.isEmpty)
                  const Text("Nenhuma cerca ativa encontrada.")
                else
                  ..._geofences.map((g) {
                    Color c = AppTheme.amareloVale;
                    if (g['severity'] == 'critical') c = AppTheme.alertaCritico;
                    if (g['severity'] == 'low') c = AppTheme.sucesso;
                    return _buildGeofenceCard(
                      g['name'] ?? 'Sem Nome',
                      g['limit'] ?? 'N/A',
                      c,
                    );
                  }),
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
        color: AppTheme.amareloVale.withValues(alpha: 0.1),
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
