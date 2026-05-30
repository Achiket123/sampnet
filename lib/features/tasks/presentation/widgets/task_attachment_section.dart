import 'package:flutter/material.dart';
import 'package:hackathon/features/tasks/domain/entities/task_attachment_entity.dart';
import 'package:hackathon/globals/constants/api_end_points.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

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
            style: TextStyle(color: Colors.grey, fontSize: 14),
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
                    const Icon(Icons.attach_file, color: Colors.blue),
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
                            style: const TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.download, color: Colors.blue),
                      onPressed: () async {
                        final url = Uri.parse(ApiConstants.getFileById(attachment.fileId.toString()));
                        if (await canLaunchUrl(url)) {
                          await launchUrl(url, mode: LaunchMode.externalApplication);
                        }
                      },
                    ),
                    if (attachment.uploadedBy == widget.currentUserId)
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
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
              // The logic to trigger file picker and UploadFileBloc is handled in the Page listener
              // This button just signals the intent if needed, or we can make it a specific trigger.
              // For now, we follow the instruction that the page coordinates the two BLoCs.
              // I will use a dummy trigger or just let the page handle it.
              // Actually, I'll add a placeholder or a real trigger if I can.
              // Let's assume the onAddAttachment callback is used after the upload completes.
            },
            icon: const Icon(Icons.upload_file),
            label: const Text("Upload Attachment"),
          ),
      ],
    );
  }
}
