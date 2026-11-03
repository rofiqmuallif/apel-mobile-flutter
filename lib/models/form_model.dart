import 'dart:io';

class FormModel {
  final File? photo;
  final int? severityScale;      // 1-5
  final String description;
  final double? latitude;
  final double? longitude;
  final String? address;

  FormModel({
    this.photo,
    this.severityScale,
    required this.description,
    this.latitude,
    this.longitude,
    this.address,
  });
}