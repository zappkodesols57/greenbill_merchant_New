import 'package:flutter/material.dart';
import 'package:greenbill_merchant/src/ui/Promotions/offersList.dart';
import '../../constants.dart';
import 'couponsList.dart';
import 'offerForMerchant.dart';

class TabBarPromotions extends StatelessWidget {
  const TabBarPromotions({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            title: Text('Promotions'),
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

                Tab(text: 'My Coupons'),
                Tab(text: 'My Offers'),
              ],
            ),
          ),
          body: TabBarView(
            children: [

              CouponsList(),
              MyOfferList(),


            ],
          ),
        ),
      ),
    );
  }

}
