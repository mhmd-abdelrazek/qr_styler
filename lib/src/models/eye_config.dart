import 'eye_radii.dart';

class EyeConfig {
  final EyeRadii outer; // outer boundary of the frame
  final EyeRadii outerInner; // inner boundary of the frame (hole edge)
  final EyeRadii pupil; // filled center square

  const EyeConfig({
    required this.outer,
    required this.outerInner,
    required this.pupil,
  });

  /// Convenience: one radius value for every corner of every layer
  static EyeConfig uniform({
    required double outerRadius,
    required double outerInnerRadius,
    required double pupilRadius,
  }) => EyeConfig(
    outer: EyeRadii.circular(outerRadius),
    outerInner: EyeRadii.circular(outerInnerRadius),
    pupil: EyeRadii.circular(pupilRadius),
  );
}
