import 'package:flutter/material.dart';
import '../../../../core/constants/app_constants.dart';

class Vendor {
  final String name;
  final String businessName;
  final String category;
  final String location;
  final String phone;
  final String email;
  final String description;
  final String imageUrl;
  final String status; // 'verified', 'pending', 'rejected'
  final String registrationDate;
  final int totalProducts;
  final double rating;

  Vendor({
    required this.name,
    required this.businessName,
    required this.category,
    required this.location,
    required this.phone,
    required this.email,
    required this.description,
    required this.imageUrl,
    required this.status,
    required this.registrationDate,
    required this.totalProducts,
    required this.rating,
  });
}

class VendorsScreen extends StatefulWidget {
  @override
  _VendorsScreenState createState() => _VendorsScreenState();
}

class _VendorsScreenState extends State<VendorsScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String selectedFilter = 'All';

  // Sample vendor data based on registration form
  final List<Vendor> vendors = [
    Vendor(
      name: 'Alex Petrov',
      businessName: 'TechGadgets Pro',
      category: 'Electronics',
      location: 'Moscow',
      phone: '+7 (495) 123-45-67',
      email: 'alex@techgadgets.ru',
      description: 'Professional electronics store with 5+ years of experience. We offer the latest gadgets and tech accessories.',
      imageUrl: 'https://images.unsplash.com/photo-1560472354-b33ff0c44a43?w=400&h=300&fit=crop',
      status: 'verified',
      registrationDate: '2023-12-15',
      totalProducts: 45,
      rating: 4.8,
    ),
    Vendor(
      name: 'Maria Ivanova',
      businessName: 'Fashion Boutique Elite',
      category: 'Clothing',
      location: 'Saint Petersburg',
      phone: '+7 (812) 987-65-43',
      email: 'maria@fashionboutique.ru',
      description: 'Premium fashion boutique offering designer clothing and accessories for all occasions.',
      imageUrl: 'https://images.unsplash.com/photo-1441986300917-64674bd600d8?w=400&h=300&fit=crop',
      status: 'verified',
      registrationDate: '2023-11-20',
      totalProducts: 32,
      rating: 4.9,
    ),
    Vendor(
      name: 'Dmitry Sokolov',
      businessName: 'AutoParts Express',
      category: 'Automotive',
      location: 'Kazan',
      phone: '+7 (843) 555-12-34',
      email: 'dmitry@autoparts.ru',
      description: 'Specialized in high-quality automotive parts and accessories for all car brands.',
      imageUrl: 'https://images.unsplash.com/photo-1486262715619-67b85e0b08d3?w=400&h=300&fit=crop',
      status: 'pending',
      registrationDate: '2024-01-10',
      totalProducts: 0,
      rating: 0.0,
    ),
    Vendor(
      name: 'Elena Kuznetsova',
      businessName: 'Home Decor Plus',
      category: 'Furniture',
      location: 'Novosibirsk',
      phone: '+7 (383) 777-88-99',
      email: 'elena@homedecor.ru',
      description: 'Beautiful home decor and furniture for modern living spaces.',
      imageUrl: 'https://images.unsplash.com/photo-1555041469-a586c61ea9bc?w=400&h=300&fit=crop',
      status: 'verified',
      registrationDate: '2023-10-05',
      totalProducts: 28,
      rating: 4.7,
    ),
    Vendor(
      name: 'Sergey Volkov',
      businessName: 'Sports Equipment Hub',
      category: 'Sports',
      location: 'Yekaterinburg',
      phone: '+7 (343) 444-33-22',
      email: 'sergey@sportsequipment.ru',
      description: 'Complete range of sports equipment and fitness gear for all levels.',
      imageUrl: 'https://images.unsplash.com/photo-1571019613454-1cb2f99b2d8b?w=400&h=300&fit=crop',
      status: 'rejected',
      registrationDate: '2024-01-05',
      totalProducts: 0,
      rating: 0.0,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildVendorsList('verified'),
          _buildVendorsList('pending'),
          _buildVendorsList('rejected'),
        ],
      ),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: AppBar(
          automaticallyImplyLeading: false,
          elevation: 0,
          backgroundColor: kBackgroundColor,
          titleSpacing: 0,
          title: TabBar(
        controller: _tabController,
        isScrollable: false,
        labelPadding: EdgeInsets.zero,
        labelColor: kAccentColor,
        unselectedLabelColor: kTextSecondaryColor,
        indicatorColor: kAccentColor,
        tabs: [
          Tab(text: 'Verified (3)'),
          Tab(text: 'Pending (1)'),
          Tab(text: 'Rejected (1)'),
        ],
          ),
        ),
      ),
      
      
    );
  }

  Widget _buildVendorsList(String status) {
    List<Vendor> filteredVendors = vendors.where((vendor) => vendor.status == status).toList();
    
    if (filteredVendors.isEmpty) {
      return _buildEmptyState(status);
    }

    return ListView.builder(
      
      padding: EdgeInsets.all(16),
      itemCount: filteredVendors.length,
      itemBuilder: (context, index) {
        return _buildVendorCard(filteredVendors[index]);
      },
    );
  }

  Widget _buildEmptyState(String status) {
    String message = '';
    IconData icon = Icons.store;
    
    switch (status) {
      case 'verified':
        message = 'No verified vendors yet';
        icon = Icons.verified;
        break;
      case 'pending':
        message = 'No pending vendor applications';
        icon = Icons.pending;
        break;
      case 'rejected':
        message = 'No rejected applications';
        icon = Icons.cancel;
        break;
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 64,
            color: kIconsColor,
          ),
          SizedBox(height: 16),
          Text(
            message,
            style: TextStyle(
              fontSize: 16,
              color: kTextSecondaryColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVendorCard(Vendor vendor) {
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
          // Header with image and status
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
                child: Image.network(
                  vendor.imageUrl,
                  width: double.infinity,
                  height: 150,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: double.infinity,
                      height: 150,
                      color: kBackgroundColor,
                      child: Icon(
                        Icons.store,
                        color: kIconsColor,
                        size: 48,
                      ),
                    );
                  },
                ),
              ),
              // Status badge
              Positioned(
                top: 12,
                right: 12,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: _getStatusColor(vendor.status),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    vendor.status.toUpperCase(),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
          
          // Vendor info
          Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Business name and rating
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        vendor.businessName,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: kTextPrimaryColor,
                        ),
                      ),
                    ),
                    if (vendor.rating > 0)
                      Row(
                        children: [
                          Icon(Icons.star, color: Colors.amber, size: 16),
                          SizedBox(width: 4),
                          Text(
                            vendor.rating.toString(),
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: kTextPrimaryColor,
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
                SizedBox(height: 4),
                
                // Owner name and category
                Row(
                  children: [
                    Icon(Icons.person, color: kIconsColor, size: 16),
                    SizedBox(width: 4),
                    Text(
                      vendor.name,
                      style: TextStyle(
                        fontSize: 14,
                        color: kTextSecondaryColor,
                      ),
                    ),
                    SizedBox(width: 16),
                    Icon(Icons.category, color: kIconsColor, size: 16),
                    SizedBox(width: 4),
                    Text(
                      vendor.category,
                      style: TextStyle(
                        fontSize: 14,
                        color: kTextSecondaryColor,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                
                // Location
                Row(
                  children: [
                    Icon(Icons.location_on, color: kIconsColor, size: 16),
                    SizedBox(width: 4),
                    Text(
                      vendor.location,
                      style: TextStyle(
                        fontSize: 14,
                        color: kTextSecondaryColor,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                
                // Description
                Text(
                  vendor.description,
                  style: TextStyle(
                    fontSize: 14,
                    color: kTextSecondaryColor,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 12),
                
                // Stats and actions
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Stats
                    Row(
                      children: [
                        if (vendor.totalProducts > 0) ...[
                          Icon(Icons.inventory, color: kIconsColor, size: 16),
                          SizedBox(width: 4),
                          Text(
                            '${vendor.totalProducts} products',
                            style: TextStyle(
                              fontSize: 12,
                              color: kTextSecondaryColor,
                            ),
                          ),
                          SizedBox(width: 16),
                        ],
                        Icon(Icons.calendar_today, color: kIconsColor, size: 16),
                        SizedBox(width: 4),
                        Text(
                          'Joined ${_formatDate(vendor.registrationDate)}',
                          style: TextStyle(
                            fontSize: 12,
                            color: kTextSecondaryColor,
                          ),
                        ),
                      ],
                    ),
                    
                    // Action buttons
                    
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'verified':
        return Colors.green;
      case 'pending':
        return Colors.orange;
      case 'rejected':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  String _formatDate(String date) {
    // Simple date formatting - you might want to use a proper date package
    return date;
  }

  void _approveVendor(Vendor vendor) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Approve Vendor'),
        content: Text('Are you sure you want to approve ${vendor.businessName}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('${vendor.businessName} approved successfully'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
            child: Text('Approve', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _rejectVendor(Vendor vendor) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Reject Vendor'),
        content: Text('Are you sure you want to reject ${vendor.businessName}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('${vendor.businessName} rejected'),
                  backgroundColor: Colors.red,
                ),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: Text('Reject', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
} 