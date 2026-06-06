import 'dart:convert';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hackathon/dependency_injection.g.dart';
import 'package:hackathon/globals/constants/user.dart';

import '../../domain/entities/research_entry_entity.dart';
import '../../domain/entities/research_status.dart';
import '../blocs/research_detail_bloc/research_detail_bloc.dart';
import '../blocs/research_list_bloc/research_list_bloc.dart';
import '../../../projects/presentation/blocs/project_bloc/project_bloc.dart';
import '../../../projects/presentation/blocs/project_bloc/project_state.dart';
import '../../../team/presentation/blocs/team_bloc/team_bloc.dart';

class CreateEditResearchPage extends StatefulWidget {
  static const String routePath = '/create-edit-research';
  static const String routeName = 'create-edit-research';

  final ResearchEntryEntity? entryToEdit;

  const CreateEditResearchPage({super.key, this.entryToEdit});

  @override
  State<CreateEditResearchPage> createState() => _CreateEditResearchPageState();
}

class _CreateEditResearchPageState extends State<CreateEditResearchPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late TextEditingController _tagsController;
  ResearchStatus _selectedStatus = ResearchStatus.draft;
  int? _selectedProjectId;
  int? _selectedTeamId;
  List<String> _tags = [];
  String? _base64Thumbnail;
  Uint8List? _thumbnailBytes;

  @override
  void initState() {
    super.initState();
    _titleController =
        TextEditingController(text: widget.entryToEdit?.title ?? '');
    _descriptionController =
        TextEditingController(text: widget.entryToEdit?.description ?? '');
    _tagsController = TextEditingController();
    _selectedStatus = widget.entryToEdit?.status ?? ResearchStatus.draft;
    _selectedProjectId = widget.entryToEdit?.projectId;
    _selectedTeamId = widget.entryToEdit?.teamId;
    _tags = widget.entryToEdit != null
        ? List<String>.from(widget.entryToEdit!.tags)
        : [];
    
    if (widget.entryToEdit?.thumbnail != null) {
      _base64Thumbnail = widget.entryToEdit!.thumbnail;
      try {
        _thumbnailBytes = base64Decode(_base64Thumbnail!);
      } catch (_) {}
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _tagsController.dispose();
    super.dispose();
  }

  Future<void> _pickThumbnail() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      withData: true,
    );

    if (result != null && result.files.first.bytes != null) {
      setState(() {
        _thumbnailBytes = result.files.first.bytes;
        _base64Thumbnail = base64Encode(_thumbnailBytes!);
      });
    }
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      final user = getIt<User>().user;
      final entry = ResearchEntryEntity(
        id: widget.entryToEdit?.id ?? 0,
        title: _titleController.text,
        description: _descriptionController.text,
        thumbnail: _base64Thumbnail,
        status: _selectedStatus,
        authorName: widget.entryToEdit?.authorName ?? '',
        authorId: widget.entryToEdit?.authorId ?? user!.id,
        projectId: _selectedProjectId,
        teamId: _selectedTeamId,
        tags: _tags,
        createdAt: widget.entryToEdit?.createdAt ?? DateTime.now(),
        updatedAt: DateTime.now(),
      );

      if (widget.entryToEdit == null) {
        context
            .read<ResearchDetailBloc>()
            .add(CreateResearchEntry(entry: entry));
      } else {
        context
            .read<ResearchDetailBloc>()
            .add(UpdateResearchEntry(entry: entry));
      }
      // Relying on BlocListener for pop
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F0F11),
      appBar: AppBar(
        title: Text(
            widget.entryToEdit == null ? 'Create Research' : 'Edit Research',
            style: const TextStyle(color: Colors.white)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.white),
          onPressed: () => context.pop(),
        ),
      ),
      body: MultiBlocListener(
        listeners: [
          BlocListener<ResearchDetailBloc, ResearchDetailState>(
            listener: (context, state) {
              if (state is ResearchActionSuccess) {
                context
                    .read<ResearchListBloc>()
                    .add(const LoadResearchList(isRefresh: true));
                context.pop(true);
              }
            },
          ),
        ],
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildThumbnailSection(),
                const SizedBox(height: 24),
                _buildTextField(
                  controller: _titleController,
                  label: 'Title',
                  validator: (v) =>
                      v == null || v.isEmpty ? 'Title is required' : null,
                ),
                const SizedBox(height: 20),
                _buildTextField(
                  controller: _descriptionController,
                  label: 'Description',
                  maxLines: 5,
                ),
                const SizedBox(height: 20),
                _buildDropdown<ResearchStatus>(
                  label: 'Status',
                  value: _selectedStatus,
                  items: ResearchStatus.values
                      .map((s) =>
                          DropdownMenuItem(value: s, child: Text(s.label)))
                      .toList(),
                  onChanged: (v) => setState(() => _selectedStatus = v!),
                ),
                const SizedBox(height: 20),
                _buildTagsSection(),
                const SizedBox(height: 20),
                BlocBuilder<ProjectsBloc, ProjectState>(
                  builder: (context, state) {
                    List<DropdownMenuItem<int?>> items = [
                      const DropdownMenuItem(value: null, child: Text('None'))
                    ];
                    if (state is ProjectsLoaded) {
                      items.addAll(state.projects.map((p) =>
                          DropdownMenuItem(value: p.id, child: Text(p.name))));
                    }
                    return _buildDropdown<int?>(
                      label: 'Link to Project (Optional)',
                      value: _selectedProjectId,
                      items: items,
                      onChanged: (v) => setState(() => _selectedProjectId = v),
                    );
                  },
                ),
                const SizedBox(height: 20),
                BlocBuilder<TeamBloc, TeamState>(
                  builder: (context, state) {
                    List<DropdownMenuItem<int?>> items = [
                      const DropdownMenuItem(value: null, child: Text('None'))
                    ];
                    if (state is TeamSuccessState) {
                      items.addAll(state.teams.map((t) =>
                          DropdownMenuItem(value: t.id, child: Text(t.name))));
                    }
                    return _buildDropdown<int?>(
                      label: 'Link to Team (Optional)',
                      value: _selectedTeamId,
                      items: items,
                      onChanged: (v) => setState(() => _selectedTeamId = v),
                    );
                  },
                ),
                const SizedBox(height: 40),
                BlocBuilder<ResearchDetailBloc, ResearchDetailState>(
                  builder: (context, state) {
                    return SizedBox(
                      width: double.infinity,
                      height: 54,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.black,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                          elevation: 0,
                        ),
                        onPressed:
                            state is ResearchDetailLoading ? null : _submit,
                        child: state is ResearchDetailLoading
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child:
                                    CircularProgressIndicator(strokeWidth: 2))
                            : Text(
                                widget.entryToEdit == null
                                    ? 'CREATE ENTRY'
                                    : 'UPDATE ENTRY',
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 1.2),
                              ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildThumbnailSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Thumbnail',
            style: TextStyle(
                color: Colors.white70,
                fontSize: 12,
                fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        Center(
          child: GestureDetector(
            onTap: _pickThumbnail,
            child: Container(
              width: double.infinity,
              height: 160,
              decoration: BoxDecoration(
                color: const Color(0xFF16161A),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.white10),
                image: _thumbnailBytes != null
                    ? DecorationImage(
                        image: MemoryImage(_thumbnailBytes!),
                        fit: BoxFit.cover,
                      )
                    : null,
              ),
              child: _thumbnailBytes == null
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.add_photo_alternate_outlined,
                            color: Colors.white.withValues(alpha: 0.3), size: 40),
                        const SizedBox(height: 8),
                        Text('Add File (Workspace Image)',
                            style: TextStyle(
                                color: Colors.white.withValues(alpha: 0.3),
                                fontSize: 12)),
                      ],
                    )
                  : Stack(
                      children: [
                        Positioned(
                          right: 8,
                          top: 8,
                          child: CircleAvatar(
                            backgroundColor: Colors.black54,
                            radius: 16,
                            child: IconButton(
                              icon: const Icon(Icons.edit, size: 14, color: Colors.white),
                              onPressed: _pickThumbnail,
                            ),
                          ),
                        ),
                      ],
                    ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(
                color: Colors.white70,
                fontSize: 12,
                fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          maxLines: maxLines,
          validator: validator,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            filled: true,
            fillColor: const Color(0xFF16161A),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Colors.white10)),
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Colors.white10)),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Colors.white30)),
            contentPadding: const EdgeInsets.all(16),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdown<T>({
    required String label,
    required T value,
    required List<DropdownMenuItem<T>> items,
    required Function(T?) onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(
                color: Colors.white70,
                fontSize: 12,
                fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        DropdownButtonFormField<T>(
          value: value,
          items: items,
          onChanged: onChanged,
          dropdownColor: const Color(0xFF16161A),
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            filled: true,
            fillColor: const Color(0xFF16161A),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Colors.white10)),
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Colors.white10)),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          ),
        ),
      ],
    );
  }

  Widget _buildTagsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Tags',
            style: TextStyle(
                color: Colors.white70,
                fontSize: 12,
                fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: _tagsController,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: 'Press enter to add tag',
                  hintStyle:
                      const TextStyle(color: Colors.white24, fontSize: 14),
                  filled: true,
                  fillColor: const Color(0xFF16161A),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Colors.white10)),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Colors.white10)),
                ),
                onFieldSubmitted: (v) {
                  if (v.isNotEmpty && !_tags.contains(v)) {
                    setState(() {
                      _tags.add(v);
                      _tagsController.clear();
                    });
                  }
                },
              ),
            ),
          ],
        ),
        if (_tags.isNotEmpty) ...[
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _tags
                .map((tag) => Chip(
                      label: Text(tag),
                      onDeleted: () => setState(() => _tags.remove(tag)),
                      backgroundColor: Colors.white.withValues(alpha: 0.05),
                      labelStyle:
                          const TextStyle(color: Colors.white70, fontSize: 12),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                      deleteIconColor: Colors.white38,
                      deleteIcon: const Icon(Icons.close, size: 14),
                    ))
                .toList(),
          ),
        ],
      ],
    );
  }
}
