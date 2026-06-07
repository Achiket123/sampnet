import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:go_router/go_router.dart';
import 'package:hackathon/globals/constants/strings.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:hackathon/dependency_injection.g.dart';
import 'package:hackathon/services/api_client.dart';
import 'package:hackathon/globals/constants/user.dart';

import '../../../../globals/constants/color_pallete.dart';
import '../blocs/markdown_editor_bloc/markdown_editor_bloc.dart';
import '../../domain/entities/research_file_entity.dart';
import '../../domain/entities/research_reference_entity.dart';

class MarkdownEditorPage extends StatefulWidget {
  static const String routePath = '/research-editor';
  static const String routeName = 'research-editor';

  final int documentId;
  final int researchId;
  final int? folderId;
  final String? initialTitle;
  final String? initialContent;

  const MarkdownEditorPage({
    super.key,
    required this.documentId,
    required this.researchId,
    this.folderId,
    this.initialTitle,
    this.initialContent,
  });

  @override
  State<MarkdownEditorPage> createState() => _MarkdownEditorPageState();
}

enum ArtifactKind { file, link }

enum FileArtifactType { image, pdf, other }

class _MarkdownEditorPageState extends State<MarkdownEditorPage> {
  late final TextEditingController _titleController;
  late final TextEditingController _contentController;
  bool _isPreviewMode = false;
  dynamic _selectedArtifact;

  @override
  void initState() {
    super.initState();
    _titleController =
        TextEditingController(text: widget.initialTitle ?? 'Untitled Document');
    _contentController =
        TextEditingController(text: widget.initialContent ?? '');
    context.read<MarkdownEditorBloc>().add(
          LoadMarkdownDocument(
            documentId: widget.documentId,
            researchId: widget.researchId,
            folderId: widget.folderId,
            initialTitle: widget.initialTitle,
            initialContent: widget.initialContent,
          ),
        );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  void _insertFormatting(String prefix, String suffix) {
    final selection = _contentController.selection;
    if (selection.start < 0 || selection.end < 0) {
      return;
    }
    final selected =
        _contentController.text.substring(selection.start, selection.end);
    final updated = _contentController.text.replaceRange(
        selection.start, selection.end, '$prefix$selected$suffix');
    _contentController.value = TextEditingValue(
      text: updated,
      selection: TextSelection.collapsed(
          offset: selection.start +
              prefix.length +
              selected.length +
              suffix.length),
    );
    _scheduleAutosave();
  }

  void _scheduleAutosave() {
    final state = context.read<MarkdownEditorBloc>().state;
    context.read<MarkdownEditorBloc>().add(
          AutosaveMarkdownDocument(
            documentId: state.documentId,
            researchId: widget.researchId,
            folderId: widget.folderId,
            title: _titleController.text.trim().isEmpty
                ? 'Untitled Document'
                : _titleController.text.trim(),
            content: _contentController.text,
          ),
        );
  }

  Future<void> _pickArtifacts() async {
    final result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      withData: true,
      type: FileType.custom,
      allowedExtensions: const ['pdf', 'png', 'jpg', 'jpeg', 'webp', 'gif'],
    );
    if (result == null || !mounted) {
      return;
    }

    final state = context.read<MarkdownEditorBloc>().state;
    if (state.documentId == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please save the document first')));
      return;
    }

    for (final file in result.files) {
      if (file.bytes != null) {
        context.read<MarkdownEditorBloc>().add(
              UploadEditorFile(
                researchId: widget.researchId,
                documentId: state.documentId,
                fileName: file.name,
                bytes: file.bytes!,
                mimeType: _resolveMimeType(file.extension),
              ),
            );
      }
    }
  }

  String _resolveMimeType(String? extension) {
    final ext = (extension ?? '').toLowerCase();
    switch (ext) {
      case 'pdf':
        return 'application/pdf';
      case 'png':
        return 'image/png';
      case 'jpg':
      case 'jpeg':
        return 'image/jpeg';
      case 'gif':
        return 'image/gif';
      case 'webp':
        return 'image/webp';
      default:
        return 'application/octet-stream';
    }
  }

  FileArtifactType _resolveFileType(String? extension) {
    final normalized = (extension ?? '').toLowerCase();
    if (normalized == 'pdf') {
      return FileArtifactType.pdf;
    }
    if (const ['png', 'jpg', 'jpeg', 'webp', 'gif'].contains(normalized)) {
      return FileArtifactType.image;
    }
    return FileArtifactType.other;
  }

  Future<void> _promptForLink() async {
    final labelController = TextEditingController();
    final urlController = TextEditingController();

    final result = await showDialog<Map<String, String>>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: ColorPallete.backgroundSecondary,
        title: const Text('Add Link', style: TextStyle(color: ColorPallete.textPrimary)),
        content: SizedBox(
          width: 420,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: labelController,
                style: const TextStyle(color: ColorPallete.textPrimary),
                decoration: InputDecoration(
                  labelText: 'Label',
                  labelStyle: TextStyle(color: ColorPallete.textPrimary.withOpacity(0.60)),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: urlController,
                style: const TextStyle(color: ColorPallete.textPrimary),
                decoration: InputDecoration(
                  labelText: 'URL',
                  labelStyle: TextStyle(color: ColorPallete.textPrimary.withOpacity(0.60)),
                  hintText: 'https://example.com',
                  hintStyle: TextStyle(color: ColorPallete.textDisabled),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final url = urlController.text.trim();
              if (url.isEmpty) {
                return;
              }
              Navigator.of(context).pop({
                'label': labelController.text.trim().isEmpty
                    ? url
                    : labelController.text.trim(),
                'url': url,
              });
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );

    if (result == null || !mounted) {
      return;
    }

    final state = context.read<MarkdownEditorBloc>().state;
    context.read<MarkdownEditorBloc>().add(
          AddEditorReference(
            researchId: widget.researchId,
            documentId: state.documentId,
            title: result['label']!,
            url: result['url']!,
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MarkdownEditorBloc, MarkdownEditorState>(
      listener: (context, state) {
        if (state.errorMessage != null && state.errorMessage!.isNotEmpty) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(state.errorMessage!)));
        }
        if (state.title != _titleController.text) {
          _titleController.text = state.title;
        }
        if (state.content != _contentController.text) {
          _contentController.text = state.content;
        }
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: ColorPallete.backgroundPrimary,
          appBar: AppBar(
            backgroundColor: ColorPallete.backgroundSecondary,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: ColorPallete.textPrimary),
              onPressed: () => context.pop(),
            ),
            title: TextField(
              controller: _titleController,
              onChanged: (_) => _scheduleAutosave(),
              style: const TextStyle(
                  color: ColorPallete.textPrimary,
                  fontSize: 16,
                  fontWeight: FontWeight.bold),
              decoration: const InputDecoration(border: InputBorder.none),
            ),
            actions: [
              IconButton(
                icon: Icon(
                    _isPreviewMode
                        ? Icons.edit_outlined
                        : Icons.visibility_outlined,
                    color: ColorPallete.textPrimary),
                onPressed: () =>
                    setState(() => _isPreviewMode = !_isPreviewMode),
              ),
              IconButton(
                icon: state.isSaving
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                            strokeWidth: 2, color: ColorPallete.textPrimary),
                      )
                    : const Icon(Icons.save_outlined, color: ColorPallete.textPrimary),
                onPressed: () {
                  context.read<MarkdownEditorBloc>().add(
                        SaveMarkdownDocument(
                          documentId: state.documentId,
                          researchId: widget.researchId,
                          folderId: widget.folderId,
                          title: _titleController.text.trim().isEmpty
                              ? 'Untitled Document'
                              : _titleController.text.trim(),
                          content: _contentController.text,
                        ),
                      );
                },
              ),
            ],
          ),
          body: state.isLoading
              ? const Center(child: CircularProgressIndicator())
              : Column(
                  children: [
                    if (!_isPreviewMode) _buildToolbar(),
                    Expanded(
                      child: Row(
                        children: [
                          Expanded(
                            flex: 5,
                            child: _isPreviewMode
                                ? _buildPreview()
                                : _buildEditor(),
                          ),
                          Container(width: 1, color: ColorPallete.divider),
                          SizedBox(
                            width: 380,
                            child: _buildArtifactsPanel(state),
                          ),
                        ],
                      ),
                    ),
                    _buildStatusBar(state),
                  ],
                ),
        );
      },
    );
  }

  Widget _buildToolbar() {
    return Container(
      decoration: const BoxDecoration(
        color: ColorPallete.backgroundSecondary,
        border: Border(bottom: BorderSide(color: ColorPallete.divider)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            _toolbarButton(Icons.title, () => _insertFormatting('# ', '')),
            _toolbarButton(
                Icons.format_bold, () => _insertFormatting('**', '**')),
            _toolbarButton(
                Icons.format_italic, () => _insertFormatting('*', '*')),
            _toolbarButton(Icons.code, () => _insertFormatting('`', '`')),
            _toolbarButton(Icons.link, () => _insertFormatting('[', '](url)')),
            _toolbarButton(
                Icons.format_quote, () => _insertFormatting('> ', '')),
            _toolbarButton(Icons.list, () => _insertFormatting('- ', '')),
          ],
        ),
      ),
    );
  }

  Widget _toolbarButton(IconData icon, VoidCallback onPressed) {
    return IconButton(
      onPressed: onPressed,
      icon: Icon(icon, color: ColorPallete.textPrimary.withOpacity(0.60), size: 20),
      constraints: const BoxConstraints(minWidth: 40, minHeight: 40),
      splashRadius: 20,
    );
  }

  Widget _buildEditor() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: TextField(
        controller: _contentController,
        onChanged: (_) => _scheduleAutosave(),
        style: const TextStyle(
          color: ColorPallete.textPrimary,
          fontSize: 16,
          height: 1.5,
          fontFamily: 'monospace',
        ),
        maxLines: null,
        expands: true,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: 'Start writing your research notes here...',
          hintStyle: TextStyle(color: ColorPallete.textPrimary.withOpacity(0.24)),
        ),
      ),
    );
  }

  Widget _buildPreview() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      child: Markdown(
        data: _contentController.text.isEmpty
            ? 'Nothing to preview yet.'
            : _contentController.text,
        selectable: true,
        styleSheet: MarkdownStyleSheet(
          p: const TextStyle(color: ColorPallete.textSecondary, fontSize: 16, height: 1.6),
          h1: const TextStyle(
              color: ColorPallete.textPrimary, fontSize: 24, fontWeight: FontWeight.bold),
          code: const TextStyle(
              backgroundColor: ColorPallete.divider, fontFamily: 'monospace'),
        ),
      ),
    );
  }

  Widget _buildArtifactsPanel(MarkdownEditorState state) {
    return Container(
      color: const Color(0xFF111218),
      child: Column(
        children: [
          _buildArtifactsHeader(),
          Expanded(
            child: Row(
              children: [
                SizedBox(
                  width: 150,
                  child: _buildArtifactsSidebar(state),
                ),
                Container(width: 1, color: ColorPallete.divider),
                Expanded(
                  child: _buildArtifactPreview(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildArtifactsHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: ColorPallete.backgroundSecondary,
        border: Border(bottom: BorderSide(color: ColorPallete.divider)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Artifacts',
            style: TextStyle(
                color: ColorPallete.textPrimary, fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: _pickArtifacts,
                  icon: const Icon(Icons.attach_file, size: 16),
                  label: const Text('Add File'),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: _promptForLink,
                  icon: const Icon(Icons.link, size: 16),
                  label: const Text('Add Link'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildArtifactsSidebar(MarkdownEditorState state) {
    return ListView(
      padding: const EdgeInsets.all(12),
      children: [
        _buildArtifactSectionTitle('Files'),
        if (state.files.isEmpty)
          _buildSectionPlaceholder('Upload PDFs or images'),
        ...state.files.map(_buildFileTile),
        const SizedBox(height: 16),
        _buildArtifactSectionTitle('Links'),
        if (state.references.isEmpty)
          _buildSectionPlaceholder('Save URLs for this note'),
        ...state.references.map(_buildLinkTile),
      ],
    );
  }

  Widget _buildArtifactSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        title,
        style:  TextStyle(
          color: ColorPallete.textPrimary.withOpacity(0.60),
          fontSize: 12,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.6,
        ),
      ),
    );
  }

  Widget _buildSectionPlaceholder(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        text,
        style: TextStyle(color: ColorPallete.textSecondary, fontSize: 12),
      ),
    );
  }

  Widget _buildFileTile(ResearchFileEntity artifact) {
    final isSelected = _selectedArtifact is ResearchFileEntity &&
        (_selectedArtifact as ResearchFileEntity).id == artifact.id;
    return _buildTile(
      label: artifact.fileName,
      icon: _fileIcon(artifact.mimeType),
      color: _fileColor(artifact.mimeType),
      isSelected: isSelected,
      onTap: () => setState(() => _selectedArtifact = artifact),
    );
  }

  Widget _buildLinkTile(ResearchReferenceEntity artifact) {
    final isSelected = _selectedArtifact is ResearchReferenceEntity &&
        (_selectedArtifact as ResearchReferenceEntity).id == artifact.id;
    return _buildTile(
      label: artifact.title,
      icon: Icons.link,
      color: ColorPallete.textSecondary,
      isSelected: isSelected,
      onTap: () => setState(() => _selectedArtifact = artifact),
    );
  }

  Widget _buildTile({
    required String label,
    required IconData icon,
    required Color color,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: isSelected
                ? ColorPallete.redPrimary.withValues(alpha: 0.18)
                : ColorPallete.textPrimary.withValues(alpha: 0.04),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected ? ColorPallete.redPrimary : ColorPallete.divider,
            ),
          ),
          child: Row(
            children: [
              Icon(icon, color: color, size: 18),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  label,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: ColorPallete.textSecondary, fontSize: 12),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildArtifactPreview() {
    final artifact = _selectedArtifact;
    if (artifact == null) {
      return const Center(
        child: Text(
          'Select an artifact to preview it here.',
          style: TextStyle(color: ColorPallete.textDisabled),
          textAlign: TextAlign.center,
        ),
      );
    }

    if (artifact is ResearchReferenceEntity) {
      return _buildLinkPreview(artifact);
    }
    return _buildFilePreview(artifact as ResearchFileEntity);
  }

  Widget _buildLinkPreview(ResearchReferenceEntity artifact) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Link',
            style: TextStyle(
                color: ColorPallete.textPrimary, fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          Text(
            artifact.title,
            style: const TextStyle(
                color: ColorPallete.textSecondary,
                fontSize: 14,
                fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          SelectableText(
            artifact.url ?? '',
            style: const TextStyle(color: ColorPallete.textSecondary, fontSize: 13),
          ),
          const SizedBox(height: 16),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: ColorPallete.textPrimary.withValues(alpha: 0.04),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: ColorPallete.divider),
            ),
            child: Text(
              'Link artifacts are kept separate from uploaded files. Use the button below to open the URL when needed.',
              style: TextStyle(color: ColorPallete.textPrimary.withOpacity(0.60), height: 1.5),
            ),
          ),
          const SizedBox(height: 16),
          OutlinedButton.icon(
            onPressed: () => _openLink(artifact.url),
            icon: const Icon(Icons.open_in_new),
            label: const Text('Open Link'),
          ),
        ],
      ),
    );
  }

  Future<void> _openLink(String? rawUrl) async {
    if (rawUrl == null || rawUrl.isEmpty) {
      return;
    }
    final prefixed =
        rawUrl.startsWith('http://') || rawUrl.startsWith('https://')
            ? rawUrl
            : 'https://$rawUrl';
    final uri = Uri.tryParse(prefixed);
    if (uri == null) {
      return;
    }
    await launchUrl(uri, mode: LaunchMode.platformDefault);
  }

  Widget _buildFilePreview(ResearchFileEntity artifact) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            artifact.fileName,
            style: const TextStyle(
                color: ColorPallete.textPrimary, fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 6),
          Text(
            _buildFileMeta(artifact),
            style: const TextStyle(color: ColorPallete.textDisabled, fontSize: 12),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: ColorPallete.textPrimary.withValues(alpha: 0.03),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: ColorPallete.divider),
              ),
              clipBehavior: Clip.antiAlias,
              child: _buildFilePreviewBody(artifact),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilePreviewBody(ResearchFileEntity artifact) {
    final downloadUrl =
        '${getIt<ApiClient>().baseUrl}/research/files/${artifact.id}/download';
    final empToken = getIt<User>().employeeToken;
    final token = empToken ?? Hive.box(Strings.authBox).get(Strings.tokenKey);
    debugPrint("TOKEN:: $token");
    if (artifact.mimeType.startsWith('image/')) {
      return InteractiveViewer(
        maxScale: 4,
        child: Center(
          child: Image.network(
            downloadUrl,
            fit: BoxFit.contain,
            headers: {
              'Authorization': 'Bearer $token', // Correct headers are needed
            },
          ),
        ),
      );
    }

    if (artifact.mimeType == 'application/pdf') {
      return SfPdfViewer.network(
        downloadUrl,
        headers: {
          'Authorization': 'Bearer ${getIt<User>().token}',
        },
        pageLayoutMode: PdfPageLayoutMode.single,
        canShowScrollHead: true,
        canShowPaginationDialog: true,
      );
    }

    return const Center(
      child: Text(
        'Preview is only enabled for PDFs and images right now.',
        style: TextStyle(color: ColorPallete.textDisabled),
        textAlign: TextAlign.center,
      ),
    );
  }

  String _buildFileMeta(ResearchFileEntity artifact) {
    final pieces = <String>[];
    final ext = artifact.fileName.split('.').last;
    pieces.add(ext.toUpperCase());
    pieces.add(_humanSize(artifact.size));
    return pieces.join(' • ');
  }

  String _humanSize(int bytes) {
    if (bytes < 1024) {
      return '$bytes B';
    }
    if (bytes < 1024 * 1024) {
      return '${(bytes / 1024).toStringAsFixed(1)} KB';
    }
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }

  IconData _fileIcon(String mimeType) {
    if (mimeType == 'application/pdf') {
      return Icons.picture_as_pdf_outlined;
    }
    if (mimeType.startsWith('image/')) {
      return Icons.image_outlined;
    }
    return Icons.insert_drive_file_outlined;
  }

  Color _fileColor(String mimeType) {
    if (mimeType == 'application/pdf') {
      return ColorPallete.error;
    }
    if (mimeType.startsWith('image/')) {
      return ColorPallete.statusColor('approved');
    }
    return ColorPallete.textSecondary;
  }

  Widget _buildStatusBar(MarkdownEditorState state) {
    final words = _contentController.text.trim().isEmpty
        ? 0
        : _contentController.text.trim().split(RegExp(r'\s+')).length;
    return Container(
      color: ColorPallete.backgroundSecondary,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '$words words | ${_contentController.text.length} chars',
            style: const TextStyle(color: ColorPallete.textDisabled, fontSize: 12),
          ),
          Text(
            state.isSaving ? 'Saving...' : (state.saveMessage ?? 'Ready'),
            style: const TextStyle(color: ColorPallete.textDisabled, fontSize: 12),
          ),
        ],
      ),
    );
  }
}
