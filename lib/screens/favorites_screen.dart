import '../constants.dart';
import '../models/avito_model.dart';
import '../items_list.dart';
import 'package:flutter/material.dart';

class FavoritesScreen extends StatefulWidget {
  @override
  _FavoritesScreenState createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  String selectedCategory = 'All Categories';
  List<AvitoItem> favoriteItems = [];

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  void _loadFavorites() {
    // Simulate loading favorite items
    favoriteItems = [
      AvitoItem(
        title: 'iPhone 14 Pro Max 256GB - Excellent condition',
        price: '₽85,000',
        location: 'Moscow',
        imageUrl: 'https://via.placeholder.com/300x200/0066CC/FFFFFF?text=iPhone+14+Pro',
        timeAgo: '2 hours ago',
        category: 'Electronics',
        isFavorite: true,
      ),
      AvitoItem(
        title: 'Toyota Camry 2019 - Low mileage, perfect condition',
        price: '₽2,150,000',
        location: 'Saint Petersburg',
        imageUrl: 'https://via.placeholder.com/300x200/0066CC/FFFFFF?text=Toyota+Camry',
        timeAgo: '5 hours ago',
        category: 'Cars',
        isFavorite: true,
      ),
      AvitoItem(
        title: 'MacBook Pro M2 512GB - Like new',
        price: '₽125,000',
        location: 'Kazan',
        imageUrl: 'https://via.placeholder.com/300x200/0066CC/FFFFFF?text=MacBook+Pro',
        timeAgo: '3 hours ago',
        category: 'Electronics',
        isFavorite: true,
      ),
    ];
  }

  List<AvitoItem> get filteredFavorites {
    if (selectedCategory == 'All Categories') {
      return favoriteItems;
    }
    return favoriteItems.where((item) => item.category == selectedCategory).toList();
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
          'Favorites',
          style: TextStyle(
            color: kTextPrimaryColor,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        actions: [
          if (favoriteItems.isNotEmpty)
            TextButton(
              onPressed: _showClearAllDialog,
              child: Text(
                'Clear All',
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
        ],
      ),
      body: Column(
        children: [
          // Category filter
          Container(
            height: 50,
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                _buildFilterChip('All Categories', selectedCategory == 'All Categories'),
                _buildFilterChip('Electronics', selectedCategory == 'Electronics'),
                _buildFilterChip('Cars', selectedCategory == 'Cars'),
                _buildFilterChip('Real Estate', selectedCategory == 'Real Estate'),
                _buildFilterChip('Furniture', selectedCategory == 'Furniture'),
              ],
            ),
          ),
          // Stats
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Expanded(
                  child: _buildStatCard('Total', '${favoriteItems.length}', Icons.favorite),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: _buildStatCard('Categories', '${favoriteItems.map((e) => e.category).toSet().length}', Icons.category),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: _buildStatCard('Price Range', '₽85K-2.1M', Icons.attach_money),
                ),
              ],
            ),
          ),
          SizedBox(height: 16),
          // Favorites list
          Expanded(
            child: filteredFavorites.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    itemCount: filteredFavorites.length,
                    itemBuilder: (context, index) {
                      return _buildFavoriteCard(filteredFavorites[index]);
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
            selectedCategory = label;
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
              fontSize: 16,
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

  Widget _buildFavoriteCard(AvitoItem item) {
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
          // Item content
          Padding(
            padding: EdgeInsets.all(16),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    item.imageUrl,
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
                        item.title,
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
                        item.price,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: kAccentColor,
                        ),
                      ),
                      SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(
                            Icons.location_on_outlined,
                            size: 14,
                            color: kTextLightColor,
                          ),
                          SizedBox(width: 4),
                          Text(
                            item.location,
                            style: TextStyle(
                              fontSize: 12,
                              color: kTextSecondaryColor,
                            ),
                          ),
                          Spacer(),
                          Text(
                            item.timeAgo,
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
                    onPressed: () {
                      // Navigate to product details
                    },
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
                      // Navigate to chat with seller
                    },
                    icon: Icon(Icons.chat_bubble, size: 16),
                    label: Text('Message'),
                    style: TextButton.styleFrom(
                      foregroundColor: kTextSecondaryColor,
                    ),
                  ),
                ),
                Expanded(
                  child: TextButton.icon(
                    onPressed: () {
                      _removeFavorite(item);
                    },
                    icon: Icon(Icons.favorite, size: 16),
                    label: Text('Remove'),
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

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.favorite_border,
            size: 64,
            color: kTextLightColor,
          ),
          SizedBox(height: 16),
          Text(
            'No Favorites Yet',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: kTextSecondaryColor,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Start browsing and save items you like\nby tapping the heart icon',
            style: TextStyle(
              fontSize: 14,
              color: kTextLightColor,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.search),
            label: Text('Browse Items'),
            style: ElevatedButton.styleFrom(
              backgroundColor: kAccentColor,
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _removeFavorite(AvitoItem item) {
    setState(() {
      favoriteItems.remove(item);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Removed from favorites'),
        backgroundColor: Colors.red,
        action: SnackBarAction(
          label: 'Undo',
          textColor: Colors.white,
          onPressed: () {
            setState(() {
              favoriteItems.add(item);
            });
          },
        ),
      ),
    );
  }

  void _showClearAllDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Clear All Favorites'),
          content: Text('Are you sure you want to remove all items from your favorites?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  favoriteItems.clear();
                });
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('All favorites cleared'),
                    backgroundColor: Colors.red,
                  ),
                );
              },
              child: Text('Clear All', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }
} 