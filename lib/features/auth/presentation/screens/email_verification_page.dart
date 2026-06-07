import 'package:flutter/material.dart';
import 'package:hackathon/globals/constants/color_pallete.dart';
import 'package:hackathon/widgets/auth_button.dart';

class EmailVerificationPage extends StatelessWidget {
  static const String routePath = '/verify-email';
  const EmailVerificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [ColorPallete.backgroundPrimary, ColorPallete.backgroundSecondary],
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
          ),
        ),
        child: Center(
          child: Container(
            padding: const EdgeInsets.all(24),
            constraints: const BoxConstraints(maxWidth: 400),
            decoration: BoxDecoration(
              color: ColorPallete.textPrimary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Icon(
                  Icons.mark_email_unread_outlined,
                  size: 64,
                  color: ColorPallete.textPrimary,
                ),
                const SizedBox(height: 24),
                Text(
                  "Verify Your Email",
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        color: ColorPallete.textPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                Text(
                  "We've sent a verification link to your email address. Please click the link to verify your account.",
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: ColorPallete.textPrimary.withOpacity(0.7),
                      ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
                AuthButton(
                  text: "Resend Email",
                  onpressed: () {
                    // TODO: Implement resend verification logic
                  },
                ),
                const SizedBox(height: 16),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text(
                    "Back to Login",
                    style: TextStyle(color: ColorPallete.textPrimary),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
