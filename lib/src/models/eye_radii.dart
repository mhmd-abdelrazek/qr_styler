// ─────────────────────────────────────────────────────────────────────────────
// EyeRadii
// ─────────────────────────────────────────────────────────────────────────────

import 'dart:ui';

class EyeRadii {
  final Radius topLeft;
  final Radius topRight;
  final Radius bottomLeft;
  final Radius bottomRight;

  const EyeRadii({
    this.topLeft = const Radius.circular(0),
    this.topRight = const Radius.circular(0),
    this.bottomLeft = const Radius.circular(0),
    this.bottomRight = const Radius.circular(0),
  });

  const EyeRadii.all(Radius r)
    : topLeft = r,
      topRight = r,
      bottomLeft = r,
      bottomRight = r;

  static EyeRadii circular(double r) => EyeRadii.all(Radius.circular(r));
  static EyeRadii get zero => const EyeRadii.all(Radius.circular(0));

  EyeRadii copyWith({
    Radius? topLeft,
    Radius? topRight,
    Radius? bottomLeft,
    Radius? bottomRight,
  }) {
    return EyeRadii(
      topLeft: topLeft ?? this.topLeft,
      topRight: topRight ?? this.topRight,
      bottomLeft: bottomLeft ?? this.bottomLeft,
      bottomRight: bottomRight ?? this.bottomRight,
    );
  }
}