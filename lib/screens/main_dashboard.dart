import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import '../providers/app_provider.dart';
import '../tabs/calendar_tab.dart';
import '../tabs/search_tab.dart';
import '../tabs/stats_tab.dart';
import '../tabs/profile_tab.dart';
import '../tabs/settings_tab.dart';

class MainDashboard extends ConsumerStatefulWidget {
  const MainDashboard({super.key});

  @override
  ConsumerState<MainDashboard> createState() => _MainDashboardState();
}

class _MainDashboardState extends ConsumerState<MainDashboard> {
  int _idx = 0;
  String _ticker = 'Canlı Piyasa: Dolar: ... | Euro: ... | Altın (Gram): ...';

  @override
  void initState() {
    super.initState();
    _fetchFinance();
  }

  Future<void> _fetchFinance() async {
    try {
      final dovizRes = await http.get(Uri.parse('https://api.genelpara.com/embed/doviz.json'));
      final altinRes = await http.get(Uri.parse('https://api.genelpara.com/embed/altin.json'));

      String usd = '?', eur = '?', gold = '?';
      if (dovizRes.statusCode == 200) {
        final d = jsonDecode(dovizRes.body);
        usd = d['USD']?['satis'] ?? '?';
        eur = d['EUR']?['satis'] ?? '?';
      }
      if (altinRes.statusCode == 200) {
        final a = jsonDecode(altinRes.body);
        gold = a['GA']?['satis'] ?? a['gramAltin']?['satis'] ?? '?';
      }

      if (mounted) {
        setState(() {
          _ticker = '💵 Dolar: $usd ₺   |   💶 Euro: $eur ₺   |   🟡 Gram Altın: $gold ₺';
        });
      }
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(appProvider);
    final settings = state.settings;

    final tabs = [
      CalendarTab(),
      SearchTab(),
      StatsTab(),
      ProfileTab(),
      SettingsTab(),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text('MesaiTakip 👷'),
        actions: [
          Center(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(color: Theme.of(context).colorScheme.primaryContainer, borderRadius: BorderRadius.circular(20)),
              child: Text('Saatlik: ${settings.hourlyWage.toStringAsFixed(1)} ₺', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
            ),
          ),
          IconButton(
            icon: Badge(child: Icon(Icons.notifications_outlined)),
            onPressed: () {
              showDialog(context: context, builder: (c) => AlertDialog(title: Text('Bildirimler'), content: Text('Yeni bildirim yok.'), actions: [TextButton(onPressed: () => Navigator.pop(c), child: Text('Kapat'))]));
            },
          ),
        ],
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(28),
          child: Container(
            width: double.infinity,
            color: Theme.of(context).colorScheme.surfaceContainerHighest,
            padding: EdgeInsets.symmetric(vertical: 4),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Text(_ticker, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
            ),
          ),
        ),
      ),
      body: tabs[_idx],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _idx,
        onDestinationSelected: (i) => setState(() => _idx = i),
        destinations: [
          NavigationDestination(icon: Icon(Icons.calendar_month_outlined), selectedIcon: Icon(Icons.calendar_month), label: 'Takvim'),
          NavigationDestination(icon: Icon(Icons.search_outlined), selectedIcon: Icon(Icons.search), label: 'Arama'),
          NavigationDestination(icon: Icon(Icons.bar_chart_outlined), selectedIcon: Icon(Icons.bar_chart), label: 'İstatistik'),
          NavigationDestination(icon: Icon(Icons.person_outline), selectedIcon: Icon(Icons.person), label: 'Profilim'),
          NavigationDestination(icon: Icon(Icons.settings_outlined), selectedIcon: Icon(Icons.settings), label: 'Ayarlar'),
        ],
      ),
    );
  }
}
