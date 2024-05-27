
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import '../../../../blockchain/classes.dart';
import '../../../widgets/tags/wrapped_chip.dart';
import '../../model_view/pending_model_view.dart';
import '../stat_shimmer.dart';

class InYourWalletTab extends StatelessWidget {
  const InYourWalletTab({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final listenTags = context.select((TokenPendingModel vm) => vm.state.tags);

    return Container(
        padding: const EdgeInsets.only(top: 16.0, left: 4, right: 4, bottom: 16),
        height: 100,
        alignment: Alignment.topLeft,
        child: listenTags.isNotEmpty ? SingleChildScrollView(
          child: Wrap(
            alignment: WrapAlignment.start,
            direction: Axis.horizontal,
            children: listenTags.map((e) {
              return HomeWrappedChip(
                key: ValueKey(e),
                item: MapEntry(
                    e.name,
                    NftCollection(
                      selected: false,
                      name: e.name,
                      bunch: {
                        BigInt.from(e.balance):
                        TokenItem(name: e.name, nft: e.nft, inactive: e.inactive, balance: e.balance, collection: true, type: 'myNft')
                      },
                    )),
                nft: e.nft,
                balance: e.balance,
                completed: e.selected,
                type: e.type!,
              );
            }).toList(),
          ),
        )
            : const StatisticsChipShimmer()
    );
  }
}
