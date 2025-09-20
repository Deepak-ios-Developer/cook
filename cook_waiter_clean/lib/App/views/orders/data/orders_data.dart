class OrderListResponseData {
  int? status;
  Data? data;

  OrderListResponseData({this.status, this.data});

  OrderListResponseData.fromJson(Map<String, dynamic> json) {
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
  List<TableList>? tableList;
  List<OrderList>? orderList;

  Data({this.tableList, this.orderList});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['tableList'] != null) {
      tableList = <TableList>[];
      json['tableList'].forEach((v) {
        tableList!.add(new TableList.fromJson(v));
      });
    }
    if (json['orderList'] != null) {
      orderList = <OrderList>[];
      json['orderList'].forEach((v) {
        orderList!.add(new OrderList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.tableList != null) {
      data['tableList'] = this.tableList!.map((v) => v.toJson()).toList();
    }
    if (this.orderList != null) {
      data['orderList'] = this.orderList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class TableList {
  String? tableNo;

  TableList({this.tableNo});

  TableList.fromJson(Map<String, dynamic> json) {
    tableNo = json['tableNo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['tableNo'] = this.tableNo;
    return data;
  }
}

class OrderList {
  String? categoryType;
  String? categoryName;
  String? productName;
  String? status;
  String? companyId;
  String? tableNo;
  String? seatNo;
  String? orderType;
  String? orderNo;
  String? orderqty;
  String? sno;
  String? createdDate;
  dynamic? updatedDate;
  String? orderItemNo;
  String? quantity;
  String? time;
  dynamic? orderStatus;
  String? orderStatusCode;
  String? chefId;

  OrderList(
      {this.categoryType,
      this.categoryName,
      this.productName,
      this.status,
      this.companyId,
      this.tableNo,
      this.seatNo,
      this.orderType,
      this.orderNo,
      this.orderqty,
      this.sno,
      this.createdDate,
      this.updatedDate,
      this.orderItemNo,
      this.quantity,
      this.time,
      this.orderStatus,
      this.chefId,
      this.orderStatusCode});

  OrderList.fromJson(Map<String, dynamic> json) {
    categoryType = json['CategoryType'];
    categoryName = json['CategoryName'];
    productName = json['ProductName'];
    status = json['status'];
    companyId = json['Company_Id'];
    tableNo = json['tableNo'];
    seatNo = json['seatNo'];
    orderType = json['orderType'];
    orderNo = json['orderNo'];
    orderqty = json['orderqty'];
    sno = json['sno'];
    createdDate = json['created_date'];
    updatedDate = json['updated_date'];
    orderItemNo = json['orderItemNo'];
    quantity = json['quantity'];
    time = json['CookTime'];
    orderStatus = json['orderStatus'];
    orderStatusCode = json['orderStatusCode'];
    chefId = json['updated_by'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['CategoryType'] = this.categoryType;
    data['CategoryName'] = this.categoryName;
    data['ProductName'] = this.productName;
    data['status'] = this.status;
    data['Company_Id'] = this.companyId;
    data['tableNo'] = this.tableNo;
    data['seatNo'] = this.seatNo;
    data['orderType'] = this.orderType;
    data['orderNo'] = this.orderNo;
    data['orderqty'] = this.orderqty;
    data['sno'] = this.sno;
    data['created_date'] = this.createdDate;
    data['updated_date'] = this.updatedDate;
    data['orderItemNo'] = this.orderItemNo;
    data['quantity'] = this.quantity;
    data['CookTime'] = this.time;
    data['orderStatus'] = this.orderStatus;
    data['orderStatusCode'] = this.orderStatusCode;
    data['updated_by'] = this.chefId;

    return data;
  }
}
