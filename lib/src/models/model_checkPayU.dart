
import 'dart:convert';

checkPayU checkPayUFromJson(String str) => checkPayU.fromJson(json.decode(str));

String checkPayUToJson(checkPayU data) => json.encode(data.toJson());

class checkPayU {
  String status;
  String payuKey;
  String payuSalt;

  checkPayU({this.status, this.payuKey, this.payuSalt});

  checkPayU.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    payuKey = json['payu_key'];
    payuSalt = json['payu_salt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['payu_key'] = this.payuKey;
    data['payu_salt'] = this.payuSalt;
    return data;
  }
}
