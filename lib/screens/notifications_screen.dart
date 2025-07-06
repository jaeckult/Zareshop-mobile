import '../constants.dart';
import 'package:flutter/material.dart';

class NotificationsScreen extends StatefulWidget {
  @override
  _NotificationsScreenState createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  String selectedFilter = 'All';
  List<NotificationItem> notifications = [];

  @override
  void initState() {
    super.initState();
    _loadNotifications();
  }

  void _loadNotifications() {
    notifications = [
      NotificationItem(
        title: 'New message from Alex',
        message: 'Is your iPhone still available?',
        time: '2 minutes ago',
        isUnread: true,
        type: NotificationType.message,
        actionData: {'userId': 'alex123', 'itemId': 'iphone14'},
      ),
      NotificationItem(
        title: 'Your ad was viewed',
        message: 'Toyota Camry 2019 was viewed 15 times today',
        time: '1 hour ago',
        isUnread: true,
        type: NotificationType.view,
        actionData: {'itemId': 'toyota_camry', 'views': 15},
      ),
      NotificationItem(
        title: 'Price drop alert',
        message: 'Similar items in your area dropped in price',
        time: '3 hours ago',
        isUnread: false,
        type: NotificationType.price,
        actionData: {'category': 'cars', 'priceChange': '-10%'},
      ),
      NotificationItem(
        title: 'Ad approved',
        message: 'Your MacBook Pro ad has been approved and is now live',
        time: '1 day ago',
        isUnread: false,
        type: NotificationType.approval,
        actionData: {'itemId': 'macbook_pro', 'status': 'approved'},
      ),
      NotificationItem(
        title: 'New follower',
        message: 'Maria Ivanova started following your ads',
        time: '2 days ago',
        isUnread: false,
        type: NotificationType.follow,
        actionData: {'userId': 'maria456', 'followerCount': 23},
      ),
      NotificationItem(
        title: 'Payment received',
        message: 'You received ₽85,000 for iPhone 14 Pro Max',
        time: '3 days ago',
        isUnread: false,
        type: NotificationType.payment,
        actionData: {'amount': '₽85,000', 'itemId': 'iphone14'},
      ),
      NotificationItem(
        title: 'Ad expiring soon',
        message: 'Your Samsung TV ad expires in 2 days. Renew now!',
        time: '1 week ago',
        isUnread: false,
        type: NotificationType.expiry,
        actionData: {'itemId': 'samsung_tv', 'daysLeft': 2},
      ),
      NotificationItem(
        title: 'New review received',
        message: 'Alex Petrov left you a 5-star review',
        time: '1 week ago',
        isUnread: false,
        type: NotificationType.review,
        actionData: {'userId': 'alex123', 'rating': 5, 'reviewId': 'rev123'},
      ),
    ];
  }

  List<NotificationItem> get filteredNotifications {
    if (selectedFilter == 'All') {
      return notifications;
    }
    return notifications.where((notification) {
      switch (selectedFilter) {
        case 'Unread':
          return notification.isUnread;
        case 'Messages':
          return notification.type == NotificationType.message;
        case 'Views':
          return notification.type == NotificationType.view;
        case 'Payments':
          return notification.type == NotificationType.payment;
        default:
          return true;
      }
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        title: Text(
          'Notifications',
          style: TextStyle(
            color: kTextPrimaryColor,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: _markAllAsRead,
            child: Text(
              'Mark all read',
              style: TextStyle(
                color: kAccentColor,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Filter chips
          Container(
            height: 50,
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                _buildFilterChip('All', selectedFilter == 'All'),
                _buildFilterChip('Unread', selectedFilter == 'Unread'),
                _buildFilterChip('Messages', selectedFilter == 'Messages'),
                _buildFilterChip('Views', selectedFilter == 'Views'),
                _buildFilterChip('Payments', selectedFilter == 'Payments'),
              ],
            ),
          ),
          // Stats summary
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    'Total',
                    '${notifications.length}',
                    Icons.notifications,
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: _buildStatCard(
                    'Unread',
                    '${notifications.where((n) => n.isUnread).length}',
                    Icons.mark_email_unread,
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: _buildStatCard(
                    'Today',
                    '${notifications.where((n) => n.time.contains('min') || n.time.contains('hour')).length}',
                    Icons.today,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 16),
          // Notifications list
          Expanded(
            child: filteredNotifications.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    itemCount: filteredNotifications.length,
                    itemBuilder: (context, index) {
                      return _buildNotificationCard(filteredNotifications[index]);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, bool isSelected) {
    return Container(
      margin: EdgeInsets.only(right: 8),
      child: FilterChip(
        label: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : kTextSecondaryColor,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
        selected: isSelected,
        onSelected: (selected) {
          setState(() {
            selectedFilter = label;
          });
        },
        backgroundColor: Colors.white,
        selectedColor: kAccentColor,
        side: BorderSide(
          color: isSelected ? kAccentColor : kBorderColor,
        ),
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, color: kAccentColor, size: 24),
          SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: kTextPrimaryColor,
            ),
          ),
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              color: kTextSecondaryColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationCard(NotificationItem notification) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: notification.isUnread ? kAccentColor.withOpacity(0.05) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: notification.isUnread 
            ? Border.all(color: kAccentColor.withOpacity(0.2))
            : null,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: InkWell(
        onTap: () => _handleNotificationTap(notification),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Row(
            children: [
              // Notification icon
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: _getNotificationColor(notification.type).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  _getNotificationIcon(notification.type),
                  color: _getNotificationColor(notification.type),
                  size: 24,
                ),
              ),
              SizedBox(width: 12),
              // Notification content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            notification.title,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: notification.isUnread ? FontWeight.w600 : FontWeight.w500,
                              color: kTextPrimaryColor,
                            ),
                          ),
                        ),
                        if (notification.isUnread)
                          Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: kAccentColor,
                              shape: BoxShape.circle,
                            ),
                          ),
                      ],
                    ),
                    SizedBox(height: 4),
                    Text(
                      notification.message,
                      style: TextStyle(
                        fontSize: 14,
                        color: kTextSecondaryColor,
                      ),
                    ),
                    SizedBox(height: 8),
                    Row(
                      children: [
                        Text(
                          notification.time,
                          style: TextStyle(
                            fontSize: 12,
                            color: kTextLightColor,
                          ),
                        ),
                        Spacer(),
                        // Action buttons
                        if (notification.type == NotificationType.message)
                          TextButton(
                            onPressed: () => _handleNotificationAction(notification, 'reply'),
                            child: Text(
                              'Reply',
                              style: TextStyle(
                                fontSize: 12,
                                color: kAccentColor,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        if (notification.type == NotificationType.expiry)
                          TextButton(
                            onPressed: () => _handleNotificationAction(notification, 'renew'),
                            child: Text(
                              'Renew',
                              style: TextStyle(
                                fontSize: 12,
                                color: kAccentColor,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            _getEmptyStateIcon(),
            size: 64,
            color: kTextLightColor,
          ),
          SizedBox(height: 16),
          Text(
            _getEmptyStateText(),
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: kTextSecondaryColor,
            ),
          ),
          SizedBox(height: 8),
          Text(
            _getEmptyStateSubtext(),
            style: TextStyle(
              fontSize: 14,
              color: kTextLightColor,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Color _getNotificationColor(NotificationType type) {
    switch (type) {
      case NotificationType.message:
        return kAccentColor;
      case NotificationType.view:
        return Colors.blue;
      case NotificationType.price:
        return Colors.orange;
      case NotificationType.approval:
        return Colors.green;
      case NotificationType.follow:
        return Colors.purple;
      case NotificationType.payment:
        return Colors.green;
      case NotificationType.expiry:
        return Colors.red;
      case NotificationType.review:
        return Colors.amber;
    }
  }

  IconData _getNotificationIcon(NotificationType type) {
    switch (type) {
      case NotificationType.message:
        return Icons.chat_bubble;
      case NotificationType.view:
        return Icons.visibility;
      case NotificationType.price:
        return Icons.trending_down;
      case NotificationType.approval:
        return Icons.check_circle;
      case NotificationType.follow:
        return Icons.person_add;
      case NotificationType.payment:
        return Icons.payment;
      case NotificationType.expiry:
        return Icons.timer_off;
      case NotificationType.review:
        return Icons.star;
    }
  }

  IconData _getEmptyStateIcon() {
    switch (selectedFilter) {
      case 'Unread':
        return Icons.mark_email_read;
      case 'Messages':
        return Icons.chat_bubble_outline;
      case 'Views':
        return Icons.visibility_off;
      case 'Payments':
        return Icons.payment_outlined;
      default:
        return Icons.notifications_none;
    }
  }

  String _getEmptyStateText() {
    switch (selectedFilter) {
      case 'Unread':
        return 'No Unread Notifications';
      case 'Messages':
        return 'No Message Notifications';
      case 'Views':
        return 'No View Notifications';
      case 'Payments':
        return 'No Payment Notifications';
      default:
        return 'No Notifications';
    }
  }

  String _getEmptyStateSubtext() {
    switch (selectedFilter) {
      case 'Unread':
        return 'All caught up! You have no unread notifications.';
      case 'Messages':
        return 'You\'ll see message notifications here when someone contacts you.';
      case 'Views':
        return 'View notifications will appear when people look at your ads.';
      case 'Payments':
        return 'Payment notifications will show when you receive money.';
      default:
        return 'You\'ll see notifications here when there\'s activity on your account.';
    }
  }

  void _handleNotificationTap(NotificationItem notification) {
    setState(() {
      notification.isUnread = false;
    });
    
    switch (notification.type) {
      case NotificationType.message:
        // Navigate to chat
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Opening chat with ${notification.title.split(' ')[3]}')),
        );
        break;
      case NotificationType.view:
        // Navigate to item details
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Opening item details')),
        );
        break;
      case NotificationType.payment:
        // Navigate to payment details
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Opening payment details')),
        );
        break;
      default:
        // Generic notification tap
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Notification tapped')),
        );
    }
  }

  void _handleNotificationAction(NotificationItem notification, String action) {
    switch (action) {
      case 'reply':
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Opening reply to ${notification.title.split(' ')[3]}')),
        );
        break;
      case 'renew':
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Renewing ad...')),
        );
        break;
    }
  }

  void _markAllAsRead() {
    setState(() {
      for (var notification in notifications) {
        notification.isUnread = false;
      }
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('All notifications marked as read'),
        backgroundColor: kAccentColor,
      ),
    );
  }
}

class NotificationItem {
  String title;
  String message;
  String time;
  bool isUnread;
  NotificationType type;
  Map<String, dynamic> actionData;

  NotificationItem({
    required this.title,
    required this.message,
    required this.time,
    required this.isUnread,
    required this.type,
    required this.actionData,
  });
}

enum NotificationType {
  message,
  view,
  price,
  approval,
  follow,
  payment,
  expiry,
  review,
}
