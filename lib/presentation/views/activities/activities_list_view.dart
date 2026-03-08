import 'package:flutter/material.dart';
import 'package:smart_tourism_application/core/theme/app_colors.dart';
import 'package:smart_tourism_application/presentation/widgets/custom_app_bar.dart';
import 'package:smart_tourism_application/presentation/controllers/activities_controller.dart';
import 'package:provider/provider.dart';
import 'package:smart_tourism_application/core/entities/activity.dart';
import 'package:get_it/get_it.dart';
import 'package:smart_tourism_application/presentation/widgets/rating_dialog.dart';
import 'package:smart_tourism_application/presentation/controllers/ratings_controller.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:smart_tourism_application/core/entities/city.dart' as entities;
import 'package:smart_tourism_application/core/use_cases/city/get_cities.dart';

class ActivitiesListView extends StatefulWidget {
  const ActivitiesListView({super.key});

  @override
  State<ActivitiesListView> createState() => _ActivitiesListViewState();
}

class _ActivitiesListViewState extends State<ActivitiesListView> {
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
          ActivitiesController(GetIt.instance())..loadActivities(),
      child: Consumer<ActivitiesController>(
        builder: (context, controller, child) {
          return Scaffold(
            appBar: CustomAppBar(
              title: 'Activities & Events',
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
                          await controller.loadActivities(
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
                              // Search and Filter Section
                              _buildSearchAndFilterSection(controller),

                              // Categories Section
                              // _buildCategoriesSection(),

                              // Upcoming Events Section
                              _buildUpcomingEventsSection(controller.activities),

                              // Popular Activities Section
                              _buildPopularActivitiesSection(
                                  controller.activities),
                            ],
                          ),
                        ),
                      ),
          );
        },
      ),
    );
  }

  Widget _buildSearchAndFilterSection(ActivitiesController controller) {
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
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          TextField(
            controller: _searchController,
            decoration: const InputDecoration(
              hintText: 'Search activities...',
              prefixIcon: Icon(Icons.search),
              border: InputBorder.none,
            ),
            textInputAction: TextInputAction.search,
            onSubmitted: (_) {
              controller.loadActivities(
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
                      'City',
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
                                  controller.loadActivities(
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
                            controller.loadActivities(
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

  Widget _buildCategoriesSection() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.0),
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
                  icon: Icons.nature_people,
                  label: 'Adventure',
                  isSelected: true,
                ),
                SizedBox(width: 12),
                _CategoryChip(
                  icon: Icons.museum,
                  label: 'Culture',
                  isSelected: false,
                ),
                SizedBox(width: 12),
                _CategoryChip(
                  icon: Icons.restaurant,
                  label: 'Food',
                  isSelected: false,
                ),
                SizedBox(width: 12),
                _CategoryChip(
                  icon: Icons.spa,
                  label: 'Wellness',
                  isSelected: false,
                ),
                SizedBox(width: 12),
                _CategoryChip(
                  icon: Icons.music_note,
                  label: 'Entertainment',
                  isSelected: false,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUpcomingEventsSection(List<Activity> activities) {
    // Filter for upcoming events (you can adjust this logic as needed)
    final upcomingEvents = activities.take(2).toList();
    
    if (upcomingEvents.isEmpty) {
      return Container();
    }
    
    return Container(
      margin: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Upcoming Events',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),

            ],
          ),
          SizedBox(height: 12),
          ...upcomingEvents.asMap().entries.map((entry) {
            final index = entry.key;
            final activity = entry.value;
            return Column(
              children: [
                _EventCard(
                  imageUrl: activity.thumbnail.isNotEmpty ? activity.thumbnail : 'assets/images/event${index + 1}.jpg',
                  title: activity.name,
                  date: activity.date,
                  time: 'All Day', // You might want to add time to your model
                  location: activity.address,
                  price: activity.priceRange.min.toDouble(),
                ),
                if (index < upcomingEvents.length - 1) SizedBox(height: 16),
              ],
            );
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildPopularActivitiesSection(List<Activity> activities) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Popular Activities',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 12),
          ...activities.asMap().entries.map((entry) {
            final index = entry.key;
            final activity = entry.value;
            return Column(
              children: [
                _ActivityCard(activity: activity),
                if (index < activities.length - 1) SizedBox(height: 16),
              ],
            );
          }).toList(),
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

class _EventCard extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String date;
  final String time;
  final String location;
  final double price;

  const _EventCard({
    required this.imageUrl,
    required this.title,
    required this.date,
    required this.time,
    required this.location,
    required this.price,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      elevation: 3,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.horizontal(left: Radius.circular(12.0)),
              image: DecorationImage(
                image: AssetImage(imageUrl),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Expanded(
            child: Padding(
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
                      Icon(Icons.calendar_today, size: 14, color: Colors.grey),
                      SizedBox(width: 4),
                      Text(
                        '$date • $time',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.location_on, size: 14, color: Colors.grey),
                      SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          location,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'From \$${price.toStringAsFixed(0)}',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ),
                      OutlinedButton(
                        onPressed: () {
                          // Navigate to event details
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EventDetailView(
                                event: {
                                  'title': title,
                                  'date': date,
                                  'time': time,
                                  'location': location,
                                  'price': price,
                                  'imageUrl': imageUrl,
                                  'description': 'An exciting event that you won\'t want to miss!',
                                },
                              ),
                            ),
                          );
                        },
                        style: OutlinedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text('Details'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ActivityCard extends StatelessWidget {
  final Activity activity;

  const _ActivityCard({
    required this.activity,
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
                image: activity.thumbnail.isNotEmpty 
                    ? NetworkImage(activity.thumbnail) 
                    : AssetImage('assets/images/default_activity.jpg') as ImageProvider,
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
                        activity.name,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.star, size: 14, color: Colors.white),
                          SizedBox(width: 2),
                          Text(
                            '${activity.priceRange.min}-${activity.priceRange.max} SAR',
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
                SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.access_time, size: 14, color: Colors.grey),
                    SizedBox(width: 4),
                    Text(
                      activity.date,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
                    SizedBox(width: 16),
                    Icon(Icons.location_on, size: 14, color: Colors.grey),
                    SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        activity.address,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'From \$${activity.priceRange.min}',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        // Navigate to activity details
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ActivityDetailView(activityId: activity.id),
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

class EventDetailView extends StatelessWidget {
  final Map<String, dynamic> event;

  const EventDetailView({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: event['title'],
        actions: [
          // IconButton(
          //   onPressed: () {
          //     // Handle sharing
          //   },
          //   icon: Icon(Icons.share),
          // ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Event Image
            _buildEventImage(),
            
            // Event Info
            _buildEventInfo(),
            
            // Description
            _buildDescription(),
            
            // Action Buttons
            _buildActionButtons(context),
          ],
        ),
      ),
    );
  }

  Widget _buildEventImage() {
    return Container(
      height: 250,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(event['imageUrl']),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _buildEventInfo() {
    return Container(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                event['title'],
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  '\$${event['price'].toStringAsFixed(0)}',
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
              Icon(Icons.calendar_today, color: AppColors.primary),
              SizedBox(width: 8),
              Text(
                '${event['date']} • ${event['time']}',
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
            ],
          ),
          SizedBox(height: 8),
          Row(
            children: [
              Icon(Icons.location_on, color: AppColors.primary),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  event['location'],
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

  Widget _buildDescription() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'About this event',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          Text(
            event['description'],
            style: TextStyle(
              fontSize: 16,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.0),
      child: Row(
        children: [
          // Expanded(
          //   child: OutlinedButton(
          //     onPressed: () {
          //       // Handle favorite
          //     },
          //     style: OutlinedButton.styleFrom(
          //       padding: EdgeInsets.all(16.0),
          //       shape: RoundedRectangleBorder(
          //         borderRadius: BorderRadius.circular(8),
          //       ),
          //     ),
          //     child: Icon(Icons.favorite_border, color: AppColors.primary),
          //   ),
          // ),
          SizedBox(width: 16),
          Expanded(
            flex: 2,
            child: ElevatedButton(
              onPressed: () async {
                final url = event['url'] as String?;
                if (url != null && url.isNotEmpty) {
                  try {
                    final uri = Uri.parse(url);
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
                      content: Text('No booking link available for this event'),
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

class ActivityDetailView extends StatelessWidget {
  final int activityId;

  const ActivityDetailView({super.key, required this.activityId});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ActivitiesController(GetIt.instance()),
      child: Consumer<ActivitiesController>(
        builder: (context, controller, child) {
          // Load activity details when the widget is built
          if (controller.selectedActivity == null && !controller.isLoadingActivity) {
            controller.loadActivityById(activityId);
          }

          return Scaffold(
            appBar: CustomAppBar(
              title: controller.selectedActivity?.name ?? 'Activity Details',
              actions: [
                IconButton(
                  onPressed: () {
                    if (controller.selectedActivity != null) {
                      showDialog(
                        context: context,
                        builder: (context) => ChangeNotifierProvider.value(
                          value: Provider.of<RatingsController>(context, listen: false),
                          child: RatingDialog(
                            typeId: controller.selectedActivity!.id,
                            type: 'activities',
                            itemName: controller.selectedActivity!.name,
                          ),
                        ),
                      );
                    }
                  },
                  icon: Icon(Icons.star_border),
                  tooltip: 'Rate this activity',
                ),
                IconButton(
                  onPressed: () {
                    // Handle sharing
                  },
                  icon: Icon(Icons.share),
                ),
              ],
            ),
            body: controller.isLoadingActivity
                ? Center(child: CircularProgressIndicator())
                : controller.errorMessage != null
                    ? Center(child: Text('Error: ${controller.errorMessage}'))
                    : controller.selectedActivity != null
                        ? SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Activity Image
                                _buildActivityImage(controller.selectedActivity!),
                                
                                // Activity Info
                                _buildActivityInfo(controller.selectedActivity!),
                                
                                // Description
                                _buildDescription(controller.selectedActivity!),
                                
                                // Reviews
                                _buildReviews(),
                                
                                // Action Buttons
                                // _buildActionButtons(context, controller.selectedActivity!),
                              ],
                            ),
                          )
                        : Center(child: Text('Activity not found')),
          );
        },
      ),
    );
  }

  Widget _buildActivityImage(Activity activity) {
    return Container(
      height: 250,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: activity.thumbnail.isNotEmpty 
              ? NetworkImage(activity.thumbnail) 
              : AssetImage('assets/images/default_activity.jpg') as ImageProvider,
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _buildActivityInfo(Activity activity) {
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
                  activity.name,
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
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Row(
                  children: [
                    Icon(Icons.star, color: Colors.white, size: 16),
                    SizedBox(width: 4),
                    Text(
                      '${activity.priceRange.min}-${activity.priceRange.max} SAR',
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
          SizedBox(height: 16),
          Row(
            children: [
              Icon(Icons.calendar_today, color: AppColors.primary),
              SizedBox(width: 8),
              Text(
                activity.date,
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
              SizedBox(width: 16),
              Icon(Icons.location_on, color: AppColors.primary),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  activity.address,
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          Container(
            padding: EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              'From \$${activity.priceRange.min} to \$${activity.priceRange.max} per person',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDescription(Activity activity) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'About this activity',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          Text(
            activity.details,
            style: TextStyle(
              fontSize: 16,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReviews() {
    return Container(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Reviews',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 16),
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: 3,
            itemBuilder: (context, index) {
              return Container(
                margin: EdgeInsets.only(bottom: 16),
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'User ${index + 1}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Row(
                          children: List.generate(5, (starIndex) {
                            return Icon(
                              starIndex < 4 ? Icons.star : Icons.star_border,
                              color: AppColors.primary,
                              size: 16,
                            );
                          }),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    Text(
                      'This was an amazing experience! Highly recommend to anyone visiting the area.',
                      style: TextStyle(
                        color: Colors.grey[700],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context, Activity activity) {
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
                if (activity.url != null && activity.url!.isNotEmpty) {
                  try {
                    final uri = Uri.parse(activity.url!);
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
                      content: Text('No booking link available for this activity'),
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