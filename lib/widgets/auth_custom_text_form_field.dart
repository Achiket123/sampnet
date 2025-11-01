import 'package:flutter/material.dart';

class AuthCustomTextFormField extends StatelessWidget {
  final String? label;
  final String? hintText;
  final double? width;
  final TextEditingController? controller;
  final bool? obscureText;
  final Widget? suffixIcon;
  final TextStyle? style;
  final TextStyle? labelStyle;
  final TextStyle? hintStyle;

  const AuthCustomTextFormField({
    super.key,
    this.label,
    this.controller,
    this.hintText,
    this.width,
    this.obscureText,
    this.suffixIcon,
    this.style,
    this.labelStyle,
    this.hintStyle,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: TextFormField(
        validator: (val) {
          if (val!.isEmpty) {
            return "Please enter a valid $label";
          }
          return null;
        },
        controller: controller,
        obscureText: obscureText ?? false,
        style: style,
        decoration: InputDecoration(
          labelText: label,
          hintText: hintText,
          suffixIcon: suffixIcon,
          labelStyle: labelStyle,
          hintStyle: hintStyle,
        ),
      ),
    );
  }
}
