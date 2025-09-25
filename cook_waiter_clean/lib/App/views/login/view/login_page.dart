import 'package:cook_waiter/App/Themes/app_colors.dart';
import 'package:cook_waiter/App/common_widgets/common_custom_button.dart';
import 'package:cook_waiter/App/common_widgets/common_snack_bar.dart';
import 'package:cook_waiter/App/common_widgets/common_textfield.dart';
import 'package:cook_waiter/App/constants/app_constants.dart';
import 'package:cook_waiter/App/views/login/controller/login_controller.dart';
import 'package:cook_waiter/App/views/login/data/login_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class LoginScreen extends GetView<LoginController> {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(LoginController());
    return Scaffold(
      backgroundColor: AppColors.background, // <-- use your #F9A948 directly!
      body: Column(
        children: [
          // ✅ Top orange + form
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              children: [
                const SizedBox(height: 40),
                Image.asset('assets/app_logo.png', height: 80),
                const SizedBox(height: 40),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    AppStrings.employeeId,
                    style: TextStyle(
                      color: AppColors.black,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                CommonTextField(
                  controller: controller.employeeIdController,
                  hintText: AppStrings.pleaseEnter,
                ),
                const SizedBox(height: 20),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    AppStrings.password,
                    style: TextStyle(
                      color: AppColors.black,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Obx(
                  () => CommonTextField(
                    controller: controller.passwordController,
                    hintText: AppStrings.pleaseEnter,
                    obscureText: !controller.isPasswordVisible.value,
                    suffixIcon: IconButton(
                      icon: Icon(
                        controller.isPasswordVisible.value
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: AppColors.black,
                      ),
                      onPressed: controller.togglePasswordVisibility,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                // Obx(
                //   () => Row(
                //     children: [
                //       Text(
                //         AppStrings.rememberMe,
                //         style: TextStyle(
                //           color: AppColors.black,
                //           fontWeight: AppFonts.bold,
                //         ),
                //       ),
                //       const Spacer(),

                //       CommonToggleSwitch(
                //         value: controller.rememberMe.value,
                //         onChanged: (_) => controller.toggleRememberMe(),
                //         activeColor: AppColors.toggleActive,
                //         inactiveColor: AppColors.white,
                //       ),
                //     ],
                //   ),
                // ),
                const SizedBox(height: 20),
                Obx(
                  () => CustomFullButton(
                    title: AppStrings.login,
                    isLoading: controller.isLoading.value,
                    onTap: () {
                      if (controller.employeeIdController.text.isEmpty ||
                          controller.passwordController.text.isEmpty) {
                        CommonSnackbar.show(
                          context,
                          message: "Please enter email and password",
                          isSuccess: false,
                        );
                        return;
                      }
                      controller.callLoginApi(
                        LoginRequestData(
                          email: controller.employeeIdController.text,
                          password: controller.passwordController.text,
                        ),
                        context,
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          // ✅ Bottom white + curve + image (no bottom space)
          Expanded(
            child: ClipPath(
              // clipper: TopCurveClipper(),
              child: Container(
                width: double.infinity,
                // decoration: const BoxDecoration(color: Colors.white),
                child: Container(
                  width: double.infinity,
                  height: double.infinity,
                  color: AppColors
                      .background, // Ensure white background behind image
                  child: SvgPicture.asset(
                    'assets/cook.svg',
                    fit: BoxFit
                        .fitHeight, // Changed to contain to preserve aspect ratio
                    width: double.infinity,
                    height: double.infinity,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class TopCurveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, 20);
    path.quadraticBezierTo(size.width / 2, 0, size.width, 40);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height * 0.9);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
