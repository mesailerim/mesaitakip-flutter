import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'services/supabase_service.dart';
import 'theme/app_theme.dart';
import 'providers/app_provider.dart';
import 'screens/app_content_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SupabaseService.initialize();
  await initializeDateFormatting('tr', null);
  runApp(const ProviderScope(child: MesaiTakipApp()));
}

class MesaiTakipApp extends ConsumerWidget {
  const MesaiTakipApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(appProvider);
    final themeColor = state.settings.themeColor;

    return MaterialApp(
      title: 'MesaiTakip',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme(themeColor),
      darkTheme: AppTheme.darkTheme(themeColor),
      themeMode: ThemeMode.light,
      home: const AppContentManager(),
    );
  }
}
