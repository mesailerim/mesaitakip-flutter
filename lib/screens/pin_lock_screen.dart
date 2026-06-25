import 'package:flutter/material.dart';

class PinLockScreen extends StatefulWidget {
  final VoidCallback onSuccess;
  final String requiredPin;

  const PinLockScreen({super.key, required this.onSuccess, required this.requiredPin});

  @override
  State<PinLockScreen> createState() => _PinLockScreenState();
}

class _PinLockScreenState extends State<PinLockScreen> {
  String _entered = '';
  String? _err;

  void _addChar(String c) {
    if (_entered.length < 4) {
      setState(() {
        _entered += c;
        _err = null;
      });
      if (_entered.length == 4) {
        if (_entered == widget.requiredPin) {
          widget.onSuccess();
        } else {
          setState(() {
            _err = 'Hatalı PIN!';
            _entered = '';
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.lock, size: 64, color: Theme.of(context).colorScheme.primary),
            SizedBox(height: 16),
            Text('PIN Kodu Girin', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(4, (i) => Container(
                margin: EdgeInsets.symmetric(horizontal: 8),
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: i < _entered.length ? Theme.of(context).colorScheme.primary : Colors.grey[300],
                ),
              )),
            ),
            if (_err != null) ...[
              SizedBox(height: 16),
              Text(_err!, style: TextStyle(color: Colors.red)),
            ],
            SizedBox(height: 48),
            _buildGrid(),
          ],
        ),
      ),
    );
  }

  Widget _buildGrid() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 48),
      child: GridView.count(
        shrinkWrap: true,
        crossAxisCount: 3,
        childAspectRatio: 1.5,
        physics: NeverScrollableScrollPhysics(),
        children: [
          for (var i = 1; i <= 9; i++) _btn(i.toString()),
          SizedBox(),
          _btn('0'),
          IconButton(onPressed: () => setState(() => _entered = _entered.isNotEmpty ? _entered.substring(0, _entered.length - 1) : ''), icon: Icon(Icons.backspace)),
        ],
      ),
    );
  }

  Widget _btn(String s) => TextButton(onPressed: () => _addChar(s), child: Text(s, style: TextStyle(fontSize: 24)));
}
