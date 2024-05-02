import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:dodao/widgets/tags/search_services.dart';
import 'package:flutter/material.dart';
import '../../blockchain/interface.dart';
import '../../blockchain/task_services.dart';
import '../../config/theme.dart';
import '../../nft_manager/collection_services.dart';
import '../../nft_manager/nft_item.dart';
import '../../nft_manager/nft_card.dart';

class BottomItemInfo extends StatefulWidget {
  const BottomItemInfo({
    super.key,
  });

  @override
  State<BottomItemInfo> createState() => _BottomItemInfoState();
}

class _BottomItemInfoState extends State<BottomItemInfo> {
  final PageController pageController = PageController(initialPage: 0);
  final Curve splitCurve = Curves.easeInOutQuart;
  final Duration splitDuration = const Duration(milliseconds: 600);

  @override
  Widget build(BuildContext context) {
    SearchServices searchServices = Provider.of<SearchServices>(context, listen: false);
    TasksServices tasksServices = Provider.of<TasksServices>(context, listen: false);
    InterfaceServices interfaceServices = Provider.of<InterfaceServices>(context, listen: false);

    return Consumer<CollectionServices>(builder: (context, model, child) {
      late double secondPartHeight = 0.0;
      late bool splitScreen = false;
      final int nftCount = model.treasuryNftsInfoSelected.bunch.length;
      final String collectionName = model.treasuryNftsInfoSelected.bunch.entries.first.value.name;
      if (model.treasuryNftsInfoSelected.bunch.entries.first.value.name != 'empty') {
        splitScreen = true;
      }
      secondPartHeight = 300;

      return AnimatedContainer(
        duration: splitDuration,
        height: splitScreen ? secondPartHeight : 0.0,
        color: DodaoTheme.of(context).nftInfoBackgroundColor,
        curve: splitCurve,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 10.0, bottom: 10, left: 8, right: 8),
                child: Row(
                  children: [
                    Row(
                      children: [
                        InkResponse(
                          radius: 35,
                          containedInkWell: false,
                          onTap: () {
                            pageController.animateToPage(pageController.page!.toInt() - 1,
                                duration: const Duration(milliseconds: 500), curve: Curves.ease);
                          },
                          child: Icon(
                            Icons.arrow_back_ios_new,
                            size: 24,
                            color: DodaoTheme.of(context).secondaryText,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 5.0, right: 5.0),
                          child: Consumer<InterfaceServices>(builder: (context, model, child) {
                            // Reset count:
                            if (model.treasuryPageCount > nftCount) {
                              model.treasuryPageCount = 1;
                            }
                            return Text(
                              '${model.treasuryPageCount} of ${nftCount.toString()}',
                              style: Theme.of(context).textTheme.bodyMedium?.apply(color: DodaoTheme.of(context).primaryText),
                            );
                          }),
                        ),
                        InkResponse(
                          radius: 35,
                          containedInkWell: false,
                          onTap: () {
                            pageController.animateToPage(pageController.page!.toInt() + 1,
                                duration: const Duration(milliseconds: 500), curve: Curves.ease);
                          },
                          child: Icon(
                            Icons.arrow_forward_ios,
                            size: 24,
                            color: DodaoTheme.of(context).secondaryText,
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    Container(
                      constraints: const BoxConstraints(
                        maxWidth: 220,
                      ),
                      padding: const EdgeInsets.only(left: 5.0, right: 5.0),
                      child: Text(
                        collectionName,
                        style: Theme.of(context).textTheme.bodyMedium,
                        softWrap: false,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ),
                    const Spacer(),
                    InkResponse(
                      radius: 35,
                      containedInkWell: false,
                      onTap: () {
                        model.clearSelectedInManager();
                      },
                      child: Icon(
                        Icons.arrow_downward,
                        size: 24,
                        color: DodaoTheme.of(context).secondaryText,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: secondPartHeight - 60,
                child: Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: PageView.builder(
                    onPageChanged: (number) {
                      interfaceServices.treasuryPageCountUpdate(number + 1);
                    },
                    itemCount: model.treasuryNftsInfoSelected.bunch.length,
                    controller: pageController,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (BuildContext context, int index) {
                      late Widget nftItemWidget;
                      if (model.treasuryNftsInfoSelected.bunch.values.toList()[index].nft) {
                        nftItemWidget = NftItem(
                          item: model.treasuryNftsInfoSelected.bunch.values.toList()[index],
                          frameHeight: secondPartHeight,
                          page: 'selection',
                        );
                      } else {
                        nftItemWidget = NftMint(
                          item: model.treasuryNftsInfoSelected.bunch.values.toList()[index],
                          frameHeight: secondPartHeight,
                        );
                      }
                      return nftItemWidget;
                    },
                  ),
                ),
              )
            ],
          ),
        ),
      );
    });
  }
}
