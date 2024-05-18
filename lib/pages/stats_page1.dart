import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;

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

              // Overall Statistics
              const Text(
                'Overall Statistics',
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8.0),
              OverallStatisticsCards(
                dailyStats: dailyStats,
                weeklyStats: weeklyStats,
                monthlyStats: monthlyStats,
              ),
              const SizedBox(height: 16.0),

              // Performer Statistics
              const Text(
                'Performer Statistics',
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8.0),
              PerformerStatisticsCards(
                dailyStats: dailyStats,
                weeklyStats: weeklyStats,
                monthlyStats: monthlyStats,
              ),
              const SizedBox(height: 16.0),

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
                dailyStats: dailyStats,
                weeklyStats: weeklyStats,
                monthlyStats: monthlyStats,
              ),
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

class OverallStatisticsCards extends StatelessWidget {
  final Map<String, Map<String, Map<String, int>>> dailyStats;
  final Map<String, Map<String, Map<String, int>>> weeklyStats;
  final Map<String, Map<String, Map<String, int>>> monthlyStats;

  const OverallStatisticsCards({
    Key? key,
    required this.dailyStats,
    required this.weeklyStats,
    required this.monthlyStats,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildStatisticsCard(
          title: 'Daily',
          value: dailyStats.length.toString(),
          color: Colors.blue,
        ),
        _buildStatisticsCard(
          title: 'Weekly',
          value: weeklyStats.length.toString(),
          color: Colors.green,
        ),
        _buildStatisticsCard(
          title: 'Monthly',
          value: monthlyStats.length.toString(),
          color: Colors.orange,
        ),
      ],
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
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8.0),
            Text(
              value,
              style: const TextStyle(
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

class PerformerStatisticsCards extends StatelessWidget {
  final Map<String, Map<String, Map<String, int>>> dailyStats;
  final Map<String, Map<String, Map<String, int>>> weeklyStats;
  final Map<String, Map<String, Map<String, int>>> monthlyStats;

  const PerformerStatisticsCards({
    Key? key,
    required this.dailyStats,
    required this.weeklyStats,
    required this.monthlyStats,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildStatisticsCard(
          title: 'Tasks Applied',
          value: getDailyValue(dailyStats, 'statsTaskStateListCounts', 'new'),
          color: Colors.red,
        ),
        _buildStatisticsCard(
          title: 'Tasks In Progress',
          value: getDailyValue(dailyStats, 'statsTaskStateListCounts', 'progress'),
          color: Colors.yellow,
        ),
        _buildStatisticsCard(
          title: 'Tasks Completed',
          value: getDailyValue(dailyStats, 'statsTaskStateListCounts', 'completed'),
          color: Colors.green,
        ),
      ],
    );
  }

  String getDailyValue(
    Map<String, Map<String, Map<String, int>>> stats,
    String key,
    String value,
  ) {
    int total = 0;
    for (var entry in stats.entries) {
      if (entry.value[key]?.containsKey(value) ?? false) {
        total += entry.value[key]![value]!;
      }
    }
    return total.toString();
  }

  Widget _buildStatisticsCard({
    required String title,
    required String value,
    required Color color,
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
              style: const TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8.0),
            Text(
              value,
              style: const TextStyle(
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
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildStatisticsCard(
          title: 'Tasks Posted',
          value: getDailyValue(dailyStats, 'statsTaskStateListCounts', 'new'),
          color: Colors.purple,
        ),
        _buildStatisticsCard(
          title: 'Tasks In Review',
          value: getDailyValue(dailyStats, 'statsTaskStateListCounts', 'review'),
          color: Colors.orange,
        ),
        _buildStatisticsCard(
          title: 'Tasks Completed',
          value: getDailyValue(dailyStats, 'statsTaskStateListCounts', 'completed'),
          color: Colors.green,
        ),
      ],
    );
  }

  String getDailyValue(
    Map<String, Map<String, Map<String, int>>> stats,
    String key,
    String value,
  ) {
    int total = 0;
    for (var entry in stats.entries) {
      if (entry.value[key]?.containsKey(value) ?? false) {
        total += entry.value[key]![value]!;
      }
    }
    return total.toString();
  }

  Widget _buildStatisticsCard({
    required String title,
    required String value,
    required Color color,
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
              style: const TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8.0),
            Text(
              value,
              style: const TextStyle(
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

class StatisticsCharts extends StatelessWidget {
  final Map<String, Map<String, Map<String, int>>> dailyStats;
  final Map<String, Map<String, Map<String, int>>> weeklyStats;
  final Map<String, Map<String, Map<String, int>>> monthlyStats;

  const StatisticsCharts({
    Key? key,
    required this.dailyStats,
    required this.weeklyStats,
    required this.monthlyStats,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildChartSwitcher(),
        const SizedBox(height: 16.0),
        _buildChart(),
      ],
    );
  }

  Widget _buildChartSwitcher() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(
          onPressed: () {
            // Handle daily chart
          },
          child: const Text('Daily'),
        ),
        const SizedBox(width: 16.0),
        ElevatedButton(
          onPressed: () {
            // Handle weekly chart
          },
          child: const Text('Weekly'),
        ),
        const SizedBox(width: 16.0),
        ElevatedButton(
          onPressed: () {
            // Handle monthly chart
          },
          child: const Text('Monthly'),
        ),
      ],
    );
  }

  Widget _buildChart() {
    // Build chart based on selected data
    return SizedBox(
      height: 400.0,
      child: charts.PieChart(
          // Provide data and customize chart
          ),
    );
  }
}
