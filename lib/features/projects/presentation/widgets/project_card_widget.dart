import 'package:flutter/material.dart';
import 'package:hackathon/features/projects/domain/entities/project_entity.dart';
import 'package:hackathon/features/projects/presentation/widgets/project_status_badge.dart';
import 'package:intl/intl.dart';

class ProjectCardWidget extends StatelessWidget {
  final Project project;
  final VoidCallback onTap;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const ProjectCardWidget({
    super.key,
    required this.project,
    required this.onTap,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    // Calculate progress
    double progress = 0.0;
    if (project.milestones.isNotEmpty) {
      final completed = project.milestones.where((m) => m.status.toLowerCase() == 'completed').length;
      progress = completed / project.milestones.length;
    } else {
      switch (project.status.toLowerCase()) {
        case 'planning':
          progress = 0.15;
          break;
        case 'active':
          progress = 0.50;
          break;
        case 'completed':
          progress = 1.0;
          break;
        case 'on_hold':
        case 'paused':
          progress = 0.35;
          break;
        default:
          progress = 0.0;
      }
    }

    final dateRangeStr = '${DateFormat('MMM dd, yyyy').format(project.startDate)} - ${DateFormat('MMM dd, yyyy').format(project.endDate)}';
    
    // Status text color for progress highlight
    Color progressColor;
    if (progress >= 0.8) {
      progressColor = const Color(0xFF34D399); // Emerald-400
    } else if (progress >= 0.4) {
      progressColor = const Color(0xFF60A5FA); // Blue-400
    } else {
      progressColor = const Color(0xFFFACC15); // Yellow-400
    }

    return Card(
      color: const Color(0xFF16161A),
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: Colors.white10),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          project.name,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(Icons.people_outline_rounded, size: 14, color: Colors.white38),
                            const SizedBox(width: 4),
                            Text(
                              'Team ID: ${project.teamId}',
                              style: const TextStyle(color: Colors.white38, fontSize: 12),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit_outlined, size: 20, color: Colors.white54),
                        onPressed: onEdit,
                        tooltip: 'Edit Project',
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete_outline_rounded, size: 20, color: Colors.redAccent),
                        onPressed: onDelete,
                        tooltip: 'Delete Project',
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 12),
              
              // Description
              Text(
                project.description.isNotEmpty ? project.description : 'No description provided.',
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 13,
                  height: 1.4,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 16),

              // Badges & Date
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      ProjectStatusBadge(text: project.status),
                      const SizedBox(width: 8),
                      ProjectStatusBadge(text: project.priority, isPriority: true),
                    ],
                  ),
                  Row(
                    children: [
                      const Icon(Icons.calendar_today_rounded, size: 12, color: Colors.white54),
                      const SizedBox(width: 6),
                      Text(
                        dateRangeStr,
                        style: const TextStyle(color: Colors.white54, fontSize: 12),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 18),
              
              // Progress Bar
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Completion Status: ${project.completionStatus.toUpperCase()}',
                        style: const TextStyle(
                          color: Colors.white38,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '${(progress * 100).toInt()}%',
                        style: TextStyle(
                          color: progressColor,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: progress,
                      backgroundColor: Colors.white.withAlpha(15),
                      valueColor: AlwaysStoppedAnimation<Color>(progressColor),
                      minHeight: 6,
                    ),
                  ),
                ],
              ),
              
              if (project.milestones.isNotEmpty) ...[
                const SizedBox(height: 12),
                Row(
                  children: [
                    const Icon(Icons.flag_outlined, size: 14, color: Colors.white38),
                    const SizedBox(width: 4),
                    Text(
                      '${project.milestones.length} Milestones (${project.milestones.where((m) => m.status.toLowerCase() == 'completed').length} completed)',
                      style: const TextStyle(color: Colors.white38, fontSize: 12),
                    ),
                  ],
                )
              ]
            ],
          ),
        ),
      ),
    );
  }
}
