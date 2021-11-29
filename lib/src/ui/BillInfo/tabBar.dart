import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:greenbill_merchant/src/constants.dart';
import 'package:greenbill_merchant/src/ui/BillInfo/ReceivedBills.dart';
import 'package:greenbill_merchant/src/ui/BillInfo/RejectedBills.dart';
import 'package:greenbill_merchant/src/ui/BillInfo/SentBills.dart';
import 'package:greenbill_merchant/src/ui/BillInfo/flagBills.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BillsTab extends StatelessWidget {
  final String storeCatID;
  final int length;
  final int tabSelected;
  BillsTab(this.storeCatID,this.length,this.tabSelected);

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  String token, id, storeID;


  @override

  Widget build(BuildContext context) {
    return Scaffold(
      body: DefaultTabController(
        initialIndex: tabSelected,
      length: length,
        child: Scaffold(
          appBar: AppBar(
            toolbarHeight: 80.0,
            backgroundColor:  kPrimaryColorBlue,
            bottom: TabBar(
              tabs: [
                Tab(icon: Icon(FontAwesomeIcons.exchangeAlt), text: 'Received'),
                Tab(icon: Icon(FontAwesomeIcons.exchangeAlt), text: 'Sent'),
                Tab(icon: Icon(Icons.keyboard_return_outlined), text: 'Rejected'),
                if(length==4)
                Tab(icon: Icon(FontAwesomeIcons.flag), text: 'Flagged'),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              BillIncoming(),
              BillInfo(),
              BillRejected(),
              if(length==4)
              FlagBills(),
            ],
          ),
        ),
      ),
    );
  }
}
