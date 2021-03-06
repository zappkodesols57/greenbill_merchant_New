import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:greenbill_merchant/src/constants.dart';
import 'package:greenbill_merchant/src/models/model_Common.dart';
import 'package:greenbill_merchant/src/models/model_suggestStoreList.dart';
import 'package:greenbill_merchant/src/ui/Profile/generalSetting.dart';
import 'package:greenbill_merchant/src/ui/values/values.dart';
import 'package:greenbill_merchant/src/ui/widgets/background.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:path/path.dart' as path;
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class CancelledCheck extends StatefulWidget {

  final String name,url;
  CancelledCheck(this.name,this.url);

  @override
  _CancelledCheckState createState() => _CancelledCheckState();
}

class _CancelledCheckState extends State<CancelledCheck> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  String token, id, storeID, storeCatID;
  File _imageFile;
  bool _isFileAvailable, _isFilePdf,removeIMG;
  final ScrollController _controller = ScrollController();

  String imageUrl;

  @override
  void initState() {
    getCredentials();
    _isFileAvailable = false;
    _isFilePdf = false;
    removeIMG = false;
    super.initState();
  }

  getCredentials() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      token = prefs.getString("token");
      id = prefs.getInt("userID").toString();
      storeID = prefs.getString("businessID");
      storeCatID = prefs.getString("businessCategoryID");
    });
    print('$token\n$id');
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("Upload Image"),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pop(context,false);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
        child: Column(
        children: <Widget>[
          SizedBox(
            height: 10.0,
          ),
          Container(
            width: size.width,
            padding: EdgeInsets.only(left: 20.0),
            child: RichText(
              text: TextSpan(
                  text: widget.name,
                  style: TextStyle(
                    fontFamily: "PoppinsLight",
                    fontSize: 13.0,
                    color: kPrimaryColorBlue,
                    fontWeight: FontWeight.bold,
                  ),
                  children: <TextSpan>[
                    TextSpan(
                      text: '',
                      style: TextStyle(
                        color: kPrimaryColorBlue,
                        fontStyle: FontStyle.normal,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ]),
            ),
          ),
          SizedBox(
            height: 10.0,
          ),
          if(removeIMG == false && widget.url != "")
          Container(
            height: 210,
            child: Image.network(widget.url,height: 200,
              loadingBuilder:(BuildContext context, Widget child,ImageChunkEvent loadingProgress) {
                if (loadingProgress == null) return child;
                return Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(kPrimaryColorBlue),
                  ),
                );
              },
            ),
          ),
          if(removeIMG == false && widget.url != "")
          SizedBox(
            height: 15.0,
          ),
          if(removeIMG == true && widget.url == "")
          Container(
            height: 210,
            child: Image.asset("assets/empty.jpg",height: 200,
            ),
          ),
          if(removeIMG == true && widget.url == "")

          SizedBox(
            height: 15.0,
          ),
          Card(
            color: Colors.white,
            elevation: 5,
            child: Container(
              height: size.height * 0.30,
              width: MediaQuery.of(context).size.width,
              child: Stack(
                children: [
                  Positioned(
                      left: MediaQuery.of(context).size.width / 1.2,
                      child: Visibility(
                        visible: _isFileAvailable,
                        child: IconButton(
                            icon: Icon(Icons.cancel),
                            onPressed: () {
                              setState(() {
                                _imageFile.delete();
                                _imageFile = null;
                                _isFileAvailable = false;
                                _isFilePdf = false;
                              });
                            }),
                      )),
                  Center(
                    child: _isFileAvailable
                        ? ClipRRect(
                      borderRadius: BorderRadius.circular(5.0),
                      child: _isFilePdf
                          ? Column(
                        mainAxisAlignment:
                        MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment:
                        CrossAxisAlignment.center,
                        children: [
                          Icon(
                            FontAwesomeIcons.solidFilePdf,
                            color: kPrimaryColorRed,
                            size: 50.0,
                          ),
                          Container(
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color: kPrimaryColorBlue)),
                              child: Text(path
                                  .basename(_imageFile.path))),
                        ],
                      )
                          : Column(
                        children: [
                          Image.file(
                            _imageFile,
                            key: ValueKey("CapturedImagePreview"),
                            fit: BoxFit.fitHeight,
                            alignment: Alignment.center,
                            height: 200,
                          ),
                          Text(
                              "${path.basename(_imageFile.path)}  ${(int.parse(_imageFile.lengthSync().toString()) / 1024).toStringAsFixed(0)} kb"),
                        ],
                      ),
                    )
                        : Center(
                      child: Row(
                        mainAxisAlignment:
                        MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          new InkWell(
                            onTap: () {
                              print("camera");
                              _openCamera(context);
                            },
                            child: Column(
                              mainAxisAlignment:
                              MainAxisAlignment.center,
                              crossAxisAlignment:
                              CrossAxisAlignment.center,
                              children: [
                                CircleAvatar(
                                  child: Icon(
                                    Icons.camera,
                                    color: Colors.white,
                                    size: size.width * 0.08,
                                  ),
                                  backgroundColor: kPrimaryColorBlue,
                                  radius: size.width * 0.06,
                                ),
                                SizedBox(
                                  height: size.width * 0.02,
                                ),
                                Text(
                                  "Camera",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: size.width * 0.05,
                                      fontFamily: "PoppinsLight",
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),

                          new InkWell(
                            onTap: () {
                              print("Gallery");
                              _openGallery(context);
                            },
                            child: Column(
                              mainAxisAlignment:
                              MainAxisAlignment.center,
                              crossAxisAlignment:
                              CrossAxisAlignment.center,
                              children: [
                                CircleAvatar(
                                  child: Icon(
                                    Icons.photo,
                                    color: Colors.white,
                                    size: size.width * 0.08,
                                  ),
                                  backgroundColor: kPrimaryColorBlue,
                                  radius: size.width * 0.06,
                                ),
                                SizedBox(
                                  height: size.width * 0.02,
                                ),
                                Text(
                                  "Gallery",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: size.width * 0.05,
                                      fontFamily: "PoppinsLight",
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 15.0),
            child: Container(
              width: 300,
              decoration: new BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(35.0)),
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                      color: Colors.white,
                      offset: Offset(1.0, 6.0),
                      blurRadius: 20.0,
                    ),
                    BoxShadow(
                      color: Colors.white,
                      offset: Offset(1.0, 6.0),
                      blurRadius: 20.0,
                    ),
                  ],
                  color: kPrimaryColorBlue
              ),
              child: MaterialButton(
                  highlightColor: Colors.transparent,
                  splashColor: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10.0, horizontal: 42.0),
                    child: Text(
                      "Submit",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 17.0,
                          fontWeight: FontWeight.w500,
                          fontFamily: "PoppinsMedium"),
                    ),
                  ),
                  onPressed: () {
                    submit(widget.name);
                  }),
            ),
          ),
          if(widget.name == "Authorised Signature" && widget.url != "" && removeIMG == true)
            Padding(
              padding: const EdgeInsets.only(top: 15.0),
            child: Container(
              width: 300,
              decoration: new BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(35.0)),
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                      color: Colors.white,
                      offset: Offset(1.0, 6.0),
                      blurRadius: 20.0,
                    ),
                    BoxShadow(
                      color: Colors.white,
                      offset: Offset(1.0, 6.0),
                      blurRadius: 20.0,
                    ),
                  ],
                  color: AppColors.kPrimaryColorRed
              ),
              child: MaterialButton(
                  highlightColor: Colors.transparent,
                  splashColor: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10.0, horizontal: 42.0),
                    child: Text(
                      "Remove",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 17.0,
                          fontWeight: FontWeight.w500,
                          fontFamily: "PoppinsMedium"),
                    ),
                  ),
                  onPressed: () {
                    removeSign();
                  }),
            ),
          ),
          if(widget.name == "Business Logo" && widget.url != "")
            Padding(
            padding: const EdgeInsets.only(top: 15.0),
            child: Container(
              width: 300,
              decoration: new BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(35.0)),
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                      color: Colors.white,
                      offset: Offset(1.0, 6.0),
                      blurRadius: 20.0,
                    ),
                    BoxShadow(
                      color: Colors.white,
                      offset: Offset(1.0, 6.0),
                      blurRadius: 20.0,
                    ),
                  ],
                  color: AppColors.kPrimaryColorRed
              ),
              child: MaterialButton(
                  highlightColor: Colors.transparent,
                  splashColor: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10.0, horizontal: 42.0),
                    child: Text(
                      "Remove",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 17.0,
                          fontWeight: FontWeight.w500,
                          fontFamily: "PoppinsMedium"),
                    ),
                  ),
                  onPressed: () {
                    removeLogo();
                  }),
            ),
          ),
        ],),)
      ),

    );
  }

  void _openGallery(BuildContext context) async {
    var picture = await ImagePicker.pickImage(source: ImageSource.gallery, imageQuality: 25);
    if (picture != null) {
      _cropImage(picture);
    }
  }

  Future<Null> _cropImage(File picture) async {
    File croppedFile = await ImageCropper.cropImage(
      sourcePath: picture.path,
      compressQuality: 50,
      aspectRatioPresets: Platform.isAndroid
          ? [
        CropAspectRatioPreset.square,
        CropAspectRatioPreset.ratio3x2,
        CropAspectRatioPreset.original,
        CropAspectRatioPreset.ratio4x3,
        CropAspectRatioPreset.ratio16x9,
      ]
          : [
        CropAspectRatioPreset.square,
        CropAspectRatioPreset.ratio3x2,
        CropAspectRatioPreset.ratio4x3,
        CropAspectRatioPreset.ratio5x3,
        CropAspectRatioPreset.ratio5x4,
        CropAspectRatioPreset.ratio7x5,
        CropAspectRatioPreset.ratio16x9
      ],
      androidUiSettings: AndroidUiSettings(
          toolbarTitle: 'Crop',
          toolbarColor: kPrimaryColorBlue,
          toolbarWidgetColor: Colors.white,
          activeControlsWidgetColor: kPrimaryColorGreen,
          initAspectRatio: CropAspectRatioPreset.square,
          lockAspectRatio: false),
    );
    if (croppedFile != null) {
      setState(() {
        _imageFile = croppedFile;
        _isFileAvailable = true;
      });
      // await Future.delayed(Duration(milliseconds: 1000), null);
      // showInSnackBar("Tap on Cancel button to select another picture", 5);
    }
  }
  void _openCamera(BuildContext context) async {
    var picture = await ImagePicker.pickImage(
        source: ImageSource.camera, imageQuality: 25);
    if (picture != null) {
      // setState(() {
      //   _imageFile = picture;
      //   _isFileAvailable = true;
      // });
      _cropImage(picture);
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
                  )
              )
          );
        });
  }

  void showInSnackBar(String value) {
    // FocusScope.of(context).requestFocus(new FocusNode());
    _scaffoldKey.currentState?.removeCurrentSnackBar();
    _scaffoldKey.currentState.showSnackBar(new SnackBar(
      content: new Text(
        value,
        textAlign: TextAlign.center,
        style: TextStyle(
            color: Colors.white,
            fontSize: 16.0,
            fontFamily: "PoppinsMedium"),
      ),
      // backgroundColor: kPrimaryColorBlue,
      duration: Duration(seconds: 2),
      behavior: SnackBarBehavior.floating,
    ));
  }

  Future<void> submit(String value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    int userID = prefs.getInt("userID");
    String tokenn = prefs.getString("token");

    if (_imageFile == null) {
      showInSnackBar("Please select Image");
      return null;
    }
    _showLoaderDialog(context);

    var uri = Uri.parse("http://157.230.228.250/merchant-upload-cancel-check-api/");
    Map<String, String> headers = {"Authorization": "Token $tokenn"};
    // create multipart request
    var request = new http.MultipartRequest("POST", uri);

    http.MultipartFile multipartFile = await http.MultipartFile.fromPath(
        'cancel_bank_cheque_photo', _imageFile.path,
        filename: path.basename(_imageFile.path));
    http.MultipartFile multipartFile2 = await http.MultipartFile.fromPath(
        'm_gstin_certificate', _imageFile.path,
        filename: path.basename(_imageFile.path));
    http.MultipartFile multipartFile3 = await http.MultipartFile.fromPath(
        'm_CIN_certificate', _imageFile.path,
        filename: path.basename(_imageFile.path));
    http.MultipartFile multipartFile4 = await http.MultipartFile.fromPath(
        'udyog_adhaar_certificate', _imageFile.path,
        filename: path.basename(_imageFile.path));
    http.MultipartFile multipartFile5 = await http.MultipartFile.fromPath(
        'address_proof', _imageFile.path,
        filename: path.basename(_imageFile.path));
    http.MultipartFile multipartFile6 = await http.MultipartFile.fromPath(
        'pan_card_legal_entity', _imageFile.path,
        filename: path.basename(_imageFile.path));
    http.MultipartFile multipartFile7 = await http.MultipartFile.fromPath(
        'proof_of_authourize_signature', _imageFile.path,
        filename: path.basename(_imageFile.path));
    http.MultipartFile multipartFile8 = await http.MultipartFile.fromPath(
        'm_company_registration_certificate', _imageFile.path,
        filename: path.basename(_imageFile.path));
    http.MultipartFile multipartFile9 = await http.MultipartFile.fromPath(
        'm_schedule_pdf_upload', _imageFile.path,
        filename: path.basename(_imageFile.path));
    http.MultipartFile multipartFile10 = await http.MultipartFile.fromPath(
        'm_digital_signature', _imageFile.path,
        filename: path.basename(_imageFile.path));
    http.MultipartFile multipartFile11 = await http.MultipartFile.fromPath(
        'm_business_logo', _imageFile.path,
        filename: path.basename(_imageFile.path));
    // add file to multipart
    if(widget.name == "Cancelled Cheque") {
      request.files.add(multipartFile);
    }
    if(widget.name == "GSTIN Certificate") {
      request.files.add(multipartFile2);
    }
    if(widget.name == "CIN Certificate") {
      request.files.add(multipartFile3);
    }
    if(widget.name == "Udyog Aadhaar Certificate") {
      request.files.add(multipartFile4);
    }
    if(widget.name == "Address Proof") {
      request.files.add(multipartFile5);
    }
    if(widget.name == "Attested copy of Pan Card of Legal Entity") {
      request.files.add(multipartFile6);
    }
    if(widget.name == "Signature proof of Authorized Signatory") {
      request.files.add(multipartFile7);
    }
    if(widget.name == "Company Registration Certificate") {
      request.files.add(multipartFile8);
    }
    if(widget.name == "PayU Schedule Upload") {
      request.files.add(multipartFile9);
    }
    if(widget.name == "Authorised Signature") {
      request.files.add(multipartFile10);
    }
    if(widget.name == "Business Logo") {
      request.files.add(multipartFile11);
    }
    request.fields['m_business_id'] =storeID;
    request.headers.addAll(headers);


    var response = await request.send();
    print(response.statusCode);
    print(response);
    Navigator.of(context, rootNavigator: true).pop();
    if (response.statusCode == 200) {
      print("***********************************************     Submit     *******************************************************");
      _imageFile.delete();
      _imageFile = null;
      _isFileAvailable = false;
      _isFilePdf = false;
      showInSnackBar("Image Uploaded Successfully");
      Navigator.pop(context,true);
      // Navigator.of(context).push(MaterialPageRoute(builder: (_) => GeneralSetting()));
    } else {
      showInSnackBar("Something went wrong!");
    }
    response.stream.transform(utf8.decoder).listen((value) {
      print(value);
    });


  }

  Future<void> removeSign() async {
    String url;
     url = "http://157.230.228.250/remove-digital-signature-api/";
    final param = {
      "m_business_id": storeID,
    };

    final response = await http.post(url, body: param, headers: {HttpHeaders.authorizationHeader: "Token $token"},);

    print(response.statusCode);
    CommonData data;
    var responseJson = json.decode(response.body);
    data = new CommonData.fromJson(jsonDecode(response.body));
    print(response.body);
    // Navigator.of(context, rootNavigator: true).pop();

    if (response.statusCode == 200) {
      print(responseJson);
      print("Delete Successful");
      print(data.status);
      if(data.status == "success"){
        showInSnackBar(data.message);
        Navigator.pop(context,true);
      } else showInSnackBar(data.status);
    } else {
      print(data.status);
      showInSnackBar(data.status);
      return null;
    }
  }

  Future<void> removeLogo() async {
    String url;
     url = "http://157.230.228.250/remove-business-logo-api/";
    final param = {
      "m_business_id": storeID,
    };

    final response = await http.post(url, body: param, headers: {HttpHeaders.authorizationHeader: "Token $token"},);

    print(response.statusCode);
    CommonData data;
    var responseJson = json.decode(response.body);
    data = new CommonData.fromJson(jsonDecode(response.body));
    print(response.body);
    // Navigator.of(context, rootNavigator: true).pop();

    if (response.statusCode == 200) {
      print(responseJson);
      print("Delete Successful");
      print(data.status);
      if(data.status == "success"){
        showInSnackBar(data.message);
        Navigator.pop(context,true);
      } else showInSnackBar(data.status);
    } else {
      print(data.status);
      showInSnackBar(data.status);
      return null;
    }
  }
}
