import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_tourism_application/core/entities/budget.dart';
import 'package:smart_tourism_application/core/theme/app_colors.dart';
import 'package:smart_tourism_application/data/models/budgets_responce_model.dart';
import 'budget_planning_view.dart';
import 'budget_detail_view.dart';
import 'package:smart_tourism_application/presentation/widgets/main_bottom_nav_bar.dart';
import '../../controllers/budget_controller.dart';

class BudgetListView extends StatefulWidget {
  @override
  _BudgetListViewState createState() => _BudgetListViewState();
}

class _BudgetListViewState extends State<BudgetListView> {
  List<BudgetDetailItem> _budgets = [];

  @override
  void initState() {
    super.initState();
    _loadBudgets();
  }

  void _loadBudgets() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final budgetController = Provider.of<BudgetController>(context, listen: false);
      await budgetController.loadBudgets();
      if (!mounted) return;
      print("budgetsError ${budgetController.budgetsError}");
      if (budgetController.budgetsError != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error loading budgets: ${budgetController.budgetsError}'),
            backgroundColor: Colors.red,
          ),
        );
      } else {
        setState(() {
          _budgets = _convertBudgetsToDetailItems(budgetController.budgets);
        });
      }
    });
  }

  List<BudgetDetailItem> _convertBudgetsToDetailItems(List<Datum> budgets) {
    return budgets.map((budget) {
      // Convert subcategories to allocations map
      final allocations = <String, double>{};
      final totalAmount = double.tryParse(budget.amount) ?? 0.0;
      
      for (var subcategory in budget.subcategories) {
        final categoryName = _getCategoryNameFromType(subcategory.type);
        final allocatedAmount = totalAmount * (subcategory.percentage / 100);
        allocations[categoryName] = allocatedAmount;
      }

      // Create Budget entity
      final budgetEntity = Budget(
        id: budget.id.toString(),
        userId: budget.userId.toString(),
        totalAmount: totalAmount,
        allocations: allocations,
        startDate: budget.createdAt,
        endDate: budget.createdAt.add(Duration(days: budget.days)),
      );

      // Create destination string
      final cityName = _getCityNameString(budget.toCity.name);
      final countryName = _getCountryNameString(budget.toCity.country);
      final destination = '$cityName, $countryName';

      return BudgetDetailItem(
        budget: budgetEntity,
        title: budget.name,
        destination: destination,
        travelers: budget.teamsNumber,
        budgetData: budget, // Pass API data
      );
    }).toList();
  }

  String _getCategoryNameFromType(Type type) {
    switch (type) {
      case Type.HOTEL:
        return 'Accommodation';
      case Type.RESTAURANT:
        return 'Food';
      case Type.ACTIVITIES:
        return 'Activities';
      case Type.PLANE:
        return 'Transportation';
      case Type.OTHER:
        return 'Other';
    }
  }

  String _getCityNameString(Name name) {
    switch (name) {
      case Name.JEDDAH:
        return 'Jeddah';
      case Name.RIYADH:
        return 'Riyadh';
    }
  }

  String _getCountryNameString(Country country) {
    switch (country) {
      case Country.SAUDI_ARABIA:
        return 'Saudi Arabia';
    }
  }

  @override
  Widget build(BuildContext context) {
    final budgetController = Provider.of<BudgetController>(context);
    
    return Scaffold(
      appBar: AppBar(
        title: Text('My Budgets'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: budgetController.isBudgetsLoading
          ? Center(
              child: CircularProgressIndicator(
                color: AppColors.primary,
              ),
            )
          : _budgets.isEmpty
              ? _buildEmptyState()
              : ListView.builder(
              padding: EdgeInsets.all(16.0),
              itemCount: _budgets.length + 1, // +1 for the add button
              itemBuilder: (context, index) {
                if (index == _budgets.length) {
                  return _buildAddBudgetButton();
                }
                return _BudgetCard(
                  budgetItem: _budgets[index],
                  onDelete: () {
                    setState(() {
                      _budgets.removeAt(index);
                    });
                  },
                );
              },
            ),
      bottomNavigationBar: MainBottomNavBar(
        currentIndex: 2,
        onTap: (index) {
          switch (index) {
            case 0:
              Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
              break;
            case 1:
              Navigator.pushNamedAndRemoveUntil(context, '/hotels', (route) => false);
              break;
            case 2:
              // Already on budget page
              break;
            case 3:
              Navigator.pushNamedAndRemoveUntil(context, '/profile', (route) => false);
              break;
          }
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.account_balance_wallet_outlined,
            size: 80,
            color: Colors.grey[400],
          ),
          SizedBox(height: 20),
          Text(
            'No budgets yet',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.grey[600],
            ),
          ),
          SizedBox(height: 10),
          Text(
            'Create your first budget to start planning',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[500],
            ),
          ),
          SizedBox(height: 30),
          ElevatedButton(
            onPressed: () {
              _navigateToBudgetPlanning();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            child: Text(
              'Create Budget',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddBudgetButton() {
    return Container(
      margin: EdgeInsets.only(top: 16),
      child: ElevatedButton.icon(
        onPressed: () {
          _navigateToBudgetPlanning();
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        icon: Icon(Icons.add),
        label: Text(
          'Add New Budget',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  void _navigateToBudgetPlanning() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BudgetPlanningView(),
      ),
    );
  }
}

class _BudgetCard extends StatefulWidget {
  final BudgetDetailItem budgetItem;
  final VoidCallback onDelete;

  const _BudgetCard({
    required this.budgetItem,
    required this.onDelete,
  });

  @override
  __BudgetCardState createState() => __BudgetCardState();
}

class __BudgetCardState extends State<_BudgetCard> {
  bool _isEnabled = true;

  @override
  Widget build(BuildContext context) {
    final budget = widget.budgetItem.budget;
    final totalAmount = budget.totalAmount;
    final duration = budget.endDate.difference(budget.startDate).inDays;
    
    return Card(
      margin: EdgeInsets.only(bottom: 16),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        onTap: () {
          // Navigate to budget detail view
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => BudgetDetailView(
                budgetItem: widget.budgetItem,
              ),
            ),
          );
        },
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header row with title and toggle
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      widget.budgetItem.title,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Colors.grey[800],
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              
              SizedBox(height: 16),
              
              // Destination and travelers info
              Row(
                children: [
                  Icon(Icons.location_on, size: 20, color: AppColors.primary),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      widget.budgetItem.destination,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[700],
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              
              SizedBox(height: 8),
              
              Row(
                children: [
                  Icon(Icons.people, size: 20, color: AppColors.primary),
                  SizedBox(width: 8),
                  Text(
                    '${widget.budgetItem.travelers} Traveler${widget.budgetItem.travelers > 1 ? 's' : ''}',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[700],
                    ),
                  ),
                  SizedBox(width: 16),
                  Icon(Icons.timer, size: 20, color: AppColors.primary),
                  SizedBox(width: 8),
                  Text(
                    '$duration days',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[700],
                    ),
                  ),
                ],
              ),
              
              SizedBox(height: 16),
              
              // Date range
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.calendar_today, size: 16, color: AppColors.primary),
                    SizedBox(width: 6),
                    Text(
                      '${_formatDate(budget.startDate)} - ${_formatDate(budget.endDate)}',
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.primary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              
              SizedBox(height: 20),
              
              // Budget amount with divider
              Divider(height: 1, thickness: 1, color: Colors.grey[300]),
              
              SizedBox(height: 16),
              
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total Budget',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey[600],
                    ),
                  ),
                  Text(
                    '\$${totalAmount.toStringAsFixed(0)}',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
              
              SizedBox(height: 16),
              
              // Action buttons row
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    icon: Icon(Icons.delete, color: Colors.red),
                    onPressed: () async {
                      final budgetController = Provider.of<BudgetController>(
                        context,
                        listen: false,
                      );

                      final budgetId = widget.budgetItem.budgetData?.id;

                      if (budgetId != null) {
                        await budgetController.deleteBudget(budgetId);
                      }

                      if (!mounted) return;

                      widget.onDelete();

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Budget deleted successfully'),
                          backgroundColor: Colors.green,
                        ),
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.month}/${date.day}/${date.year}';
  }
}
