import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';

import '../tasks_statistics_expanded.dart';


class GotoStatistics extends StatelessWidget {
  final bool extended;

  const GotoStatistics({Key? key, required this.extended}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TextButton(child: Text('Go to Statistics page'),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => StatisticsExpandedMain()),
                    );
                  },
                  style: TextButton.styleFrom(
                      textStyle: Theme.of(context).textTheme.bodyMedium)
              ),
            ],
          ),
        );
      },
    );
  }
}