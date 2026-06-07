import 'package:flutter/material.dart';
import 'package:hackathon/globals/constants/color_pallete.dart';

class TaskWidget extends StatelessWidget {
  const TaskWidget({super.key});
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: ColorPallete.textPrimary,
          borderRadius: BorderRadius.circular(10)),
      child:const Row(
        children: [
          Icon(Icons.menu),
          ListTile(
            title: Text(
                "Consequat nisi minim magna eu exercitation enim duis aute culpa cupid"),
            subtitle: Text(
                "Aliqua dolor in est fugiat est eu irure sunt nostrud ea nostrud."),
          ),
          // Container(child: ,)
        ],
      ),
    );
  }
}
