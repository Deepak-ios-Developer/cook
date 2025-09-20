import 'dart:convert';

import 'package:get_storage/get_storage.dart';

class SessionStorage {
  static final SessionStorage _instance = SessionStorage._internal();
  factory SessionStorage() => _instance;
  SessionStorage._internal();

  static GetStorage? _getStorage;

  static Future<void> init() async {
    _getStorage = GetStorage();
  }

  static Future<void> saveUserSession(UserSession user) async {
    final jsonString = jsonEncode(user.toJson());
    await _getStorage?.write('userSession', jsonString);
  }

  static Future<void> saveCompanyId(String companyId) async {
    await _getStorage?.write('companyId', companyId);
  }

  static String? getCompanyId() {
    return _getStorage?.read('companyId');
  }

  static UserSession? getUserSession() {
    final jsonString = _getStorage?.read('userSession');
    if (jsonString != null) {
      final Map<String, dynamic> jsonMap = jsonDecode(jsonString);
      return UserSession.fromJson(jsonMap);
    }
    return null;
  }

  static Future<void> removeUserSession() async {
    await _getStorage?.remove("companyId");
    await _getStorage?.remove('userSession');
  }
}

class UserSession {
  final String sno;
  final String role;
  final String roleText;
  final String name;
  final String isAdmin;
  final String companyId;
  final String companyName;
  final String lastLogin;
  final bool isLoggedIn;
  final String imageUrl;
  final String sessionId;

  UserSession({
    required this.sno,
    required this.role,
    required this.roleText,
    required this.name,
    required this.isAdmin,
    required this.companyId,
    required this.companyName,
    required this.lastLogin,
    required this.isLoggedIn,
    required this.imageUrl,
     required this.sessionId,
  });

  factory UserSession.fromJson(Map<String, dynamic> json) {
    return UserSession(
      sno: json['sno'],
      role: json['role'],
      roleText: json['roleText'],
      name: json['name'],
      isAdmin: json['isAdmin'],
      companyId: json['Company_Id'],
      companyName: json['CompanyName'],
      lastLogin: json['lastLogin'],
      isLoggedIn: json['isLoggedIn'],
      imageUrl: json['Company_Logo'],
      sessionId: json['sessionid'],

    );
  }

  Map<String, dynamic> toJson() {
    return {
      'sno': sno,
      'role': role,
      'roleText': roleText,
      'name': name,
      'isAdmin': isAdmin,
      'Company_Id': companyId,
      'CompanyName': companyName,
      'lastLogin': lastLogin,
      'isLoggedIn': isLoggedIn,
      'Company_Logo':imageUrl,
      'sessionid': sessionId
    };
  }
}
