// lib/controllers/login_controller.dart
import 'package:cook_waiter/App/Routes/app_routes.dart';
import 'package:cook_waiter/App/Storage/session_storage.dart';
import 'package:cook_waiter/App/common_widgets/common_snack_bar.dart';
import 'package:cook_waiter/App/service/app_service.dart';
import 'package:cook_waiter/App/views/login/data/login_data.dart';
import 'package:cook_waiter/App/views/login/service/login_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class LoginController extends GetxController {
  final employeeIdController = TextEditingController();
  final passwordController = TextEditingController();

  var isPasswordVisible = false.obs;
  var rememberMe = false.obs;

  var isLoading = false.obs;
  var errorMessage = ''.obs;
  var loginResponse = LoginResponseData().obs;

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  void toggleRememberMe() {
    rememberMe.value = !rememberMe.value;
  }

  // void login() {
  //   // Add your login API call here
  //   Get.toNamed(AppRoutes.orders);
  //   print('Login tapped');
  // }

  Future<void> callLoginApi(
    LoginRequestData request,
    BuildContext context,
  ) async {
    isLoading.value = true;
    errorMessage.value = '';

    try {
      final response = await login(request);
      loginResponse.value = response;

      final apiStatus = loginResponse.value.status?.toApiStatus();

      if (apiStatus == ApiStatus.success200) {
        CommonSnackbar.show(context, message: "Login Successfully");

        SessionStorage.saveUserSession(
          UserSession(
            sno: loginResponse.value.data?.sno ?? '',
            role: loginResponse.value.data?.role ?? '',
            roleText: loginResponse.value.data?.roleText ?? '',
            name: loginResponse.value.data?.name ?? '',
            isAdmin: loginResponse.value.data?.isAdmin ?? '',
            companyId: loginResponse.value.data?.companyId ?? '',
            companyName: loginResponse.value.data?.companyName ?? '',
            lastLogin: loginResponse.value.data?.lastLogin ?? '',
            imageUrl: loginResponse.value.data?.imageUrl ?? '',

            isLoggedIn: true,
          ),
        );

        await SessionStorage.saveCompanyId(
          loginResponse.value.data?.companyId ?? '',
        );
        await GetStorage().initStorage; // force refresh
        debugPrint("Company ID 2: ${SessionStorage.getCompanyId()}");

        debugPrint(
            "Company ID 1: ${loginResponse.value.data?.companyId ?? ''}");

        debugPrint("Company ID 2: ${SessionStorage.getCompanyId()}");

        Get.toNamed(AppRoutes.orders);
      } else {
        CommonSnackbar.show(context, message: "Login Failed", isSuccess: false);
      }
    } catch (e) {
      debugPrint(e.toString());
      errorMessage.value = e.toString();
      CommonSnackbar.show(
        context,
        message: "Email id not found !!!",
        isSuccess: false,
      );
    } finally {
      isLoading.value = false;
    }
  }
}
