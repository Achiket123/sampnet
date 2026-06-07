import 'package:flutter/material.dart';
import 'package:hackathon/globals/constants/color_pallete.dart';

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
        return ColorPallete.textSecondary;
      case ResearchStatus.inProgress:
        return ColorPallete.redPrimary;
      case ResearchStatus.review:
        return ColorPallete.statusColor('pending');
      case ResearchStatus.published:
        return ColorPallete.statusColor('approved');
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
