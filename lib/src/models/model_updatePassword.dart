class UpdatePassword {
  final String status;
  final String message;

  UpdatePassword({this.status, this.message});

  factory UpdatePassword.fromJson(Map<String, dynamic> json) {
    return UpdatePassword(
      status: json['status'],
      message: json['message']
    );
  }
}