import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_tourism_application/core/theme/app_colors.dart';
import 'package:smart_tourism_application/presentation/widgets/custom_app_bar.dart';
import 'package:smart_tourism_application/presentation/controllers/destinations_controller.dart';
import 'package:smart_tourism_application/presentation/widgets/destination_card.dart';

class DestinationsListView extends StatefulWidget {
  const DestinationsListView({super.key});

  @override
  State<DestinationsListView> createState() => _DestinationsListViewState();
}

class _DestinationsListViewState extends State<DestinationsListView> {
  @override
  void initState() {
    super.initState();
    // تحميل الوجهات أول مرة بعد بناء الـ widget
    Future.microtask(() {
      final controller =
          Provider.of<DestinationsController>(context, listen: false);
      controller.loadDestinations();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<DestinationsController>(
      builder: (context, controller, _) {
        return Scaffold(
          appBar: const CustomAppBar(
            title: 'Destinations',
          ),
          body: controller.isLoading
              ? const Center(child: CircularProgressIndicator())
              : controller.errorMessage != null
                  ? Center(child: Text(controller.errorMessage!))
                  : RefreshIndicator(
                      onRefresh: () async {
                        await controller.loadDestinations();
                      },
                      child: SingleChildScrollView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Hero Banner
                            _buildHeroBanner(),

                            // Search
                            // _buildSearchAndFilter(controller),

                            // Popular Destinations
                            _buildPopularDestinations(context, controller),

                            // Featured Destinations
                            _buildFeaturedDestinations(context, controller),
                          ],
                        ),
                      ),
                    ),
        );
      },
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

  Widget _buildSearchAndFilter(DestinationsController controller) {
    final TextEditingController searchController = TextEditingController();
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        controller: searchController,
        decoration: const InputDecoration(
          hintText: 'Search destinations...',
          prefixIcon: Icon(Icons.search),
          border: InputBorder.none,
        ),
        textInputAction: TextInputAction.search,
        onSubmitted: (value) {
          controller.searchDestinations(value);
        },
      ),
    );
  }

  Widget _buildPopularDestinations(
      BuildContext context, DestinationsController controller) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Popular Destinations',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 12),
          SizedBox(
            height: 300,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: controller.popularDestinations.length,
              separatorBuilder: (_, __) => const SizedBox(width: 16),
              itemBuilder: (context, index) {
                final destination = controller.popularDestinations[index];
                return SizedBox(
                  width: 200,
                  child: DestinationCard(destination: destination),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeaturedDestinations(
      BuildContext context, DestinationsController controller) {
    return Container(
      margin: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Featured Destinations',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 16),
          ...controller.featuredDestinations.map(
            (destination) => Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: DestinationCard(destination: destination),
            ),
          ),
        ],
      ),
    );
  }
}