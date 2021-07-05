import 'package:flutter/material.dart';
import 'package:greenbill_merchant/src/constants.dart';
import 'package:greenbill_merchant/src/ui/drawer/cashMemoReceipts/CashMemoList.dart';
import 'package:greenbill_merchant/src/ui/drawer/cashMemoReceipts/receipt.dart';

class TabBarMemo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            title: Text('Cash Memo & Receipt'),
            elevation: 0,
            leading: IconButton(
              icon: Icon(Icons.arrow_back_ios),
              onPressed: () {
                Navigator.pop(context, false);
              },
            ),
            toolbarHeight: 110.0,
            backgroundColor:  kPrimaryColorBlue,
            bottom: TabBar(
              tabs: [
                Tab(text: 'Cash Memo'),
                Tab(text: 'Receipt'),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              CashMemoList(),
              Receipt(),
            ],
          ),
        ),
      ),
    );
  }
}