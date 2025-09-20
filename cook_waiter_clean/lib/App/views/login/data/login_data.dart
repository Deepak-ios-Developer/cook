
class LoginRequestData {
  String? email;
  String? password;

  LoginRequestData({this.email, this.password});

  LoginRequestData.fromJson(Map<String, dynamic> json) {
    email = json['email'];
    password = json['password'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['email'] = this.email;
    data['password'] = this.password;
    return data;
  }
}
class LoginResponseData {
  int? status;
  dynamic? data;

  LoginResponseData({this.status, this.data});

  LoginResponseData.fromJson(Map<String, dynamic> json) {
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
  String? sno;
  String? role;
  String? roleText;
  String? name;
  String? isAdmin;
  String? companyId;
  String? companyName;
  String? lastLogin;
  bool? isLoggedIn;
  dynamic? imageUrl;
  String ? sessionId;


  Data(
      {this.sno,
      this.role,
      this.roleText,
      this.name,
      this.isAdmin,
      this.companyId,
      this.companyName,
      this.lastLogin,
      this.isLoggedIn,
      this.imageUrl,
      this.sessionId
      
      
      });

  Data.fromJson(Map<String, dynamic> json) {
    sno = json['sno'];
    role = json['role'];
    roleText = json['roleText'];
    name = json['name'];
    isAdmin = json['isAdmin'];
    companyId = json['Company_Id'];
    companyName = json['CompanyName'];
    lastLogin = json['lastLogin'];
    isLoggedIn = json['isLoggedIn'];
    imageUrl = json['Company_Logo'];
    sessionId = json['sessionid'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['sno'] = this.sno;
    data['role'] = this.role;
    data['roleText'] = this.roleText;
    data['name'] = this.name;
    data['isAdmin'] = this.isAdmin;
    data['Company_Id'] = this.companyId;
    data['CompanyName'] = this.companyName;
    data['lastLogin'] = this.lastLogin;
        data['Company_Logo'] = this.imageUrl;
    data['isLoggedIn'] = this.isLoggedIn;
    data['sessionid'] = this.sessionId;

   return data;
  }
}


