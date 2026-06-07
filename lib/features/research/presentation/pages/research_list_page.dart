import 'package:elegant_notification/elegant_notification.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../domain/entities/research_status.dart';
import '../blocs/research_list_bloc/research_list_bloc.dart';
import '../blocs/research_detail_bloc/research_detail_bloc.dart';
import '../widgets/research_entry_card_widget.dart';
import '../../../../widgets/custom_app_bar.dart';
import '../../../../widgets/custom_drawer.dart';
import '../../../../widgets/list_of_side_bar.dart';
import '../../../../globals/constants/color_pallete.dart';
import 'research_detail_page.dart';
import 'create_edit_research_page.dart';

class ResearchListPage extends StatefulWidget {
  static const String routePath = '/research';
  static const String routeName = 'research';

  const ResearchListPage({super.key});

  @override
  State<ResearchListPage> createState() => _ResearchListPageState();
}

class _ResearchListPageState extends State<ResearchListPage> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_isBottom) {
      context.read<ResearchListBloc>().add(const LoadResearchList());
    }
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [ColorPallete.backgroundPrimary, ColorPallete.backgroundSecondary],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Scaffold(
        backgroundColor: ColorPallete.transparent,
        drawer: CustomDrawer(
          selectedIndex: ListOfSideBar.sideBarItems.indexOf('Research'),
        ),
        body: BlocListener<ResearchDetailBloc, ResearchDetailState>(
          listener: (context, state) {
            if (state is ResearchActionSuccess) {
              ElegantNotification.success(
                title: const Text("Success"),
                description: Text(state.message),
              ).show(context);
              context
                  .read<ResearchListBloc>()
                  .add(const LoadResearchList(isRefresh: true));
            } else if (state is ResearchDetailError) {
              ElegantNotification.error(
                title: const Text("Error"),
                description: Text(state.message),
              ).show(context);
            }
          },
          child: SafeArea(
            child: Column(
              children: [
                _appBar(context),
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: width * 0.04, vertical: 8),
                  child: _buildFilters(context),
                ),
                Expanded(
                  child: BlocBuilder<ResearchListBloc, ResearchListState>(
                    builder: (context, state) {
                      if (state is ResearchListInitial ||
                          (state is ResearchListLoading &&
                              _searchController.text.isEmpty)) {
                        return const Center(
                            child: CircularProgressIndicator(
                                valueColor:
                                    AlwaysStoppedAnimation(ColorPallete.textPrimary)));
                      } else if (state is ResearchListError) {
                        return _buildErrorState(context, state.message);
                      } else if (state is ResearchListLoaded) {
                        if (state.entries.isEmpty) {
                          return _buildEmptyState(context);
                        }
                        return RefreshIndicator(
                          onRefresh: () async {
                            context
                                .read<ResearchListBloc>()
                                .add(const LoadResearchList(isRefresh: true));
                          },
                          child: ListView.builder(
                            controller: _scrollController,
                            padding: EdgeInsets.symmetric(
                                horizontal: width * 0.04, vertical: 8),
                            itemCount: state.hasReachedMax
                                ? state.entries.length
                                : state.entries.length + 1,
                            itemBuilder: (context, index) {
                              if (index >= state.entries.length) {
                                return const Center(
                                    child: Padding(
                                        padding: EdgeInsets.all(8.0),
                                        child: CircularProgressIndicator(
                                            valueColor: AlwaysStoppedAnimation(
                                                ColorPallete.textPrimary))));
                              }
                              final entry = state.entries[index];
                              return ResearchEntryCardWidget(
                                entry: entry,
                                onTap: () => context.push(
                                    '${ResearchDetailPage.routePath}/${entry.id}'),
                                onEdit: (entry) => context.push(
                                    CreateEditResearchPage.routePath,
                                    extra: entry),
                                onDelete: (id) => _confirmDelete(context, id),
                              );
                            },
                          ),
                        );
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: ColorPallete.textPrimary,
          foregroundColor: ColorPallete.textSecondary,
          onPressed: () => context.push(CreateEditResearchPage.routePath),
          child: const Icon(Icons.add),
        ),
      ),
    );
  }

  Widget _appBar(BuildContext context) {
    return CustomAppBar(
      children: [
        const SizedBox(width: 8),
        Text(
          'RESEARCH',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: ColorPallete.textPrimary,
                fontWeight: FontWeight.bold,
              ),
        ),
        const Spacer(),
        Builder(
          builder: (context) => IconButton(
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
            icon: const Icon(Icons.menu, color: ColorPallete.textPrimary),
          ),
        ),
      ],
    );
  }

  Widget _buildFilters(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 48,
          decoration: BoxDecoration(
            color: ColorPallete.backgroundPrimary,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: ColorPallete.divider),
          ),
          child: TextField(
            controller: _searchController,
            style: const TextStyle(color: ColorPallete.textPrimary, fontSize: 14),
            onChanged: (value) {
              context
                  .read<ResearchListBloc>()
                  .add(SearchQueryChanged(query: value));
            },
            decoration: InputDecoration(
              hintText: 'Search research by title...',
              hintStyle: TextStyle(color: ColorPallete.textPrimary.withOpacity(0.24)),
              prefixIcon:
                  Icon(Icons.search_rounded, color: ColorPallete.textDisabled, size: 20),
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(vertical: 12),
            ),
          ),
        ),
        const SizedBox(height: 12),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              _filterChip(context, 'All', null),
              ...ResearchStatus.values.map(
                  (status) => _filterChip(context, status.label, status.value)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _filterChip(BuildContext context, String label, String? value) {
    return BlocBuilder<ResearchListBloc, ResearchListState>(
      builder: (context, state) {
        final isSelected =
            state is ResearchListLoaded && state.statusFilter == value;
        return Padding(
          padding: const EdgeInsets.only(right: 8),
          child: FilterChip(
            label: Text(label),
            selected: isSelected,
            onSelected: (_) {
              context
                  .read<ResearchListBloc>()
                  .add(FilterByStatus(status: value));
            },
            backgroundColor: ColorPallete.backgroundPrimary,
            selectedColor: ColorPallete.textPrimary,
            showCheckmark: false,
            labelStyle: TextStyle(
              color: isSelected ? ColorPallete.textSecondary : ColorPallete.textPrimary.withOpacity(0.60),
              fontSize: 12,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side:
                  BorderSide(color: isSelected ? ColorPallete.textPrimary : ColorPallete.divider),
            ),
          ),
        );
      },
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

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_off_rounded, size: 64, color: ColorPallete.textPrimary.withOpacity(0.24)),
          const SizedBox(height: 16),
          const Text('No research entries found',
              style: TextStyle(
                  color: ColorPallete.textSecondary,
                  fontSize: 18,
                  fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          const Text('Try adjusting your filters or search query',
              style: TextStyle(color: ColorPallete.textDisabled, fontSize: 14)),
        ],
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline_rounded,
              size: 64, color: ColorPallete.error),
          const SizedBox(height: 16),
          const Text('Something went wrong',
              style: TextStyle(
                  color: ColorPallete.textSecondary,
                  fontSize: 18,
                  fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text(message,
              style: const TextStyle(color: ColorPallete.textDisabled, fontSize: 14),
              textAlign: TextAlign.center),
          const SizedBox(height: 16),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: ColorPallete.divider,
              side:  BorderSide(color: ColorPallete.textPrimary.withOpacity(0.24)),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
            ),
            onPressed: () => context
                .read<ResearchListBloc>()
                .add(const LoadResearchList(isRefresh: true)),
            child: const Text('Retry', style: TextStyle(color: ColorPallete.textPrimary)),
          ),
        ],
      ),
    );
  }
}
