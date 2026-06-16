import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';
import 'core/app_theme.dart';
import 'core/providers/filter_provider.dart';
import 'core/services/data_service.dart';
import 'core/services/parse_data_service.dart';
import 'layout/main_layout.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  const keyApplicationId = 'YOUR_APP_ID';
  const keyClientKey = 'YOUR_CLIENT_KEY';
  const keyParseServerUrl = 'https://parseapi.back4app.com';

  await Parse().initialize(
    keyApplicationId,
    keyParseServerUrl,
    clientKey: keyClientKey,
    autoSendSessionId: true,
  );

  runApp(
    MultiProvider(
      providers: [
        Provider<DataService>(
          create: (_) => ParseDataService(),
        ),
        ChangeNotifierProvider(create: (_) => FilterProvider()),
      ],
      child: const SgsvApp(),
    ),
  );
}

class SgsvApp extends StatelessWidget {
  const SgsvApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SGSV Mineração - VPS Vale',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.theme,
      home: const MainLayout(),
    );
  }
}
