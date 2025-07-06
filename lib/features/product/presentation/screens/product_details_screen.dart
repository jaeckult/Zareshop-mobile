import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../shared/models/product_model.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:share_plus/share_plus.dart';

class ProductDetailsScreen extends StatefulWidget {
  final AvitoItem item;

  ProductDetailsScreen({required this.item});

  @override
  _ProductDetailsScreenState createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  int _currentImageIndex = 0;
  bool _isFavorite = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      body: CustomScrollView(
        slivers: [
          // App bar with images
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            backgroundColor: Colors.white,
            leading: IconButton(
              icon: Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.9),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.arrow_back, color: kTextPrimaryColor),
              ),
              onPressed: () => Navigator.pop(context),
            ),
            actions: [
              IconButton(
                icon: Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.9),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    _isFavorite ? Icons.favorite : Icons.favorite_border,
                    color: _isFavorite ? Colors.red : kTextPrimaryColor,
                  ),
                ),
                onPressed: () {
                  setState(() {
                    _isFavorite = !_isFavorite;
                  });
                },
              ),
              IconButton(
                icon: Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.9),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.share, color: kTextPrimaryColor),
                ),
                onPressed: () => _showShareDialog(),
                iconSize: 20,
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                children: [
                  // Main image
                  PageView.builder(
                    itemCount: 3, // Simulating multiple images
                    onPageChanged: (index) {
                      setState(() {
                        _currentImageIndex = index;
                      });
                    },
                    itemBuilder: (context, index) {
                      return Image.network(
                        widget.item.imageUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: kBackgroundColor,
                            child: Icon(
                              Icons.image,
                              color: kIconsColor,
                              size: 64,
                            ),
                          );
                        },
                      );
                    },
                  ),
                  // Image indicators
                  Positioned(
                    bottom: 16,
                    left: 0,
                    right: 0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(3, (index) {
                        return Container(
                          margin: EdgeInsets.symmetric(horizontal: 4),
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color:
                                _currentImageIndex == index
                                    ? Colors.white
                                    : Colors.white.withOpacity(0.5),
                          ),
                        );
                      }),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Product content
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Price and title section
                Container(
                  padding: EdgeInsets.all(16),
                  color: Colors.white,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.item.price,
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: kAccentColor,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        widget.item.title,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: kTextPrimaryColor,
                        ),
                      ),
                      SizedBox(height: 12),
                      Row(
                        children: [
                          Icon(
                            Icons.location_on_outlined,
                            size: 16,
                            color: kTextLightColor,
                          ),
                          SizedBox(width: 4),
                          Text(
                            widget.item.location,
                            style: TextStyle(
                              fontSize: 14,
                              color: kTextSecondaryColor,
                            ),
                          ),
                          Spacer(),
                          Text(
                            widget.item.timeAgo,
                            style: TextStyle(
                              fontSize: 12,
                              color: kTextLightColor,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 8),
                // Seller information
                Container(
                  padding: EdgeInsets.all(16),
                  color: Colors.white,
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 25,
                        backgroundColor: kAccentColor,
                        child: Icon(
                          Icons.person,
                          color: Colors.white,
                          size: 30,
                        ),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'John Doe',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: kTextPrimaryColor,
                              ),
                            ),
                            Text(
                              'Member since 2020',
                              style: TextStyle(
                                fontSize: 12,
                                color: kTextSecondaryColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: kAccentColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Text(
                          '4.8 ★',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: kAccentColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 8),
                // Description
                Container(
                  padding: EdgeInsets.all(16),
                  color: Colors.white,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Description',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: kTextPrimaryColor,
                        ),
                      ),
                      SizedBox(height: 12),
                      Text(
                        'This is a detailed description of the item. It includes all the important features, condition details, and any additional information that buyers might need to know. The item is in excellent condition and comes with all original accessories.',
                        style: TextStyle(
                          fontSize: 14,
                          color: kTextSecondaryColor,
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 8),
                // Specifications
                Container(
                  padding: EdgeInsets.all(16),
                  color: Colors.white,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Specifications',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: kTextPrimaryColor,
                        ),
                      ),
                      SizedBox(height: 12),
                      _buildSpecItem('Category', widget.item.category),
                      _buildSpecItem('Condition', 'Excellent'),
                      _buildSpecItem('Brand', 'Apple'),
                      _buildSpecItem('Model', 'iPhone 14 Pro Max'),
                      _buildSpecItem('Storage', '256GB'),
                      _buildSpecItem('Color', 'Space Black'),
                    ],
                  ),
                ),
                SizedBox(height: 8),
                // Similar items
                Container(
                  padding: EdgeInsets.all(16),
                  color: Colors.white,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Similar Items',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: kTextPrimaryColor,
                        ),
                      ),
                      SizedBox(height: 12),
                      Container(
                        height: 120,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: 5,
                          itemBuilder: (context, index) {
                            return Container(
                              width: 100,
                              margin: EdgeInsets.only(right: 12),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Image.network(
                                      'https://picsum.photos/100/80?random=${index + 1}',
                                      width: 100,
                                      height: 80,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    '₽${(index + 1) * 10000}',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: kAccentColor,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 100), // Space for bottom buttons
              ],
            ),
          ),
        ],
      ),
      // Bottom action buttons
      bottomSheet: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: Offset(0, -2),
            ),
          ],
        ),
        child: SafeArea(
          child: Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => _showMessageDialog(),
                  icon: Icon(Icons.chat_bubble_outline),
                  label: Text('Message'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: kAccentColor,
                    side: BorderSide(color: kAccentColor),
                    padding: EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => _showCallDialog(),
                  icon: Icon(Icons.phone),
                  label: Text('Call'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kAccentColor,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSpecItem(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Text(
            '$label:',
            style: TextStyle(fontSize: 14, color: kTextSecondaryColor),
          ),
          SizedBox(width: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: kTextPrimaryColor,
            ),
          ),
        ],
      ),
    );
  }

  void _showShareDialog() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle bar
            Container(
              margin: EdgeInsets.only(top: 12),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            // Title
            Padding(
              padding: EdgeInsets.all(20),
              child: Text(
                'Share Product',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: kTextPrimaryColor,
                ),
              ),
            ),
            // Share options
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  // Copy link option
                  InkWell(
                    onTap: () {
                      Clipboard.setData(ClipboardData(text: widget.item.link));
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Row(
                            children: [
                              Icon(Icons.check_circle, color: Colors.white),
                              SizedBox(width: 8),
                              Text('Link copied to clipboard!'),
                            ],
                          ),
                          backgroundColor: Colors.green,
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      );
                    },
                    child: Container(
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: kAccentColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: kAccentColor.withOpacity(0.3),
                          width: 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: kAccentColor,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.copy,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                          SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Copy Link',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: kTextPrimaryColor,
                                  ),
                                ),
                                Text(
                                  'Copy product link to clipboard',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: kTextSecondaryColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Icon(
                            Icons.arrow_forward_ios,
                            color: kTextLightColor,
                            size: 16,
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 12),
                  // Share via system option
                  // Share via specific platforms
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _buildPlatformButton(
                              context: context,
                              icon: Icons.telegram,
                              label: 'Telegram',
                              color: Colors.blueAccent,
                              url:
                                  'https://t.me/share/url?url=${Uri.encodeComponent(widget.item.link)}&text=${Uri.encodeComponent(widget.item.title)}',
                            ),
                            _buildPlatformButton(
                              context: context,
                              icon: Icons.facebook,
                              label: 'Facebook',
                              color: Colors.blue,
                              url:
                                  'https://www.facebook.com/sharer/sharer.php?u=${Uri.encodeComponent(widget.item.link)}',
                            ),
                            _buildPlatformButton(
                              context: context,
                              icon: Icons.camera_alt, // substitute for Instagram
                              label: 'Instagram',
                              color: Colors.purple,
                              url: 'https://www.instagram.com/', // Instagram doesn't support web share links
                            ),
                          ],
                        ),
                        SizedBox(height: 20),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlatformButton({
    required BuildContext context,
    required IconData icon,
    required String label,
    required Color color,
    required String url,
  }) {
    return Column(
      children: [
        InkWell(
          onTap: () async {
            if (await canLaunchUrl(Uri.parse(url))) {
              await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Could not launch $label')),
              );
            }
            Navigator.pop(context);
          },
          child: CircleAvatar(
            radius: 28,
            backgroundColor: color,
            child: Icon(icon, color: Colors.white),
          ),
        ),
        SizedBox(height: 8),
        Text(label, style: TextStyle(fontSize: 12)),
      ],
    );
  }

  void _showMessageDialog() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle bar
            Container(
              margin: EdgeInsets.only(top: 12),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            // Title
            Padding(
              padding: EdgeInsets.all(20),
              child: Text(
                'Send Message',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: kTextPrimaryColor,
                ),
              ),
            ),
            // Message options
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  // WhatsApp option
                  InkWell(
                    onTap: () async {
                      final message = 'Hi! I\'m interested in your product: ${widget.item.title}';
                      final whatsappUrl = 'https://wa.me/+79001234567?text=${Uri.encodeComponent(message)}';
                      if (await canLaunchUrl(Uri.parse(whatsappUrl))) {
                        await launchUrl(Uri.parse(whatsappUrl), mode: LaunchMode.externalApplication);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('WhatsApp not available')),
                        );
                      }
                      Navigator.pop(context);
                    },
                    child: Container(
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.green.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Colors.green.withOpacity(0.3),
                          width: 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.green,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.chat_bubble,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                          SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'WhatsApp',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: kTextPrimaryColor,
                                  ),
                                ),
                                Text(
                                  'Send message via WhatsApp',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: kTextSecondaryColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Icon(
                            Icons.arrow_forward_ios,
                            color: kTextLightColor,
                            size: 16,
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 12),
                  // Telegram option
                  InkWell(
                    onTap: () async {
                      final message = 'Hi! I\'m interested in your product: ${widget.item.title}';
                      final telegramUrl = 'https://t.me/+79001234567?text=${Uri.encodeComponent(message)}';
                      if (await canLaunchUrl(Uri.parse(telegramUrl))) {
                        await launchUrl(Uri.parse(telegramUrl), mode: LaunchMode.externalApplication);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Telegram not available')),
                        );
                      }
                      Navigator.pop(context);
                    },
                    child: Container(
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.blue.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Colors.blue.withOpacity(0.3),
                          width: 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.blue,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.telegram,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                          SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Telegram',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: kTextPrimaryColor,
                                  ),
                                ),
                                Text(
                                  'Send message via Telegram',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: kTextSecondaryColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Icon(
                            Icons.arrow_forward_ios,
                            color: kTextLightColor,
                            size: 16,
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 12),
                  // Email option
                  InkWell(
                    onTap: () async {
                      final subject = 'Inquiry about: ${widget.item.title}';
                      final body = 'Hi,\n\nI\'m interested in your product: ${widget.item.title}\nPrice: ${widget.item.price}\n\nCould you please provide more information?\n\nBest regards';
                      final emailUrl = 'mailto:seller@zareshop.com?subject=${Uri.encodeComponent(subject)}&body=${Uri.encodeComponent(body)}';
                      if (await canLaunchUrl(Uri.parse(emailUrl))) {
                        await launchUrl(Uri.parse(emailUrl), mode: LaunchMode.externalApplication);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Email app not available')),
                        );
                      }
                      Navigator.pop(context);
                    },
                    child: Container(
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.orange.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Colors.orange.withOpacity(0.3),
                          width: 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.orange,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.email,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                          SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Email',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: kTextPrimaryColor,
                                  ),
                                ),
                                Text(
                                  'Send email to seller',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: kTextSecondaryColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Icon(
                            Icons.arrow_forward_ios,
                            color: kTextLightColor,
                            size: 16,
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showCallDialog() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle bar
            Container(
              margin: EdgeInsets.only(top: 12),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            // Title
            Padding(
              padding: EdgeInsets.all(20),
              child: Text(
                'Call Seller',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: kTextPrimaryColor,
                ),
              ),
            ),
            // Call options
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  // Direct call option
                  InkWell(
                    onTap: () async {
                      final phoneUrl = 'tel:+79001234567';
                      if (await canLaunchUrl(Uri.parse(phoneUrl))) {
                        await launchUrl(Uri.parse(phoneUrl), mode: LaunchMode.externalApplication);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Phone app not available')),
                        );
                      }
                      Navigator.pop(context);
                    },
                    child: Container(
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: kAccentColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: kAccentColor.withOpacity(0.3),
                          width: 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: kAccentColor,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.phone,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                          SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Call Now',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: kTextPrimaryColor,
                                  ),
                                ),
                                Text(
                                  '+7 (900) 123-45-67',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: kTextSecondaryColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Icon(
                            Icons.arrow_forward_ios,
                            color: kTextLightColor,
                            size: 16,
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 12),
                  // WhatsApp call option
                  InkWell(
                    onTap: () async {
                      final whatsappUrl = 'https://wa.me/+79001234567';
                      if (await canLaunchUrl(Uri.parse(whatsappUrl))) {
                        await launchUrl(Uri.parse(whatsappUrl), mode: LaunchMode.externalApplication);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('WhatsApp not available')),
                        );
                      }
                      Navigator.pop(context);
                    },
                    child: Container(
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.green.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Colors.green.withOpacity(0.3),
                          width: 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.green,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.chat_bubble,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                          SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'WhatsApp Call',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: kTextPrimaryColor,
                                  ),
                                ),
                                Text(
                                  'Call via WhatsApp',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: kTextSecondaryColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Icon(
                            Icons.arrow_forward_ios,
                            color: kTextLightColor,
                            size: 16,
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 12),
                  // Telegram call option
                  InkWell(
                    onTap: () async {
                      final telegramUrl = 'https://t.me/+79001234567';
                      if (await canLaunchUrl(Uri.parse(telegramUrl))) {
                        await launchUrl(Uri.parse(telegramUrl), mode: LaunchMode.externalApplication);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Telegram not available')),
                        );
                      }
                      Navigator.pop(context);
                    },
                    child: Container(
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.blue.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Colors.blue.withOpacity(0.3),
                          width: 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.blue,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.telegram,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                          SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Telegram Call',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: kTextPrimaryColor,
                                  ),
                                ),
                                Text(
                                  'Call via Telegram',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: kTextSecondaryColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Icon(
                            Icons.arrow_forward_ios,
                            color: kTextLightColor,
                            size: 16,
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
