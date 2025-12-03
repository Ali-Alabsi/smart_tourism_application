import 'package:flutter/material.dart';
import 'package:smart_tourism_application/core/theme/app_colors.dart';
import 'package:smart_tourism_application/presentation/widgets/custom_app_bar.dart';
import 'package:smart_tourism_application/presentation/controllers/restaurants_controller.dart';
import 'package:provider/provider.dart';
import 'package:smart_tourism_application/core/entities/restaurant.dart';
import 'package:get_it/get_it.dart';

class RestaurantListView extends StatelessWidget {
  const RestaurantListView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => RestaurantsController(GetIt.instance())..loadRestaurants(),
      child: Consumer<RestaurantsController>(
        builder: (context, controller, child) {
          return Scaffold(
            appBar: CustomAppBar(
              title: 'Restaurants',
              actions: [
                IconButton(
                  onPressed: () {
                    // Handle notifications
                  },
                  icon: Icon(Icons.notifications),
                ),
              ],
            ),
            body: controller.isLoading
                ? Center(child: CircularProgressIndicator())
                : controller.errorMessage != null
                    ? Center(child: Text('Error: ${controller.errorMessage}'))
                    : RefreshIndicator(
                        onRefresh: () async {
                          await controller.loadRestaurants();
                        },
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Search Section
                              _buildSearchSection(),
                              
                              // Filter Section
                              _buildFilterSection(controller.restaurants.length),
                              
                              // Restaurant Listings
                              _buildRestaurantListings(controller.restaurants),
                            ],
                          ),
                        ),
                      ),
          );
        },
      ),
    );
  }

  Widget _buildSearchSection() {
    return Container(
      margin: EdgeInsets.all(16.0),
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 5,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          TextField(
            decoration: InputDecoration(
              hintText: 'Search restaurants...',
              prefixIcon: Icon(Icons.search),
              border: InputBorder.none,
            ),
          ),
          Divider(),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Location',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
                    Row(
                      children: [
                        Icon(Icons.location_on, size: 16),
                        SizedBox(width: 8),
                        Text('Riyadh, Saudi Arabia'),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                height: 40,
                width: 1,
                color: Colors.grey,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Cuisine',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
                    Row(
                      children: [
                        Icon(Icons.restaurant, size: 16),
                        SizedBox(width: 8),
                        Text('All Types'),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFilterSection(int restaurantCount) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '$restaurantCount restaurants found',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          Row(
            children: [
              Icon(Icons.filter_list),
              SizedBox(width: 4),
              Text('Filter'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRestaurantListings(List<Restaurant> restaurants) {
    return Container(
      margin: EdgeInsets.all(16.0),
      child: Column(
        children: restaurants.map((restaurant) {
          return Column(
            children: [
              _RestaurantCard(restaurant: restaurant),
              SizedBox(height: 16),
            ],
          );
        }).toList(),
      ),
    );
  }
}

class _RestaurantCard extends StatelessWidget {
  final Restaurant restaurant;

  const _RestaurantCard({required this.restaurant});

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
              color: AppColors.primary.withOpacity(0.1),
              image: restaurant.images.isNotEmpty 
                  ? DecorationImage(
                      image: NetworkImage(restaurant.images.first),
                      fit: BoxFit.cover,
                    )
                  : null,
            ),
            child: restaurant.images.isEmpty
                ? Icon(Icons.restaurant, size: 50, color: AppColors.primary)
                : null,
          ),
          Padding(
            padding: EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        restaurant.name,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.restaurant, size: 16, color: Colors.white),
                          SizedBox(width: 4),
                          Text(
                            '${restaurant.foodsCount} items',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 4),
                Row(
                  children: [
                    Icon(Icons.location_on, size: 16, color: Colors.grey),
                    SizedBox(width: 4),
                    Text(
                      restaurant.address,
                      style: TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.local_dining, size: 16, color: AppColors.primary),
                    SizedBox(width: 4),
                    Text(
                      restaurant.cuisineType,
                      style: TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Opening Hours',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                        Text(
                          '${restaurant.openingHours.openingTime} - ${restaurant.openingHours.closingTime}',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    ElevatedButton(
                      onPressed: () {
                        // Navigate to restaurant details
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Restaurant details would be shown here'),
                            backgroundColor: AppColors.primary,
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text('View Menu'),
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
}