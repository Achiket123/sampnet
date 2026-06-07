import 'package:flutter/material.dart';
import 'package:hackathon/globals/constants/color_pallete.dart';
import 'package:hackathon/widgets/auth_button.dart';

class ResetPasswordPage extends StatefulWidget {
  static const String routePath = '/reset-password';
  const ResetPasswordPage({super.key});

  @override
  State<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool isPasswordVisible = false;

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
                    "Reset Password",
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          color: ColorPallete.textPrimary,
                          fontWeight: FontWeight.bold,
                        ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    "Enter your new password below.",
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: ColorPallete.textPrimary.withOpacity(0.7),
                        ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32),
                  TextFormField(
                    controller: passwordController,
                    obscureText: !isPasswordVisible,
                    style: const TextStyle(color: ColorPallete.textPrimary),
                    decoration: InputDecoration(
                      labelText: "New Password",
                      labelStyle: const TextStyle(color: ColorPallete.textPrimary),
                      suffixIcon: IconButton(
                        icon: Icon(
                          isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                          color: ColorPallete.textPrimary,
                        ),
                        onPressed: () => setState(() => isPasswordVisible = !isPasswordVisible),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter a new password";
                      }
                      if (value.length < 6) {
                        return "Password must be at least 6 characters";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: confirmPasswordController,
                    obscureText: !isPasswordVisible,
                    style: const TextStyle(color: ColorPallete.textPrimary),
                    decoration: const InputDecoration(
                      labelText: "Confirm New Password",
                      labelStyle: TextStyle(color: ColorPallete.textPrimary),
                    ),
                    validator: (value) {
                      if (value != passwordController.text) {
                        return "Passwords do not match";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 32),
                  AuthButton(
                    text: "Reset Password",
                    onpressed: () {
                      if (formKey.currentState!.validate()) {
                        // TODO: Implement reset password logic
                      }
                    },
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
