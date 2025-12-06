import 'package:flutter/material.dart';
import 'package:smart_tourism_application/core/entities/budget.dart';
import 'package:smart_tourism_application/core/theme/app_colors.dart';
import 'package:smart_tourism_application/data/models/budgets_responce_model.dart';
import 'package:smart_tourism_application/presentation/views/flight_itinerary/flight_detail_view.dart';
import 'package:smart_tourism_application/presentation/views/activities/activities_list_view.dart';
import 'package:smart_tourism_application/presentation/views/restaurant/restaurant_list_view.dart';
import 'package:smart_tourism_application/presentation/views/hotel/hotel_list_view.dart';

class BudgetDetailItem {
  final Budget budget;
  final String title;
  final String destination;
  final int travelers;
  final Datum? budgetData; // Add API data

  BudgetDetailItem({
    required this.budget,
    required this.title,
    required this.destination,
    required this.travelers,
    this.budgetData,
  });
}

class BudgetDetailView extends StatelessWidget {
  final BudgetDetailItem budgetItem;

  const BudgetDetailView({Key? key, required this.budgetItem}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final budget = budgetItem.budget;
    final allocations = budget.allocations;
    final totalAmount = budget.totalAmount;

    return Scaffold(
      appBar: AppBar(
        title: Text(budgetItem.title),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header section with trip info
            _buildHeaderSection(),
            
            // Budget summary card
            _buildBudgetSummaryCard(),
            
            // Budget breakdown section
            // _buildBudgetBreakdownSection(allocations, totalAmount),
            
            // AI Suggestions section
            _buildAISuggestionsSection(),
            
            // Remove the action buttons
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderSection() {
    final budget = budgetItem.budget;
    final duration = budget.endDate.difference(budget.startDate).inDays;
    
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  budgetItem.destination,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Text(
                  '${budgetItem.travelers} Traveler${budgetItem.travelers > 1 ? 's' : ''}',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          Row(
            children: [
              Icon(Icons.calendar_today, color: Colors.white, size: 20),
              SizedBox(width: 8),
              Text(
                '${_formatDate(budget.startDate)} - ${_formatDate(budget.endDate)}',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(width: 20),
              Icon(Icons.timer, color: Colors.white, size: 20),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  '$duration days',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBudgetSummaryCard() {
    final budget = budgetItem.budget;
    final totalAmount = budget.totalAmount;
    final duration = budget.endDate.difference(budget.startDate).inDays;
    
    return Container(
      margin: EdgeInsets.all(20),
      padding: EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.15),
            spreadRadius: 1,
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            'Total Budget',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.grey[800],
            ),
          ),
          SizedBox(height: 16),
          Text(
            '\$${totalAmount.toStringAsFixed(0)}',
            style: TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            ),
          ),
          SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildSummaryItem('Daily', '\$${(totalAmount / (duration > 0 ? duration : 1)).toStringAsFixed(0)}'),
              _buildSummaryItem('Per Person', '\$${(totalAmount / budgetItem.travelers).toStringAsFixed(0)}'),
              _buildSummaryItem('Daily/Person', '\$${(totalAmount / (duration > 0 ? duration : 1) / budgetItem.travelers).toStringAsFixed(0)}'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryItem(String label, String value) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 14,
              color: AppColors.primary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.grey[800],
          ),
        ),
      ],
    );
  }

  Widget _buildBudgetBreakdownSection(Map<String, double> allocations, double totalAmount) {
    return Container(
      margin: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Budget Breakdown',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.grey[800],
            ),
          ),
          SizedBox(height: 20),
          ...allocations.entries.map((entry) {
            final percentage = totalAmount > 0 
                ? (entry.value / totalAmount) * 100 
                : 0.0;
            
            return _AllocationDetailItem(
              category: entry.key,
              amount: entry.value,
              percentage: percentage,
            );
          }).toList(),
          SizedBox(height: 24),
          _buildRemainingBudgetCard(allocations, totalAmount),
        ],
      ),
    );
  }

  Widget _buildRemainingBudgetCard(Map<String, double> allocations, double totalAmount) {
    final allocatedAmount = allocations.values.reduce((a, b) => a + b);
    final remainingAmount = totalAmount - allocatedAmount;
    final remainingPercentage = totalAmount > 0 ? (remainingAmount / totalAmount) * 100 : 0;
    
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: remainingAmount >= 0 ? Colors.green : Colors.red,
            width: 2,
          ),
          color: remainingAmount >= 0 ? Colors.green.withOpacity(0.05) : Colors.red.withOpacity(0.05),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Remaining Budget',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: remainingAmount >= 0 ? Colors.green[700] : Colors.red[700],
              ),
            ),
            SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '\$${remainingAmount.toStringAsFixed(0)}',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: remainingAmount >= 0 ? Colors.green[700] : Colors.red[700],
                  ),
                ),
                Text(
                  '${remainingPercentage.toStringAsFixed(1)}%',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: remainingAmount >= 0 ? Colors.green[700] : Colors.red[700],
                  ),
                ),
              ],
            ),
            SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: LinearProgressIndicator(
                value: remainingPercentage.clamp(0.0, 100.0) / 100,
                backgroundColor: Colors.grey[300],
                valueColor: AlwaysStoppedAnimation<Color>(
                  remainingAmount >= 0 ? Colors.green : Colors.red,
                ),
                minHeight: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAISuggestionsSection() {
    if (budgetItem.budgetData == null || budgetItem.budgetData!.subcategories.isEmpty) {
      return SizedBox.shrink();
    }

    // Display all subcategories from API (hotel, restaurant, activities, plane, other)
    final allSubcategories = budgetItem.budgetData!.subcategories;

    if (allSubcategories.isEmpty) {
      return SizedBox.shrink();
    }

    return Container(
      margin: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Budget Items',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.grey[800],
            ),
          ),
          SizedBox(height: 20),
          ...allSubcategories.map((subcategory) {
            return _SuggestionCategoryCard(
              subcategory: subcategory,
            );
          }).toList(),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.month}/${date.day}/${date.year}';
  }
}

class _AllocationDetailItem extends StatelessWidget {
  final String category;
  final double amount;
  final double percentage;

  const _AllocationDetailItem({
    required this.category,
    required this.amount,
    required this.percentage,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                category,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey[800],
                ),
              ),
              Text(
                '\$${amount.toStringAsFixed(0)} (${percentage.toStringAsFixed(1)}%)',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey[800],
                ),
              ),
            ],
          ),
          SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: LinearProgressIndicator(
              value: percentage / 100,
              backgroundColor: Colors.grey[300],
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
              minHeight: 14,
            ),
          ),
        ],
      ),
    );
  }
}

class _SuggestionCategoryCard extends StatelessWidget {
  final Subcategory subcategory;

  const _SuggestionCategoryCard({
    required this.subcategory,
  });

  IconData _getIconForType(Type type) {
    switch (type) {
      case Type.PLANE:
        return Icons.flight;
      case Type.RESTAURANT:
        return Icons.restaurant;
      case Type.ACTIVITIES:
        return Icons.local_activity;
      case Type.OTHER:
        return Icons.category;
      case Type.HOTEL:
        return Icons.hotel;
    }
  }

  String _getTitleForType(Type type) {
    switch (type) {
      case Type.PLANE:
        return 'Flights';
      case Type.RESTAURANT:
        return 'Restaurants';
      case Type.ACTIVITIES:
        return 'Events';
      case Type.OTHER:
        return 'Clubs';
      case Type.HOTEL:
        return 'Hotels';
    }
  }

  String _getDescriptionForType(Type type) {
    switch (type) {
      case Type.PLANE:
        return 'Flight options and bookings';
      case Type.RESTAURANT:
        return 'Restaurant recommendations and dining options';
      case Type.ACTIVITIES:
        return 'Events and activities';
      case Type.OTHER:
        return 'Clubs and other options';
      case Type.HOTEL:
        return 'Hotel recommendations';
    }
  }

  String _getDescriptionText(Description description) {
    // Convert enum to readable string
    switch (description) {
      case Description.HOTEL_BUDGET:
        return 'Hotel budget';
      case Description.RESTAURANT_BUDGET:
        return 'Restaurant budget';
      case Description.ACTIVITIES_BUDGET:
        return 'Activities budget';
      case Description.DESC:
        return 'Other budget';
    }
  }

  void _navigateToDetail(BuildContext context, Type type, int itemId) {
    switch (type) {
      case Type.PLANE:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => FlightDetailView(flightId: itemId),
          ),
        );
        break;
      case Type.RESTAURANT:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => RestaurantDetailView(restaurantId: itemId),
          ),
        );
        break;
      case Type.ACTIVITIES:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ActivityDetailView(activityId: itemId),
          ),
        );
        break;
      case Type.OTHER:
        // No detail page for clubs/other
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Detail page not available for this item'),
            backgroundColor: Colors.orange,
          ),
        );
        break;
      case Type.HOTEL:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => HotelDetailView(hotelId: itemId),
          ),
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: ExpansionTile(
        title: Row(
          children: [
            Icon(_getIconForType(subcategory.type), color: AppColors.primary, size: 24),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _getTitleForType(subcategory.type),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Colors.grey[800],
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    _getDescriptionForType(subcategory.type),
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        children: [
          Container(
            padding: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Display subcategory details from API
                if (subcategory.name != null)
                  Padding(
                    padding: EdgeInsets.only(bottom: 12),
                    child: Text(
                      'Name: ${subcategory.name}',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey[700],
                      ),
                    ),
                  ),
                Padding(
                  padding: EdgeInsets.only(bottom: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Description:',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey[700],
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        subcategory.descriptionText.isNotEmpty 
                            ? subcategory.descriptionText 
                            : _getDescriptionText(subcategory.description),
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 12),
                  child: Row(
                    children: [
                      Text(
                        'Percentage: ',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey[700],
                        ),
                      ),
                      Text(
                        '${subcategory.percentage}%',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
                if (subcategory.allocatedAmount != null)
                  Padding(
                    padding: EdgeInsets.only(bottom: 12),
                    child: Row(
                      children: [
                        Text(
                          'Allocated Amount: ',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey[700],
                          ),
                        ),
                        Text(
                          '\$${subcategory.allocatedAmount}',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                if (subcategory.spentAmount.isNotEmpty)
                  Padding(
                    padding: EdgeInsets.only(bottom: 12),
                    child: Row(
                      children: [
                        Text(
                          'Spent Amount: ',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey[700],
                          ),
                        ),
                        Text(
                          '\$${subcategory.spentAmount}',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                Divider(),
                SizedBox(height: 8),
                Text(
                  'Items:',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[800],
                  ),
                ),
                SizedBox(height: 12),
                if (subcategory.items.isEmpty)
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    child: Row(
                      children: [
                        Icon(
                          Icons.info_outline,
                          size: 20,
                          color: Colors.orange,
                        ),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'No items available - This item is currently unavailable',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.orange[700],
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                else
                  ...subcategory.items.map((item) => InkWell(
                    onTap: () => _navigateToDetail(context, subcategory.type, item.typeId),
                    child: Card(
                      margin: EdgeInsets.only(bottom: 8),
                      elevation: 1,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(12),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(
                              Icons.check_circle,
                              size: 20,
                              color: AppColors.primary,
                            ),
                            SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'ID: ${item.id}',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      height: 1.4,
                                    ),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    'Amount: \$${item.amount}',
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500,
                                      color: AppColors.primary,
                                    ),
                                  ),
                                  if (item.types != null)
                                    Padding(
                                      padding: EdgeInsets.only(top: 4),
                                      child: Text(
                                        'Type: ${item.types.toString().split('.').last}',
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.grey[600],
                                        ),
                                      ),
                                    ),
                                  if (item.purchasedAt != null)
                                    Padding(
                                      padding: EdgeInsets.only(top: 4),
                                      child: Text(
                                        'Purchased At: ${item.purchasedAt}',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey[500],
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                            Icon(
                              Icons.arrow_forward_ios,
                              size: 16,
                              color: Colors.grey[400],
                            ),
                          ],
                        ),
                      ),
                    ),
                  )).toList(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}