import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:hackathon/dependency_injection.g.dart';
import 'package:hackathon/globals/constants/color_pallete.dart';
import 'package:hackathon/features/settings/presentation/blocs/settings_bloc/settings_bloc.dart';
import 'package:hackathon/features/settings/presentation/blocs/settings_bloc/settings_event.dart';
import 'package:hackathon/features/settings/presentation/blocs/settings_bloc/settings_state.dart';

class BillingSettingsPage extends StatelessWidget {
  const BillingSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<SettingsBloc>()..add(LoadOrgPlanEvent()),
      child: BlocBuilder<SettingsBloc, SettingsState>(
        builder: (context, state) {
          final bool isLoading = state is SettingsLoading;

          return Scaffold(
            backgroundColor: ColorPallete.backgroundPrimary,
            body: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Billing & Subscriptions',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: ColorPallete.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Review your current subscription plan details, limits, and billing status.',
                    style: TextStyle(
                      fontSize: 14,
                      color: ColorPallete.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 24),
                  if (isLoading)
                    const Center(
                      child: Padding(
                        padding: EdgeInsets.all(48.0),
                        child: CircularProgressIndicator(color: ColorPallete.redPrimary),
                      ),
                    )
                  else if (state is OrgPlanLoaded)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildCurrentPlanCard(context, state.plan),
                        const SizedBox(height: 32),
                        const Text(
                          'Available Plans',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: ColorPallete.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: _buildPlanComparisonCard(
                                title: 'Standard Tier',
                                price: '\$49/mo',
                                desc: 'Perfect for small companies up to 50 employees.',
                                features: ['Up to 50 employees', 'Core HR features', 'Standard Support'],
                                isCurrent: state.plan.planName.toLowerCase().contains('standard') || 
                                           state.plan.planName.toLowerCase().contains('free') || 
                                           state.plan.planId == 1,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: _buildPlanComparisonCard(
                                title: 'Enterprise Pro',
                                price: '\$149/mo',
                                desc: 'For growing organizations needing full policy controls.',
                                features: ['Unlimited employees', 'Advanced leaves & checkins', 'Priority 24/7 Support'],
                                isCurrent: state.plan.planName.toLowerCase().contains('enterprise') || 
                                           state.plan.planName.toLowerCase().contains('pro') || 
                                           state.plan.planId == 2,
                              ),
                            ),
                          ],
                        ),
                      ],
                    )
                  else
                    const Center(
                      child: Text(
                        'Failed to load plan details.',
                        style: TextStyle(color: ColorPallete.error),
                      ),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildCurrentPlanCard(BuildContext context, plan) {
    final dateFormat = DateFormat('MMMM d, yyyy');
    final startDateStr = plan.planStartDate != null ? dateFormat.format(plan.planStartDate!) : 'N/A';
    final endDateStr = plan.planEndDate != null ? dateFormat.format(plan.planEndDate!) : 'N/A';

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [ColorPallete.backgroundSecondary, ColorPallete.backgroundTertiary],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: ColorPallete.divider),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'CURRENT PLAN',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                      color: ColorPallete.redPrimary,
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    plan.planName.toUpperCase(),
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: ColorPallete.textPrimary,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: ColorPallete.success.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: ColorPallete.success.withOpacity(0.5)),
                ),
                child: Text(
                  plan.planStatus.toUpperCase(),
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: ColorPallete.success,
                  ),
                ),
              ),
            ],
          ),
          const Divider(color: ColorPallete.divider, height: 32),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildPlanMetaItem(
                label: 'Employee Limit',
                value: '${plan.maxEmployees} active slots',
              ),
              _buildPlanMetaItem(
                label: 'Start Date',
                value: startDateStr,
              ),
              _buildPlanMetaItem(
                label: 'Renewal Date',
                value: endDateStr,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPlanMetaItem({required String label, required String value}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: ColorPallete.textSecondary,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          value,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: ColorPallete.textPrimary,
          ),
        ),
      ],
    );
  }

  Widget _buildPlanComparisonCard({
    required String title,
    required String price,
    required String desc,
    required List<String> features,
    required bool isCurrent,
  }) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: ColorPallete.backgroundSecondary,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isCurrent ? ColorPallete.redPrimary : ColorPallete.divider,
          width: isCurrent ? 2 : 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: ColorPallete.textPrimary,
                ),
              ),
              if (isCurrent)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: ColorPallete.redSubtle,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Text(
                    'Active',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: ColorPallete.redPrimary,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            price,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: ColorPallete.textPrimary,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            desc,
            style: const TextStyle(
              fontSize: 13,
              color: ColorPallete.textSecondary,
            ),
          ),
          const Divider(color: ColorPallete.divider, height: 32),
          ...features.map((f) => Padding(
                padding: const EdgeInsets.only(bottom: 10.0),
                child: Row(
                  children: [
                    const Icon(Icons.check_circle_outline, size: 16, color: ColorPallete.success),
                    const SizedBox(width: 8),
                    Text(
                      f,
                      style: const TextStyle(
                        fontSize: 13,
                        color: ColorPallete.textPrimary,
                      ),
                    ),
                  ],
                ),
              )),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: isCurrent ? ColorPallete.backgroundTertiary : ColorPallete.redPrimary,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: isCurrent ? null : () {},
              child: Text(
                isCurrent ? 'Current Plan' : 'Upgrade Plan',
                style: TextStyle(
                  color: isCurrent ? ColorPallete.textSecondary : ColorPallete.textPrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
