import 'dart:convert';
import 'package:greenbill_merchant/src/models/model_History.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';
class HistoryPayment{
  static Future<PaymentHistory> getHistory(String id) async {
    String token;

    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString("token");
    final param = {
      "merchant_business_id": id,
    };
    final response = await http.post(
      "http://157.230.228.250/merchant-get-payment-history-api/",
      body: param,
      headers: {HttpHeaders.authorizationHeader: "Token $token"},
    );

    PaymentHistory history;
    var responseJson = json.decode(response.body);
    history = new PaymentHistory.fromJson(jsonDecode(response.body));
    print(responseJson);

    if (response.statusCode == 200) {
      if(history.status == "success"){
        print('History');
        return history;
      } else{
       // print(otp.message);
        return history;
      }
    } else {
      //print(otp.message);
      return history;
    }
  }
}