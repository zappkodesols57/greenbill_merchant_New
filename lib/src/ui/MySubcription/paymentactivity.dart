import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:http/http.dart' as http;
class WebViewPayment extends StatefulWidget {

  @override
  _WebViewPaymentState createState() => _WebViewPaymentState();
}
class _WebViewPaymentState extends State<WebViewPayment> {
  @override
  void initState() {
    super.initState();
  }
  @override
  void dispose() {
    super.dispose();
  }

  Future<http.Response> _launchAboutUsURL()async {
    return http.post(
      Uri.parse('https://test.payu.in/_payment'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        "key":"JPM7Fg",
        "txnid":"PQI6MqpYrjEefU",
        "amount":"10",
        "productinfo":"iPhone",
        "firstname":"PayU User",
        "email":"test@gmail.com",
        "phone":"9876543210",
        "surl":"https://apiplayground-response.herokuapp.com/",
        "furl":"https://apiplayground-response.herokuapp.com/",
        "hash":"ccc029894dcc03a164f281b7a64596a19785e8a61ae81d008ef482e1534a99a67eee346d3cbf9ffcf1ce63b0e2faee26f2e4a20e6aef471c25b424c33971bb41",
      }
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Hii"),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back_ios),
        ),
      ),
      body: WebView(
        javascriptMode: JavascriptMode.unrestricted,
        initialUrl: "https://test.payu.in/_payment",
      ),
    );
  }
}