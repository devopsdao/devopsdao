import 'package:dodao/widgets/tags/search_services.dart';
import 'package:dodao/widgets/tags/wrapped_chip.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../blockchain/classes.dart';
import '../../config/theme.dart';
import '../../nft_manager/collection_services.dart';


class WrappedMintChip extends StatefulWidget {
  final bool selected;
  final MapEntry<String, NftCollection> item;
  final double textWidth;
  final wrapperRole;
  final int tabIndex;
  const WrappedMintChip({Key? key,
    required this.selected,
    required this.item,
    required this.textWidth,
    required this.wrapperRole,
    this.tabIndex = 0,
  }) : super(key: key);

  @override
  _WrappedMintChipState createState() => _WrappedMintChipState();
}

class _WrappedMintChipState extends State<WrappedMintChip> {

  late Color textColor = DodaoTheme.of(context).chipTextColor;
  late Color borderColor = DodaoTheme.of(context).chipBorderColor;
  late Color bodyColor = DodaoTheme.of(context).chipBodyColor;

  @override
  Widget build(BuildContext context) {
    var searchServices = context.read<SearchServices>();
    var collectionServices = context.read<CollectionServices>();

    final String tagName = widget.item.value.name;
    final String tagKey = widget.item.key;


    // sizes
    late double iconSize = 17;
    late double fontSize = 14;
    late double containerMainHeight = 28.0;
    late EdgeInsets containerMargin = const EdgeInsets.symmetric(horizontal: 4, vertical: 4);
    late EdgeInsets centerTextPadding = const EdgeInsets.only(left: 6.0, right: 6.0);

    // final tokenName = walletModel.getNetworkChainCurrency(walletModel.state.chainId ?? WalletService.defaultNetwork);


    final double tagMainWidth = widget.textWidth + 37;


    return TapRegion(
      onTapInside: (tap) {
        setState(() {
          textColor = Colors.white;
          borderColor = DodaoTheme.of(context).chipSelectedColor;
          bodyColor = DodaoTheme.of(context).chipSelectedColor;
        });
        // searchServices.tagSelection( unselectAll: false, tagName: tagName, typeSelection: 'mint', tagKey: tagKey);
        collectionServices.updateMintNft(widget.item.value.bunch.values.first);
      },
      onTapOutside: (tap) {
        setState(() {
          textColor = DodaoTheme.of(context).chipTextColor;
          borderColor = DodaoTheme.of(context).chipBorderColor;
          bodyColor = DodaoTheme.of(context).chipBodyColor;
        });
      },
      child: Container(
        width: tagMainWidth,
        constraints: const BoxConstraints(maxWidth: 280),
        margin: containerMargin,
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(
            Radius.circular(14.0),
          ),
          border: Border.all(
              color: borderColor,
              width: 1
          ),
          color: bodyColor,
        ),
        child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (!(widget.wrapperRole == WrapperRole.selectNew || widget.wrapperRole == WrapperRole.removeNew))
              Container(
                width: 9,
              ),
              Container(
                alignment: Alignment.center,
                height: containerMainHeight,
                child: Padding(
                  padding: centerTextPadding,
                  child: Container(
                    constraints: const BoxConstraints(maxWidth: 210),
                    child: Text(
                      tagName,
                      style: DodaoTheme.of(context).bodyText3.override(
                        fontFamily: 'Inter',
                        color: textColor,
                        fontWeight: FontWeight.w400,
                        fontSize: fontSize,
                      ),
                      softWrap: false,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ),
                ),
              ),
              // Close button (will be not visible if item.selected false)
              Flexible(
                flex: 3,
                child: Opacity(
                  opacity: 0,
                  child: Icon(
                      shadows: const <Shadow>[Shadow(color: Colors.black26, blurRadius: 0.01, offset: Offset(0, 1))],
                      Icons.clear_rounded,
                      size: iconSize,
                      color: textColor
                  ),
                ),
              ),
              Container(
                width: 7,
              )
            ],
          ),
      ),
    );
  }
}
