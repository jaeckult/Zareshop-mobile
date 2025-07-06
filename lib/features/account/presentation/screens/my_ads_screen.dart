import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
              _showCreateAdDialog();
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
            link: 'https://www.avito.ru/moskva/telefony/iphone_14_pro_max_256gb_otlichnoe_sostoyanie_1234567890',

          ),
          AvitoItem(
            title: 'Toyota Camry 2019 - Low mileage, perfect condition',
            price: '₽2,150,000',
            location: 'Saint Petersburg',
            imageUrl: 'https://images.unsplash.com/photo-1549317661-bd32c8ce0db2?w=400',
            timeAgo: '5 hours ago',
            category: 'Cars',
            isFavorite: false,
    link: 'https://www.avito.ru/moskva/telefony/iphone_14_pro_max_256gb_otlichnoe_sostoyanie_1234567890',

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
    link: 'https://www.avito.ru/moskva/telefony/iphone_14_pro_max_256gb_otlichnoe_sostoyanie_1234567890',

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
    link: 'https://www.avito.ru/moskva/telefony/iphone_14_pro_max_256gb_otlichnoe_sostoyanie_1234567890',

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
                          onPressed: () => _showEditAdDialog(ad),
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
                          onPressed: () => _showDeleteAdDialog(ad),
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
                        onPressed: () => _showEditAdDialog(ad),
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
                        onPressed: () => _showPromoteDialog(ad, status),
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

  void _showCreateAdDialog() {
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
                'Create New Ad',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: kTextPrimaryColor,
                ),
              ),
            ),
            // Content
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  Text(
                    'Create a new advertisement to sell your products or services.',
                    style: TextStyle(
                      fontSize: 14,
                      color: kTextSecondaryColor,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Navigate to create ad screen...'),
                          backgroundColor: kAccentColor,
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: kAccentColor,
                      minimumSize: Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      'Start Creating',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
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

  void _showEditAdDialog(AvitoItem ad) {
    final TextEditingController titleController = TextEditingController(text: ad.title);
    final TextEditingController priceController = TextEditingController(text: ad.price);
    final TextEditingController locationController = TextEditingController(text: ad.location);
    String selectedCategory = ad.category;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: SingleChildScrollView(
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
                  'Edit Advertisement',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: kTextPrimaryColor,
                  ),
                ),
              ),
              // Form
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title field
                    Text(
                      'Title',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: kTextPrimaryColor,
                      ),
                    ),
                    SizedBox(height: 8),
                    TextField(
                      controller: titleController,
                      decoration: InputDecoration(
                        hintText: 'Enter product title',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: kBorderColor),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: kBorderColor),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: kAccentColor),
                        ),
                        filled: true,
                        fillColor: Colors.grey[50],
                      ),
                    ),
                    SizedBox(height: 16),
                    
                    // Price field
                    Text(
                      'Price',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: kTextPrimaryColor,
                      ),
                    ),
                    SizedBox(height: 8),
                    TextField(
                      controller: priceController,
                      decoration: InputDecoration(
                        hintText: 'Enter price',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: kBorderColor),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: kBorderColor),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: kAccentColor),
                        ),
                        filled: true,
                        fillColor: Colors.grey[50],
                      ),
                    ),
                    SizedBox(height: 16),
                    
                    // Location field
                    Text(
                      'Location',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: kTextPrimaryColor,
                      ),
                    ),
                    SizedBox(height: 8),
                    TextField(
                      controller: locationController,
                      decoration: InputDecoration(
                        hintText: 'Enter location',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: kBorderColor),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: kBorderColor),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: kAccentColor),
                        ),
                        filled: true,
                        fillColor: Colors.grey[50],
                      ),
                    ),
                    SizedBox(height: 16),
                    
                    // Category dropdown
                    Text(
                      'Category',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: kTextPrimaryColor,
                      ),
                    ),
                    SizedBox(height: 8),
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        border: Border.all(color: kBorderColor),
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.grey[50],
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: selectedCategory,
                          isExpanded: true,
                          items: categories.where((cat) => cat != 'All Categories').map((String category) {
                            return DropdownMenuItem<String>(
                              value: category,
                              child: Text(category),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            if (newValue != null) {
                              selectedCategory = newValue;
                            }
                          },
                        ),
                      ),
                    ),
                    SizedBox(height: 24),
                    
                    // Action buttons
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () => Navigator.pop(context),
                            style: OutlinedButton.styleFrom(
                              side: BorderSide(color: kAccentColor),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              padding: EdgeInsets.symmetric(vertical: 12),
                            ),
                            child: Text(
                              'Cancel',
                              style: TextStyle(color: kAccentColor),
                            ),
                          ),
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              // Here you would typically update the ad in your data source
                              Navigator.pop(context);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Row(
                                    children: [
                                      Icon(Icons.check_circle, color: Colors.white),
                                      SizedBox(width: 8),
                                      Text('Ad updated successfully!'),
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
                            style: ElevatedButton.styleFrom(
                              backgroundColor: kAccentColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              padding: EdgeInsets.symmetric(vertical: 12),
                            ),
                            child: Text(
                              'Save Changes',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showDeleteAdDialog(AvitoItem ad) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Delete Ad',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: kTextPrimaryColor,
          ),
        ),
        content: Text(
          'Are you sure you want to delete "${ad.title}"? This action cannot be undone.',
          style: TextStyle(
            fontSize: 14,
            color: kTextSecondaryColor,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: TextStyle(color: kTextSecondaryColor),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Ad deleted successfully'),
                  backgroundColor: Colors.red,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: Text(
              'Delete',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  void _showPromoteDialog(AvitoItem ad, String status) {
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
                status == 'active' ? 'Promote Ad' : 'Renew Ad',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: kTextPrimaryColor,
                ),
              ),
            ),
            // Options
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  // Boost visibility option
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Row(
                            children: [
                              Icon(Icons.check_circle, color: Colors.white),
                              SizedBox(width: 8),
                              Text('Ad promoted successfully!'),
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
                              Icons.trending_up,
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
                                  status == 'active' ? 'Boost Visibility' : 'Renew Ad',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: kTextPrimaryColor,
                                  ),
                                ),
                                Text(
                                  status == 'active' 
                                    ? 'Increase your ad\'s visibility'
                                    : 'Extend your ad\'s duration',
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
                  // Premium placement option
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Row(
                            children: [
                              Icon(Icons.check_circle, color: Colors.white),
                              SizedBox(width: 8),
                              Text('Premium placement activated!'),
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
                        color: Colors.amber.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Colors.amber.withOpacity(0.3),
                          width: 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.amber,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.star,
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
                                  'Premium Placement',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: kTextPrimaryColor,
                                  ),
                                ),
                                Text(
                                  'Get featured at the top of search results',
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
                  // Social media promotion option
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Row(
                            children: [
                              Icon(Icons.check_circle, color: Colors.white),
                              SizedBox(width: 8),
                              Text('Social media promotion activated!'),
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
                              Icons.share,
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
                                  'Social Media Promotion',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: kTextPrimaryColor,
                                  ),
                                ),
                                Text(
                                  'Promote your ad on social platforms',
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