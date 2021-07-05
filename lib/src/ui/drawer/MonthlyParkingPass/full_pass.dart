import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../../../constants.dart';
import 'package:greenbill_merchant/src/models/model_monthlyPass.dart';

class FullPass extends StatefulWidget {
  final Datum data;
  FullPass(this.data);

  @override
  FullPassState createState() => FullPassState();
}

class FullPassState extends State<FullPass> {

  TextEditingController idController = new TextEditingController();
  TextEditingController vehNoController = new TextEditingController();
  TextEditingController compController = new TextEditingController();
  TextEditingController expController = new TextEditingController();
  TextEditingController amtController = new TextEditingController();

  @override
  void initState() {
    super.initState();
    idController.text = widget.data.id.toString();
    vehNoController.text = widget.data.vehicalNo;
    compController.text = widget.data.companyName;
    expController.text = widget.data.validTo;
    amtController.text = widget.data.amount;
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(
          title: Text("View Pass"),
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                width: size.width * 0.99,
                padding: EdgeInsets.only(
                    top: 20.0, bottom: 0.0, left: 20.0, right: 25.0),
                child: Text(
                  "Show this QR Code to Cashier",
                  style: TextStyle(
                    color: Colors.black,
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.bold,
                    fontSize: 20.0,
                    fontFamily: "PoppinsMedium",
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: 10.0,),
              Card(
                elevation: 5.0,
                shadowColor: kPrimaryColor,
                child: QrImage(
                  data: "GreenBill~Parking Pass~${widget.data.id}~${widget.data.businessName}~${widget.data.businessLogo}~${widget.data.mobileNo}~${widget.data.amount}~${widget.data.vehicalNo}~${widget.data.validFrom}~${widget.data.validTo}~${widget.data.comments}~${widget.data.createdAt}~${widget.data.passType}~${widget.data.companyId}~${widget.data.companyName}",
                  version: QrVersions.auto,
                  size: 300.0,
                  foregroundColor: kPrimaryColorBlue,
                  embeddedImage: AssetImage('assets/logo/logo.png'),
                  embeddedImageStyle: QrEmbeddedImageStyle(
                    size: Size(40, 40),
                  ),
                ),
              ),
              Container(
                width: size.width * 0.99,
                padding: EdgeInsets.only(
                    top: 10.0, bottom: 10.0, left: 20.0, right: 20.0),
                child: Center(
                  child: Text(
                    "Parking Pass Details",
                    style: TextStyle(
                      color: Colors.black,
                      fontStyle: FontStyle.normal,
                      fontWeight: FontWeight.bold,
                      fontSize: 15.0,
                      decoration: TextDecoration.underline,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.only(
                    top: 10.0, bottom: 10.0, left: 0.0, right: 0.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      width: size.width * 0.45,
                      padding: EdgeInsets.only(
                          top: 0.0, bottom: 0.0, left: 0.0, right: 0.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: new TextField(
                        controller: idController,
                        enableInteractiveSelection: false, // will disable paste operation
                        focusNode: new AlwaysDisabledFocusNode(),
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: size.height * 0.019,
                          fontStyle: FontStyle.normal,
                          fontWeight: FontWeight.w400,
                        ),
                        decoration: InputDecoration(
                          prefixIcon: Icon(
                            Icons.credit_card_rounded,
                            color: Color(0xFF00569D),
                          ),
                          labelText: "Pass ID",
                          labelStyle: TextStyle(
                              fontFamily: "PoppinsLight",
                              fontSize: 18.0,
                              color: Color(0xFF00569D)),
                          border: InputBorder.none,
                          counterStyle: TextStyle(
                            height: double.minPositive,
                          ),
                          counterText: "",
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 13.0, horizontal: 5),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: kPrimaryColorBlue,
                                width: 0.5),
                            borderRadius:
                            const BorderRadius.all(Radius.circular(35.0)),
                          ),
                          focusedBorder: new OutlineInputBorder(
                            borderSide: BorderSide(
                                color: kPrimaryColorBlue,
                                width: 0.5),
                            borderRadius:
                            const BorderRadius.all(Radius.circular(35.0)),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      width: size.width * 0.45,
                      padding: EdgeInsets.only(
                          top: 0.0, bottom: 0.0, left: 0.0, right: 0.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: new TextField(
                        controller: vehNoController,
                        enableInteractiveSelection:
                        false, // will disable paste operation
                        focusNode: new AlwaysDisabledFocusNode(),
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: size.height * 0.019,
                          fontStyle: FontStyle.normal,
                          fontWeight: FontWeight.w400,
                        ),
                        decoration: InputDecoration(
                          prefixIcon: Icon(
                            Icons.pedal_bike_rounded,
                            color: Color(0xFF00569D),
                          ),
                          labelText: "Vehicle No.",
                          labelStyle: TextStyle(
                              fontFamily: "PoppinsLight",
                              fontSize: 18.0,
                              color: Color(0xFF00569D)),
                          border: InputBorder.none,
                          counterStyle: TextStyle(
                            height: double.minPositive,
                          ),
                          counterText: "",
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 13.0, horizontal: 5),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: kPrimaryColorBlue,
                                width: 0.5),
                            borderRadius:
                            const BorderRadius.all(Radius.circular(35.0)),
                          ),
                          focusedBorder: new OutlineInputBorder(
                            borderSide: BorderSide(
                                color: kPrimaryColorBlue,
                                width: 0.5),
                            borderRadius:
                            const BorderRadius.all(Radius.circular(35.0)),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.only(
                    top: 0.0, bottom: 10.0, left: 0.0, right: 0.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      width: size.width * 0.45,
                      padding: EdgeInsets.only(
                          top: 0.0, bottom: 0.0, left: 0.0, right: 0.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: new TextField(
                        controller: amtController,
                        enableInteractiveSelection:
                        false, // will disable paste operation
                        focusNode: new AlwaysDisabledFocusNode(),
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: size.height * 0.019,
                          fontStyle: FontStyle.normal,
                          fontWeight: FontWeight.w400,
                        ),
                        decoration: InputDecoration(
                          prefixIcon: Icon(
                            FontAwesomeIcons.rupeeSign,
                            color: Color(0xFF00569D),
                          ),
                          labelText: "Amount",
                          labelStyle: TextStyle(
                              fontFamily: "PoppinsLight",
                              fontSize: 18.0,
                              color: Color(0xFF00569D)),
                          border: InputBorder.none,
                          counterStyle: TextStyle(
                            height: double.minPositive,
                          ),
                          counterText: "",
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 13.0, horizontal: 5),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: kPrimaryColorBlue,
                                width: 0.5),
                            borderRadius:
                            const BorderRadius.all(Radius.circular(35.0)),
                          ),
                          focusedBorder: new OutlineInputBorder(
                            borderSide: BorderSide(
                                color: kPrimaryColorBlue,
                                width: 0.5),
                            borderRadius:
                            const BorderRadius.all(Radius.circular(35.0)),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      width: size.width * 0.45,
                      padding: EdgeInsets.only(
                          top: 0.0, bottom: 0.0, left: 0.0, right: 0.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: new TextField(
                        controller: expController,
                        enableInteractiveSelection:
                        false, // will disable paste operation
                        focusNode: new AlwaysDisabledFocusNode(),
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: size.height * 0.019,
                          fontStyle: FontStyle.normal,
                          fontWeight: FontWeight.w400,
                        ),
                        decoration: InputDecoration(
                          prefixIcon: Icon(
                            Icons.calendar_today,
                            color: Color(0xFF00569D),
                          ),
                          labelText: "Valid Till",
                          labelStyle: TextStyle(
                              fontFamily: "PoppinsLight",
                              fontSize: 18.0,
                              color: Color(0xFF00569D)),
                          border: InputBorder.none,
                          counterStyle: TextStyle(
                            height: double.minPositive,
                          ),
                          counterText: "",
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 13.0, horizontal: 5),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: kPrimaryColorBlue,
                                width: 0.5),
                            borderRadius:
                            const BorderRadius.all(Radius.circular(35.0)),
                          ),
                          focusedBorder: new OutlineInputBorder(
                            borderSide: BorderSide(
                                color: kPrimaryColorBlue,
                                width: 0.5),
                            borderRadius:
                            const BorderRadius.all(Radius.circular(35.0)),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: size.width * 0.95,
                padding: EdgeInsets.only(
                    top: 0.0, bottom: 10.0, left: 0.0, right: 0.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                ),
                child: new TextField(
                  controller: compController,
                  enableInteractiveSelection:
                  false, // will disable paste operation
                  focusNode: new AlwaysDisabledFocusNode(),
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: size.height * 0.019,
                    fontStyle: FontStyle.normal,
                    fontWeight: FontWeight.w400,
                  ),
                  decoration: InputDecoration(
                    prefixIcon: Icon(
                      Icons.location_city,
                      color: Color(0xFF00569D),
                    ),
                    labelText: "Company",
                    labelStyle: TextStyle(
                        fontFamily: "PoppinsLight",
                        fontSize: 18.0,
                        color: Color(0xFF00569D)),
                    border: InputBorder.none,
                    counterStyle: TextStyle(
                      height: double.minPositive,
                    ),
                    counterText: "",
                    contentPadding: const EdgeInsets.symmetric(vertical: 13.0, horizontal: 5),
                    enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: kPrimaryColorBlue, width: 0.5),
                      borderRadius: const BorderRadius.all(Radius.circular(35.0)),
                    ),
                    focusedBorder: new OutlineInputBorder(
                      borderSide: BorderSide(color: kPrimaryColorBlue, width: 0.5),
                      borderRadius: const BorderRadius.all(Radius.circular(35.0)),
                    ),
                  ),
                ),
              ),
            ],
          ),
        )
    );
  }
}

class AlwaysDisabledFocusNode extends FocusNode {
  @override
  bool get hasFocus => false;
}

