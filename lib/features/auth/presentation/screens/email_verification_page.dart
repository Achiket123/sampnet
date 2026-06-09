import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hackathon/dependency_injection.g.dart';
import 'package:hackathon/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:hackathon/globals/constants/color_pallete.dart';
import 'package:hackathon/widgets/auth_button.dart';
import 'package:go_router/go_router.dart';
import 'package:hackathon/services/token_manager.dart';
import 'package:hackathon/globals/constants/user.dart';
import 'package:hackathon/features/landing/landing.dart';

class EmailVerificationPage extends StatelessWidget {
  static const String routePath = '/verify-email';
  const EmailVerificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AuthBloc>(
      create: (_) => getIt<AuthBloc>(),
      child: Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [ColorPallete.backgroundPrimary, ColorPallete.backgroundSecondary],
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
            ),
          ),
          child: Center(
            child: BlocConsumer<AuthBloc, AuthState>(
              listener: (context, state) {
                if (state is AuthVerificationEmailSent) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Verification email sent! Please check your inbox."),
                      backgroundColor: Colors.green,
                    ),
                  );
                } else if (state is AuthGetMeSuccess) {
                  if (state.auth.userEntity.isVerified) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Email successfully verified!"),
                        backgroundColor: Colors.green,
                      ),
                    );
                    context.go('/');
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Email is still not verified. Please verify using the link sent to your email."),
                        backgroundColor: Colors.orange,
                      ),
                    );
                  }
                } else if (state is AuthFailure) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("Error: ${state.message}"),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              builder: (context, state) {
                final isLoading = state is AuthLoading;

                return Container(
                  padding: const EdgeInsets.all(24),
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  constraints: const BoxConstraints(maxWidth: 400),
                  decoration: BoxDecoration(
                    color: ColorPallete.textPrimary.withOpacity(0.05),
                    border: Border.all(
                      color: ColorPallete.textPrimary.withOpacity(0.1),
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Icon(
                        Icons.mark_email_unread_outlined,
                        size: 64,
                        color: Colors.redAccent,
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
                        "Please verify your email address to access the platform. If you didn't receive the email, click below to resend.",
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: ColorPallete.textPrimary.withOpacity(0.7),
                            ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 32),
                      isLoading
                          ? const Center(child: CircularProgressIndicator(color: Colors.redAccent))
                          : Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                AuthButton(
                                  text: "I have verified my email",
                                  onpressed: () {
                                    context.read<AuthBloc>().add(GetMeEvent());
                                  },
                                ),
                                const SizedBox(height: 12),
                                OutlinedButton(
                                  onPressed: () {
                                    context.read<AuthBloc>().add(SendVerificationEmailEvent());
                                  },
                                  style: OutlinedButton.styleFrom(
                                    foregroundColor: Colors.redAccent,
                                    side: const BorderSide(color: Colors.redAccent),
                                  ),
                                  child: const Text("Resend Email"),
                                ),
                              ],
                            ),
                      const SizedBox(height: 16),
                      TextButton(
                        onPressed: () {
                          getIt<TokenManager>().clearTokens();
                          getIt<User>().user = null;
                          getIt<User>().token = null;
                          context.go(LandingPage.routePath);
                        },
                        child: const Text(
                          "Back to Home / Login",
                          style: TextStyle(color: Colors.redAccent),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
