import 'package:flutter/material.dart';
import 'package:hackathon/globals/constants/styles.dart';

class AuthButton extends StatelessWidget {
  final String text;
  final Function() onpressed;
  final TextStyle? textStyle;
  final double? width;
  final double? height;
  const AuthButton(
      {super.key,
      required this.text,
      required this.onpressed,
      this.textStyle,
      this.width,
      this.height});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: onpressed,
          child: Container(
            width: width,
            height: height,
            decoration: BoxDecoration(
                color: const Color.fromARGB(255, 27, 27, 27),
                borderRadius: BorderRadius.circular(4)),
            child: Center(
              child: Text(
                text,
                style: textStyle ?? textTheme.bodyMedium,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
