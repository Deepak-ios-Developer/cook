class StatusUpdateRequestData {
  String? curOrderStatus;
  String? sno;
  String? chefId;

  StatusUpdateRequestData({this.curOrderStatus, this.sno = "", this.chefId});

  StatusUpdateRequestData.fromJson(Map<String, dynamic> json) {
    curOrderStatus = json['curOrderStatus'];
    sno = json['sno'];
    chefId = json['curUserId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['curOrderStatus'] = this.curOrderStatus;
    data['sno'] = this.sno;
    data['curUserId'] = this.chefId;
    return data;
  }
}

class StatusUpdateResponseData {
  int? curOrderStatus;
  String? orderid;
  String? mobilenumber;
  String? companyId;
  String? status;

  StatusUpdateResponseData(
      {this.curOrderStatus,
      this.orderid,
      this.mobilenumber,
      this.companyId,
      this.status});

  StatusUpdateResponseData.fromJson(Map<String, dynamic> json) {
    curOrderStatus = json['curOrderStatus'];
    orderid = json['orderid'];
    mobilenumber = json['mobilenumber'];
    companyId = json['CompanyId'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['curOrderStatus'] = this.curOrderStatus;
    data['orderid'] = this.orderid;
    data['mobilenumber'] = this.mobilenumber;
    data['CompanyId'] = this.companyId;
    data['status'] = this.status;
    return data;
  }
}

class OrderDelayRequestData {
  String? orderId;
  String? sno;
  String? chefId;

  OrderDelayRequestData({this.orderId, this.sno = "", this.chefId});

  OrderDelayRequestData.fromJson(Map<String, dynamic> json) {
    orderId = json['orderId'];
    sno = json['sno'];
    chefId = json['curUserId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['orderId'] = this.orderId;
    data['sno'] = this.sno;
    data['curUserId'] = this.chefId;
    return data;
  }
}
