class AddEmployeeRequestModel {
  final int employmentId;
  final String firstName;
  final String lastName;
  final String email;
  final String phoneNumber;

  const AddEmployeeRequestModel({
    required this.employmentId,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phoneNumber,
  });

  Map<String, dynamic> toJson() {
    return {
      'employment_id': employmentId,
      'first_name': firstName,
      'last_name': lastName,
      'email': email,
      'phone_number': phoneNumber,
    };
  }
}
