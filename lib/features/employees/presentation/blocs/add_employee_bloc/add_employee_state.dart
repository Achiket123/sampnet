import 'package:equatable/equatable.dart';

enum AddEmployeeStatus { idle, submitting, submitted, error }

class AddEmployeeState extends Equatable {
  final String firstName;
  final String lastName;
  final String email;
  final String phoneNumber;
  final String employmentId;
  final AddEmployeeStatus status;
  final String? failureMessage;
  
  final String? firstNameError;
  final String? lastNameError;
  final String? emailError;
  final String? phoneError;
  final String? employmentIdError;

  const AddEmployeeState({
    this.firstName = '',
    this.lastName = '',
    this.email = '',
    this.phoneNumber = '',
    this.employmentId = '',
    this.status = AddEmployeeStatus.idle,
    this.failureMessage,
    this.firstNameError,
    this.lastNameError,
    this.emailError,
    this.phoneError,
    this.employmentIdError,
  });

  bool get isFormValid {
    return firstName.isNotEmpty &&
        lastName.isNotEmpty &&
        email.isNotEmpty &&
        RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
            .hasMatch(email) &&
        phoneNumber.isNotEmpty &&
        employmentId.isNotEmpty;
  }

  AddEmployeeState copyWith({
    String? firstName,
    String? lastName,
    String? email,
    String? phoneNumber,
    String? employmentId,
    AddEmployeeStatus? status,
    String? failureMessage,
    String? firstNameError,
    String? lastNameError,
    String? emailError,
    String? phoneError,
    String? employmentIdError,
  }) {
    return AddEmployeeState(
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      employmentId: employmentId ?? this.employmentId,
      status: status ?? this.status,
      failureMessage: failureMessage ?? this.failureMessage,
      firstNameError: firstNameError ?? this.firstNameError,
      lastNameError: lastNameError ?? this.lastNameError,
      emailError: emailError ?? this.emailError,
      phoneError: phoneError ?? this.phoneError,
      employmentIdError: employmentIdError ?? this.employmentIdError,
    );
  }

  @override
  List<Object?> get props => [
        firstName,
        lastName,
        email,
        phoneNumber,
        employmentId,
        status,
        failureMessage,
        firstNameError,
        lastNameError,
        emailError,
        phoneError,
        employmentIdError,
      ];
}
