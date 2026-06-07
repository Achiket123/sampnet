import 'package:elegant_notification/elegant_notification.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../blocs/research_detail_bloc/research_detail_bloc.dart';
import '../widgets/status_badge_widget.dart';
import 'create_edit_research_page.dart';
import 'research_explorer_page.dart';
import 'package:hackathon/globals/constants/color_pallete.dart';

class ResearchDetailPage extends StatelessWidget {
  static const String routePath = '/research-detail';
  static const String routeName = 'research-detail';

  final int researchId;

  const ResearchDetailPage({super.key, required this.researchId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorPallete.backgroundPrimary,
      appBar: AppBar(
        backgroundColor: ColorPallete.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: ColorPallete.textPrimary),
          onPressed: () => context.pop(),
        ),
        actions: [
          BlocBuilder<ResearchDetailBloc, ResearchDetailState>(
            builder: (context, state) {
              if (state is ResearchDetailLoaded) {
                return Row(
                  children: [
                    IconButton(
                      icon:
                          const Icon(Icons.edit_outlined, color: ColorPallete.textPrimary),
                      onPressed: () => context.push(
                          CreateEditResearchPage.routePath,
                          extra: state.entry),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete_outline,
                          color: ColorPallete.error),
                      onPressed: () => _confirmDelete(context, state.entry.id),
                    ),
                  ],
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ],
      ),
      body: BlocConsumer<ResearchDetailBloc, ResearchDetailState>(
        listener: (context, state) {
          if (state is ResearchActionSuccess) {
            ElegantNotification.success(
              title: const Text("Success"),
              description: Text(state.message),
            ).show(context);
            context.pop();
          } else if (state is ResearchDetailError) {
            ElegantNotification.error(
              title: const Text("Error"),
              description: Text(state.message),
            ).show(context);
          }
        },
        builder: (context, state) {
          if (state is ResearchDetailLoading) {
            return const Center(
                child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation(ColorPallete.textPrimary)));
          } else if (state is ResearchDetailLoaded) {
            final entry = state.entry;
            return SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      StatusBadgeWidget(status: entry.status),
                      Text(
                        DateFormat('MMM dd, yyyy').format(entry.createdAt),
                        style: const TextStyle(
                            color: ColorPallete.textDisabled, fontSize: 12),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    entry.title,
                    style: const TextStyle(
                      color: ColorPallete.textPrimary,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 24),
                  _buildInfoTile(
                    icon: Icons.person_outline,
                    label: 'Author',
                    value: entry.authorName,
                  ),
                  if (entry.projectName != null)
                    _buildInfoTile(
                      icon: Icons.folder_outlined,
                      label: 'Project',
                      value: entry.projectName!,
                      onTap: () {
                        // TODO: Navigate to project detail
                      },
                    ),
                  if (entry.teamName != null)
                    _buildInfoTile(
                      icon: Icons.groups_outlined,
                      label: 'Team',
                      value: entry.teamName!,
                      onTap: () {
                        // TODO: Navigate to team detail
                      },
                    ),
                  const SizedBox(height: 32),
                  const Text(
                    'Description',
                    style: TextStyle(
                      color: ColorPallete.textSecondary,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    entry.description,
                    style:  TextStyle(
                      color: ColorPallete.textPrimary.withOpacity(0.60),
                      fontSize: 16,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 32),
                  if (entry.tags.isNotEmpty) ...[
                    const Text(
                      'Tags',
                      style: TextStyle(
                        color: ColorPallete.textSecondary,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: entry.tags
                          .map((tag) => Chip(
                                label: Text(tag),
                                backgroundColor: ColorPallete.divider,
                                labelStyle: const TextStyle(
                                    color: ColorPallete.textSecondary, fontSize: 12),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8)),
                              ))
                          .toList(),
                    ),
                  ],
                  const SizedBox(height: 40),
                  SizedBox(
                    width: double.infinity,
                    height: 54,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: ColorPallete.redPrimary,
                        foregroundColor: ColorPallete.textPrimary,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                      icon: const Icon(Icons.folder_open_rounded),
                      label: const Text('OPEN WORKSPACE',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, letterSpacing: 1.2)),
                      onPressed: () {
                        context.push(
                            '${ResearchExplorerPage.routePath}/${entry.id}',
                            extra: entry);
                      },
                    ),
                  ),
                ],
              ),
            );
          } else if (state is ResearchDetailError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline,
                      size: 48, color: ColorPallete.error),
                  const SizedBox(height: 16),
                  Text(state.message,
                      style: const TextStyle(color: ColorPallete.textSecondary)),
                  TextButton(
                    onPressed: () => context
                        .read<ResearchDetailBloc>()
                        .add(GetResearchDetail(id: researchId)),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildInfoTile({
    required IconData icon,
    required String label,
    required String value,
    VoidCallback? onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: ColorPallete.textPrimary.withValues(alpha: 0.03),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: ColorPallete.divider),
          ),
          child: Row(
            children: [
              Icon(icon, color: ColorPallete.textDisabled, size: 20),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label,
                      style:
                          const TextStyle(color: ColorPallete.textDisabled, fontSize: 10)),
                  Text(
                    value,
                    style: TextStyle(
                      color: onTap != null ? ColorPallete.redPrimary : ColorPallete.textSecondary,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      decoration:
                          onTap != null ? TextDecoration.underline : null,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _confirmDelete(BuildContext context, int id) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: ColorPallete.backgroundPrimary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: ColorPallete.divider),
        ),
        title: const Text('Delete Research Entry',
            style: TextStyle(color: ColorPallete.textPrimary, fontWeight: FontWeight.bold)),
        content: const Text(
            'Are you sure you want to delete this entry? This action cannot be undone.',
            style: TextStyle(color: ColorPallete.textSecondary)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child:
                const Text('Cancel', style: TextStyle(color: ColorPallete.textSecondary)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: ColorPallete.error,
              foregroundColor: ColorPallete.textPrimary,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
            ),
            onPressed: () {
              context
                  .read<ResearchDetailBloc>()
                  .add(DeleteResearchEntry(id: id));
              Navigator.pop(dialogContext);
            },
            child: const Text('Delete',
                style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}
