import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

import '../blockchain/interface.dart';
import '../blockchain/classes.dart';
import '../config/theme.dart';
import '../widgets/tags/wrapped_chip.dart';


class ShimmeredTaskPages extends StatefulWidget {
  final Task task;

  const ShimmeredTaskPages({
    Key? key,
    required this.task,
  }) : super(key: key);

  @override
  _ShimmeredTaskPagesState createState() => _ShimmeredTaskPagesState();
}

class _ShimmeredTaskPagesState extends State<ShimmeredTaskPages> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (ctx, dialogConstraints) {
      double innerPaddingWidth = dialogConstraints.maxWidth - 50;
      return Column(
        children: [
          const SizedBox(height: 7),
          Padding(
            padding: const EdgeInsets.only(bottom: 14),
            child: Material(
              elevation: DodaoTheme.of(context).elevation,
              borderRadius: DodaoTheme.of(context).borderRadius,
              child: Shimmer.fromColors(
                  baseColor: DodaoTheme.of(context).shimmerBaseColor,
                  highlightColor: DodaoTheme.of(context).shimmerHighlightColor,
                  child: Container(
                    // height: 82,
                    width: innerPaddingWidth,
                    decoration: BoxDecoration(
                      borderRadius: DodaoTheme.of(context).borderRadius,
                      border: DodaoTheme.of(context).borderGradient,
                    ),
                    child: Container(
                      padding: const EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 6,
                            child: Container(
                                padding: const EdgeInsets.all(6.0),
                                child: const Text('▇▇▇▇ ▇▇▇▇▇')
                            ),
                          ),
                            Container(
                              margin:const EdgeInsets.only(top: 6.0, bottom: 6.0),
                              width: 36,
                              height: 36,
                              decoration: BoxDecoration(
                                gradient: DodaoTheme.of(context).smallButtonGradient,
                                borderRadius: DodaoTheme.of(context).borderRadiusSmallIcon,
                              ),
                              child: const Icon(Icons.chat_outlined, size: 18, color: Colors.white),
                            ),
                        ],
                      ),
                    ),
                  )
              ),
            )




          ),
          // ************ Show prices and topup part ******** //
          Padding(
            padding: const EdgeInsets.only(bottom: 14),
            child: Material(
              elevation: DodaoTheme.of(context).elevation,
              borderRadius: DodaoTheme.of(context).borderRadius,
              child: Shimmer.fromColors(
                  baseColor: DodaoTheme.of(context).shimmerBaseColor,
                  highlightColor: DodaoTheme.of(context).shimmerHighlightColor,
                  child: Container(
                    // height: 90,
                    width: innerPaddingWidth,
                    decoration: BoxDecoration(
                      borderRadius: DodaoTheme.of(context).borderRadius,
                      border: DodaoTheme.of(context).borderGradient,
                    ),
                    child: Container(
                      padding: const EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
                      child: Container(
                          padding: const EdgeInsets.all(6.0),
                          child: const Text('▇▇▇▇ ▇▇▇▇▇▇ ▇▇▇▇▇▇▇ \n▇▇▇▇ ▇▇▇▇▇ ▇▇▇▇')
                      ),
                    ),
                  )
              ),
            ),
          ),

          // ********* Text Input ************ //
          // Padding(
          //   padding: const EdgeInsets.only(bottom: 14),
          //   child: Material(
          //     elevation: DodaoTheme.of(context).elevation,
          //     borderRadius: DodaoTheme.of(context).borderRadius,
          //     child: Shimmer.fromColors(
          //         baseColor: DodaoTheme.of(context).shimmerBaseColor,
          //         highlightColor: DodaoTheme.of(context).shimmerHighlightColor,
          //         child: Container(
          //           padding: const EdgeInsets.only(top: 14),
          //           height: 70,
          //           width: innerPaddingWidth,
          //           // color: Colors.grey[350],
          //           decoration: BoxDecoration(
          //             borderRadius: DodaoTheme.of(context).borderRadius,
          //             border: DodaoTheme.of(context).borderGradient,
          //           ),
          //         )
          //     ),
          //   ),
          // ),
          Padding(
            padding: const EdgeInsets.only(bottom: 14),
            child: Material(
              elevation: DodaoTheme.of(context).elevation,
              borderRadius: DodaoTheme.of(context).borderRadius,
              child: Shimmer.fromColors(

                  baseColor: DodaoTheme.of(context).shimmerBaseColor,
                  highlightColor: DodaoTheme.of(context).shimmerHighlightColor,
                  child: Container(
                    padding: const EdgeInsets.all(14.0),
                    width: innerPaddingWidth,
                    decoration: BoxDecoration(
                      borderRadius: DodaoTheme.of(context).borderRadius,
                      border: DodaoTheme.of(context).borderGradient,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: RichText(
                              text: TextSpan(style: Theme.of(context).textTheme.bodySmall, children: const <TextSpan>[
                                TextSpan(text:
                                               '▇▇▇▇ ▇▇▇ ▇▇▇ ▇▇▇▇▇▇▇▇:'),
                              ])),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: LayoutBuilder(builder: (context, constraints) {
                            List<TokenItem> tags = [TokenItem(collection: true, name: 'empty', id: BigInt.from(0))];
                            if (tags.isNotEmpty) {
                              return SizedBox(
                                // width: width,
                                child: Wrap(
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
                                    }).toList()),
                              );
                            } else {
                              return Row(
                                children: <Widget>[
                                  RichText(
                                      text: TextSpan(style: Theme.of(context).textTheme.bodySmall, children: const <TextSpan>[
                                        TextSpan(
                                            text: 'Nothing here',
                                            style: TextStyle(
                                              height: 1,
                                            )),
                                      ])),
                                ],
                              );
                            }
                          }),
                        ),
                      ],
                    ),
                  )
              ),
            ),
          )
        ],
      );
    });
  }
}
