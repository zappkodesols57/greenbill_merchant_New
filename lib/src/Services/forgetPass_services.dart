import 'dart:convert';
import 'package:greenbill_merchant/src/models/model_forgetPass.dart';
import 'package:http/http.dart' as http;

class  ForgetPassServices{
  static Future<ForgetPass> forgetPassMethod(String num, String signCode) async {
    final param = {
      "mobile_no": num,
      "signature": signCode,
    };

    final response = await http.post(
      "http://157.230.228.250/generate-otp-forgot-password-merchant-api/",
      body: param,
    );

    ForgetPass forgetPass;
    var responseJson = json.decode(response.body);
    forgetPass = new ForgetPass.fromJson(jsonDecode(response.body));
    print(responseJson);

    if (response.statusCode == 200) {
      if(forgetPass.status == "success"){
        print('OTP Generated Successfully');
        return forgetPass;
      } else{
        print('Error in Generating OTP');
        return forgetPass;
      }
    } else {
      print('Error in Generating OTP');
      return forgetPass;
    }
  }
}