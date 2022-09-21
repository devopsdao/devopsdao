import 'package:devopsdao/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../blockchain/task_services.dart';
import '../flutter_flow/flutter_flow_icon_button.dart';

import 'package:devopsdao/blockchain/task_services.dart';

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
  Widget build(BuildContext context) {
    var tasksServices = context.watch<TasksServices>();
    // if(tasksServices.transactionStatuses[widget.nanoId] == null) {
    //
    // }
    // String? statusPrint = tasksServices.transactionStatuses[widget.nanoId]?[widget.taskName]?['status'];
    // print('lastStatus: ' + statusPrint!);
    // String? txnPrint = tasksServices.transactionStatuses[widget.nanoId]?[widget.taskName]?['tokenApproved'];
    // print('statusApproved: ' + txnPrint!);

    // if (widget.taskName == 'addTask' && tasksServices.taskTokenSymbol != 'ETH') {
    //   transactionStagesApprove = 'approve';
    //   transactionStagesPending = 'initial';
    // } else {
    //   transactionStagesPending = 'loading';
    // }

    if (widget.taskName == 'addTask' && tasksServices.taskTokenSymbol != 'ETH') {
      if (tasksServices.transactionStatuses[widget.nanoId]?[widget
          .taskName]?['status'] == 'pending') {
        if (tasksServices.transactionStatuses[widget.nanoId]?[widget
            .taskName]?['tokenApproved'] == 'initial') {
          transactionStagesApprove = 'approve';
          transactionStagesWaiting = 'initial';
          transactionStagesPending = 'initial';
          transactionStagesConfirmed = 'initial';
          transactionStagesMinted = 'initial';
        } else {
          transactionStagesApprove = 'loading';
          transactionStagesWaiting = 'initial';
          transactionStagesPending = 'initial';
          transactionStagesConfirmed = 'initial';
          transactionStagesMinted = 'initial';
        }
      } else if (tasksServices.transactionStatuses[widget.nanoId]?[widget
          .taskName]?['status'] == 'minted' &&
          tasksServices.transactionStatuses[widget.nanoId]?[widget
              .taskName]?['tokenApproved'] == 'approved') {
        transactionStagesApprove = 'done';
        transactionStagesWaiting = 'done';
        transactionStagesPending = 'loading';
        transactionStagesConfirmed = 'initial';
        transactionStagesMinted = 'initial';
      } else if (tasksServices.transactionStatuses[widget.nanoId]?[widget
          .taskName]?['status'] == 'confirmed' &&
          tasksServices.transactionStatuses[widget.nanoId]?[widget
              .taskName]?['tokenApproved'] == 'complete') {
        transactionStagesApprove = 'done';
        transactionStagesWaiting = 'done';
        transactionStagesPending = 'done';
        transactionStagesConfirmed = 'done';
        transactionStagesMinted = 'loading';
      } else if (tasksServices.transactionStatuses[widget.nanoId]?[widget
          .taskName]?['status'] == 'minted' &&
          tasksServices.transactionStatuses[widget.nanoId]?[widget
              .taskName]?['tokenApproved'] == 'complete') {
        transactionStagesApprove = 'done';
        transactionStagesWaiting = 'done';
        transactionStagesPending = 'done';
        transactionStagesConfirmed = 'done';
        transactionStagesMinted = 'done';
      }
    } else {
      if (tasksServices.transactionStatuses[widget.nanoId]?[widget
          .taskName]?['status'] == 'pending') {
        transactionStagesPending = 'loading';
        transactionStagesConfirmed = 'initial';
        transactionStagesMinted = 'initial';
      } else if (tasksServices.transactionStatuses[widget.nanoId]?[widget
          .taskName]?['status'] == 'confirmed') {
        transactionStagesPending = 'done';
        transactionStagesConfirmed = 'done';
        transactionStagesMinted = 'loading';
      } else if (tasksServices.transactionStatuses[widget.nanoId]?[widget
          .taskName]?['status'] == 'minted') {
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
            Container(
              // height: 150,
              // width: 350,
              child: Column(
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
                                    height:  35,
                                    child: Row(
                                      children: [
                                        Icon(Icons.dangerous_outlined, size: 30.0, color: Colors.red,),
                                      ],
                                    )
                                ),
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
                                      height:  35,
                                      child: Row(
                                        children: [
                                          Icon(Icons.dangerous_outlined, size: 30.0, color: Colors.red,),
                                        ],
                                      )
                                  ),
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
                          else if (
                                tasksServices.transactionStatuses[widget.nanoId]?[widget.taskName]?['txn'] != 'failed' ||
                                tasksServices.transactionStatuses[widget.nanoId]?[widget.taskName]?['txn'] != 'rejected'
                            )

                            Column(
                              children: [
                                if(widget.taskName == 'addTask' && tasksServices.taskTokenSymbol != 'ETH')
                                  Row(
                                    children: [
                                      Container(
                                          width: 45,
                                          height:  45,
                                          child: Row(
                                            children: [
                                              if(transactionStagesApprove == 'initial')
                                                Icon(Icons.task_alt, size: 30.0, color: Colors.black26,)
                                              else if(transactionStagesApprove == 'loading' || transactionStagesApprove == 'approve')
                                                LoadingAnimationWidget.threeRotatingDots(
                                                  color: Colors.black54,
                                                  size: 30,
                                                )
                                              else if(transactionStagesApprove == 'done')
                                                  Icon(Icons.task_alt, size: 30.0, color: Colors.green,)
                                            ],
                                          )
                                      ),

                                      if(transactionStagesApprove == 'initial')
                                        Container(
                                          child: Text(
                                            'Token transaction approved',
                                            style: Theme.of(context).textTheme.bodyText1,
                                            textAlign: TextAlign.left,
                                          ),
                                        ),
                                      if(transactionStagesApprove == 'approve')
                                        Container(
                                          child: Text(
                                            'Please approve\ntoken transaction!',
                                            style: Theme.of(context).textTheme.bodyText1,
                                            textAlign: TextAlign.left,
                                          ),
                                        ),
                                      if(transactionStagesApprove == 'done')
                                        Container(
                                          child: Text(
                                            'Token transaction approved',
                                            style: Theme.of(context).textTheme.bodyText1,
                                            textAlign: TextAlign.left,
                                          ),
                                        ),
                                    ],
                                  ),
                                if(widget.taskName == 'addTask' && tasksServices.taskTokenSymbol != 'ETH')
                                Row(
                                  children: [
                                    Container(
                                        width: 45,
                                        height:  45,
                                        child: Row(
                                          children: [
                                            if (transactionStagesWaiting == 'initial')
                                              Icon(Icons.task_alt, size: 30.0, color: Colors.black26,)
                                            else if (transactionStagesWaiting == 'loading')
                                              LoadingAnimationWidget.threeRotatingDots(
                                                color: Colors.black54,
                                                size: 30,
                                              )
                                            else if (transactionStagesWaiting == 'done')
                                                Icon(Icons.task_alt, size: 30.0, color: Colors.green,)
                                          ],
                                        )
                                    ),
                                    Container(
                                      alignment: Alignment.center,
                                      child: Text(
                                        'Wait for confirmation',
                                        style: Theme.of(context).textTheme.bodyText1,
                                        textAlign: TextAlign.center,
                                      ),
                                    ),

                                  ],
                                ),
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
                                              Icon(Icons.task_alt, size: 30.0, color: Colors.black26,)
                                            else if (transactionStagesConfirmed == 'done')
                                              Icon(Icons.task_alt, size: 30.0, color: Colors.green,)
                                          ],
                                        )
                                    ),
                                    Center(
                                      child: Text(
                                        'Transaction confirmed',
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
                                        height:  45,
                                        child: Row(
                                          children: [
                                            if(transactionStagesMinted == 'initial')
                                              Icon(Icons.task_alt, size: 30.0, color: Colors.black26,)
                                            else if(transactionStagesMinted == 'loading')
                                              LoadingAnimationWidget.threeRotatingDots(
                                                color: Colors.black54,
                                                size: 30,
                                              )
                                            else if(transactionStagesMinted == 'done')
                                                Icon(Icons.task_alt, size: 30.0, color: Colors.green,)
                                          ],
                                        )
                                    ),
                                    Container(

                                        child: Text(
                                          'Minted in the blockchain',
                                          style: Theme.of(context).textTheme.bodyText1,
                                          textAlign: TextAlign.left,
                                        ),
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
                            )
                        ],
                      ))
                ],
              ),
            ),
          ],
        ),
      ),
      actions: [
        if(transactionStagesMinted == 'initial')
        TextButton(
            child: Text('Go To Wallet'),
            style: TextButton.styleFrom(
                primary: Colors.white,
                backgroundColor: Colors.green),
            onPressed: () async {
              launchURL(tasksServices
                  .walletConnectSessionUri);
              // _transactionStateToAction(context, state: _state);
              setState(() {});
              // Navigator.pop(context);
            }),
        TextButton(
            child: Text('Close'), onPressed: () => Navigator.pop(context)),
        // if (tasksServices.walletConnectConnected)
        //   TextButton(
        //       child: Text('Disconnect'),
        //       style: TextButton.styleFrom(
        //           primary: Colors.white, backgroundColor: Colors.red),
        //       onPressed: () async {
        //         await tasksServices.transactionTester?.disconnect();
        //         // _transactionStateToAction(context, state: _state);
        //         setState(() {});
        //         // Navigator.pop(context);
        //       }),
        // if (!tasksServices.walletConnectConnected)
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
