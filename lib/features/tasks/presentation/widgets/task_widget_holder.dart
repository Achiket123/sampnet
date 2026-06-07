import 'package:flutter/material.dart';
import 'package:hackathon/widgets/task_button.dart';
import 'package:hackathon/globals/constants/color_pallete.dart';

// ignore: must_be_immutable
class TaskWidgetHolder extends StatelessWidget {
  TaskWidgetHolder({super.key, required this.children, required this.text});
  List<Widget> children;
  final Widget text;
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.sizeOf(context).height;
    final width = MediaQuery.sizeOf(context).width;
    return Expanded(
      child: SizedBox(
        height: height * 0.7,
        child: Column(
          children: [
            CustomTextButton(
              color: ColorPallete.textSecondary,
              width: width * 0.2,
              text: text,
              onTap: () {},
            ),
            SizedBox(height: height * 0.01),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  // color: ColorPallete.backgroundPrimary,
                  borderRadius: BorderRadius.circular(10),
                ),
                width: width * 0.8,
                child: SingleChildScrollView(
                  child: Column(
                    children: [...children],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
