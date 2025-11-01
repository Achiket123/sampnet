import 'package:flutter/material.dart';
import 'package:hackathon/globals/constants/color_pallete.dart';

TextTheme textTheme = const TextTheme(
    titleLarge: TextStyle(
      color: ColorPallete.white,
      fontSize: 50,
      fontWeight: FontWeight.bold,
    ),
    headlineLarge: TextStyle(
      color: ColorPallete.white,
      fontSize: 50,
      fontWeight: FontWeight.bold,
    ),
    headlineMedium: TextStyle(
      color: ColorPallete.white,
      fontSize: 30,
      fontWeight: FontWeight.bold,
    ),
    headlineSmall: TextStyle(
        color: ColorPallete.white, fontSize: 15, fontWeight: FontWeight.bold),
    bodyMedium: TextStyle(
        color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold),
    displaySmall: TextStyle(
        color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
    displayMedium: TextStyle(
        color: Colors.black, fontSize: 12, fontWeight: FontWeight.bold),
    bodySmall: TextStyle(color: Colors.white, fontSize: 9));

InputDecorationTheme inputDecorationTheme = InputDecorationTheme(
    border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(5),
        borderSide: const BorderSide(
          width: 2.0,
          color: ColorPallete.white,
          strokeAlign: BorderSide.strokeAlignCenter,
          style: BorderStyle.solid,
        )),
    contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
    focusedBorder: const GradientOutlineInputBorder(
        animation: AlwaysStoppedAnimation(1),
        borderSide: BorderSide(
          width: 2.0,
          color: ColorPallete.white,
        ),
        gradient: LinearGradient(colors: [
          Color.fromARGB(255, 106, 106, 106),
          Color.fromARGB(255, 176, 39, 158)
        ], begin: Alignment.topLeft, end: Alignment.bottomRight)),
    outlineBorder: const BorderSide(color: Colors.red));

class GradientOutlineInputBorder extends OutlineInputBorder {
  final Gradient gradient;
  final Animation<double> animation;

  const GradientOutlineInputBorder({
    required this.gradient,
    this.animation = const AlwaysStoppedAnimation(0),
    super.borderSide = const BorderSide(),
    super.borderRadius = const BorderRadius.all(Radius.circular(4.0)),
    super.gapPadding = 15.0,
  });

  @override
  void paint(Canvas canvas, Rect rect,
      {double? gapStart,
      double gapExtent = 0.0,
      double gapPercentage = 0.0,
      TextDirection? textDirection}) {
    canvas.save();

    final center = rect.center;
    canvas.translate(center.dx, center.dy);
    canvas.rotate(animation.value * 2 * 3.14159);
    canvas.translate(-center.dx, -center.dy);

    final Paint paint = Paint()
      ..shader = gradient.createShader(rect)
      ..strokeWidth = borderSide.width
      ..style = PaintingStyle.stroke;

    Path path = getOuterPath(rect, textDirection: textDirection);
    canvas.drawPath(path, paint);

    canvas.restore();
  }

  @override
  GradientOutlineInputBorder copyWith({
    BorderSide? borderSide,
    BorderRadius? borderRadius,
    double? gapPadding,
    Gradient? gradient,
    Animation<double>? animation,
  }) {
    return GradientOutlineInputBorder(
      borderSide: borderSide ?? this.borderSide,
      borderRadius: borderRadius ?? this.borderRadius,
      gapPadding: gapPadding ?? this.gapPadding,
      gradient: gradient ?? this.gradient,
      animation: animation ?? this.animation,
    );
  }
}
