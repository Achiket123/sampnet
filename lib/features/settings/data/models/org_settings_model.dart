import 'package:hackathon/features/settings/domain/entities/org_settings_entity.dart';

class OrgSettingsModel extends OrgSettings {
  OrgSettingsModel({
    super.id,
    required super.companyName,
    required super.companyCode,
    required super.primaryContactName,
    required super.primaryEmail,
    required super.phoneNumber,
    required super.officeAddress,
    required super.city,
    required super.state,
    required super.postalCode,
    required super.country,
    super.companyLogo,
    required super.industry,
    required super.billingAddress,
    required super.companySize,
  });

  factory OrgSettingsModel.fromJson(Map<String, dynamic> json) {
    return OrgSettingsModel(
      id: json['id'] as int?,
      companyName: json['company_name'] as String? ?? '',
      companyCode: json['company_code'] as String? ?? '',
      primaryContactName: json['primary_contact_name'] as String? ?? '',
      primaryEmail: json['primary_email'] as String? ?? '',
      phoneNumber: json['phone_number'] as String? ?? '',
      officeAddress: json['office_address'] as String? ?? '',
      city: json['city'] as String? ?? '',
      state: json['state'] as String? ?? '',
      postalCode: json['postal_code'] as String? ?? '',
      country: json['country'] as String? ?? '',
      companyLogo: json['company_logo'] as int?,
      industry: json['industry'] as String? ?? '',
      billingAddress: json['billing_address'] as String? ?? '',
      companySize: json['company_size'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
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
      'company_logo': companyLogo,
      'industry': industry,
      'billing_address': billingAddress,
      'company_size': companySize,
    };
  }
}
