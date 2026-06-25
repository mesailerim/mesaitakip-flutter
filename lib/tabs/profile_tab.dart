import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../providers/app_provider.dart';
import '../models/work_experience.dart';

class ProfileTab extends ConsumerStatefulWidget {
  const ProfileTab({super.key});

  @override
  ConsumerState<ProfileTab> createState() => _ProfileTabState();
}

class _ProfileTabState extends ConsumerState<ProfileTab> {
  void _showAddExpSheet() {
    final compCtrl = TextEditingController();
    final titleCtrl = TextEditingController();
    final startCtrl = TextEditingController();
    final endCtrl = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom, left: 24, right: 24, top: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Deneyim Ekle', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            SizedBox(height: 16),
            TextField(controller: compCtrl, decoration: InputDecoration(labelText: 'Şirket Adı', border: OutlineInputBorder())),
            SizedBox(height: 12),
            TextField(controller: titleCtrl, decoration: InputDecoration(labelText: 'Pozisyon/Ünvan', border: OutlineInputBorder())),
            SizedBox(height: 12),
            Row(
              children: [
                Expanded(child: TextField(controller: startCtrl, decoration: InputDecoration(labelText: 'Başlangıç (Yıl)', border: OutlineInputBorder()))),
                SizedBox(width: 12),
                Expanded(child: TextField(controller: endCtrl, decoration: InputDecoration(labelText: 'Bitiş (Yıl)', border: OutlineInputBorder()))),
              ],
            ),
            SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () {
                  if (compCtrl.text.isNotEmpty && titleCtrl.text.isNotEmpty) {
                    ref.read(appProvider.notifier).addWorkExperience(WorkExperience(
                      id: const Uuid().v4(),
                      userId: ref.read(appProvider).settings.userId,
                      companyName: compCtrl.text,
                      jobTitle: titleCtrl.text,
                      startDate: startCtrl.text,
                      endDate: endCtrl.text,
                    ));
                    Navigator.pop(ctx);
                  }
                },
                child: Text('Kaydet'),
              ),
            ),
            SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(appProvider);
    final s = state.settings;

    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        children: [
          CircleAvatar(radius: 40, backgroundColor: Theme.of(context).colorScheme.primaryContainer, child: Icon(Icons.person, size: 48)),
          SizedBox(height: 12),
          Text(s.fullName.isNotEmpty ? s.fullName : 'İsimsiz Kullanıcı', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          Text(s.workplaceName.isNotEmpty ? s.workplaceName : 'İşyeri belirtilmedi', style: TextStyle(color: Colors.grey[700])),
          SizedBox(height: 24),
          // Salary Card
          Card(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Brüt Maaş:', style: TextStyle(fontWeight: FontWeight.bold)),
                      Text('${s.grossSalary.toStringAsFixed(2)} ₺'),
                    ],
                  ),
                  Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Saatlik Ücret (Brüt / 225):', style: TextStyle(fontWeight: FontWeight.bold)),
                      Text('${s.hourlyWage.toStringAsFixed(2)} ₺', style: TextStyle(color: Theme.of(context).colorScheme.primary, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 16),
          // App ID Card
          Card(
            color: Theme.of(context).colorScheme.surfaceContainerHighest,
            child: ListTile(
              title: Text('Evrensel Uygulama Kimliği (App ID)', style: TextStyle(fontSize: 12)),
              subtitle: Text(s.userId, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
              trailing: IconButton(
                icon: Icon(Icons.copy),
                onPressed: () {
                  Clipboard.setData(ClipboardData(text: s.userId));
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('ID Kopyalandı!')));
                },
              ),
            ),
          ),
          SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Özgeçmiş Deneyimlerim', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              IconButton(icon: Icon(Icons.add_circle), onPressed: _showAddExpSheet),
            ],
          ),
          if (state.workExperiences.isEmpty) Text('Henüz deneyim eklenmemiş.', style: TextStyle(color: Colors.grey)),
          for (final e in state.workExperiences)
            Card(
              margin: EdgeInsets.symmetric(vertical: 4),
              child: ListTile(
                title: Text(e.jobTitle, style: TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text('${e.companyName} (${e.startDate} - ${e.endDate})'),
                trailing: IconButton(icon: Icon(Icons.delete_outline, color: Colors.red), onPressed: () => ref.read(appProvider.notifier).deleteWorkExperience(e.id)),
              ),
            ),
          SizedBox(height: 80),
        ],
      ),
    );
  }
}
