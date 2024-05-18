import 'package:collection/collection.dart';
import 'package:dodao/blockchain/task_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';

class StatisticsPage extends StatefulWidget {
  const StatisticsPage({Key? key}) : super(key: key);

  @override
  State<StatisticsPage> createState() => _StatisticsPageState();
}

class _StatisticsPageState extends State<StatisticsPage> {
  DateTime _startDate = DateTime.now().subtract(const Duration(days: 30));
  DateTime _endDate = DateTime.now();

  Map<String, Map<String, Map<String, int>>> dailyStats = {};
  Map<String, Map<String, Map<String, int>>> weeklyStats = {};
  Map<String, Map<String, Map<String, int>>> monthlyStats = {};
  Map<String, Map<String, int>> totalStats = {};

  @override
  void initState() {
    super.initState();
    // Initialize dailyStats, weeklyStats, and monthlyStats with data
  }

  void _selectDateRange(DateTimeRange? newDateRange) {
    if (newDateRange != null) {
      setState(() {
        _startDate = newDateRange.start;
        _endDate = newDateRange.end;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var tasksServices = context.watch<TasksServices>();

    totalStats = tasksServices.totalStats;
    dailyStats = tasksServices.dailyStats;
    weeklyStats = tasksServices.weeklyStats;
    monthlyStats = tasksServices.monthlyStats;
    // dailyStats = {
    //   '2023-05-18': {
    //     'statsTaskStateListCounts': {'new': 10, 'progress': 5, 'completed': 3},
    //     // Add more data as needed
    //   },
    //   // Add more dates as needed
    // };

    // weeklyStats = {
    //   '2023-05-15': {
    //     'statsTaskStateListCounts': {'new': 25, 'progress': 12, 'completed': 8},
    //     // Add more data as needed
    //   },
    //   // Add more weeks as needed
    // };

    // monthlyStats = {
    //   '2023-05-01': {
    //     'statsTaskStateListCounts': {'new': 50, 'progress': 30, 'completed': 20},
    //     // Add more data as needed
    //   },
    //   // Add more months as needed
    // };
    return Scaffold(
      appBar: AppBar(
        title: const Text('Statistics Dashboard'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Date Range Picker
              RangeDatePicker(
                startDate: _startDate,
                endDate: _endDate,
                onChanged: _selectDateRange,
              ),
              const SizedBox(height: 16.0),

              // Charts
              const Text(
                'Charts',
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8.0),
              StatisticsCharts(
                stats: totalStats,
              ),

              // Total Overview
              const Text(
                'Total Overview',
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8.0),
              TotalOverviewCards(totalStats: totalStats),
              const SizedBox(height: 16.0),

              // Charts
              const Text(
                'Charts',
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8.0),
              // StatisticsCharts(
              //   stats: dailyStats,
              // ),

              // Customer Statistics
              const Text(
                'Customer Statistics',
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8.0),
              CustomerStatisticsCards(
                dailyStats: dailyStats,
                weeklyStats: weeklyStats,
                monthlyStats: monthlyStats,
              ),
              const SizedBox(height: 16.0),
            ],
          ),
        ),
      ),
    );
  }
}

class RangeDatePicker extends StatefulWidget {
  final DateTime startDate;
  final DateTime endDate;
  final Function(DateTimeRange?) onChanged;

  const RangeDatePicker({
    Key? key,
    required this.startDate,
    required this.endDate,
    required this.onChanged,
  }) : super(key: key);

  @override
  State<RangeDatePicker> createState() => _RangeDatePickerState();
}

class _RangeDatePickerState extends State<RangeDatePicker> {
  DateTimeRange? _selectedDateRange;

  @override
  void initState() {
    super.initState();
    _selectedDateRange = DateTimeRange(
      start: widget.startDate,
      end: widget.endDate,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        ElevatedButton(
          onPressed: () async {
            final DateTimeRange? newDateRange = await showDateRangePicker(
              context: context,
              initialDateRange: _selectedDateRange,
              firstDate: DateTime(2000),
              lastDate: DateTime(2100),
            );
            if (newDateRange != null) {
              setState(() {
                _selectedDateRange = newDateRange;
              });
              widget.onChanged(newDateRange);
            }
          },
          child: const Text('Select Date Range'),
        ),
        Text(
          '${_selectedDateRange?.start.toString().split(' ')[0]} - ${_selectedDateRange?.end.toString().split(' ')[0]}',
        ),
      ],
    );
  }
}

class TotalOverviewCards extends StatefulWidget {
  final Map<String, Map<String, int>> totalStats;

  const TotalOverviewCards({
    Key? key,
    required this.totalStats,
  }) : super(key: key);

  @override
  _TotalOverviewCardsState createState() => _TotalOverviewCardsState();
}

class _TotalOverviewCardsState extends State<TotalOverviewCards> {
  final Map<String, List<Widget>> _expandedOtherCards = {};

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: widget.totalStats.entries.map((entry) {
        final groupTitle = entry.key;
        final groupValues = entry.value;
        final sortedGroupValues = groupValues.entries.toList()..sort((a, b) => b.value.compareTo(a.value));

        final threshold = sortedGroupValues.length * 0.25;
        final topGroupEntries = sortedGroupValues.take(threshold.ceil()).toList();
        final otherGroupEntries = sortedGroupValues.skip(threshold.ceil()).toList();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 16.0, top: 16.0),
              child: Text(
                groupTitle,
                style: const TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 8.0),
            StatisticsCharts(stats: groupValues),
            const SizedBox(height: 8.0),
            Wrap(
              spacing: 8.0,
              runSpacing: 8.0,
              children: [
                ...topGroupEntries.map((innerEntry) {
                  return _buildStatisticsCard(
                    title: innerEntry.key,
                    value: innerEntry.value.toString(),
                    color: Colors.blue,
                  );
                }),
                if (otherGroupEntries.isNotEmpty)
                  ExpansionTile(
                    tilePadding: EdgeInsets.zero,
                    title: _buildStatisticsCard(
                      title: 'Other',
                      value: otherGroupEntries
                          .fold(
                            0,
                            (sum, entry) => sum + entry.value,
                          )
                          .toString(),
                      color: Colors.grey,
                    ),
                    initiallyExpanded: _expandedOtherCards.containsKey(groupTitle),
                    onExpansionChanged: (isExpanded) {
                      setState(() {
                        if (isExpanded) {
                          _expandedOtherCards[groupTitle] = otherGroupEntries.map((innerEntry) {
                            return _buildStatisticsCard(
                              title: innerEntry.key,
                              value: innerEntry.value.toString(),
                              color: Colors.blue,
                            );
                          }).toList();
                        } else {
                          _expandedOtherCards.remove(groupTitle);
                        }
                      });
                    },
                    children: _expandedOtherCards[groupTitle] ?? [],
                  ),
              ],
            ),
          ],
        );
      }).toList(),
    );
  }

  Widget _buildStatisticsCard({
    required String title,
    required String value,
    required Color color,
  }) {
    return Card(
      color: color.withOpacity(0.5),
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: SizedBox(
          width: 80,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 10.0,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 2.0),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 12.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CustomerStatisticsCards extends StatelessWidget {
  final Map<String, Map<String, Map<String, int>>> dailyStats;
  final Map<String, Map<String, Map<String, int>>> weeklyStats;
  final Map<String, Map<String, Map<String, int>>> monthlyStats;

  const CustomerStatisticsCards({
    Key? key,
    required this.dailyStats,
    required this.weeklyStats,
    required this.monthlyStats,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildStatisticsCard(
              title: 'Tasks Posted',
              value: getTotalValue(dailyStats, 'statsTaskStateListCounts', 'new'),
              color: Colors.purple,
            ),
            _buildStatisticsCard(
              title: 'Tasks In Review',
              value: getTotalValue(dailyStats, 'statsTaskStateListCounts', 'review'),
              color: Colors.orange,
            ),
            _buildStatisticsCard(
              title: 'Tasks Completed',
              value: getTotalValue(dailyStats, 'statsTaskStateListCounts', 'completed'),
              color: Colors.green,
            ),
          ],
        ),
        const SizedBox(height: 16.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildStatisticsCard(
              title: 'Avg. Customer Rating',
              value: getAvgValue(dailyStats, 'statsCustomerRatingListCounts'),
              color: Colors.pink,
            ),
            _buildStatisticsCard(
              title: 'Unique Contract Owners',
              value: getUniqueCount(dailyStats, 'statsContractOwnerListCounts'),
              color: Colors.teal,
            ),
            _buildStatisticsCard(
              title: 'Unique Funders',
              value: getUniqueCount(dailyStats, 'statsFundersListCounts'),
              color: Colors.brown,
            ),
          ],
        ),
      ],
    );
  }

  String getTotalValue(
    Map<String, Map<String, Map<String, int>>> stats,
    String key,
    String value,
  ) {
    int total = 0;
    for (var entry in stats.entries) {
      if (entry.value[key]?.containsKey(value) ?? false) {
        if (entry.value[key]![value] is int) total += entry.value[key]![value]!;
      }
    }
    return total.toString();
  }

  String getAvgValue(
    Map<String, Map<String, Map<String, int>>> stats,
    String key,
  ) {
    int total = 0;
    int count = 0;
    for (var entry in stats.entries) {
      for (var ratingEntry in entry.value[key]!.entries) {
        if (ratingEntry.key is int) {
          total += (ratingEntry.key * ratingEntry.value) as int;
          count += ratingEntry.value;
        }
      }
    }
    return count > 0 ? (total / count).toStringAsFixed(2) : '0.00';
  }

  String getUniqueCount(
    Map<String, Map<String, Map<String, int>>> stats,
    String key,
  ) {
    Set<dynamic> uniqueValues = {};
    for (var entry in stats.entries) {
      for (var valueEntry in entry.value[key]!.entries) {
        if (valueEntry is int) uniqueValues.add(valueEntry.key);
      }
    }
    return uniqueValues.length.toString();
  }

  Widget _buildStatisticsCard({
    required String title,
    required String value,
    required Color color,
    TextStyle? valueStyle,
    TextStyle? titleStyle,
  }) {
    return Card(
      color: color.withOpacity(0.5),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: titleStyle ??
                  const TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8.0),
            Text(
              value,
              style: valueStyle ??
                  const TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}

class StatisticsCharts extends StatefulWidget {
  final Map<String, dynamic> stats;

  const StatisticsCharts({
    Key? key,
    required this.stats,
  }) : super(key: key);

  @override
  State<StatisticsCharts> createState() => _StatisticsChartsState();
}

class _StatisticsChartsState extends State<StatisticsCharts> {
  List<BarChartGroupData> getBarGroups(Map<String, dynamic> stats) {
    Map<String, double> flattenedStats = {};

    stats.forEach((key, value) {
      if (value is Map<String, int>) {
        value.forEach((innerKey, innerValue) {
          flattenedStats['$key - $innerKey'] = innerValue.toDouble();
        });
      } else if (value is int) {
        flattenedStats[key] = value.toDouble();
      }
    });

    // Sort the flattened stats in descending order
    final sortedStats = flattenedStats.entries.toList()..sort((a, b) => b.value.compareTo(a.value));

    // Calculate the 10% threshold
    final threshold = sortedStats.length * 0.25;

    // Split the sorted stats into top and bottom groups
    final topStats = sortedStats.take(sortedStats.length - threshold.ceil()).toList();
    final bottomStats = sortedStats.skip(sortedStats.length - threshold.ceil()).toList();

    // Combine the bottom stats into an "other" group
    final otherValue = bottomStats.fold<double>(0.0, (sum, entry) => sum + entry.value);
    topStats.add(MapEntry('Other', otherValue));

    return topStats.asMap().entries.map((entry) {
      return BarChartGroupData(
        x: entry.key,
        barRods: [
          BarChartRodData(
            toY: entry.value.value,
            width: 10.0, // Decreased bar width
            rodStackItems: [
              BarChartRodStackItem(
                0,
                entry.value.value,
                const Color(0xFF4CAF50),
              ),
            ],
          ),
        ],
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200.0,
      child: widget.stats.isEmpty
          ? const Center(child: Text('No data available'))
          : BarChart(
              BarChartData(
                barTouchData: BarTouchData(enabled: false),
                borderData: FlBorderData(show: false),
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  rightTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        final index = value.toInt();
                        if (index >= 0 && index < widget.stats.keys.length) {
                          final title = widget.stats.keys.elementAt(index);
                          return Padding(
                            padding: const EdgeInsets.only(top: 16.0, bottom: 4.0),
                            child: Text(
                              title,
                              style: const TextStyle(
                                fontSize: 12.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          );
                        } else {
                          return const SizedBox.shrink();
                        }
                      },
                    ),
                  ),
                ),
                barGroups: getBarGroups(widget.stats),
              ),
            ),
    );
  }
}
