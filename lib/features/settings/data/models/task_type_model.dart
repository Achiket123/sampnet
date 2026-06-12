import 'package:hackathon/features/settings/domain/entities/task_type_entity.dart';

class TaskTypeConfigModel extends TaskTypeConfig {
  TaskTypeConfigModel({
    super.id,
    required super.name,
    required super.description,
  });

  factory TaskTypeConfigModel.fromJson(Map<String, dynamic> json) {
    return TaskTypeConfigModel(
      id: json['id'] as int?,
      name: json['name'] as String? ?? '',
      description: json['description'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
    };
  }
}
