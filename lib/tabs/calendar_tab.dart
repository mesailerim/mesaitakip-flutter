import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';
import '../providers/app_provider.dart';
import '../models/overtime_log.dart';
import '../models/absent_day.dart';
import '../utils/turkish_tax_helper.dart';

class CalendarTab extends ConsumerStatefulWidget {
  const CalendarTab({super.key});

  @override
  ConsumerState<CalendarTab> createState() => _CalendarTabState();
}

class _CalendarTabState extends ConsumerState<CalendarTab> {
  bool _isNetMode = false;

  void _showAddSheet(DateTime date) {
    final dateStr = DateFormat('yyyy-MM-dd').format(date);
    final hoursCtrl = TextEditingController();
    final noteCtrl = TextEditingController();
    double mult = 1.5;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (ctx) => StatefulBuilder(
        builder: (c, setS) => Padding(
          padding: EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom, left: 24, right: 24, top: 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('${DateFormat('dd.MM.yyyy').format(date)} İşlemi Ekle', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              SizedBox(height: 16),
              TextField(controller: hoursCtrl, keyboardType: TextInputType.numberWithOptions(decimal: true), decoration: InputDecoration(labelText: 'Mesai Saati', border: OutlineInputBorder())),
              SizedBox(height: 16),
              Text('Çarpan', style: TextStyle(fontWeight: FontWeight.bold)),
              Row(
                children: [
                  ChoiceChip(label: Text('1.5x (Normal)'), selected: mult == 1.5, onSelected: (v) => setS(() => mult = 1.5)),
                  SizedBox(width: 8),
                  ChoiceChip(label: Text('2.0x (Pazar/Gece)'), selected: mult == 2.0, onSelected: (v) => setS(() => mult = 2.0)),
                  SizedBox(width: 8),
                  ChoiceChip(label: Text('3.0x (Bayram)'), selected: mult == 3.0, onSelected: (v) => setS(() => mult = 3.0)),
                ],
              ),
              SizedBox(height: 16),
              TextField(controller: noteCtrl, decoration: InputDecoration(labelText: 'Not (İsteğe bağlı)', border: OutlineInputBorder())),
              SizedBox(height: 24),
              Row(
                children: [
                  OutlinedButton(
                    style: OutlinedButton.styleFrom(foregroundColor: Colors.red),
                    onPressed: () {
                      ref.read(appProvider.notifier).addAbsentDay(AbsentDay(id: const Uuid().v4(), userId: ref.read(appProvider).settings.userId, dateStr: dateStr, reason: 'Eksik Gün'));
                      Navigator.pop(ctx);
                    },
                    child: Text('Eksik Gün İşaretle'),
                  ),
                  Spacer(),
                  FilledButton(
                    onPressed: () {
                      final h = double.tryParse(hoursCtrl.text.replaceAll(',', '.'));
                      if (h != null && h > 0) {
                        ref.read(appProvider.notifier).addOvertimeLog(OvertimeLog(
                          id: const Uuid().v4(),
                          userId: ref.read(appProvider).settings.userId,
                          dateStr: dateStr,
                          hours: h,
                          multiplier: mult,
                          hourlyWage: ref.read(appProvider).settings.hourlyWage,
                          note: noteCtrl.text,
                        ));
                        Navigator.pop(ctx);
                      }
                    },
                    child: Text('Kaydet'),
                  ),
                ],
              ),
              SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(appProvider);
    final settings = state.settings;
    final m = state.selectedMonth;
    final y = state.selectedYear;

    final logsThisMonth = state.logs.where((e) {
      final d = DateTime.tryParse(e.dateStr);
      return d != null && d.month == m && d.year == y;
    }).toList();

    double totalH = logsThisMonth.fold(0.0, (sum, e) => sum + e.hours);
    double grossEarn = logsThisMonth.fold(0.0, (sum, e) => sum + (e.hours * e.hourlyWage * e.multiplier));
    
    double taxRate = TurkishTaxHelper.calculateMonthlyDeductionRate(grossNormal: settings.grossSalary, grossOvertime: grossEarn, hireDateStr: settings.hireDate, currentMonth: m, currentYear: y);
    double shownEarn = _isNetMode ? TurkishTaxHelper.calculateNetSalary(grossEarn, taxRate) : grossEarn;

    final firstDay = DateTime(y, m, 1);
    final daysInM = DateTime(y, m + 1, 0).day;
    int startWeekday = firstDay.weekday; // 1 Mon ... 7 Sun

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddSheet(DateTime.now()),
        child: Icon(Icons.add),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            // Month Selector
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(icon: Icon(Icons.chevron_left), onPressed: () => ref.read(appProvider.notifier).selectMonth(m > 1 ? m - 1 : 12, m > 1 ? y : y - 1)),
                Text('${DateFormat('MMMM yyyy', 'tr').format(firstDay)}', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                IconButton(icon: Icon(Icons.chevron_right), onPressed: () => ref.read(appProvider.notifier).selectMonth(m < 12 ? m + 1 : 1, m < 12 ? y : y + 1)),
              ],
            ),
            SizedBox(height: 12),
            // Summary Card
            Card(
              color: Theme.of(context).colorScheme.secondaryContainer,
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Bu Ay Toplam Mesai:', style: TextStyle(fontWeight: FontWeight.w500)),
                        Text('${totalH.toStringAsFixed(1)} Saat', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                      ],
                    ),
                    Divider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Text(_isNetMode ? 'Net Kazanç:' : 'Brüt Kazanç:', style: TextStyle(fontWeight: FontWeight.w500)),
                            SizedBox(width: 8),
                            InkWell(
                              onTap: () => setState(() => _isNetMode = !_isNetMode),
                              child: Container(padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2), decoration: BoxDecoration(color: Colors.black12, borderRadius: BorderRadius.circular(8)), child: Text(_isNetMode ? 'Net' : 'Brüt', style: TextStyle(fontSize: 11))),
                            ),
                          ],
                        ),
                        Text('${shownEarn.toStringAsFixed(2)} ₺', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Theme.of(context).colorScheme.primary)),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 16),
            // Weekdays Header
            GridView.count(
              shrinkWrap: true,
              crossAxisCount: 7,
              physics: NeverScrollableScrollPhysics(),
              children: ['Pzt', 'Sal', 'Çar', 'Per', 'Cum', 'Cmt', 'Paz'].map((d) => Center(child: Text(d, style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)))).toList(),
            ),
            // Calendar Grid
            GridView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 7),
              itemCount: daysInM + startWeekday - 1,
              itemBuilder: (ctx, idx) {
                if (idx < startWeekday - 1) return SizedBox();
                int day = idx - (startWeekday - 1) + 1;
                final curDate = DateTime(y, m, day);
                final dStr = DateFormat('yyyy-MM-dd').format(curDate);
                final isToday = DateFormat('yyyy-MM-dd').format(DateTime.now()) == dStr;

                final hasOvertime = state.logs.any((e) => e.dateStr == dStr);
                final isAbsent = state.absentDays.any((e) => e.dateStr == dStr);

                return InkWell(
                  onTap: () => _showAddSheet(curDate),
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    margin: EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      border: isToday ? Border.all(color: Theme.of(context).colorScheme.primary, width: 2) : null,
                      borderRadius: BorderRadius.circular(12),
                      color: isAbsent ? Colors.red.withValues(alpha: 0.15) : (hasOvertime ? Colors.orange.withValues(alpha: 0.15) : null),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('$day', style: TextStyle(fontWeight: isToday ? FontWeight.bold : FontWeight.normal)),
                        SizedBox(height: 2),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            if (hasOvertime) Container(width: 5, height: 5, decoration: BoxDecoration(color: Colors.orange, shape: BoxShape.circle)),
                            if (isAbsent) Container(width: 5, height: 5, decoration: BoxDecoration(color: Colors.red, shape: BoxShape.circle)),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
            SizedBox(height: 24),
            Align(alignment: Alignment.centerLeft, child: Text('Ayın Kayıtları', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold))),
            SizedBox(height: 8),
            if (logsThisMonth.isEmpty)
              Text('Bu ay için kayıt bulunmuyor.', style: TextStyle(color: Colors.grey)),
            for (final l in logsThisMonth)
              Dismissible(
                key: Key(l.id),
                direction: DismissDirection.endToStart,
                background: Container(alignment: Alignment.centerRight, padding: EdgeInsets.only(right: 16), color: Colors.red, child: Icon(Icons.delete, color: Colors.white)),
                onDismissed: (_) => ref.read(appProvider.notifier).deleteOvertimeLog(l.id),
                child: ListTile(
                  leading: CircleAvatar(backgroundColor: Colors.orange[100], child: Text('${l.multiplier}x', style: TextStyle(fontSize: 12, color: Colors.orange[900]))),
                  title: Text('${l.dateStr} - ${l.hours} Saat'),
                  subtitle: Text(l.note.isNotEmpty ? l.note : 'Not girilmedi'),
                  trailing: Text('+${(l.hours * l.hourlyWage * l.multiplier).toStringAsFixed(1)} ₺', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green[700])),
                ),
              ),
            SizedBox(height: 80),
          ],
        ),
      ),
    );
  }
}
