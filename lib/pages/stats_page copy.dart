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
