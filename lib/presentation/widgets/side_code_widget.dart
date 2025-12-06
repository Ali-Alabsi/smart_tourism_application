import 'package:flutter/material.dart';

/// Widget that adds small code snippets on both sides of the application
class SideCodeWidget extends StatelessWidget {
  final Widget child;
  final String leftCode;
  final String rightCode;

  const SideCodeWidget({
    super.key,
    required this.child,
    this.leftCode = '// LEFT',
    this.rightCode = '// RIGHT',
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Stack(
          children: [
            // Main content
            child,
            // Left side code
            Positioned(
              left: 0,
              top: constraints.maxHeight * 0.5 - 20,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 4, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.1),
                  border: Border(
                    right: BorderSide(
                      color: Colors.blue.withOpacity(0.3),
                      width: 2,
                    ),
                  ),
                ),
                child: RotatedBox(
                  quarterTurns: 1,
                  child: Text(
                    leftCode,
                    style: TextStyle(
                      fontSize: 10,
                      color: Colors.blue.withOpacity(0.7),
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1,
                    ),
                  ),
                ),
              ),
            ),
            // Right side code
            Positioned(
              right: 0,
              top: constraints.maxHeight * 0.5 - 20,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 4, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.1),
                  border: Border(
                    left: BorderSide(
                      color: Colors.blue.withOpacity(0.3),
                      width: 2,
                    ),
                  ),
                ),
                child: RotatedBox(
                  quarterTurns: 1,
                  child: Text(
                    rightCode,
                    style: TextStyle(
                      fontSize: 10,
                      color: Colors.blue.withOpacity(0.7),
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1,
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

