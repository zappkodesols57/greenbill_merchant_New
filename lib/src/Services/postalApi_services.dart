import 'package:greenbill_merchant/src/models/postApi_model.dart';
import 'package:http/http.dart' as http;

class Services{
  static Future<List<PinCode>> getUserLocation(String pinCodes) async {
    final res = await http.get('https://api.postalpincode.in/pincode/$pinCodes');
    print(res.body);
    try{
      if(200 == res.statusCode){
        final List<PinCode> pinCode = pinCodeFromJson(res.body);
        return pinCode;
      } else{
        return List<PinCode>();
      }
    } catch(e){
      return List<PinCode>();
    }
  }
}