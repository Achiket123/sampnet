import 'package:flutter/material.dart';
import 'package:hackathon/globals/constants/color_pallete.dart';
import 'package:hackathon/globals/constants/styles.dart';

class BannerBase extends StatelessWidget {
  final String text;
  final String image;
  final double? size;
  final double? rotation;
  final double? imageScale;
  const BannerBase(
      {super.key,
      required this.text,
      required this.image,
      this.size,
      this.rotation,
      this.imageScale});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.maxFinite,
      margin: const EdgeInsets.all(20),
      // padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
              colors: [ColorPallete.backgroundPrimary, ColorPallete.backgroundSecondary],
              transform: GradientRotation(rotation ?? -15))),
      child: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Row(
          children: [
            Flexible(
              flex: 1,
              child: Text(text,
                  style: textTheme.headlineLarge!.copyWith(
                      fontSize: size ?? 60, fontWeight: FontWeight.bold)),
            ),
            // Spacer(),
            Image.asset(image, scale: imageScale ?? 5)
          ],
        ),
      ),
    );
  }
}
