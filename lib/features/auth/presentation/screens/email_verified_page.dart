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

class EmailVerifiedPage extends StatefulWidget {
  static const String routePath = '/verify-email-landing';
  final String? token;
  const EmailVerifiedPage({super.key, this.token});

  @override
  State<EmailVerifiedPage> createState() => _EmailVerifiedPageState();
}

class _EmailVerifiedPageState extends State<EmailVerifiedPage> {
  late final AuthBloc _authBloc;

  @override
  void initState() {
    super.initState();
    _authBloc = getIt<AuthBloc>();
    if (widget.token != null && widget.token!.isNotEmpty) {
      _authBloc.add(VerifyEmailEvent(token: widget.token!));
    }
  }

  @override
  void dispose() {
    _authBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AuthBloc>.value(
      value: _authBloc,
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
            child: BlocBuilder<AuthBloc, AuthState>(
              builder: (context, state) {
                if (widget.token == null || widget.token!.isEmpty) {
                  return _buildCard(
                    context,
                    icon: Icons.error_outline,
                    iconColor: Colors.redAccent,
                    title: "Invalid Verification Link",
                    subtitle: "No verification token was provided in the link. Please check your email and try again.",
                    action: AuthButton(
                      text: "Back to Home",
                      onpressed: () {
                        getIt<TokenManager>().clearTokens();
                        getIt<User>().user = null;
                        getIt<User>().token = null;
                        context.go(LandingPage.routePath);
                      },
                    ),
                  );
                }

                if (state is AuthInitial || state is AuthLoading) {
                  return _buildCard(
                    context,
                    icon: Icons.hourglass_top_outlined,
                    iconColor: Colors.amber,
                    title: "Validating your email...",
                    subtitle: "Please wait while we verify your email address.",
                    action: const Center(child: CircularProgressIndicator(color: Colors.redAccent)),
                  );
                }

                if (state is AuthVerifyEmailSuccess) {
                  return _buildCard(
                    context,
                    icon: Icons.check_circle_outline,
                    iconColor: Colors.green,
                    title: "Email Verified!",
                    subtitle: "Your email address has been successfully verified. You can now proceed to set up your organization.",
                    action: AuthButton(
                      text: "Proceed to Registration",
                      onpressed: () {
                        context.go('/');
                      },
                    ),
                  );
                }

                if (state is AuthFailure) {
                  return _buildCard(
                    context,
                    icon: Icons.error_outline,
                    iconColor: Colors.redAccent,
                    title: "Verification Failed",
                    subtitle: state.message,
                    action: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        AuthButton(
                          text: "Back to Home / Login",
                          onpressed: () {
                            getIt<TokenManager>().clearTokens();
                            getIt<User>().user = null;
                            getIt<User>().token = null;
                            context.go(LandingPage.routePath);
                          },
                        ),
                      ],
                    ),
                  );
                }

                return const SizedBox.shrink();
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCard(
    BuildContext context, {
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    required Widget action,
  }) {
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
          Icon(
            icon,
            size: 64,
            color: iconColor,
          ),
          const SizedBox(height: 24),
          Text(
            title,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: ColorPallete.textPrimary,
                  fontWeight: FontWeight.bold,
                ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Text(
            subtitle,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: ColorPallete.textPrimary.withOpacity(0.7),
                ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          action,
        ],
      ),
    );
  }
}
