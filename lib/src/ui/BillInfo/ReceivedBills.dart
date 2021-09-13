import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:greenbill_merchant/src/constants.dart';
import 'package:greenbill_merchant/src/models/model_Common.dart';
import 'package:greenbill_merchant/src/models/model_IncomingBills.dart';
import 'package:greenbill_merchant/src/models/model_billInfoList.dart';
import 'package:greenbill_merchant/src/models/model_billSend.dart';
import 'package:greenbill_merchant/src/models/model_getStore.dart';
import 'package:http/http.dart' as http;
import 'package:open_file/open_file.dart';
import 'package:image_downloader/image_downloader.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import 'ViewBill.dart';

class BillIncoming extends StatefulWidget {
  @override
  BillIncomingState createState() => BillIncomingState();
}

class BillIncomingState extends State<BillIncoming> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  String token, id, storeID;
  final ScrollController _controller = ScrollController();
  File media;
  int billID;
  int storeId;
  final path = '/storage/emulated/0/Download';
  Dio dio = new Dio();
  TextEditingController query = new TextEditingController();

  @override
  void initState() {
    getCredentials();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
    query.dispose();
  }

  getCredentials() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      token = prefs.getString("token");
      id = prefs.getInt("userID").toString();
      storeID = prefs.getString("businessID");
    });
    print('$token\n$id\n$storeID');
  }

  Future<List<Datum>> getBillInfoList() async {
    final param = {
      "m_business_id": storeID,
    };

    final res = await http.post("http://157.230.228.250/merchant-get-received-bill-api/",
        body: param, headers: {HttpHeaders.authorizationHeader: "Token $token"});

    print(res.body);
    print(res.statusCode);
    if (200 == res.statusCode) {
      print(incomingBillsFromJson(res.body).data.length);
      return incomingBillsFromJson(res.body).data
          .where((element) =>
      element.businessName.toString().toLowerCase().toUpperCase().contains(query.text) ||
          element.invoiceNo.toString().toUpperCase().toLowerCase().contains(query.text) ||
          element.billId.toString().toLowerCase().contains(query.text)|| element.billAmount.toString().contains(query.text))
          .toList();

    } else {
      throw Exception('Failed to load List');
    }
  }
  Future<List<StoreList>> getStoreList(String id, String token) async {
    final param = {
      "user_id": id,
    };

    final res = await http.post(
      "http://157.230.228.250/get-merchant-businesses-api/",
      body: param,
      headers: {HttpHeaders.authorizationHeader: "Token $token"},
    );

    print(res.body);
    if (200 == res.statusCode) {
      print(storeListFromJson(res.body).length);
      return storeListFromJson(res.body);
    } else {
      throw Exception('Failed to load Stores List');
    }
  }
  Future<List<StoreBillList>> transferBill(String id, String token) async {
    final param = {
      "user_id": id,
    };

    final res = await http.post(
      "http://157.230.228.250/get-merchant-businesses-api/",
      body: param,
      headers: {HttpHeaders.authorizationHeader: "Token $token"},
    );

    print(res.body);
    if (200 == res.statusCode) {
      print(storeListFromJson(res.body).length);
      return storeBillListFromJson(res.body);
    } else {
      throw Exception('Failed to load Stores List');
    }
  }


  Widget setupAlertDialoagContainerBill() {
    return Container(
      height: 150,
      width: 350,
      child: FutureBuilder<List<StoreBillList>>(
        future: transferBill(id.toString(), token),
        //future: getStoreList(id.toString(), token),
        builder: (BuildContext context,
            AsyncSnapshot<List<StoreBillList>> snapshot) {
          if (snapshot.connectionState == ConnectionState.done &&
              snapshot.hasData) {
            return Scrollbar(
                radius: Radius.circular(5.0),
                isAlwaysShown: true,
                controller: _controller,
                thickness: 3.0,
                child: ListView.builder(
                    controller: _controller,
                    itemCount: snapshot.data.length,
                    itemBuilder: (BuildContext context, int index) {

                      return ListTile(
                        title: Text(snapshot.data[index].mBusinessName,
                            style: TextStyle(fontSize: 15.0)),
                        subtitle: (snapshot.data[index].mArea.isNotEmpty)
                            ? Text(
                            '${snapshot.data[index].mAddress}, ${snapshot.data[index].mArea}, ${snapshot.data[index].mCity}',
                            style: TextStyle(fontSize: 10.0))
                            : Text('Address not available',
                            style: TextStyle(fontSize: 10.0)),


                        leading:
                        (snapshot.data[index].mBusinessLogo != null)
                            ? CircleAvatar(
                          backgroundColor: kPrimaryColorBlue,
                          backgroundImage: NetworkImage(snapshot.data[index].mBusinessLogo),
                        )
                            : CircleAvatar(
                          backgroundColor: kPrimaryColorBlue,
                          child: Text(
                            storeID.substring(0, 1).toUpperCase(),
                            style: TextStyle(
                              fontSize: 20.0,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        onTap: () async {
                          setState(() {
                            storeId=snapshot.data[index].id;
                          });
                          sendBill();
                        },
                      );
                    }));
          } else {
            return Center(
                child: CircularProgressIndicator(
                  //valueColor: animationController.drive(ColorTween(
                  // begin: kPrimaryColorBlue, end: kPrimaryColorGreen)),
                ));
          }
        },
      ),
    );
  }


  showStoreDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              'Where you want to send bill',
              style: TextStyle(
                  color: Colors.black87,
                  fontWeight: FontWeight.w800,
                  fontSize: 15.0,
                  fontFamily: "PoppinsMedium"),
            ),
            content: setupAlertDialoagContainerBill(),
            actions: <Widget>[
              TextButton(
                child:
                Text('Cancel', style: TextStyle(color: kPrimaryColorBlue)),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }


  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        key: _scaffoldKey,
        // appBar:buildAppBar(),
        backgroundColor: Colors.white,
        body: Column(
          children: [
            Container(
              width: size.width * 0.99,
              padding: EdgeInsets.only(
                  top: 10.0, bottom: 10.0, left: 0.0, right: 0.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(32),
              ),
              child: TextField(
                controller: query,
                // keyboardType: TextInputType.phone,
                // maxLength: 10,
                textCapitalization: TextCapitalization.characters,
                onChanged: (value) {
                  getBillInfoList();
                  setState(() {});
                },
                // inputFormatters: <TextInputFormatter>[
                //   FilteringTextInputFormatter.digitsOnly
                // ],
                style: TextStyle(
                    fontFamily: "PoppinsMedium",
                    fontSize: 15.0,
                    color: kPrimaryColorBlue),
                decoration: InputDecoration(
                  border: InputBorder.none,
                  counterStyle: TextStyle(
                    height: double.minPositive,
                  ),
                  counterText: "",
                  contentPadding: const EdgeInsets.symmetric(
                      vertical: 13.0, horizontal: 20.0),
                  enabledBorder: OutlineInputBorder(
                    borderSide:
                    BorderSide(color: kPrimaryColorBlue, width: 1.0),
                    borderRadius: const BorderRadius.all(Radius.circular(35.0)),
                  ),
                  focusedBorder: new OutlineInputBorder(
                    borderSide:
                    BorderSide(color: kPrimaryColorBlue, width: 1.0),
                    borderRadius: const BorderRadius.all(Radius.circular(35.0)),
                  ),
                  // prefixIcon: Icon(
                  //   FontAwesomeIcons.search,
                  //   color: kPrimaryColorBlue,
                  //   size: 20.0,
                  // ),
                  suffixIcon: GestureDetector(
                    onTap: () {},
                    child: Icon(
                      CupertinoIcons.search,
                      color: kPrimaryColorBlue,
                      size: 25.0,
                    ),
                  ),
                  hintText: "Search Bills",
                  hintStyle: TextStyle(
                      fontFamily: "PoppinsMedium",
                      fontSize: 15.0,
                      color: kPrimaryColorBlue),
                ),
              ),
            ),
            ListTile(
              tileColor: kPrimaryColorBlue,
              title: Container(
                margin: const EdgeInsets.only(left: 10.0, right: 0.0),
                child: Text(
                  "Business",
                  textAlign: TextAlign.start,
                  style: TextStyle(
                      color: Colors.white, fontFamily: "PoppinsBold"),
                ),
              ),
              trailing:Wrap(
                spacing: 10, // space between two icons
                crossAxisAlignment: WrapCrossAlignment.center,
                children: <Widget>[
                  Container(
                    width: 50.0,
                    child: Text(
                      "Bill ",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.white, fontFamily: "PoppinsBold"),
                    ),
                  ),
                  Container(
                    width: 50.0,
                    child: Text(
                      "Send ",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.white, fontFamily: "PoppinsBold"),
                    ),
                  ),

                  Container(
                    width: 72.0,
                    child: Text(
                      "Amount",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.white, fontFamily: "PoppinsBold"),
                    ),
                  )
                ],
              ),

              onTap: () {
                // Navigator.push(context, MaterialPageRoute(builder:  (context)=>MerchantBillList(snapshot.data[index].mBusinessName)));
              },
            ),

            Expanded(
              child: FutureBuilder<List<Datum>>(
                future: getBillInfoList(),
                builder: (BuildContext context,
                    AsyncSnapshot<List<Datum>> snapshot) {

                  if (snapshot.connectionState == ConnectionState.waiting)
                    return Center(
                        child: CircularProgressIndicator(
                          valueColor:
                          AlwaysStoppedAnimation<Color>(kPrimaryColorBlue),
                        ));
                  else if (snapshot.hasError) {
                    print(snapshot.error);
                    return Center(
                      child: Text("No Bills Found"),
                    );
                  } else {
                    if (snapshot.connectionState == ConnectionState.done &&
                        snapshot.hasData) {
                      // WidgetsBinding.instance.addPostFrameCallback((_) {
                      //   if (_controller.hasClients) {
                      //     _controller.animateTo(
                      //         _controller.position.maxScrollExtent,
                      //         duration: Duration(milliseconds: 100),
                      //         curve: Curves.);
                      //   } else {
                      //     setState(() => null);
                      //   }
                      // });
                      return Scrollbar(
                        isAlwaysShown: true,
                        controller: _controller,
                        thickness: 3.0,
                        child: ListView.builder(
                            controller: _controller,
                            reverse: false,
                            itemCount: snapshot.data.length,
                            itemBuilder: (BuildContext context, int index) {

                              return Card(
                                child: Center(
                                  child: ListTile(
                                    dense: true,
                                    title: Text(snapshot.data[index].businessName,
                                        style: TextStyle(fontSize: 15.0)),
                                    subtitle: Text("Date : ${snapshot.data[index].billDate}\nInvoice : ${snapshot.data[index].invoiceNo}",
                                        style: TextStyle(
                                            fontSize: 11.0,
                                            color: Colors.grey)),
                                    isThreeLine: false,

                                    trailing: Wrap(
                                      spacing: 7, // space between two icons
                                      crossAxisAlignment:
                                      WrapCrossAlignment.center,
                                      children: <Widget>[
                                        IconButton(
                                          icon: Icon(
                                            Icons.download_outlined,
                                            color: Colors.black,
                                          ),
                                          onPressed: () async {
                                            try {
                                              await ImageDownloader.downloadImage("http://157.230.228.250/"+snapshot.data[index].billImage).then((context) =>  showInSnackBar("Download Complete"));
                                            }
                                            on PlatformException catch (error) {
                                              print(error);
                                            }
                                          },
                                        ),
                                        IconButton(
                                          icon: Icon(
                                            Icons.switch_account,
                                            color: Colors.black,
                                          ),
                                          onPressed: () {
                                            setState(() {
                                              billID = snapshot.data[index].billId;
                                              //storeId= snapshot.data[index].id;
                                            });
                                            showStoreDialog(context);

                                          },
                                        ),

                                        SizedBox(width: 3.0,),

                                        Container(
                                            width: 70.0,
                                            child: Text("₹ ${double.parse(snapshot.data[index].billAmount).toStringAsFixed(2)}",
                                                style: TextStyle(
                                                    fontWeight:
                                                    FontWeight.bold))),
                                      ],
                                    ),
                                    onTap: () {
                                      launch(snapshot.data[index].billUrl);
                                      // Navigator.push(
                                      //   context,
                                      //   MaterialPageRoute(
                                      //       builder: (context) => ViewBill("0", snapshot.data[index].billImage,
                                      //           snapshot.data[index].billUrl, snapshot.data[index].billDate, snapshot.data[index].billAmount,
                                      //           snapshot.data[index].businessName)),
                                      // );
                                    },
                                  ),
                                ),
                              );
                            }),
                      );
                    } else {
                      return Center(
                          child: CircularProgressIndicator(
                            valueColor:
                            AlwaysStoppedAnimation<Color>(kPrimaryColorBlue),
                          ));
                    }
                  }
                },
              ),
            )
          ],
        ));
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
  Future<void> openBill(String billFile, String fileName) async {
    _showLoaderDialog(context);
    var tempDir = await getTemporaryDirectory();
    String fullPath = tempDir.path + "/$fileName";
    File file = new File(fullPath);
    print('full path ${fullPath}');
    download2(dio, billFile, fullPath);
    setState(() {
      media = file;
    });
  }

  Future download2(Dio dio, String url, String savePath) async {
    try {
      Response response = await dio.get(
        url,
        onReceiveProgress: showDownloadProgress,
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
      Navigator.of(context, rootNavigator: true).pop();
      final result = await OpenFile.open(file.path);
      print(
          "==========================================================> ${result.message} ${result.type.index}");
    } catch (e) {
      print(e);
    }
  }
  Future<File> urlToFile(String imageUrl,String billFile) async {
// generate random number.
    var rng = new Random();
// get temporary directory of device.
    Directory tempDir = await getTemporaryDirectory();
// get temporary path from temporary directory.
    String tempPath = tempDir.path;
    String fullPath='$tempPath'+ (rng.nextInt(100)).toString() +'.jpg';
// create a new file in temporary path with random file name.
    File file = new File(fullPath);
// call http.get method and pass imageUrl into it to get response.
    http.Response response = await http.get(imageUrl);
// write bodyBytes received in response to file.
    await file.writeAsBytes(response.bodyBytes);
    download2(dio, billFile, fullPath);
// now return the file which is created with random name in
// temporary directory and image bytes from response is written to // that file.
    print(file);

    return file;

  }





  void showDownloadProgress(received, total) {
    if (total != -1) {
      print((received / total * 100).toStringAsFixed(0) + "%");
    }
  }

  void sendBill() async{
    final param ={
      "business_id":storeId.toString(),
      "bill_id":billID.toString(),
    };
    print("............$storeId..............$billID");
    final response = await http.post("http://157.230.228.250/merchant-send-received-bill-api/",
        body: param, headers: {HttpHeaders.authorizationHeader:"Token $token"}
    );

    CommonData data;
    var responseJson = json.decode(response.body);
    print(response.body);
    data = new CommonData.fromJson(jsonDecode(response.body));
    print(responseJson);
    Navigator.of(context, rootNavigator: true).pop();
    if (response.statusCode == 200) {
      if (data.status == "success") {
        print("Send Successful");
        showInSnackBar(data.message);
        print(data.message);
      } else {
        print(data.status);
        showInSnackBar(data.message);
      }
    } else {
      print(data.status);
      showInSnackBar(data.message);
    }
  }


}
