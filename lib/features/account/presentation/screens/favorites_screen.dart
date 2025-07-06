import 'package:flutter/material.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../shared/models/product_model.dart';
import '../../../../shared/widgets/product_list.dart';

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
        imageUrl: 'https://images.unsplash.com/photo-1592750475338-74b7b21085ab?w=400',
        timeAgo: '2 hours ago',
        category: 'Electronics',
        isFavorite: true,
    link: 'https://www.avito.ru/moskva/telefony/iphone_14_pro_max_256gb_otlichnoe_sostoyanie_1234567890',

      ),
      AvitoItem(
        title: 'Toyota Camry 2019 - Low mileage, perfect condition',
        price: '₽2,150,000',
        location: 'Saint Petersburg',
        imageUrl: 'https://images.unsplash.com/photo-1549317661-bd32c8ce0db2?w=400',
        timeAgo: '5 hours ago',
        category: 'Cars',
        isFavorite: true,
    link: 'https://www.avito.ru/moskva/telefony/iphone_14_pro_max_256gb_otlichnoe_sostoyanie_1234567890',

      ),
      AvitoItem(
        title: 'MacBook Pro M2 512GB - Like new',
        price: '₽125,000',
        location: 'Kazan',
        imageUrl: 'https://images.unsplash.com/photo-1517336714731-489689fd1ca8?w=400',
        timeAgo: '3 hours ago',
        category: 'Electronics',
        isFavorite: true,
    link: 'https://www.avito.ru/moskva/telefony/iphone_14_pro_max_256gb_otlichnoe_sostoyanie_1234567890',

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
          IconButton(
            icon: Icon(Icons.search, color: kAccentColor),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          // Stats section
          Container(
            padding: EdgeInsets.all(16),
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
          // Category filter
          Container(
            height: 50,
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: categories.length,
              itemBuilder: (context, index) {
                bool isSelected = categories[index] == selectedCategory;
                return Container(
                  margin: EdgeInsets.only(right: 8),
                  child: FilterChip(
                    label: Text(
                      categories[index],
                      style: TextStyle(
                        color: isSelected ? Colors.white : kTextSecondaryColor,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() {
                        selectedCategory = categories[index];
                      });
                    },
                    backgroundColor: Colors.white,
                    selectedColor: kAccentColor,
                    side: BorderSide(
                      color: isSelected ? kAccentColor : kBorderColor,
                    ),
                  ),
                );
              },
            ),
          ),
          // Favorites list
          Expanded(
            child: filteredFavorites.isEmpty
                ? Center(
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
                          'No favorites yet',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: kTextSecondaryColor,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Start adding items to your favorites',
                          style: TextStyle(
                            fontSize: 14,
                            color: kTextLightColor,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 24),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: kAccentColor,
                            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: Text(
                            'Browse Items',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: EdgeInsets.all(16),
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

  Widget _buildFavoriteCard(AvitoItem item) {
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
                  item.imageUrl,
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
                // Favorite button
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.9),
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: Icon(
                        Icons.favorite,
                        color: Colors.red,
                        size: 20,
                      ),
                      onPressed: () {
                        setState(() {
                          favoriteItems.remove(item);
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Removed from favorites'),
                            backgroundColor: Colors.red,
                          ),
                        );
                      },
                    ),
                  ),
                ),
                // Price tag
                Positioned(
                  bottom: 8,
                  left: 8,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: kAccentColor,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      item.price,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
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
                Text(
                  item.title,
                  style: kItemsTitleStyle,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.location_on_outlined, size: 16, color: kTextLightColor),
                    SizedBox(width: 4),
                    Expanded(
                      child: Text(item.location, style: kTextIconStyle),
                    ),
                    Text(item.timeAgo, style: kTextIconStyle),
                  ],
                ),
                SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          // Navigate to product details
                        },
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: kAccentColor),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text(
                          'View Details',
                          style: TextStyle(color: kAccentColor),
                        ),
                      ),
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          // Navigate to chat
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: kAccentColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text(
                          'Contact Seller',
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
} 