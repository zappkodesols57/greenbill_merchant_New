class SignupData {
  final String status;
  final String message;

  SignupData({this.status, this.message});

  factory SignupData.fromJson(Map<String, dynamic> json) {
    return SignupData(
        status: json['status'],
        message: json['message'],
    );
  }
}