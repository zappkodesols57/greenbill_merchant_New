class GenerateOTP {
  final String status;
  final String message;

  GenerateOTP({this.status, this.message});

  factory GenerateOTP.fromJson(Map<String, dynamic> json) {
    return GenerateOTP(
      status: json['status'],
      message: json['message'],
    );
  }
}