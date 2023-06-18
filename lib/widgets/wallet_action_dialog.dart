import 'dart:math';

import 'package:beamer/beamer.dart';
import 'package:dodao/config/flutter_flow_util.dart';
import 'package:dodao/config/theme.dart';
import 'package:dodao/widgets/tags/search_services.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:nanoid/async.dart';
import 'package:provider/provider.dart';
import 'package:webthree/credentials.dart';

import '../blockchain/interface.dart';
import '../blockchain/task_services.dart';
import '../tags_manager/collection_services.dart';

class WalletActionDialog extends StatefulWidget {
  final String nanoId;
  final String taskName;
  final String page;
  const WalletActionDialog({Key? key, required this.nanoId, required this.taskName, this.page = ''}) : super(key: key);

  @override
  _WalletActionDialog createState() => _WalletActionDialog();
}

class _WalletActionDialog extends State<WalletActionDialog> {
  String transactionStagesApprove = 'initial';
  String transactionStagesWaiting = 'initial';
  String transactionStagesPending = 'initial';
  String transactionStagesConfirmed = 'initial';
  String transactionStagesMinted = 'initial';

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var tasksServices = context.watch<TasksServices>();
    var searchServices = context.read<SearchServices>();
    var collectionServices = context.read<CollectionServices>();
    var interface = context.read<InterfaceServices>();

    // if(tasksServices.transactionStatuses[widget.nanoId] == null) {
    //
    // }
    // String? statusPrint = tasksServices.transactionStatuses[widget.nanoId]?[widget.taskName]?['status'];
    // print('lastStatus: ' + statusPrint!);
    // String? txnPrint = tasksServices.transactionStatuses[widget.nanoId]?[widget.taskName]?['tokenApproved'];
    // print('statusApproved: ' + txnPrint!);

    // if (widget.taskName == 'createTaskContract' && tasksServices.taskTokenSymbol != 'ETH') {
    //   transactionStagesApprove = 'approve';
    //   transactionStagesPending = 'initial';
    // } else {
    //   transactionStagesPending = 'loading';
    // }
    // Beamer.of(interface.createJobPageContext).beamBack();
    // Beamer.of(context).beamToNamed('/');

    final String? status = tasksServices.transactionStatuses[widget.nanoId]?[widget.taskName]?['status'];
    final String? tokenApproved = tasksServices.transactionStatuses[widget.nanoId]?[widget.taskName]?['tokenApproved'];

    if (widget.taskName == 'createTaskContract' && tasksServices.isRequestApproved) {

      if (status == 'pending') {
        if (tokenApproved == 'initial') {
          transactionStagesApprove = 'loading';
          // transactionStagesWaiting = 'initial';
          // transactionStagesPending = 'initial';
          transactionStagesConfirmed = 'initial';
          transactionStagesMinted = 'initial';
        } else {
          transactionStagesApprove = 'approve';
          // transactionStagesWaiting = 'initial';
          // transactionStagesPending = 'initial';
          transactionStagesConfirmed = 'initial';
          transactionStagesMinted = 'initial';
        }
      } else if (status == 'minted' && tokenApproved == 'approved') {
        transactionStagesApprove = 'done';
        // transactionStagesWaiting = 'done';
        // transactionStagesPending = 'loading';
        transactionStagesConfirmed = 'loading';
        transactionStagesMinted = 'initial';
      } else if (status == 'confirmed' && tokenApproved == 'complete') {
        transactionStagesApprove = 'done';
        // transactionStagesWaiting = 'done';
        // transactionStagesPending = 'done';
        transactionStagesConfirmed = 'done';
        transactionStagesMinted = 'loading';
      } else if (status == 'minted' && tokenApproved == 'complete') {
        transactionStagesApprove = 'done';
        // transactionStagesWaiting = 'done';
        // transactionStagesPending = 'done';
        transactionStagesConfirmed = 'done';
        transactionStagesMinted = 'done';

        Future.delayed(const Duration(milliseconds: 500)).whenComplete(() {
          Navigator.pop(context);
          Navigator.pop(interface.createJobPageContext);
          // WidgetsBinding.instance.addPostFrameCallback((_) {
          //   context.beamToNamed('/customer');
          // });
        });
      }


      tasksServices.isRequestApproved = false;

    } else if (widget.taskName == 'createTaskContract') {
      if (status == 'pending') {
        transactionStagesConfirmed = 'loading';
        transactionStagesMinted = 'initial';
      } else if (status == 'confirmed') {
        transactionStagesConfirmed = 'done';
        transactionStagesMinted = 'loading';
      } else if (status == 'minted') {
        transactionStagesConfirmed = 'done';
        transactionStagesMinted = 'done';

        Future.delayed(const Duration(milliseconds: 500)).whenComplete(() {
          Navigator.pop(context);
          Navigator.pop(interface.createJobPageContext);
          // WidgetsBinding.instance.addPostFrameCallback((_) {
          //   context.beamToNamed('/customer');
          // });
        });
      }
    } else if (widget.taskName == 'createNFT') {
      if (status == 'pending') {
        // transactionStagesApprove = 'done';
        transactionStagesConfirmed = 'loading';
        transactionStagesMinted = 'initial';
      } else if (status == 'confirmed') {
        // transactionStagesApprove = 'done';
        transactionStagesConfirmed = 'done';
        transactionStagesMinted = 'loading';
      } else if (status == 'minted') {
        // transactionStagesApprove = 'done';
        // transactionStagesWaiting = 'done';
        // transactionStagesPending = 'done';
        transactionStagesConfirmed = 'done';
        transactionStagesMinted = 'done';
      }
    } else if (widget.taskName == 'mintNonFungible') {
      if (status == 'pending') {
        // transactionStagesApprove = 'done';
        transactionStagesConfirmed = 'loading';
        transactionStagesMinted = 'initial';
      } else if (status == 'confirmed') {
        // transactionStagesApprove = 'done';
        transactionStagesConfirmed = 'done';
        transactionStagesMinted = 'loading';
      } else if (status == 'minted') {
        transactionStagesApprove = 'done';
        // transactionStagesWaiting = 'done';
        // transactionStagesPending = 'done';
        transactionStagesConfirmed = 'done';
        transactionStagesMinted = 'done';

        Future.delayed(const Duration(milliseconds: 200)).whenComplete(() async {
          await tasksServices.collectMyTokens();
          searchServices.refreshLists('selection');
        });

      }

    } else if (widget.taskName == 'postWitnetRequest') {
      if (status == 'pending') {
        transactionStagesConfirmed = 'loading';
        transactionStagesMinted = 'initial';
      } else if (status == 'confirmed') {
        transactionStagesConfirmed = 'done';
        transactionStagesMinted = 'loading';
      } else if (status == 'minted') {
        transactionStagesConfirmed = 'done';
        transactionStagesMinted = 'done';
      }
    } else if (widget.taskName == 'taskStateChange') {
      if (status == 'pending') {
        transactionStagesConfirmed = 'loading';
        transactionStagesMinted = 'initial';
      } else if (status == 'confirmed') {
        transactionStagesConfirmed = 'done';
        transactionStagesMinted = 'loading';
      } else if (status == 'minted') {
        transactionStagesConfirmed = 'done';
        transactionStagesMinted = 'done';
      }
    } else if (widget.taskName == 'saveLastWitnetResult') {
      if (status == 'pending') {
        transactionStagesConfirmed = 'loading';
        transactionStagesMinted = 'initial';
      } else if (status == 'confirmed') {
        transactionStagesConfirmed = 'done';
        transactionStagesMinted = 'loading';
      } else if (status == 'minted') {
        transactionStagesConfirmed = 'done';
        transactionStagesMinted = 'done';
      }
    } else if (widget.taskName == 'setApprovalForAll') {
      if (status == 'pending') {
        transactionStagesConfirmed = 'loading';
        transactionStagesMinted = 'initial';
      } else if (status == 'confirmed') {
        transactionStagesConfirmed = 'done';
        transactionStagesMinted = 'loading';
      } else if (status == 'minted') {
        transactionStagesConfirmed = 'done';
        transactionStagesMinted = 'done';
      }
    }  else  {
      if (status == 'pending') {
        // transactionStagesPending = 'loading';
        transactionStagesConfirmed = 'loading';
        transactionStagesMinted = 'initial';
      } else if (status == 'confirmed') {
        // transactionStagesPending = 'done';
        transactionStagesConfirmed = 'done';
        transactionStagesMinted = 'loading';
      } else if (status == 'minted') {
        transactionStagesConfirmed = 'done';
        transactionStagesMinted = 'done';
      }
    }
    var width = MediaQuery.of(context).size.width ;


    return Dialog(
      // title: Text('Connect your wallet'),
      shape: RoundedRectangleBorder(borderRadius: DodaoTheme.of(context).borderRadius,),
      insetAnimationDuration: const Duration(milliseconds: 1100),
      child: Container(
        padding: const EdgeInsets.only(
          top: 20,
          left: 20,
          right: 20,
          bottom: 20
        ),
        width: width < 400 ? width : 350,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 250,
                    // padding: const EdgeInsets.all(10),
                    child: Column(
                      children: [
                        if (tasksServices.transactionStatuses[widget.nanoId]?[widget.taskName]?['txn'] == 'rejected')
                          Row(
                            children: [
                              SizedBox(
                                  width: 40,
                                  height: 35,
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.dangerous_outlined,
                                        size: 30.0,
                                        color: DodaoTheme.of(context).iconWrong,
                                      ),
                                    ],
                                  )
                              ),
                              Container(
                                alignment: Alignment.center,
                                child: Text(
                                  'Transaction has been rejected',
                                  style: Theme.of(context).textTheme.bodySmall,
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ],
                          )
                        // Text(
                        //   'Transaction has been rejected',
                        //   style: Theme.of(context).textTheme.bodyText1,
                        //   textAlign: TextAlign.center,
                        // )
                        else if (tasksServices.transactionStatuses[widget.nanoId]?[widget.taskName]?['txn'] == 'failed')
                          Row(
                            children: [
                              SizedBox(
                                  width: 40,
                                  height: 35,
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.dangerous_outlined,
                                        size: 30.0,
                                        color: DodaoTheme.of(context).iconWrong,
                                      ),
                                    ],
                                  )),
                              Container(
                                child: Text(
                                  'Transaction has failed, \nplease retry',
                                  style: Theme.of(context).textTheme.bodyMedium,
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ],
                          )
                        // Text(
                        //   'Transaction has failed, please retry',
                        //   style: Theme.of(context).textTheme.bodyText1,
                        //   textAlign: TextAlign.center,
                        // )
                        else if (tasksServices.transactionStatuses[widget.nanoId]?[widget.taskName]?['txn'] != 'failed' ||
                              tasksServices.transactionStatuses[widget.nanoId]?[widget.taskName]?['txn'] != 'rejected')
                            Column(
                              children: [
                                if (widget.taskName == 'createTaskContract' && tasksServices.taskTokenSymbol != 'ETH')
                                  Row(
                                    children: [
                                      Container(
                                          width: 40,
                                          height: 45,
                                          child: Row(
                                            children: [
                                              if (transactionStagesApprove == 'initial')
                                                Icon(
                                                  Icons.task_alt,
                                                  size: 30.0,
                                                  color: DodaoTheme.of(context).iconInitial,
                                                )
                                              else if (transactionStagesApprove == 'loading' || transactionStagesApprove == 'approve')
                                                LoadingAnimationWidget.threeRotatingDots(
                                                  color: DodaoTheme.of(context).iconProcess,
                                                  size: 30,
                                                )
                                              else if (transactionStagesApprove == 'done')
                                                  Icon(
                                                    Icons.task_alt,
                                                    size: 30.0,
                                                    color: DodaoTheme.of(context).iconDone,
                                                  )
                                            ],
                                          )),
                                      if (transactionStagesApprove == 'initial')
                                        Text(
                                          'Please approve token spend',
                                          style: Theme.of(context).textTheme.bodyMedium,
                                          textAlign: TextAlign.left,
                                        ),
                                      if (transactionStagesApprove == 'loading')
                                        Text(
                                          'Please approve token spend',
                                          style: Theme.of(context).textTheme.bodyMedium,
                                          textAlign: TextAlign.left,
                                        ),
                                      if (transactionStagesApprove == 'approve')
                                        Text(
                                          'Token spend approved',
                                          style: Theme.of(context).textTheme.bodyMedium,
                                          textAlign: TextAlign.left,
                                        ),
                                      if (transactionStagesApprove == 'done')
                                        Text(
                                          'Token spend approved',
                                          style: Theme.of(context).textTheme.bodyMedium,
                                          textAlign: TextAlign.left,
                                        ),
                                    ],
                                  ),
                                // if(widget.taskName == 'createTaskContract' && tasksServices.taskTokenSymbol != 'ETH')
                                // Row(
                                //   children: [
                                //     Container(
                                //         width: 45,
                                //         height:  45,
                                //         child: Row(
                                //           children: [
                                //             if (transactionStagesWaiting == 'initial')
                                //               Icon(Icons.task_alt, size: 30.0, color: Colors.black26,)
                                //             else if (transactionStagesWaiting == 'loading')
                                //               LoadingAnimationWidget.threeRotatingDots(
                                //                 color: Colors.black54,
                                //                 size: 30,
                                //               )
                                //             else if (transactionStagesWaiting == 'done')
                                //                 Icon(Icons.task_alt, size: 30.0, color: Colors.green,)
                                //           ],
                                //         )
                                //     ),
                                //     Container(
                                //       alignment: Alignment.center,
                                //       child: Text(
                                //         'Wait for confirmation',
                                //         style: Theme.of(context).textTheme.bodyText1,
                                //         textAlign: TextAlign.center,
                                //       ),
                                //     ),
                                //
                                //   ],
                                // ),
                                // Row(
                                //   children: [
                                //     Container(
                                //         width: 45,
                                //         height:  45,
                                //         child: Row(
                                //           children: [
                                //             if (transactionStagesPending == 'initial')
                                //               Icon(Icons.task_alt, size: 30.0, color: Colors.black26,)
                                //             else if (transactionStagesPending == 'loading')
                                //               LoadingAnimationWidget.threeRotatingDots(
                                //                 color: Colors.black54,
                                //                 size: 30,
                                //               )
                                //             else if (transactionStagesPending == 'done')
                                //               Icon(Icons.task_alt, size: 30.0, color: Colors.green,)
                                //           ],
                                //         )
                                //     ),
                                //     Container(
                                //       alignment: Alignment.center,
                                //       child: Text(
                                //         'Confirm the transaction',
                                //         style: Theme.of(context).textTheme.bodyText1,
                                //         textAlign: TextAlign.center,
                                //       ),
                                //     ),
                                //
                                //   ],
                                // ),
                                Row(
                                  children: [
                                    Container(
                                        width: 40,
                                        height: 45,
                                        child: Row(
                                          children: [
                                            if (transactionStagesConfirmed == 'initial')
                                            // Icon(Icons.task_alt, size: 30.0, color: Colors.green,)
                                              Icon(
                                                Icons.task_alt,
                                                size: 30.0,
                                                color: DodaoTheme.of(context).iconInitial,
                                              )
                                            else if (transactionStagesConfirmed == 'loading')
                                              LoadingAnimationWidget.threeRotatingDots(
                                                color: DodaoTheme.of(context).iconProcess,
                                                size: 30,
                                              )
                                            else if (transactionStagesConfirmed == 'done')
                                                Icon(
                                                  Icons.task_alt,
                                                  size: 30.0,
                                                  color: DodaoTheme.of(context).iconDone,
                                                )
                                          ],
                                        )),
                                    if (transactionStagesConfirmed == 'initial' || transactionStagesConfirmed == 'loading')
                                      Center(
                                        child: Text(
                                          'Please approve transaction',
                                          style: Theme.of(context).textTheme.bodyMedium,
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    if (transactionStagesConfirmed == 'done')
                                      Center(
                                        child: Text(
                                          'Transaction approved',
                                          style: Theme.of(context).textTheme.bodyMedium,
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Container(
                                        width: 40,
                                        height: 45,
                                        child: Row(
                                          children: [
                                            if (transactionStagesMinted == 'initial')
                                              Icon(
                                                Icons.task_alt,
                                                size: 30.0,
                                                color: DodaoTheme.of(context).iconInitial,
                                              )
                                            else if (transactionStagesMinted == 'loading')
                                              LoadingAnimationWidget.threeRotatingDots(
                                                color: DodaoTheme.of(context).iconProcess,
                                                size: 30,
                                              )
                                            else if (transactionStagesMinted == 'done')
                                                Icon(
                                                  Icons.task_alt,
                                                  size: 30.0,
                                                  color: DodaoTheme.of(context).iconDone,
                                                )
                                          ],
                                        )),
                                    Text(
                                      'Minted in the blockchain',
                                      style: Theme.of(context).textTheme.bodyMedium,
                                      textAlign: TextAlign.left,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                      ],
                    ),
                  ),
                ],
              ),

              // if (tasksServices.interchainSelected.isNotEmpty)
              // if (false)
              //   Container(
              //     padding: const EdgeInsets.only(top: 50.0),
              //     child: Column(
              //       children: [
              //         const Text('Interchain protocol:'),
              //         Container(
              //           padding: const EdgeInsets.all(4.0),
              //           // width: 128,
              //           child: interface.interchainImages[tasksServices.interchainSelected],
              //         ),
              //       ],
              //     ),
              //   )
              const SizedBox( height: 15,),
              Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () async {
                        Navigator.pop(context);

                        if (widget.page == 'create_collection') {
                          await tasksServices.collectMyTokens();
                          // searchServices.tagSelection(unselectAll: true, tagName: '', typeSelection: 'treasury', tagKey: '');
                          collectionServices.update();
                          searchServices.searchKeywordController.clear();
                          // searchServices.refreshLists('mint');
                        }
                      },
                      child: Container(
                        margin: const EdgeInsets.all(0.0),
                        height: 54.0,
                        alignment: Alignment.center,
                        //MediaQuery.of(context).size.width * .08,
                        // width: halfWidth,
                        decoration: BoxDecoration(
                          borderRadius: DodaoTheme.of(context).borderRadius,
                          border: Border.all(width: 0.5, color: Colors.black54 //                   <--- border width here
                          ),
                        ),
                        child: Text(
                          'Close',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: DodaoTheme.of(context).primaryText,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 16,
                  ),
                  if (transactionStagesApprove == 'loading' || transactionStagesConfirmed == 'loading')
                  Expanded(
                    child: InkWell(
                      borderRadius: BorderRadius.circular(20.0),
                      onTap: () {
                        // Navigator.pop(context);
                        launchURL(tasksServices.walletConnectSessionUri);
                        // _transactionStateToAction(context, state: _state);
                        setState(() {

                        });
                        // Navigator.pop(context);
                      },
                      child: Container(
                        padding: const EdgeInsets.all(0.0),
                        height: 54.0,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          borderRadius: DodaoTheme.of(context).borderRadius,
                          gradient: const LinearGradient(
                            colors: [Color(0xfffadb00), Colors.deepOrangeAccent, Colors.deepOrange],
                            stops: [0, 0.6, 1],
                          ),
                        ),
                        child: const Text(
                          'Go to wallet',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ),
                  ),
                  // if (transactionStagesApprove == 'loading' || transactionStagesConfirmed == 'loading')
                  //   Expanded(
                  //     child: InkWell(
                  //       borderRadius: BorderRadius.circular(20.0),
                  //       onTap: () {
                  //         // Navigator.pop(context);
                  //         // launchURL(tasksServices.walletConnectSessionUri);
                  //         // _transactionStateToAction(context, state: _state);
                  //         setState(() {
                  //           // final nanoId = customAlphabet('0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ_abcdefghijklmnopqrstuvwxyz-', 12);
                  //           // final List<String> tags = [];
                  //           // final List<BigInt> tokenId = [];
                  //           // final List<BigInt> amounts = [];
                  //           // //final List<String> tokenNames = [];
                  //           //
                  //           // List<EthereumAddress> tokenContracts = [];
                  //           //
                  //           // late bool nftPresent = false;
                  //           //
                  //           // for (var e in searchServices.createTagsList.entries) {
                  //           //   for (var e2 in e.value.bunch.entries) {
                  //           //     if (e2.value.nft) {
                  //           //       tokenId.add(e2.key);
                  //           //       amounts.add(BigInt.from(1));
                  //           //       nftPresent = true;
                  //           //       //  tokenNames.add(e2.value.name);
                  //           //     } else {
                  //           //       tags.add(e.value.name);
                  //           //     }
                  //           //   }
                  //           // }
                  //           //
                  //           // if (nftPresent) {
                  //           //   tokenContracts.add(tasksServices.contractAddress);
                  //           //   nftPresent = false;
                  //           // }
                  //           //
                  //           // if (interface.tokensEntered != 0) {
                  //           //   // add taskTokenSymbol if there any tokens(expl: ETH) added to contract
                  //           //   //  tokenNames.insert(0, tasksServices.taskTokenSymbol);
                  //           //   tokenId.insert(0, BigInt.from(0));
                  //           //   amounts.insert(0, BigInt.from(interface.tokensEntered * pow(10, 18)));
                  //           //   tokenContracts.insert(0, EthereumAddress.fromHex('0x0000000000000000000000000000000000000000'));
                  //           // } else if (tokenId.isEmpty) {
                  //           //   //  tokenNames.insert(0, 'dodao');
                  //           //   //   amounts.insert(0, BigInt.from(0));
                  //           // }
                  //           //
                  //           // List<List<BigInt>> tokenIds = [tokenId];
                  //           // List<List<BigInt>> tokenAmounts = [amounts];
                  //           //
                  //           // tasksServices.createTaskContract(titleFieldController!.text, descriptionController!.text, githubLinkController!.text,
                  //           //     interface.tokensEntered, nanoId, tags, tokenIds, tokenAmounts, tokenContracts);
                  //         });
                  //         // Navigator.pop(context);
                  //       },
                  //       child: Container(
                  //         padding: const EdgeInsets.all(0.0),
                  //         height: 54.0,
                  //         alignment: Alignment.center,
                  //         decoration: BoxDecoration(
                  //           borderRadius: DodaoTheme.of(context).borderRadius,
                  //           gradient: const LinearGradient(
                  //             colors: [Color(0xfffadb00), Colors.deepOrangeAccent, Colors.deepOrange],
                  //             stops: [0, 0.6, 1],
                  //           ),
                  //         ),
                  //         child: const Text(
                  //           'Retry',
                  //           textAlign: TextAlign.center,
                  //           style: TextStyle(
                  //             color: Colors.white,
                  //             fontWeight: FontWeight.bold,
                  //             fontSize: 18,
                  //           ),
                  //         ),
                  //       ),
                  //     ),
                  //   )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
