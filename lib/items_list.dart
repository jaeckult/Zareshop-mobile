import 'constants.dart';
import 'models/avito_model.dart';
import 'screens/product_details_screen.dart';
import 'package:flutter/material.dart';

class ItemsList extends StatelessWidget {
  final List<AvitoItem> ListData;

  ItemsList({required this.ListData});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.all(12.0),
      itemCount: ListData.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ProductDetailsScreen(
                  item: ListData[index],
                ),
              ),
            );
          },
          child: Container(
            margin: EdgeInsets.only(bottom: 12.0),
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
                        ListData[index].imageUrl,
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
                              ListData[index].isFavorite 
                                  ? Icons.favorite 
                                  : Icons.favorite_border,
                              color: ListData[index].isFavorite 
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
                        ListData[index].price,
                        style: kItemsPriceStyle,
                      ),
                      SizedBox(height: 8.0),
                      // Title
                      Text(
                        ListData[index].title,
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
                              ListData[index].location,
                              style: kTextIconStyle,
                            ),
                          ),
                          Text(
                            ListData[index].timeAgo,
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
                          ListData[index].category,
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
      },
    );
  }
}
