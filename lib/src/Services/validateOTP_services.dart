import 'dart:convert';
import 'package:greenbill_merchant/src/models/model_validateOTP.dart';
import 'package:http/http.dart' as http;

class ValidateService{
  static Future<ValidateOTP> otpValidate(String otpNumber, String mob) async {
    final param = {
      "otp": otpNumber,
      "mobile_no": mob,
    };

    final response = await http.post(
      "http://157.230.228.250/otp-validate-merchant-api/",
      body: param,
    );

    ValidateOTP otp;
    var responseJson = json.decode(response.body);
    otp = new ValidateOTP.fromJson(jsonDecode(response.body));
    print(responseJson);

    if (response.statusCode == 200) {
      if(otp.status == "success"){
        print('OTP Validated');
        return otp;
      } else{
        print(otp.message);
        return otp;
      }
    } else {
      print(otp.message);
      return otp;
    }
  }
}