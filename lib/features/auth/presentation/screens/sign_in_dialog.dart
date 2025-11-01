import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hackathon/features/auth/domain/usecase/auth_params.dart';
import 'package:hackathon/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:hackathon/features/auth/presentation/screens/sign_up_dialog.dart';
import 'package:hackathon/features/company/presentation/pages/register_company_page.dart';
import 'package:hackathon/globals/constants/color_pallete.dart';
import 'package:hackathon/globals/constants/user.dart';
import 'package:hackathon/widgets/auth_button.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  bool isPasswordVisible = false;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(10),
      color: Colors.transparent,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          gradient: const LinearGradient(
              colors: ColorPallete.background2,
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter),
        ),
        padding: const EdgeInsets.all(20),
        constraints: const BoxConstraints(
            maxWidth: 400, maxHeight: 400, minHeight: 400, minWidth: 400),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SelectableText("Welcome Back",
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge
                      ?.copyWith(color: ColorPallete.white)),
              const SizedBox(height: 20),
              Form(
                  key: formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextFormField(
                        controller: emailController,
                        style: Theme.of(context).textTheme.bodyMedium,
                        decoration: const InputDecoration(
                          label: Text("Email"),
                        ),
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: passwordController,
                        obscureText: isPasswordVisible,
                        style: Theme.of(context).textTheme.bodyMedium,
                        decoration: InputDecoration(
                            label: const Text("Password"),
                            suffixIcon: IconButton(
                                onPressed: () {
                                  setState(() {
                                    isPasswordVisible = !isPasswordVisible;
                                  });
                                },
                                icon: Icon(isPasswordVisible
                                    ? Icons.visibility
                                    : Icons.visibility_off))),
                        keyboardType: TextInputType.visiblePassword,
                      ),
                      const SizedBox(height: 20),
                      BlocConsumer<AuthBloc, AuthState>(
                        listener: (context, state) {
                          if (state is AuthFailure) {
                            ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(state.message)));
                          } else if (state is AuthSignInSuccess) {
                            User.user = state.user;
                            context.go(RegisterCompanyPage.routePath);
                          }
                        },
                        builder: (context, state) {
                          if (state is AuthLoading) {
                            return const Center(
                                child: CircularProgressIndicator());
                          } else {
                            return AuthButton(
                              width: 100,
                              height: 50,
                              text: "Sign In",
                              onpressed: () {
                                if (formKey.currentState!.validate()) {
                                  context.read<AuthBloc>().add(SignInEvent(
                                      signInParams: SignInParams(
                                          email: emailController.text,
                                          hashedPassword:
                                              passwordController.text)));
                                }
                              },
                            );
                          }
                        },
                      ),
                      RichText(
                          text: TextSpan(
                              text: "Don't have an account? ",
                              style: Theme.of(context).textTheme.bodyMedium,
                              children: [
                            TextSpan(
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    context.pop();
                                    showDialog(
                                        context: context,
                                        builder: (context) =>
                                            const SignUpDialog());
                                  },
                                text: "Sign Up",
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(
                                        color: const Color.fromARGB(
                                            255, 43, 173, 254)))
                          ]))
                    ],
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
