import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hackathon/features/onboarding/presentation/blocs/onboarding_bloc/onboarding_bloc.dart';
import 'package:hackathon/features/onboarding/presentation/blocs/onboarding_bloc/onboarding_state.dart';
import 'package:hackathon/globals/constants/color_pallete.dart';

class GettingStartedChecklistWidget extends StatelessWidget {
  const GettingStartedChecklistWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: ColorPallete.background2[0].withOpacity(0.5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: BlocBuilder<OnboardingBloc, OnboardingState>(
        builder: (context, state) {
          if (state is OnboardingLoading) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            );
          }

          int currentStep = 0;
          if (state is OnboardingLoaded) {
            currentStep = state.progress.currentStep;
          }

          final steps = [
            "Set up your profile",
            "Create or join an organisation",
            "Create your first team",
            "Assign your first task",
            "Invite a team member",
          ];

          final completionProgress = currentStep / steps.length;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Getting Started",
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: ColorPallete.white,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  Text(
                    "${(completionProgress * 100).toInt()}%",
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: ColorPallete.white.withOpacity(0.7),
                        ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: completionProgress,
                  backgroundColor: Colors.white10,
                  valueColor: const AlwaysStoppedAnimation<Color>(Colors.greenAccent),
                  minHeight: 4,
                ),
              ),
              const SizedBox(height: 16),
              ...List.generate(steps.length, (index) {
                return _ChecklistItem(
                  text: steps[index],
                  isDone: currentStep > index,
                );
              }),
              if (state is OnboardingError)
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    "Error loading progress",
                    style: TextStyle(color: Colors.redAccent.withOpacity(0.7), fontSize: 11),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}

class _ChecklistItem extends StatelessWidget {
  final String text;
  final bool isDone;

  const _ChecklistItem({required this.text, required this.isDone});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Icon(
            isDone ? Icons.check_circle : Icons.radio_button_unchecked,
            color: isDone ? Colors.greenAccent : Colors.white24,
            size: 18,
          ),
          const SizedBox(width: 8),
          Text(
            text,
            style: TextStyle(
              color: isDone ? ColorPallete.white.withOpacity(0.5) : ColorPallete.white,
              decoration: isDone ? TextDecoration.lineThrough : null,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}
