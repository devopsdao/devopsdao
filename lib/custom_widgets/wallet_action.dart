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
  @override
  Widget build(BuildContext context) {
    var tasksServices = context.watch<TasksServices>();

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
              height: 150,
              width: 300,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                      padding: const EdgeInsets.only(
                        left: 16,
                        right: 16,
                        bottom: 16,
                      ),
                      child: Column(
                        children: [
                          if (tasksServices.lastTxn == 'pending')
                            Container(
                              child: Column(
                                children: [
                                  RichText(
                                      text: TextSpan(
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline6,
                                        children: [
                                          if (tasksServices.lastTxn ==
                                              'pending')
                                            TextSpan(
                                                text:
                                                    'Confirm the transaction'),
                                          if (tasksServices.lastTxn ==
                                              'pending')
                                            WidgetSpan(
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 2.0),
                                                child:
                                                    Icon(Icons.airport_shuttle),
                                              ),
                                            )
                                          else if (tasksServices
                                                  .lastTxn.length ==
                                              66)
                                            WidgetSpan(
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 2.0),
                                                child: Icon(Icons.verified),
                                              ),
                                            )
                                        ],
                                      ),
                                      textAlign: TextAlign.center),
                                  // Text(
                                  //   'Please confirm the transaction in your wallet!',
                                  //   style:
                                  //       Theme.of(context).textTheme.headline6,
                                  //   textAlign: TextAlign.center,
                                  // ),
                                  if (tasksServices.lastTxn == 'pending' &&
                                      tasksServices.platform == 'mobile')
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
                                ],
                              ),
                            )
                          else if (tasksServices.lastTxn == 'rejected')
                            Text(
                              'Transaction has been rejected',
                              style: Theme.of(context).textTheme.headline6,
                              textAlign: TextAlign.center,
                            )
                          else if (tasksServices.lastTxn == 'failed')
                            Text(
                              'Transaction has failed, please retry',
                              style: Theme.of(context).textTheme.headline6,
                              textAlign: TextAlign.center,
                            )
                          else if (tasksServices.lastTxn == 'minted')
                            Text(
                              'Transaction has been minted in the blockchain',
                              style: Theme.of(context).textTheme.headline6,
                              textAlign: TextAlign.center,
                            )
                          else if (tasksServices.lastTxn.length == 66)
                            Text(
                              'Transaction confirmed :)',
                              style: Theme.of(context).textTheme.headline6,
                              textAlign: TextAlign.center,
                            ),
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
