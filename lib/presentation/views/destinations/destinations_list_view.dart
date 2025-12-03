import 'package:flutter/material.dart';
import 'package:smart_tourism_application/core/theme/app_colors.dart';
import 'package:smart_tourism_application/presentation/widgets/custom_app_bar.dart';

class DestinationsListView extends StatelessWidget {
  const DestinationsListView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Destinations',
        actions: [
          IconButton(
            onPressed: () {
              // Handle search
            },
            icon: Icon(Icons.search),
          ),
          IconButton(
            onPressed: () {
              // Handle notifications
            },
            icon: Icon(Icons.notifications),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hero Banner
            _buildHeroBanner(),
            
            // Search and Filter
            _buildSearchAndFilter(),
            
            // Categories
            _buildCategories(),
            
            // Popular Destinations
            _buildPopularDestinations(context),
            
            // Featured Destinations
            _buildFeaturedDestinations(context),
          ],
        ),
      ),
    );
  }

  Widget _buildHeroBanner() {
    return Container(
      height: 200,
      margin: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.0),
        image: DecorationImage(
          image: AssetImage('assets/images/destinations_banner.jpg'),
          fit: BoxFit.cover,
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.0),
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.transparent,
              Colors.black.withOpacity(0.7),
            ],
          ),
        ),
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Discover Amazing Places',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 4),
              Text(
                'Explore the beauty of Saudi Arabia',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchAndFilter() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 1,
                    blurRadius: 5,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Search destinations...',
                  prefixIcon: Icon(Icons.search),
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          SizedBox(width: 12),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 1,
                  blurRadius: 5,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: IconButton(
              onPressed: () {
                // Handle filter
              },
              icon: Icon(Icons.filter_list),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategories() {
    return Container(
      margin: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Categories',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 12),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _CategoryChip(
                  icon: Icons.location_city,
                  label: 'Cities',
                  isSelected: true,
                ),
                SizedBox(width: 12),
                _CategoryChip(
                  icon: Icons.nature,
                  label: 'Nature',
                  isSelected: false,
                ),
                SizedBox(width: 12),
                _CategoryChip(
                  icon: Icons.beach_access,
                  label: 'Beaches',
                  isSelected: false,
                ),
                SizedBox(width: 12),
                _CategoryChip(
                  icon: Icons.temple_buddhist,
                  label: 'Historical',
                  isSelected: false,
                ),
                SizedBox(width: 12),
                _CategoryChip(
                  icon: Icons.restaurant,
                  label: 'Culinary',
                  isSelected: false,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPopularDestinations(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Popular Destinations',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextButton(
                onPressed: () {
                  // Handle view all
                },
                child: Text('View All'),
              ),
            ],
          ),
          SizedBox(height: 12),
          SizedBox(
            height: 250,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                _DestinationCard(
                  context: context,
                  imageUrl: 'assets/images/riyadh.jpg',
                  title: 'Riyadh',
                  location: 'Saudi Arabia',
                  rating: 4.8,
                  price: 120,
                ),
                SizedBox(width: 16),
                _DestinationCard(
                  context: context,
                  imageUrl: 'assets/images/jeddah.jpg',
                  title: 'Jeddah',
                  location: 'Saudi Arabia',
                  rating: 4.6,
                  price: 100,
                ),
                SizedBox(width: 16),
                _DestinationCard(
                  context: context,
                  imageUrl: 'assets/images/medina.jpg',
                  title: 'Medina',
                  location: 'Saudi Arabia',
                  rating: 4.9,
                  price: 90,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeaturedDestinations(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Featured Destinations',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 16),
          _FeaturedDestinationCard(
            context: context,
            imageUrl: 'assets/images/neom.jpg',
            title: 'NEOM',
            description: 'The future city being built in northwestern Saudi Arabia',
            rating: 4.9,
          ),
          SizedBox(height: 16),
          _FeaturedDestinationCard(
            context: context,
            imageUrl: 'assets/images/alula.jpg',
            title: 'AlUla',
            description: 'An ancient city with thousands of years of history',
            rating: 4.7,
          ),
          SizedBox(height: 16),
          _FeaturedDestinationCard(
            context: context,
            imageUrl: 'assets/images/abha.jpg',
            title: 'Abha',
            description: 'Mountain city known for its cool climate and natural beauty',
            rating: 4.5,
          ),
        ],
      ),
    );
  }
}

class _CategoryChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;

  const _CategoryChip({
    required this.icon,
    required this.label,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    return ChoiceChip(
      label: Row(
        children: [
          Icon(icon, size: 18),
          SizedBox(width: 6),
          Text(label),
        ],
      ),
      selected: isSelected,
      selectedColor: AppColors.primary,
      backgroundColor: Colors.grey[200],
      labelStyle: TextStyle(
        color: isSelected ? Colors.white : Colors.black,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
    );
  }
}

class _DestinationCard extends StatelessWidget {
  final BuildContext context;
  final String imageUrl;
  final String title;
  final String location;
  final double rating;
  final double price;

  const _DestinationCard({
    required this.context,
    required this.imageUrl,
    required this.title,
    required this.location,
    required this.rating,
    required this.price,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 180,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        elevation: 3,
        child: InkWell(
          onTap: () {
            // Navigate to destination detail view
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DestinationDetailView(
                  destination: {
                    'name': title,
                    'location': location,
                    'rating': rating,
                    'price': price,
                    'imageUrl': imageUrl,
                    'description': 'A beautiful destination with amazing experiences.',
                  },
                ),
              ),
            );
          },
          borderRadius: BorderRadius.circular(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.vertical(top: Radius.circular(12.0)),
                    image: DecorationImage(
                      image: AssetImage(imageUrl),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Align(
                    alignment: Alignment.topRight,
                    child: Container(
                      margin: EdgeInsets.all(8.0),
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.star, size: 14, color: Colors.white),
                          SizedBox(width: 4),
                          Text(
                            '$rating',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(Icons.location_on, size: 14, color: Colors.grey),
                        SizedBox(width: 4),
                        Text(
                          location,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    Text(
                      'From \$${price.toStringAsFixed(0)}',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FeaturedDestinationCard extends StatelessWidget {
  final BuildContext context;
  final String imageUrl;
  final String title;
  final String description;
  final double rating;

  const _FeaturedDestinationCard({
    required this.context,
    required this.imageUrl,
    required this.title,
    required this.description,
    required this.rating,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      elevation: 3,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 150,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.vertical(top: Radius.circular(12.0)),
              image: DecorationImage(
                image: AssetImage(imageUrl),
                fit: BoxFit.cover,
              ),
            ),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.vertical(top: Radius.circular(12.0)),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withOpacity(0.7),
                  ],
                ),
              ),
              child: Align(
                alignment: Alignment.bottomLeft,
                child: Padding(
                  padding: EdgeInsets.all(12.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.star, size: 14, color: Colors.white),
                            SizedBox(width: 4),
                            Text(
                              '$rating',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
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
          ),
          Padding(
            padding: EdgeInsets.all(12.0),
            child: Text(
              description,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[700],
                height: 1.4,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // Navigate to destination detail view
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DestinationDetailView(
                        destination: {
                          'name': title,
                          'location': 'Saudi Arabia',
                          'rating': rating,
                          'price': 0.0,
                          'imageUrl': imageUrl,
                          'description': description,
                        },
                      ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text('View Details'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class DestinationDetailView extends StatelessWidget {
  final Map<String, dynamic> destination;

  const DestinationDetailView({super.key, required this.destination});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: destination['name'],
        actions: [
          IconButton(
            onPressed: () {
              // Handle sharing
            },
            icon: Icon(Icons.share),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Destination Image
            _buildDestinationImage(),
            
            // Destination Info
            _buildDestinationInfo(),
            
            // Features
            _buildFeatures(),
            
            // Description
            _buildDescription(),
            
            // Action Buttons
            _buildActionButtons(context),
          ],
        ),
      ),
    );
  }

  Widget _buildDestinationImage() {
    return Container(
      height: 250,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(destination['imageUrl']),
          fit: BoxFit.cover,
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.transparent,
              Colors.black.withOpacity(0.7),
            ],
          ),
        ),
        child: Align(
          alignment: Alignment.bottomLeft,
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.star, size: 16, color: Colors.white),
                      SizedBox(width: 4),
                      Text(
                        '${destination['rating']}',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                if (destination['price'] > 0)
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      'From \$${destination['price'].toStringAsFixed(0)}',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDestinationInfo() {
    return Container(
      margin: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            destination['name'],
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          Row(
            children: [
              Icon(Icons.location_on, color: Colors.grey),
              SizedBox(width: 4),
              Text(
                destination['location'],
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFeatures() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Highlights',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _FeatureChip(label: 'Historical'),
              _FeatureChip(label: 'Cultural'),
              _FeatureChip(label: 'Natural'),
              _FeatureChip(label: 'Adventure'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDescription() {
    return Container(
      margin: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'About',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 12),
          Text(
            destination['description'],
            style: TextStyle(
              fontSize: 14,
              height: 1.6,
              color: Colors.grey[700],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(16.0),
      child: Column(
        children: [
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                // Show information about planning a trip
                _showTripPlanningDialog(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                padding: EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                'Plan a Trip',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: () {
                // Handle add to favorites
              },
              style: OutlinedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                'Add to Favorites',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showTripPlanningDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Trip Planning'),
          content: Text(
            'Get personalized trip planning assistance for ${destination['name']} through our partner travel services. '
            'You will be connected with travel experts who can help you plan your visit.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                // In a real app, this would connect to travel planning services
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Connecting to travel planning services...'),
                    backgroundColor: AppColors.primary,
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
              ),
              child: Text('Continue'),
            ),
          ],
        );
      },
    );
  }
}

class _FeatureChip extends StatelessWidget {
  final String label;

  const _FeatureChip({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.primary.withOpacity(0.3),
        ),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: AppColors.primary,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}