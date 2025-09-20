import 'package:flutter/material.dart';


class CommonSnackbar {
  static void show(
    BuildContext context, {
    required String message,
    bool isSuccess = true,
    Duration duration = const Duration(seconds: 2),
  }) {
    // Solution 1: Check if the context is still mounted
    if (!context.mounted) return;
    
    final snackBar = SnackBar(
      content: Text(
        message,
        style: const TextStyle(
          color: Color.fromARGB(255, 205, 201, 201), 
          fontWeight: FontWeight.w500
        ),
      ),
      backgroundColor: isSuccess ? Colors.green : Colors.red,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      duration: duration,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
    );

    try {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(snackBar);
    } catch (e) {
      // Handle the case where ScaffoldMessenger is not available
      debugPrint('Failed to show snackbar: $e');
    }
  }

  // Solution 2: Alternative implementation with better error handling
  static void showSafe(
    BuildContext context, {
    required String message,
    bool isSuccess = true,
    Duration duration = const Duration(seconds: 2),
  }) {
    // Check if context is still mounted and has a valid scaffold messenger
    if (!context.mounted) return;
    
    final scaffoldMessenger = ScaffoldMessenger.maybeOf(context);
    if (scaffoldMessenger == null) return;
    
    final snackBar = SnackBar(
      content: Text(
        message,
        style: const TextStyle(
          color: Color.fromARGB(255, 205, 201, 201), 
          fontWeight: FontWeight.w500
        ),
      ),
      backgroundColor: isSuccess ? Colors.green : Colors.red,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      duration: duration,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
    );

    scaffoldMessenger
      ..hideCurrentSnackBar()
      ..showSnackBar(snackBar);
  }

  // Solution 3: For use in controllers - pass ScaffoldMessengerState directly
  static void showWithMessenger(
    ScaffoldMessengerState scaffoldMessenger, {
    required String message,
    bool isSuccess = true,
    Duration duration = const Duration(seconds: 2),
  }) {
    final snackBar = SnackBar(
      content: Text(
        message,
        style: const TextStyle(
          color: Color.fromARGB(255, 205, 201, 201), 
          fontWeight: FontWeight.w500
        ),
      ),
      backgroundColor: isSuccess ? Colors.green : Colors.red,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      duration: duration,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
    );

    scaffoldMessenger
      ..hideCurrentSnackBar()
      ..showSnackBar(snackBar);
  }
}
