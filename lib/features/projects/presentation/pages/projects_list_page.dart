import 'package:elegant_notification/elegant_notification.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hackathon/dependency_injection.g.dart';
import 'package:hackathon/features/projects/domain/entities/project_entity.dart';
import 'package:hackathon/features/projects/presentation/blocs/project_bloc/project_bloc.dart';
import 'package:hackathon/features/projects/presentation/blocs/project_bloc/project_event.dart';
import 'package:hackathon/features/projects/presentation/blocs/project_bloc/project_state.dart';
import 'package:hackathon/features/projects/presentation/pages/project_detail_page.dart';
import 'package:hackathon/features/projects/presentation/widgets/create_project_dialog.dart';
import 'package:hackathon/features/projects/presentation/widgets/project_card_widget.dart';
import 'package:hackathon/widgets/custom_app_bar.dart';
import 'package:hackathon/widgets/custom_drawer.dart';
import 'package:hackathon/widgets/list_of_side_bar.dart';
import 'package:hackathon/globals/constants/color_pallete.dart';

final GlobalKey<ScaffoldState> _projectsPageKey = GlobalKey<ScaffoldState>();

class ProjectsListPage extends StatefulWidget {
  static const String routePath = '/projects';
  static const String routeName = 'projects';
  const ProjectsListPage({super.key});

  @override
  State<ProjectsListPage> createState() => _ProjectsListPageState();
}

class _ProjectsListPageState extends State<ProjectsListPage> {
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text.toLowerCase();
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [ColorPallete.backgroundPrimary, ColorPallete.backgroundSecondary],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: BlocProvider(
        create: (context) => getIt<ProjectsBloc>()..add(LoadProjectsEvent()),
        child: Scaffold(
          key: _projectsPageKey,
          drawer: CustomDrawer(
            selectedIndex: ListOfSideBar.sideBarItems.indexOf('Projects'),
          ),
          backgroundColor: ColorPallete.transparent,
          body: BlocConsumer<ProjectsBloc, ProjectState>(
            listener: (context, state) {
              if (state is ProjectActionSuccess) {
                ElegantNotification.success(
                  title: const Text("Success"),
                  description: Text(state.message),
                ).show(context);
                context.read<ProjectsBloc>().add(LoadProjectsEvent());
              } else if (state is ProjectError) {
                ElegantNotification.error(
                  title: const Text("Error"),
                  description: Text(state.message),
                ).show(context);
              }
            },
            builder: (context, state) {
              return ListView(
                padding: EdgeInsets.symmetric(
                  horizontal: width * 0.04,
                  vertical: height * 0.02,
                ),
                children: [
                  _appBar(context),
                  const SizedBox(height: 20),
                  
                  if (state is ProjectLoading) ...[
                    const SizedBox(height: 100),
                    const Center(child: CircularProgressIndicator.adaptive(valueColor: AlwaysStoppedAnimation(ColorPallete.textPrimary))),
                  ] else if (state is ProjectsLoaded) ...[
                    _buildStatsRow(state.projects),
                    const SizedBox(height: 24),
                    _buildBelowAppBar(context, state.projects),
                    const SizedBox(height: 16),
                    _buildProjectsGridOrList(context, state.projects),
                  ] else if (state is ProjectError) ...[
                    _buildErrorState(context, state.message),
                  ] else ...[
                    const SizedBox(height: 100),
                    const Center(child: CircularProgressIndicator.adaptive(valueColor: AlwaysStoppedAnimation(ColorPallete.textPrimary))),
                  ]
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _appBar(BuildContext context) {
    return CustomAppBar(
      children: [
        const SizedBox(width: 8),
        Text(
          'PROJECTS',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            color: ColorPallete.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        const Spacer(),
        IconButton(
          onPressed: () {
            _projectsPageKey.currentState?.openDrawer();
          },
          icon: const Icon(
            Icons.menu,
            color: ColorPallete.textPrimary,
          ),
        ),
      ],
    );
  }

  Widget _buildStatsRow(List<Project> projects) {
    final total = projects.length;
    final active = projects.where((p) => p.status.toLowerCase() == 'active').length;
    final completed = projects.where((p) => p.status.toLowerCase() == 'completed').length;
    final paused = projects.where((p) => p.status.toLowerCase() == 'paused' || p.status.toLowerCase() == 'on_hold').length;

    return LayoutBuilder(
      builder: (context, constraints) {
        final double cardWidth = (constraints.maxWidth - 36) / 4;
        
        // If screen is narrow, display stats in a grid (2x2)
        if (constraints.maxWidth < 600) {
          return GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 1.6,
            children: [
              _statsCard('TOTAL', total.toString(), ColorPallete.redPrimary),
              _statsCard('ACTIVE', active.toString(), ColorPallete.statusColor('approved')),
              _statsCard('COMPLETED', completed.toString(), ColorPallete.statusColor('approved')),
              _statsCard('PAUSED', paused.toString(), ColorPallete.statusColor('pending')),
            ],
          );
        }

        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _statsCard('TOTAL', total.toString(), ColorPallete.redPrimary, width: cardWidth),
            _statsCard('ACTIVE', active.toString(), ColorPallete.statusColor('approved'), width: cardWidth),
            _statsCard('COMPLETED', completed.toString(), ColorPallete.statusColor('approved'), width: cardWidth),
            _statsCard('PAUSED', paused.toString(), ColorPallete.statusColor('pending'), width: cardWidth),
          ],
        );
      },
    );
  }

  Widget _statsCard(String title, String count, Color accentColor, {double? width}) {
    return Container(
      width: width,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(
        color: ColorPallete.backgroundPrimary,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: ColorPallete.divider),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: ColorPallete.textDisabled,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),
              Container(
                width: 6,
                height: 6,
                decoration: BoxDecoration(
                  color: accentColor,
                  shape: BoxShape.circle,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            count,
            style: const TextStyle(
              color: ColorPallete.textPrimary,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBelowAppBar(BuildContext context, List<Project> projects) {
    return Row(
      children: [
        // Search input
        Expanded(
          child: Container(
            height: 48,
            decoration: BoxDecoration(
              color: ColorPallete.backgroundPrimary,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: ColorPallete.divider),
            ),
            child: TextField(
              controller: _searchController,
              style: const TextStyle(color: ColorPallete.textPrimary, fontSize: 14),
              decoration: InputDecoration(
                hintText: 'Search projects by name...',
                hintStyle: TextStyle(color: ColorPallete.textPrimary.withOpacity(0.24)),
                prefixIcon: Icon(Icons.search_rounded, color: ColorPallete.textDisabled, size: 20),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),
        ),
        const SizedBox(width: 16),
        // Action Button
        ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            backgroundColor: ColorPallete.textPrimary,
            foregroundColor: ColorPallete.textSecondary,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          icon: const Icon(Icons.add, size: 18),
          label: const Text(
            'Create Project',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          onPressed: () => _showCreateProjectDialog(context),
        ),
      ],
    );
  }

  Widget _buildProjectsGridOrList(BuildContext context, List<Project> projects) {
    final filteredProjects = projects.where((p) => p.name.toLowerCase().contains(_searchQuery)).toList();

    if (filteredProjects.isEmpty) {
      return _buildEmptyState(context);
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth > 900) {
          // Grid view with 2 columns
          return GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: filteredProjects.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 4,
              childAspectRatio: 1.8,
            ),
            itemBuilder: (context, index) {
              final project = filteredProjects[index];
              return ProjectCardWidget(
                project: project,
                onTap: () => context.push('${ProjectDetailPage.routePath}/${project.id}'),
                onEdit: () => _showEditProjectDialog(context, project),
                onDelete: () => _confirmDeleteProject(context, project),
              );
            },
          );
        }

        // List view
        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: filteredProjects.length,
          itemBuilder: (context, index) {
            final project = filteredProjects[index];
            return ProjectCardWidget(
              project: project,
              onTap: () => context.push('${ProjectDetailPage.routePath}/${project.id}'),
              onEdit: () => _showEditProjectDialog(context, project),
              onDelete: () => _confirmDeleteProject(context, project),
            );
          },
        );
      },
    );
  }

  void _showCreateProjectDialog(BuildContext parentContext) {
    showDialog<Project>(
      context: parentContext,
      builder: (context) => const CreateProjectDialog(),
    ).then((newProject) {
      if (newProject != null && parentContext.mounted) {
        final bloc = parentContext.read<ProjectsBloc>();
        if (!bloc.isClosed) {
          bloc.add(CreateProjectEvent(newProject));
        }
      }
    });
  }

  void _showEditProjectDialog(BuildContext parentContext, Project project) {
    showDialog<Project>(
      context: parentContext,
      builder: (context) => CreateProjectDialog(projectToEdit: project),
    ).then((updatedProject) {
      if (updatedProject != null && parentContext.mounted) {
        final bloc = parentContext.read<ProjectsBloc>();
        if (!bloc.isClosed) {
          bloc.add(UpdateProjectEvent(updatedProject));
        }
      }
    });
  }

  void _confirmDeleteProject(BuildContext parentContext, Project project) {
    showDialog<bool>(
      context: parentContext,
      builder: (context) => AlertDialog(
        backgroundColor: ColorPallete.backgroundPrimary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: ColorPallete.divider),
        ),
        title: const Text('Delete Project', style: TextStyle(color: ColorPallete.textPrimary, fontWeight: FontWeight.bold)),
        content: Text('Are you sure you want to delete "${project.name}"? This action cannot be undone.', style: const TextStyle(color: ColorPallete.textSecondary)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel', style: TextStyle(color: ColorPallete.textSecondary)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: ColorPallete.error,
              foregroundColor: ColorPallete.textPrimary,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    ).then((confirmed) {
      if (confirmed == true && parentContext.mounted) {
        final bloc = parentContext.read<ProjectsBloc>();
        if (!bloc.isClosed) {
          bloc.add(DeleteProjectEvent(project.id));
        }
      }
    });
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 80.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
             Icon(Icons.assignment_outlined, size: 64, color: ColorPallete.textPrimary.withOpacity(0.24)),
            const SizedBox(height: 16),
            const Text(
              'No projects found',
              style: TextStyle(color: ColorPallete.textSecondary, fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            Text(
              _searchQuery.isNotEmpty ? 'Try adjusting your search query.' : 'Click "Create Project" to get started.',
              style: const TextStyle(color: ColorPallete.textDisabled, fontSize: 13),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 80.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline_rounded, size: 64, color: ColorPallete.error),
            const SizedBox(height: 16),
            const Text(
              'Failed to load projects',
              style: TextStyle(color: ColorPallete.textSecondary, fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            Text(
              message,
              style: const TextStyle(color: ColorPallete.textDisabled, fontSize: 13),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: ColorPallete.divider,
                side:  BorderSide(color: ColorPallete.textPrimary.withOpacity(0.24)),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              onPressed: () {
                context.read<ProjectsBloc>().add(LoadProjectsEvent());
              },
              child: const Text('Retry', style: TextStyle(color: ColorPallete.textPrimary)),
            ),
          ],
        ),
      ),
    );
  }
}
