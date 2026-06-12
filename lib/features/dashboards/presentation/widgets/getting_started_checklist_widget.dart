import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hackathon/features/onboarding/presentation/blocs/onboarding_bloc/onboarding_bloc.dart';
import 'package:hackathon/features/onboarding/presentation/blocs/onboarding_bloc/onboarding_state.dart';
import 'package:hackathon/features/onboarding/presentation/blocs/onboarding_bloc/onboarding_event.dart';
import 'package:hackathon/features/onboarding/data/models/onboarding_progress_model.dart';
import 'package:hackathon/globals/constants/color_pallete.dart';

class GettingStartedChecklistWidget extends StatelessWidget {
  const GettingStartedChecklistWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: ColorPallete.backgroundSecondary,
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
          bool profileCompleted = false;
          bool orgJoined = true;
          bool teamJoined = false;
          bool taskCreated = false;
          bool inviteSent = false;

          if (state is OnboardingLoaded) {
            currentStep = state.progress.currentStep;
            profileCompleted = state.progress.profileCompleted;
            orgJoined = state.progress.organisationId != 0;
            teamJoined = state.progress.teamJoined;
            taskCreated = state.progress.taskCreated;
            inviteSent = state.progress.inviteSent;
          }

          final steps = [
            "Set up your profile",
            "Create or join an organisation",
            "Create your first team",
            "Assign your first task",
            "Invite a team member",
          ];

          final stepStatuses = [
            profileCompleted,
            orgJoined,
            teamJoined,
            taskCreated,
            inviteSent,
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
                          color: ColorPallete.textPrimary,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  Text(
                    "${(completionProgress * 100).toInt()}%",
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: ColorPallete.textPrimary.withOpacity(0.7),
                        ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: completionProgress,
                  backgroundColor: ColorPallete.divider,
                  valueColor: AlwaysStoppedAnimation<Color>(ColorPallete.statusColor('approved')),
                  minHeight: 4,
                ),
              ),
              const SizedBox(height: 16),
              ...List.generate(steps.length, (index) {
                if (state is OnboardingError){
                  debugPrint("${state.message}");
                }
                return _ChecklistItem(
                  text: steps[index],
                  isDone: stepStatuses[index],
                );
              }),
              if (state is OnboardingError)
              wid(state),
                
              const SizedBox(height: 16),
              if (state is OnboardingLoaded && completionProgress < 1.0)
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      final updatedProgress = OnboardingProgressModel(
                        userId: state.progress.userId,
                        organisationId: state.progress.organisationId,
                        profileCompleted: true,
                        teamJoined: true,
                        taskCreated: true,
                        inviteSent: true,
                        currentStep: 5,
                        isCompleted: true,
                      );
                      context.read<OnboardingBloc>().add(UpdateOnboardingStep(updatedProgress));
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ColorPallete.statusColor('approved'),
                      foregroundColor: ColorPallete.textPrimary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: const Text(
                      "Complete Onboarding",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
  Widget wid( OnboardingError state){
    debugPrint("ONBOARDING:: ${state.message}");
    return Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    "Error loading progress",
                    style: TextStyle(color: ColorPallete.error.withOpacity(0.7), fontSize: 11),
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
            color: isDone ? ColorPallete.statusColor('approved') : ColorPallete.textPrimary.withOpacity(0.24),
            size: 18,
          ),
          const SizedBox(width: 8),
          Text(
            text,
            style: TextStyle(
              color: isDone ? ColorPallete.textPrimary.withOpacity(0.5) : ColorPallete.textPrimary,
              decoration: isDone ? TextDecoration.lineThrough : null,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}
