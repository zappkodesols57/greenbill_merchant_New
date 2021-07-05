class ValidateOTP {
  final String status;
  final String message;

  ValidateOTP({this.status, this.message});

  factory ValidateOTP.fromJson(Map<String, dynamic> json) {
    return ValidateOTP(
      status: json['status'],
      message: json['message'],
    );
  }
}