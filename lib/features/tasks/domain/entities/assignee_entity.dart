import 'package:equatable/equatable.dart';

class AssigneeEntity extends Equatable{
  final int id;
  final String? firstName;
  final String? lastName;

  const AssigneeEntity(
      {required this.id, required this.firstName, required this.lastName});

  @override
  // TODO: implement props
  List<Object?> get props => [id, firstName, lastName];
}
