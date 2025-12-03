import 'package:flutter/material.dart';
import 'budget_planning_view.dart';
import 'budget_list_view.dart';
import '../../../core/theme/app_colors.dart';

class BudgetView extends StatefulWidget {
  @override
  _BudgetViewState createState() => _BudgetViewState();
}

class _BudgetViewState extends State<BudgetView> {
  final _budgetController = TextEditingController();
  Map<String, double> _allocations = {
    'Accommodation': 0.0,
    'Transportation': 0.0,
    'Food': 0.0,
    'Activities': 0.0,
  };

  @override
  Widget build(BuildContext context) {
    double totalBudget = double.tryParse(_budgetController.text) ?? 0.0;

    return Scaffold(
      appBar: AppBar(
        title: Text('Budget Planner'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Set Your Travel Budget',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _budgetController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Total Budget',
                prefixText: '\$',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              onChanged: (value) {
                setState(() {});
              },
            ),
            SizedBox(height: 24),
            Text(
              'Budget Allocation',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            ..._allocations.keys.map((category) {
              return _BudgetAllocationItem(
                category: category,
                totalBudget: totalBudget,
                allocation: _allocations[category] ?? 0.0,
                onChanged: (value) {
                  setState(() {
                    _allocations[category] = value;
                  });
                },
              );
            }).toList(),
            SizedBox(height: 24),
            Text(
              'Budget Management',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            Card(
              child: ListTile(
                title: Text('View All Budgets'),
                subtitle: Text('See your budget history and details'),
                trailing: Icon(Icons.arrow_forward_ios),
                onTap: () {
                  Navigator.pushNamed(context, '/budget-list');
                },
              ),
            ),
            SizedBox(height: 16),
            Card(
              child: ListTile(
                title: Text('AI-Powered Budget Planning'),
                subtitle: Text('Get personalized recommendations based on your trip details'),
                trailing: Icon(Icons.arrow_forward_ios),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BudgetPlanningView(),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 24),
            Text(
              'Summary',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            Container(
              padding: EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Column(
                children: [
                  _SummaryRow(
                    label: 'Total Budget',
                    value: totalBudget,
                  ),
                  Divider(),
                  _SummaryRow(
                    label: 'Allocated',
                    value: _allocations.values.reduce((a, b) => a + b),
                  ),
                  Divider(),
                  _SummaryRow(
                    label: 'Remaining',
                    value: totalBudget -
                        _allocations.values.reduce((a, b) => a + b),
                  ),
                ],
              ),
            ),
            SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // Handle save budget
                },
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.all(16.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                child: Text(
                  'Save Budget',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _budgetController.dispose();
    super.dispose();
  }
}

class _BudgetAllocationItem extends StatelessWidget {
  final String category;
  final double totalBudget;
  final double allocation;
  final Function(double) onChanged;

  const _BudgetAllocationItem({
    required this.category,
    required this.totalBudget,
    required this.allocation,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    double percentage = totalBudget > 0 ? (allocation / totalBudget) * 100 : 0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(category),
            Text('${percentage.toStringAsFixed(1)}%'),
          ],
        ),
        Slider(
          value: allocation.clamp(0.0, totalBudget),
          min: 0.0,
          max: totalBudget,
          divisions: 100,
          label: '\$${allocation.toStringAsFixed(0)}',
          onChanged: (value) {
            onChanged(value);
          },
        ),
        Text('\$${allocation.toStringAsFixed(0)}'),
        SizedBox(height: 16),
      ],
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final String label;
  final double value;

  const _SummaryRow({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text('\$${value.toStringAsFixed(2)}'),
        ],
      ),
    );
  }
}