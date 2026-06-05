class SearchResultItem {
  final int id;
  final String type;
  final String title;
  final String subtitle;
  final int organisationId;
  final Map<String, dynamic>? extraData;

  const SearchResultItem({
    required this.id,
    required this.type,
    required this.title,
    required this.subtitle,
    required this.organisationId,
    this.extraData,
  });

  factory SearchResultItem.fromJson(Map<String, dynamic> json) {
    return SearchResultItem(
      id: (json['id'] as num).toInt(),
      type: json['type'] as String? ?? '',
      title: json['title'] as String? ?? '',
      subtitle: json['subtitle'] as String? ?? '',
      organisationId: (json['organisation_id'] as num? ?? 0).toInt(),
      extraData: json['extra_data'] != null
          ? Map<String, dynamic>.from(json['extra_data'] as Map)
          : null,
    );
  }
}

class SearchResults {
  final String query;
  final int totalCount;
  final List<SearchResultItem> items;
  final int taskCount;
  final int projectCount;
  final int teamCount;
  final int employeeCount;
  final int chatCount;

  const SearchResults({
    required this.query,
    required this.totalCount,
    required this.items,
    required this.taskCount,
    required this.projectCount,
    required this.teamCount,
    required this.employeeCount,
    required this.chatCount,
  });

  factory SearchResults.fromJson(Map<String, dynamic> json) {
    final rawItems = json['items'] as List<dynamic>? ?? [];
    return SearchResults(
      query: json['query'] as String? ?? '',
      totalCount: (json['total_count'] as num? ?? 0).toInt(),
      items: rawItems
          .map((e) => SearchResultItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      taskCount: (json['task_count'] as num? ?? 0).toInt(),
      projectCount: (json['project_count'] as num? ?? 0).toInt(),
      teamCount: (json['team_count'] as num? ?? 0).toInt(),
      employeeCount: (json['employee_count'] as num? ?? 0).toInt(),
      chatCount: (json['chat_count'] as num? ?? 0).toInt(),
    );
  }

  factory SearchResults.empty() {
    return const SearchResults(
      query: '',
      totalCount: 0,
      items: [],
      taskCount: 0,
      projectCount: 0,
      teamCount: 0,
      employeeCount: 0,
      chatCount: 0,
    );
  }
}
