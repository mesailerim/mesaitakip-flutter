import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/app_provider.dart';

class SettingsTab extends ConsumerWidget {
  const SettingsTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(appProvider);
    final s = state.settings;

    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Ayarlar', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          SizedBox(height: 16),
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: Icon(Icons.cloud_sync),
                  title: Text('Bulut Senkronizasyonu'),
                  subtitle: Text(s.lastSyncTime > 0 ? 'Son eşitleme başarılı' : 'Henüz senkronize edilmedi'),
                  trailing: state.isLoading ? CircularProgressIndicator() : FilledButton(
                    onPressed: () => ref.read(appProvider.notifier).performCloudSync(),
                    child: Text('Şimdi Eşitle'),
                  ),
                ),
                Divider(),
                SwitchListTile(
                  secondary: Icon(Icons.lock_outline),
                  title: Text('PIN Giriş Kilidi'),
                  subtitle: Text('Uygulama açılışında şifre sorulsun'),
                  value: s.isPinEnabled,
                  onChanged: (v) {
                    ref.read(appProvider.notifier).saveSettings(s.copyWith(isPinEnabled: v, pinCode: v ? '1234' : ''));
                  },
                ),
              ],
            ),
          ),
          SizedBox(height: 16),
          Card(
            child: ListTile(
              leading: Icon(Icons.restore_outlined, color: Colors.red),
              title: Text('Fabrika Ayarlarına Dön', style: TextStyle(color: Colors.red)),
              subtitle: Text('Tüm yerel verileri siler'),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: Text('Emin misiniz?'),
                    content: Text('Tüm kayıtlarınız silinecek.'),
                    actions: [
                      TextButton(onPressed: () => Navigator.pop(ctx), child: Text('İptal')),
                      FilledButton(style: FilledButton.styleFrom(backgroundColor: Colors.red), onPressed: () { ref.read(appProvider.notifier).resetApp(); Navigator.pop(ctx); }, child: Text('Sıfırla')),
                    ],
                  ),
                );
              },
            ),
          ),
          SizedBox(height: 40),
        ],
      ),
    );
  }
}
