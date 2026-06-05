import 'package:hackathon/features/tasks/domain/entities/assignee_entity.dart';

class AssigneeModel extends AssigneeEntity {
  const AssigneeModel(
      {required super.id, required super.firstName, required super.lastName});
  factory AssigneeModel.fromJson(Map<String, dynamic> json) {
    return AssigneeModel(
        id: json['id'] as int,
        firstName: json['first_name'] as String,
        lastName: json['last_name'] as String);
  }
}
