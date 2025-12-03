import 'package:flutter/material.dart';
import 'package:smart_tourism_application/core/entities/budget.dart';
import 'package:smart_tourism_application/core/theme/app_colors.dart';

class BudgetDetailItem {
  final Budget budget;
  final String title;
  final String destination;
  final int travelers;

  BudgetDetailItem({
    required this.budget,
    required this.title,
    required this.destination,
    required this.travelers,
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
            _buildBudgetBreakdownSection(allocations, totalAmount),
            
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
              Text(
                '$duration days',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
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
    return Container(
      margin: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'AI-Powered Suggestions',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.grey[800],
            ),
          ),
          SizedBox(height: 20),
          _SuggestionCategoryCard(
            icon: Icons.hotel,
            title: 'Accommodations',
            description: 'Recommended hotels and lodging options based on your budget and preferences',
            items: [
              'Grand Plaza Hotel - \$120/night (4.5★)',
              'Seaside Resort - \$150/night (5★)',
              'City Center Inn - \$80/night (3★)',
            ],
          ),
          SizedBox(height: 20),
          _SuggestionCategoryCard(
            icon: Icons.local_dining,
            title: 'Food & Dining',
            description: 'Restaurant recommendations and local cuisine options',
            items: [
              'Local Restaurant - \$15/meal',
              'Fine Dining Experience - \$50/meal',
              'Street Food Tour - \$10/person',
            ],
          ),
          SizedBox(height: 20),
          _SuggestionCategoryCard(
            icon: Icons.directions_car,
            title: 'Transportation',
            description: 'Best travel options for your trip',
            items: [
              'Airport Transfer - \$25',
              'Daily Car Rental - \$45/day',
              'Public Transit Pass - \$10/day',
            ],
          ),
          SizedBox(height: 20),
          _SuggestionCategoryCard(
            icon: Icons.local_activity,
            title: 'Activities & Tours',
            description: 'Top attractions and experiences',
            items: [
              'City Walking Tour - \$20/person',
              'Museum Entry - \$15/person',
              'Adventure Park - \$40/person',
            ],
          ),
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
  final IconData icon;
  final String title;
  final String description;
  final List<String> items;

  const _SuggestionCategoryCard({
    required this.icon,
    required this.title,
    required this.description,
    required this.items,
  });

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
            Icon(icon, color: AppColors.primary, size: 24),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Colors.grey[800],
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    description,
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
                ...items.map((item) => Padding(
                  padding: EdgeInsets.symmetric(vertical: 10),
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
                        child: Text(
                          item,
                          style: TextStyle(
                            fontSize: 16,
                            height: 1.4,
                          ),
                        ),
                      ),
                    ],
                  ),
                )).toList(),
                SizedBox(height: 20),
                Align(
                  alignment: Alignment.centerRight,
                  child: ElevatedButton(
                    onPressed: () {
                      // TODO: Implement view details functionality
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                    ),
                    child: Text(
                      'View Details',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}