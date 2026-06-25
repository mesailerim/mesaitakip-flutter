import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/app_provider.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final _pageCtrl = PageController();
  int _step = 0;

  final _nameCtrl = TextEditingController();
  final _workplaceCtrl = TextEditingController();
  final _birthCtrl = TextEditingController();
  final _hireCtrl = TextEditingController();
  final _salaryCtrl = TextEditingController();
  final _taxCtrl = TextEditingController(text: '15.0');
  final _leaveCtrl = TextEditingController(text: '14');

  String _marital = 'Bekar';
  String _gender = 'Belirtilmedi';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Kurulum Adımı (${_step + 1}/4)')),
      body: SafeArea(
        child: Column(
          children: [
            LinearProgressIndicator(value: (_step + 1) / 4.0),
            Expanded(
              child: PageView(
                controller: _pageCtrl,
                physics: NeverScrollableScrollPhysics(),
                children: [
                  // Step 1
                  _buildStep(
                    title: 'Hoş Geldiniz 👋',
                    desc: 'Uygulamayı kişiselleştirmek için temel bilgileri girelim.',
                    children: [
                      TextField(controller: _nameCtrl, decoration: InputDecoration(labelText: 'Ad Soyad', border: OutlineInputBorder())),
                      SizedBox(height: 16),
                      TextField(controller: _workplaceCtrl, decoration: InputDecoration(labelText: 'İşyeri Adı', border: OutlineInputBorder())),
                    ],
                  ),
                  // Step 2
                  _buildStep(
                    title: 'Tarihler 📅',
                    desc: 'Maaş ve izin hesaplamaları için gereklidir.',
                    children: [
                      TextField(controller: _birthCtrl, decoration: InputDecoration(labelText: 'Doğum Tarihi (GG.AA.YYYY)', hintText: '01.01.1990', border: OutlineInputBorder())),
                      SizedBox(height: 16),
                      TextField(controller: _hireCtrl, decoration: InputDecoration(labelText: 'İşe Giriş Tarihi (GG.AA.YYYY)', hintText: '15.06.2020', border: OutlineInputBorder())),
                    ],
                  ),
                  // Step 3
                  _buildStep(
                    title: 'Maaş Bilgileri 💰',
                    desc: 'Saatlik ücret hesabınız Brüt Maaş / 225 üzerinden otomatik yapılır.',
                    children: [
                      TextField(controller: _salaryCtrl, keyboardType: TextInputType.number, decoration: InputDecoration(labelText: 'Brüt Maaş (₺)', border: OutlineInputBorder())),
                      SizedBox(height: 16),
                      TextField(controller: _taxCtrl, keyboardType: TextInputType.number, decoration: InputDecoration(labelText: 'Vergi Kesinti Oranı (%)', border: OutlineInputBorder())),
                      SizedBox(height: 16),
                      TextField(controller: _leaveCtrl, keyboardType: TextInputType.number, decoration: InputDecoration(labelText: 'Yıllık İzin Hakkı (Gün)', border: OutlineInputBorder())),
                    ],
                  ),
                  // Step 4
                  _buildStep(
                    title: 'Ek Bilgiler ℹ️',
                    desc: 'Profil ve özgeçmiş oluşturucu için isteğe bağlıdır.',
                    children: [
                      Text('Medeni Durum', style: TextStyle(fontWeight: FontWeight.bold)),
                      Row(
                        children: [
                          ChoiceChip(label: Text('Bekar'), selected: _marital == 'Bekar', onSelected: (v) => setState(() => _marital = 'Bekar')),
                          SizedBox(width: 8),
                          ChoiceChip(label: Text('Evli'), selected: _marital == 'Evli', onSelected: (v) => setState(() => _marital = 'Evli')),
                        ],
                      ),
                      SizedBox(height: 16),
                      Text('Cinsiyet', style: TextStyle(fontWeight: FontWeight.bold)),
                      Wrap(
                        spacing: 8,
                        children: [
                          ChoiceChip(label: Text('Erkek'), selected: _gender == 'Erkek', onSelected: (v) => setState(() => _gender = 'Erkek')),
                          ChoiceChip(label: Text('Kadın'), selected: _gender == 'Kadın', onSelected: (v) => setState(() => _gender = 'Kadın')),
                          ChoiceChip(label: Text('Belirtilmedi'), selected: _gender == 'Belirtilmedi', onSelected: (v) => setState(() => _gender = 'Belirtilmedi')),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.all(16),
              child: Row(
                children: [
                  if (_step > 0)
                    OutlinedButton(
                      onPressed: () {
                        setState(() => _step--);
                        _pageCtrl.previousPage(duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
                      },
                      child: Text('Geri'),
                    ),
                  Spacer(),
                  FilledButton(
                    onPressed: () {
                      if (_step < 3) {
                        setState(() => _step++);
                        _pageCtrl.nextPage(duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
                      } else {
                        ref.read(appProvider.notifier).completeOnboarding(
                          fullName: _nameCtrl.text,
                          workplaceName: _workplaceCtrl.text,
                          birthDate: _birthCtrl.text,
                          hireDate: _hireCtrl.text,
                          grossSalary: double.tryParse(_salaryCtrl.text) ?? 0.0,
                          taxPercentage: double.tryParse(_taxCtrl.text) ?? 15.0,
                          annualLeaveBalance: int.tryParse(_leaveCtrl.text) ?? 14,
                          maritalStatus: _marital,
                          gender: _gender,
                        );
                      }
                    },
                    child: Text(_step == 3 ? 'Tamamla' : 'İleri'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStep({required String title, required String desc, required List<Widget> children}) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          SizedBox(height: 8),
          Text(desc, style: TextStyle(color: Colors.grey[700])),
          SizedBox(height: 24),
          ...children,
        ],
      ),
    );
  }
}
