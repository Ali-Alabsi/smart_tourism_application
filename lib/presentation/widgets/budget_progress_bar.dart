import 'package:flutter/material.dart';

class BudgetProgressBar extends StatelessWidget {
  final double totalBudget;
  final double spentAmount;
  final Map<String, double> allocations;

  const BudgetProgressBar({
    required this.totalBudget,
    required this.spentAmount,
    required this.allocations,
  });

  @override
  Widget build(BuildContext context) {
    double remaining = totalBudget - spentAmount;
    double progress = totalBudget > 0 ? spentAmount / totalBudget : 0;

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Budget Progress',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '${(progress * 100).toStringAsFixed(1)}%',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: progress > 0.8 ? Colors.red : Colors.green,
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            LinearProgressIndicator(
              value: progress.clamp(0.0, 1.0),
              backgroundColor: Colors.grey[300],
              valueColor: AlwaysStoppedAnimation<Color>(
                progress > 0.8 ? Colors.red : Colors.green,
              ),
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Spent',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                    Text(
                      '\$$spentAmount',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'Remaining',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                    Text(
                      '\$$remaining',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: remaining < 0 ? Colors.red : Colors.black,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 16),
            Text(
              'Allocations',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            ...allocations.entries.map((entry) {
              double percentage = totalBudget > 0
                  ? (entry.value / totalBudget) * 100
                  : 0;

              return Padding(
                padding: EdgeInsets.symmetric(vertical: 4.0),
                child: Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: Text(entry.key),
                    ),
                    Expanded(
                      flex: 2,
                      child: Text('${percentage.toStringAsFixed(1)}%'),
                    ),
                    Expanded(
                      flex: 2,
                      child: Text('\$${entry.value.toStringAsFixed(0)}'),
                    ),
                  ],
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }
}