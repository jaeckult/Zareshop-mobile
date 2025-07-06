import 'package:flutter/material.dart';
import '../../../../core/constants/app_constants.dart';
import 'chat_conversation_screen.dart';

class ChatScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        title: Text(
          'Messages',
          style: TextStyle(
            color: kTextPrimaryColor,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.search, color: kTextPrimaryColor),
            onPressed: () {
              _showSearchDialog(context);
            },
          ),
          PopupMenuButton<String>(
            icon: Icon(Icons.more_vert, color: kTextPrimaryColor),
            onSelected: (value) {
              switch (value) {
                case 'mark_all_read':
                  _markAllAsRead(context);
                  break;
                case 'clear_all':
                  _clearAllChats(context);
                  break;
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'mark_all_read',
                child: Row(
                  children: [
                    Icon(Icons.mark_email_read, color: kAccentColor),
                    SizedBox(width: 8),
                    Text('Mark all as read'),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'clear_all',
                child: Row(
                  children: [
                    Icon(Icons.clear_all, color: Colors.red),
                    SizedBox(width: 8),
                    Text('Clear all chats'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          // Search bar
          Container(
            padding: EdgeInsets.all(16),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search conversations...',
                hintStyle: TextStyle(color: kTextLightColor),
                prefixIcon: Icon(Icons.search, color: kTextLightColor),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
            ),
          ),
          // Chat list
          Expanded(
            child: ListView(
              padding: EdgeInsets.symmetric(horizontal: 16),
              children: [
                _buildChatItem(
                  context,
                  name: 'Alex Petrov',
                  lastMessage: 'Is this still available?',
                  time: '2 min ago',
                  unreadCount: 1,
                  imageUrl: 'https://via.placeholder.com/50x50/0066CC/FFFFFF?text=AP',
                  isOnline: true,
                  itemTitle: 'iPhone 14 Pro Max',
                  itemPrice: '₽85,000',
                ),
                _buildChatItem(
                  context,
                  name: 'Maria Ivanova',
                  lastMessage: 'Can you send more photos?',
                  time: '1 hour ago',
                  unreadCount: 0,
                  imageUrl: 'https://via.placeholder.com/50x50/0066CC/FFFFFF?text=MI',
                  isOnline: false,
                  itemTitle: 'MacBook Pro M2',
                  itemPrice: '₽125,000',
                ),
                _buildChatItem(
                  context,
                  name: 'Dmitry Sokolov',
                  lastMessage: 'What\'s the best price you can offer?',
                  time: '3 hours ago',
                  unreadCount: 2,
                  imageUrl: 'https://via.placeholder.com/50x50/0066CC/FFFFFF?text=DS',
                  isOnline: true,
                  itemTitle: 'Toyota Camry 2019',
                  itemPrice: '₽2,150,000',
                ),
                _buildChatItem(
                  context,
                  name: 'Elena Kuznetsova',
                  lastMessage: 'I\'m interested in your item',
                  time: '1 day ago',
                  unreadCount: 0,
                  imageUrl: 'https://via.placeholder.com/50x50/0066CC/FFFFFF?text=EK',
                  isOnline: false,
                  itemTitle: 'Samsung 65" TV',
                  itemPrice: '₽65,000',
                ),
                _buildChatItem(
                  context,
                  name: 'Sergey Volkov',
                  lastMessage: 'When can I come to see it?',
                  time: '2 days ago',
                  unreadCount: 0,
                  imageUrl: 'https://via.placeholder.com/50x50/0066CC/FFFFFF?text=SV',
                  isOnline: false,
                  itemTitle: 'Yamaha R1 1000cc',
                  itemPrice: '₽850,000',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChatItem(
    BuildContext context, {
    required String name,
    required String lastMessage,
    required String time,
    required int unreadCount,
    required String imageUrl,
    required bool isOnline,
    required String itemTitle,
    required String itemPrice,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
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
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChatConversationScreen(
                userName: name,
                userAvatar: imageUrl,
                isOnline: isOnline,
              ),
            ),
          );
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Row(
            children: [
              // User avatar with online status
              Stack(
                children: [
                  CircleAvatar(
                    radius: 25,
                    backgroundImage: NetworkImage(imageUrl),
                    onBackgroundImageError: (exception, stackTrace) {
                      // Handle error
                    },
                  ),
                  if (isOnline)
                    Positioned(
                      right: 0,
                      bottom: 0,
                      child: Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          color: Colors.green,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                      ),
                    ),
                ],
              ),
              SizedBox(width: 12),
              // Chat content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            name,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: kTextPrimaryColor,
                            ),
                          ),
                        ),
                        Text(
                          time,
                          style: TextStyle(
                            fontSize: 12,
                            color: kTextLightColor,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 4),
                    Text(
                      lastMessage,
                      style: TextStyle(
                        fontSize: 14,
                        color: kTextSecondaryColor,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 8),
                    // Item info
                    Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: kBackgroundColor,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: kAccentColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Icon(
                              Icons.image,
                              color: kAccentColor,
                              size: 20,
                            ),
                          ),
                          SizedBox(width: 8),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  itemTitle,
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    color: kTextPrimaryColor,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Text(
                                  itemPrice,
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: kAccentColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              // Unread count
              if (unreadCount > 0) ...[
                SizedBox(width: 8),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: kAccentColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    unreadCount.toString(),
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  void _showSearchDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Search Messages'),
        content: TextField(
          decoration: InputDecoration(
            hintText: 'Enter search term...',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Search functionality coming soon')),
              );
            },
            child: Text('Search'),
          ),
        ],
      ),
    );
  }

  void _markAllAsRead(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('All messages marked as read'),
        backgroundColor: kAccentColor,
      ),
    );
  }

  void _clearAllChats(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Clear All Chats'),
        content: Text('Are you sure you want to clear all chat conversations?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('All chats cleared'),
                  backgroundColor: Colors.red,
                ),
              );
            },
            child: Text('Clear All', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
