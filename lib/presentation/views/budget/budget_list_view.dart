import 'package:flutter/material.dart';
import 'package:smart_tourism_application/core/entities/budget.dart';
import 'package:smart_tourism_application/core/theme/app_colors.dart';
import 'budget_planning_view.dart';
import 'budget_detail_view.dart';

class BudgetListView extends StatefulWidget {
  @override
  _BudgetListViewState createState() => _BudgetListViewState();
}

class _BudgetListViewState extends State<BudgetListView> {
  // Mock data for budgets
  List<BudgetDetailItem> _budgets = [];

  @override
  void initState() {
    super.initState();
    _loadMockBudgets();
  }

  void _loadMockBudgets() {
    setState(() {
      _budgets = [
        BudgetDetailItem(
          budget: Budget(
            id: '1',
            userId: 'user1',
            totalAmount: 2500.0,
            allocations: {
              'Accommodation': 1000.0,
              'Transportation': 300.0,
              'Food': 500.0,
              'Activities': 400.0,
              'Shopping': 300.0,
            },
            startDate: DateTime.now().subtract(Duration(days: 5)),
            endDate: DateTime.now().add(Duration(days: 10)),
          ),
          title: 'Summer Vacation',
          destination: 'Riyadh, Saudi Arabia',
          travelers: 2,
        ),
        BudgetDetailItem(
          budget: Budget(
            id: '2',
            userId: 'user1',
            totalAmount: 1800.0,
            allocations: {
              'Accommodation': 800.0,
              'Transportation': 250.0,
              'Food': 400.0,
              'Activities': 350.0,
            },
            startDate: DateTime.now().add(Duration(days: 15)),
            endDate: DateTime.now().add(Duration(days: 22)),
          ),
          title: 'Weekend Getaway',
          destination: 'Jeddah, Saudi Arabia',
          travelers: 1,
        ),
        BudgetDetailItem(
          budget: Budget(
            id: '3',
            userId: 'user1',
            totalAmount: 3200.0,
            allocations: {
              'Accommodation': 1200.0,
              'Transportation': 400.0,
              'Food': 600.0,
              'Activities': 500.0,
              'Shopping': 500.0,
            },
            startDate: DateTime.now().add(Duration(days: 30)),
            endDate: DateTime.now().add(Duration(days: 45)),
          ),
          title: 'Family Trip',
          destination: 'Medina & Makkah',
          travelers: 4,
        ),
      ];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Budgets'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: _budgets.isEmpty
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
                  Switch(
                    value: _isEnabled,
                    onChanged: (value) {
                      setState(() {
                        _isEnabled = value;
                      });
                    },
                    activeColor: AppColors.primary,
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
                    onPressed: widget.onDelete,
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
