import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/app_provider.dart';

class StatsTab extends ConsumerWidget {
  const StatsTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(appProvider);
    final y = state.selectedYear;

    final logsThisYear = state.logs.where((e) => e.dateStr.startsWith('$y')).toList();

    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('$y Yılı Özeti', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          SizedBox(height: 16),
          Card(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                children: [
                  Text('Aylık Mesai Saatleri Grafik', style: TextStyle(fontWeight: FontWeight.bold)),
                  SizedBox(height: 16),
                  SizedBox(
                    height: 200,
                    child: BarChart(
                      BarChartData(
                        borderData: FlBorderData(show: false),
                        titlesData: FlTitlesData(
                          leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              getTitlesWidget: (val, meta) {
                                const m = ['O', 'Ş', 'M', 'N', 'M', 'H', 'T', 'A', 'E', 'E', 'K', 'A'];
                                if (val.toInt() >= 0 && val.toInt() < 12) return Text(m[val.toInt()], style: TextStyle(fontSize: 10));
                                return Text('');
                              },
                            ),
                          ),
                        ),
                        barGroups: List.generate(12, (i) {
                          double h = logsThisYear.where((e) {
                            final d = DateTime.tryParse(e.dateStr);
                            return d != null && d.month == (i + 1);
                          }).fold(0.0, (s, e) => s + e.hours);
                          return BarChartGroupData(x: i, barRods: [BarChartRodData(toY: h, color: Theme.of(context).colorScheme.primary, width: 12, borderRadius: BorderRadius.circular(4))]);
                        }),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 16),
          Card(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                children: [
                  Text('Gün Dağılımı', style: TextStyle(fontWeight: FontWeight.bold)),
                  SizedBox(height: 16),
                  SizedBox(
                    height: 160,
                    child: PieChart(
                      PieChartData(
                        sectionsSpace: 2,
                        centerSpaceRadius: 30,
                        sections: [
                          PieChartSectionData(value: state.logs.length.toDouble() > 0 ? state.logs.length.toDouble() : 1, title: 'Mesai', color: Colors.orange),
                          PieChartSectionData(value: state.absentDays.length.toDouble() > 0 ? state.absentDays.length.toDouble() : 1, title: 'Eksik', color: Colors.red),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 40),
        ],
      ),
    );
  }
}
