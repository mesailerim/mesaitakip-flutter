import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/app_provider.dart';

class SearchTab extends ConsumerStatefulWidget {
  const SearchTab({super.key});

  @override
  ConsumerState<SearchTab> createState() => _SearchTabState();
}

class _SearchTabState extends ConsumerState<SearchTab> {
  String _q = '';

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(appProvider);
    final list = state.logs.where((e) => e.dateStr.contains(_q) || e.note.toLowerCase().contains(_q.toLowerCase())).toList();

    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(16),
            child: TextField(
              onChanged: (v) => setState(() => _q = v),
              decoration: InputDecoration(
                hintText: 'Tarih veya not ara...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ),
          Expanded(
            child: list.isEmpty ? Center(child: Text('Kayıt bulunamadı.')) : ListView.builder(
              itemCount: list.length,
              itemBuilder: (ctx, i) {
                final l = list[i];
                return Dismissible(
                  key: Key(l.id),
                  onDismissed: (_) => ref.read(appProvider.notifier).deleteOvertimeLog(l.id),
                  background: Container(color: Colors.red),
                  child: ListTile(
                    title: Text('${l.dateStr} (${l.hours} Saat)'),
                    subtitle: Text(l.note),
                    trailing: Text('${(l.hours * l.hourlyWage * l.multiplier).toStringAsFixed(1)} ₺', style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
