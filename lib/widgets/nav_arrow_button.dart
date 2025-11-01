import 'package:flutter/material.dart';
import 'package:hackathon/globals/constants/color_pallete.dart';
import 'package:hackathon/globals/constants/styles.dart';

class NavArrowButton extends StatelessWidget {
  final String? text;
  final Function() onpressed;
  final TextStyle? textStyle;
  final Color? color;
  const NavArrowButton(
      {super.key,
      required this.text,
      required this.onpressed,
      this.textStyle,
      this.color});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ElevatedButton(
        onPressed: onpressed,
        style: ButtonStyle(
            shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5), side: BorderSide.none)),
            backgroundColor:
                WidgetStatePropertyAll(color ?? ColorPallete.blackPrimary)),
        child: Text(
          text ?? ">",
          style: textStyle ?? textTheme.bodyMedium,
        ),
      ),
    );
  }
}
