import 'package:flutter/material.dart';
import 'package:hackathon/globals/constants/color_pallete.dart';
import 'package:hackathon/globals/constants/styles.dart';
import 'package:hackathon/widgets/nav_arrow_button.dart';

class IntroWidgets extends StatelessWidget {
  final String text;
  final Function() onTap;
  const IntroWidgets({super.key, required this.text, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final swidth = MediaQuery.of(context).size.width;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: ColorPallete.backgroundPrimary,
          boxShadow: const [
            BoxShadow(
                color: ColorPallete.backgroundSecondary,
                blurRadius: 3,
                blurStyle: BlurStyle.outer,
                spreadRadius: 2)
          ]),

      // height: 300,
      width: swidth / 3.5,
      child: Column(
        children: [
          Text(
            text,
            style: textTheme.headlineMedium!
                .copyWith(fontWeight: FontWeight.normal),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: NavArrowButton(
              text: ">",
              onpressed: onTap,
              color: ColorPallete.backgroundPrimary,
            ),
          )
        ],
      ),
    );
  }
}
