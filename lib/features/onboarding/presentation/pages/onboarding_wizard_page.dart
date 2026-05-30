import 'package:flutter/material.dart';

class OnboardingWizardPage extends StatelessWidget {
  const OnboardingWizardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Admin Onboarding Wizard')),
      body: const Center(child: Text('Onboarding Wizard Page')),
    );
  }
}
