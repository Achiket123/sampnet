// Dart Model for Organisation
import 'package:flutter/material.dart';

class Organisation {
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
  final int? planId;
  final DateTime? planStartDate;
  final DateTime? planEndDate;
  final String planStatus;
  final int maxEmployees;
  final int? companyLogo;
  final String industry;
  final String billingAddress;
  final String companySize;

  Organisation({
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
    this.planId,
    this.planStartDate,
    this.planEndDate,
    required this.planStatus,
    required this.maxEmployees,
    this.companyLogo,
    required this.industry,
    required this.billingAddress,
    required this.companySize,
  });

  // From JSON
  factory Organisation.fromJson(Map<String, dynamic> json) {
    debugPrint("Desializing Org: $json");
    return Organisation(
      id: json['id'] as int?,
      companyName: (json['company_name'] ?? '') as String,
      companyCode: (json['company_code'] ?? '') as String,
      primaryContactName: (json['primary_contact_name'] ?? '') as String,
      primaryEmail: (json['primary_email'] ?? '') as String,
      phoneNumber: (json['phone_number'] ?? '') as String,
      officeAddress: (json['office_address'] ?? '') as String,
      city: (json['city'] ?? '') as String,
      state: (json['state'] ?? '') as String,
      postalCode: (json['postal_code'] ?? '') as String,
      country: (json['country'] ?? '') as String,
      planId: json['plan_id'] as int?,
      planStartDate: json['plan_start_date'] != null && (json['plan_start_date'] as String).isNotEmpty
          ? DateTime.parse(json['plan_start_date'] as String)
          : null,
      planEndDate: json['plan_end_date'] != null && (json['plan_end_date'] as String).isNotEmpty
          ? DateTime.parse(json['plan_end_date'] as String)
          : null,
      planStatus: (json['plan_status'] ?? '') as String,
      maxEmployees: (json['max_employees'] ?? 0) as int,
      companyLogo: json['company_logo'] as int?,
      industry: (json['industry'] ?? '') as String,
      billingAddress: (json['billing_address'] ?? '') as String,
      companySize: (json['company_size'] ?? '') as String,
    );
  }

  // To JSON
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
      'plan_id': planId,
      'plan_start_date': planStartDate?.toIso8601String(),
      'plan_end_date': planEndDate?.toIso8601String(),
      'plan_status': planStatus,
      'max_employees': maxEmployees,
      'company_logo': companyLogo,
      'industry': industry,
      'billing_address': billingAddress,
      'company_size': companySize,
    };
  }
}
