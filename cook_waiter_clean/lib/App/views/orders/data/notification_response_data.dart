class NotificationResponseData {
  int? status;
  List<Data>? data;

  NotificationResponseData({this.status, this.data});

  NotificationResponseData.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  String? sno;
  String? companyId;
  String? tableNo;
  String? seatNo;
  String? fullname;
  String? mobilenumber;
  String? orderNo;
  String? createdDate;
  String? updatedDate;
  String? paymentStatus;
  String? modeOfPay;

  Data(
      {this.sno,
      this.companyId,
      this.tableNo,
      this.seatNo,
      this.fullname,
      this.mobilenumber,
      this.orderNo,
      this.createdDate,
      this.updatedDate,
      this.paymentStatus,
      this.modeOfPay});

  Data.fromJson(Map<String, dynamic> json) {
    sno = json['sno'];
    companyId = json['Company_Id'];
    tableNo = json['tableNo'];
    seatNo = json['seatNo'];
    fullname = json['fullname'];
    mobilenumber = json['mobilenumber'];
    orderNo = json['orderNo'];
    createdDate = json['Created_Date'];
    updatedDate = json['Updated_date'];
    paymentStatus = json['paymentStatus'];
    modeOfPay = json['modeOfPay'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['sno'] = this.sno;
    data['Company_Id'] = this.companyId;
    data['tableNo'] = this.tableNo;
    data['seatNo'] = this.seatNo;
    data['fullname'] = this.fullname;
    data['mobilenumber'] = this.mobilenumber;
    data['orderNo'] = this.orderNo;
    data['Created_Date'] = this.createdDate;
    data['Updated_date'] = this.updatedDate;
    data['paymentStatus'] = this.paymentStatus;
    data['modeOfPay'] = this.modeOfPay;
    return data;
  }
}
