import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../blockchain/classes.dart';
import '../blockchain/task_services.dart';
import '../config/theme.dart';
import '../widgets/tags/search_services.dart';

class NftItem extends StatefulWidget {
  final TokenItem item;
  final double frameHeight;
  final String page;

  const NftItem({
    Key? key,
    required this.item,
    required this.frameHeight,
    required this.page
  }) : super(key: key);

  @override
  State<NftItem> createState() => _NftItemState();
}

class _NftItemState extends State<NftItem> {
  final EdgeInsets padding = const EdgeInsets.all(10.0);

  late List<dynamic> totalSupply = [BigInt.from(0)];

  getTotalSupply() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      TasksServices tasksServices = Provider.of<TasksServices>(context, listen: false);
      var getTS = await tasksServices.totalSupplyOfBatchName([widget.item.name]);
      setState(() {
        totalSupply = getTS;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    // final bool selected = widget.item.selected;
    // TasksServices tasksServices = Provider.of<TasksServices>(context, listen: false);
    if (widget.item.name != 'empty') {
      getTotalSupply();
    }
    return InkWell(
      child: Card(
          elevation: 4,
          color: Colors.grey[700],
          shape: RoundedRectangleBorder(
            borderRadius: DodaoTheme.of(context).borderRadius,
          ),
          margin: const EdgeInsets.only(left: 4, right: 4, bottom: 8.0),
          child: Padding(
            padding: padding,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                LayoutBuilder(builder: (context, constraints) {
                  final double maxWidth = constraints.maxWidth - 150;
                  return Row(
                    children: [
                      Container(
                        alignment: Alignment.topLeft,
                        padding: padding,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(15.0),
                          child: Image.asset(
                            'assets/images/logo.png',
                            height: widget.frameHeight - 192,
                            filterQuality: FilterQuality.medium,
                            isAntiAlias: true,
                          ),
                        ),
                      ),
                      Container(
                          width: maxWidth,
                          alignment: Alignment.topLeft,
                          padding: padding,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              RichText(
                                  textAlign: TextAlign.start,
                                  softWrap: false,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  text: TextSpan(style: DodaoTheme.of(context).bodyText1.override(
                                    fontFamily: 'Inter',
                                    color: Colors.white,
                                    fontWeight: FontWeight.w400,
                                  ),
                                      children: [TextSpan(text: 'NFT: ${widget.item.name}'),])),
                              RichText(
                                  text: TextSpan(style: DodaoTheme.of(context).bodyText1.override(
                                      fontFamily: 'Inter',
                                      color: Colors.white,
                                      fontWeight: FontWeight.w400
                                  ),
                                  children: <TextSpan>[
                                    TextSpan(text: 'Features: ${widget.item.feature}\n'),
                                    TextSpan(text: 'Rarity: ${widget.item.nft}\n'),
                                    TextSpan(text: 'Issued by: ${widget.item.nft}\n'),
                                    const TextSpan(text: 'You own: 1'),
                                  ])),
                              Text('Total supply: ${totalSupply.first}',
                                style: DodaoTheme.of(context).bodyText1.override(
                                    fontFamily: 'Inter',
                                    color: Colors.white,
                                    fontWeight: FontWeight.w400
                                ),),
                              GestureDetector(
                                onTap: () async {
                                  Clipboard.setData(ClipboardData(text: '${widget.item.id}')).then((_) {
                                    Flushbar(
                                        icon: Icon(
                                          Icons.copy,
                                          size: 20,
                                          color: DodaoTheme.of(context).flushTextColor,
                                        ),
                                        message: '${widget.item.id} copied to your clipboard!',
                                        duration: const Duration(seconds: 2),
                                        backgroundColor: DodaoTheme.of(context).flushForCopyBackgroundColor,
                                        shouldIconPulse: false)
                                        .show(context);
                                  });
                                },
                                child: Container(
                                  width: maxWidth,
                                  child: RichText(
                                      textAlign: TextAlign.start,
                                      softWrap: false,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      text: TextSpan(style: DodaoTheme.of(context).bodyText1.override(
                                        fontFamily: 'Inter',
                                        color: Colors.white,
                                        fontWeight: FontWeight.w400,
                                      ),
                                          children: [
                                            const TextSpan(text: 'Id: '),
                                            const WidgetSpan(
                                                child: Icon(
                                                  Icons.copy,
                                                  size: 16,
                                                  color: Colors.white,
                                                )),
                                            TextSpan(text: '${widget.item.id}'),
                                          ])),
                                ),
                              ),
                              GestureDetector(
                                onTap: () async {
                                  Clipboard.setData(ClipboardData(text: '${widget.item.name}')).then((_) {
                                    Flushbar(
                                        icon: Icon(
                                          Icons.copy,
                                          size: 20,
                                          color: DodaoTheme.of(context).flushTextColor,
                                        ),
                                        message: '${widget.item.name} copied to your clipboard!',
                                        duration: const Duration(seconds: 2),
                                        backgroundColor: DodaoTheme.of(context).flushForCopyBackgroundColor,
                                        shouldIconPulse: false)
                                        .show(context);
                                  });
                                },
                                child: Container(
                                  child: RichText(
                                      textAlign: TextAlign.start,
                                      softWrap: false,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    text: TextSpan(style: DodaoTheme.of(context).bodyText1.override(
                                      fontFamily: 'Inter',
                                      color: Colors.white,
                                      fontWeight: FontWeight.w400
                                    ),
                                      children: [
                                        const TextSpan(text: 'Metadata url: '),
                                        const WidgetSpan(
                                          child: Icon(
                                            Icons.copy,
                                            size: 16,
                                            color: Colors.white,
                                          )),
                                        TextSpan(text: '${widget.item.name}'),
                                      ])),
                                ),
                              ),
                            ],
                          )
                      ),

                    ],
                  );
                }),
                if (widget.page == 'selection')
                NftCheckBox(item: widget.item),
              ],
            ),
          )
      ),
    );
  }
}


class NftCheckBox extends StatefulWidget {
  final TokenItem item;
  const NftCheckBox({Key? key, required this.item}) : super(key: key);

  @override
  _NftCheckBox createState() => _NftCheckBox();
}

class _NftCheckBox extends State<NftCheckBox> {
  @override
  Widget build(BuildContext context) {
    var searchServices = context.watch<SearchServices>();
    Color getColor(Set<MaterialState> states) {
      const Set<MaterialState> interactiveStates = <MaterialState>{
        MaterialState.pressed,
        MaterialState.hovered,
        MaterialState.focused,
      };
      if (states.any(interactiveStates.contains)) {
        return Colors.blue;
      }
      return Colors.deepOrangeAccent;
    }

    return Row(
      children: [
        Checkbox(
          checkColor: Colors.white,
          fillColor: MaterialStateProperty.resolveWith(getColor),
          value: widget.item.selected,
          onChanged: (bool? value) {
            setState(() {
              searchServices.nftSelection(unselectAll: false, nftName: widget.item.name, nftKey: widget.item.id!, unselectAllInBunch: false);
            });
          },
        ),
        RichText(
          text: TextSpan(style: DodaoTheme.of(context).bodyText1.override(
              fontFamily: 'Inter',
              color: Colors.white,
              fontWeight: FontWeight.w400
          ),
          children: const [
            TextSpan(text: 'Select NFT'),
          ])),
      ],
    );
  }
}

