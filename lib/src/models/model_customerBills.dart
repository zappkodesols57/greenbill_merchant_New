// To parse this JSON data, do
//
//     final customerBills = customerBillsFromJson(jsonString);

import 'dart:convert';

CustomerBills customerBillsFromJson(String str) => CustomerBills.fromJson(json.decode(str));

String customerBillsToJson(CustomerBills data) => json.encode(data.toJson());

class CustomerBills {
  CustomerBills({
    this.status,
    this.personalDetails,
    this.allBills,
  });

  String status;
  PersonalDetails personalDetails;
  List<AllBill> allBills;

  factory CustomerBills.fromJson(Map<String, dynamic> json) => CustomerBills(
    status: json["status"],
    personalDetails: PersonalDetails.fromJson(json["personal_details"]),
    allBills: List<AllBill>.from(json["all_bills"].map((x) => AllBill.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "personal_details": personalDetails.toJson(),
    "all_bills": List<dynamic>.from(allBills.map((x) => x.toJson())),
  };
}

class AllBill {
  AllBill({
    this.billId,
    this.mobileNo,
    this.amount,
    this.billDate,
    this.billFile,
    this.dbTable,
    this.newBillUrl,
  });

  int billId;
  String mobileNo;
  String amount;
  String billDate;
  String billFile;
  String dbTable;
  String newBillUrl;

  factory AllBill.fromJson(Map<String, dynamic> json) => AllBill(
    billId: json["bill_id"],
    mobileNo: json["mobile_no"],
    amount: json["amount"],
    billDate: json["bill_date"],
    billFile: json["bill_file"],
    dbTable: json["db_table"],
    newBillUrl: json["new_bill_url"],
  );

  Map<String, dynamic> toJson() => {
    "bill_id": billId,
    "mobile_no": mobileNo,
    "amount": amount,
    "bill_date": billDate,
    "bill_file": billFile,
    "db_table": dbTable,
    "new_bill_url": newBillUrl,
  };
}

class PersonalDetails {
  PersonalDetails({
    this.mobileNo,
    this.firstName,
    this.lastName,
    this.email,
  });

  String mobileNo;
  String firstName;
  String lastName;
  String email;

  factory PersonalDetails.fromJson(Map<String, dynamic> json) => PersonalDetails(
    mobileNo: (json["mobile_no"].toString().isEmpty) ? "--//--" : json["mobile_no"],
    firstName: (json["first_name"].toString().isEmpty) ? "--//--" : json["first_name"],
    lastName: json["last_name"],
    email: (json["email"].toString().isEmpty) ? "--//--" : json["email"],
  );

  Map<String, dynamic> toJson() => {
    "mobile_no": mobileNo,
    "first_name": firstName,
    "last_name": lastName,
    "email": email,
  };
}
