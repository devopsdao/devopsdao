import 'package:devopsdao/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../blockchain/task_services.dart';
import '../flutter_flow/flutter_flow_icon_button.dart';

import 'package:devopsdao/blockchain/task_services.dart';

class WalletAction extends StatefulWidget {
  const WalletAction({Key? key}) : super(key: key);

  @override
  _WalletAction createState() => _WalletAction();
}

class _WalletAction extends State<WalletAction> {
  String transactionStagesPending = 'initial';
  String transactionStagesConfirmed = 'initial';
  String transactionStagesMinted = 'initial';
  @override
  Widget build(BuildContext context) {
    var tasksServices = context.watch<TasksServices>();

    if (tasksServices.lastTxn == 'pending') {
      transactionStagesPending = 'loading';
    } else if (tasksServices.lastTxn.length == 66) {
      transactionStagesPending = 'done';
      transactionStagesConfirmed = 'done';
      transactionStagesMinted = 'loading';
    } else if (tasksServices.lastTxn == 'minted') {
      transactionStagesMinted = 'done';
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
                        top: 17,
                        left: 17,
                        right: 17,
                        // bottom: 16,
                      ),
                      child: Column(
                        children: [
                          // if (tasksServices.lastTxn == 'pending')
                          //   Container(
                          //     child: Column(
                          //       children: [
                          //         if (tasksServices.lastTxn == 'pending')
                          //           Column(
                          //             children: [
                          //               Row(
                          //                 children: [
                          //                   Container(
                          //                       width: 45,
                          //                       height:  35,
                          //                       child: Row(
                          //                         children: [
                          //                           Icon(Icons.arrow_circle_up_outlined, size: 30.0, color: Colors.yellow,),
                          //                         ],
                          //                       )
                          //                   ),
                          //                   Container(
                          //                     alignment: Alignment.center,
                          //                     child: Text(
                          //                       'Confirm the transaction',
                          //                       style: Theme.of(context).textTheme.headline6,
                          //                       textAlign: TextAlign.center,
                          //                     ),
                          //                   ),
                          //
                          //                 ],
                          //               ),
                          //               Container(
                          //                   height:  35,
                          //                   child: Row(
                          //                     mainAxisAlignment: MainAxisAlignment.center,
                          //                     crossAxisAlignment: CrossAxisAlignment.center,
                          //                     children: [
                          //                       Padding(
                          //                         padding: const EdgeInsets.only(
                          //                           top: 25,
                          //                         ),
                          //                         child: LoadingAnimationWidget.prograssiveDots(
                          //                           color: Colors.black54,
                          //                           size: 44,
                          //                         ),
                          //                       )
                          //                     ],
                          //                   )
                          //               ),
                          //             ],
                          //           ),
                          //
                          //         // RichText(
                          //         //     text: TextSpan(
                          //         //       style: Theme.of(context)
                          //         //           .textTheme
                          //         //           .headline6,
                          //         //       children: [
                          //         //         if (tasksServices.lastTxn ==
                          //         //             'pending')
                          //         //           TextSpan(
                          //         //               text:
                          //         //                   'Confirm the transaction'),
                          //         //         if (tasksServices.lastTxn ==
                          //         //             'pending')
                          //         //           WidgetSpan(
                          //         //             child: Padding(
                          //         //               padding:
                          //         //                   const EdgeInsets.symmetric(
                          //         //                       horizontal: 2.0),
                          //         //               child:
                          //         //                   Icon(Icons.airport_shuttle),
                          //         //             ),
                          //         //           )
                          //         //         else if (tasksServices
                          //         //                 .lastTxn.length ==
                          //         //             66)
                          //         //           WidgetSpan(
                          //         //             child: Padding(
                          //         //               padding:
                          //         //                   const EdgeInsets.symmetric(
                          //         //                       horizontal: 2.0),
                          //         //               child: Icon(Icons.verified),
                          //         //             ),
                          //         //           )
                          //         //       ],
                          //         //     ),
                          //         //     textAlign: TextAlign.center),
                          //         // Text(
                          //         //   'Please confirm the transaction in your wallet!',
                          //         //   style:
                          //         //       Theme.of(context).textTheme.headline6,
                          //         //   textAlign: TextAlign.center,
                          //         // ),
                          //         if (tasksServices.lastTxn == 'pending' &&
                          //             tasksServices.platform == 'mobile')
                          //           // TextButton(
                          //           //     child: Text('Go To Wallet'),
                          //           //     style: TextButton.styleFrom(
                          //           //         primary: Colors.white,
                          //           //         backgroundColor: Colors.green),
                          //           //     onPressed: () async {
                          //           //       launchURL(tasksServices
                          //           //           .walletConnectSessionUri);
                          //           //       // _transactionStateToAction(context, state: _state);
                          //           //       setState(() {});
                          //           //       // Navigator.pop(context);
                          //           //     }),
                          //           Row(
                          //             children: [
                          //               Container(
                          //                   width: 45,
                          //                   height:  35,
                          //                   child: Row(
                          //                     children: [
                          //                       Icon(Icons.arrow_circle_up_outlined, size: 30.0, color: Colors.yellow,),
                          //                     ],
                          //                   )
                          //               ),
                          //               Container(
                          //                 alignment: Alignment.center,
                          //                 child: Text(
                          //                   'Go To Wallet',
                          //                   style: Theme.of(context).textTheme.headline6,
                          //                   textAlign: TextAlign.center,
                          //                 ),
                          //               ),
                          //             ],
                          //           ),
                          //       ],
                          //     ),
                          //   )
                          if (tasksServices.lastTxn == 'rejected')
                            Row(
                              children: [
                                Container(
                                    width: 45,
                                    height: 35,
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.dangerous_outlined,
                                          size: 30.0,
                                          color: Colors.red,
                                        ),
                                      ],
                                    )),
                                if (tasksServices.lastTxn == 'pending' &&
                                    (tasksServices.platform == 'mobile'))
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
                                //),
                                Container(
                                  alignment: Alignment.center,
                                  child: Text(
                                    'Transaction has been rejected',
                                    style:
                                        Theme.of(context).textTheme.headline6,
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ],
                            )
                          // Text(
                          //   'Transaction has been rejected',
                          //   style: Theme.of(context).textTheme.headline6,
                          //   textAlign: TextAlign.center,
                          // )
                          else if (tasksServices.lastTxn == 'failed')
                            Row(
                              children: [
                                Container(
                                    width: 45,
                                    height: 35,
                                    child: Row(
                                      children: [
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
                                    style:
                                        Theme.of(context).textTheme.headline6,
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ],
                            )
                          // Text(
                          //   'Transaction has failed, please retry',
                          //   style: Theme.of(context).textTheme.headline6,
                          //   textAlign: TextAlign.center,
                          // )
                          else if (tasksServices.lastTxn == 'minted' ||
                              tasksServices.lastTxn.length == 66 ||
                              tasksServices.lastTxn == 'pending')
                            Column(
                              children: [
                                Row(
                                  children: [
                                    Container(
                                        width: 45,
                                        height: 45,
                                        child: Row(
                                          children: [
                                            if (transactionStagesPending ==
                                                'initial')
                                              Icon(
                                                Icons.task_alt,
                                                size: 30.0,
                                                color: Colors.black26,
                                              )
                                            else if (transactionStagesPending ==
                                                'loading')
                                              LoadingAnimationWidget
                                                  .threeRotatingDots(
                                                color: Colors.black54,
                                                size: 30,
                                              )
                                            else if (transactionStagesPending ==
                                                'done')
                                              Icon(
                                                Icons.task_alt,
                                                size: 30.0,
                                                color: Colors.green,
                                              )
                                          ],
                                        )),
                                    Container(
                                      alignment: Alignment.center,
                                      child: Text(
                                        'Confirm the transaction',
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline6,
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
                                            if (transactionStagesConfirmed ==
                                                'initial')
                                              // Icon(Icons.task_alt, size: 30.0, color: Colors.green,)
                                              Icon(
                                                Icons.task_alt,
                                                size: 30.0,
                                                color: Colors.black26,
                                              )
                                            else if (transactionStagesConfirmed ==
                                                'done')
                                              Icon(
                                                Icons.task_alt,
                                                size: 30.0,
                                                color: Colors.green,
                                              )
                                          ],
                                        )),
                                    Center(
                                      child: Text(
                                        'Transaction confirmed',
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline6,
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
                                            if (transactionStagesMinted ==
                                                'initial')
                                              Icon(
                                                Icons.task_alt,
                                                size: 30.0,
                                                color: Colors.black26,
                                              )
                                            else if (transactionStagesMinted ==
                                                'loading')
                                              LoadingAnimationWidget
                                                  .threeRotatingDots(
                                                color: Colors.black54,
                                                size: 30,
                                              )
                                            else if (transactionStagesMinted ==
                                                'done')
                                              Icon(
                                                Icons.task_alt,
                                                size: 30.0,
                                                color: Colors.green,
                                              )
                                          ],
                                        )),
                                    Container(
                                      child: Text(
                                        'Minted in the blockchain',
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline6,
                                        textAlign: TextAlign.left,
                                      ),
                                    ),
                                  ],
                                ),

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
