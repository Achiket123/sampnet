import 'package:hackathon/globals/constants/user.dart';

class RegisterCompanyParams {
 
  final String companyName;
  final String companyCode;
  final String primaryContactName;
  final String primaryEmail;
  final String phoneNumber;
  final String officeAddress;
  final String city;
  final String state;
  final String postalCode;
  final String country;
  final String planStatus;
  final int maxEmployees;
  final int companyLogo;
  final String industry;
  final String billingAddress;
  final String companySize;

  RegisterCompanyParams({
    required this.companyName,
    required this.companyCode, 
    required this.primaryContactName,
    required this.primaryEmail,
    required this.phoneNumber,
    required this.officeAddress,
    required this.city,
    required this.state,
    required this.postalCode,
    required this.country,
    required this.planStatus,
    required this.maxEmployees,
    required this.companyLogo,
    required this.industry,
    required this.billingAddress,
    required this.companySize,
  });

  Map<String, dynamic> toJson() {
    return {
      'company_name': companyName,
      'company_code': companyCode,
      'primary_contact_name': primaryContactName,
      'primary_email': primaryEmail,
      'phone_number': phoneNumber,
      'office_address': officeAddress,
      'city': city,
      'state': state,
      'postal_code': postalCode,
      'country': country,
      'plan_status': planStatus,
      'max_employees': maxEmployees,
      'company_logo': companyLogo,
      'industry': industry,
      'billing_address': billingAddress,
      'company_size': companySize,
      'boss_id': User.user.id,
    };
  }
}