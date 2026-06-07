import 'package:flutter/material.dart';
import 'package:hackathon/features/tasks/domain/entities/task_comment_entity.dart';
import 'package:intl/intl.dart';
import 'package:hackathon/globals/constants/color_pallete.dart';

class TaskCommentSection extends StatefulWidget {
  final List<TaskCommentEntity> comments;
  final Function(String) onAddComment;
  final Function(int) onDeleteComment;
  final bool isSubmitting;
  final int currentUserId;

  const TaskCommentSection({
    super.key,
    required this.comments,
    required this.onAddComment,
    required this.onDeleteComment,
    required this.isSubmitting,
    required this.currentUserId,
  });

  @override
  State<TaskCommentSection> createState() => _TaskCommentSectionState();
}

class _TaskCommentSectionState extends State<TaskCommentSection> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Comments",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: widget.comments.length,
          itemBuilder: (context, index) {
            final comment = widget.comments[index];
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    child: Text(comment.userFirstName.isNotEmpty
                        ? comment.userFirstName[0]
                        : "?"),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              comment.displayName,
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(
                              DateFormat('MMM dd, hh:mm a')
                                  .format(comment.createdAt),
                              style: const TextStyle(
                                  fontSize: 12, color: ColorPallete.textSecondary),
                            ),
                          ],
                        ),
                        const SizedBox(height: 5),
                        Text(comment.content),
                      ],
                    ),
                  ),
                  if (comment.userId == widget.currentUserId)
                    IconButton(
                      icon:
                          const Icon(Icons.delete, color: ColorPallete.error, size: 20),
                      onPressed: () => widget.onDeleteComment(comment.id),
                    ),
                ],
              ),
            );
          },
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: _controller,
                style: TextStyle(color: ColorPallete.textPrimary),
                decoration: const InputDecoration(
                  hintText: "Add a comment...",
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            const SizedBox(width: 10),
            widget.isSubmitting
                ? const CircularProgressIndicator()
                : IconButton(
                    icon: const Icon(Icons.send),
                    onPressed: () {
                      if (_controller.text.isNotEmpty) {
                        widget.onAddComment(_controller.text);
                        _controller.clear();
                      }
                    },
                  ),
          ],
        ),
      ],
    );
  }
}
