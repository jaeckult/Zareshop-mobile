import 'package:flutter/material.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../shared/models/product_model.dart';
import '../../../../shared/widgets/product_list.dart';

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
    List<AvitoItem> ads = _getAdsByStatus(status);
    
    if (ads.isEmpty) {
      return _buildEmptyState(status);
    }

    return ListView.builder(
      padding: EdgeInsets.all(16),
      itemCount: ads.length,
      itemBuilder: (context, index) {
        return _buildAdCard(ads[index], status);
      },
    );
  }

  List<AvitoItem> _getAdsByStatus(String status) {
    // Simulate different ads for different statuses
    switch (status) {
      case 'active':
        return [
          AvitoItem(
            title: 'iPhone 14 Pro Max 256GB - Excellent condition',
            price: '₽85,000',
            location: 'Moscow',
            imageUrl: 'https://images.unsplash.com/photo-1592750475338-74b7b21085ab?w=400',
            timeAgo: '2 hours ago',
            category: 'Electronics',
            isFavorite: false,
          ),
          AvitoItem(
            title: 'Toyota Camry 2019 - Low mileage, perfect condition',
            price: '₽2,150,000',
            location: 'Saint Petersburg',
            imageUrl: 'https://images.unsplash.com/photo-1549317661-bd32c8ce0db2?w=400',
            timeAgo: '5 hours ago',
            category: 'Cars',
            isFavorite: false,
          ),
        ];
      case 'pending':
        return [
          AvitoItem(
            title: 'MacBook Pro M2 512GB - Like new',
            price: '₽125,000',
            location: 'Kazan',
            imageUrl: 'https://images.unsplash.com/photo-1517336714731-489689fd1ca8?w=400',
            timeAgo: '1 day ago',
            category: 'Electronics',
            isFavorite: false,
          ),
        ];
      case 'expired':
        return [
          AvitoItem(
            title: 'Samsung Galaxy S23 Ultra - Good condition',
            price: '₽65,000',
            location: 'Novosibirsk',
            imageUrl: 'https://images.unsplash.com/photo-1610945265064-0e34e5519bbf?w=400',
            timeAgo: '3 days ago',
            category: 'Electronics',
            isFavorite: false,
          ),
        ];
      default:
        return [];
    }
  }

  Widget _buildAdCard(AvitoItem ad, String status) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image section
          ClipRRect(
            borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
            child: Stack(
              children: [
                Image.network(
                  ad.imageUrl,
                  width: double.infinity,
                  height: 200,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: double.infinity,
                      height: 200,
                      color: kBackgroundColor,
                      child: Icon(
                        Icons.image,
                        color: kIconsColor,
                        size: 48,
                      ),
                    );
                  },
                ),
                // Status badge
                Positioned(
                  top: 8,
                  left: 8,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: _getStatusColor(status),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      _getStatusText(status),
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                // Actions
                Positioned(
                  top: 8,
                  right: 8,
                  child: Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.9),
                          shape: BoxShape.circle,
                        ),
                        child: IconButton(
                          icon: Icon(Icons.edit, color: kAccentColor, size: 20),
                          onPressed: () {},
                        ),
                      ),
                      SizedBox(width: 8),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.9),
                          shape: BoxShape.circle,
                        ),
                        child: IconButton(
                          icon: Icon(Icons.delete, color: Colors.red, size: 20),
                          onPressed: () {},
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Content section
          Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        ad.title,
                        style: kItemsTitleStyle,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Text(
                      ad.price,
                      style: kItemsPriceStyle,
                    ),
                  ],
                ),
                SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.location_on_outlined, size: 16, color: kTextLightColor),
                    SizedBox(width: 4),
                    Text(ad.location, style: kTextIconStyle),
                    Spacer(),
                    Text(ad.timeAgo, style: kTextIconStyle),
                  ],
                ),
                SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {},
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: kAccentColor),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text(
                          'Edit',
                          style: TextStyle(color: kAccentColor),
                        ),
                      ),
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: kAccentColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text(
                          status == 'active' ? 'Promote' : 'Renew',
                          style: TextStyle(color: Colors.white),
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
        return 'Renew your ads to keep them active';
      default:
        return 'Start creating ads to see them here';
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
} 