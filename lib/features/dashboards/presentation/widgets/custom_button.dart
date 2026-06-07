import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hackathon/features/attendence/presentation/blocs/bloc/attendence_bloc.dart';
import 'package:intl/intl.dart';

import 'package:hackathon/globals/constants/color_pallete.dart';
import 'package:hackathon/globals/constants/styles.dart';

class CustomAttendanceButton extends StatefulWidget {
  final Function() onTap;
  final String text;
  final AttendenceBloc attendenceBloc;

  const CustomAttendanceButton(
      {super.key,
      required this.onTap,
      required this.text,
      required this.attendenceBloc});

  @override
  State<CustomAttendanceButton> createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomAttendanceButton> {
  @override
  void initState() {
    super.initState();
  }

  bool isHovered = false;

  double scale = 1.0;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer(
      listener: (context, state) {
        if (state is AttendenceFailure) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(state.errorModel.message),
              backgroundColor: ColorPallete.error));
        }
      },
      bloc: widget.attendenceBloc,
      builder: (context, state) {
        return MouseRegion(
          cursor: SystemMouseCursors.click,
          onEnter: (_) => setState(() {
            isHovered = true;
            scale = 1.05;
          }),
          onExit: (_) => setState(() {
            isHovered = false;
            scale = 1.0;
          }),
          child: GestureDetector(
            onTap: widget.onTap,
            child: Transform.scale(
              scale: scale,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 400),
                constraints: const BoxConstraints(
                  maxWidth: 150,
                  minWidth: 120,
                ),
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: ColorPallete.textSecondary,
                  borderRadius: BorderRadius.circular(5),
                  boxShadow: isHovered
                      ? [
                          BoxShadow(
                            color: const Color.fromARGB(255, 46, 46, 46)
                                .withOpacity(0.3),
                            blurRadius: 12,
                            spreadRadius: 2,
                          )
                        ]
                      : null,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      widget.text,
                      style: textTheme.displaySmall!.copyWith(fontSize: 10),
                    ),
                    if (state is AttendenceGetSuccess) ...[
                      Text(
                          widget.text == "CHECK-IN"
                              ? state.attendenceEntity.checkinTime != null
                                  ? DateFormat.jm().format(
                                      state.attendenceEntity.checkinTime!)
                                  : "--:--"
                              : state.attendenceEntity.checkoutTime != null
                                  ? DateFormat.jm().format(
                                      state.attendenceEntity.checkoutTime!)
                                  : "--:--",
                          style:
                              textTheme.displaySmall!.copyWith(fontSize: 10)),
                    ]
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class DashBoardButton extends StatefulWidget {
  final bool isSelected;
  final String text;
  final Function(int) onTap;
  final int index;
  const DashBoardButton(
      {super.key,
      required this.isSelected,
      required this.text,
      required this.onTap,
      required this.index});

  @override
  State<DashBoardButton> createState() => _DashBoardButtonState();
}

class _DashBoardButtonState extends State<DashBoardButton> {
  bool isHovered = false;
  double scale = 1.0;
  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() {
        isHovered = true;
        scale = 1.05;
      }),
      onExit: (_) => setState(() {
        isHovered = false;
        scale = 1.0;
      }),
      child: GestureDetector(
        onTap: () => widget.onTap(widget.index),
        child: Transform.scale(
          scale: scale,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            
            child: Center(
                child: Text(
              widget.text,
              style: textTheme.displayMedium!.copyWith(
                  color: ColorPallete.textPrimary, fontWeight: FontWeight.bold),
            )),
          ),
        ),
      ),
    );
  }
}

class DashBoardTextFunctionButton extends StatefulWidget {
  final String text;
  final Function() onTap;
  const DashBoardTextFunctionButton(
      {super.key, required this.text, required this.onTap});

  @override
  State<DashBoardTextFunctionButton> createState() =>
      _DashBoardTextFunctionButtonState();
}

class _DashBoardTextFunctionButtonState
    extends State<DashBoardTextFunctionButton> {
  bool isHovered = false;
  double scale = 1.0;
  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() {
        isHovered = true;
        scale = 1.05;
      }),
      onExit: (_) => setState(() {
        isHovered = false;
        scale = 1.0;
      }),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          padding: const EdgeInsets.all(10),
          height: 55,
          constraints: const BoxConstraints(
            maxWidth: 150,
            minWidth: 60,
          ),
          decoration: BoxDecoration(
            color: ColorPallete.textPrimary,
            borderRadius: BorderRadius.circular(10),
            boxShadow: isHovered
                ? [
                    BoxShadow(
                      color: ColorPallete.textPrimary.withOpacity(0.3),
                      blurRadius: 12,
                      spreadRadius: 2,
                    )
                  ]
                : null,
          ),
          duration: const Duration(milliseconds: 200),
          child: Center(
              child: Text(
            widget.text,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: textTheme.displaySmall!
                .copyWith(fontSize: 13, color: ColorPallete.textSecondary),
          )),
        ),
      ),
    );
  }
}
