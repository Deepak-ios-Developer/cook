// 🎯 lib/views/orders/orders_screen.dart
import 'package:cook_waiter/App/Routes/app_routes.dart';
import 'package:cook_waiter/App/Storage/session_storage.dart';
import 'package:cook_waiter/App/Themes/app_colors.dart';
import 'package:cook_waiter/App/common_widgets/common_app_loader.dart';
import 'package:cook_waiter/App/common_widgets/common_custom_button.dart';
import 'package:cook_waiter/App/common_widgets/common_snack_bar.dart';
import 'package:cook_waiter/App/common_widgets/notification_pop%20_up_widget.dart';
import 'package:cook_waiter/App/constants/app_fonts.dart';
import 'package:cook_waiter/App/views/orders/controller/orders_controller.dart';
import 'package:cook_waiter/App/views/orders/data/orders_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:gif/gif.dart';
import 'package:intl/intl.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:slide_to_act/slide_to_act.dart';

// ignore: must_be_immutable
class OrdersScreen extends GetView<OrdersController> {
  final OrdersController controller = Get.put(OrdersController());

  OrdersScreen({super.key});

  final tabs = ['New Order', 'Ready', 'Delivered'];
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _notificationEntry;

  // Add for bottom navigation
  final RxInt _bottomTabIndex = 0.obs;

  @override
  Widget build(BuildContext context) {
    final userSession = SessionStorage.getUserSession();

    return Obx(() => Scaffold(
          backgroundColor: Colors.grey.shade100,
          appBar: AppBar(
            automaticallyImplyLeading: false, // This removes the back button
            backgroundColor: Colors.white,
            elevation: 0, // No shadow
            title: Align(
              alignment: Alignment.centerLeft,
              child: Image.network(
                userSession?.imageUrl ?? "",
                height: 50,
                width: 150,
                fit: BoxFit.contain,
              ),
            ),

            actions: [
              CompositedTransformTarget(
                link: _layerLink,
                child: GestureDetector(
                  onTap: () => _toggleNotifications(context),
                  child: Obx(() {
                    final notificationCount = _getNotificationCount();
                    return Badge(
                      label: Text(
                        notificationCount > 99
                            ? '99+'
                            : notificationCount.toString(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      backgroundColor: Colors.red,
                      isLabelVisible: notificationCount > 0,
                      child: const Icon(
                        Icons.notifications_outlined,
                        size: 25,
                        color: Colors.black87,
                      ),
                    );
                  }),
                ),
              ),
              const SizedBox(width: 20),
              GestureDetector(
                onTap: () {},
                child: SvgPicture.asset(
                  'assets/power.svg',
                  height: 25,
                ),
              ),
              const SizedBox(width: 20),
            ],
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(1.0),
              child: Container(
                color: Colors.grey.shade300, // Divider color
                height: 1.0,
              ),
            ),
          ),
          body: _buildBody(context),
          bottomNavigationBar: BottomNavigationBar(
            backgroundColor: AppColors.white,
            elevation: 0.1,
            currentIndex: _bottomTabIndex.value,
            onTap: (index) {
              _bottomTabIndex.value = index;
            },
            selectedItemColor: AppColors.primary,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.list_alt),
                label: 'Orders',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.payment),
                label: 'Recent Payment',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person),
                label: 'Profile',
              ),
            ],
          ),
        ));
  }

  int _getNotificationCount() {
    // Get unread notifications count
    final notifications = controller.notificationResponse.value.data ?? [];

    // Option 1: Count all notifications
    return notifications.length;
  }

  Widget _buildBody(BuildContext context) {
    return Obx(() {
      switch (_bottomTabIndex.value) {
        case 0:
          return _ordersTabContent(context);
        case 1:
          return Center(child: Text("Recent Payment (Coming Soon)"));
        case 2:
          return _profileTabWidget(context);
        default:
          return _ordersTabContent(context);
      }
    });
  }

  Widget _ordersTabContent(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          // Tabs
          _tabBarWidget(),
          const SizedBox(height: 25),

          _tabelListWidget(),

          // Table filters
          const SizedBox(height: 25),

          // Header row
          Obx(() => _tabelHeaderWidget()),

          // Example if used inside Column
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(child: AppLoader());
              } else {
                return _tableOrdersView();
              }
            }),
          ),

          // Orders list
          // Navigation buttons
        ],
      ),
    );
  }

  void _toggleNotifications(BuildContext context) {
    print("toggleNotifications");
    if (_notificationEntry != null) {
      _notificationEntry?.remove();
      _notificationEntry = null;
      return;
    }

    final overlay = Overlay.of(context);
    _notificationEntry = OverlayEntry(
      builder: (context) => Positioned(
        width: 360,
        top: kToolbarHeight + 12,
        right: 10,
        child: CompositedTransformFollower(
          link: _layerLink,
          showWhenUnlinked: false,
          offset: const Offset(-280, 40),
          child: NotificationPopup(
            notifications: controller.notificationResponse.value.data
                    ?.map((e) => {
                          'showBill': e.paymentStatus == "0" ? true : false,
                          'userInitials': (e.fullname != null &&
                                  e.fullname!.isNotEmpty)
                              ? e.fullname!
                                  .substring(0, e.fullname!.length >= 2 ? 2 : 1)
                              : "",
                          'message':
                              "Payment request initiated for Order ID#${e.orderNo}.",
                          'timeAgo': "",
                          'isSuccess': e.paymentStatus == "1" ? true : false,
                          ""
                              'onTap': () {
                            if (e.paymentStatus == "1") {
                              showPaymentSuccessDialog(context);
                            } else {
                              showBillSummaryDialog(context, e.orderNo ?? "");
                            }
                            _notificationEntry?.remove();
                            _notificationEntry = null;
                          },
                        })
                    .toList() ??
                [],
            onMarkAllRead: () {
              print("Marked all as read");
            },
          ),
        ),
      ),
    );

    overlay.insert(_notificationEntry!);
  }

  Widget _tabBarWidget() {
    return Obx(
      () => Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(25),
          border: Border.all(color: Colors.grey.shade300, width: 1.2),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(tabs.length, (index) {
            final isSelected = controller.selectedTab.value == index;
            final count = _getTabCount(index); // Get count for each tab

            return Expanded(
              child: GestureDetector(
                onTap: () {
                  controller.changeTab(index);
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    color: isSelected ? AppColors.primary : Colors.transparent,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: isSelected
                        ? [
                            BoxShadow(
                              color: AppColors.primary.withOpacity(0.3),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ]
                        : [],
                  ),
                  alignment: Alignment.center,
                  child: RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: tabs[index],
                          style: AppFonts.custom(
                            fontSize: 14,
                            fontWeight: AppFonts.semiBold,
                            color: isSelected ? Colors.white : Colors.black87,
                          ),
                        ),
                        TextSpan(
                          text: ' (${controller.tabCounts[index] ?? 0})',
                          style: AppFonts.custom(
                            fontSize: 12,
                            fontWeight: AppFonts.medium,
                            color: isSelected ? Colors.white70 : Colors.black54,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }

// Add this helper method to get count for each tab
  int _getTabCount(int tabIndex) {
    if (controller.filteredOrders.isEmpty) return 0;

    // Based on your tab switching logic with order statuses
    switch (tabIndex) {
      case 0: // First tab - Order Status 1
        return controller.filteredOrders
            .where((order) => order.orderStatusCode == "1")
            .length;
      case 1: // Second tab - Order Status 3
        return controller.filteredOrders
            .where((order) => order.orderStatusCode == "3")
            .length;
      case 2: // Third tab - Order Status 4
        return controller.filteredOrders
            .where((order) => order.orderStatusCode == "4")
            .length;
      default: // Default - Order Status 1
        return controller.filteredOrders
            .where((order) => order.orderStatusCode == "1")
            .length;
    }
  }

  Widget _tabelListWidget() {
    return Obx(() {
      final tables = controller.ordersResponse.value.data?.tableList ?? [];
      final isLoading = controller.isTableLoading.value;

      // Show 6 placeholders if loading, else tables + 1 for 'All'
      final totalItems = isLoading ? 6 : tables.length + 1;

      return SizedBox(
        height: 90,
        child: Skeletonizer(
          enabled: isLoading,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: totalItems,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemBuilder: (_, index) {
              final isSelected = controller.selectedTable.value == index;

              String tableLabel;
              if (index == 0) {
                tableLabel = 'All';
              } else if (index - 1 < tables.length) {
                final no = tables[index - 1].tableNo;
                tableLabel = (no == null || no == "-") ? "" : no;
              } else {
                tableLabel = "";
              }

              return GestureDetector(
                onTap: () => controller.changeTable(index),
                child: Container(
                  width: 65,
                  decoration: BoxDecoration(
                    color: isSelected ? AppColors.primary : Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(
                      color:
                          isSelected ? AppColors.primary : Colors.grey.shade300,
                      width: isSelected ? 2 : 1,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        tableLabel,
                        style: AppFonts.custom(
                          fontSize: 25,
                          color: isSelected ? Colors.white : Colors.black,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Table',
                        style: AppFonts.custom(
                          fontSize: 16,
                          fontWeight: AppFonts.bold,
                          color: isSelected ? Colors.white : Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      );
    });
  }

  Widget _tableOrdersView() {
    return Column(
      children: [
        // Chef Filter Toggle
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: controller.selectedTab.value == 0
              ? Row(
                  children: [
                    Obx(() => Switch(
                          value: controller.isChefFilterEnabled.value,
                          onChanged: (value) => controller.toggleChefFilter(),
                          activeColor: AppColors.primary,
                        )),
                    const SizedBox(width: 8),
                    const Text(
                      "Show My Orders Only",
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                    const Spacer(),
                    // if (controller.isChefFilterEnabled.value)
                    //   Container(
                    //     padding:
                    //         const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    //     decoration: BoxDecoration(
                    //       color: AppColors.primary.withOpacity(0.1),
                    //       borderRadius: BorderRadius.circular(15),
                    //     ),
                    //     child: Obx(() => Text(
                    //           "Chef ID: ${controller.selectedChefId.value}",
                    //           style: TextStyle(
                    //             fontSize: 12,
                    //             color: AppColors.primary,
                    //             fontWeight: FontWeight.bold,
                    //           ),
                    //         )),
                    //   ),
                  ],
                )
              : SizedBox(),
        ),

        // Existing RefreshIndicator and ListView
        Expanded(
          child: RefreshIndicator(
            color: AppColors.primary,
            onRefresh: () async {
              switch (controller.selectedTab.value) {
                case 0:
                  await controller.getOrdersApi(orderStatus: 1);
                  break;
                case 1:
                  await controller.getOrdersApi(orderStatus: 3);
                  break;
                case 2:
                  await controller.getOrdersApi(orderStatus: 4);
                  break;
                default:
                  await controller.getOrdersApi(orderStatus: 1);
              }
              controller.applyFilters();
            },
            child: Obx(() {
              if (controller.filteredOrders.isEmpty) {
                return const Center(child: Text("No Orders Found"));
              }

              final tableNumbers = controller.filteredOrders
                  .map((e) => e.tableNo ?? '')
                  .toSet()
                  .toList();

              int globalIndex = 0;

              return ListView(
                children: [
                  for (var tableNo in tableNumbers)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ...controller.filteredOrders
                            .where((o) => o.tableNo == tableNo)
                            .map((order) => buildOrderRow(order, globalIndex++))
                            .toList(),
                      ],
                    ),
                ],
              );
            }),
          ),
        ),
      ],
    );
  }

  Widget buildOrderRow(OrderList order, int index) {
    final bool isGrey = index % 2 == 0;
    final GlobalKey<SlideActionState> _sliderKey =
        GlobalKey<SlideActionState>();
    var orderTime = formatDate(order.createdDate);

    final currentStatusCode = order.orderStatusCode ?? "1";
    final isUpdatingThisOrder = controller.isOrderUpdating(order.sno ?? "");

    // 🛑 Handle Delayed Status Code "5"
    if (currentStatusCode == "5") {
      return Container(
        color: isGrey ? AppColors.listGrey : Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
        child: Row(
          children: [
            SizedBox(
              width: 40,
              child: Text(
                order.tableNo ?? '',
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Row for item name and "Delayed" text
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          order.productName ?? '',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(left: 8, top: 2),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.redAccent,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Text(
                          "Delayed",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Text("Qty: ${order.orderqty}"),
                  // Show chef info for delayed orders
                  // if (order.chefId != null && order.chefId!.isNotEmpty)
                  //   Text(
                  //     "Chef ID: ${order.chefId}",
                  //     style: TextStyle(
                  //       fontSize: 12,
                  //       color: Colors.grey[600],
                  //     ),
                  //   ),
                  SizedBox(height: 10),

                  ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 150),
                    child: SlideAction(
                      key: _sliderKey,
                      elevation: 0.5,
                      outerColor: AppColors.white,
                      height: 50,
                      submittedIcon: isUpdatingThisOrder
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                color: AppColors.primary,
                                strokeWidth: 2,
                              ),
                            )
                          : SvgPicture.asset(
                              'assets/green_check.svg',
                              height: 20,
                              width: 20,
                              color: Colors.white,
                            ),
                      text: "Preparing" ?? "Unknown",
                      sliderButtonIconPadding: 7,
                      textStyle: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: Color.fromRGBO(0, 0, 0, 1),
                      ),
                      sliderButtonIcon: SvgPicture.asset(
                        'assets/green_check.svg',
                        height: 18,
                        width: 18,
                      ),
                      onSubmit: () async {
                        await controller.updateOrderStatusDynamic(
                          order.orderNo ?? "",
                          order.sno ?? "",
                          order.orderStatusCode ?? "1",
                          index,
                        );
                        await Future.delayed(
                          const Duration(seconds: 1),
                        );
                        _sliderKey.currentState?.reset();
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }

    // ✅ Normal order rendering
    return Container(
      color: isGrey ? AppColors.listGrey : Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
      child: Row(
        children: [
          SizedBox(
            width: 40,
            child: Text(
              order.tableNo ?? '',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  order.productName ?? '',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Text("Qty: ${order.orderqty}"),
                // Updated chef display logic
                if (order.chefId != null && order.chefId!.isNotEmpty)
                  Text(
                    "Chef ID: ${order.chefId}",
                    style: TextStyle(
                      fontSize: 12,
                      color: order.orderStatusCode == "2"
                          ? AppColors.primary
                          : Colors.grey[600],
                      fontWeight: order.orderStatusCode == "2"
                          ? FontWeight.bold
                          : FontWeight.normal,
                    ),
                  )
                else
                  Text(
                    "Chef: Unassigned",
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                const SizedBox(height: 6),
                const SizedBox(height: 20),

                // Rest of your existing slide action code...
                if (controller.selectedTab.value != 2 &&
                    controller.canUpdateOrder(currentStatusCode))
                  Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(25),
                        ),
                        child: Obx(() {
                          final isUpdatingThisOrder =
                              controller.isOrderUpdating(order.sno ?? "");
                          final nextStatus =
                              controller.getNextStatus(currentStatusCode);

                          if (nextStatus == null) {
                            return Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 12,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.listGrey,
                                borderRadius: BorderRadius.circular(25),
                              ),
                              child: const Text(
                                "Completed",
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            );
                          }

                          return Center(
                            child: ConstrainedBox(
                              constraints: const BoxConstraints(maxWidth: 150),
                              child: SlideAction(
                                key: _sliderKey,
                                elevation: 0.5,
                                outerColor: AppColors.white,
                                height: 50,
                                submittedIcon: isUpdatingThisOrder
                                    ? const SizedBox(
                                        height: 20,
                                        width: 20,
                                        child: CircularProgressIndicator(
                                          color: AppColors.primary,
                                          strokeWidth: 2,
                                        ),
                                      )
                                    : SvgPicture.asset(
                                        'assets/green_check.svg',
                                        height: 20,
                                        width: 20,
                                        color: Colors.white,
                                      ),
                                text: order.orderStatus ?? "Unknown",
                                sliderButtonIconPadding: 7,
                                textStyle: const TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: Color.fromRGBO(0, 0, 0, 1),
                                ),
                                sliderButtonIcon: SvgPicture.asset(
                                  'assets/green_check.svg',
                                  height: 18,
                                  width: 18,
                                ),
                                onSubmit: () async {
                                  await controller.updateOrderStatusDynamic(
                                    order.orderNo ?? "",
                                    order.sno ?? "",
                                    order.orderStatusCode ?? "1",
                                    index,
                                  );
                                  await Future.delayed(
                                    const Duration(seconds: 1),
                                  );
                                  _sliderKey.currentState?.reset();
                                },
                              ),
                            ),
                          );
                        }),
                      ),
                    ],
                  ),
              ],
            ),
          ),

          // Rest of your existing right side content...
          if (controller.selectedTab.value == 0) ...[
            Column(
              children: [
                controller.shouldShowPreparingAnimation(currentStatusCode)
                    ? Gif(
                        height: 50,
                        width: 50,
                        image: const AssetImage("assets/pan.gif"),
                        controller: controller.gifController,
                        autostart: Autostart.loop,
                        placeholder: (context) => const Text('Loading...'),
                      )
                    : Image.asset("assets/pan.png", height: 50, width: 50),
                // Text(
                //   orderTime,
                //   style: const TextStyle(
                //     color: AppColors.primary,
                //     fontWeight: FontWeight.bold,
                //   ),
                // ),
                if (controller
                    .shouldShowPreparingAnimation(currentStatusCode)) ...[
                  Obx(
                    () => Text(
                      " ${controller.observeCountdown(order.sno ?? "").value}",
                      style: const TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
                const SizedBox(height: 5),
                order.orderStatusCode == "2"
                    ? ElevatedButton(
                        onPressed: () {
                          controller.callOrderDelayApi(
                            order.orderNo ?? "",
                            order.sno ?? "",
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 4,
                          ),
                        ),
                        child: const Text("Add Time"),
                      )
                    : const SizedBox(),
              ],
            ),
          ],

          if (controller.selectedTab.value != 0) ...[
            Column(
              children: [
                GestureDetector(
                  onTap: () {
                    controller.callChangeOrderStatusApi(
                      order.orderStatusCode ?? "",
                      order.sno ?? "",
                      order.time,
                    );
                  },
                  child: SvgPicture.asset('assets/refersh.svg', height: 30),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  } // Helper method to get status color

  Widget _tabelHeaderWidget() {
    final controller = Get.find<OrdersController>();
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.5),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
        color: AppColors.listYellow,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(15),
          topRight: Radius.circular(15),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          SizedBox(
            width: 60,
            child: Text(
              'T.No',
              style: AppFonts.custom(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.black,
              ),
            ),
          ),
          Expanded(
            child: Text(
              'Items & Quantity',
              style: AppFonts.custom(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.black,
              ),
            ),
          ),
          if (controller.selectedTab.value == 0)
            Expanded(
              child: Align(
                alignment: Alignment.centerRight,
                child: Text(
                  'Timer (hr:min:sec)',
                  style: AppFonts.custom(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.black,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  void showBillSummaryDialog(BuildContext context, String orderNo) async {
    await controller.callOrderDetailAPi(orderNo);

    if (controller.isLoading.value) return;

    final dialogContext = Get.context!;

    if (!dialogContext.mounted)
      return; // Optional safety check for Flutter 3.7+

    if (controller.orderDetailResponse.value.data?.productList?.isEmpty ??
        true) {
      CommonSnackbar.show(
        dialogContext,
        message: "No order details found",
        isSuccess: false,
      );
      return;
    }

    showDialog(
      context: dialogContext,
      barrierDismissible: false,
      builder: (_) => Dialog(
        backgroundColor: AppColors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Bill Summary',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    onPressed: () => Get.back(),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: controller
                        .orderDetailResponse.value.data?.productList?.length ??
                    0,
                itemBuilder: (context, index) {
                  final product = controller
                      .orderDetailResponse.value.data?.productList?[index];
                  return buildRow(
                      product?.productName ?? '',
                      'x${product?.quantity ?? ''}',
                      '₹${product?.productPrice ?? ''}');
                },
              ),
              const Divider(color: AppColors.listGrey, thickness: 0.8),
              buildRow('Item Total', '',
                  '₹${controller.orderDetailResponse.value.data?.priceDetails?.totalPrice ?? ''}'),
              buildRow(
                  'Discount',
                  '${controller.orderDetailResponse.value.data?.priceDetails?.discountPercentage ?? ''} %',
                  '₹${controller.orderDetailResponse.value.data?.priceDetails?.discountAmount ?? ''}'),
              buildRow(
                  'GST & Other Charges',
                  '${controller.orderDetailResponse.value.data?.priceDetails?.gSTPercentage ?? ''} %',
                  '₹${controller.orderDetailResponse.value.data?.priceDetails?.gSTAmount ?? ''}'),
              const Divider(color: AppColors.listGrey, thickness: 0.8),
              buildRow('Item Total', '',
                  '₹${controller.orderDetailResponse.value.data?.priceDetails?.grandTotal ?? ''}',
                  isBold: true),
              const SizedBox(height: 20),
              CustomFullButton(
                title: "Proceed to Pay",
                width: 200,
                onTap: () {
                  Get.back();
                  Future.delayed(const Duration(milliseconds: 200), () {
                    showPaymentSuccessDialog(dialogContext);
                  });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Row Builder
  Widget buildRow(
    String title,
    dynamic qty,
    dynamic price, {
    bool isHeader = false,
    bool isBold = false,
  }) {
    String formatValue(dynamic val) {
      if (val is num) {
        return val.toStringAsFixed(2);
      }
      return val.toString();
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Expanded(child: Text(title, style: rowStyle(isHeader, isBold))),
          SizedBox(
            width: 40,
            child: Text(formatValue(qty), style: rowStyle(isHeader, isBold)),
          ),
          Text(formatValue(price), style: rowStyle(isHeader, isBold)),
        ],
      ),
    );
  }

  TextStyle rowStyle(bool isHeader, bool isBold) => TextStyle(
        fontWeight: isBold
            ? FontWeight.bold
            : isHeader
                ? FontWeight.w600
                : FontWeight.normal,
        fontSize: 14,
      );

  void showPaymentSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => Dialog(
        backgroundColor: AppColors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              /// Title and close
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Payment Received Successfully',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Get.back(),
                    child: Icon(Icons.close),
                  ),
                  SizedBox(width: 10),
                ],
              ),
              const SizedBox(height: 16),

              /// Payment text
              const Text(
                'Payment of ₹899 for Order ID#12345 has been successfully received.',
                style: TextStyle(fontSize: 14),
              ),

              const SizedBox(height: 20),

              /// OK button
              CustomFullButton(
                title: "OK",
                width: 100,
                onTap: () => Navigator.pop(context),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String formatDate(String? dateStr) {
    if (dateStr == null || dateStr.isEmpty) return '';
    try {
      final dateTime = DateTime.parse(dateStr);
      final formatter = DateFormat(' h:mm a');
      return formatter.format(dateTime);
    } catch (e) {
      return dateStr; // fallback to raw if parsing fails
    }
  }

  Widget _profileTabWidget(BuildContext context) {
    // Fetch user session from SessionStorage (adjust if your SessionStorage API is different)
    final userSession = SessionStorage.getUserSession();

    if (userSession == null) {
      return const Center(child: Text("No user session found."));
    }

    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Profile icon
          Icon(Icons.person, size: 80, color: Colors.grey.shade400),

          const SizedBox(height: 16),

          // User name
          Text(
            userSession.name,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 8),

          // User role
          Text(
            userSession.roleText,
            style: const TextStyle(fontSize: 16, color: Colors.black54),
          ),

          const SizedBox(height: 16),

          // Company name (with icon)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.business, size: 18, color: Colors.black54),
              const SizedBox(width: 6),
              Text(
                userSession.companyName,
                style: const TextStyle(fontSize: 15, color: Colors.black54),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Last login time (with icon)
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.center,
          //   children: [
          //     const Icon(Icons.access_time, size: 18, color: Colors.black54),
          //     const SizedBox(width: 6),
          //     // Text(
          //     //   "Last Login: ${userSession.lastLogin}",
          //     //   style: const TextStyle(fontSize: 15, color: Colors.black54),
          //     // ),
          //   ],
          // ),

          const SizedBox(height: 32),

          // Logout button
          ElevatedButton.icon(
            icon: const Icon(Icons.logout, color: Colors.white),
            label: const Text(
              "Logout",
              style: TextStyle(color: AppColors.white),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
            ),
            onPressed: () async {
              await SessionStorage.removeUserSession();
              Get.offAllNamed('/login'); // Navigate to login route after logout
            },
          ),
        ],
      ),
    );
  }
}
