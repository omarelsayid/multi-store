class VendorUserModel {
  final bool? approved;
  final String? email;
  final String? cityValue;
  final String? stateValue;
  final String? phoneNumber;
  final String? taxNumber;
  final String? taxOption;
  final String? bussinessName;
  final String? storeImage;
  final String? vendorId;

  VendorUserModel({
    required this.approved,
    required this.email,
    required this.cityValue,
    required this.stateValue,
    required this.phoneNumber,
    required this.taxNumber,
    required this.taxOption,
    required this.bussinessName,
    required this.storeImage,
    required this.vendorId,
  });

  VendorUserModel.fromJson(Map<String, dynamic> data)
      : this(
          approved: data['approved']! as bool,
          bussinessName: data['bussinessName']! as String,
          email: data['email']! as String,
          cityValue: data['cityValue']! as String,
          stateValue: data['stateValue']! as String,
          phoneNumber: data['phoneNumber']! as String,
          taxNumber: data['taxNumber']! as String,
          taxOption: data['taxOption']! as String,
          storeImage: data['image']! as String,
          vendorId: data['vendorId']! as String,
        );

  Map<String, dynamic> toJson() {
    return {
      'approved': approved,
      'bussinessName': bussinessName,
      'cityValue': cityValue,
      'stateValue': stateValue,
      'phoneNumber': phoneNumber,
      'emial': email,
      'taxOption': taxOption,
      'taxNumber': taxNumber,
      'storeImage': storeImage,
      'vendorId': vendorId,
    };
  }
}
