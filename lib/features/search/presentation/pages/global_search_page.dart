import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hackathon/dependency_injection.g.dart';
import 'package:hackathon/features/chats/domain/entities/chat_entity.dart';
import 'package:hackathon/features/chats/domain/entities/chat_participant_entity.dart';
import 'package:hackathon/features/chats/presentation/pages/chat_page.dart';
import 'package:hackathon/globals/constants/user.dart' as user;
import 'package:hackathon/features/employees/presentation/pages/employee_profile_page.dart';
import 'package:hackathon/features/projects/presentation/pages/project_detail_page.dart';
import 'package:hackathon/features/research/presentation/pages/research_detail_page.dart';
import 'package:hackathon/features/search/domain/entities/search_entity.dart';
import 'package:hackathon/features/search/presentation/blocs/search_bloc/search_bloc.dart';
import 'package:hackathon/features/tasks/presentation/pages/task_detail_page.dart';
import 'package:hackathon/features/team/presentation/pages/team_page.dart';
import 'package:hackathon/globals/constants/color_pallete.dart';

class GlobalSearchPage extends StatefulWidget {
  static const routePath = '/search';

  /// Optional pre-loaded query (passed from SearchOverlayWidget).
  final String initialQuery;

  const GlobalSearchPage({super.key, this.initialQuery = ''});

  @override
  State<GlobalSearchPage> createState() => _GlobalSearchPageState();
}

class _GlobalSearchPageState extends State<GlobalSearchPage> {
  late final TextEditingController _controller;
  late final SearchBloc _bloc;

  static const _filterTypes = [
    'task',
    'project',
    'team',
    'employee',
    'chat',
    'research'
  ];

  List<String> _selectedTypes = [];

  @override
  void initState() {
    super.initState();
    _bloc = getIt<SearchBloc>();
    _controller = TextEditingController(text: widget.initialQuery);
    if (widget.initialQuery.length >= 2) {
      _bloc.add(SearchQueryChanged(widget.initialQuery));
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTypeChipTap(String type) {
    setState(() {
      if (type == 'all') {
        _selectedTypes = [];
      } else if (_selectedTypes.contains(type)) {
        _selectedTypes = List.from(_selectedTypes)..remove(type);
      } else {
        _selectedTypes = List.from(_selectedTypes)..add(type);
      }
    });
    _bloc.add(SearchTypeFilterChanged(_selectedTypes));
  }

  void _navigateTo(BuildContext context, SearchResultItem item) {
    switch (item.type) {
      case 'task':
        context.push('${TaskDetailPage.routePath}/${item.id}');
        break;
      case 'project':
        context.push('${ProjectDetailPage.routePath}/${item.id}');
        break;
      case 'team':
        context.push(TeamPage.routePath);
        break;
      case 'employee':
        context.push('${EmployeeProfilePage.routePath}/${item.id}');
        break;
      case 'research':
        context.push('${ResearchDetailPage.routePath}/${item.id}');
        break;
      case 'chat':
        final currentUserId = getIt<user.User>().user!.id;
        final targetUserId = item.id;
        final smallerId = currentUserId < targetUserId ? currentUserId : targetUserId;
        final largerId = currentUserId > targetUserId ? currentUserId : targetUserId;
        final roomId = 'dm_${smallerId}_${largerId}';

        final chat = ChatEntity(
          id: item.id,
          roomId: roomId,
          organisationId: getIt<user.User>().organisation?.id ?? 0,
          isGroup: false,
          createdBy: getIt<user.User>().user!.id,
          participants: [
            ChatParticipantEntity(
              userId: item.id,
              chatId: item.id,
              unreadCount: 0,
              lastReadMessageId: 0,
              firstName: item.title.split(' ').first,
              lastName: item.title.split(' ').length > 1
                  ? item.title.split(' ').last
                  : '',
              joinedAt: DateTime.now(),
            )
          ],
          lastMessageAt: DateTime.now(),
          lastMessage: '',
          messageCount: 0,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );
        context.push(ChatPage.routePath, extra: chat);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _bloc,
      child: Scaffold(
        backgroundColor: ColorPallete.backgroundPrimary,
        body: SafeArea(
          child: Column(
            children: [
              _SearchBar(
                controller: _controller,
                onChanged: (q) => _bloc.add(SearchQueryChanged(q)),
                onClear: () {
                  _controller.clear();
                  _bloc.add(const SearchCleared());
                },
              ),
              _TypeFilterRow(
                selectedTypes: _selectedTypes,
                allTypes: _filterTypes,
                onTap: _onTypeChipTap,
              ),
              Expanded(
                child: BlocBuilder<SearchBloc, SearchState>(
                  builder: (context, state) {
                    if (state is SearchInitial) {
                      return _EmptyState();
                    }
                    if (state is SearchError) {
                      return Center(
                        child: Text(
                          state.message,
                          style: const TextStyle(color: ColorPallete.error),
                          textAlign: TextAlign.center,
                        ),
                      );
                    }

                    SearchResults? results;
                    bool loading = false;

                    if (state is SearchLoading) {
                      loading = true;
                      results = state.previousResults;
                    } else if (state is SearchLoaded) {
                      results = state.results;
                    }

                    return Column(
                      children: [
                        if (loading)
                          const LinearProgressIndicator(
                            minHeight: 2,
                            color: ColorPallete.success,
                          ),
                        if (results != null)
                          Expanded(
                            child: _ResultsList(
                              results: results,
                              onTap: (item) => _navigateTo(context, item),
                            ),
                          )
                        else
                          const Expanded(child: SizedBox.shrink()),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Sub-widgets ───────────────────────────────────────────────────────────────

class _SearchBar extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final VoidCallback onClear;

  const _SearchBar({
    required this.controller,
    required this.onChanged,
    required this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 12, 16, 8),
      decoration: BoxDecoration(
        color: ColorPallete.backgroundSecondary,
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextField(
        controller: controller,
        autofocus: true,
        style: const TextStyle(color: ColorPallete.textPrimary),
        onChanged: onChanged,
        decoration: InputDecoration(
          hintText: 'Search tasks, projects, teams, employees…',
          hintStyle: TextStyle(color: ColorPallete.textPrimary.withOpacity(0.4)),
          prefixIcon: const Icon(Icons.search, color: ColorPallete.textSecondary),
          suffixIcon: ValueListenableBuilder<TextEditingValue>(
            valueListenable: controller,
            builder: (_, value, __) => value.text.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.clear, color: ColorPallete.textSecondary),
                    onPressed: onClear,
                  )
                : const SizedBox.shrink(),
          ),
          border: InputBorder.none,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
      ),
    );
  }
}

class _TypeFilterRow extends StatelessWidget {
  final List<String> selectedTypes;
  final List<String> allTypes;
  final ValueChanged<String> onTap;

  const _TypeFilterRow({
    required this.selectedTypes,
    required this.allTypes,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final chips = ['all', ...allTypes];
    return SizedBox(
      height: 40,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: chips.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, i) {
          final type = chips[i];
          final isSelected = type == 'all'
              ? selectedTypes.isEmpty
              : selectedTypes.contains(type);
          return ChoiceChip(
            label: Text(
              type == 'all' ? 'All' : _capitalise(type),
              style: TextStyle(
                color: isSelected ? ColorPallete.textPrimary : ColorPallete.textPrimary.withOpacity(0.60),
                fontSize: 12,
              ),
            ),
            selected: isSelected,
            selectedColor: ColorPallete.success,
            backgroundColor: ColorPallete.backgroundSecondary,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            onSelected: (_) => onTap(type),
          );
        },
      ),
    );
  }

  static String _capitalise(String s) =>
      s.isEmpty ? s : s[0].toUpperCase() + s.substring(1);
}

class _EmptyState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.search, size: 64, color: ColorPallete.textPrimary.withOpacity(0.2)),
          const SizedBox(height: 16),
          Text(
            'Search across tasks, projects,\nteams, employees and chats',
            textAlign: TextAlign.center,
            style:
                TextStyle(color: ColorPallete.textPrimary.withOpacity(0.4), fontSize: 14),
          ),
        ],
      ),
    );
  }
}

class _ResultsList extends StatelessWidget {
  final SearchResults results;
  final ValueChanged<SearchResultItem> onTap;

  const _ResultsList({required this.results, required this.onTap});

  @override
  Widget build(BuildContext context) {
    if (results.items.isEmpty) {
      return Center(
        child: Text(
          'No results for "${results.query}"',
          style: TextStyle(color: ColorPallete.textPrimary.withOpacity(0.5)),
        ),
      );
    }

    // Group by type preserving order.
    final Map<String, List<SearchResultItem>> grouped = {};
    for (final item in results.items) {
      grouped.putIfAbsent(item.type, () => []).add(item);
    }

    final sections = grouped.entries.toList();

    return ListView.builder(
      padding: const EdgeInsets.only(bottom: 24),
      itemCount: sections.fold<int>(0, (sum, e) => sum + 1 + e.value.length),
      itemBuilder: (context, index) {
        int running = 0;
        for (final entry in sections) {
          if (index == running) {
            // Section header.
            return _SectionHeader(
              type: entry.key,
              count: entry.value.length,
            );
          }
          running++;
          final itemIndex = index - running;
          if (itemIndex < entry.value.length) {
            return _SearchResultTile(
              item: entry.value[itemIndex],
              onTap: () => onTap(entry.value[itemIndex]),
            );
          }
          running += entry.value.length;
        }
        return const SizedBox.shrink();
      },
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String type;
  final int count;
  const _SectionHeader({required this.type, required this.count});

  static String _label(String t) {
    const labels = {
      'task': 'Tasks',
      'project': 'Projects',
      'team': 'Teams',
      'employee': 'Employees',
      'chat': 'Chats',
      'research': 'Research',
    };
    return labels[t] ?? t[0].toUpperCase() + t.substring(1);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 6),
      child: Text(
        '${_label(type)} ($count)',
        style: const TextStyle(
          color: ColorPallete.textSecondary,
          fontSize: 12,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.8,
        ),
      ),
    );
  }
}

class _SearchResultTile extends StatelessWidget {
  final SearchResultItem item;
  final VoidCallback onTap;

  const _SearchResultTile({required this.item, required this.onTap});

  static IconData _iconFor(String type) {
    switch (type) {
      case 'task':
        return Icons.task_alt;
      case 'project':
        return Icons.folder_outlined;
      case 'team':
        return Icons.people_outline;
      case 'employee':
        return Icons.person_outline;
      case 'chat':
        return Icons.chat_bubble_outline;
      case 'research':
        return Icons.science_outlined;
      default:
        return Icons.search;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: ColorPallete.backgroundSecondary,
        child: Icon(_iconFor(item.type), color: ColorPallete.textSecondary, size: 20),
      ),
      title: Text(
        item.title,
        style: const TextStyle(color: ColorPallete.textPrimary, fontSize: 14),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: item.subtitle.isNotEmpty
          ? Text(
              item.subtitle,
              style:
                  TextStyle(color: ColorPallete.textPrimary.withOpacity(0.5), fontSize: 12),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            )
          : null,
      onTap: onTap,
    );
  }
}
