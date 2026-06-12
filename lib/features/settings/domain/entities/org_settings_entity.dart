class OrgSettings {
  final int? id;
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
  final int? companyLogo;
  final String industry;
  final String billingAddress;
  final String companySize;

  OrgSettings({
    this.id,
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
    this.companyLogo,
    required this.industry,
    required this.billingAddress,
    required this.companySize,
  });
}
