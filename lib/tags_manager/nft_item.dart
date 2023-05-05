import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../blockchain/classes.dart';
import '../config/theme.dart';
import '../widgets/tags/search_services.dart';

class NftItem extends StatelessWidget {
  final TokenItem item;
  final double frameHeight;
  final String page;

  const NftItem({
    Key? key,
    required this.item,
    required this.frameHeight,
    required this.page
  }) : super(key: key);

  final EdgeInsets padding = const EdgeInsets.all(10.0);



  @override
  Widget build(BuildContext context) {
    final bool selected = item.selected;
    return InkWell(
      child: Card(
          elevation: 2,
          color: Colors.grey[700],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          child: Padding(
            padding: padding,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                LayoutBuilder(builder: (context, constraints) {
                  final double maxWidth = constraints.maxWidth - 170;
                  return Row(
                    children: [
                      Container(
                        alignment: Alignment.topLeft,
                        padding: padding,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(15.0),
                          child: Image.asset(
                            'assets/images/logo.png',
                            height: frameHeight - 150,
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
                                  overflow: TextOverflow.fade,
                                  text: TextSpan(style: DodaoTheme.of(context).bodyText1.override(
                                    fontFamily: 'Inter',
                                    color: Colors.white,
                                    fontWeight: FontWeight.w400,
                                  ),
                                      children: [TextSpan(text: 'NFT: ${item.name}'),])),
                              RichText(
                                  text: TextSpan(style: DodaoTheme.of(context).bodyText1.override(
                                      fontFamily: 'Inter',
                                      color: Colors.white,
                                      fontWeight: FontWeight.w400
                                  ),
                                  children: <TextSpan>[
                                    TextSpan(text: 'Features: ${item.feature}\n'),
                                    TextSpan(text: 'Rarity: ${item.nft}\n'),
                                    TextSpan(text: 'Total supply: ${item.nft}\n'),
                                    TextSpan(text: 'Issued by: ${item.nft}\n'),
                                    const TextSpan(text: 'You own: 1'),
                                  ])),
                              GestureDetector(
                                onTap: () async {
                                  Clipboard.setData(ClipboardData(text: '${item.id}')).then((_) {
                                    Flushbar(
                                        icon: Icon(
                                          Icons.copy,
                                          size: 20,
                                          color: DodaoTheme.of(context).flushTextColor,
                                        ),
                                        message: '${item.id} copied to your clipboard!',
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
                                      overflow: TextOverflow.fade,
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
                                            TextSpan(text: '${item.id}'),
                                          ])),
                                ),
                              ),
                              GestureDetector(
                                onTap: () async {
                                  Clipboard.setData(ClipboardData(text: '${item.name}')).then((_) {
                                    Flushbar(
                                        icon: Icon(
                                          Icons.copy,
                                          size: 20,
                                          color: DodaoTheme.of(context).flushTextColor,
                                        ),
                                        message: '${item.name} copied to your clipboard!',
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
                                      maxLines: 2,
                                      overflow: TextOverflow.fade,
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
                                        TextSpan(text: '${item.name}'),
                                      ])),
                                ),
                              ),
                            ],
                          )
                      ),

                    ],
                  );
                }),
                if (page == 'selection')
                NftCheckBox(item: item),
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