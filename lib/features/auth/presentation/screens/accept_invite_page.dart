import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hackathon/dependency_injection.g.dart';
import 'package:hackathon/features/auth/domain/usecase/auth_usecase.dart';
import 'package:hackathon/features/landing/landing.dart';
import 'package:hackathon/globals/constants/color_pallete.dart';
import 'package:hackathon/widgets/auth_button.dart';

class AcceptInvitePage extends StatefulWidget {
  static const String routePath = '/accept-invite';
  final String? token;

  const AcceptInvitePage({super.key, this.token});

  @override
  State<AcceptInvitePage> createState() => _AcceptInvitePageState();
}

class _AcceptInvitePageState extends State<AcceptInvitePage> {
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool isPasswordVisible = false;
  bool isLoading = false;
  String? errorMessage;
  String? successMessage;

  @override
  void dispose() {
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    setState(() {
      errorMessage = null;
      successMessage = null;
    });

    if (widget.token == null || widget.token!.isEmpty) {
      setState(() {
        errorMessage = "Invalid invitation token. Please check your invitation email.";
      });
      return;
    }

    if (!formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      isLoading = true;
    });

    final useCase = getIt<AcceptInviteUseCase>();
    final result = await useCase.call(AcceptInviteParams(
      token: widget.token!,
      password: passwordController.text,
    ));

    result.fold(
      (failure) {
        setState(() {
          isLoading = false;
          errorMessage = failure.message;
        });
      },
      (authResponse) {
        setState(() {
          isLoading = false;
          successMessage = "Account setup complete! Redirecting...";
        });
        Future.delayed(const Duration(seconds: 2), () {
          if (mounted) {
            context.go('/');
          }
        });
      },
    );
  }

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
            margin: const EdgeInsets.symmetric(horizontal: 16),
            constraints: const BoxConstraints(maxWidth: 400),
            decoration: BoxDecoration(
              color: ColorPallete.textPrimary.withOpacity(0.05),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: ColorPallete.redPrimary.withOpacity(0.2),
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                )
              ],
            ),
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Icon(
                    Icons.mark_email_read_outlined,
                    color: ColorPallete.redPrimary,
                    size: 48,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    "Welcome to the Team",
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          color: ColorPallete.textPrimary,
                          fontWeight: FontWeight.bold,
                        ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Create a password to activate your account and join the organization.",
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: ColorPallete.textSecondary,
                        ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  if (errorMessage != null) ...[
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: ColorPallete.error.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: ColorPallete.error.withOpacity(0.3)),
                      ),
                      child: Text(
                        errorMessage!,
                        style: const TextStyle(color: ColorPallete.error, fontSize: 13),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                  if (successMessage != null) ...[
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: ColorPallete.success.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: ColorPallete.success.withOpacity(0.3)),
                      ),
                      child: Text(
                        successMessage!,
                        style: const TextStyle(color: ColorPallete.success, fontSize: 13),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                  TextFormField(
                    controller: passwordController,
                    obscureText: !isPasswordVisible,
                    style: const TextStyle(color: ColorPallete.textPrimary),
                    enabled: !isLoading && successMessage == null,
                    decoration: InputDecoration(
                      labelText: "Password",
                      labelStyle: const TextStyle(color: ColorPallete.textSecondary),
                      prefixIcon: const Icon(Icons.lock_outline, color: ColorPallete.textSecondary),
                      suffixIcon: IconButton(
                        icon: Icon(
                          isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                          color: ColorPallete.textSecondary,
                        ),
                        onPressed: () => setState(() => isPasswordVisible = !isPasswordVisible),
                      ),
                      enabledBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(color: ColorPallete.divider),
                      ),
                      focusedBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(color: ColorPallete.redPrimary),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter a password";
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
                    enabled: !isLoading && successMessage == null,
                    decoration: const InputDecoration(
                      labelText: "Confirm Password",
                      labelStyle: TextStyle(color: ColorPallete.textSecondary),
                      prefixIcon: Icon(Icons.lock_reset_outlined, color: ColorPallete.textSecondary),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: ColorPallete.divider),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: ColorPallete.redPrimary),
                      ),
                    ),
                    validator: (value) {
                      if (value != passwordController.text) {
                        return "Passwords do not match";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 32),
                  if (isLoading)
                    const Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(ColorPallete.redPrimary),
                      ),
                    )
                  else
                    AuthButton(
                      text: "Activate Account",
                      onpressed: successMessage != null ? () {} : _submit,
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
