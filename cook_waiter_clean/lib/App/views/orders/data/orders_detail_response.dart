class OrderDetailResponseData {
  int? status;
  Data? data;

  OrderDetailResponseData({this.status, this.data});

  OrderDetailResponseData.fromJson(Map<String, dynamic> json) {
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
  List<ProductList>? productList;
  PriceDetails? priceDetails;
  PaymentInfo? paymentInfo;
  UserInfo? userInfo;
  dynamic restroInfo;

  Data(
      {this.productList,
      this.priceDetails,
      this.paymentInfo,
      this.userInfo,
      this.restroInfo});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['ProductList'] != null) {
      productList = <ProductList>[];
      json['ProductList'].forEach((v) {
        productList!.add(new ProductList.fromJson(v));
      });
    }
    priceDetails = json['PriceDetails'] != null
        ? new PriceDetails.fromJson(json['PriceDetails'])
        : null;
    paymentInfo = json['PaymentInfo'] != null
        ? new PaymentInfo.fromJson(json['PaymentInfo'])
        : null;
    userInfo = json['UserInfo'] != null
        ? new UserInfo.fromJson(json['UserInfo'])
        : null;
    restroInfo = json['RestroInfo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.productList != null) {
      data['ProductList'] = this.productList!.map((v) => v.toJson()).toList();
    }
    if (this.priceDetails != null) {
      data['PriceDetails'] = this.priceDetails!.toJson();
    }
    if (this.paymentInfo != null) {
      data['PaymentInfo'] = this.paymentInfo!.toJson();
    }
    if (this.userInfo != null) {
      data['UserInfo'] = this.userInfo!.toJson();
    }
    data['RestroInfo'] = this.restroInfo;
    return data;
  }
}

class ProductList {
  dynamic? sno;
  dynamic? orderItemNo;
  dynamic? quantity;
  dynamic? time;
  dynamic? orderStatus;
  dynamic? orderStatusCode;
  dynamic? cookTime;
  dynamic? categoryType;
  dynamic? categoryName;
      dynamic? productName;
  dynamic? productPrice;

  ProductList(
      {this.sno,
      this.orderItemNo,
      this.quantity,
      this.time,
      this.orderStatus,
      this.orderStatusCode,
      this.cookTime,
      this.categoryType,
      this.categoryName,
      this.productName,
      this.productPrice});

  ProductList.fromJson(Map<String, dynamic> json) {
    sno = json['sno'];
    orderItemNo = json['orderItemNo'];
    quantity = json['quantity'];
    time = json['time'];
    orderStatus = json['orderStatus'];
    orderStatusCode = json['orderStatusCode'];
    cookTime = json['CookTime'];
    categoryType = json['CategoryType'];
    categoryName = json['CategoryName'];
    productName = json['ProductName'];
    productPrice = json['ProductPrice'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['sno'] = this.sno;
    data['orderItemNo'] = this.orderItemNo;
    data['quantity'] = this.quantity;
    data['time'] = this.time;
    data['orderStatus'] = this.orderStatus;
    data['orderStatusCode'] = this.orderStatusCode;
    data['CookTime'] = this.cookTime;
    data['CategoryType'] = this.categoryType;
    data['CategoryName'] = this.categoryName;
    data['ProductName'] = this.productName;
    data['ProductPrice'] = this.productPrice;
    return data;
  }
}

class PriceDetails {
  dynamic? gSTPercentage;
  dynamic? gSTAmount;
  dynamic? totalPrice;
  dynamic? discountPercentage;
    dynamic? discountAmount;
  dynamic? grandTotal;
  dynamic? roundedGrandTotal;

  PriceDetails(
      {this.gSTPercentage,
      this.gSTAmount,
      this.totalPrice,
      this.discountPercentage,
      this.discountAmount,
      this.grandTotal,
      this.roundedGrandTotal});

  PriceDetails.fromJson(Map<String, dynamic> json) {
    gSTPercentage = json['GSTPercentage'];
    gSTAmount = json['GSTAmount'];
    totalPrice = json['totalPrice'];
    discountPercentage = json['DiscountPercentage'];
    discountAmount = json['DiscountAmount'];
    grandTotal = json['GrandTotal'];
    roundedGrandTotal = json['RoundedGrandTotal'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['GSTPercentage'] = this.gSTPercentage;
    data['GSTAmount'] = this.gSTAmount;
    data['totalPrice'] = this.totalPrice;
    data['DiscountPercentage'] = this.discountPercentage;
    data['DiscountAmount'] = this.discountAmount;
    data['GrandTotal'] = this.grandTotal;
    data['RoundedGrandTotal'] = this.roundedGrandTotal;
    return data;
  }
}

class PaymentInfo {
  dynamic? paymentStatus;
  dynamic? modeOfPay;
  dynamic? payRefNo;
  dynamic? updatedDate;

  PaymentInfo(
      {this.paymentStatus, this.modeOfPay, this.payRefNo, this.updatedDate});

  PaymentInfo.fromJson(Map<String, dynamic> json) {
    paymentStatus = json['paymentStatus'];
    modeOfPay = json['modeOfPay'];
    payRefNo = json['payRefNo'];
    updatedDate = json['Updated_date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['paymentStatus'] = this.paymentStatus;
    data['modeOfPay'] = this.modeOfPay;
    data['payRefNo'] = this.payRefNo;
    data['Updated_date'] = this.updatedDate;
    return data;
  }
}

class UserInfo {
  dynamic? orderNo;
  dynamic? companyId;
  dynamic? fullname;
  dynamic? mobilenumber;
  dynamic? tableNo;
  dynamic? seatNo;

  UserInfo(
      {this.orderNo,
      this.companyId,
      this.fullname,
      this.mobilenumber,
      this.tableNo,
      this.seatNo});

  UserInfo.fromJson(Map<String, dynamic> json) {
    orderNo = json['orderNo'];
    companyId = json['Company_Id'];
    fullname = json['fullname'];
    mobilenumber = json['mobilenumber'];
    tableNo = json['tableNo'];
    seatNo = json['seatNo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['orderNo'] = this.orderNo;
    data['Company_Id'] = this.companyId;
    data['fullname'] = this.fullname;
    data['mobilenumber'] = this.mobilenumber;
    data['tableNo'] = this.tableNo;
    data['seatNo'] = this.seatNo;
    return data;
  }
}
