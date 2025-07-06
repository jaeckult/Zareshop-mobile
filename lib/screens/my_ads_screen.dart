import '../constants.dart';
import '../models/avito_model.dart';
import '../items_list.dart';
import 'package:flutter/material.dart';

class MyAdsScreen extends StatefulWidget {
  @override
  _MyAdsScreenState createState() => _MyAdsScreenState();
}

class _MyAdsScreenState extends State<MyAdsScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String selectedFilter = 'All';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

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
        title: Text(
          'My Ads',
          style: TextStyle(
            color: kTextPrimaryColor,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.add, color: kAccentColor),
            onPressed: () {
              // Navigate to create ad screen
            },
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          labelColor: kAccentColor,
          unselectedLabelColor: kTextSecondaryColor,
          indicatorColor: kAccentColor,
          tabs: [
            Tab(text: 'Active (12)'),
            Tab(text: 'Pending (3)'),
            Tab(text: 'Expired (5)'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildAdsList('active'),
          _buildAdsList('pending'),
          _buildAdsList('expired'),
        ],
      ),
    );
  }

  Widget _buildAdsList(String status) {
    List<AvitoItem> myAds = _getMyAds(status);
    
    return Column(
      children: [
        // Filter chips
        Container(
          height: 50,
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              _buildFilterChip('All', selectedFilter == 'All'),
              _buildFilterChip('Electronics', selectedFilter == 'Electronics'),
              _buildFilterChip('Cars', selectedFilter == 'Cars'),
              _buildFilterChip('Real Estate', selectedFilter == 'Real Estate'),
            ],
          ),
        ),
        // Stats cards
        Container(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              Expanded(
                child: _buildStatCard('Views', '1,234', Icons.visibility),
              ),
              SizedBox(width: 12),
              Expanded(
                child: _buildStatCard('Messages', '45', Icons.chat_bubble),
              ),
              SizedBox(width: 12),
              Expanded(
                child: _buildStatCard('Favorites', '23', Icons.favorite),
              ),
            ],
          ),
        ),
        SizedBox(height: 16),
        // Ads list
        Expanded(
          child: myAds.isEmpty
              ? _buildEmptyState(status)
              : ListView.builder(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  itemCount: myAds.length,
                  itemBuilder: (context, index) {
                    return _buildMyAdCard(myAds[index], status);
                  },
                ),
        ),
      ],
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

  Widget _buildMyAdCard(AvitoItem ad, String status) {
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
      child: Column(
        children: [
          // Ad content
          Padding(
            padding: EdgeInsets.all(16),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    ad.imageUrl,
                    width: 80,
                    height: 80,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        width: 80,
                        height: 80,
                        color: kBackgroundColor,
                        child: Icon(Icons.image, color: kIconsColor),
                      );
                    },
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        ad.title,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: kTextPrimaryColor,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 4),
                      Text(
                        ad.price,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: kAccentColor,
                        ),
                      ),
                      SizedBox(height: 8),
                      Row(
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: _getStatusColor(status).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              _getStatusText(status),
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                                color: _getStatusColor(status),
                              ),
                            ),
                          ),
                          Spacer(),
                          Text(
                            ad.timeAgo,
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
              ],
            ),
          ),
          // Action buttons
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: kBackgroundColor,
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(12)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextButton.icon(
                    onPressed: () {},
                    icon: Icon(Icons.edit, size: 16),
                    label: Text('Edit'),
                    style: TextButton.styleFrom(
                      foregroundColor: kTextSecondaryColor,
                    ),
                  ),
                ),
                Expanded(
                  child: TextButton.icon(
                    onPressed: () {},
                    icon: Icon(Icons.visibility, size: 16),
                    label: Text('View'),
                    style: TextButton.styleFrom(
                      foregroundColor: kAccentColor,
                    ),
                  ),
                ),
                Expanded(
                  child: TextButton.icon(
                    onPressed: () {
                      _showDeleteDialog(ad);
                    },
                    icon: Icon(Icons.delete, size: 16),
                    label: Text('Delete'),
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.red,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(String status) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            _getEmptyStateIcon(status),
            size: 64,
            color: kTextLightColor,
          ),
          SizedBox(height: 16),
          Text(
            _getEmptyStateText(status),
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: kTextSecondaryColor,
            ),
          ),
          SizedBox(height: 8),
          Text(
            _getEmptyStateSubtext(status),
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

  Color _getStatusColor(String status) {
    switch (status) {
      case 'active':
        return Colors.green;
      case 'pending':
        return Colors.orange;
      case 'expired':
        return Colors.red;
      default:
        return kTextSecondaryColor;
    }
  }

  String _getStatusText(String status) {
    switch (status) {
      case 'active':
        return 'ACTIVE';
      case 'pending':
        return 'PENDING';
      case 'expired':
        return 'EXPIRED';
      default:
        return 'UNKNOWN';
    }
  }

  IconData _getEmptyStateIcon(String status) {
    switch (status) {
      case 'active':
        return Icons.store;
      case 'pending':
        return Icons.schedule;
      case 'expired':
        return Icons.timer_off;
      default:
        return Icons.inbox;
    }
  }

  String _getEmptyStateText(String status) {
    switch (status) {
      case 'active':
        return 'No Active Ads';
      case 'pending':
        return 'No Pending Ads';
      case 'expired':
        return 'No Expired Ads';
      default:
        return 'No Ads Found';
    }
  }

  String _getEmptyStateSubtext(String status) {
    switch (status) {
      case 'active':
        return 'Create your first ad to start selling';
      case 'pending':
        return 'Your ads are being reviewed';
      case 'expired':
        return 'Renew your expired ads to continue selling';
      default:
        return 'Start by creating a new ad';
    }
  }

  List<AvitoItem> _getMyAds(String status) {
    // Simulate different ad statuses
    List<AvitoItem> allAds = [
      AvitoItem(
        title: 'iPhone 14 Pro Max 256GB - Excellent condition',
        price: '₽85,000',
        location: 'Moscow',
        imageUrl: 'https://via.placeholder.com/300x200/0066CC/FFFFFF?text=iPhone+14+Pro',
        timeAgo: '2 hours ago',
        category: 'Electronics',
      ),
      AvitoItem(
        title: 'MacBook Pro M2 512GB - Like new',
        price: '₽125,000',
        location: 'Kazan',
        imageUrl: 'https://via.placeholder.com/300x200/0066CC/FFFFFF?text=MacBook+Pro',
        timeAgo: '3 hours ago',
        category: 'Electronics',
      ),
    ];

    switch (status) {
      case 'active':
        return allAds;
      case 'pending':
        return allAds.take(1).toList();
      case 'expired':
        return allAds.take(1).toList();
      default:
        return [];
    }
  }

  void _showDeleteDialog(AvitoItem ad) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete Ad'),
          content: Text('Are you sure you want to delete "${ad.title}"?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Ad deleted successfully'),
                    backgroundColor: Colors.red,
                  ),
                );
              },
              child: Text('Delete', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
} 