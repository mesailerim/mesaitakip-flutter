import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/app_provider.dart';

class WelcomeScreen extends ConsumerStatefulWidget {
  const WelcomeScreen({super.key});

  @override
  ConsumerState<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends ConsumerState<WelcomeScreen> {
  void _showLinkAccountDialog() {
    final firstCtrl = TextEditingController();
    final lastCtrl = TextEditingController();
    final emailCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Google Hesabı Bağla'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Bulut senkronizasyonu için bilgilerinizi girin:', style: TextStyle(fontSize: 13)),
            SizedBox(height: 12),
            TextField(controller: firstCtrl, decoration: InputDecoration(labelText: 'Ad', border: OutlineInputBorder())),
            SizedBox(height: 8),
            TextField(controller: lastCtrl, decoration: InputDecoration(labelText: 'Soyad', border: OutlineInputBorder())),
            SizedBox(height: 8),
            TextField(controller: emailCtrl, decoration: InputDecoration(labelText: 'E-posta (@gmail.com)', border: OutlineInputBorder())),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: Text('İptal')),
          FilledButton(
            onPressed: () {
              if (emailCtrl.text.trim().isNotEmpty && firstCtrl.text.trim().isNotEmpty) {
                ref.read(appProvider.notifier).linkAccount(emailCtrl.text.trim(), firstCtrl.text.trim(), lastCtrl.text.trim());
                Navigator.pop(ctx);
              }
            },
            child: Text('Bağla ve Devam Et'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF65558F), Color(0xFF381E72)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Center(
            child: Padding(
              padding: EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Spacer(),
                  Icon(Icons.access_time_filled, size: 80, color: Colors.white),
                  SizedBox(height: 16),
                  Text(
                    'MesaiTakip 👷',
                    style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Mesai ve kazanımlarınızı bulut güvenliğiyle takip edin',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16, color: Colors.white70),
                  ),
                  Spacer(),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton.icon(
                      style: FilledButton.styleFrom(backgroundColor: Colors.white, foregroundColor: Color(0xFF381E72)),
                      icon: Icon(Icons.person_outline),
                      label: Text('Misafir Olarak Gir'),
                      onPressed: () {
                        ref.read(appProvider.notifier).loginAsGuest();
                      },
                    ),
                  ),
                  SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(foregroundColor: Colors.white, side: BorderSide(color: Colors.white)),
                      icon: Icon(Icons.cloud_sync_outlined),
                      label: Text('Hesap Bağla (Senkronizasyon)'),
                      onPressed: _showLinkAccountDialog,
                    ),
                  ),
                  SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
