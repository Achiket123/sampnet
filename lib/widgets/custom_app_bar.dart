import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hackathon/features/dashboards/presentation/pages/dashboard.dart';
import 'package:hackathon/globals/constants/color_pallete.dart';

class CustomAppBar extends StatelessWidget {
  final List<Widget> children;
  final double? height;
  final VoidCallback? callback;
  final Color? backgroundColor;
  const CustomAppBar(
      {super.key, required this.children, this.height, this.backgroundColor,this.callback});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height ?? 60,
      decoration: BoxDecoration(
        color: backgroundColor ?? ColorPallete.redPrimary,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
            onPressed:callback ?? () {
              context.canPop()
                  ? context.pop()
                  : context.go(Dashboard.routePath);
            },
          ),
          ...children
        ],
      ),
    );
  }
}
