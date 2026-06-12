class NotificationPreferenceEntry {
  final String category;
  final bool email;
  final bool push;
  final bool inApp;

  NotificationPreferenceEntry({
    required this.category,
    required this.email,
    required this.push,
    required this.inApp,
  });

  NotificationPreferenceEntry copyWith({
    String? category,
    bool? email,
    bool? push,
    bool? inApp,
  }) {
    return NotificationPreferenceEntry(
      category: category ?? this.category,
      email: email ?? this.email,
      push: push ?? this.push,
      inApp: inApp ?? this.inApp,
    );
  }
}
