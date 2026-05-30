import 'package:flutter/material.dart';

class OnboardingStep1Invite extends StatelessWidget {
  const OnboardingStep1Invite({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Step 1: Invite')),
      body: const Center(child: Text('Onboarding Step 1 Invite')),
    );
  }
}
