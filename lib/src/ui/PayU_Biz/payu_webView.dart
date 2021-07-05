import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PayUWebView extends StatefulWidget {
  final String title, url;
  PayUWebView(this.title, this.url);

  @override
  _PayUWebViewState createState() => _PayUWebViewState();
}

class _PayUWebViewState extends State<PayUWebView> {

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back_ios),
        ),
      ),
      body: WebView(
        javascriptMode: JavascriptMode.unrestricted,
        initialUrl: new Uri.dataFromString('''
      <html>
        <head>
         <meta name="viewport" content="width=device-width">
        </head>
        <center>
          <body>
              <form action='https://secure.payu.in/_payment' method='post'>
                  <input type="hidden" name="key" value="IUZdcF" />
                  <input type="hidden" name="txnid" value="PQI6MqpYrjEefU" />
                  <input type="hidden" name="productinfo" value="iPhone" />
                  <input type="hidden" name="amount" value="1.00" />
                  <input type="hidden" name="email" value="test@gmail.com" />
                  <input type="hidden" name="firstname" value="PayU User" />
                  <input type="hidden" name="lastname" value="" />
                  <input type="hidden" name="surl" value="http://greenbill.in" />
                  <input type="hidden" name="furl" value="https://www.acme.com/getFailure" />
                  <input type="hidden" name="phone" value="8208323667" />
                  <input type="hidden" name="hash" value="ccc029894dcc03a164f281b7a64596a19785e8a61ae81d008ef482e1534a99a67eee346d3cbf9ffcf1ce63b0e2faee26f2e4a20e6aef471c25b424c33971bb41" />
              </form>
          </body>
        </center>
      </html>
            ''', mimeType: 'text/html').toString(),
      ),
    );
  }
}