import 'package:flutter/material.dart';
import 'package:smart_tourism_application/core/theme/app_colors.dart';
import 'package:smart_tourism_application/presentation/widgets/custom_app_bar.dart';
import 'package:smart_tourism_application/presentation/controllers/hotels_controller.dart';
import 'package:provider/provider.dart';
import 'package:smart_tourism_application/core/entities/hotel.dart';
import 'package:get_it/get_it.dart';
import 'package:smart_tourism_application/presentation/widgets/rating_dialog.dart';
import 'package:smart_tourism_application/presentation/controllers/ratings_controller.dart';
import 'package:smart_tourism_application/presentation/widgets/main_bottom_nav_bar.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:smart_tourism_application/core/entities/city.dart' as entities;
import 'package:smart_tourism_application/core/use_cases/city/get_cities.dart';

class HotelListView extends StatefulWidget {
  const HotelListView({super.key});

  @override
  State<HotelListView> createState() => _HotelListViewState();
}

class _HotelListViewState extends State<HotelListView> {
  final TextEditingController _searchController = TextEditingController();
  int? _selectedCityId;
  int? _selectedRating;
  List<entities.City> _cities = [];
  bool _isLoadingCities = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

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
      // يمكن لاحقًا إظهار رسالة خطأ للمستخدم
    } finally {
      if (mounted) {
        setState(() {
          _isLoadingCities = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) =>
          HotelsController(GetIt.instance())..loadHotels(),
      child: Consumer<HotelsController>(
        builder: (context, controller, child) {
          return Scaffold(
            appBar: CustomAppBar(
              title: 'Hotels',
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
                        child: Text(
                          'Error: ${controller.errorMessage}',
                        ),
                      )
                    : RefreshIndicator(
                        onRefresh: () async {
                          await controller.loadHotels(
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
                              _buildFilterSection(controller.hotels.length),

                              // Hotel Listings
                              _buildHotelListings(controller.hotels),
                            ],
                          ),
                        ),
                      ),
            bottomNavigationBar: MainBottomNavBar(
              currentIndex: 1,
              onTap: (index) {
                switch (index) {
                  case 0:
                    Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
                    break;
                  case 1:
                    // Already on hotels page
                    break;
                  case 2:
                    Navigator.pushNamedAndRemoveUntil(context, '/budget-list', (route) => false);
                    break;
                  case 3:
                    Navigator.pushNamedAndRemoveUntil(context, '/profile', (route) => false);
                    break;
                }
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildSearchSection(HotelsController controller) {
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
              hintText: 'Search hotels...',
              prefixIcon: const Icon(Icons.search),
              border: InputBorder.none,
            ),
            textInputAction: TextInputAction.search,
            onSubmitted: (_) {
              controller.loadHotels(
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
                                child: CircularProgressIndicator(strokeWidth: 2),
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
                                  controller.loadHotels(
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
                            controller.loadHotels(
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

  Widget _buildFilterSection(int hotelCount) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '$hotelCount hotels found',
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

  Widget _buildHotelListings(List<Hotel> hotels) {
    return Container(
      margin: EdgeInsets.all(16.0),
      child: Column(
        children: hotels.map((hotel) {
          return Column(
            children: [
              _HotelCard(hotel: hotel),
              SizedBox(height: 16),
            ],
          );
        }).toList(),
      ),
    );
  }
}

class _HotelCard extends StatelessWidget {
  final Hotel hotel;

  const _HotelCard({required this.hotel});

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
                image: hotel.featuredImage.isNotEmpty 
                    ? NetworkImage(hotel.featuredImage) 
                    : AssetImage('assets/images/default_hotel.jpg') as ImageProvider,
                fit: BoxFit.cover,
              ),
            ),
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
                        hotel.name,
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
                          Icon(Icons.star, size: 16, color: Colors.white),
                          SizedBox(width: 4),
                          Text(
                            '${hotel.priceRange.min}-${hotel.priceRange.max} SAR',
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
                      hotel.address,
                      style: TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 4,
                  children: hotel.services.map((service) {
                    return Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        service.name,
                        style: TextStyle(
                          fontSize: 12,
                        ),
                      ),
                    );
                  }).toList(),
                ),
                SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Avg. price per night',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                        Text(
                          '\$${hotel.priceRange.min} To \$${hotel.priceRange.max}',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                    ElevatedButton(
                      onPressed: () {
                        // Navigate to hotel details
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => HotelDetailView(
                              hotel: hotel,
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

class HotelDetailView extends StatelessWidget {
  final Hotel? hotel;
  final int? hotelId;

  const HotelDetailView({super.key, this.hotel, this.hotelId})
      : assert(hotel != null || hotelId != null, 'Either hotel or hotelId must be provided');

  @override
  Widget build(BuildContext context) {
    // If hotelId is provided, use controller to load hotel
    if (hotelId != null) {
      return ChangeNotifierProvider(
        create: (context) => HotelsController(GetIt.instance()),
        child: Consumer<HotelsController>(
          builder: (context, controller, child) {
            // Load hotel details when the widget is built
            if (controller.selectedHotel == null && !controller.isLoadingHotel) {
              controller.loadHotelById(hotelId!);
            }

            return Scaffold(
              appBar: CustomAppBar(
                title: controller.selectedHotel?.name ?? 'Hotel Details',
                actions: [
                  IconButton(
                    onPressed: () {
                      if (controller.selectedHotel != null) {
                        showDialog(
                          context: context,
                          builder: (context) => ChangeNotifierProvider.value(
                            value: Provider.of<RatingsController>(context, listen: false),
                            child: RatingDialog(
                              typeId: controller.selectedHotel!.id,
                              type: 'hotel',
                              itemName: controller.selectedHotel!.name,
                            ),
                          ),
                        );
                      }
                    },
                    icon: Icon(Icons.star_border),
                    tooltip: 'Rate this hotel',
                  ),
                  IconButton(
                    onPressed: () {
                      // Handle sharing
                    },
                    icon: Icon(Icons.share),
                  ),
                ],
              ),
              body: controller.isLoadingHotel
                  ? Center(child: CircularProgressIndicator())
                  : controller.errorMessage != null
                      ? Center(child: Text('Error: ${controller.errorMessage}'))
                      : controller.selectedHotel != null
                          ? _buildHotelContent(context, controller.selectedHotel!)
                          : Center(child: Text('Hotel not found')),
            );
          },
        ),
      );
    }

    // If hotel object is provided, use it directly
    return Scaffold(
      appBar: CustomAppBar(
        title: hotel!.name,
        actions: [
          IconButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => ChangeNotifierProvider.value(
                  value: Provider.of<RatingsController>(context, listen: false),
                  child: RatingDialog(
                    typeId: hotel!.id,
                    type: 'hotel',
                    itemName: hotel!.name,
                  ),
                ),
              );
            },
            icon: Icon(Icons.star_border),
            tooltip: 'Rate this hotel',
          ),
          IconButton(
            onPressed: () {
              // Handle sharing
            },
            icon: Icon(Icons.share),
          ),
        ],
      ),
      body: _buildHotelContent(context, hotel!),
    );
  }

  Widget _buildHotelContent(BuildContext context, Hotel hotel) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Hotel Image
          _buildHotelImage(hotel),
          
          // Hotel Info
          _buildHotelInfo(hotel),
          
          // Features
          _buildFeatures(hotel),
          
          // Description
          _buildDescription(hotel),
          
          // Action Buttons
          _buildActionButtons(context, hotel),
        ],
      ),
    );
  }

  Widget _buildHotelImage(Hotel hotel) {
    return Container(
      height: 250,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: hotel.featuredImage.isNotEmpty 
              ? NetworkImage(hotel.featuredImage) 
              : AssetImage('assets/images/default_hotel.jpg') as ImageProvider,
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _buildHotelInfo(Hotel hotel) {
    return Container(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  hotel.name,
                  style: TextStyle(
                    fontSize: 24,
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
                child: Text(
                  '\$${hotel.priceRange.min}-${hotel.priceRange.max} per night',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          Row(
            children: [
              Icon(Icons.location_on, color: AppColors.primary),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  hotel.address,
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFeatures(Hotel hotel) {
    return Container(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Features & Services',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: hotel.services.map((service) {
              return Chip(
                label: Text(service.name),
                avatar: Icon(Icons.check, color: AppColors.primary),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildDescription(Hotel hotel) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'About this hotel',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          Text(
            hotel.details,
            style: TextStyle(
              fontSize: 16,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context, Hotel hotel) {
    return Container(
      padding: EdgeInsets.all(16.0),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: () {
                // Handle favorite
              },
              style: OutlinedButton.styleFrom(
                padding: EdgeInsets.all(16.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Icon(Icons.favorite_border, color: AppColors.primary),
            ),
          ),
          SizedBox(width: 16),
          Expanded(
            flex: 2,
            child: ElevatedButton(
              onPressed: () async {
                if (hotel.url != null && hotel.url!.isNotEmpty) {
                  try {
                    final uri = Uri.parse(hotel.url!);
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
                      content: Text('No booking link available for this hotel'),
                      backgroundColor: Colors.orange,
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                padding: EdgeInsets.all(16.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                'Book Now',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}