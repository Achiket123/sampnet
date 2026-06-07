import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hackathon/features/tasks/domain/entities/task_attachment_entity.dart';
import 'package:hackathon/features/upload_files/domain/use_cases/upload_file_usecase.dart';
import 'package:hackathon/features/upload_files/presentation/bloc/upload_file_bloc.dart';
import 'package:hackathon/globals/constants/api_end_points.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:html' as html;
import 'dart:typed_data';
import 'package:hackathon/globals/constants/color_pallete.dart';

class TaskAttachmentSection extends StatefulWidget {
  final List<TaskAttachmentEntity> attachments;
  final Function(int, String) onAddAttachment;
  final Function(int) onRemoveAttachment;
  final bool isUploading;
  final int currentUserId;

  const TaskAttachmentSection({
    super.key,
    required this.attachments,
    required this.onAddAttachment,
    required this.onRemoveAttachment,
    required this.isUploading,
    required this.currentUserId,
  });

  @override
  State<TaskAttachmentSection> createState() => _TaskAttachmentSectionState();
}

class _TaskAttachmentSectionState extends State<TaskAttachmentSection> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Attachments",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        if (widget.attachments.isEmpty && !widget.isUploading)
          const Text(
            "No attachments yet",
            style: TextStyle(color: ColorPallete.textSecondary, fontSize: 14),
          )
        else
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: widget.attachments.length,
            itemBuilder: (context, index) {
              final attachment = widget.attachments[index];
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: Row(
                  children: [
                    const Icon(Icons.attach_file, color: ColorPallete.redPrimary),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            attachment.fileName,
                            style: const TextStyle(fontWeight: FontWeight.w500),
                          ),
                          Text(
                            "Uploaded by ${attachment.uploaderDisplayName} on ${DateFormat('MMM dd, yyyy').format(attachment.createdAt)}",
                            style: const TextStyle(fontSize: 12, color: ColorPallete.textSecondary),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.download, color: ColorPallete.redPrimary),
                      onPressed: () async {
                        final url = Uri.parse(ApiConstants.getFileById(attachment.fileId.toString()));
                        if (await canLaunchUrl(url)) {
                          await launchUrl(url, mode: LaunchMode.externalApplication);
                        }
                      },
                    ),
                    if (attachment.uploadedBy == widget.currentUserId)
                      IconButton(
                        icon: const Icon(Icons.delete, color: ColorPallete.error),
                        onPressed: () => widget.onRemoveAttachment(attachment.id),
                      ),
                  ],
                ),
              );
            },
          ),
        const SizedBox(height: 10),
        if (widget.isUploading)
          const Center(child: CircularProgressIndicator())
        else
          ElevatedButton.icon(
            onPressed: () {
              html.FileUploadInputElement uploadInput =
                  html.FileUploadInputElement();
              uploadInput.click();

              uploadInput.onChange.listen((e) {
                final files = uploadInput.files;
                if (files != null && files.length == 1) {
                  final file = files[0];
                  html.FileReader reader = html.FileReader();

                  reader.onLoadEnd.listen((e) {
                    if (!mounted) return;
                    final params = UploadFileParams(
                      file: (reader.result as Uint8List),
                      fileType: file.type,
                      fileName: file.name,
                      fileSize: file.size,
                    );

                    context
                        .read<UploadFileBloc>()
                        .add(UploadFileBlocEvent(file: params));
                  });

                  reader.readAsArrayBuffer(file);
                }
              });
            },
            icon: const Icon(Icons.upload_file),
            label: const Text("Upload Attachment"),
          ),
      ],
    );
  }
}
