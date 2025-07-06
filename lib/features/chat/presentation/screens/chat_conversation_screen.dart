import 'package:flutter/material.dart';
import '../../../../core/constants/app_constants.dart';

class ChatConversationScreen extends StatefulWidget {
  final String userName;
  final String userAvatar;
  final bool isOnline;

  ChatConversationScreen({
    required this.userName,
    required this.userAvatar,
    required this.isOnline,
  });

  @override
  _ChatConversationScreenState createState() => _ChatConversationScreenState();
}

class _ChatConversationScreenState extends State<ChatConversationScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _isTyping = false;

  List<ChatMessage> messages = [
    ChatMessage(
      text: 'Hi! Is this iPhone still available?',
      isMe: false,
      timestamp: DateTime.now().subtract(Duration(minutes: 5)),
    ),
    ChatMessage(
      text: 'Yes, it\'s still available! Are you interested?',
      isMe: true,
      timestamp: DateTime.now().subtract(Duration(minutes: 4)),
    ),
    ChatMessage(
      text: 'Yes, I am. Can you send me more photos?',
      isMe: false,
      timestamp: DateTime.now().subtract(Duration(minutes: 3)),
    ),
    ChatMessage(
      text: 'Of course! I\'ll send you additional photos in a moment.',
      isMe: true,
      timestamp: DateTime.now().subtract(Duration(minutes: 2)),
    ),
    ChatMessage(
      text: 'What\'s the best price you can offer?',
      isMe: false,
      timestamp: DateTime.now().subtract(Duration(minutes: 1)),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: kTextPrimaryColor),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          children: [
            Stack(
              children: [
                CircleAvatar(
                  radius: 18,
                  backgroundImage: NetworkImage(widget.userAvatar),
                  onBackgroundImageError: (exception, stackTrace) {
                    // Handle error
                  },
                ),
                if (widget.isOnline)
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: Container(
                      width: 10,
                      height: 10,
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
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.userName,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: kTextPrimaryColor,
                    ),
                  ),
                  Text(
                    widget.isOnline ? 'Online' : 'Last seen recently',
                    style: TextStyle(
                      fontSize: 12,
                      color: widget.isOnline ? Colors.green : kTextLightColor,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.phone, color: kAccentColor),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Icons.video_call, color: kAccentColor),
            onPressed: () {},
          ),
          PopupMenuButton<String>(
            icon: Icon(Icons.more_vert, color: kTextPrimaryColor),
            onSelected: (value) {
              switch (value) {
                case 'block':
                  _showBlockDialog();
                  break;
                case 'report':
                  _showReportDialog();
                  break;
                case 'clear':
                  _showClearChatDialog();
                  break;
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'block',
                child: Row(
                  children: [
                    Icon(Icons.block, color: Colors.red),
                    SizedBox(width: 8),
                    Text('Block User'),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'report',
                child: Row(
                  children: [
                    Icon(Icons.report, color: Colors.orange),
                    SizedBox(width: 8),
                    Text('Report'),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'clear',
                child: Row(
                  children: [
                    Icon(Icons.clear_all, color: kTextSecondaryColor),
                    SizedBox(width: 8),
                    Text('Clear Chat'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          // Messages list
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: EdgeInsets.all(16),
              itemCount: messages.length + (_isTyping ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == messages.length && _isTyping) {
                  return _buildTypingIndicator();
                }
                return _buildMessageBubble(messages[index]);
              },
            ),
          ),
          // Message input
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 8,
                  offset: Offset(0, -2),
                ),
              ],
            ),
            child: SafeArea(
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.attach_file, color: kTextSecondaryColor),
                    onPressed: () {
                      _showAttachmentOptions();
                    },
                  ),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: kBackgroundColor,
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(color: kBorderColor),
                      ),
                      child: TextField(
                        controller: _messageController,
                        decoration: InputDecoration(
                          hintText: 'Type a message...',
                          hintStyle: TextStyle(color: kTextLightColor),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                        ),
                        maxLines: null,
                        textCapitalization: TextCapitalization.sentences,
                      ),
                    ),
                  ),
                  SizedBox(width: 8),
                  Container(
                    decoration: BoxDecoration(
                      color: kAccentColor,
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: Icon(Icons.send, color: Colors.white),
                      onPressed: _sendMessage,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(ChatMessage message) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: message.isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!message.isMe) ...[
            CircleAvatar(
              radius: 12,
              backgroundImage: NetworkImage(widget.userAvatar),
            ),
            SizedBox(width: 8),
          ],
          Flexible(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: message.isMe ? kAccentColor : Colors.white,
                borderRadius: BorderRadius.circular(18),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 4,
                    offset: Offset(0, 1),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    message.text,
                    style: TextStyle(
                      fontSize: 14,
                      color: message.isMe ? Colors.white : kTextPrimaryColor,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    _formatTime(message.timestamp),
                    style: TextStyle(
                      fontSize: 11,
                      color: message.isMe ? Colors.white70 : kTextLightColor,
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (message.isMe) ...[
            SizedBox(width: 8),
            Icon(
              message.isRead ? Icons.done_all : Icons.done,
              size: 16,
              color: message.isRead ? kAccentColor : kTextLightColor,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildTypingIndicator() {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          CircleAvatar(
            radius: 12,
            backgroundImage: NetworkImage(widget.userAvatar),
          ),
          SizedBox(width: 8),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildTypingDot(0),
                _buildTypingDot(1),
                _buildTypingDot(2),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTypingDot(int index) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 600),
      margin: EdgeInsets.symmetric(horizontal: 2),
      width: 6,
      height: 6,
      decoration: BoxDecoration(
        color: kTextLightColor,
        shape: BoxShape.circle,
      ),
    );
  }

  String _formatTime(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inMinutes < 1) {
      return 'now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else {
      return '${timestamp.day}/${timestamp.month}';
    }
  }

  void _sendMessage() {
    if (_messageController.text.trim().isNotEmpty) {
      setState(() {
        messages.add(ChatMessage(
          text: _messageController.text.trim(),
          isMe: true,
          timestamp: DateTime.now(),
        ));
      });
      _messageController.clear();
      _scrollToBottom();
      
      // Simulate typing indicator
      setState(() {
        _isTyping = true;
      });
      
      Future.delayed(Duration(seconds: 2), () {
        setState(() {
          _isTyping = false;
          messages.add(ChatMessage(
            text: 'Thanks for your message! I\'ll get back to you soon.',
            isMe: false,
            timestamp: DateTime.now(),
          ));
        });
        _scrollToBottom();
      });
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _showAttachmentOptions() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.photo, color: kAccentColor),
              title: Text('Photo'),
              onTap: () {
                Navigator.pop(context);
                // Handle photo attachment
              },
            ),
            ListTile(
              leading: Icon(Icons.camera_alt, color: kAccentColor),
              title: Text('Camera'),
              onTap: () {
                Navigator.pop(context);
                // Handle camera
              },
            ),
            ListTile(
              leading: Icon(Icons.location_on, color: kAccentColor),
              title: Text('Location'),
              onTap: () {
                Navigator.pop(context);
                // Handle location sharing
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showBlockDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Block User'),
        content: Text('Are you sure you want to block ${widget.userName}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('User blocked')),
              );
            },
            child: Text('Block', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _showReportDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Report User'),
        content: Text('Report ${widget.userName} for inappropriate behavior?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('User reported')),
              );
            },
            child: Text('Report', style: TextStyle(color: Colors.orange)),
          ),
        ],
      ),
    );
  }

  void _showClearChatDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Clear Chat'),
        content: Text('Are you sure you want to clear all messages?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                messages.clear();
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Chat cleared')),
              );
            },
            child: Text('Clear', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }
}

class ChatMessage {
  final String text;
  final bool isMe;
  final DateTime timestamp;
  final bool isRead;

  ChatMessage({
    required this.text,
    required this.isMe,
    required this.timestamp,
    this.isRead = false,
  });
} 