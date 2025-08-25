import 'dart:async';

import 'package:cook_waiter/App/Bindings/app_binidings.dart';
import 'package:cook_waiter/App/Routes/app_routes.dart';
import 'package:cook_waiter/App/Storage/session_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  await SessionStorage.init();

  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.presentError(details);
    // optionally log to analytics or server
    print("FlutterError: ${details.exceptionAsString()}");
  };

  runZonedGuarded(() {
    runApp(MyApp());
  }, (error, stackTrace) {
    print('Caught in zone: $error');
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      initialBinding: AppBindings(),
      title: 'Cook Waiter',
      initialRoute: AppRoutes.splash, // ✅ use initialRoute
      getPages: appPages, // ✅ use GetPages list
    );
  }
}
