import 'package:cook_waiter/App/views/login/controller/login_controller.dart';
import 'package:cook_waiter/App/views/orders/controller/orders_controller.dart';
import 'package:get/get.dart';

class AppBindings extends Bindings {
  @override
  void dependencies() {
    // Register your controllers here
    Get.lazyPut<LoginController>(() => LoginController());
        Get.lazyPut<OrdersController>(() => OrdersController());

  }
}
