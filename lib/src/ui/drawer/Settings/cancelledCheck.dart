import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:greenbill_merchant/src/constants.dart';
import 'package:greenbill_merchant/src/models/model_Common.dart';
import 'package:greenbill_merchant/src/models/model_suggestStoreList.dart';
import 'package:greenbill_merchant/src/ui/widgets/background.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:path/path.dart' as path;
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class CancelledCheck extends StatefulWidget {
  @override
  _CancelledCheckState createState() => _CancelledCheckState();
}

class _CancelledCheckState extends State<CancelledCheck> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  String token, id, storeID, storeCatID;
  File _imageFile;
  bool _isFileAvailable, _isFilePdf;
  final ScrollController _controller = ScrollController();





  @override
  void initState() {
    getCredentials();
    _isFileAvailable = false;
    _isFilePdf = false;
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
        title: Text('Cancelled Cheque'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pop(context);
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
                  text: 'Cancelled Cheque',
                  style: TextStyle(
                    fontFamily: "PoppinsLight",
                    fontSize: 13.0,
                    color: kPrimaryColorBlue,
                    fontWeight: FontWeight.bold,
                  ),
                  children: <TextSpan>[
                    TextSpan(
                      text: '*',
                      style: TextStyle(
                        color: kPrimaryColorBlue,
                        fontStyle: FontStyle.normal,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ]),
            ),
          ),
          Card(
            color: Colors.white,
            elevation: 5,
            child: Container(
              height: size.height * 0.26,
              width: MediaQuery.of(context).size.width,
              child: Stack(
                children: [
                  // Positioned(
                  //   child: Visibility(
                  //     child: Container(
                  //       height: 100,
                  //       width: 300,
                  //       color: Colors.green,
                  //     ),
                  //   ),
                  // ),
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
            padding: const EdgeInsets.all(20.0),
            child: Container(
              width: size.width,
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
                          fontSize: 20.0,
                          fontWeight: FontWeight.w500,
                          fontFamily: "PoppinsMedium"),
                    ),
                  ),
                  onPressed: () {
                    submit();
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
    FocusScope.of(context).requestFocus(new FocusNode());
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
      backgroundColor: kPrimaryColorBlue,
      duration: Duration(seconds: 2),
    ));
  }

  Future<void> submit() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    int userID = prefs.getInt("userID");
    String tokenn = prefs.getString("token");


    if (_imageFile == null) {
      showInSnackBar("Please select Cancelled Cheque");
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
    // add file to multipart
    request.files.add(multipartFile);
    request.fields['m_business_id'] =storeID;
    request.headers.addAll(headers);


    var response = await request.send();
    print(response.statusCode);
    print(response);
    Navigator.of(context, rootNavigator: true).pop();
    if (response.statusCode == 200) {
      print("***********************************************     Submit     *******************************************************");
      showInSnackBar("Cancelled Check Uploaded Successfully");
    } else {
      showInSnackBar("Something went wrong!");
    }
    response.stream.transform(utf8.decoder).listen((value) {
      print(value);
    });


  }

}
