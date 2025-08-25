import 'package:flutter/material.dart';
import 'package:cook_waiter/App/Themes/app_colors.dart';
import 'package:cook_waiter/App/common_widgets/common_custom_button.dart';

class NotificationPopup extends StatefulWidget {
  final List<Map<String, dynamic>> notifications;
  final VoidCallback onMarkAllRead;

  const NotificationPopup({
    Key? key,
    required this.notifications,
    required this.onMarkAllRead,
  }) : super(key: key);

  @override
  State<NotificationPopup> createState() => _NotificationPopupState();
}

class _NotificationPopupState extends State<NotificationPopup> {
  int selectedTab = 0; // 0 = Unread, 1 = All

  @override
  Widget build(BuildContext context) {
    final unreadNotifications =
        widget.notifications.where((n) => n['isSuccess'] == false).toList();

    final visibleList =
        selectedTab == 0 ? unreadNotifications : widget.notifications;

    return Material(
        elevation: 8,
        borderRadius: BorderRadius.circular(12),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: 360,
              maxHeight: 360, // 👈 required to avoid "not laid out" error
            ),
            child: Container(
              // width: 360,
              // height: 320, // Shows approx 2 items and scrolls for more
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Column(
                children: [
                  // Header
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Notifications",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        GestureDetector(
                          onTap: widget.onMarkAllRead,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                "Mark all as read",
                                style: TextStyle(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Container(
                                height: 1,
                                width: 100,
                                color: AppColors.primary,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Tabs
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 4,
                    ),
                    child: Row(
                      children: [
                        _tabItem("Unread", 0, unreadNotifications.length),
                        const SizedBox(width: 20),
                        _tabItem("All", 1, null),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Notifications list (scrollable)
                  Expanded(
                    child: visibleList.isEmpty
                        ? const Center(
                            child: Text("No notifications found."),
                          )
                        : ListView.builder(
                            itemCount: visibleList.length,
                            padding: EdgeInsets.zero,
                            itemBuilder: (context, index) {
                              final notif = visibleList[index];
                              final isEven = index % 2 == 0;

                              return Container(
                                width: double.infinity,
                                color: isEven && selectedTab == 0
                                    ? AppColors.listGrey
                                    : Colors.white,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 12),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      CircleAvatar(
                                        backgroundColor: notif['isSuccess']
                                            ? Colors.green.shade100
                                            : Colors.orange.shade100,
                                        radius: 20,
                                        child: Text(
                                          notif['userInitials'],
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(notif['message']),
                                            // Text(
                                            //   notif['timeAgo'],
                                            //   style: const TextStyle(
                                            //       color: Colors.grey),
                                            // ),
                                            // const SizedBox(height: 6),
                                            // !notif['isSuccess']
                                            //     ? Text(
                                            //         "Payment Successful",
                                            //         style: TextStyle(
                                            //           color:
                                            //               Colors.green.shade600,
                                            //           fontWeight:
                                            //               FontWeight.bold,
                                            //         ),
                                            //       )
                                            //     :

                                            SizedBox(
                                              height: 10,
                                            ),

                                            notif["showBill"]
                                                ? CustomFullButton(
                                                    width: 120,
                                                    height: 40,
                                                    title: "View Bill",
                                                    onTap: notif['onTap'],
                                                  )
                                                : SizedBox.shrink(),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }

  Widget _tabItem(String label, int index, int? count) {
    final isSelected = selectedTab == index;

    return GestureDetector(
      onTap: () => setState(() => selectedTab = index),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                label,
                style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.normal,
                ),
              ),
              if (count != null) ...[
                const SizedBox(width: 6),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    "$count",
                    style: const TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: 4),
          Container(
            height: 2,
            width: 40,
            color: isSelected ? AppColors.primary : Colors.transparent,
          ),
        ],
      ),
    );
  }
}
