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
    // filter out null isSuccess completely
    final validNotifications =
        widget.notifications.where((n) => n['isSuccess'] != null).toList();

    final unreadNotifications =
        validNotifications.where((n) => n['isSuccess'] == false).toList();

    final visibleList =
        selectedTab == 0 ? unreadNotifications : validNotifications;

    return Material(
      elevation: 8,
      borderRadius: BorderRadius.circular(12),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: 360,
            maxHeight: 360,
          ),
          child: Container(
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
                      _tabItem("All", 1, 0),
                    ],
                  ),
                ),
                const SizedBox(height: 12),

                // Notifications list OR Empty state
                Expanded(
                  child: visibleList.isEmpty
                      ? _emptyState()
                      : ListView.builder(
                          itemCount: visibleList.length,
                          padding: EdgeInsets.zero,
                          itemBuilder: (context, index) {
                            final notif = visibleList[index];
                            final isEven = index % 2 == 0;

                            return Container(
                              width: double.infinity,
                              color: isEven ? AppColors.listGrey : Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 16),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    CircleAvatar(
                                      backgroundColor: notif['isSuccess'] == true
                                          ? Colors.green.shade100
                                          : Colors.orange.shade100,
                                      radius: 20,
                                      child: Text(
                                        notif['userInitials'] ?? '',
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
                                          Text(notif['message'] ?? ''),
                                          const SizedBox(height: 10),
                                          notif["showBill"] == true
                                              ? CustomFullButton(
                                                  width: 120,
                                                  height: 40,
                                                  title: "View Bill",
                                                  onTap: notif['onTap'],
                                                )
                                              : const SizedBox.shrink(),
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
      ),
    );
  }

  /// Tab Item Widget
  Widget _tabItem(String label, int index, int count) {
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
                style: TextStyle(
                  color: isSelected ? AppColors.primary : Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 6),
              count != 0
                  ? Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        "$count",
                        style:
                            const TextStyle(color: Colors.white, fontSize: 12),
                      ),
                    )
                  : const SizedBox(),
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

  /// Empty State Widget
  Widget _emptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.notifications_none,
              size: 60, color: Colors.grey.shade400),
          const SizedBox(height: 12),
          const  Text(
            "No unread notifications",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}
