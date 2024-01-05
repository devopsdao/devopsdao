import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:webthree/credentials.dart';

import '../blockchain/classes.dart';
import '../blockchain/task_services.dart';
import '../config/theme.dart';
import '../wallet/model_view/wallet_model.dart';
import '../widgets/tags/search_services.dart';
import '../widgets/wallet_action_dialog.dart';
import 'collection_services.dart';

class NftMint extends StatelessWidget {
  final TokenItem item;
  final double frameHeight;

  const NftMint({
    Key? key,
    required this.item,
    required this.frameHeight,
  }) : super(key: key);

  final EdgeInsets padding = const EdgeInsets.all(10.0);



  @override
  Widget build(BuildContext context) {
    var tasksServices = context.read<TasksServices>();
    final listenWalletAddress = context.select((WalletModel vm) => vm.state.walletAddress);
    var collectionServices = context.watch<CollectionServices>();
    final String collectionName = item.name;

    return InkWell(
      child: Card(
          elevation: 2,
          color: DodaoTheme.of(context).nftCardBackgroundColor,
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
                  final double maxWidth = constraints.maxWidth - 190;
                  return Row(
                    children: [
                      Container(
                        alignment: Alignment.topLeft,
                        padding: padding,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(15.0),
                          child: Image.asset(
                            'assets/images/logo.png',
                            height: frameHeight - 153,
                            filterQuality: FilterQuality.medium,
                            isAntiAlias: true,
                          ),
                        ),
                      ),

                      Container(
                          alignment: Alignment.topLeft,
                          padding: padding,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: maxWidth,
                                child: RichText(
                                    text: TextSpan(style: DodaoTheme.of(context).bodyText1.override(
                                        fontFamily: 'Inter',
                                        color: Colors.white,
                                        fontWeight: FontWeight.w400
                                    ),
                                        children: <TextSpan>[
                                          TextSpan(text: 'Luck of "${item.name}" NFT, below you have the opportunity to mint a new one.\n'),



                                        ])),
                              ),

                              Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(backgroundColor: Colors.deepOrangeAccent),
                                      // onPressed: (stageMint != Status.done)
                                      //     ? () {
                                      //         if (stageMint == Status.open) {
                                      //           setState(() {
                                      //             stageMint = Status.done;
                                      //           });
                                      //         }
                                      //       }
                                      //     : null,
                                      onPressed: () async {
                                        if (listenWalletAddress != null) {
                                          final List<EthereumAddress> address = [listenWalletAddress!];
                                          final List<BigInt> quantities = [BigInt.from(1)];

                                          showDialog(
                                              barrierDismissible: false,
                                              context: context,
                                              builder: (context) => const WalletActionDialog(
                                                nanoId: 'mintNonFungible',
                                                taskName: 'mintNonFungible',
                                              ));

                                          await tasksServices.mintNonFungibleByName(collectionName, address, quantities);

                                        }
                                      },
                                      child: Text(
                                        'Mint',
                                        style: DodaoTheme.of(context).bodyText1.override(fontFamily: 'Inter', color: Colors.white, fontWeight: FontWeight.w400),
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            ],
                          )
                      ),
                    ],
                  );
                }),
              ],
            ),
          )
      ),
    );
  }
}
