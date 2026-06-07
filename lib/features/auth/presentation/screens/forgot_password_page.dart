import 'package:flutter/material.dart';
import 'package:hackathon/globals/constants/color_pallete.dart';
import 'package:hackathon/widgets/auth_button.dart';

class ForgotPasswordPage extends StatefulWidget {
  static const String routePath = '/forgot-password';
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final TextEditingController emailController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

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
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    "Forgot Password",
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          color: ColorPallete.textPrimary,
                          fontWeight: FontWeight.bold,
                        ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    "Enter your email address and we'll send you a link to reset your password.",
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: ColorPallete.textPrimary.withOpacity(0.7),
                        ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32),
                  TextFormField(
                    controller: emailController,
                    style: const TextStyle(color: ColorPallete.textPrimary),
                    decoration: const InputDecoration(
                      labelText: "Email",
                      labelStyle: TextStyle(color: ColorPallete.textPrimary),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter your email";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 32),
                  AuthButton(
                    text: "Send Reset Link",
                    onpressed: () {
                      if (formKey.currentState!.validate()) {
                        // TODO: Implement forgot password logic
                      }
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
      ),
    );
  }
}
