import 'package:flutter/material.dart';
import 'package:nanoid/async.dart';
import 'package:provider/provider.dart';
import 'package:webthree/credentials.dart';

import '../../blockchain/classes.dart';
import '../../blockchain/task_services.dart';
import '../../config/theme.dart';
import '../../wallet/model_view/wallet_model.dart';
import '../../widgets/tags/search_services.dart';
import '../../widgets/wallet_action_dialog.dart';
import '../collection_services.dart';

class MintBottomSheet extends StatefulWidget {
  final String collectionName;
  const MintBottomSheet({
    super.key,
    required this.collectionName
  });

  @override
  State<MintBottomSheet> createState() => _MintBottomSheetState();
}


class _MintBottomSheetState extends State<MintBottomSheet> {
  final ButtonStyle activeButtonStyle = ElevatedButton.styleFrom(backgroundColor: Colors.deepOrangeAccent);

  late bool canCreateCollection = false;
  late bool canMintNft = false;

  @override
  void initState() {
    super.initState();
    // WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
    //   var collectionServices = context.read<CollectionServices>();
    //   item = collectionServices.mintNftTagSelected;
    // });
  }

  @override
  Widget build(BuildContext context) {
    var tasksServices = context.watch<TasksServices>();
    var searchServices = context.watch<SearchServices>();
    var collectionServices = context.watch<CollectionServices>();
    final walletConnected = context.select((WalletModel vm) => vm.state.walletConnected);
    final listenWalletAddress = context.select((WalletModel vm) => vm.state.walletAddress);
    if (searchServices.mintPageFilterResults[widget.collectionName] == null) {
      canCreateCollection = true;
      canMintNft = false;
    } else {
      canCreateCollection = false;
      if (walletConnected) {
        canMintNft = true;
      } else {
        canMintNft = false;
      }
    }

    return Container(
      padding: const EdgeInsets.all(10),
      height: 300,
      width: double.infinity,
      child: Center(
        child: Column(
          children: [
            // Top:
            Material(
              type: MaterialType.transparency,
              elevation: 6.0,
              child: Padding(
                padding: const EdgeInsets.only(top: 12.0, bottom: 12, left: 12, right: 12),
                child: Row(
                  children: [
                    const Spacer(),
                    Container(
                      // constraints: const BoxConstraints(
                      //   maxWidth: 250,
                      // ),
                      padding: const EdgeInsets.only(left: 5.0, right: 5.0),
                      child: Text(
                        widget.collectionName ,
                        style: Theme.of(context).textTheme.bodyMedium,
                        softWrap: false,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ),
                    const Spacer(),
                    InkResponse(
                      radius: DodaoTheme.of(context).inkRadius,
                      containedInkWell: false,
                      onTap: () {
                        // collectionServices.clearSelectedInManager();
                        // searchServices.tagSelection(
                        //     unselectAll: true,
                        //     tagName: '', typeSelection: 'mint', tagKey: ''
                        // );
                        Navigator.pop(context);
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
            ),

            //Body:
            Container(
              alignment: Alignment.topLeft,
              padding: const EdgeInsets.only(left: 15.0, right: 15.0, top: 0.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Container(
                    alignment: Alignment.topLeft,
                    decoration: BoxDecoration(
                      border: DodaoTheme.of(context).pictureBorderGradient,
                      borderRadius: BorderRadius.circular(17),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(15.0),
                      child: Image.asset(
                        'assets/images/logo.png',
                        height: 150,
                        filterQuality: FilterQuality.medium,
                        isAntiAlias: true,
                      ),
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      //Upload:
                      Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: ElevatedButton(
                          style: null,
                          onPressed: null,
                          child: Text(
                            'Upload picture',
                            style: Theme.of(context).textTheme.titleSmall!.copyWith(color: DodaoTheme.of(context).buttonTextColor),
                          ),
                        ),
                      ),

                      //Add features:
                      Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: ElevatedButton(
                          style: null,
                          onPressed: null,
                          child: Text(
                            'Add features',
                            style: Theme.of(context).textTheme.titleSmall!.copyWith(color: DodaoTheme.of(context).buttonTextColor),
                          ),
                        ),
                      ),

                      // Create:
                      Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: ElevatedButton(
                          style: canCreateCollection ? activeButtonStyle : null,

                          onPressed: (canCreateCollection ) ? () async {
                            // collectionServices.clearSelectedInManager();
                            showDialog(
                                barrierDismissible: false,
                                context: context,
                                builder: (context) => const WalletActionDialog(
                                  nanoId: 'createNFT',
                                  actionName: 'createNFT',
                                  page: 'create_collection',
                                )
                            );

                            String createNftReceipt = await tasksServices.createNft('example.com', widget.collectionName, true);
                            // print('createNftReceipt: $createNftReceipt');
                            if (createNftReceipt.length == 66) {
                              await searchServices.addNewTag(widget.collectionName, 'mint');
                              // collectionServices.mintNftTagSelected.collection = true;
                              await searchServices.refreshLists('selection');
                              await searchServices.refreshLists('treasury');
                              await searchServices.refreshLists('filter');
                              // setState(() {
                              //   item = TokenItem(collection: true, name: widget.collectionName, id: BigInt.from(0));
                              // });
                            }
                            // searchServices.tagSelection(typeSelection: 'mint', tagName: '', unselectAll: true, tagKey: '');
                          } : null,
                          child: Text(
                            'Create collection',
                            style: Theme.of(context).textTheme.titleSmall!.copyWith(color: DodaoTheme.of(context).buttonTextColor),
                          ),
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: ElevatedButton(
                          style: canMintNft ? activeButtonStyle : null,
                          onPressed: (canMintNft ) ? () async {
                            if (listenWalletAddress != null) {
                              final List<EthereumAddress> address = [listenWalletAddress!];
                              final List<BigInt> quantities = [BigInt.from(1)];
                              showDialog(
                                  barrierDismissible: false,
                                  context: context,
                                  builder: (context) => const WalletActionDialog(
                                    nanoId: 'mintNonFungible',
                                    actionName: 'mintNonFungible',
                                  )
                              );
                              var txn = await tasksServices.mintNonFungibleByName(widget.collectionName, address, quantities);
                              if (txn.length == 66) {

                              }
                            }
                          } : null,
                          child: Text(
                            'Mint',
                            style: Theme.of(context).textTheme.titleSmall!.copyWith(color: DodaoTheme.of(context).buttonTextColor),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}