// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:qr/qr.dart';
import 'package:qr_styler/src/models/eye_config.dart';
import 'package:qr_styler/src/models/eye_radii.dart';
import 'package:qr_styler/src/models/qr_connect_style.dart';

// ─────────────────────────────────────────────────────────────────────────────
// QrPainter
// ─────────────────────────────────────────────────────────────────────────────
class QrPainter extends CustomPainter {
  // ── Data ──────────────────────────────────────────────────────────────────
  final String data;

  // ── Dot style ─────────────────────────────────────────────────────────────
  final Color dotColor;
  final double dotSizeRatio; // relative to cell (0–1)
  final double dotCornerRadius; // 99 = full pill
  final QrConnectStyle connectStyle;

  // ── Eye configs (one per finder eye) ─────────────────────────────────────
  final EyeConfig topLeftEye;
  final EyeConfig topRightEye;
  final EyeConfig bottomLeftEye;

  // ── Eye colors ────────────────────────────────────────────────────────────
  final Color eyeFrameColor;
  final Color eyePupilColor;

  // ── Center safe zone ──────────────────────────────────────────────────────
  final bool centerLogoSafeZone;
  final double iconSizeRatio;

  // ─────────────────────────────────────────────────────────────────────────
  const QrPainter(
    this.data, {
    this.dotColor = const Color(0xFFF5A800),
    this.eyeFrameColor = const Color(0xFFC8102E),
    this.eyePupilColor = const Color(0xFFF5A800),
    this.dotSizeRatio = 0.72,
    this.dotCornerRadius = 99,
    this.connectStyle = QrConnectStyle.none,
    this.centerLogoSafeZone = false,
    this.iconSizeRatio = 0.20,

    // Default: sharp on the inward corner, rounded everywhere else
    EyeConfig? topLeftEye,
    EyeConfig? topRightEye,
    EyeConfig? bottomLeftEye,
  }) : topLeftEye =
           topLeftEye ??
           const EyeConfig(
             outer: EyeRadii(
               topLeft: Radius.circular(24),
               topRight: Radius.circular(24),
               bottomLeft: Radius.circular(24),
               bottomRight: Radius.zero,
             ),
             outerInner: EyeRadii(
               topLeft: Radius.circular(16),
               topRight: Radius.circular(16),
               bottomLeft: Radius.circular(16),
               bottomRight: Radius.zero,
             ),
             pupil: EyeRadii(
               topLeft: Radius.circular(12),
               topRight: Radius.circular(12),
               bottomLeft: Radius.circular(12),
               bottomRight: Radius.circular(12),
             ),
           ),
       topRightEye =
           topRightEye ??
           const EyeConfig(
             outer: EyeRadii(
               topLeft: Radius.circular(24),
               topRight: Radius.circular(24),
               bottomLeft: Radius.zero,
               bottomRight: Radius.circular(24),
             ),
             outerInner: EyeRadii(
               topLeft: Radius.circular(16),
               topRight: Radius.circular(16),
               bottomLeft: Radius.zero,
               bottomRight: Radius.circular(16),
             ),
             pupil: EyeRadii(
               topLeft: Radius.circular(12),
               topRight: Radius.circular(12),
               bottomLeft: Radius.circular(12),
               bottomRight: Radius.circular(12),
             ),
           ),
       bottomLeftEye =
           bottomLeftEye ??
           const EyeConfig(
             outer: EyeRadii(
               topLeft: Radius.circular(24),
               topRight: Radius.zero,
               bottomLeft: Radius.circular(24),
               bottomRight: Radius.circular(24),
             ),
             outerInner: EyeRadii(
               topLeft: Radius.circular(16),
               topRight: Radius.zero,
               bottomLeft: Radius.circular(16),
               bottomRight: Radius.circular(16),
             ),
             pupil: EyeRadii(
               topLeft: Radius.circular(12),
               topRight: Radius.circular(12),
               bottomLeft: Radius.circular(12),
               bottomRight: Radius.circular(12),
             ),
           );

  // ─────────────────────────────────────────────────────────────────────────
  @override
  void paint(Canvas canvas, Size size) {
    final qr = QrImage(
      QrCode.fromData(data: data, errorCorrectLevel: QrErrorCorrectLevel.H),
    );
    final count = qr.moduleCount;
    final cell = size.width / count;

    _drawDots(canvas, qr, count, cell);

    _drawEye(canvas, cell, col: 0, row: 0, config: topLeftEye);
    _drawEye(canvas, cell, col: count - 7, row: 0, config: topRightEye);
    _drawEye(canvas, cell, col: 0, row: count - 7, config: bottomLeftEye);
  }

  // ── Dots + connectors ─────────────────────────────────────────────────────
  void _drawDots(Canvas canvas, QrImage qr, int count, double cell) {
    final dotSize = cell * dotSizeRatio;
    final paint = Paint()
      ..style = PaintingStyle.fill
      ..color = dotColor;

    final int safeStart = (count / 2).floor() - 2;
    final int safeEnd = (count / 2).ceil() + 2;

    // ── Pass 1: collect active dot centers ───────────────────────────────
    final Map<String, Offset> dotMap = {};

    for (int col = 0; col < count; col++) {
      for (int row = 0; row < count; row++) {
        if (_isEyeRegion(col, row, count)) continue;
        if (centerLogoSafeZone && _isInSafeZone(col, row, safeStart, safeEnd)) {
          continue;
        }
        if (!qr.isDark(row, col)) continue;

        dotMap['$col,$row'] = Offset(
          col * cell + cell / 2,
          row * cell + cell / 2,
        );
      }
    }

    // ── Pass 2: connectors ────────────────────────────────────────────────
    switch (connectStyle) {
      case QrConnectStyle.horizontal:
        _drawHorizontalConnectors(canvas, dotMap, count, dotSize, paint);
      case QrConnectStyle.vertical:
        _drawVerticalConnectors(canvas, dotMap, count, dotSize, paint);
      case QrConnectStyle.none:
        break;
    }

    // ── Pass 3: dots on top ───────────────────────────────────────────────
    for (final center in dotMap.values) {
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromCenter(center: center, width: dotSize, height: dotSize),
          Radius.circular(dotCornerRadius),
        ),
        paint,
      );
    }
  }

  // ── Horizontal pill connectors ────────────────────────────────────────────
  void _drawHorizontalConnectors(
    Canvas canvas,
    Map<String, Offset> dotMap,
    int count,
    double dotSize,
    Paint paint,
  ) {
    for (int row = 0; row < count; row++) {
      int? runStart;

      for (int col = 0; col <= count; col++) {
        final isActive = dotMap.containsKey('$col,$row');

        if (isActive && runStart == null) {
          runStart = col;
        } else if (!isActive && runStart != null) {
          final runEnd = col - 1;

          if (runEnd > runStart) {
            final left = dotMap['$runStart,$row']!;
            final right = dotMap['$runEnd,$row']!;

            canvas.drawRRect(
              RRect.fromRectAndRadius(
                Rect.fromLTWH(
                  left.dx - dotSize / 2,
                  left.dy - dotSize / 2,
                  right.dx - left.dx + dotSize,
                  dotSize,
                ),
                Radius.circular(dotCornerRadius),
              ),
              paint,
            );
          }
          runStart = null;
        }
      }
    }
  }

  // ── Vertical pill connectors ──────────────────────────────────────────────
  void _drawVerticalConnectors(
    Canvas canvas,
    Map<String, Offset> dotMap,
    int count,
    double dotSize,
    Paint paint,
  ) {
    for (int col = 0; col < count; col++) {
      int? runStart;

      for (int row = 0; row <= count; row++) {
        final isActive = dotMap.containsKey('$col,$row');

        if (isActive && runStart == null) {
          runStart = row;
        } else if (!isActive && runStart != null) {
          final runEnd = row - 1;

          if (runEnd > runStart) {
            final top = dotMap['$col,$runStart']!;
            final bottom = dotMap['$col,$runEnd']!;

            canvas.drawRRect(
              RRect.fromRectAndRadius(
                Rect.fromLTWH(
                  top.dx - dotSize / 2,
                  top.dy - dotSize / 2,
                  dotSize,
                  bottom.dy - top.dy + dotSize,
                ),
                Radius.circular(dotCornerRadius),
              ),
              paint,
            );
          }
          runStart = null;
        }
      }
    }
  }

  // ── Single finder eye ─────────────────────────────────────────────────────
  //
  //  Eye anatomy (cells):
  //  ┌───────────────────────┐  ← outer      (7×7, config.outer)
  //  │ ┌───────────────────┐ │  ← outerInner (5×5, config.outerInner) — hole edge
  //  │ │                   │ │    white gap shows between outerInner and pupil
  //  │ │   ┌───────────┐   │ │  ← pupil      (3×3, config.pupil)
  //  │ │   │           │   │ │
  //  │ │   └───────────┘   │ │
  //  │ │                   │ │
  //  │ └───────────────────┘ │
  //  └───────────────────────┘
  //
  void _drawEye(
    Canvas canvas,
    double cell, {
    required int col,
    required int row,
    required EyeConfig config,
  }) {
    final double x = col * cell;
    final double y = row * cell;

    final double x1 = x + cell, y1 = y + cell; // outerInner inset (1 cell)
    final double x2 = x + cell * 2,
        y2 = y + cell * 2; // pupil inset      (2 cells)
    final double s7 = cell * 7, s5 = cell * 5, s3 = cell * 3;

    final outerRRect = _rrect(x, y, s7, s7, config.outer);
    final outerInnerRRect = _rrect(x1, y1, s5, s5, config.outerInner);
    final pupilRRect = _rrect(x2, y2, s3, s3, config.pupil);

    // Layer 1 — colored frame ring (evenOdd punches the hole with outerInner shape)
    canvas.drawPath(
      Path()
        ..addRRect(outerRRect)
        ..addRRect(outerInnerRRect)
        ..fillType = PathFillType.evenOdd,
      Paint()..color = eyeFrameColor,
    );

    // Layer 2 — white gap (flood-fills the hole so background doesn't bleed)
    canvas.drawRRect(outerInnerRRect, Paint()..color = Colors.white);

    // Layer 3 — solid colored pupil
    canvas.drawRRect(pupilRRect, Paint()..color = eyePupilColor);
  }

  // ── Helpers ───────────────────────────────────────────────────────────────
  RRect _rrect(double x, double y, double w, double h, EyeRadii r) =>
      RRect.fromLTRBAndCorners(
        x,
        y,
        x + w,
        y + h,
        topLeft: r.topLeft,
        topRight: r.topRight,
        bottomLeft: r.bottomLeft,
        bottomRight: r.bottomRight,
      );

  bool _isEyeRegion(int col, int row, int count) =>
      (col < 7 && row < 7) ||
      (col > count - 8 && row < 7) ||
      (col < 7 && row > count - 8);

  bool _isInSafeZone(int col, int row, int start, int end) =>
      col >= start && col <= end && row >= start && row <= end;

  // ─────────────────────────────────────────────────────────────────────────
  @override
  bool shouldRepaint(covariant QrPainter old) =>
      old.data != data ||
      old.dotColor != dotColor ||
      old.eyeFrameColor != eyeFrameColor ||
      old.eyePupilColor != eyePupilColor ||
      old.dotSizeRatio != dotSizeRatio ||
      old.dotCornerRadius != dotCornerRadius ||
      old.connectStyle != connectStyle ||
      old.topLeftEye != topLeftEye ||
      old.topRightEye != topRightEye ||
      old.bottomLeftEye != bottomLeftEye ||
      old.centerLogoSafeZone != centerLogoSafeZone ||
      old.iconSizeRatio != iconSizeRatio;
}
