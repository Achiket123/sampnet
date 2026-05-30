import 'package:flutter/material.dart';

class OnboardingStep2Team extends StatelessWidget {
  const OnboardingStep2Team({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Step 2: Team')),
      body: const Center(child: Text('Onboarding Step 2 Team')),
    );
  }
}
