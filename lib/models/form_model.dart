import 'dart:io';

class FormModel {
  final File? photo;
  final int? severityScale;
  final String description;
  final double? latitude;
  final double? longitude;
  final String? address;
  final DateTime reportDate;

  FormModel({
    this.photo,
    this.severityScale,
    required this.description,
    this.latitude,
    this.longitude,
    this.address,
    DateTime? reportDate,
  }) : reportDate = reportDate ?? DateTime.now();
}