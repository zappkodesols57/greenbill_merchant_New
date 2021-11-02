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
              SizedBox(height:10.0),
              Center(
                child: Container(
                  padding: EdgeInsets.all(10.0),
                  width: size.width * 0.95,
                  height: 580.0,
                  decoration: BoxDecoration(
                      border: Border.all(
                          width: 15.0,
                          color: kPrimaryColorBlue
                      ),
                      borderRadius: BorderRadius.all(
                          Radius.circular(25.0)
                      )
                  ),

                  child: Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                            border: Border.all(
                                width: 0.5,
                                color: kPrimaryColorBlue
                            ),
                            borderRadius: BorderRadius.all(
                                Radius.circular(10.0)
                            )
                        ),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Center(
                                child: Text("PARKING PASS",
                                  style: TextStyle(
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: "PoppinsMedium",
                                      color: kPrimaryColorBlue
                                  ),
                                ),
                              ),
                            ),
                            Center(
                              child: Text(widget.data.businessName,
                                style: TextStyle(
                                  // fontWeight: FontWeight.bold,
                                    fontFamily: "PoppinsMedium",
                                    color: kPrimaryColorBlue
                                ),
                              ),
                            ),
                            SizedBox(height: 10.0,),
                          ],
                        ),
                      ),
                      SizedBox(height: 20.0,),
                      Container(
                        height: 430.0,
                        decoration: BoxDecoration(
                            color: kPrimaryColorBlue,
                            border: Border.all(
                                width: 0.5,
                                color: kPrimaryColorBlue
                            ),
                            borderRadius: BorderRadius.all(
                                Radius.circular(10.0)
                            )
                        ),
                        child: Column(
                          children: [
                            Container(
                              margin: EdgeInsets.only(left: 5.0,right: 5.0,top: 15.0,bottom: 0.0),
                              width: size.width * 0.90,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  Container(
                                    alignment: Alignment.center,
                                    width: size.width * 0.30,
                                    child: Text("Pass ID",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontFamily: "PoppinsMedium",
                                          color: Colors.white
                                      ),
                                    ),
                                  ),
                                  Center(
                                    child: Container(
                                      padding: EdgeInsets.all(5.0),
                                      alignment: Alignment.center,
                                      width: size.width * 0.40,
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(5.0)
                                          ),
                                          color: Colors.white
                                      ),
                                      child: Text(widget.data.id.toString(),
                                        style: TextStyle(
                                          // fontWeight: FontWeight.bold,
                                          fontFamily: "PoppinsMedium",
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 10.0,),
                            Container(
                              margin: EdgeInsets.only(left: 5.0,right: 5.0,top: 10.0,bottom: 0.0),
                              width: size.width * 0.90,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  Container(
                                    alignment: Alignment.center,
                                    width: size.width * 0.30,
                                    child: Text("Vehicle No.",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontFamily: "PoppinsMedium",
                                          color: Colors.white
                                      ),
                                    ),
                                  ),
                                  Center(
                                    child: Container(
                                      padding: EdgeInsets.all(5.0),
                                      alignment: Alignment.center,
                                      width: size.width * 0.40,
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(5.0)
                                          ),
                                          color: Colors.white
                                      ),
                                      child: Text(widget.data.vehicalNo.toString(),
                                        style: TextStyle(
                                          // fontWeight: FontWeight.bold,
                                          fontFamily: "PoppinsMedium",
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ), SizedBox(height: 10.0,),
                            Container(
                              margin: EdgeInsets.only(left: 5.0,right: 5.0,top: 10.0,bottom: 0.0),
                              width: size.width * 0.90,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  Container(
                                    alignment: Alignment.center,
                                    width: size.width * 0.30,
                                    child: Text("Valid Till",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontFamily: "PoppinsMedium",
                                          color: Colors.white
                                      ),
                                    ),
                                  ),
                                  Center(
                                    child: Container(
                                      padding: EdgeInsets.all(5.0),
                                      alignment: Alignment.center,
                                      width: size.width * 0.40,
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(5.0)
                                          ),
                                          color: Colors.white
                                      ),
                                      child: Text(widget.data.validTo.toString(),
                                        style: TextStyle(
                                          // fontWeight: FontWeight.bold,
                                          fontFamily: "PoppinsMedium",
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 10.0,),
                            Container(
                              margin: EdgeInsets.only(left: 5.0,right: 5.0,top: 10.0,bottom: 0.0),
                              width: size.width * 0.90,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  Container(
                                    alignment: Alignment.center,
                                    width: size.width * 0.30,
                                    child: Text("Company",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontFamily: "PoppinsMedium",
                                          color: Colors.white
                                      ),
                                    ),
                                  ),
                                  Center(
                                    child: Container(
                                      padding: EdgeInsets.all(5.0),
                                      alignment: Alignment.center,
                                      width: size.width * 0.40,
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(5.0)
                                          ),
                                          color: Colors.white
                                      ),
                                      child: Text(widget.data.companyName.toString(),
                                        style: TextStyle(
                                          // fontWeight: FontWeight.bold,
                                          fontFamily: "PoppinsMedium",
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 10.0,),
                            Container(
                              margin: EdgeInsets.only(left: 5.0,right: 5.0,top: 10.0,bottom: 0.0),
                              width: size.width * 0.90,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  Container(
                                    alignment: Alignment.center,
                                    width: size.width * 0.30,
                                    child: Text("QR Code",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontFamily: "PoppinsMedium",
                                          color: Colors.white
                                      ),
                                    ),
                                  ),
                                  Center(
                                    child: Container(
                                      padding: EdgeInsets.all(5.0),
                                      alignment: Alignment.center,
                                      width: size.width * 0.40,
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(5.0)
                                          ),
                                          color: Colors.white
                                      ),
                                      child: QrImage(
                                        data: "GreenBill~Parking Pass~${widget.data.id}~${widget.data.businessName}~${widget.data.businessLogo}~${widget.data.mobileNo}~${widget.data.amount}~${widget.data.vehicalNo}~${widget.data.validFrom}~${widget.data.validTo}~${widget.data.comments}~${widget.data.createdAt}~${widget.data.passType}~${widget.data.companyId}~${widget.data.companyName}",
                                        version: QrVersions.auto,
                                        size: 130.0,
                                        // foregroundColor: kPrimaryColorBlue,
                                        // embeddedImage: AssetImage('assets/logo/logo.png'),
                                        // embeddedImageStyle: QrEmbeddedImageStyle(
                                        //   size: Size(40, 40),
                                        // ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 10.0,),
                            Container(
                              margin: EdgeInsets.only(left: 5.0,right: 5.0,top: 10.0,bottom: 0.0),
                              width: size.width * 0.90,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  Container(
                                    alignment: Alignment.center,
                                    width: size.width * 0.30,
                                    child: Text("Cost",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontFamily: "PoppinsMedium",
                                          color: Colors.white
                                      ),
                                    ),
                                  ),
                                  Center(
                                    child: Container(
                                      padding: EdgeInsets.all(5.0),
                                      alignment: Alignment.center,
                                      width: size.width * 0.40,
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(5.0)
                                          ),
                                          color: Colors.white
                                      ),
                                      child: Text(widget.data.amount.toString(),
                                        style: TextStyle(
                                          // fontWeight: FontWeight.bold,
                                          fontFamily: "PoppinsMedium",
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 10.0,),
                          ],
                        ),
                      ),
                    ],
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

