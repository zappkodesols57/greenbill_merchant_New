import 'package:flutter/material.dart';
import 'package:greenbill_merchant/src/constants.dart';
import 'package:greenbill_merchant/src/ui/MySubcription/mysub.dart';
import 'package:greenbill_merchant/src/ui/MySubcription/subHistory.dart';
import 'package:greenbill_merchant/src/ui/MySubcription/subscription.dart';

class TabBarSub extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            title: Text('Subscription'),
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
                Tab(text: 'Active'),
                Tab(text: 'Recharge'),
                Tab(text: 'History'),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              MySub(),
              Recharge(),
              subHistory(),
            ],
          ),
        ),
      ),
    );
  }
}