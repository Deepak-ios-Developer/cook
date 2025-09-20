// 🎯 lib/views/orders/controller/orders_controller.dart
import 'dart:async';
import 'dart:convert';
import 'dart:io' as IO show Socket;

import 'package:cook_waiter/App/Storage/session_storage.dart';
import 'package:cook_waiter/App/common_widgets/common_snack_bar.dart';
import 'package:cook_waiter/App/service/app_service.dart';
import 'package:cook_waiter/App/views/orders/data/get_all_tabel_data.dart';
import 'package:cook_waiter/App/views/orders/data/notification_response_data.dart';
import 'package:cook_waiter/App/views/orders/data/orders_data.dart';
import 'package:cook_waiter/App/views/orders/data/orders_data.dart' as data;
import 'package:cook_waiter/App/views/orders/data/orders_detail_response.dart';
import 'package:cook_waiter/App/views/orders/data/payment_history_data.dart';
import 'package:cook_waiter/App/views/orders/data/update_payment_response_data.dart';
import 'package:cook_waiter/App/views/orders/service/orders_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gif/gif.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class OrdersController extends GetxController
    with GetSingleTickerProviderStateMixin {
  late GifController gifController;
  var isLoading = false.obs;
  var isTableLoading = false.obs;
  var errorMessage = ''.obs;
  var ordersResponse = OrderListResponseData().obs;
  var tabelResponse = GetAllTabelListResponseData().obs;
  var orderDetailResponse = OrderDetailResponseData().obs;
  var notificationResponse = NotificationResponseData().obs;
  var paymentHistoryResponse = PaymentHistoryResponseData().obs;
  var updatePaymentResponse = UpdatePaymentResponseData().obs;
  final socketService = SocketService();

  int orderStatusParam = 1; // Default for tab 0

  Map<int, int> tabCounts = {
    0: 0, // Waiting/Preparing
    1: 0, // Ready
    2: 0, // Delivered
  };

  final RxString selectedTableQRID = ''.obs;
  RxList<OrderStatusModel> orderStatusList = <OrderStatusModel>[].obs;

  // Track which orders are currently being updated
  var updatingOrderIds = <String>[].obs;
  final RxString selectedTableNo = ''.obs; // stores the current selected table

  // Get the list of orders from the response
  List<OrderList> get orders => ordersResponse.value.data?.orderList ?? [];
  RxInt selectedTab = 0.obs;

  var selectedTable = 0.obs;
  var filteredOrders = <OrderList>[].obs;

  // Track stopped timers
  final _stoppedTimers = <String>{}.obs;
  final _remainingDurations = <String, Duration>{}.obs;
  final _countdowns = <String, RxString>{}.obs;
  final _timers = <String, Timer>{}.obs;

  // Default countdown duration (15 minutes)
  final defaultDuration = const Duration(minutes: 15);

  // Dynamic status flow - this will be populated from API or can be hardcoded

  final List<Map<String, dynamic>> statusFlow = [
    {"code": "1", "label": "Awaiting Pickup"},
    {"code": "2", "label": "Preparing"},
    {"code": "3", "label": "Order Ready"},
    {"code": "4", "label": "Delivered"},
  ];
  RxString selectedChefId = ''.obs; // Add this for chef filtering
  RxBool isChefFilterEnabled = false.obs; // Toggle for chef filter

  // Method to toggle chef filter
  void toggleChefFilter() {
    final userSession = SessionStorage.getUserSession();

    if (!isChefFilterEnabled.value) {
      // Turn ON
      selectedChefId.value = userSession?.sno ?? "";
      isChefFilterEnabled.value = true;
    } else {
      // Turn OFF
      getOrdersApi(orderStatus: 1);

      isChefFilterEnabled.value = false;
      selectedChefId.value = '';
    }

    applyFilters();
  }

  // Method to set specific chef filter
  void setTableFilter(String tableNo) {
    selectedTableNo.value = tableNo;
    applyFilters();
  }

  void clearTableFilter() {
    selectedTableNo.value = '';
    applyFilters();
  }

  // Method to get current user's orders count
  int getCurrentUserOrdersCount() {
    if (selectedChefId.value.isEmpty) return 0;

    final allOrders = ordersResponse.value.data?.orderList ?? [];
    return allOrders
        .where((order) => order.chefId == selectedChefId.value)
        .length;
  }

  // Method to check if current user has any orders
  bool hasCurrentUserOrders() {
    if (selectedChefId.value.isEmpty) return false;

    final allOrders = ordersResponse.value.data?.orderList ?? [];
    return allOrders.any((order) => order.chefId == selectedChefId.value);
  }

  // Method to refresh chef filter (useful after API calls)
  void refreshChefFilter() {
    if (isChefFilterEnabled.value && selectedChefId.value.isNotEmpty) {
      print("🔵 Refreshing chef filter for Chef ID: ${selectedChefId.value}");
      applyFilters();
    }
  }

  // Updated method to apply all filters including chef filter
//   void applyFilters() {
//   var tempOrders = List<OrderList>.from(orders);

//   print('Total Orders: ${orders.length}');
//   print('Chef Filter Enabled: ${isChefFilterEnabled.value}, Chef ID: ${selectedChefId.value}');
//   print('Table Filter: ${selectedTableNo.value}');

//   for (var o in tempOrders) {
//     print('Order ${o.orderNo} - Table: ${o.tableNo}, Chef: ${o.chefId}');
//   }

//   // ✅ Only apply chef filter when toggle is ON
//   if (isChefFilterEnabled.value) {
//     tempOrders = tempOrders
//         .where((order) => order.chefId == selectedChefId.value)
//         .toList();
//   }

//   // ✅ Only apply table filter when a specific table is chosen
//   if (selectedTableNo.value.isNotEmpty) {
//     tempOrders = tempOrders
//         .where((order) => (order.tableNo ?? '') == selectedTableNo.value)
//         .toList();
//   }

//   // Update the filtered orders list
//   filteredOrders.assignAll(tempOrders);

//   // Optionally, print filtered orders for debugging
//   print('Filtered Orders: ${filteredOrders.length}');
//   for (var o in filteredOrders) {
//     print('Filtered Order ${o.orderNo} - Table: ${o.tableNo}, Chef: ${o.chefId}');
//   }
// }


  // Get status label from code
  String getStatusLabel(String code) {
    final status = statusFlow.firstWhere(
      (s) => s['code'] == code,
      orElse: () => {"label": "Unknown"},
    );
    return status["label"] ?? "Unknown";
  }

  // Get next status in the flow
  Map<String, dynamic>? getNextStatus(String currentCode) {
    final index = statusFlow.indexWhere((s) => s['code'] == currentCode);
    if (index != -1 && index + 1 < statusFlow.length) {
      return statusFlow[index + 1];
    }
    return null;
  }

  // Check if a specific order is being updated
  bool isOrderUpdating(String orderNo) {
    return updatingOrderIds.contains(orderNo);
  }

  // Get button text based on current status - completely dynamic
  String getButtonText(String currentStatusCode, String currentStatusLabel) {
    final nextStatus = getNextStatus(currentStatusCode);
    if (nextStatus != null) {
      return statusFlow.firstWhere(
        (s) => s['code'] == nextStatus['code'],
        orElse: () => {"label": "Unknown"},
      )["label"];
    }
    return "Completed";
  }

  // Alternative: Get button text using current status from API
  String getDynamicButtonText(OrderList order) {
    final currentStatusCode = order.orderStatusCode ?? "1";
    final nextStatus = getNextStatus(currentStatusCode);

    // Use label from next status in flow
    if (nextStatus != null) {
      return nextStatus['label'] ?? "Next";
    }
    return "Completed";
  }

  // Get current status text directly from API response
  String getCurrentStatusText(OrderList order) {
    return order.orderStatus ?? "Unknown Status";
  }

  // Check if order can be updated (not at final status)
  bool canUpdateOrder(String currentStatusCode) {
    return getNextStatus(currentStatusCode) != null;
  }

  Timer? timer;

  @override
  void onInit() {
    super.onInit();
connectToSocket();
    // Initialize GifController
    gifController = GifController(vsync: this);

    // Fetch initial orders
    getOrdersApi(orderStatus: 1);
    callNotificationApi();
    orderHistoryAPi();
  }

  @override
  void dispose() {
    super.dispose();
    gifController.dispose();
    socketService.disconnect();
    timer?.cancel();
  }

  void connectToSocket() async {
    socketService.connectToSocket();
    final userSession = await SessionStorage.getUserSession();

// Before placing an order
    socketService.registerClient(
      sessionId: userSession?.sessionId ?? "",
      restaurantClientId: userSession?.companyId ?? "",
    );
  }

  Future<void> fetchOrderStatuses() async {
    var companyId = SessionStorage.getCompanyId() ?? '';
    try {
      final response = await getOrdersApi(
        orderStatus: selectedTab.value == 0
            ? 1
            : selectedTab.value == 1
                ? 3
                : 4,
      );
      orderStatusList.value = (response as List)
          .map((item) => OrderStatusModel.fromJson(item))
          .toList();
    } catch (e) {
      print("Failed to fetch status list: $e");
    }
  }

  void changeTab(int index) {
    // Save current tab’s order count before switching
    tabCounts[selectedTab.value] = orders.length;

    selectedTab.value = index;

    // Decide orderStatus for the new tab
    switch (index) {
      case 0:
        orderStatusParam = 1; // Waiting/Preparing
        break;
      case 1:
        orderStatusParam = 3; // Ready
        break;
      case 2:
        orderStatusParam = 4; // Delivered
        break;
    }

    // Call API for the new tab
    getOrdersApi(orderStatus: orderStatusParam);
  }

void applyFilters() {
  var tempOrders = List<OrderList>.from(orders);

  print('Total Orders: ${orders.length}');
  print('Chef Filter Enabled: ${isChefFilterEnabled.value}, Chef ID: ${selectedChefId.value}');
  print('Table Filter: ${selectedTableNo.value}');

  for (var o in tempOrders) {
    print('Order ${o.orderNo} - Table: ${o.tableNo}, Chef: ${o.chefId}');
  }

  // ✅ Apply chef filter only when toggle is ON
  if (isChefFilterEnabled.value) {
    tempOrders = tempOrders
        .where((order) => order.chefId == selectedChefId.value)
        .toList();
  }

  // ✅ Apply table filter only when a specific table is chosen
  if (selectedTableNo.value.isNotEmpty) {
    tempOrders = tempOrders
        .where((order) => (order.tableNo ?? '') == selectedTableNo.value)
        .toList();
  }

  // Update the filtered orders list
  filteredOrders.assignAll(tempOrders);

  // Debugging filtered results
  print('Filtered Orders: ${filteredOrders.length}');
  for (var o in filteredOrders) {
    print('Filtered Order ${o.orderNo} - Table: ${o.tableNo}, Chef: ${o.chefId}');
  }
}

void changeTable(int index, String tableNo) {
  selectedTable.value = index;
  selectedTableNo.value = tableNo; // ✅ update table filter value

  // Apply all filters including chef filter
  applyFilters();
    getOrdersApi(orderStatus: orderStatusParam);

  ordersResponse.refresh();
  print(
    "DEBUG JSON: ${jsonEncode(filteredOrders.map((e) => e.toJson()).toList())}",
  );
}


  Future<void> getOrdersApi({int orderStatus = 1}) async {
    isLoading.value = true;
    errorMessage.value = '';
    var companyId = SessionStorage.getCompanyId() ?? '';
    print(" From Controller Company ID: $companyId");

    try {
      final response = await callOrdersApi(companyId, orderStatus);
      ordersResponse.value = response;
      ordersResponse.refresh();

      // Set initial filtered orders
      filteredOrders.value = ordersResponse.value?.data?.orderList ?? [];
      filteredOrders.refresh();

      // Apply all filters including chef filter
      applyFilters();

      final apiStatus = ordersResponse.value.status?.toApiStatus();
      print(" From Controller API Status: $apiStatus");
      for (var order in filteredOrders) {
        if ((order.orderStatusCode ?? "") == "2") {
          final updatedDateStr = order.updatedDate ?? order.updatedDate ?? "";
          final cookTimeStr = order.time ?? order.time ?? "";
          final sno = order.sno ?? "";
          if (updatedDateStr.isNotEmpty &&
              cookTimeStr.isNotEmpty &&
              sno.isNotEmpty) {
            initTimerFromUpdatedDateAndCookTime(
                sno, updatedDateStr, cookTimeStr);
          }
        }
      }

      if (apiStatus == ApiStatus.success200) {
        print(" From Controller Orders Response: ${ordersResponse.value.data}");
        tabCounts[selectedTab.value] = orders.length;
      } else {
        CommonSnackbar.show(
          Get.context!,
          message: "Orders Fetch Failed",
          isSuccess: false,
        );
      }
    } catch (e) {
      errorMessage.value = e.toString();
      print(" From Controller Error: $e");
      CommonSnackbar.show(
        Get.context!,
        message: "Something Went Wrong",
        isSuccess: false,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Updated updateOrderStatus method to handle individual orders
  Future<void> updateOrderStatusDynamic(
    String orderId,
    String sno,
    String currentStatusCode,
    int index,
  ) async {
    updatingOrderIds.add(sno);
    final companyId = SessionStorage.getCompanyId() ?? '';
    final nextStatus = getNextStatus(currentStatusCode);

    if (nextStatus == null && currentStatusCode != "5") {
      CommonSnackbar.show(
        Get.context!,
        message: "Order already at final status",
        isSuccess: false,
      );

      updatingOrderIds.remove(orderId);
      return;
    }

    try {
      final response = await callStatusUpdateApi(
        companyId,
        sno,
        currentStatusCode,
      );

      if (response.status == "success") {
        // Update the order in the local list immediately
        if (currentStatusCode != "5") {
          // If current status is "Preparing", we need to stop the timer
          updateLocalOrderStatus(
              index, nextStatus?["code"], nextStatus?["label"]);
          CommonSnackbar.show(
            Get.context!,
            message: "Order moved to ${nextStatus?["label"]}",
            isSuccess: true,
          );
        }
        // Refresh the list for the selected tab
        getOrdersApi(orderStatus: orderStatusParam);
      } else {
        CommonSnackbar.show(
          Get.context!,
          message: "Failed to update order status",
          isSuccess: false,
        );
      }
    } catch (e) {
      print("Error updating order status: $e");
      CommonSnackbar.show(
        Get.context!,
        message: "Error updating order status",
        isSuccess: false,
      );
    } finally {
      updatingOrderIds.remove(orderId);
    }
  }

  // Update local order status immediately for better UX
  void updateLocalOrderStatus(
    int index,
    String newStatusCode,
    String newStatusLabel,
  ) {
    if (index >= 0 && index < orders.length) {
      orders[index].orderStatusCode = newStatusCode;
      orders[index].orderStatus = newStatusLabel;
      orders[index].updatedDate = DateTime.now().toString(); // Update timestamp

      // Trigger UI update
      ordersResponse.refresh();
    }
  }

  // Refresh specific order
  Future<void> refreshOrder(String orderNo, int index) async {
    print(" From Controller Refresh Order: $orderNo");
    if (orderNo.isEmpty || index < 0 || index >= orders.length) return;

    try {
      // Add loading state
      updatingOrderIds.add(orderNo);

      // Refresh all orders for now
      await getOrdersApi(
        orderStatus: selectedTab.value == 0
            ? 1
            : selectedTab.value == 1
                ? 3
                : 4,
      );
    } catch (e) {
      print('Error refreshing order: $e');
      CommonSnackbar.show(
        Get.context!,
        message: "Error refreshing order",
        isSuccess: false,
      );
    } finally {
      updatingOrderIds.remove(orderNo);
    }
  }

  Future<void> callChangeOrderStatusApi(
      String orderId, String sno, time) async {
    var companyId = SessionStorage.getCompanyId() ?? '';
    isLoading.value = true;
    final response = await changeOrderStatusApi(companyId, orderId, sno);
    if (response.status == "success") {
      CommonSnackbar.show(
        Get.context!,
        message: "Order Status Updated Successfully",
        isSuccess: true,
      );
      getOrdersApi(orderStatus: orderStatusParam);
      initTimerFromApiTime(sno, time);
    } else {
      isLoading.value = false;
      CommonSnackbar.show(
        Get.context!,
        message: "Order Status Update Failed",
        isSuccess: false,
      );
    }
    isLoading.value = false;
  }

  Future<void> callOrderDelayApi(String orderId, String sno) async {
    var companyId = SessionStorage.getCompanyId() ?? '';
    isLoading.value = true;
    final response = await orderDelayApi(companyId, orderId, sno);
    if (response.status == "success") {
      CommonSnackbar.show(
        Get.context!,
        message: "Order Status Updated Successfully",
        isSuccess: true,
      );
      getOrdersApi(orderStatus: orderStatusParam);
    } else {
      isLoading.value = false;
      CommonSnackbar.show(
        Get.context!,
        message: "Order Status Update Failed",
        isSuccess: false,
      );
    }
    isLoading.value = false;
  }

  Future<void> callOrderDetailAPi(orderId) async {
    isLoading.value = true;
    errorMessage.value = '';
    var companyId = SessionStorage.getCompanyId() ?? '';
    print(" From Controller Company ID: $companyId");

    try {
      final response = await orderDetailAPi(orderId);
      orderDetailResponse.value = response;
      orderDetailResponse.refresh();

      final apiStatus = orderDetailResponse.value.status?.toApiStatus();
      print(" From Controller API Status: $apiStatus");

      if (apiStatus == ApiStatus.success200) {
      } else {
        CommonSnackbar.show(
          Get.context!,
          message: "Orders Fetch Failed",
          isSuccess: false,
        );
      }
    } catch (e) {
      errorMessage.value = e.toString();
      print(" From Controller Error: $e");
      CommonSnackbar.show(
        Get.context!,
        message: "Something Went Wrong",
        isSuccess: false,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> callNotificationApi() async {
    isLoading.value = true;
    errorMessage.value = '';
    var companyId = SessionStorage.getCompanyId() ?? '';
    print(" From Controller Company ID: $companyId");

    try {
      final response = await notificationApi(companyId);
      notificationResponse.value = response;
      notificationResponse.refresh();

      final apiStatus = notificationResponse.value.status?.toApiStatus();
      print(" From Controller API Status: $apiStatus");

      if (apiStatus == ApiStatus.success200) {
      } else {
        CommonSnackbar.show(
          Get.context!,
          message: "Notification Fetch Failed",
          isSuccess: false,
        );
      }
    } catch (e) {
      errorMessage.value = e.toString();
      CommonSnackbar.show(
        Get.context!,
        message: "Something Went Wrong",
        isSuccess: false,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> orderHistoryAPi() async {
    isLoading.value = true;
    errorMessage.value = '';
    var companyId = SessionStorage.getCompanyId() ?? '';
    print(" From Controller Company ID: $companyId");

    try {
      final response = await getRecentPayment(companyId);
      paymentHistoryResponse.value = response;
      paymentHistoryResponse.refresh();

      final apiStatus = paymentHistoryResponse.value.status?.toApiStatus();
      print(" From Controller API Status: $apiStatus");

      if (apiStatus == ApiStatus.success200) {
      } else {
        CommonSnackbar.show(
          Get.context!,
          message: "Orders Fetch Failed",
          isSuccess: false,
        );
      }
    } catch (e) {
      errorMessage.value = e.toString();
      print(" From Controller Error: $e");
      CommonSnackbar.show(
        Get.context!,
        message: "Something Went Wrong",
        isSuccess: false,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updatePayment(orderId) async {
    isLoading.value = true;
    errorMessage.value = '';
    var companyId = SessionStorage.getCompanyId() ?? '';
    print(" From Controller Company ID: $companyId");

    try {
      final response = await updatePaymentAPi(orderId);
      updatePaymentResponse.value = response;
      updatePaymentResponse.refresh();

      final apiStatus = orderDetailResponse.value.status?.toApiStatus();
      print(" From Controller API Status: $apiStatus");

      callNotificationApi();

      if (apiStatus == ApiStatus.success200) {
      } else {
        CommonSnackbar.show(
          Get.context!,
          message: "Orders Update Failed",
          isSuccess: false,
        );
      }
    } catch (e) {
      errorMessage.value = e.toString();
      print(" From Controller Error: $e");
      CommonSnackbar.show(
        Get.context!,
        message: "Something Went Wrong",
        isSuccess: false,
      );
    } finally {
      isLoading.value = false;
    }
  }

  void initTimerFromApiTime(String orderSno, String timeString) {
    // print("DEBUG TIMER FUNCTION CALLED");
    if (_stoppedTimers.contains(orderSno)) return;

    // Parse "18:02:03" into Duration
    final parts = timeString.split(':');
    var remaining = Duration(
      hours: int.parse(parts[0]),
      minutes: int.parse(parts[1]),
      seconds: int.parse(parts[2]),
    );

    // print('Starting countdown from: $remaining');

    _remainingDurations[orderSno] = remaining;
    _countdowns[orderSno] = RxString(_formatDuration(remaining));

    // Start periodic timer
    _startTimer(orderSno);
  }

  void _startTimer(String orderSno) {
    _timers[orderSno]?.cancel(); // Cancel existing timer if any

    _timers[orderSno] =
        Timer.periodic(const Duration(seconds: 1), (timer) async {
      final currentRemaining = _remainingDurations[orderSno]!;

      if (currentRemaining <= Duration.zero) {
        timer.cancel();
        _countdowns[orderSno]?.value = "00:00:00";
        print('Timer ended for $orderSno');
        // Automatically call delay API when timer ends
        await callOrderDelayApi(orderSno, orderSno);
        return;
      }

      // Decrement by 1 second
      final newRemaining = currentRemaining - const Duration(seconds: 1);

      _remainingDurations[orderSno] = newRemaining;
      _countdowns[orderSno]?.value = _formatDuration(newRemaining);
    });
  }

  String _formatDuration(Duration d) {
    final hours = d.inHours.toString().padLeft(2, '0');
    final minutes = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return "$hours:$minutes:$seconds";
  }

  /// Stops the timer and marks it as stopped
  void stopTimer(String orderSno) {
    _timers[orderSno]?.cancel();
    _stoppedTimers.add(orderSno);
  }

  /// Adds time and stops the timer (freeze at new duration)
  void addTimeAndStop(String orderSno, Duration addTimeDuration) {
    _remainingDurations[orderSno] =
        (_remainingDurations[orderSno] ?? Duration.zero) + addTimeDuration;

    _countdowns[orderSno]?.value =
        _formatDuration(_remainingDurations[orderSno]!);

    stopTimer(orderSno);
  }

  /// Returns observable countdown
  RxString observeCountdown(String orderSno) {
    return _countdowns[orderSno] ?? RxString("00:00");
  }

  // Helper method to check if order should show preparing animation
  bool shouldShowPreparingAnimation(String statusCode) {
    return statusCode == "2"; // Preparing status
  }

  void initTimerFromUpdatedDateAndCookTime(
      String orderSno, String updatedDateStr, String cookTimeStr) {
    if (_stoppedTimers.contains(orderSno)) return;

    try {
      final updatedDate = DateTime.parse(updatedDateStr);
      final cookTimeMinutes = int.tryParse(cookTimeStr) ?? 15;
      final endTime = updatedDate.add(Duration(minutes: cookTimeMinutes));
      final now = DateTime.now();
      final remaining = endTime.difference(now);

      final safeRemaining = remaining.isNegative ? Duration.zero : remaining;

      _remainingDurations[orderSno] = safeRemaining;
      _countdowns[orderSno] = RxString(_formatDuration(safeRemaining));

      _startTimer(orderSno);
    } catch (e) {
      print('Failed to parse updated_date or cook time: $e');
      _remainingDurations[orderSno] = Duration.zero;
      _countdowns[orderSno] = RxString("00:00:00");
    }
  }

  /// Converts a string representing minutes (e.g., "15") to a Duration in minutes.
  /// Returns Duration.zero if parsing fails.
  Duration minutesStringToDuration(String mins) {
    final m = int.tryParse(mins) ?? 0;
    return Duration(minutes: m);
  }
}

class Order {
  final String itemName;
  final int qty;
  final String chef;
  final String timer;

  Order({
    required this.itemName,
    required this.qty,
    required this.chef,
    required this.timer,
  });
}

class OrderStatusModel {
  final String code;
  final String label;

  OrderStatusModel({required this.code, required this.label});

  factory OrderStatusModel.fromJson(Map<String, dynamic> json) {
    return OrderStatusModel(code: json['code'], label: json['label']);
  }
}

class SocketService {
  late IO.Socket socket;

  void connectToSocket() {
    socket = IO.io('https://51baaeba68b9.ngrok-free.app', <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
    });

    socket.connect();

    // Connection events
    socket.onConnect((_) => print('✅ Connected to socket server'));
    socket.onDisconnect((_) => print('❌ Disconnected from socket server'));
    socket.onConnectError((data) => print('⚠️ Connect error: $data'));
    socket.onError((data) => print('⚠️ General error: $data'));
  }

  /// Register client: emit and listen on the same event
  void registerClient({
    required String sessionId,
    String? restaurantClientId,
    void Function(bool success, String? message)? onAck,
    void Function(dynamic data)? onServerUpdate,
  }) {
    final registerData = {
      "clientType": "mobile",
      "sessionId": sessionId,
      if (restaurantClientId != null) "restaurantClientId": restaurantClientId,
    };

    // 1️⃣ Emit with acknowledgement
    socket.emitWithAck("register-client", registerData, ack: (response) {
      print("Client registration response: $response");
      final success = response['success'] ?? false;
      final message = response['message'];

      if (success) {
        print("Client registered successfully");
      } else {
        print("Client registration failed: $message");
      }

      if (onAck != null) onAck(success, message);
    });

    // 2️⃣ Listen to all events
   socket.onAny((event, data) {
  print("📌 Event: $event, Data: $data");

  if (event == 'order-received' && data is List && data.isNotEmpty) {
    CommonSnackbar.show(
      Get.context!,
      message: "New Order Received! Order ID: ${data[0]['orderId']}",
      isSuccess: true,
    );
  }
});


    // 3️⃣ Listen specifically for server pushes on "register-client"
    socket.on("register-client", (data) {
      print("🔄 Received server update on register-client: $data");
      if (onServerUpdate != null) onServerUpdate(data);
    });
  }

  void disconnect() {
    socket.disconnect();
  }
}
