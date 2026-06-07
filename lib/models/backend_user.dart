class BackendUser {
  final String id;
  final String fullName;
  final String email;
  final String? phoneNumber;
  final String? location;
  final String? address;
  final String? bloodGroup;
  final String? allergies;
  final String? urgentMedicalNotes;

  const BackendUser({
    required this.id,
    required this.fullName,
    required this.email,
    this.phoneNumber,
    this.location,
    this.address,
    this.bloodGroup,
    this.allergies,
    this.urgentMedicalNotes,
  });

  factory BackendUser.fromJson(Map<String, dynamic> json) {
    return BackendUser(
      id: json['id']?.toString() ?? '',
      fullName: (json['full_name'] ?? json['fullName'] ?? '').toString(),
      email: (json['email'] ?? '').toString(),
      phoneNumber: json['phone_number']?.toString(),
      location: (json['location'] ?? json['address'])?.toString(),
      address: json['address']?.toString(),
      bloodGroup: json['blood_group']?.toString(),
      allergies: json['allergies']?.toString(),
      urgentMedicalNotes: json['urgent_medical_notes']?.toString(),
    );
  }

  BackendUser copyWith({
    String? id,
    String? fullName,
    String? email,
    String? phoneNumber,
    String? location,
    String? address,
    String? bloodGroup,
    String? allergies,
    String? urgentMedicalNotes,
  }) {
    return BackendUser(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      location: location ?? this.location,
      address: address ?? this.address,
      bloodGroup: bloodGroup ?? this.bloodGroup,
      allergies: allergies ?? this.allergies,
      urgentMedicalNotes: urgentMedicalNotes ?? this.urgentMedicalNotes,
    );
  }
}
