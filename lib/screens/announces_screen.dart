import '../items_list.dart';
import '../models/avito_model.dart';
import '../constants.dart';
import 'product_details_screen.dart';
import 'package:flutter/material.dart';

class AnnouncesScreen extends StatefulWidget {
  @override
  _AnnouncesScreenState createState() => _AnnouncesScreenState();
}

class _AnnouncesScreenState extends State<AnnouncesScreen> with TickerProviderStateMixin {
  String selectedCategory = 'All Categories';
  String searchQuery = '';
  late ScrollController _mainScrollController;
  late ScrollController _horizontalScrollController;
  late AnimationController _bannerAnimationController;
  int _currentBannerIndex = 0;
  
  // Animation values for scroll-based transitions
  double _scrollOffset = 0.0;
  static const double _featuredSectionHeight = 200.0;
  static const double _stickyHeaderHeight = 120.0; // Categories + Search height

  @override
  void initState() {
    super.initState();
    _mainScrollController = ScrollController();
    _horizontalScrollController = ScrollController();
    _bannerAnimationController = AnimationController(
      duration: Duration(seconds: 20),
      vsync: this,
    )..repeat();
    
    // Listen to scroll changes for animations
    _mainScrollController.addListener(_onScroll);
    
    // Auto-scroll the banner
    _startAutoScroll();
  }

  void _onScroll() {
    setState(() {
      _scrollOffset = _mainScrollController.offset;
    });
  }

  void _startAutoScroll() {
    Future.delayed(Duration(seconds: 2), () {
      if (mounted) {
        _scrollToNextBanner();
      }
    });
  }

  void _scrollToNextBanner() {
    if (_horizontalScrollController.hasClients) {
      final maxScroll = _horizontalScrollController.position.maxScrollExtent;
      final currentScroll = _horizontalScrollController.offset;
      final itemWidth = MediaQuery.of(context).size.width * 0.8;
      
      if (currentScroll >= maxScroll) {
        _horizontalScrollController.animateTo(
          0,
          duration: Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
        _currentBannerIndex = 0;
      } else {
        _horizontalScrollController.animateTo(
          currentScroll + itemWidth,
          duration: Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
        _currentBannerIndex++;
      }
    }
    
    // Schedule next scroll
    Future.delayed(Duration(seconds: 3), () {
      if (mounted) {
        _scrollToNextBanner();
      }
    });
  }

  List<AvitoItem> get filteredData {
    List<AvitoItem> filtered = avitoData;
    
    if (selectedCategory != 'All Categories') {
      filtered = filtered.where((item) => item.category == selectedCategory).toList();
    }
    
    if (searchQuery.isNotEmpty) {
      filtered = filtered.where((item) => 
        item.title.toLowerCase().contains(searchQuery.toLowerCase()) ||
        item.location.toLowerCase().contains(searchQuery.toLowerCase())
      ).toList();
    }
    
    return filtered;
  }

  // Calculate animation values based on scroll position
  double get _featuredOpacity {
    final progress = (_scrollOffset / _featuredSectionHeight).clamp(0.0, 1.0);
    return 1.0 - progress;
  }

  double get _featuredScale {
    final progress = (_scrollOffset / _featuredSectionHeight).clamp(0.0, 1.0);
    return 1.0 - (progress * 0.3); // Scale down to 70%
  }

  double get _featuredTranslateY {
    return -_scrollOffset * 0.5; // Move up as we scroll
  }

  double get _stickyHeaderOpacity {
    final progress = (_scrollOffset / _featuredSectionHeight).clamp(0.0, 1.0);
    return progress;
  }

  double get _stickyHeaderTranslateY {
    final progress = (_scrollOffset / _featuredSectionHeight).clamp(0.0, 1.0);
    return -_stickyHeaderHeight + (_stickyHeaderHeight * progress) - 8; // Account for small spacer
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      body: SafeArea(
        child: Stack(
          children: [
            // Main scrollable content
            CustomScrollView(
              controller: _mainScrollController,
              slivers: [
                // Featured Products Section (collapsible)
                SliverToBoxAdapter(
                  child: Transform.translate(
                    offset: Offset(0, _featuredTranslateY),
                    child: Transform.scale(
                      scale: _featuredScale,
                      child: Opacity(
                        opacity: _featuredOpacity,
                        child: Container(
                          height: _featuredSectionHeight,
                          margin: EdgeInsets.only(top: 8, bottom: 0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 16),
                                child: Row(
                                  children: [
                                    Icon(Icons.star, color: Colors.amber, size: 20),
                                    SizedBox(width: 8),
                                    Text(
                                      'Featured Products',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: kTextPrimaryColor,
                                      ),
                                    ),
                                    Spacer(),
                                    Container(
                                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: kAccentColor.withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Text(
                                        'In Stock',
                                        style: TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.w600,
                                          color: kAccentColor,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 8),
                              Expanded(
                                child: ListView.builder(
                                  controller: _horizontalScrollController,
                                  scrollDirection: Axis.horizontal,
                                  padding: EdgeInsets.symmetric(horizontal: 16),
                                  itemCount: avitoData.length,
                                  itemBuilder: (context, index) {
                                    return _buildFeaturedProductCard(avitoData[index]);
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                
                // Small spacer for visual separation
                SliverToBoxAdapter(
                  child: Container(
                    height: 8,
                  ),
                ),
                
                // Category filter
                SliverToBoxAdapter(
                  child: Container(
                    height: 50,
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: categories.length,
                      itemBuilder: (context, index) {
                        bool isSelected = categories[index] == selectedCategory;
                        return Container(
                          margin: EdgeInsets.only(right: 8.0),
                          child: FilterChip(
                            label: Text(
                              categories[index],
                              style: TextStyle(
                                color: isSelected ? Colors.white : kTextSecondaryColor,
                                fontSize: 12.0,
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
                ),
                
                // Search bar
                SliverToBoxAdapter(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
                    child: TextField(
                      onChanged: (value) {
                        setState(() {
                          searchQuery = value;
                        });
                      },
                      decoration: InputDecoration(
                        hintText: 'Search ads...',
                        hintStyle: kSearchTextStyle,
                        prefixIcon: Icon(Icons.search, color: kTextLightColor),
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide: BorderSide(color: kBorderColor),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide: BorderSide(color: kBorderColor),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide: BorderSide(color: kAccentColor),
                        ),
                      ),
                    ),
                  ),
                ),
                
                // Results count
                SliverToBoxAdapter(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
                    child: Row(
                      children: [
                        Text(
                          '${filteredData.length} ads found',
                          style: TextStyle(
                            color: kTextSecondaryColor,
                            fontSize: 12.0,
                          ),
                        ),
                        Spacer(),
                        IconButton(
                          icon: Icon(Icons.sort, color: kTextLightColor),
                          onPressed: () {},
                        ),
                      ],
                    ),
                  ),
                ),
                
                // Products list
                SliverPadding(
                  padding: EdgeInsets.only(bottom: 80), // Space for FAB
                  sliver: filteredData.isEmpty
                      ? SliverToBoxAdapter(
                          child: Container(
                            height: 300,
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.search_off,
                                    size: 64,
                                    color: kTextLightColor,
                                  ),
                                  SizedBox(height: 16),
                                  Text(
                                    'No ads found',
                                    style: TextStyle(
                                      color: kTextSecondaryColor,
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        )
                      : SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (context, index) {
                              return _buildProductCard(filteredData[index]);
                            },
                            childCount: filteredData.length,
                          ),
                        ),
                ),
              ],
            ),
            
            // Sticky Header (Categories + Search)
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Transform.translate(
                offset: Offset(0, _stickyHeaderTranslateY),
                child: Opacity(
                  opacity: _stickyHeaderOpacity,
                  child: Container(
                    height: _stickyHeaderHeight,
                    decoration: BoxDecoration(
                      color: kBackgroundColor,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 8,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        // Category filter
                        Container(
                          height: 50,
                          padding: EdgeInsets.symmetric(horizontal: 16.0),
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: categories.length,
                            itemBuilder: (context, index) {
                              bool isSelected = categories[index] == selectedCategory;
                              return Container(
                                margin: EdgeInsets.only(right: 8.0),
                                child: FilterChip(
                                  label: Text(
                                    categories[index],
                                    style: TextStyle(
                                      color: isSelected ? Colors.white : kTextSecondaryColor,
                                      fontSize: 12.0,
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
                        
                        // Search bar
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
                          child: TextField(
                            onChanged: (value) {
                              setState(() {
                                searchQuery = value;
                              });
                            },
                            decoration: InputDecoration(
                              hintText: 'Search ads...',
                              hintStyle: kSearchTextStyle,
                              prefixIcon: Icon(Icons.search, color: kTextLightColor),
                              filled: true,
                              fillColor: Colors.white,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0),
                                borderSide: BorderSide(color: kBorderColor),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0),
                                borderSide: BorderSide(color: kBorderColor),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0),
                                borderSide: BorderSide(color: kAccentColor),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeaturedProductCard(AvitoItem item) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.8,
      margin: EdgeInsets.only(right: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Image section with overlay
          ClipRRect(
            borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
            child: Stack(
              children: [
                Image.network(
                  item.imageUrl,
                  width: double.infinity,
                  height: 80,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: double.infinity,
                      height: 80,
                      color: kBackgroundColor,
                      child: Icon(
                        Icons.image,
                        color: kIconsColor,
                        size: 20,
                      ),
                    );
                  },
                ),
                // Gradient overlay
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withOpacity(0.3),
                        ],
                      ),
                    ),
                  ),
                ),
                // Featured badge
                Positioned(
                  top: 4,
                  left: 4,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                    decoration: BoxDecoration(
                      color: Colors.amber,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      'FEATURED',
                      style: TextStyle(
                        fontSize: 7,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                // Stock indicator
                Positioned(
                  top: 4,
                  right: 4,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                    decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      'IN STOCK',
                      style: TextStyle(
                        fontSize: 7,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Content section
          Padding(
            padding: EdgeInsets.all(6),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Price
                Text(
                  item.price,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: kAccentColor,
                  ),
                ),
                SizedBox(height: 1),
                // Title
                Text(
                  item.title,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: kTextPrimaryColor,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 2),
                // Location and category
                Row(
                  children: [
                    Icon(
                      Icons.location_on_outlined,
                      size: 10,
                      color: kTextLightColor,
                    ),
                    SizedBox(width: 1),
                    Expanded(
                      child: Text(
                        item.location,
                        style: TextStyle(
                          fontSize: 9,
                          color: kTextSecondaryColor,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 3, vertical: 1),
                      decoration: BoxDecoration(
                        color: kBackgroundColor,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        item.category,
                        style: TextStyle(
                          fontSize: 7,
                          fontWeight: FontWeight.w500,
                          color: kTextSecondaryColor,
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

  Widget _buildProductCard(AvitoItem item) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductDetailsScreen(item: item),
          ),
        );
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 6.0),
        decoration: BoxDecoration(
          color: kCardBackgroundColor,
          borderRadius: BorderRadius.circular(12.0),
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
              borderRadius: BorderRadius.vertical(top: Radius.circular(12.0)),
              child: Stack(
                children: [
                  Image.network(
                    item.imageUrl,
                    width: double.infinity,
                    height: 200.0,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        width: double.infinity,
                        height: 200.0,
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
                          item.isFavorite 
                              ? Icons.favorite 
                              : Icons.favorite_border,
                          color: item.isFavorite 
                              ? Colors.red 
                              : kTextLightColor,
                        ),
                        onPressed: () {},
                        iconSize: 20,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Content section
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Price
                  Text(
                    item.price,
                    style: kItemsPriceStyle,
                  ),
                  SizedBox(height: 8.0),
                  // Title
                  Text(
                    item.title,
                    style: kItemsTitleStyle,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 12.0),
                  // Location and time
                  Row(
                    children: [
                      Icon(
                        Icons.location_on_outlined,
                        size: 16.0,
                        color: kTextLightColor,
                      ),
                      SizedBox(width: 4.0),
                      Expanded(
                        child: Text(
                          item.location,
                          style: kTextIconStyle,
                        ),
                      ),
                      Text(
                        item.timeAgo,
                        style: kTextIconStyle,
                      ),
                    ],
                  ),
                  SizedBox(height: 8.0),
                  // Category
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                    decoration: BoxDecoration(
                      color: kBackgroundColor,
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    child: Text(
                      item.category,
                      style: TextStyle(
                        fontSize: 11.0,
                        color: kTextSecondaryColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _mainScrollController.dispose();
    _horizontalScrollController.dispose();
    _bannerAnimationController.dispose();
    super.dispose();
  }
}
