import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/app_theme.dart';
import '../../../core/services/data_service.dart';

class AdminPanelScreen extends StatefulWidget {
  const AdminPanelScreen({super.key});

  @override
  State<AdminPanelScreen> createState() => _AdminPanelScreenState();
}

class _AdminPanelScreenState extends State<AdminPanelScreen> {
  bool _isLoading = true;
  List<Map<String, dynamic>> _users = [];
  List<Map<String, dynamic>> _drivers = [];
  List<Map<String, dynamic>> _vehicles = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final service = Provider.of<DataService>(context, listen: false);

    final usersData = await service.getUsers();
    final driversData = await service.getDrivers();
    final vehiclesData = await service.getVehicles();

    if (mounted) {
      setState(() {
        _users = usersData;
        _drivers = driversData;
        _vehicles = vehiclesData;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return DefaultTabController(
      length: 3,
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Painel de Administração e Cadastros",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),
            Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(8),
                  topRight: Radius.circular(8),
                ),
              ),
              child: const TabBar(
                labelColor: AppTheme.verdeVale,
                unselectedLabelColor: AppTheme.textoSecundario,
                indicatorColor: AppTheme.verdeVale,
                tabs: [
                  Tab(text: "Usuários do Sistema"),
                  Tab(text: "Motoristas (Condutores)"),
                  Tab(text: "Frota (Veículos)"),
                ],
              ),
            ),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(8),
                    bottomRight: Radius.circular(8),
                  ),
                ),
                child: TabBarView(
                  children: [
                    _buildTabContent("Usuários", _users, ["Nome", "E-mail", "Papel (Role)"]),
                    _buildTabContent("Motoristas", _drivers, ["Nome", "Licença / CNH", "-"]),
                    _buildTabContent("Veículos", _vehicles, ["Placa", "Frota", "-"]),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  void _showAddUserDialog() {
    final nameCtrl = TextEditingController();
    final emailCtrl = TextEditingController();
    String role = 'operador';

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(builder: (context, setDialogState) {
          return AlertDialog(
            title: const Text("Novo Usuário"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(controller: nameCtrl, decoration: const InputDecoration(labelText: "Nome")),
                TextField(controller: emailCtrl, decoration: const InputDecoration(labelText: "E-mail")),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  initialValue: role,
                  decoration: const InputDecoration(labelText: "Papel/Acesso"),
                  items: const [
                    DropdownMenuItem(value: "admin", child: Text("Administrador")),
                    DropdownMenuItem(value: "supervisor_qualidade", child: Text("Supervisor de Qualidade")),
                    DropdownMenuItem(value: "operador", child: Text("Operador")),
                  ],
                  onChanged: (val) => setDialogState(() => role = val ?? 'operador'),
                ),
              ],
            ),
            actions: [
              TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancelar")),
              ElevatedButton(
                onPressed: () async {
                  if (nameCtrl.text.isNotEmpty && emailCtrl.text.isNotEmpty) {
                    final newUser = {"name": nameCtrl.text, "email": emailCtrl.text, "role": role};
                    setState(() { _users.add(newUser); });
                    final service = Provider.of<DataService>(context, listen: false);
                    await service.addUser(newUser);
                    if (context.mounted) Navigator.pop(context);
                  }
                },
                child: const Text("Salvar"),
              ),
            ],
          );
        });
      },
    );
  }

  void _showAddDriverDialog() {
    final nameCtrl = TextEditingController();
    final licenseCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Novo Motorista"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: nameCtrl, decoration: const InputDecoration(labelText: "Nome do Condutor")),
              TextField(controller: licenseCtrl, decoration: const InputDecoration(labelText: "Licença/CNH")),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancelar")),
            ElevatedButton(
              onPressed: () async {
                if (nameCtrl.text.isNotEmpty && licenseCtrl.text.isNotEmpty) {
                  final newDriver = {"name": nameCtrl.text, "license": licenseCtrl.text};
                  setState(() { _drivers.add(newDriver); });
                  final service = Provider.of<DataService>(context, listen: false);
                  await service.addDriver(newDriver);
                  if (context.mounted) Navigator.pop(context);
                }
              },
              child: const Text("Salvar"),
            ),
          ],
        );
      },
    );
  }

  void _showAddVehicleDialog() {
    final plateCtrl = TextEditingController();
    String fleet = 'Caminhões';

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(builder: (context, setDialogState) {
          return AlertDialog(
            title: const Text("Novo Veículo"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(controller: plateCtrl, decoration: const InputDecoration(labelText: "Placa/Identificação")),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  initialValue: fleet,
                  decoration: const InputDecoration(labelText: "Frota"),
                  items: const [
                    DropdownMenuItem(value: "Caminhões", child: Text("Caminhões")),
                    DropdownMenuItem(value: "Escavadeiras", child: Text("Escavadeiras")),
                    DropdownMenuItem(value: "Tratores", child: Text("Tratores")),
                  ],
                  onChanged: (val) => setDialogState(() => fleet = val ?? 'Caminhões'),
                ),
              ],
            ),
            actions: [
              TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancelar")),
              ElevatedButton(
                onPressed: () async {
                  if (plateCtrl.text.isNotEmpty) {
                    final newVehicle = {"plate": plateCtrl.text, "fleet": fleet};
                    setState(() { _vehicles.add(newVehicle); });
                    final service = Provider.of<DataService>(context, listen: false);
                    await service.addVehicle(newVehicle);
                    if (context.mounted) Navigator.pop(context);
                  }
                },
                child: const Text("Salvar"),
              ),
            ],
          );
        });
      },
    );
  }

  Widget _buildTabContent(String title, List<Map<String, dynamic>> items, List<String> columns) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Gestão de $title", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ElevatedButton.icon(
              onPressed: () {
                if (title == "Usuários") _showAddUserDialog();
                if (title == "Motoristas") _showAddDriverDialog();
                if (title == "Veículos") _showAddVehicleDialog();
              },
              icon: const Icon(Icons.add, size: 16),
              label: Text("Adicionar $title"),
            )
          ],
        ),
        const SizedBox(height: 24),
        Expanded(
          child: ListView.builder(
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              final String val1 = item['name'] ?? item['plate'] ?? '-';
              final String val2 = item['email'] ?? item['license'] ?? item['fleet'] ?? '-';
              final String val3 = item['role'] ?? '-';

              return Card(
                elevation: 0,
                shape: RoundedRectangleBorder(
                  side: const BorderSide(color: Colors.black12),
                  borderRadius: BorderRadius.circular(8)
                ),
                margin: const EdgeInsets.only(bottom: 8),
                child: ListTile(
                  leading: const CircleAvatar(
                    backgroundColor: AppTheme.background,
                    child: Icon(Icons.data_object, color: AppTheme.verdeEscuro),
                  ),
                  title: Text(val1, style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text(val2),
                  trailing: title == "Usuários" ? Chip(label: Text(val3)) : null,
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
