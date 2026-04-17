# QR Styler

<p align="center">
  <img src="https://img.shields.io/pub/v/qr_styler.svg" alt="pub version">
  <img src="https://img.shields.io/badge/platform-flutter-blue.svg" alt="platform">
  <img src="https://img.shields.io/badge/license-MIT-green.svg" alt="license">
  <img src="https://img.shields.io/badge/dart-%3E%3D3.0.0-blue.svg" alt="dart version">
</p>

<p align="center">
  A Flutter package for generating highly customizable, visually modern QR codes — with full control over dots, finder eyes, connection styles, and center logos, all while maintaining reliable scan performance.
</p>

---

## ✨ Features

- 🎨 **Customizable dots** — control color, size, and corner rounding
- 🔗 **Dot connection styles** — horizontal bars, vertical bars, or standalone dots
- 👁️ **Full finder eye control** — independently style outer frame, inner gap, and pupil
- 🖼️ **Center logo support** — with automatic safe zone clearing
- 📐 **Scalable rendering** — all elements scale proportionally from a single `dimension`
- 🔒 **High error correction** — uses QR error correction level H internally
- ⚡ **Performant** — lightweight `CustomPainter` implementation, no heavy dependencies

---

## 📦 Installation

Add to your `pubspec.yaml`:

```yaml
dependencies:
  qr_styler: ^0.0.1
```

Then fetch the package:

```bash
flutter pub get
```

---

## 🚀 Quick Start

```dart
QrStyler(
  dimension: 200,
  painter: QrPainter('https://example.com'),
)
```

A more complete example with custom styling:

```dart
QrStyler(
  dimension: 240,
  painter: QrPainter(
    'https://example.com',
    dotColor: Colors.black,
    dotSizeRatio: 0.7,
    dotCornerRadius: 20,
    connectStyle: QrConnectStyle.horizontal,
    centerLogoSafeZone: true,
    eyeFrameColor: Colors.blue,
    eyePupilColor: Colors.orange,
  ),
  icon: const FlutterLogo(),
)
```

---

## 📖 API Reference

### `QrStyler` Widget

The top-level widget that renders the QR code on screen.

| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `dimension` | `double` | ✅ | Width and height of the QR widget (always square) |
| `painter` | `QrPainter` | ✅ | Core painter handling all rendering logic |
| `icon` | `Widget?` | ❌ | Optional center logo (use with `centerLogoSafeZone`) |
| `backgroundColor` | `Color?` | ❌ | Background fill color of the QR container |

---

### `QrPainter`

The core engine that converts your data into a styled QR code using a grid-based `CustomPainter` system.

#### Required

| Parameter | Type | Description |
|-----------|------|-------------|
| `data` | `String` | Content to encode — URL, plain text, or any string |

#### Dot Styling

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `dotColor` | `Color` | `0xFFF5A800` | Color of QR data dots |
| `dotSizeRatio` | `double` | `0.72` | Dot size relative to cell size (`0.0`–`1.0`) |
| `dotCornerRadius` | `double` | `0` | Corner radius of each dot (`0` = square, `30` = fully rounded) |

> **Tip:** `dotSizeRatio` between `0.6`–`0.8` gives the best balance of aesthetics and scannability.

#### Dot Connections

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `connectStyle` | `QrConnectStyle` | `none` | How adjacent dots are joined |

**`QrConnectStyle` options:**

| Value | Behavior |
|-------|----------|
| `QrConnectStyle.none` | Each dot is independent |
| `QrConnectStyle.horizontal` | Adjacent dots in the same row are merged into bars |
| `QrConnectStyle.vertical` | Adjacent dots in the same column are merged into bars |

#### Finder Eyes

The three corner markers that allow scanners to detect QR orientation.

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `eyeFrameColor` | `Color` | red tone | Outer frame color of each finder eye |
| `eyePupilColor` | `Color` | orange tone | Center pupil color of each finder eye |

**Eye structure (sizes in QR modules):**

| Layer | Size | Purpose |
|-------|------|---------|
| Outer | 7×7 | Main frame |
| Inner | 5×5 | White gap separating frame from pupil |
| Pupil | 3×3 | Center marker dot |

For advanced shape customization, use `EyeConfig` and `EyeRadii`:

```dart
EyeConfig(
  outer: EyeRadii(
    topLeft: Radius.circular(24),
    topRight: Radius.circular(24),
    bottomLeft: Radius.zero,
    bottomRight: Radius.circular(24),
  ),
  outerInner: EyeRadii(...),
  pupil: EyeRadii(...),
)
```

#### Center Logo

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `centerLogoSafeZone` | `bool` | `false` | Clears QR modules from the center to make space for the logo |
| `iconSizeRatio` | `double` | `0.20` | Logo size as a ratio of `dimension` (`0.10`–`0.30`) |

> ⚠️ Always enable `centerLogoSafeZone` when using a center icon. A large `iconSizeRatio` (above `0.25`) may reduce scan reliability.

---

## 🔬 Rendering System

QR Styler uses a proportional grid system. The QR matrix is divided into equal cells, and all visual elements are derived from the cell size:

```
cell size       = dimension / moduleCount
dot size        = cell × dotSizeRatio
eye outer size  = 7 × cell
eye inner size  = 5 × cell
eye pupil size  = 3 × cell
```

Everything scales automatically when you change `dimension`.

---

## ✅ Best Practices

- Keep `dotSizeRatio` between **0.6 and 0.8** for optimal readability
- Always **test your QR code** with multiple scanner apps before deploying
- Enable **`centerLogoSafeZone`** whenever you use a logo
- Maintain **high contrast** between dot color and background
- Avoid heavily customized finder eyes in production — subtle rounding is safer than extreme shapes
- Error correction level H is applied internally, giving roughly 30% data recovery capacity

---

## 📋 Complete Example

```dart
import 'package:flutter/material.dart';
import 'package:qr_styler/qr_styler.dart';

class QrExample extends StatelessWidget {
  const QrExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: QrStyler(
          dimension: 280,
          backgroundColor: Colors.white,
          painter: QrPainter(
            'https://example.com',
            dotColor: Colors.black87,
            dotSizeRatio: 0.75,
            dotCornerRadius: 16,
            connectStyle: QrConnectStyle.horizontal,
            eyeFrameColor: Colors.indigo,
            eyePupilColor: Colors.indigoAccent,
            centerLogoSafeZone: true,
            iconSizeRatio: 0.18,
          ),
          icon: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
            padding: const EdgeInsets.all(4),
            child: const FlutterLogo(size: 32),
          ),
        ),
      ),
    );
  }
}
```

---

## 📄 License

This package is released under the [MIT License](LICENSE).

---

<p align="center">Made with ❤️ for the Flutter community</p>
