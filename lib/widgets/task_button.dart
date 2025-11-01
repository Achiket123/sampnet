import 'package:flutter/material.dart';
import 'package:hackathon/globals/constants/color_pallete.dart';

class CustomTextButton extends StatelessWidget {
  const CustomTextButton(
      {super.key,
      required this.text,
      required this.onTap,
      this.icon,
      this.color,
      this.width,
      this.height});
  final Widget text;
  final Color? color;
  final Function() onTap;
  final IconData? icon;
  final double? width;
  final double? height;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: Container(
          padding: const EdgeInsets.all(10),
          width: width ?? 100,
          height: height ?? 50,
          decoration: BoxDecoration(
            color: color ?? Colors.black,
            gradient: color != null
                ? const LinearGradient(
                    colors: ColorPallete.background2,
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  )
                : null,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              text,
              if (icon != null) Icon(icon),
            ],
          ),
        ),
      ),
    );
  }
}
