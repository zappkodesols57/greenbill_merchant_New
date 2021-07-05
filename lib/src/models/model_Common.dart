class CommonData {
  final String status;
  final String message;

  CommonData({this.status, this.message});

  factory CommonData.fromJson(Map<String, dynamic> json) {
    return CommonData(
      status: json['status'],
      message: json['message'],
    );
  }
}