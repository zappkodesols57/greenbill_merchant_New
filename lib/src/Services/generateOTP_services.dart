import 'dart:convert';
import 'package:greenbill_merchant/src/models/model_generateOTP.dart';
import 'package:http/http.dart' as http;

class OtpService{
  static Future<GenerateOTP> generateOTP(String num, String signature) async {
    final param = {
      "mobile_no": num,
      "signature": signature,
    };

    final response = await http.post(
      "http://157.230.228.250/generate-otp-merchant-api/",
      body: param,
    );

    GenerateOTP otp;
    var responseJson = json.decode(response.body);
    otp = new GenerateOTP.fromJson(jsonDecode(response.body));
    print(responseJson);

    if (response.statusCode == 200) {
      if(otp.status == "success"){
        print('OTP Send Successfully');
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