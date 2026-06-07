import 'package:flutter/material.dart';
import 'package:hackathon/features/auth/presentation/screens/sign_in_dialog.dart';
import 'package:hackathon/features/auth/presentation/screens/sign_up_dialog.dart';
import 'package:hackathon/globals/constants/color_pallete.dart';
import 'package:hackathon/globals/constants/styles.dart';
import 'package:hackathon/widgets/auth_button.dart';

class LandingAppBar extends StatelessWidget {
  const LandingAppBar({
    super.key,
    required this.swidth,
  });

  final double swidth;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      width: swidth,
      height: 60,
      decoration: const BoxDecoration(
          color: ColorPallete.redPrimary,
          boxShadow: [
            BoxShadow(color: ColorPallete.backgroundPrimary, blurRadius: 15),
          ],
          borderRadius: BorderRadius.all(Radius.circular(15))),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
              child: RichText(
                  text: TextSpan(
                      text: "SAMPNet",
                      style: textTheme.headlineMedium,
                      children: [
                    TextSpan(
                        text: "  YOUR ALL IN ONE BUSSINESS SOLUTION.",
                        style: textTheme.headlineSmall),
                  ])),
            ),
            SizedBox(
                width: 100,
                height: 80,
                child: AuthButton(
                    text: "LOGIN",
                    onpressed: () {
                      showDialog(
                          context: context,
                          builder: (context) =>
                              const Dialog(child: SignInScreen()));
                    })),
            SizedBox(
                width: 100,
                height: 80,
                child: AuthButton(
                    text: "SIGNUP",
                    onpressed: () {
                       showDialog(
                          context: context,
                          builder: (context) =>
                              const Dialog(child: SignUpDialog()));
                    })),
          ],
        ),
      ),
    );
  }
}
