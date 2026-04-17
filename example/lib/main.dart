import 'package:flutter/material.dart';
import 'package:qr_styler/qr_styler.dart'; // adjust if your export path differs

void main() {
  runApp(const QrExampleApp());
}

class QrExampleApp extends StatelessWidget {
  const QrExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'QR Styler Demo',
      theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.orange),
      home: const QrDemoPage(),
    );
  }
}

class QrDemoPage extends StatelessWidget {
  const QrDemoPage({super.key});

  Widget section(String title, Widget child) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12, width: 500),
          child,
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('QR Styler Examples'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // ─────────────────────────────────────────────
            section(
              'Basic',
              QrStyler(
                dimension: 200,
                painter: QrPainter('https://example.com'),
              ),
            ),

            // ─────────────────────────────────────────────
            section(
              'Custom Colors',
              QrStyler(
                dimension: 200,
                painter: QrPainter(
                  'Colors',
                  dotColor: Colors.black,
                  eyeFrameColor: Colors.blue,
                  eyePupilColor: Colors.orange,
                ),
              ),
            ),

            // ─────────────────────────────────────────────
            section(
              'Square Style',
              QrStyler(
                dimension: 200,
                painter: QrPainter(
                  'Square',
                  dotCornerRadius: 0,
                  dotSizeRatio: 1,
                ),
              ),
            ),

            // ─────────────────────────────────────────────
            section(
              'Soft Rounded',
              QrStyler(
                dimension: 200,
                painter: QrPainter(
                  'Soft',
                  dotSizeRatio: 0.6,
                  dotCornerRadius: 20,
                  dotColor: Colors.deepPurple,
                ),
              ),
            ),

            // ─────────────────────────────────────────────
            section(
              'Horizontal Connect',
              QrStyler(
                dimension: 220,
                painter: QrPainter(
                  'Horizontal',
                  connectStyle: QrConnectStyle.horizontal,
                  dotCornerRadius: 50,
                ),
              ),
            ),

            // ─────────────────────────────────────────────
            section(
              'Vertical Connect',
              QrStyler(
                dimension: 220,
                painter: QrPainter(
                  'Vertical',
                  connectStyle: QrConnectStyle.vertical,
                  dotCornerRadius: 50,
                ),
              ),
            ),

            // ─────────────────────────────────────────────
            section(
              'With Logo',
              QrStyler(
                dimension: 240,
                painter: QrPainter(
                  'https://yourapp.com',
                  centerLogoSafeZone: true,
                  iconSizeRatio: 0.22,
                ),
                icon: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.qr_code, size: 32),
                ),
              ),
            ),

            // ─────────────────────────────────────────────
            section(
              'Brand Style (Example)',
              QrStyler(
                dimension: 240,
                painter: QrPainter(
                  'MenuZy',
                  dotColor: const Color(0xFFF5A800),
                  eyeFrameColor: const Color(0xFFC8102E),
                  eyePupilColor: const Color(0xFFF5A800),
                  dotCornerRadius: 99,
                  dotSizeRatio: 0.7,
                  connectStyle: QrConnectStyle.horizontal,
                  centerLogoSafeZone: true,
                ),
                icon: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: const FlutterLogo(),
                ),
              ),
            ),

            // ─────────────────────────────────────────────
            section(
              'Custom Eyes',
              QrStyler(
                dimension: 240,
                painter: QrPainter(
                  'Custom Eyes',
                  topLeftEye: const EyeConfig(
                    outer: EyeRadii.all(Radius.circular(0)),
                    outerInner: EyeRadii.all(Radius.circular(8)),
                    pupil: EyeRadii.all(Radius.circular(50)),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
