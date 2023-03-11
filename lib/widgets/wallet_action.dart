import 'package:devopsdao/config/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';

import '../blockchain/interface.dart';
import '../blockchain/task_services.dart';

class WalletAction extends StatefulWidget {
  final String nanoId;
  final String taskName;
  const WalletAction({Key? key, required this.nanoId, required this.taskName}) : super(key: key);

  @override
  _WalletAction createState() => _WalletAction();
}

class _WalletAction extends State<WalletAction> {
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
    var interface = context.watch<InterfaceServices>();

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

    if (widget.taskName == 'createTaskContract' && tasksServices.taskTokenSymbol != 'ETH') {
      if (tasksServices.transactionStatuses[widget.nanoId]?[widget.taskName]?['status'] == 'pending') {
        if (tasksServices.transactionStatuses[widget.nanoId]?[widget.taskName]?['tokenApproved'] == 'initial') {
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
      } else if (tasksServices.transactionStatuses[widget.nanoId]?[widget.taskName]?['status'] == 'minted' &&
          tasksServices.transactionStatuses[widget.nanoId]?[widget.taskName]?['tokenApproved'] == 'approved') {
        transactionStagesApprove = 'done';
        // transactionStagesWaiting = 'done';
        // transactionStagesPending = 'loading';
        transactionStagesConfirmed = 'loading';
        transactionStagesMinted = 'initial';
      } else if (tasksServices.transactionStatuses[widget.nanoId]?[widget.taskName]?['status'] == 'confirmed' &&
          tasksServices.transactionStatuses[widget.nanoId]?[widget.taskName]?['tokenApproved'] == 'complete') {
        transactionStagesApprove = 'done';
        // transactionStagesWaiting = 'done';
        // transactionStagesPending = 'done';
        transactionStagesConfirmed = 'done';
        transactionStagesMinted = 'loading';
      } else if (tasksServices.transactionStatuses[widget.nanoId]?[widget.taskName]?['status'] == 'minted' &&
          tasksServices.transactionStatuses[widget.nanoId]?[widget.taskName]?['tokenApproved'] == 'complete') {
        transactionStagesApprove = 'done';
        // transactionStagesWaiting = 'done';
        // transactionStagesPending = 'done';
        transactionStagesConfirmed = 'done';
        transactionStagesMinted = 'done';
      }
    } else {
      if (tasksServices.transactionStatuses[widget.nanoId]?[widget.taskName]?['status'] == 'pending') {
        // transactionStagesPending = 'loading';
        transactionStagesConfirmed = 'loading';
        transactionStagesMinted = 'initial';
      } else if (tasksServices.transactionStatuses[widget.nanoId]?[widget.taskName]?['status'] == 'confirmed') {
        // transactionStagesPending = 'done';
        transactionStagesConfirmed = 'done';
        transactionStagesMinted = 'loading';
      } else if (tasksServices.transactionStatuses[widget.nanoId]?[widget.taskName]?['status'] == 'minted') {
        transactionStagesConfirmed = 'done';
        transactionStagesMinted = 'done';
      }
    }

    return AlertDialog(

      // title: Text('Connect your wallet'),
      content: SingleChildScrollView(
        child: ListBody(
          children: <Widget>[
            // RichText(text: TextSpan(
            //     style: DefaultTextStyle.of(context).style.apply(fontSizeFactor: 1.0),
            //     children: <TextSpan>[
            //       TextSpan(
            //           text: 'Description: \n',
            //           style: const TextStyle(height: 2, fontWeight: FontWeight.bold)),
            //       TextSpan(text: widget.obj[index].description)
            //     ]
            // )),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                    padding: const EdgeInsets.only(
                      top: 18,
                      left: 18,
                      right: 18,
                      // bottom: 16,
                    ),
                    child: Column(
                      children: [
                        if (tasksServices.transactionStatuses[widget.nanoId]?[widget.taskName]?['txn'] == 'rejected')
                          Row(
                            children: [
                              Container(
                                  width: 45,
                                  height: 35,
                                  child: Row(
                                    children: const [
                                      Icon(
                                        Icons.dangerous_outlined,
                                        size: 30.0,
                                        color: Colors.red,
                                      ),
                                    ],
                                  )),
                              Container(
                                alignment: Alignment.center,
                                child: Text(
                                  'Transaction has been rejected',
                                  style: Theme.of(context).textTheme.bodyText1,
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
                              Container(
                                  width: 45,
                                  height: 35,
                                  child: Row(
                                    children: const [
                                      Icon(
                                        Icons.dangerous_outlined,
                                        size: 30.0,
                                        color: Colors.red,
                                      ),
                                    ],
                                  )),
                              Container(
                                alignment: Alignment.center,
                                child: Text(
                                  'Transaction has failed, \nplease retry',
                                  style: Theme.of(context).textTheme.bodyText1,
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
                                        width: 45,
                                        height: 45,
                                        child: Row(
                                          children: [
                                            if (transactionStagesApprove == 'initial')
                                              const Icon(
                                                Icons.task_alt,
                                                size: 30.0,
                                                color: Colors.black26,
                                              )
                                            else if (transactionStagesApprove == 'loading' || transactionStagesApprove == 'approve')
                                              LoadingAnimationWidget.threeRotatingDots(
                                                color: Colors.black54,
                                                size: 30,
                                              )
                                            else if (transactionStagesApprove == 'done')
                                              const Icon(
                                                Icons.task_alt,
                                                size: 30.0,
                                                color: Colors.green,
                                              )
                                          ],
                                        )),
                                    if (transactionStagesApprove == 'initial')
                                      Text(
                                        'Please approve access',
                                        style: Theme.of(context).textTheme.bodyText1,
                                        textAlign: TextAlign.left,
                                      ),
                                    if (transactionStagesApprove == 'loading')
                                      Text(
                                        'Please approve access',
                                        style: Theme.of(context).textTheme.bodyText1,
                                        textAlign: TextAlign.left,
                                      ),
                                    if (transactionStagesApprove == 'approve')
                                      Text(
                                        'Token access approved',
                                        style: Theme.of(context).textTheme.bodyText1,
                                        textAlign: TextAlign.left,
                                      ),
                                    if (transactionStagesApprove == 'done')
                                      Text(
                                        'Token access approved',
                                        style: Theme.of(context).textTheme.bodyText1,
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
                                      width: 45,
                                      height: 45,
                                      child: Row(
                                        children: [
                                          if (transactionStagesConfirmed == 'initial')
                                            // Icon(Icons.task_alt, size: 30.0, color: Colors.green,)
                                            const Icon(
                                              Icons.task_alt,
                                              size: 30.0,
                                              color: Colors.black26,
                                            )
                                          else if (transactionStagesConfirmed == 'loading')
                                            LoadingAnimationWidget.threeRotatingDots(
                                              color: Colors.black54,
                                              size: 30,
                                            )
                                          else if (transactionStagesConfirmed == 'done')
                                            const Icon(
                                              Icons.task_alt,
                                              size: 30.0,
                                              color: Colors.green,
                                            )
                                        ],
                                      )),
                                  if (transactionStagesConfirmed == 'initial' || transactionStagesConfirmed == 'loading')
                                    Center(
                                      child: Text(
                                        'Please approve transaction',
                                        style: Theme.of(context).textTheme.bodyText1,
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  if (transactionStagesConfirmed == 'done')
                                    Center(
                                      child: Text(
                                        'Transaction approved',
                                        style: Theme.of(context).textTheme.bodyText1,
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                ],
                              ),
                              Row(
                                children: [
                                  Container(
                                      width: 45,
                                      height: 45,
                                      child: Row(
                                        children: [
                                          if (transactionStagesMinted == 'initial')
                                            const Icon(
                                              Icons.task_alt,
                                              size: 30.0,
                                              color: Colors.black26,
                                            )
                                          else if (transactionStagesMinted == 'loading')
                                            LoadingAnimationWidget.threeRotatingDots(
                                              color: Colors.black54,
                                              size: 30,
                                            )
                                          else if (transactionStagesMinted == 'done')
                                            const Icon(
                                              Icons.task_alt,
                                              size: 30.0,
                                              color: Colors.green,
                                            )
                                        ],
                                      )),
                                  Text(
                                    'Minted in the blockchain',
                                    style: Theme.of(context).textTheme.bodyText1,
                                    textAlign: TextAlign.left,
                                  ),
                                ],
                              ),
                              // Prevent to show *Token transaction approved* for other

                              // Container(
                              //
                              //     // width: 45,
                              //     height:  35,
                              //     child: Row(
                              //
                              //       mainAxisAlignment: MainAxisAlignment.center,
                              //       crossAxisAlignment: CrossAxisAlignment.center,
                              //       children: [
                              //         if(tasksServices.lastTxn != 'minted')
                              //         Padding(
                              //           padding: const EdgeInsets.only(
                              //             top: 25,
                              //             // left: 17,
                              //             // right: 17,
                              //             // bottom: 16,
                              //         ),
                              //           child: LoadingAnimationWidget.prograssiveDots(
                              //             color: Colors.black54,
                              //             size: 44,
                              //           ),
                              //         )
                              //         //
                              //
                              //       ],
                              //     )
                              // ),
                            ],
                          ),
                        // if (tasksServices.interchainSelected.isNotEmpty)
                        if(false)
                          Container(
                            padding: const EdgeInsets.only(top: 50.0),
                            child: Column(
                              children: [
                                const Text('Interchain protocol:'),
                                Container(
                                  padding: const EdgeInsets.all(4.0),
                                  // width: 128,
                                  child: interface.interchainImages[tasksServices.interchainSelected],
                                ),
                              ],
                            ),
                          )
                      ],
                    ))
              ],
            ),
          ],
        ),
      ),
      actions: [
        if (transactionStagesApprove == 'loading' || transactionStagesConfirmed == 'loading')
          TextButton(
              style: TextButton.styleFrom(primary: Colors.white, backgroundColor: Colors.green),
              onPressed: () async {
                launchURL(tasksServices.walletConnectSessionUri);
                // _transactionStateToAction(context, state: _state);
                setState(() {});
                // Navigator.pop(context);
              },
              child: const Text('Go To Wallet')),
        TextButton(child: const Text('Close'), onPressed: () => Navigator.pop(context)),
        // if (tasksServices.walletConnected)
        //   TextButton(
        //       child: Text('Disconnect'),
        //       style: TextButton.styleFrom(
        //           primary: Colors.white, backgroundColor: Colors.red),
        //       onPressed: () async {
        //         await tasksServices.wallectConnectTransaction?.disconnect();
        //         // _transactionStateToAction(context, state: _state);
        //         setState(() {});
        //         // Navigator.pop(context);
        //       }),
        // if (!tasksServices.walletConnected)
        //   TextButton(
        //     child: Text('Connect'),
        //     style: TextButton.styleFrom(
        //         primary: Colors.white, backgroundColor: Colors.green),
        //     onPressed: _transactionStateToAction(context, state2: _state2),
        //     // _transactionStateToAction(context, state: _state);
        //     // setState(() {});
        //     // Navigator.pop(context)
        //   ),
      ],
    );
  }
}
