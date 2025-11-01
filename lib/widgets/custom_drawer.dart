import 'package:flutter/material.dart';
import 'package:hackathon/features/dashboards/presentation/widgets/side_bar_widget.dart';

// ignore: must_be_immutable
class CustomDrawer extends StatelessWidget {
   int? selectedIndex;
   CustomDrawer({super.key, this.selectedIndex});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SideBarWidget(
        sheight: 0,
        swidth: 0,
        selectedIndex: selectedIndex,
      ),
    );
  }
}
