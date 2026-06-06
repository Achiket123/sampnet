import 'package:elegant_notification/elegant_notification.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hackathon/dependency_injection.g.dart';
import '../blocs/people_list_bloc/people_list_bloc.dart';
import '../blocs/people_list_bloc/people_list_event.dart';
import '../blocs/people_list_bloc/people_list_state.dart';
import '../widgets/contact_card_widget.dart';
import '../widgets/add_contact_dialog.dart';

class PeopleListPage extends StatefulWidget {
  static const String routePath = '/people';

  const PeopleListPage({super.key});

  @override
  State<PeopleListPage> createState() => _PeopleListPageState();
}

class _PeopleListPageState extends State<PeopleListPage> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<PeopleListBloc>()..add(const PeopleListLoadRequested()),
      child: Builder(
        builder: (context) {
          return Scaffold(
            backgroundColor: const Color.fromARGB(255, 20, 20, 20),
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              title: const Text('People CRM', style: TextStyle(fontWeight: FontWeight.bold)),
              actions: [
                Padding(
                  padding: const EdgeInsets.only(right: 16),
                  child: TextButton.icon(
                    onPressed: () {
                      final bloc = context.read<PeopleListBloc>();
                      showDialog(
                        context: context,
                        builder: (context) => BlocProvider.value(
                          value: bloc,
                          child: const AddContactDialog(),
                        ),
                      );
                    },
                    icon: const Icon(Icons.person_add, size: 18),
                    label: const Text('Add Contact'),
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.blueAccent,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                        side: const BorderSide(color: Colors.white10),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            body: BlocListener<PeopleListBloc, PeopleListState>(
              listener: (context, state) {
                if (state.status == PeopleListStatus.failure || state.status == PeopleListStatus.deleteError) {
                  ElegantNotification.error(
                    title: const Text("Error",style:TextStyle(color:Colors.black)),
                    description: Text(state.failureMessage ?? "Something went wrong",style:TextStyle(color:Colors.black)),
                  ).show(context);
                }
              },
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                    child: TextField(
                      controller: _searchController,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: 'Search contacts...',
                        hintStyle: const TextStyle(color: Colors.white54),
                        prefixIcon: const Icon(Icons.search, color: Colors.white54),
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.clear, color: Colors.white54),
                          onPressed: () {
                            _searchController.clear();
                            context.read<PeopleListBloc>().add(PeopleListSearchCleared());
                          },
                        ),
                        filled: true,
                        fillColor: Colors.white.withValues(alpha: 0.05),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      onChanged: (query) {
                        context.read<PeopleListBloc>().add(PeopleListSearchChanged(query));
                      },
                    ),
                  ),
                  Expanded(
                    child: BlocBuilder<PeopleListBloc, PeopleListState>(
                      builder: (context, state) {
                        if (state.status == PeopleListStatus.loading && state.allContacts.isEmpty) {
                          return const Center(child: CircularProgressIndicator());
                        }

                        if (state.displayedContacts.isEmpty) {
                          return _buildEmptyState(context, state.searchQuery);
                        }

                        return RefreshIndicator(
                          onRefresh: () async {
                            context.read<PeopleListBloc>().add(const PeopleListLoadRequested());
                          },
                          child: ListView.builder(
                            itemCount: state.displayedContacts.length,
                            itemBuilder: (context, index) {
                              final contact = state.displayedContacts[index];
                              return ContactCardWidget(
                                contact: contact,
                                onTap: () {
                                  // TODO: Navigate to Contact Detail Page
                                },
                              );
                            },
                          ),
                        );
                      },
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

  Widget _buildEmptyState(BuildContext context, String query) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.contacts_outlined, size: 64, color: Colors.white.withValues(alpha: 0.1)),
          const SizedBox(height: 16),
          Text(
            query.isEmpty ? 'No contacts yet' : 'No results found',
            style: const TextStyle(color: Colors.white70, fontSize: 16),
          ),
        ],
      ),
    );
  }
}
