import '../constants.dart';
import 'package:flutter/material.dart';

class ReviewsScreen extends StatefulWidget {
  @override
  _ReviewsScreenState createState() => _ReviewsScreenState();
}

class _ReviewsScreenState extends State<ReviewsScreen> {
  String selectedFilter = 'All';
  double averageRating = 4.8;
  int totalReviews = 127;

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
          'Reviews',
          style: TextStyle(
            color: kTextPrimaryColor,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Rating summary
          Container(
            padding: EdgeInsets.all(20),
            color: Colors.white,
            child: Column(
              children: [
                Row(
                  children: [
                    // Average rating
                    Column(
                      children: [
                        Text(
                          averageRating.toString(),
                          style: TextStyle(
                            fontSize: 48,
                            fontWeight: FontWeight.bold,
                            color: kTextPrimaryColor,
                          ),
                        ),
                        Row(
                          children: List.generate(5, (index) {
                            return Icon(
                              index < averageRating.floor()
                                  ? Icons.star
                                  : Icons.star_border,
                              color: Colors.amber,
                              size: 20,
                            );
                          }),
                        ),
                        SizedBox(height: 8),
                        Text(
                          '$totalReviews reviews',
                          style: TextStyle(
                            fontSize: 14,
                            color: kTextSecondaryColor,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(width: 24),
                    // Rating breakdown
                    Expanded(
                      child: Column(
                        children: [
                          _buildRatingBar(5, 85),
                          _buildRatingBar(4, 12),
                          _buildRatingBar(3, 2),
                          _buildRatingBar(2, 1),
                          _buildRatingBar(1, 0),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: 8),
          // Filter chips
          Container(
            height: 50,
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                _buildFilterChip('All', selectedFilter == 'All'),
                _buildFilterChip('5 Stars', selectedFilter == '5 Stars'),
                _buildFilterChip('4 Stars', selectedFilter == '4 Stars'),
                _buildFilterChip('3 Stars', selectedFilter == '3 Stars'),
                _buildFilterChip('2 Stars', selectedFilter == '2 Stars'),
                _buildFilterChip('1 Star', selectedFilter == '1 Star'),
              ],
            ),
          ),
          // Reviews list
          Expanded(
            child: ListView(
              padding: EdgeInsets.all(16),
              children: [
                _buildReviewCard(
                  name: 'Alex Petrov',
                  rating: 5,
                  date: '2 days ago',
                  title: 'Great seller!',
                  comment: 'Very responsive and honest seller. Item was exactly as described. Highly recommended!',
                  avatar: 'https://via.placeholder.com/50x50/0066CC/FFFFFF?text=AP',
                ),
                _buildReviewCard(
                  name: 'Maria Ivanova',
                  rating: 5,
                  date: '1 week ago',
                  title: 'Excellent experience',
                  comment: 'Fast delivery, item in perfect condition. Will definitely buy again from this seller.',
                  avatar: 'https://via.placeholder.com/50x50/0066CC/FFFFFF?text=MI',
                ),
                _buildReviewCard(
                  name: 'Dmitry Sokolov',
                  rating: 4,
                  date: '2 weeks ago',
                  title: 'Good transaction',
                  comment: 'Item was good, but delivery took a bit longer than expected. Overall satisfied.',
                  avatar: 'https://via.placeholder.com/50x50/0066CC/FFFFFF?text=DS',
                ),
                _buildReviewCard(
                  name: 'Elena Kuznetsova',
                  rating: 5,
                  date: '3 weeks ago',
                  title: 'Perfect!',
                  comment: 'Amazing seller! Item was better than described. Very professional and friendly.',
                  avatar: 'https://via.placeholder.com/50x50/0066CC/FFFFFF?text=EK',
                ),
                _buildReviewCard(
                  name: 'Sergey Volkov',
                  rating: 3,
                  date: '1 month ago',
                  title: 'Okay experience',
                  comment: 'Item was fine, but communication could have been better. Met expectations.',
                  avatar: 'https://via.placeholder.com/50x50/0066CC/FFFFFF?text=SV',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRatingBar(int stars, int percentage) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          SizedBox(
            width: 20,
            child: Text(
              '$stars',
              style: TextStyle(
                fontSize: 12,
                color: kTextSecondaryColor,
              ),
            ),
          ),
          Icon(Icons.star, color: Colors.amber, size: 16),
          SizedBox(width: 8),
          Expanded(
            child: LinearProgressIndicator(
              value: percentage / 100,
              backgroundColor: Colors.grey[200],
              valueColor: AlwaysStoppedAnimation<Color>(Colors.amber),
            ),
          ),
          SizedBox(width: 8),
          Text(
            '$percentage%',
            style: TextStyle(
              fontSize: 12,
              color: kTextSecondaryColor,
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

  Widget _buildReviewCard({
    required String name,
    required int rating,
    required String date,
    required String title,
    required String comment,
    required String avatar,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundImage: NetworkImage(avatar),
                onBackgroundImageError: (exception, stackTrace) {
                  // Handle error
                },
              ),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: kTextPrimaryColor,
                      ),
                    ),
                    Text(
                      date,
                      style: TextStyle(
                        fontSize: 12,
                        color: kTextLightColor,
                      ),
                    ),
                  ],
                ),
              ),
              // Rating stars
              Row(
                children: List.generate(5, (index) {
                  return Icon(
                    index < rating ? Icons.star : Icons.star_border,
                    color: Colors.amber,
                    size: 16,
                  );
                }),
              ),
            ],
          ),
          SizedBox(height: 12),
          // Review title
          Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: kTextPrimaryColor,
            ),
          ),
          SizedBox(height: 8),
          // Review comment
          Text(
            comment,
            style: TextStyle(
              fontSize: 14,
              color: kTextSecondaryColor,
              height: 1.4,
            ),
          ),
          SizedBox(height: 12),
          // Action buttons
          Row(
            children: [
              TextButton.icon(
                onPressed: () {},
                icon: Icon(Icons.thumb_up_outlined, size: 16),
                label: Text('Helpful'),
                style: TextButton.styleFrom(
                  foregroundColor: kTextSecondaryColor,
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                ),
              ),
              SizedBox(width: 16),
              TextButton.icon(
                onPressed: () {},
                icon: Icon(Icons.reply, size: 16),
                label: Text('Reply'),
                style: TextButton.styleFrom(
                  foregroundColor: kAccentColor,
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
} 