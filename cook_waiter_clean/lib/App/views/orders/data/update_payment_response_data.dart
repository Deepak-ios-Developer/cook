class UpdatePaymentResponseData {
  int? status;
  Data? data;

  UpdatePaymentResponseData({this.status, this.data});

  UpdatePaymentResponseData.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  String? mobilenumber;
  String? fullname;
  String? createdDate;
  String? rountOff;

  Data({this.mobilenumber, this.fullname, this.createdDate, this.rountOff});

  Data.fromJson(Map<String, dynamic> json) {
    mobilenumber = json['mobilenumber'];
    fullname = json['fullname'];
    createdDate = json['created_date'];
    rountOff = json['RountOff'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['mobilenumber'] = this.mobilenumber;
    data['fullname'] = this.fullname;
    data['created_date'] = this.createdDate;
    data['RountOff'] = this.rountOff;
    return data;
  }
}
