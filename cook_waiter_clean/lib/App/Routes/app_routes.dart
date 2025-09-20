

import 'package:cook_waiter/App/views/login/view/splash_view.dart';
import 'package:cook_waiter/App/views/orders/view/orders_view.dart';
import 'package:cook_waiter/App/views/login/view/login_page.dart';
import 'package:get/get.dart';

class AppRoutes {
  static const String login = '/login';
  static const String splash = '/splash';
  static const String orders = '/orders'; // e.g., your list page
}


final List<GetPage> appPages = [
  GetPage(
    name: AppRoutes.splash,
    page: () => SplashView(),
  ),
  GetPage(
    name: AppRoutes.login,
    page: () => LoginScreen(),
  ),
  GetPage(
    name: AppRoutes.orders,
    page: () => OrdersScreen(), // Replace with your actual OrderScreen
  ),
];
