mixin Strings {
  static const String appName = 'Hackathon';
  static const String user = 'user';
  static const String email = 'email';
  static const String password = 'password';
  static const String name = 'name';
  static const String phone = 'phone';
  static const String address = 'address';
  static const String city = 'city';
  static const String state = 'state';
  static const String zip = 'zip';
  static const String country = 'country';
  static const String profilePicture = 'profilePicture';
  static const String role = 'role';
  static const String createdAt = 'createdAt';
  static const String updatedAt = 'updatedAt';
  static const String id = 'id';
  static const String authBox = 'auth';
  static const String tokenKey = 'token';
  static const String employeeTokenKey = 'employeeToken';
  static const String smallCompany = 'small';
  static const String mediumCompany = 'medium';
  static const String largeCompany = 'large';
  static const String organisationKey = 'organisation';

  static const List<String> companySize = [
    smallCompany,
    mediumCompany,
    largeCompany
  ];
}
enum CompanySize {
  small,
  medium,
  large,
}
