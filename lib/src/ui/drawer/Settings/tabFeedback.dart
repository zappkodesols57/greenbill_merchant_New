import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:greenbill_merchant/src/constants.dart';
import 'package:greenbill_merchant/src/ui/drawer/Settings/feedback.dart';

import 'Help&Support/reviews.dart';

class FeedTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            toolbarHeight: 80.0,
            backgroundColor:  kPrimaryColorBlue,
            bottom: TabBar(
              tabs: [
                Tab( text:'Feedback'),
                Tab( text:'Rating'),

              ],
            ),
          ),
          body: TabBarView(
            children: [
              Feedback1(),
             Reviews(),

            ],
          ),
        ),
      ),
    );
  }
}