class UserVerificationModel {
  final int id;
  final String firstName;
  final String lastName;
  final String phone;
  final String birthDate;
  final String createdAt;
  final String photo;
  final String idPhotoFront;
  final String idPhotoBack;
  final int wallet;

  UserVerificationModel({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.phone,
    required this.birthDate,
    required this.createdAt,
    required this.photo,
    required this.idPhotoFront,
    required this.idPhotoBack,
    required this.wallet,
  });

  /// Computed field (not coming from backend)
  String get fullName => '$firstName $lastName';

  factory UserVerificationModel.fromJson(Map<String, dynamic> json) {
    return UserVerificationModel(
      id: json['id'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      phone: json['phone'],
      birthDate: json['birth_date'],
      createdAt: json['created_at'],
      photo: json['photo'],
      idPhotoFront: json['id_photo_front'],
      idPhotoBack: json['id_photo_back'],
      wallet: json['wallet'],
    );
  }
}
