import 'package:equatable/equatable.dart';

class ProjectEntity extends Equatable {
  final int id;
  final String name;
  final String description;
  const ProjectEntity({required this.id, required this.name,required this.description});

  @override
  List<Object?> get props => [id, name];
}
