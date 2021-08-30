import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:greenbill_merchant/src/constants.dart';
import 'package:greenbill_merchant/src/ui/BillInfo/ReceivedBills.dart';
import 'package:greenbill_merchant/src/ui/BillInfo/RejectedBills.dart';
import 'package:greenbill_merchant/src/ui/BillInfo/SentBills.dart';
import 'package:greenbill_merchant/src/ui/BillInfo/flagBills.dart';
import 'package:shared_preferences/shared_preferences.dart';


class BillsTab extends StatefulWidget {
  final String storeCatID;
  final int length;
  BillsTab(this.storeCatID,this.length);

  @override
  BillsTabState createState() => BillsTabState();
}

class BillsTabState extends State<BillsTab> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  String token, id, storeID,storeCatID;
  String amount="0";
  int totalTran=1;
  int len;
  int subTotal;
  String total;



  @override
  void initState() {
    getCredentials();
    super.initState();


  }

  @override
  void dispose() {
    super.dispose();
  }

  getCredentials() async {
    print(widget.length);
    if(widget.length==4){
        len=4;
    }else {
        len=3;
    }
  }


  @override

  Widget build(BuildContext context) {
    return Scaffold(
      body: DefaultTabController(
      length: len,
        child: Scaffold(
          appBar: AppBar(
            toolbarHeight: 80.0,
            backgroundColor:  kPrimaryColorBlue,
            bottom: TabBar(
              tabs: [
                Tab(icon: Icon(FontAwesomeIcons.exchangeAlt), text: 'Received'),
                Tab(icon: Icon(FontAwesomeIcons.exchangeAlt), text: 'Sent'),
                Tab(icon: Icon(Icons.keyboard_return_outlined), text: 'Rejected'),
                if(len==4)
                Tab(icon: Icon(FontAwesomeIcons.flag), text: 'Flagged'),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              BillIncoming(),
              BillInfo(),
              BillRejected(),
              if(len==4)
              FlagBills(),

            ],
          ),
        ),
      ),
    );
  }






}
