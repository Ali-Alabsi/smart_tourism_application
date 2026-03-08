import 'package:flutter/material.dart';
import 'package:smart_tourism_application/core/theme/app_colors.dart';
import 'package:smart_tourism_application/presentation/widgets/custom_app_bar.dart';
import 'package:smart_tourism_application/presentation/controllers/restaurants_controller.dart';
import 'package:provider/provider.dart';
import 'package:smart_tourism_application/core/entities/restaurant.dart';
import 'package:get_it/get_it.dart';
import 'package:smart_tourism_application/presentation/widgets/rating_dialog.dart';
import 'package:smart_tourism_application/presentation/controllers/ratings_controller.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:smart_tourism_application/core/entities/city.dart' as entities;
import 'package:smart_tourism_application/core/use_cases/city/get_cities.dart';

class RestaurantListView extends StatefulWidget {
  const RestaurantListView({super.key});

  @override
  State<RestaurantListView> createState() => _RestaurantListViewState();
}

class _RestaurantListViewState extends State<RestaurantListView> {
  final TextEditingController _searchController = TextEditingController();
  int? _selectedCityId;
  int? _selectedRating;
  List<entities.City> _cities = [];
  bool _isLoadingCities = false;

  @override
  void initState() {
    super.initState();
    _loadCities();
  }

  Future<void> _loadCities() async {
    setState(() {
      _isLoadingCities = true;
    });
    try {
      final getCities = GetIt.instance<GetCities>();
      final cities = await getCities.execute();
      setState(() {
        _cities = cities;
      });
    } catch (_) {
      // يمكن لاحقًا إظهار رسالة خطأ
    } finally {
      if (mounted) {
        setState(() {
          _isLoadingCities = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) =>
          RestaurantsController(GetIt.instance())..loadRestaurants(),
      child: Consumer<RestaurantsController>(
        builder: (context, controller, child) {
          return Scaffold(
            appBar: CustomAppBar(
              title: 'Restaurants',
              actions: [
                // IconButton(
                //   onPressed: () {
                //     // Handle notifications
                //   },
                //   icon: Icon(Icons.notifications),
                // ),
              ],
            ),
            body: controller.isLoading
                ? const Center(child: CircularProgressIndicator())
                : controller.errorMessage != null
                    ? Center(
                        child: Text('Error: ${controller.errorMessage}'),
                      )
                    : RefreshIndicator(
                        onRefresh: () async {
                          await controller.loadRestaurants(
                            name: _searchController.text,
                            cityId: _selectedCityId,
                            rating: _selectedRating,
                          );
                        },
                        child: SingleChildScrollView(
                          physics: const AlwaysScrollableScrollPhysics(),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Search Section
                              _buildSearchSection(controller),

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

  Widget _buildSearchSection(RestaurantsController controller) {
    return Container(
      margin: const EdgeInsets.all(16.0),
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
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
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Search restaurants...',
              prefixIcon: const Icon(Icons.search),
              border: InputBorder.none,
            ),
            textInputAction: TextInputAction.search,
            onSubmitted: (_) {
              controller.loadRestaurants(
                name: _searchController.text,
                cityId: _selectedCityId,
                rating: _selectedRating,
              );
            },
          ),
          const Divider(),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Location',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
                    Row(
                      children: [
                        const Icon(Icons.location_on, size: 16),
                        const SizedBox(width: 8),
                        _isLoadingCities
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child:
                                    CircularProgressIndicator(strokeWidth: 2),
                              )
                            : DropdownButton<int>(
                                value: _selectedCityId,
                                hint: const Text('All cities'),
                                underline: const SizedBox.shrink(),
                                items: _cities
                                    .map(
                                      (c) => DropdownMenuItem(
                                        value: c.id,
                                        child: Text(c.name),
                                      ),
                                    )
                                    .toList(),
                                onChanged: (value) {
                                  setState(() {
                                    _selectedCityId = value;
                                  });
                                  controller.loadRestaurants(
                                    name: _searchController.text,
                                    cityId: _selectedCityId,
                                    rating: _selectedRating,
                                  );
                                },
                              ),
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
                    const Text(
                      'Rating (1-5)',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
                    Row(
                      children: [
                        const Icon(Icons.star,
                            size: 16, color: Colors.amber),
                        const SizedBox(width: 8),
                        DropdownButton<int>(
                          value: _selectedRating,
                          hint: const Text('Any rating'),
                          underline: const SizedBox.shrink(),
                          items: List.generate(
                            5,
                            (index) => DropdownMenuItem(
                              value: index + 1,
                              child: Text('${index + 1} Stars'),
                            ),
                          ),
                          onChanged: (value) {
                            setState(() {
                              _selectedRating = value;
                            });
                            controller.loadRestaurants(
                              name: _searchController.text,
                              cityId: _selectedCityId,
                              rating: _selectedRating,
                            );
                          },
                        ),
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
            width: double.infinity,
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
                    Row(
                      children: [
                        IconButton(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) => ChangeNotifierProvider.value(
                                value: Provider.of<RatingsController>(context, listen: false),
                                child: RatingDialog(
                                  typeId: restaurant.id,
                                  type: 'restaurant',
                                  itemName: restaurant.name,
                                ),
                              ),
                            );
                          },
                          icon: Icon(Icons.star_border),
                          color: AppColors.primary,
                          tooltip: 'Rate this restaurant',
                        ),
                        ElevatedButton(
                          onPressed: () async {
                            if (restaurant.url != null && restaurant.url!.isNotEmpty) {
                              try {
                                final uri = Uri.parse(restaurant.url!);
                                if (await launchUrl(uri, mode: LaunchMode.externalApplication)) {
                                  // Successfully launched
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('Could not open booking link'),
                                      backgroundColor: Colors.red,
                                    ),
                                  );
                                }
                              } catch (e) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Could not open booking link: ${e.toString()}'),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                              }
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('No booking link available for this restaurant'),
                                  backgroundColor: Colors.orange,
                                ),
                              );
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: Text('Book Now'),
                        ),
                      ],
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

class RestaurantDetailView extends StatelessWidget {
  final int restaurantId;

  const RestaurantDetailView({super.key, required this.restaurantId});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => RestaurantsController(GetIt.instance()),
      child: Consumer<RestaurantsController>(
        builder: (context, controller, child) {
          // Load restaurant details when the widget is built
          if (controller.selectedRestaurant == null && !controller.isLoadingRestaurant) {
            controller.loadRestaurantById(restaurantId);
          }

          return Scaffold(
            appBar: CustomAppBar(
              title: controller.selectedRestaurant?.name ?? 'Restaurant Details',
              actions: [
                IconButton(
                  onPressed: () {
                    if (controller.selectedRestaurant != null) {
                      showDialog(
                        context: context,
                        builder: (context) => ChangeNotifierProvider.value(
                          value: Provider.of<RatingsController>(context, listen: false),
                          child: RatingDialog(
                            typeId: controller.selectedRestaurant!.id,
                            type: 'restaurants',
                            itemName: controller.selectedRestaurant!.name,
                          ),
                        ),
                      );
                    }
                  },
                  icon: Icon(Icons.star_border),
                  tooltip: 'Rate this restaurant',
                ),
                IconButton(
                  onPressed: () {
                    // Handle sharing
                  },
                  icon: Icon(Icons.share),
                ),
              ],
            ),
            body: controller.isLoadingRestaurant
                ? Center(child: CircularProgressIndicator())
                : controller.errorMessage != null
                    ? Center(child: Text('Error: ${controller.errorMessage}'))
                    : controller.selectedRestaurant != null
                        ? SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Restaurant Image
                                _buildRestaurantImage(controller.selectedRestaurant!),
                                
                                // Restaurant Info
                                _buildRestaurantInfo(controller.selectedRestaurant!),
                                
                                // Foods Section
                                _buildFoodsSection(controller.selectedRestaurant!),
                                
                                // Action Buttons
                                _buildActionButtons(context, controller.selectedRestaurant!),
                              ],
                            ),
                          )
                        : Center(child: Text('Restaurant not found')),
          );
        },
      ),
    );
  }

  Widget _buildRestaurantImage(Restaurant restaurant) {
    return Container(
      height: 250,
      decoration: BoxDecoration(
        color: Colors.grey[300],
        image: restaurant.logo.isNotEmpty 
            ? DecorationImage(
                image: NetworkImage(restaurant.logo),
                fit: BoxFit.cover,
              )
            : null,
      ),
      child: restaurant.logo.isEmpty
          ? Center(
              child: Icon(Icons.restaurant, size: 80, color: Colors.grey[600]),
            )
          : null,
    );
  }

  Widget _buildRestaurantInfo(Restaurant restaurant) {
    return Container(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            restaurant.name,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          Row(
            children: [
              Icon(Icons.location_on, size: 16, color: Colors.grey[600]),
              SizedBox(width: 4),
              Expanded(
                child: Text(
                  restaurant.address,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[600],
                  ),
                ),
              ),
            ],
          ),
          if (restaurant.cuisineType.isNotEmpty) ...[
            SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.restaurant_menu, size: 16, color: Colors.grey[600]),
                SizedBox(width: 4),
                Text(
                  restaurant.cuisineType,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ],
          if (restaurant.openingHours != null) ...[
            SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.access_time, size: 16, color: Colors.grey[600]),
                SizedBox(width: 4),
                Text(
                  '${restaurant.openingHours.openingTime} - ${restaurant.openingHours.closingTime}',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildFoodsSection(Restaurant restaurant) {
    if (restaurant.foods.data.isEmpty) {
      return SizedBox.shrink();
    }

    return Container(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Menu',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 16),
          ...restaurant.foods.data.map((food) => Card(
            margin: EdgeInsets.only(bottom: 12),
            child: ListTile(
              title: Text(
                food.name,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (food.description.isNotEmpty)
                    Padding(
                      padding: EdgeInsets.only(top: 4),
                      child: Text(food.description),
                    ),
                  Padding(
                    padding: EdgeInsets.only(top: 4),
                    child: Text(
                      '\$${food.priceRange.from} - \$${food.priceRange.to}',
                      style: TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
              trailing: Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  food.type,
                  style: TextStyle(
                    color: AppColors.primary,
                    fontSize: 12,
                  ),
                ),
              ),
            ),
          )).toList(),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context, Restaurant restaurant) {
    return Container(
      padding: EdgeInsets.all(16.0),
      child: Column(
        children: [
          if (restaurant.url != null && restaurant.url!.isNotEmpty)
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () async {
                  final uri = Uri.parse(restaurant.url!);
                  if (await canLaunchUrl(uri)) {
                    await launchUrl(uri);
                  }
                },
                icon: Icon(Icons.open_in_browser),
                label: Text('Visit Website'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            ),
        ],
      ),
    );
  }
}