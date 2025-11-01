class SignUpParams {
  final String email;
  final String firstName;
  final String lastName;
  final String phoneNumber;
  final String hashedPassword;
  final int profilePic;
  final String city;
  final String country;
  final DateTime dateOfBirth;

  SignUpParams({
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.phoneNumber,
    required this.hashedPassword,
    required this.profilePic,
    required this.city,
    required this.country,
    required this.dateOfBirth,
  });

  Map<String, String> toJson() {
    return {
      "email": email,
      "password": hashedPassword,
      "first_name": firstName,
      "last_name": lastName,
      "phone_number": phoneNumber,
      "profile_pic": profilePic.toString(),
      "city": city,
      "country": country,
      "date_of_birth": dateOfBirth.toIso8601String(),
    };
  }
}

class SignInParams {
  final String email;
  final String hashedPassword;

  SignInParams({required this.email, required this.hashedPassword});
}
