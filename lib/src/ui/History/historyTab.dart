import 'package:flutter/material.dart';
import 'package:greenbill_merchant/src/constants.dart';
import 'package:greenbill_merchant/src/ui/History/paymentHistory.dart';
import 'package:greenbill_merchant/src/ui/drawer/ReceivedPayments/receivedPayments.dart';
class HistoryTab extends StatelessWidget {
  const HistoryTab({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(

            // elevation: 0,
            toolbarHeight: 50.0,
            backgroundColor:  kPrimaryColorBlue,
            bottom: TabBar(
              tabs: [
                Tab(text: 'Payment History'),
                Tab(text: 'Received Payments'),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              History(),
              ReceivedPayments(),
            ],
          ),
        ),
      ),
    );
  }
}