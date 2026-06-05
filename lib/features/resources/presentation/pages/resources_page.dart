import 'package:elegant_notification/elegant_notification.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hackathon/dependency_injection.g.dart';
import 'package:hackathon/features/resources/domain/entities/resource_file_entity.dart';
import 'package:hackathon/features/resources/presentation/blocs/resources_list_bloc/resources_list_bloc.dart';
import 'package:hackathon/features/resources/presentation/blocs/resources_list_bloc/resources_list_event.dart';
import 'package:hackathon/features/resources/presentation/blocs/resources_list_bloc/resources_list_state.dart';
import 'package:hackathon/globals/constants/color_pallete.dart';
import 'package:hackathon/globals/constants/user.dart';
import 'package:hackathon/widgets/custom_app_bar.dart';
import 'package:hackathon/widgets/custom_drawer.dart';
import 'package:hackathon/widgets/list_of_side_bar.dart';
import 'package:intl/intl.dart';

final GlobalKey<ScaffoldState> _resourcesPageKey = GlobalKey<ScaffoldState>();

class ResourcesPage extends StatefulWidget {
  static const String routePath = '/resources';
  static const String routeName = 'resources';
  const ResourcesPage({super.key});

  @override
  State<ResourcesPage> createState() => _ResourcesPageState();
}

class _ResourcesPageState extends State<ResourcesPage> {
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();
  ResourceCollection? _activeCollection;

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

  void _refetch(BuildContext context) {
    final token = getIt<User>().token ?? '';
    if (_activeCollection != null) {
      context.read<ResourcesListBloc>().add(
        SelectCollectionEvent(collection: _activeCollection!, token: token),
      );
    } else {
      context.read<ResourcesListBloc>().add(FetchCollectionsEvent(token: token));
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    final token = getIt<User>().token ?? '';

    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: ColorPallete.background2,
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: BlocProvider(
        create: (context) => getIt<ResourcesListBloc>()..add(FetchCollectionsEvent(token: token)),
        child: BlocConsumer<ResourcesListBloc, ResourcesListState>(
          listener: (context, state) {
            if (state is ResourcesActionSuccess) {
              ElegantNotification.success(
                title: const Text("Success"),
                description: Text(
                  state.message,
                  maxLines: 2,
                  style : const TextStyle(color:Colors.black),
                  overflow: TextOverflow.ellipsis,
                ),
                height: 100,
              ).show(context);
              _refetch(context);
            } else if (state is ResourcesListError) {
              ElegantNotification.error(
                title: const Text("Error"),
                description: Text(
                  state.message,
                  maxLines: 3,
                  style : const TextStyle(color:Colors.black),
                  overflow: TextOverflow.ellipsis,
                ),
                height: 120,
              ).show(context);
            } else if (state is CollectionRecordsLoaded) {
              setState(() {
                _activeCollection = state.collection;
              });
            }
          },
          builder: (context, state) {
            return Scaffold(
              key: _resourcesPageKey,
              drawer: CustomDrawer(
                selectedIndex: ListOfSideBar.sideBarItems.indexOf('Resources'),
              ),
              backgroundColor: Colors.transparent,
              body: ListView(
                padding: EdgeInsets.symmetric(
                  horizontal: width * 0.04,
                  vertical: height * 0.02,
                ),
                children: [
                  _appBar(context),
                  const SizedBox(height: 20),
                  if (_activeCollection != null && state is CollectionRecordsLoaded) ...[
                    _buildRecordsView(context, state.collection, state.records),
                  ] else ...[
                    _buildCollectionsListView(context, state),
                  ],
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _appBar(BuildContext context) {
    return CustomAppBar(
      children: [
        const SizedBox(width: 8),
        Text(
          _activeCollection != null ? _activeCollection!.name.toUpperCase() : 'RESOURCES',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        const Spacer(),
        if (_activeCollection != null)
          IconButton(
            onPressed: () {
              setState(() {
                _activeCollection = null;
              });
              _refetch(context);
            },
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
          ),
        IconButton(
          onPressed: () {
            _resourcesPageKey.currentState?.openDrawer();
          },
          icon: const Icon(
            Icons.menu,
            color: ColorPallete.white,
          ),
        ),
      ],
    );
  }

  // ── COLLECTIONS LIST VIEW ──
  Widget _buildCollectionsListView(BuildContext context, ResourcesListState state) {
    List<ResourceCollection> collections = [];
    bool isLoading = state is ResourcesListLoading;

    if (state is CollectionsLoaded) {
      collections = state.collections;
    }

    final filtered = collections
        .where((c) =>
            c.name.toLowerCase().contains(_searchQuery) ||
            c.description.toLowerCase().contains(_searchQuery))
        .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildBelowAppBar(context),
        const SizedBox(height: 20),
        if (isLoading)
          const Center(
            child: Padding(
              padding: EdgeInsets.all(40.0),
              child: CircularProgressIndicator.adaptive(
                valueColor: AlwaysStoppedAnimation(Colors.white),
              ),
            ),
          )
        else if (filtered.isEmpty)
          _buildEmptyState(context, "No resource collections found", "Click 'Create Collection' to get started.")
        else
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: filtered.length,
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 400,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 1.5,
            ),
            itemBuilder: (context, index) {
              final col = filtered[index];
              return _buildCollectionCard(context, col);
            },
          ),
      ],
    );
  }

  Widget _buildBelowAppBar(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 48,
            decoration: BoxDecoration(
              color: const Color(0xFF16161A),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.white10),
            ),
            child: TextField(
              controller: _searchController,
              style: const TextStyle(color: Colors.white, fontSize: 14),
              decoration: const InputDecoration(
                hintText: 'Search collections...',
                hintStyle: TextStyle(color: Colors.white24),
                prefixIcon: Icon(Icons.search_rounded, color: Colors.white38, size: 20),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),
        ),
        const SizedBox(width: 16),
        ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          icon: const Icon(Icons.add, size: 18),
          label: const Text(
            'Create Collection',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          onPressed: () => _showCreateCollectionDialog(context),
        ),
      ],
    );
  }

  Widget _buildCollectionCard(BuildContext context, ResourceCollection col) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF16161A),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  col.name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              PopupMenuButton<String>(
                icon: const Icon(Icons.more_vert, color: Colors.white70),
                color: const Color(0xFF16161A),
                onSelected: (val) {
                  if (val == 'edit') {
                    _showEditCollectionDialog(context, col);
                  } else if (val == 'delete') {
                    _confirmDeleteCollection(context, col);
                  }
                },
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: 'edit',
                    child: Text('Edit', style: TextStyle(color: Colors.white)),
                  ),
                  const PopupMenuItem(
                    value: 'delete',
                    child: Text('Delete', style: TextStyle(color: Colors.redAccent)),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 8),
          Expanded(
            child: Text(
              col.description.isNotEmpty ? col.description : "No description provided.",
              style: const TextStyle(color: Colors.white60, fontSize: 13),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${col.fields.length} Fields',
                style: const TextStyle(color: Colors.white38, fontSize: 11),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white10,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                    side: const BorderSide(color: Colors.white24),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                ),
                onPressed: () {
                  context.read<ResourcesListBloc>().add(
                        SelectCollectionEvent(
                          collection: col,
                          token: getIt<User>().token ?? '',
                        ),
                      );
                },
                child: const Text('View Records', style: TextStyle(fontSize: 12)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ── RECORDS VIEW ──
  Widget _buildRecordsView(BuildContext context, ResourceCollection col, List<ResourceRecord> records) {
    final filteredRecords = records.where((r) {
      if (_searchQuery.isEmpty) return true;
      return r.data.values.any((val) => val.toString().toLowerCase().contains(_searchQuery));
    }).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                col.description.isNotEmpty ? col.description : "Collection records database.",
                style: const TextStyle(color: Colors.white60, fontSize: 14),
              ),
            ),
            const SizedBox(width: 16),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              icon: const Icon(Icons.add, size: 16),
              label: const Text('Add Record', style: TextStyle(fontWeight: FontWeight.bold)),
              onPressed: () => _showRecordFormDialog(context, col, null),
            ),
          ],
        ),
        const SizedBox(height: 20),
        // Mini search bar for records
        Container(
          height: 48,
          decoration: BoxDecoration(
            color: const Color(0xFF16161A),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.white10),
          ),
          child: TextField(
            controller: _searchController,
            style: const TextStyle(color: Colors.white, fontSize: 14),
            decoration: const InputDecoration(
              hintText: 'Search records...',
              hintStyle: TextStyle(color: Colors.white24),
              prefixIcon: Icon(Icons.search_rounded, color: Colors.white38, size: 20),
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(vertical: 12),
            ),
          ),
        ),
        const SizedBox(height: 20),
        if (filteredRecords.isEmpty)
          _buildEmptyState(context, "No records found", "Add records by clicking 'Add Record'.")
        else
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFF16161A),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.white10),
            ),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                headingRowColor: WidgetStateProperty.all(Colors.white.withAlpha(7)),
                columns: [
                  ...col.fields.map(
                    (f) => DataColumn(
                      label: Text(
                        f.label.toUpperCase(),
                        style: const TextStyle(
                          color: Colors.white70,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                  const DataColumn(
                    label: Text(
                      'ACTIONS',
                      style: TextStyle(
                        color: Colors.white70,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
                rows: filteredRecords.map((rec) {
                  return DataRow(
                    cells: [
                      ...col.fields.map((field) {
                        final rawVal = rec.data[field.key];
                        String displayVal = "";
                        if (rawVal != null) {
                          if (field.type == 'date') {
                            try {
                              displayVal = DateFormat('yyyy-MM-dd').format(DateTime.parse(rawVal.toString()));
                            } catch (_) {
                              displayVal = rawVal.toString();
                            }
                          } else {
                            displayVal = rawVal.toString();
                          }
                        }
                        return DataCell(
                          Text(
                            displayVal,
                            style: const TextStyle(color: Colors.white70, fontSize: 13),
                          ),
                        );
                      }),
                      DataCell(
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit, color: Colors.blueAccent, size: 18),
                              onPressed: () => _showRecordFormDialog(context, col, rec),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.redAccent, size: 18),
                              onPressed: () => _confirmDeleteRecord(context, col.id, rec.id),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                }).toList(),
              ),
            ),
          ),
      ],
    );
  }

  // ── DIALOGS ──

  void _showCreateCollectionDialog(BuildContext parentContext) {
    final nameController = TextEditingController();
    final descController = TextEditingController();
    final List<Map<String, dynamic>> localFields = [
      {'label': 'Title', 'type': 'text', 'required': true, 'options': ''}
    ];

    showDialog(
      context: parentContext,
      builder: (dialogCtx) => StatefulBuilder(
        builder: (ctx, setDialogState) => AlertDialog(
          backgroundColor: const Color(0xFF0F0F11),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: const BorderSide(color: Colors.white10),
          ),
          title: const Text('Create Collection', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          content: SizedBox(
            width: 500,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: nameController,
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                      labelText: 'Collection Name',
                      labelStyle: TextStyle(color: Colors.white38),
                      enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white10)),
                      focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: descController,
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                      labelText: 'Description',
                      labelStyle: TextStyle(color: Colors.white38),
                      enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white10)),
                      focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Fields Definition', style: TextStyle(color: Colors.white70, fontWeight: FontWeight.bold)),
                      TextButton.icon(
                        icon: const Icon(Icons.add, size: 16, color: Colors.blueAccent),
                        label: const Text('Add Field', style: TextStyle(color: Colors.blueAccent)),
                        onPressed: () {
                          setDialogState(() {
                            localFields.add({'label': '', 'type': 'text', 'required': false, 'options': ''});
                          });
                        },
                      ),
                    ],
                  ),
                  const Divider(color: Colors.white10),
                  ...localFields.asMap().entries.map((entry) {
                    final idx = entry.key;
                    final field = entry.value;
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              initialValue: field['label'],
                              style: const TextStyle(color: Colors.white, fontSize: 13),
                              decoration: const InputDecoration(
                                hintText: 'Label (e.g. Price)',
                                hintStyle: TextStyle(color: Colors.white24),
                                border: InputBorder.none,
                              ),
                              onChanged: (val) {
                                field['label'] = val;
                              },
                            ),
                          ),
                          const SizedBox(width: 8),
                          DropdownButton<String>(
                            dropdownColor: const Color(0xFF16161A),
                            value: field['type'],
                            items: const [
                              DropdownMenuItem(value: 'text', child: Text('Text', style: TextStyle(color: Colors.white, fontSize: 12))),
                              DropdownMenuItem(value: 'number', child: Text('Number', style: TextStyle(color: Colors.white, fontSize: 12))),
                              DropdownMenuItem(value: 'boolean', child: Text('Checkbox', style: TextStyle(color: Colors.white, fontSize: 12))),
                              DropdownMenuItem(value: 'select', child: Text('Dropdown', style: TextStyle(color: Colors.white, fontSize: 12))),
                              DropdownMenuItem(value: 'date', child: Text('Date', style: TextStyle(color: Colors.white, fontSize: 12))),
                            ],
                            onChanged: (val) {
                              if (val != null) {
                                setDialogState(() {
                                  field['type'] = val;
                                });
                              }
                            },
                          ),
                          const SizedBox(width: 8),
                          Checkbox(
                            value: field['required'],
                            onChanged: (val) {
                              setDialogState(() {
                                field['required'] = val ?? false;
                              });
                            },
                          ),
                          const Text('Req', style: TextStyle(color: Colors.white38, fontSize: 10)),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.redAccent, size: 16),
                            onPressed: () {
                              setDialogState(() {
                                localFields.removeAt(idx);
                              });
                            },
                          ),
                        ],
                      ),
                    );
                  }),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancel', style: TextStyle(color: Colors.white54)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.white, foregroundColor: Colors.black),
              onPressed: () {
                if (nameController.text.trim().isEmpty) return;

                final fieldsList = localFields.map((lf) {
                  final key = lf['label'].toString().toLowerCase().replaceAll(RegExp(r'\s+'), '_');
                  return CollectionField(
                    key: key,
                    label: lf['label'].toString(),
                    type: lf['type'].toString(),
                    required: lf['required'] as bool,
                    options: lf['options'].toString().split(',').map((e) => e.trim()).where((e) => e.isNotEmpty).toList(),
                  );
                }).toList();

                parentContext.read<ResourcesListBloc>().add(
                  CreateCollectionEvent(
                    name: nameController.text.trim(),
                    description: descController.text.trim(),
                    fields: fieldsList,
                    token: getIt<User>().token ?? '',
                  ),
                );
                Navigator.pop(ctx);
              },
              child: const Text('Create', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }

  void _showEditCollectionDialog(BuildContext parentContext, ResourceCollection col) {
    final nameController = TextEditingController(text: col.name);
    final descController = TextEditingController(text: col.description);

    showDialog(
      context: parentContext,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF0F0F11),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: Colors.white10),
        ),
        title: const Text('Edit Collection Info', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(labelText: 'Name', labelStyle: TextStyle(color: Colors.white38)),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: descController,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(labelText: 'Description', labelStyle: TextStyle(color: Colors.white38)),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel', style: TextStyle(color: Colors.white54)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.white, foregroundColor: Colors.black),
            onPressed: () {
              parentContext.read<ResourcesListBloc>().add(
                UpdateCollectionEvent(
                  id: col.id,
                  name: nameController.text.trim(),
                  description: descController.text.trim(),
                  token: getIt<User>().token ?? '',
                ),
              );
              Navigator.pop(ctx);
            },
            child: const Text('Save', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  void _confirmDeleteCollection(BuildContext parentContext, ResourceCollection col) {
    showDialog<bool>(
      context: parentContext,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF0F0F11),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16), side: const BorderSide(color: Colors.white10)),
        title: const Text('Delete Collection', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        content: Text('Are you sure you want to delete "${col.name}"? All records will be permanently lost.', style: const TextStyle(color: Colors.white70)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel', style: TextStyle(color: Colors.white54))),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent, foregroundColor: Colors.white),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Delete', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    ).then((confirmed) {
      if (confirmed == true && parentContext.mounted) {
        parentContext.read<ResourcesListBloc>().add(
          DeleteCollectionEvent(id: col.id, token: getIt<User>().token ?? ''),
        );
      }
    });
  }

  void _showRecordFormDialog(BuildContext parentContext, ResourceCollection col, ResourceRecord? existingRecord) {
    final formKey = GlobalKey<FormState>();
    final Map<String, dynamic> recordData = Map.from(existingRecord?.data ?? {});

    showDialog(
      context: parentContext,
      builder: (ctx) => StatefulBuilder(
        builder: (dialogCtx, setDialogState) => AlertDialog(
          backgroundColor: const Color(0xFF0F0F11),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: const BorderSide(color: Colors.white10),
          ),
          title: Text(existingRecord != null ? 'Edit Record' : 'Add Record', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          content: SizedBox(
            width: 450,
            child: Form(
              key: formKey,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: col.fields.map((field) {
                    if (field.type == 'boolean') {
                      final bool val = recordData[field.key] == true;
                      return SwitchListTile(
                        title: Text(field.label, style: const TextStyle(color: Colors.white70)),
                        value: val,
                        onChanged: (newVal) {
                          setDialogState(() {
                            recordData[field.key] = newVal;
                          });
                        },
                      );
                    } else if (field.type == 'select') {
                      final String? current = recordData[field.key]?.toString();
                      return DropdownButtonFormField<String>(
                        dropdownColor: const Color(0xFF16161A),
                        value: field.options.contains(current) ? current : null,
                        decoration: InputDecoration(
                          labelText: field.label,
                          labelStyle: const TextStyle(color: Colors.white38),
                        ),
                        items: field.options
                            .map((o) => DropdownMenuItem(
                                  value: o,
                                  child: Text(o, style: const TextStyle(color: Colors.white)),
                                ))
                            .toList(),
                        validator: (v) => field.required && (v == null || v.isEmpty) ? 'Required' : null,
                        onChanged: (newVal) {
                          recordData[field.key] = newVal;
                        },
                      );
                    } else if (field.type == 'date') {
                      final rawVal = recordData[field.key];
                      DateTime? dt;
                      if (rawVal != null) {
                        dt = DateTime.tryParse(rawVal.toString());
                      }
                      return ListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Text(field.label, style: const TextStyle(color: Colors.white38, fontSize: 12)),
                        subtitle: Text(
                          dt != null ? DateFormat('yyyy-MM-dd').format(dt) : 'Choose date...',
                          style: const TextStyle(color: Colors.white),
                        ),
                        trailing: const Icon(Icons.calendar_today, color: Colors.white54, size: 18),
                        onTap: () async {
                          final selected = await showDatePicker(
                            context: dialogCtx,
                            initialDate: dt ?? DateTime.now(),
                            firstDate: DateTime(2000),
                            lastDate: DateTime(2100),
                          );
                          if (selected != null) {
                            setDialogState(() {
                              recordData[field.key] = selected.toIso8601String();
                            });
                          }
                        },
                      );
                    } else {
                      return TextFormField(
                        initialValue: recordData[field.key]?.toString(),
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          labelText: field.label,
                          labelStyle: const TextStyle(color: Colors.white38),
                        ),
                        keyboardType: field.type == 'number' ? TextInputType.number : TextInputType.text,
                        validator: (v) => field.required && (v == null || v.isEmpty) ? 'Required' : null,
                        onChanged: (newVal) {
                          if (field.type == 'number') {
                            recordData[field.key] = num.tryParse(newVal) ?? newVal;
                          } else {
                            recordData[field.key] = newVal;
                          }
                        },
                      );
                    }
                  }).toList(),
                ),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancel', style: TextStyle(color: Colors.white54)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.white, foregroundColor: Colors.black),
              onPressed: () {
                if (formKey.currentState?.validate() ?? false) {
                  final token = getIt<User>().token ?? '';
                  if (existingRecord != null) {
                    parentContext.read<ResourcesListBloc>().add(
                          UpdateRecordEvent(
                            collectionId: col.id,
                            recordId: existingRecord.id,
                            data: recordData,
                            token: token,
                          ),
                        );
                  } else {
                    parentContext.read<ResourcesListBloc>().add(
                          CreateRecordEvent(
                            collectionId: col.id,
                            data: recordData,
                            token: token,
                          ),
                        );
                  }
                  Navigator.pop(ctx);
                }
              },
              child: const Text('Save', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }

  void _confirmDeleteRecord(BuildContext parentContext, int collectionId, int recordId) {
    showDialog<bool>(
      context: parentContext,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF0F0F11),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16), side: const BorderSide(color: Colors.white10)),
        title: const Text('Delete Record', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        content: const Text('Are you sure you want to delete this record?', style: TextStyle(color: Colors.white70)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel', style: TextStyle(color: Colors.white54))),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent, foregroundColor: Colors.white),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Delete', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    ).then((confirmed) {
      if (confirmed == true && parentContext.mounted) {
        parentContext.read<ResourcesListBloc>().add(
              DeleteRecordEvent(
                collectionId: collectionId,
                recordId: recordId,
                token: getIt<User>().token ?? '',
              ),
            );
      }
    });
  }

  Widget _buildEmptyState(BuildContext context, String title, String subtitle) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 80.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.folder_open, size: 64, color: Colors.white24),
            const SizedBox(height: 16),
            Text(
              title,
              style: const TextStyle(color: Colors.white70, fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            Text(
              subtitle,
              style: const TextStyle(color: Colors.white38, fontSize: 13),
            ),
          ],
        ),
      ),
    );
  }
}
