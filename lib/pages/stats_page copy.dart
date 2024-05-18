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
    List<MapEntry<String, int>> sortedEntries = [];

    for (var entry in stats.entries) {
      if (entry.value[key]?.containsKey(value) ?? false) {
        if (entry.value[key]![value] is int) {
          sortedEntries.add(MapEntry(entry.key, entry.value[key]![value]!));
        }
      }
    }

    sortedEntries.sort((a, b) => b.value.compareTo(a.value));

    int total = 0;
    for (var entry in sortedEntries) {
      total += entry.value;
    }

    return total.toString();
  }

  String getAvgValue(
    Map<String, Map<String, Map<String, int>>> stats,
    String key,
  ) {
    List<MapEntry<int, int>> sortedEntries = [];

    for (var entry in stats.entries) {
      for (var ratingEntry in entry.value[key]!.entries) {
        if (ratingEntry.key is int) {
          sortedEntries.add(MapEntry(ratingEntry.key, ratingEntry.value));
        }
      }
    }

    sortedEntries.sort((a, b) => b.value.compareTo(a.value));

    int total = 0;
    int count = 0;
    for (var entry in sortedEntries) {
      total += (entry.key * entry.value);
      count += entry.value;
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

    List<MapEntry<dynamic, int>> sortedEntries = uniqueValues.entries.map((entry) {
      int count = 0;
      for (var stat in stats.values) {
        if (stat[key]?.containsKey(entry.key) ?? false) {
          count += stat[key]![entry.key]!;
        }
      }
      return MapEntry(entry.key, count);
    }).toList();

    sortedEntries.sort((a, b) => b.value.compareTo(a.value));

    return sortedEntries.isNotEmpty ? sortedEntries.first.value.toString() : '0';
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
