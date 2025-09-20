class OrderDelayRequestData {
  String? orderId;
  String? sno;

  OrderDelayRequestData({this.orderId, this.sno});

  OrderDelayRequestData.fromJson(Map<String, dynamic> json) {
    orderId = json['orderId'];
    sno = json['sno'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['orderId'] = this.orderId;
    data['sno'] = this.sno;
    return data;
  }
}
