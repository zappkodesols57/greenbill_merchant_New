import 'package:flutter/material.dart';
import 'package:greenbill_merchant/src/constants.dart';
import 'package:greenbill_merchant/src/models/model_hSupportData.dart';
import 'package:readmore/readmore.dart';
import 'package:shared_preferences/shared_preferences.dart';


class Faqs extends StatefulWidget {
  final List<Faq> faqs;
  Faqs(this.faqs);

  @override
  _FaqsState createState() => _FaqsState();
}

class _FaqsState extends State<Faqs> {
  String store;
  getCredentials() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      store = prefs.getString("businessName");
    });
  }

  @override
  void initState() {
    getCredentials();
    super.initState();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Faqs'),
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: ListView.builder(
          itemCount: widget.faqs.length,
          shrinkWrap: true,
          reverse: true,
          itemBuilder: (BuildContext context, int index) {
            return Card(
              elevation: 1.0,
              child: ListTile(
                dense: false,
                title: Text(widget.faqs[index].question, style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold, color: Colors.black)),
                subtitle: Text(
                  widget.faqs[index].answer,
                  style: TextStyle(color: Colors.black),
                ),
              ),
            );
          }),
    );
  }

}