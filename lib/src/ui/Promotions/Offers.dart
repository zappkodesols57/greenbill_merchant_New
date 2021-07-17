import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:async/async.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:greenbill_merchant/src/models/model_getBillCategory.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../constants.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;

class Offers extends StatefulWidget {

  final String offerName, offerCaption, offerImage, validFrom, validThrough, offerType,
      offerBusinessCategory,offerId;

  const Offers( this.offerName, this.offerCaption, this.offerImage, this.validFrom,
      this.validThrough, this.offerType, this.offerBusinessCategory,this.offerId,  {Key key}) : super(key: key);

  @override
  _OffersState createState() => _OffersState( offerName, offerCaption, offerImage, validFrom,
      validThrough, offerType, offerBusinessCategory,offerId);
}

class _OffersState extends State<Offers> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  TextEditingController catController = new TextEditingController();
  final ScrollController _controller = ScrollController();

  DateTime initDate;
  File _imageFile;
  String radioItem;
  bool _isFileAvailable, _isFilePdf;
  String token, id, mob, storeID;
  File image;
  bool custom=false;
  bool  couponType = true, amountType = true;


  final String offerName, offerCaption, offerImage, validFrom, validThrough, offerType,
      offerBusinessCategory,offerId;

  _OffersState( this.offerName, this.offerCaption, this.offerImage, this.validFrom,
      this.validThrough, this.offerType, this.offerBusinessCategory,this.offerId);

  @override
  void initState() {
    _isFileAvailable = false;
    _isFilePdf = false;
    super.initState();

    getCredentials();
  }

  @override
  void dispose() {
    super.dispose();
    cnController.dispose();
    catController.dispose();
    ccController.dispose();
    gpController.dispose();
    fDateController.dispose();
    tDateController.dispose();
    captionController.dispose();
    perController.dispose();
    amtController.dispose();
    quantityController.dispose();
  }

  getCredentials() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString("token");
    id = prefs.getInt("userID").toString();
    mob = prefs.getString("mobile");
    storeID = prefs.getString("businessID");
    print(id);
    print(storeID);
    setState(() {
      cnController.text = offerName;
      ccController.text = offerCaption;
      fDateController.text = validFrom;
      tDateController.text = validThrough;
      catController.text = offerBusinessCategory;

    });
  }

  TextEditingController cnController = new TextEditingController();
  TextEditingController ccController = new TextEditingController();
  TextEditingController gpController = new TextEditingController();
  TextEditingController fDateController = new TextEditingController();
  TextEditingController tDateController = new TextEditingController();
  TextEditingController captionController = new TextEditingController();
  TextEditingController perController = new TextEditingController();
  TextEditingController amtController = new TextEditingController();
  TextEditingController quantityController = new TextEditingController();

  Future<void> _selectFromDate(BuildContext context) async {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2030, 1),
    ).then((pickedDate) {
      fDateController.text = DateFormat('dd-MM-yyyy').format(pickedDate);
      setState(() {
        initDate = pickedDate;
      });
    });
  }

  Future<void> _selectToDate(BuildContext context) async {
    showDatePicker(
      context: context,
      initialDate: initDate,
      firstDate: initDate,
      lastDate: DateTime(2030, 1),
    ).then((pickedDate) {
      tDateController.text = DateFormat('dd-MM-yyyy').format(pickedDate);
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Add Offers'),
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pop(context, false);
          },
        ),
        actions: <Widget>[
          TextButton(
            onPressed: (){
              create();
            },
            child: Text("CREATE", style: TextStyle(color: Colors.white),),
          ),
        ],
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
                      text: 'Offer Image',
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
              Container(
                width: size.width * 0.95,
                padding: EdgeInsets.only(top: 10.0, bottom: 10.0, left: 0.0, right: 0.0),
                child: TextField(
                  maxLength: 15,
                  controller: cnController,
                  inputFormatters: [new WhitelistingTextInputFormatter(RegExp("[a-z A-Z]")),],
                  style: TextStyle(
                      fontFamily: "PoppinsLight",
                      fontSize: 17.0,
                      color: Colors.black87),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    counterStyle: TextStyle(height: double.minPositive,),
                    counterText: "",
                    contentPadding: const EdgeInsets.symmetric(vertical: 0.0),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: kPrimaryColorBlue,
                          width: 0.5
                      ),
                      borderRadius: const BorderRadius.all(Radius.circular(35.0)),
                    ),
                    focusedBorder: new OutlineInputBorder(
                      borderSide: BorderSide(
                          color: kPrimaryColorBlue,
                          width: 0.5),
                      borderRadius: const BorderRadius.all(Radius.circular(35.0)),
                    ),
                    prefixIcon: Icon(
                      CupertinoIcons.gift_fill,
                      color: kPrimaryColorBlue,
                      size: 23.0,
                    ),
                    labelText: "Offer Name *",
                    labelStyle: TextStyle(
                        fontFamily: "PoppinsLight", fontSize: 13.0, color: kPrimaryColorBlue),
                  ),
                ),
              ),
              Container(
                width: size.width * 0.95,
                padding: EdgeInsets.only(top: 0.0, bottom: 10.0, left: 0.0, right: 0.0),
                child: TextField(
                  maxLength: 20,
                  controller: ccController,
                  style: TextStyle(
                      fontFamily: "PoppinsLight",
                      fontSize: 17.0,
                      color: Colors.black87),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    counterStyle: TextStyle(height: double.minPositive,),
                    counterText: "",
                    contentPadding: const EdgeInsets.symmetric(vertical: 0.0),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: kPrimaryColorBlue,
                          width: 0.5
                      ),
                      borderRadius: const BorderRadius.all(Radius.circular(35.0)),
                    ),
                    focusedBorder: new OutlineInputBorder(
                      borderSide: BorderSide(
                          color: kPrimaryColorBlue,
                          width: 0.5),
                      borderRadius: const BorderRadius.all(Radius.circular(35.0)),
                    ),
                    prefixIcon: Icon(
                      CupertinoIcons.doc_append,
                      color: kPrimaryColorBlue,
                      size: 23.0,
                    ),
                    labelText: "Offer Caption *",
                    labelStyle: TextStyle(
                        fontFamily: "PoppinsLight", fontSize: 13.0, color: kPrimaryColorBlue),
                  ),
                ),
              ),

              Container(
                width: size.width * 0.95,
                padding: EdgeInsets.only(top: 0.0, bottom: 10.0, left: 0.0, right: 0.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: size.width * 0.45,
                      padding: EdgeInsets.only(top: 0.0, bottom: 0.0, left: 0.0, right: 0.0),
                      child: TextField(
                        enableInteractiveSelection: false, // will disable paste operation
                        focusNode: new AlwaysDisabledFocusNode(),
                        onTap: () {
                          _selectFromDate(context);
                        },
                        controller: fDateController,
                        style: TextStyle(
                            fontFamily: "PoppinsLight",
                            fontSize: 17.0,
                            color: Colors.black87),
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          counterStyle: TextStyle(height: double.minPositive,),
                          counterText: "",
                          contentPadding: const EdgeInsets.symmetric(vertical: 0.0),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: kPrimaryColorBlue,
                                width: 0.5
                            ),
                            borderRadius: const BorderRadius.all(Radius.circular(35.0)),
                          ),
                          focusedBorder: new OutlineInputBorder(
                            borderSide: BorderSide(
                                color: kPrimaryColorBlue,
                                width: 0.5),
                            borderRadius: const BorderRadius.all(Radius.circular(35.0)),
                          ),
                          prefixIcon: Icon(
                            CupertinoIcons.calendar,
                            color: kPrimaryColorBlue,
                            size: 23.0,
                          ),
                          labelText: "From Date *",
                          labelStyle: TextStyle(
                              fontFamily: "PoppinsLight", fontSize: 13.0, color: kPrimaryColorBlue),
                        ),
                      ),
                    ),
                    Container(
                      width: size.width * 0.45,
                      padding: EdgeInsets.only(
                          top: 0.0, bottom: 0.0, left: 0.0, right: 0.0),
                      child: TextField(
                        enableInteractiveSelection: false, // will disable paste operation
                        focusNode: new AlwaysDisabledFocusNode(),
                        onTap: () {
                          if(fDateController.text.isEmpty){
                            showInSnackBar("Please select Initial Date");
                            return null;
                          }
                          _selectToDate(context);
                        },
                        controller: tDateController,
                        style: TextStyle(
                            fontFamily: "PoppinsLight",
                            fontSize: 17.0,
                            color: Colors.black87),
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          counterStyle: TextStyle(height: double.minPositive,),
                          counterText: "",
                          contentPadding: const EdgeInsets.symmetric(vertical: 0.0),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: kPrimaryColorBlue,
                                width: 0.5
                            ),
                            borderRadius: const BorderRadius.all(Radius.circular(35.0)),
                          ),
                          focusedBorder: new OutlineInputBorder(
                            borderSide: BorderSide(
                                color: kPrimaryColorBlue,
                                width: 0.5),
                            borderRadius: const BorderRadius.all(Radius.circular(35.0)),
                          ),
                          prefixIcon: Icon(
                            CupertinoIcons.calendar,
                            color: kPrimaryColorBlue,
                            size: 23.0,
                          ),
                          labelText: "To Date *",
                          labelStyle: TextStyle(
                              fontFamily: "PoppinsLight", fontSize: 13.0, color: kPrimaryColorBlue),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(
                height: 10.0,
              ),
              Container(
                width: size.width,
                padding: EdgeInsets.only(left: 20.0),
                child: RichText(
                  text: TextSpan(
                      text: 'Select Audience',
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
              Container(
                width: size.width * 0.95,
                padding: EdgeInsets.only(
                    top: 0.0, bottom: 10.0, left: 0.0, right: 0.0),
                child: Row(
                  children: <Widget>[
                    Container(
                      width: size.width * 0.45,
                      child: RadioListTile(
                        groupValue: radioItem,
                        title: Text('Merchant',style: TextStyle(
                            fontFamily: "PoppinsLight", fontSize: 15.0, color: kPrimaryColorBlue),),

                        value: 'Merchant',
                        onChanged: (val) {
                          setState(() {
                            radioItem = val;
                            custom=true;

                          });
                        },
                      ),
                    ),
                    Container(
                      width: size.width * 0.45,
                      child:RadioListTile(
                        groupValue: radioItem,
                        title: Text('Customer',style: TextStyle(
                            fontFamily: "PoppinsLight", fontSize: 15.0, color: kPrimaryColorBlue),),
                        value: 'Customer',
                        onChanged: (val) {
                          setState(() {
                            custom=false;
                            radioItem = val;
                          });
                        },
                      ),
                    )
                  ],
                ),
              ),
              if(custom)
                Container(
                  width: size.width * 0.95,
                  padding: EdgeInsets.only(
                      top: 10.0, bottom: 10.0, left: 0.0, right: 0.0),
                  child: TextField(
                    keyboardType: TextInputType.text,
                    enableInteractiveSelection:
                    false, // will disable paste operation
                    focusNode: new AlwaysDisabledFocusNode(),
                    controller: catController,
                    onTap: () {
                      showCategoryDialog(context, size);
                    },
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 17,
                      fontStyle: FontStyle.normal,
                      fontWeight: FontWeight.w400,
                    ),
                    decoration: InputDecoration(
                      labelText: "Select Category *",
                      labelStyle: TextStyle(
                        fontFamily: "PoppinsLight",
                        fontSize: 13.0,
                        color: kPrimaryColorBlue,
                      ),
                      border: new OutlineInputBorder(
                        borderSide: new BorderSide(
                            color: Theme.of(context).primaryColor),
                      ),
                      counterText: "",
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 13.0, horizontal: 5),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: kPrimaryColorBlue, width: 0.5),
                        borderRadius: const BorderRadius.all(
                            Radius.circular(35.0)),
                      ),
                      focusedBorder: new OutlineInputBorder(
                        borderSide: BorderSide(
                            color: kPrimaryColorBlue, width: 0.5),
                        borderRadius: const BorderRadius.all(
                            Radius.circular(35.0)),
                      ),

                      prefixIcon: Icon(
                        FontAwesomeIcons.list,
                        color: kPrimaryColorBlue,
                        size: 20.0,
                      ),
                    ),
                  ),
                ),
              //Text('$radioItem', style: TextStyle(fontSize: 23),)
            ],
          ),
        ),
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
  showCategoryDialog(BuildContext context, Size size) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              'Select Category',
              style: TextStyle(
                  color: Colors.black87,
                  fontWeight: FontWeight.w800,
                  fontSize: 15.0,
                  fontFamily: "PoppinsMedium"),
            ),
            content: setupAlertDialoagContainer(size),
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
  Future<GetBillCategory> getCategoryList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString("token");
    final res = await http.post(
      "http://157.230.228.250/get-bill-categories-api/",
      headers: {HttpHeaders.authorizationHeader: "Token $token"},
    );

    print(res.body);
    if (200 == res.statusCode) {
      print(getBillCategoryFromJson(res.body).data.length);
      return getBillCategoryFromJson(res.body);
    } else {
      throw Exception('Failed to load Stores List');
    }
  }
  Widget setupAlertDialoagContainer(Size size) {
    return Container(
      height: size.height * 0.5, // Change as per your requirement
      width: 300.0, // Change as per your requirement
      child: FutureBuilder<GetBillCategory>(
        future: getCategoryList(),
        builder:
            (BuildContext context, AsyncSnapshot<GetBillCategory> snapshot) {
          if (snapshot.connectionState == ConnectionState.done &&
              snapshot.hasData) {
            return Scrollbar(
                radius: Radius.circular(5.0),
                isAlwaysShown: true,
                controller: _controller,
                thickness: 3.0,
                child: ListView.builder(
                    controller: _controller,
                    itemCount: snapshot.data.data.length,
                    itemBuilder: (BuildContext context, int index) {
                      return ListTile(
                        title: Text(snapshot.data.data[index].billCategoryName,
                            style: TextStyle(fontSize: 15.0)),
                        subtitle: Text(
                            snapshot.data.data[index].billCategoryDescription,
                            style: TextStyle(fontSize: 10.0)),
                        leading: Container(
                            width: 35.0,
                            height: 35.0,
                            decoration: new BoxDecoration(
                              color: kPrimaryColorBlue,
                              borderRadius: new BorderRadius.circular(25.0),
                            ),
                            alignment: Alignment.center,
                            child: new Image.network(snapshot.data.data[index].iconUrl, height: 20.0, width: 20.0, color: Colors.white,)
                        ),
                        // trailing: Wrap(
                        //   spacing: 12, // space between two icons
                        //   children: <Widget>[
                        //     Text('Rs. 200'),
                        //     Icon(Icons.call),
                        //     Icon(Icons.message),
                        //   ],
                        // ),
                        onTap: () {
                          setState(() {
                            catController.text =
                                snapshot.data.data[index].billCategoryName;

                          });
                          Navigator.of(context).pop();
                        },
                      );
                    }));
          } else {
            return Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(kPrimaryColorBlue),
                ));
          }
        },
      ),
    );
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

  Future<void> create() async {
    print(catController.text);

    if (_imageFile == null) {
      showInSnackBar("Please select Offer Image");
      return null;
    }

    if(cnController.text.isEmpty){
      showInSnackBar("Please enter Offer Name");
      return null;
    }
    if(ccController.text.isEmpty){
      showInSnackBar("Please enter Offer Caption");
      return null;
    }

    if(fDateController.text.isEmpty){
      showInSnackBar("Please select From Date");
      return null;
    }
    if(tDateController.text.isEmpty){
      showInSnackBar("Please select To Date");
      return null;
    }
    if (radioItem.isEmpty) {
      showInSnackBar("Please select Audience");
      return null;
    }
    if(custom){
      if(catController.text.isEmpty) {
        showInSnackBar("Please select Category");
        return null;
      }
    }


    _showLoaderDialog(context);
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    int userID = prefs.getInt("userID");
    String tokenn = prefs.getString("token");

    //open a byteStream
    // var stream = new http.ByteStream(DelegatingStream.typed(image.openRead()));
    // // get file length
    // var length = await image.length();

    var uri = Uri.parse("http://157.230.228.250/merchant-create-and-update-offers-api/");
    Map<String, String> headers = {"Authorization": "Token $tokenn"};
    // create multipart request
    var request = new http.MultipartRequest("POST", uri);

    http.MultipartFile multipartFile = await http.MultipartFile.fromPath(
        'offer_image', _imageFile.path,
        filename: path.basename(_imageFile.path));
    // add file to multipart
    request.files.add(multipartFile);
    request.fields['merchant_id'] = userID.toString();
    request.fields['offer_id '] = widget.offerId.isEmpty ? "" : widget.offerId;
    request.fields['offer_name'] = cnController.text;
    request.fields['offer_caption'] = ccController.text;
    request.fields['merchant_business_id'] =storeID;
    request.fields['user'] = '$radioItem';
    request.fields['valid_from'] = fDateController.text;
    request.fields['valid_through'] = tDateController.text;
    request.fields['offer_business_category'] = custom? catController.text:"";
    request.headers.addAll(headers);


    // send
    var response = await request.send();
    print(response.statusCode);
    print(response);
    Navigator.of(context, rootNavigator: true).pop();
    if (response.statusCode == 200) {
      print("***********************************************     Submit     *******************************************************");
      Navigator.pop(context, true);
    } else {
      showInSnackBar("Something went wrong!");
    }

    // listen for response
    response.stream.transform(utf8.decoder).listen((value) {
      print(value);
    });
  }

}

class AlwaysDisabledFocusNode extends FocusNode {
  @override
  bool get hasFocus => false;
}