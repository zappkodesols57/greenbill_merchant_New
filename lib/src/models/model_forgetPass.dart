class ForgetPass {
  final String status;

  ForgetPass({this.status});

  factory ForgetPass.fromJson(Map<String, dynamic> json) {
    return ForgetPass(
      status: json['status'],
    );
  }
}