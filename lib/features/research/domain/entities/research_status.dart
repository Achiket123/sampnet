import 'package:flutter/material.dart';

enum ResearchStatus {
  draft,
  inProgress,
  review,
  published,
}

extension ResearchStatusX on ResearchStatus {
  String get value {
    switch (this) {
      case ResearchStatus.draft:
        return 'draft';
      case ResearchStatus.inProgress:
        return 'in_progress';
      case ResearchStatus.review:
        return 'review';
      case ResearchStatus.published:
        return 'published';
    }
  }

  static ResearchStatus fromString(String status) {
    switch (status) {
      case 'draft':
        return ResearchStatus.draft;
      case 'in_progress':
        return ResearchStatus.inProgress;
      case 'review':
        return ResearchStatus.review;
      case 'published':
        return ResearchStatus.published;
      default:
        return ResearchStatus.draft;
    }
  }

  Color get color {
    switch (this) {
      case ResearchStatus.draft:
        return Colors.grey;
      case ResearchStatus.inProgress:
        return Colors.blue;
      case ResearchStatus.review:
        return Colors.orange;
      case ResearchStatus.published:
        return Colors.green;
    }
  }

  String get label {
    switch (this) {
      case ResearchStatus.draft:
        return 'Draft';
      case ResearchStatus.inProgress:
        return 'In Progress';
      case ResearchStatus.review:
        return 'Review';
      case ResearchStatus.published:
        return 'Published';
    }
  }
}
