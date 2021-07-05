
import 'dart:convert';
import 'dart:io';
import 'package:image_downloader/image_downloader.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;
import 'package:webview_flutter/webview_flutter.dart';

import '../../constants.dart';

class ViewBill extends StatefulWidget {


  final String id, invoiceNo, billUrl, billDate, billAmount, businessName;
  ViewBill(this.id, this.invoiceNo, this.billUrl, this.billDate, this.billAmount,
      this.businessName);

 

  @override
  _ViewBillState createState() => _ViewBillState();
}

class _ViewBillState extends State<ViewBill> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  String token, id, format, fileName, downloadStatus = "Downloading...";
  String bid, file, amt, date, cadded, tagID, tag, cmt, cstore, store, storeID, catID, cat;
  File media;
  Dio dio = new Dio();
  bool downloadProgress, _isVisible,_hideDownload,_showProgress;

  // PDFDocument doc;
  int _progress = 0;


  @override
  void initState() {
    ImageDownloader.callback(onProgressUpdate: (String imageId, int progress) {
      setState(() {
        _progress = progress;
      });
    });
    _hideDownload=false;
    downloadProgress = false;
    _showProgress=false;
    _isVisible = false;

    super.initState();
    getCredentials();
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
  }

  @override
  void dispose() {
    super.dispose();
    catController.dispose();
    tagController.dispose();
    cmtController.dispose();
  }

  TextEditingController catController = new TextEditingController();
  TextEditingController tagController = new TextEditingController();
  TextEditingController cmtController = new TextEditingController();

  getCredentials() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      token = prefs.getString("token");
      id = prefs.getInt("userID").toString();
    });
    print('$token\n$id');

  }


  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Hero(
      tag: widget.id,
      child: Scaffold(
          key: _scaffoldKey,
          backgroundColor: Colors.white,
          appBar: AppBar(
            title: Text("Green Bill"),
            elevation: 0,
            leading: IconButton(
              icon: Icon(Icons.arrow_back_ios),
              onPressed: () {
                Navigator.pop(context, false);
              },
            ),
            actions: <Widget>[
              Wrap(
                spacing: 0.0,
                crossAxisAlignment: WrapCrossAlignment.center,
                alignment: WrapAlignment.center,
                children: [


                ],
              )
            ],
          ),

          body: Column(
            children: [


              Expanded(
                child: (widget.billUrl.isEmpty) ? Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(kPrimaryColorBlue),
                    )) : WebView(
                  javascriptMode: JavascriptMode.unrestricted,
                  initialUrl: widget.billUrl,
                ),
              ),
            ],
          )
      ),
    );
  }


  Future<File> urlToFile(String imageUrl) async {
    // if (media != null) {
    //   await OpenFile.open(media.path);
    //   return null;
    // }
    _showLoaderDialog(context);
    var tempDir = await getTemporaryDirectory();
    String fullPath = tempDir.path + "/$fileName";
    File file = new File(fullPath);
    print('full path ${fullPath}');
    download2(dio, imageUrl, fullPath);
    // setState(() {
    //   media = file;
    // });
  }

  Future download2(Dio dio, String url, String savePath) async {
    try {
      Response response = await dio.get(
        url,
        // onReceiveProgress: showDownloadProgress,
        options: Options(
            responseType: ResponseType.bytes,
            followRedirects: false,
            validateStatus: (status) {
              return status < 500;
            }),
      );
      print(response.headers);
      File file = File(savePath);
      var raf = file.openSync(mode: FileMode.write);
      raf.writeFromSync(response.data);
      await raf.close();
      print(file.path);
      // Navigator.of(context, rootNavigator: true).pop();
      // final result = await OpenFile.open(file.path);
      // print(
      //     "==========================================================> ${result.message} ${result.type.index}");
    } catch (e) {
      print(e);
    }
  }




  void showDownloadProgress(received, total) {
    if (total != -1) {
      print((received / total * 100).toStringAsFixed(0) + "%");
      setState(() {
        downloadStatus = "Downloading.. ${(received / total * 100).toStringAsFixed(0) + "%"}";
      });
    }
  }

  _showLoaderDialog(BuildContext context) {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
              content: SingleChildScrollView(
                  padding: new EdgeInsets.only(top: 0.0, bottom: 0.0),
                  child: new Container(
                    height: 40.0,
                    child: Center(
                      child: SpinKitWave(
                        color: kPrimaryColorBlue,
                        size: 40.0,
                      ),
                    ),
                  )));
        });
  }

  void showInSnackBar(String value) {
    FocusScope.of(context).requestFocus(new FocusNode());
    _scaffoldKey.currentState?.removeCurrentSnackBar();
    _scaffoldKey.currentState.showSnackBar(new SnackBar(
      content: new Text(
        value,
        textAlign: TextAlign.center,
        style: TextStyle(
            color: Colors.white, fontSize: 16.0, fontFamily: "PoppinsMedium"),
      ),
      backgroundColor: kPrimaryColorBlue,
      duration: Duration(seconds: 2),
    ));
  }


}

class AlwaysDisabledFocusNode extends FocusNode {
  @override
  bool get hasFocus => false;
}

