import 'package:flutter/material.dart';
import 'dart:ui';
import '../../../../shared/widgets/product_list.dart';
import '../../../../shared/models/product_model.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../../features/product/presentation/screens/product_details_screen.dart';

class HomeScreen extends StatefulWidget {
  final Function(AvitoItem)? onAddToCart;
  final Function(String)? onRemoveFromCart;
  
  const HomeScreen({Key? key, this.onAddToCart, this.onRemoveFromCart}) : super(key: key);
  
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  String selectedCategory = 'All Categories';
  String searchQuery = '';
  String selectedSortOption = 'None'; // Track selected sort option
  late ScrollController _mainScrollController;
  late ScrollController _horizontalScrollController;
  late AnimationController _bannerAnimationController;
  int _currentBannerIndex = 0;

  // Animation values for scroll-based transitions
  double _scrollOffset = 0.0;
  static const double _featuredSectionHeight = 200.0;
  
  // Mutable list for managing favorite state
  late List<AvitoItem> _items;
  Set<String> _favoriteIds = {};
  
  // Cart state management
  Set<String> _cartItemIds = {};
  
  // Hover state management
  String? _hoveredItemId;

  @override
  void initState() {
    super.initState();
    _mainScrollController = ScrollController();
    _horizontalScrollController = ScrollController();
    _bannerAnimationController = AnimationController(
      duration: Duration(seconds: 20),
      vsync: this,
    )..repeat();

    // Initialize items list
    _items = List.from(avitoData);

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
        _horizontalScrollController.jumpTo(0);
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
    List<AvitoItem> filtered = _items;

    // Filter by category
    if (selectedCategory != 'All Categories') {
      filtered =
          filtered.where((item) => item.category == selectedCategory).toList();
    }

    // Filter by search query
    if (searchQuery.isNotEmpty) {
      filtered = filtered
          .where(
            (item) =>
                item.title.toLowerCase().contains(searchQuery.toLowerCase()) ||
                item.location.toLowerCase().contains(searchQuery.toLowerCase()),
          )
          .toList();
    }

    // Apply sorting
    if (selectedSortOption == 'Price: Low to High') {
      filtered.sort((a, b) => double.parse(a.price.replaceAll(RegExp(r'[^0-9.]'), '')).compareTo(
            double.parse(b.price.replaceAll(RegExp(r'[^0-9.]'), '')),
          ));
    } else if (selectedSortOption == 'Price: High to Low') {
      filtered.sort((a, b) => double.parse(b.price.replaceAll(RegExp(r'[^0-9.]'), '')).compareTo(
            double.parse(a.price.replaceAll(RegExp(r'[^0-9.]'), '')),
          ));
    } else if (selectedSortOption == 'Date: Newest First') {
      filtered.sort((a, b) => b.timeAgo.compareTo(a.timeAgo));
    } else if (selectedSortOption == 'Date: Oldest First') {
      filtered.sort((a, b) => a.timeAgo.compareTo(b.timeAgo));
    }

    return filtered;
  }

  // Helper method to check if an item is favorite
  bool _isFavorite(AvitoItem item) {
    return _favoriteIds.contains(item.title); // Using title as unique identifier
  }

  // Method to toggle favorite state
  void _toggleFavorite(AvitoItem item) {
    setState(() {
      if (_favoriteIds.contains(item.title)) {
        _favoriteIds.remove(item.title);
      } else {
        _favoriteIds.add(item.title);
      }
    });
  }

  // Helper method to check if an item is in cart
  bool _isInCart(AvitoItem item) {
    return _cartItemIds.contains(item.title);
  }

  // Method to add item to cart
  void _addToCart(AvitoItem item) {
    if (_isInCart(item)) {
      // Item is in cart, remove it
      setState(() {
        _cartItemIds.remove(item.title);
      });
      
      if (widget.onRemoveFromCart != null) {
        widget.onRemoveFromCart!(item.title);
      }
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${item.title} removed from cart'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 2),
        ),
      );
    } else {
      // Item is not in cart, add it
      setState(() {
        _cartItemIds.add(item.title);
      });
      
      if (widget.onAddToCart != null) {
        widget.onAddToCart!(item);
      }
    }
  }

  // Calculate animation values based on scroll position
  double get _featuredOpacity {
    final progress = (_scrollOffset / _featuredSectionHeight).clamp(0.0, 1.0);
    return 1.0 - progress;
  }

  double get _featuredScale {
    final progress = (_scrollOffset / _featuredSectionHeight).clamp(0.0, 1.0);
    return 1.0 - (progress * 0.3);
  }

  double get _featuredTranslateY {
    return -_scrollOffset * 0.5;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      body: SafeArea(
        child: CustomScrollView(
          controller: _mainScrollController,
          slivers: [
            // Sticky Search Bar
            SliverAppBar(
              pinned: true,
              backgroundColor: kBackgroundColor,
              elevation: 0,
              flexibleSpace: FlexibleSpaceBar(
                background: Container(
                  padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  child: TextField(
                    onChanged: (value) {
                      setState(() {
                        searchQuery = value;
                      });
                    },
                    decoration: InputDecoration(
                      hintText: 'Search products...',
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
                      suffixIcon: IconButton(
                        icon: Icon(Icons.sort, color: kTextLightColor),
                        onPressed: () {
                          showModalBottomSheet(
                            context: context,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
                            ),
                            builder: (context) {
                              return Container(
                                padding: EdgeInsets.all(16.0),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Sort By',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: kTextPrimaryColor,
                                      ),
                                    ),
                                    SizedBox(height: 16),
                                    ListTile(
                                      title: Text(
                                        'Price: Low to High',
                                        style: TextStyle(
                                          color: selectedSortOption == 'Price: Low to High'
                                              ? kAccentColor
                                              : kTextPrimaryColor,
                                        ),
                                      ),
                                      trailing: selectedSortOption == 'Price: Low to High'
                                          ? Icon(Icons.check, color: kAccentColor)
                                          : null,
                                      onTap: () {
                                        setState(() {
                                          selectedSortOption = 'Price: Low to High';
                                        });
                                        Navigator.pop(context);
                                      },
                                    ),
                                    ListTile(
                                      title: Text(
                                        'Price: High to Low',
                                        style: TextStyle(
                                          color: selectedSortOption == 'Price: High to Low'
                                              ? kAccentColor
                                              : kTextPrimaryColor,
                                        ),
                                      ),
                                      trailing: selectedSortOption == 'Price: High to Low'
                                          ? Icon(Icons.check, color: kAccentColor)
                                          : null,
                                      onTap: () {
                                        setState(() {
                                          selectedSortOption = 'Price: High to Low';
                                        });
                                        Navigator.pop(context);
                                      },
                                    ),
                                    ListTile(
                                      title: Text(
                                        'Date: Newest First',
                                        style: TextStyle(
                                          color: selectedSortOption == 'Date: Newest First'
                                              ? kAccentColor
                                              : kTextPrimaryColor,
                                        ),
                                      ),
                                      trailing: selectedSortOption == 'Date: Newest First'
                                          ? Icon(Icons.check, color: kAccentColor)
                                          : null,
                                      onTap: () {
                                        setState(() {
                                          selectedSortOption = 'Date: Newest First';
                                        });
                                        Navigator.pop(context);
                                      },
                                    ),
                                    ListTile(
                                      title: Text(
                                        'Date: Oldest First',
                                        style: TextStyle(
                                          color: selectedSortOption == 'Date: Oldest First'
                                              ? kAccentColor
                                              : kTextPrimaryColor,
                                        ),
                                      ),
                                      trailing: selectedSortOption == 'Date: Oldest First'
                                          ? Icon(Icons.check, color: kAccentColor)
                                          : null,
                                      onTap: () {
                                        setState(() {
                                          selectedSortOption = 'Date: Oldest First';
                                        });
                                        Navigator.pop(context);
                                      },
                                    ),
                                  ],
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ),
              toolbarHeight: 72.0, // Adjust height to fit search bar
            ),

            // Featured Products Section
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
                                Icon(
                                  Icons.star,
                                  color: Colors.amber,
                                  size: 20,
                                ),
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
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
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
                                return _buildFeaturedProductCard(
                                  avitoData[index],
                                );
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
            SliverToBoxAdapter(child: Container(height: 8)),

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

            // Results count
            SliverToBoxAdapter(
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 4.0,
                ),
                child: Row(
                  children: [
                    Text(
                      '${filteredData.length} products found for ${searchQuery.isNotEmpty ? '"$searchQuery"' : "$selectedCategory"}',
                      style: TextStyle(
                        color: kTextSecondaryColor,
                        fontSize: 12.0,
                      ),
                    ),
                    Spacer(),
                  ],
                ),
              ),
            ),

            // Products list
            SliverPadding(
              padding: EdgeInsets.only(bottom: 80),
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
                                'No products found',
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
                      child: Icon(Icons.image, color: kIconsColor, size: 20),
                    );
                  },
                ),
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
          Padding(
            padding: EdgeInsets.all(6),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  item.price,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: kAccentColor,
                  ),
                ),
                SizedBox(height: 1),
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
    final isHovered = _hoveredItemId == item.title;
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductDetailsScreen(
              item: item,
              onAddToCart: widget.onAddToCart,
              onRemoveFromCart: widget.onRemoveFromCart,
            ),
          ),
        );
      },
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (_) {
          setState(() {
            _hoveredItemId = item.title;
          });
        },
        onExit: (_) {
          setState(() {
            _hoveredItemId = null;
          });
        },
        child: Transform.translate(
          offset: isHovered ? Offset(0, -4) : Offset.zero,
          child: AnimatedContainer(
            duration: Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 6.0),
            decoration: BoxDecoration(
              color: kCardBackgroundColor,
              borderRadius: BorderRadius.circular(12.0),
              boxShadow: [
                BoxShadow(
                  color: isHovered
                      ? Colors.black.withOpacity(0.15)
                      : Colors.black.withOpacity(0.05),
                  blurRadius: isHovered ? 16 : 8,
                  offset: Offset(0, isHovered ? 4 : 2),
                  spreadRadius: isHovered ? 2 : 0,
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(12.0)),
                  child: Stack(
                    children: [
                      AnimatedContainer(
                        duration: Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                        child: ImageFiltered(
                          imageFilter: isHovered
                              ? ImageFilter.blur(sigmaX: 2.0, sigmaY: 2.0)
                              : ImageFilter.blur(sigmaX: 0.0, sigmaY: 0.0),
                          child: Image.network(
                            item.imageUrl,
                            width: double.infinity,
                            height: 200.0,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                width: double.infinity,
                                height: 200.0,
                                color: kBackgroundColor,
                                child: Icon(Icons.image, color: kIconsColor, size: 48),
                              );
                            },
                          ),
                        ),
                      ),
                      // Hover overlay with eye icon
                      AnimatedOpacity(
                        duration: Duration(milliseconds: 300),
                        opacity: isHovered ? 1.0 : 0.0,
                        child: Container(
                          width: double.infinity,
                          height: 200.0,
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.4),
                            borderRadius: BorderRadius.vertical(top: Radius.circular(12.0)),
                          ),
                          child: Center(
                            child: AnimatedContainer(
                              duration: Duration(milliseconds: 300),
                              curve: Curves.elasticOut,
                              transform: (isHovered
                                  ? (Matrix4.identity()..scale(1.1))
                                  : (Matrix4.identity()..scale(0.8))),
                              child: Container(
                                padding: EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.95),
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.2),
                                      blurRadius: 8,
                                      offset: Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: Icon(
                                  Icons.visibility,
                                  color: kAccentColor,
                                  size: 28,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        top: 8,
                        right: 8,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                color: _isInCart(item) ? kAccentColor : Colors.white.withOpacity(0.9),
                                shape: BoxShape.circle,
                              ),
                              child: IconButton(
                                icon: Icon(
                                  _isInCart(item) ? Icons.shopping_cart : Icons.shopping_cart_outlined,
                                  color: _isInCart(item) ? Colors.white : kAccentColor,
                                ),
                                onPressed: () => _addToCart(item),
                                iconSize: 20,
                              ),
                            ),
                            SizedBox(width: 8),
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.9),
                                shape: BoxShape.circle,
                              ),
                              child: IconButton(
                                icon: Icon(
                                  _isFavorite(item) ? Icons.favorite : Icons.favorite_border,
                                  color: _isFavorite(item) ? Colors.red : kTextLightColor,
                                ),
                                onPressed: () => _toggleFavorite(item),
                                iconSize: 20,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(item.price, style: kItemsPriceStyle),
                      SizedBox(height: 8.0),
                      Text(
                        item.title,
                        style: kItemsTitleStyle,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 12.0),
                      Row(
                        children: [
                          Icon(
                            Icons.location_on_outlined,
                            size: 16.0,
                            color: kTextLightColor,
                          ),
                          SizedBox(width: 4.0),
                          Expanded(
                            child: Text(item.location, style: kTextIconStyle),
                          ),
                          Text(item.timeAgo, style: kTextIconStyle),
                        ],
                      ),
                      SizedBox(height: 8.0),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 8.0,
                          vertical: 4.0,
                        ),
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