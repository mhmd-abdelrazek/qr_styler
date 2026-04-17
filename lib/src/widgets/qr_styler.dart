import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../painters/qr_painter.dart';

class QrStyler extends StatelessWidget {
  final QrPainter painter;
  final double dimension;

  final Widget? icon;
  final Color? backgroundColor;

  const QrStyler({
    super.key,
    required this.painter,
    required this.dimension,
    this.icon,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    Widget qrBox = CustomPaint(size: Size.square(dimension), painter: painter);

    if (icon != null) {
      qrBox = Stack(
        alignment: AlignmentGeometry.center,
        children: [
          qrBox,
          SizedBox.square(
            dimension: dimension * painter.iconSizeRatio,
            child: icon,
          ),
        ],
      );
    }

    return SizedBox.square(dimension: dimension, child: qrBox);
  }
}
