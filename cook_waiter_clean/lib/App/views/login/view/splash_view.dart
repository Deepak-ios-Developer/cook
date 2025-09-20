import 'package:cook_waiter/App/Routes/app_routes.dart';
import 'package:cook_waiter/App/Storage/session_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}
class _SplashViewState extends State<SplashView>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeIn);

    _controller.forward();

    // Navigate after delay
    Future.delayed(const Duration(seconds: 2), () {
      final companyId = SessionStorage.getCompanyId();
      if (companyId != null) {
        Get.offAllNamed(AppRoutes.orders);
      } else {
        Get.offAllNamed(AppRoutes.login);
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: FadeTransition(
          opacity: _animation,
          child: Image.asset(
            'assets/orders_logo.jpg',
            height: 100,
          ),
        ),
      ),
    );
  }
}
