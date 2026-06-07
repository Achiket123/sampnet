import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../globals/constants/color_pallete.dart';
import '../../domain/entities/research_document_entity.dart';
import '../../domain/entities/research_entry_entity.dart';
import '../../domain/entities/research_folder_entity.dart';
import '../blocs/research_workspace_bloc/research_workspace_bloc.dart';
import 'markdown_editor_page.dart';

class ResearchExplorerPage extends StatefulWidget {
  static const String routePath = '/research-explorer';
  static const String routeName = 'research-explorer';

  final int researchId;
  final ResearchEntryEntity? entry;

  const ResearchExplorerPage({super.key, required this.researchId, this.entry});

  @override
  State<ResearchExplorerPage> createState() => _ResearchExplorerPageState();
}

class _ResearchExplorerPageState extends State<ResearchExplorerPage> {
  final List<ResearchFolderEntity> _folderStack = [];

  int? get _currentFolderId =>
      _folderStack.isEmpty ? null : _folderStack.last.id;

  @override
  void initState() {
    super.initState();
    context.read<ResearchWorkspaceBloc>().add(
          LoadWorkspace(
              researchId: widget.researchId, parentFolderId: _currentFolderId),
        );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ResearchWorkspaceBloc, ResearchWorkspaceState>(
      listener: (context, state) {
        if (state.createdDocument != null) {
          context.push(
            '${MarkdownEditorPage.routePath}/${state.createdDocument!.id}',
            extra: {
              'researchId': widget.researchId,
              'folderId': _currentFolderId,
            },
          );
        }
        if (state.errorMessage != null && state.errorMessage!.isNotEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.errorMessage!)),
          );
        }
      },
      child: Scaffold(
        backgroundColor: ColorPallete.backgroundPrimary,
        appBar: AppBar(
          backgroundColor: ColorPallete.backgroundSecondary,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: ColorPallete.textPrimary),
            onPressed: () {
              if (_folderStack.isNotEmpty) {
                setState(() => _folderStack.removeLast());
                context.read<ResearchWorkspaceBloc>().add(
                      LoadWorkspace(
                          researchId: widget.researchId,
                          parentFolderId: _currentFolderId),
                    );
                return;
              }
              context.pop();
            },
          ),
          title: Text(
            widget.entry?.title ?? 'Research Workspace',
            style: const TextStyle(color: ColorPallete.textPrimary, fontSize: 16),
          ),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildBreadcrumbs(),
            _buildActionToolbar(),
            Expanded(
              child: BlocBuilder<ResearchWorkspaceBloc, ResearchWorkspaceState>(
                builder: (context, state) {
                  if (state.isLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (state.folders.isEmpty && state.documents.isEmpty) {
                    return const Center(
                      child: Text(
                        'This folder is empty. Create a folder or document to start organizing research.',
                        style: TextStyle(color: ColorPallete.textSecondary),
                        textAlign: TextAlign.center,
                      ),
                    );
                  }
                  return _buildExplorerGrid(state);
                },
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: ColorPallete.success,
          child: const Icon(Icons.add, color: ColorPallete.textPrimary),
          onPressed: () => _showCreateMenu(context),
        ),
      ),
    );
  }

  Widget _buildBreadcrumbs() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: ColorPallete.divider)),
      ),
      child: Wrap(
        crossAxisAlignment: WrapCrossAlignment.center,
        spacing: 8,
        children: [
          InkWell(
            onTap: () {
              setState(_folderStack.clear);
              context.read<ResearchWorkspaceBloc>().add(
                    LoadWorkspace(
                        researchId: widget.researchId, parentFolderId: null),
                  );
            },
            child: const Text('Root',
                style: TextStyle(
                    color: ColorPallete.textPrimary, fontWeight: FontWeight.bold)),
          ),
          for (var i = 0; i < _folderStack.length; i++) ...[
            Text('/',
                style: TextStyle(color: ColorPallete.textPrimary.withValues(alpha: 0.4))),
            InkWell(
              onTap: () {
                setState(
                    () => _folderStack.removeRange(i + 1, _folderStack.length));
                context.read<ResearchWorkspaceBloc>().add(
                      LoadWorkspace(
                          researchId: widget.researchId,
                          parentFolderId: _currentFolderId),
                    );
              },
              child: Text(
                _folderStack[i].name,
                style: const TextStyle(color: ColorPallete.textSecondary),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildActionToolbar() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          _buildToolbarButton(Icons.create_new_folder_outlined, 'New Folder',
              () => _promptForFolder(context)),
          const SizedBox(width: 12),
          _buildToolbarButton(Icons.description_outlined, 'New Document',
              () => _createDocument(context)),
        ],
      ),
    );
  }

  Widget _buildToolbarButton(IconData icon, String label, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: ColorPallete.textPrimary.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: ColorPallete.divider),
        ),
        child: Row(
          children: [
            Icon(icon, color: ColorPallete.textSecondary, size: 16),
            const SizedBox(width: 6),
            Text(label,
                style: const TextStyle(color: ColorPallete.textSecondary, fontSize: 12)),
          ],
        ),
      ),
    );
  }

  Widget _buildExplorerGrid(ResearchWorkspaceState state) {
    final items = [...state.folders, ...state.documents];
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 1.15,
      ),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        if (item is ResearchFolderEntity) {
          return _buildFolderCard(item);
        }
        return _buildDocumentCard(item as ResearchDocumentEntity);
      },
    );
  }

  Widget _buildFolderCard(ResearchFolderEntity folder) {
    return InkWell(
      onTap: () {
        setState(() => _folderStack.add(folder));
        context.read<ResearchWorkspaceBloc>().add(
              LoadWorkspace(
                  researchId: widget.researchId, parentFolderId: folder.id),
            );
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: ColorPallete.backgroundSecondary,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: ColorPallete.divider),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Icon(Icons.folder_rounded,
                    color: ColorPallete.redPrimary, size: 32),
                PopupMenuButton<String>(
                  color: ColorPallete.backgroundSecondary,
                  onSelected: (value) {
                    if (value == 'delete') {
                      context.read<ResearchWorkspaceBloc>().add(
                            DeleteWorkspaceFolder(
                              researchId: widget.researchId,
                              parentFolderId: _currentFolderId,
                              folderId: folder.id,
                            ),
                          );
                    }
                  },
                  itemBuilder: (context) => const [
                    PopupMenuItem(
                        value: 'delete',
                        child: Text('Delete',
                            style: TextStyle(color: ColorPallete.textPrimary))),
                  ],
                  icon: const Icon(Icons.more_vert,
                      color: ColorPallete.textSecondary, size: 20),
                ),
              ],
            ),
            const Spacer(),
            Text(
              folder.name,
              style: const TextStyle(
                  color: ColorPallete.textPrimary,
                  fontWeight: FontWeight.w600,
                  fontSize: 14),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            Text(
              'Updated ${DateFormat('MMM d').format(folder.updatedAt)}',
              style: TextStyle(
                  color: ColorPallete.textPrimary.withValues(alpha: 0.5), fontSize: 11),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDocumentCard(ResearchDocumentEntity document) {
    return InkWell(
      onTap: () {
        context.push(
          '${MarkdownEditorPage.routePath}/${document.id}',
          extra: {
            'researchId': widget.researchId,
            'folderId': _currentFolderId,
            'title': document.title,
            'content': document.content,
          },
        );
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: ColorPallete.backgroundSecondary,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: ColorPallete.divider),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(Icons.description_outlined,
                    color: ColorPallete.statusColor('pending'), size: 32),
                PopupMenuButton<String>(
                  color: ColorPallete.backgroundSecondary,
                  onSelected: (value) {
                    if (value == 'delete') {
                      context.read<ResearchWorkspaceBloc>().add(
                            DeleteWorkspaceDocument(
                              researchId: widget.researchId,
                              parentFolderId: _currentFolderId,
                              documentId: document.id,
                            ),
                          );
                    }
                  },
                  itemBuilder: (context) => const [
                    PopupMenuItem(
                        value: 'delete',
                        child: Text('Delete',
                            style: TextStyle(color: ColorPallete.textPrimary))),
                  ],
                  icon: const Icon(Icons.more_vert,
                      color: ColorPallete.textSecondary, size: 20),
                ),
              ],
            ),
            const Spacer(),
            Text(
              document.title,
              style: const TextStyle(
                  color: ColorPallete.textPrimary,
                  fontWeight: FontWeight.w600,
                  fontSize: 14),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            Text(
              'Updated ${DateFormat('MMM d, HH:mm').format(document.updatedAt)}',
              style: TextStyle(
                  color: ColorPallete.textPrimary.withValues(alpha: 0.5), fontSize: 11),
            ),
          ],
        ),
      ),
    );
  }

  void _showCreateMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: ColorPallete.backgroundSecondary,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.create_new_folder_outlined,
                  color: ColorPallete.redPrimary),
              title:
                  const Text('Folder', style: TextStyle(color: ColorPallete.textPrimary)),
              onTap: () {
                context.pop();
                _promptForFolder(this.context);
              },
            ),
            ListTile(
              leading: Icon(Icons.description_outlined,
                  color: ColorPallete.statusColor('pending')),
              title: const Text('Markdown Document',
                  style: TextStyle(color: ColorPallete.textPrimary)),
              onTap: () {
                context.pop();
                _createDocument(this.context);
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _promptForFolder(BuildContext context) async {
    final controller = TextEditingController();
    final created = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: ColorPallete.backgroundSecondary,
        title:
            const Text('Create Folder', style: TextStyle(color: ColorPallete.textPrimary)),
        content: TextField(
          controller: controller,
          style: const TextStyle(color: ColorPallete.textPrimary),
          decoration: const InputDecoration(
            hintText: 'Folder name',
            hintStyle: TextStyle(color: ColorPallete.textDisabled),
          ),
        ),
        actions: [
          TextButton(
              onPressed: () => context.pop(), child: const Text('Cancel')),
          TextButton(
              onPressed: () => Navigator.of(context).pop(controller.text),
              child: const Text('Create')),
        ],
      ),
    );
    if (created == null || created.trim().isEmpty) {
      return;
    }
    if (!mounted) {
      return;
    }
    this.context.read<ResearchWorkspaceBloc>().add(
          CreateWorkspaceFolder(
            researchId: widget.researchId,
            parentFolderId: _currentFolderId,
            name: created.trim(),
          ),
        );
  }

  void _createDocument(BuildContext context) {
    context.push(
      '${MarkdownEditorPage.routePath}/0',
      extra: {
        'researchId': widget.researchId,
        'folderId': _currentFolderId,
        'title': 'Untitled Document',
        'content': '',
      },
    );
  }
}
