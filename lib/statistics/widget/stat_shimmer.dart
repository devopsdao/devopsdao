import 'package:flutter/cupertino.dart';
import 'package:shimmer/shimmer.dart';

import '../../../blockchain/classes.dart';
import '../../../config/theme.dart';
import '../../widgets/tags/wrapped_chip.dart';

class StatisticsChipShimmer extends StatelessWidget {
  const StatisticsChipShimmer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
        baseColor: DodaoTheme.of(context).shimmerBaseColor,
        highlightColor: DodaoTheme.of(context).shimmerHighlightColor,
        child: Padding(
          padding: const EdgeInsets.only(top: 16.0, left: 4, right: 4, bottom: 16),
          child: LayoutBuilder(builder: (context, constraints) {
            List<TokenItem> tags = [
              TokenItem(collection: true, name: 'loading..', id: BigInt.from(0)),
              TokenItem(collection: true, name: 'nft loading', id: BigInt.from(0)),
              TokenItem(collection: true, name: 'loading', id: BigInt.from(0)),
            ];
            return Wrap(
                alignment: WrapAlignment.start,
                direction: Axis.horizontal,
                children: tags.map((e) {
                  return WrappedChip(
                    key: ValueKey(e),
                    item: MapEntry(
                        e.name,
                        NftCollection(
                          selected: false,
                          name: e.name,
                          bunch: {
                            BigInt.from(0):
                            TokenItem(name: e.name, nft: e.nft, inactive: e.inactive, balance: e.balance, collection: true)
                          },
                        )),
                    page: 'tasks',
                    selected: e.selected,
                    wrapperRole: WrapperRole.selectNew,
                  );
                }).toList()
            );
          }),
        )
    );
  }
}

