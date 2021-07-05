class ChangeProfile {
  final String status;
  final String message;

  ChangeProfile({this.status, this.message});

  factory ChangeProfile.fromJson(Map<String, dynamic> json) {
    return ChangeProfile(
      status: json['status'],
      message: json['message'],
    );
  }
}