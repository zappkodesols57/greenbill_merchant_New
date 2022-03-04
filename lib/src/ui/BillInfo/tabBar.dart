import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:greenbill_merchant/src/constants.dart';
import 'package:greenbill_merchant/src/ui/BillInfo/ReceivedBills.dart';
import 'package:greenbill_merchant/src/ui/BillInfo/RejectedBills.dart';
import 'package:greenbill_merchant/src/ui/BillInfo/SentBills.dart';
import 'package:greenbill_merchant/src/ui/BillInfo/flagBills.dart';


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
            toolbarHeight: 55.0,
            backgroundColor: kPrimaryColorBlue,
            bottom: TabBar(
              labelPadding: EdgeInsets.all(2.0),
              tabs: [
                Container(
                    height: 45,
                    child: Tab(icon: Icon(FontAwesomeIcons.exchangeAlt,size: 18), text: 'Sent',iconMargin: EdgeInsets.only(bottom: 1.0))),
                Container(
                    height: 45,
                    child: Tab(icon: Icon(FontAwesomeIcons.exchangeAlt,size: 18), text: 'Received',iconMargin: EdgeInsets.only(bottom: 1.0))),
                Container(
                    height: 45,
                    child: Tab(icon: Icon(Icons.keyboard_return_outlined,size: 20), text: 'Rejected',iconMargin: EdgeInsets.only(bottom: 1.0))),
                if(length==4)
                Container(
                    height: 45,
                    child: Tab(icon: Icon(FontAwesomeIcons.flag,size: 18), text: 'Flagged',iconMargin: EdgeInsets.only(bottom: 1.0))),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              BillInfo(),
              BillIncoming(),
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
