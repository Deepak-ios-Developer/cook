class GetAllTabelListResponseData {
  int? status;
  List<Data>? data;

  GetAllTabelListResponseData({this.status, this.data});

  GetAllTabelListResponseData.fromJson(Map<String, dynamic> json) {
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
  String? tableQRID;
  String? tableNo;
  String? seatNo;
  String? fullname;
  String? mobilenumber;
  String? orderNo;
  String? orderqty;
  String? total;
  String? gst;
  Null? starrating;
  Null? feedback;
  String? createdDate;
  Null? updatedDate;
  String? status;
  Null? paymentStatus;
  Null? modeOfPay;

  Data(
      {this.sno,
      this.companyId,
      this.tableQRID,
      this.tableNo,
      this.seatNo,
      this.fullname,
      this.mobilenumber,
      this.orderNo,
      this.orderqty,
      this.total,
      this.gst,
      this.starrating,
      this.feedback,
      this.createdDate,
      this.updatedDate,
      this.status,
      this.paymentStatus,
      this.modeOfPay});

  Data.fromJson(Map<String, dynamic> json) {
    sno = json['sno'];
    companyId = json['Company_Id'];
    tableQRID = json['tableQRID'];
    tableNo = json['tableNo'];
    seatNo = json['seatNo'];
    fullname = json['fullname'];
    mobilenumber = json['mobilenumber'];
    orderNo = json['orderNo'];
    orderqty = json['orderqty'];
    total = json['total'];
    gst = json['gst'];
    starrating = json['starrating'];
    feedback = json['feedback'];
    createdDate = json['created_date'];
    updatedDate = json['updated_date'];
    status = json['status'];
    paymentStatus = json['paymentStatus'];
    modeOfPay = json['modeOfPay'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['sno'] = this.sno;
    data['Company_Id'] = this.companyId;
    data['tableQRID'] = this.tableQRID;
    data['tableNo'] = this.tableNo;
    data['seatNo'] = this.seatNo;
    data['fullname'] = this.fullname;
    data['mobilenumber'] = this.mobilenumber;
    data['orderNo'] = this.orderNo;
    data['orderqty'] = this.orderqty;
    data['total'] = this.total;
    data['gst'] = this.gst;
    data['starrating'] = this.starrating;
    data['feedback'] = this.feedback;
    data['created_date'] = this.createdDate;
    data['updated_date'] = this.updatedDate;
    data['status'] = this.status;
    data['paymentStatus'] = this.paymentStatus;
    data['modeOfPay'] = this.modeOfPay;
    return data;
  }
}
