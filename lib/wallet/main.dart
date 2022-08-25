import 'package:flutter/material.dart';
import 'package:walletconnect_dart/walletconnect_dart.dart';
import 'algorand_transaction_tester.dart';
import 'ethereum_transaction_tester.dart';
import 'transaction_tester.dart';
import 'wallet_connect_lifecycle.dart';
import 'package:qr_flutter/qr_flutter.dart';

import 'package:provider/provider.dart';
import 'package:devopsdao/blockchain/task_services.dart';

// void main() {
//   runApp(const MyApp());
// }

enum NetworkType {
  ethereum,
  algorand,
}

enum TransactionState {
  disconnected,
  connecting,
  connected,
  connectionFailed,
  transferring,
  success,
  failed,
}

// class MyApp extends StatelessWidget {
//   const MyApp({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Mobile dApp',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       home: const MyWalletPage(title: 'WalletConnect'),
//     );
//   }
// }

// class ConnectButton {
//
// }
// class ConnectButton extends StatefulWidget {
//   const ConnectButton({Key? key, required this.title}) : super(key: key);
//
//   final String title;
//
//   @override
//   State<ConnectButton> createState() => _ConnectButton();
// }
//
// class _ConnectButton extends State<ConnectButton> {
//   TransactionState _state = TransactionState.disconnected;
//   @override
//   Widget build(BuildContext context) {
//     // var tasksServices = context.watch<TasksServices>();
//     // if (tasksServices.walletConnectState == null) {
//     //   tasksServices.walletConnectState = _state;
//     // } else {
//     //   setState(() => _state = tasksServices.walletConnectState);
//     // }
//     return TextButton(
//         child: Text('Connect'),
//         style: TextButton.styleFrom(
//             primary: Colors.white, backgroundColor: Colors.green),
//         onPressed: () {
//           // _transactionStateToAction(context, state: _state);
//           setState(() {});
//           Navigator.pop(context);
//         });
//
//   }
//
// }

// class DisconnectButton extends StatefulWidget {
//   const DisconnectButton({Key? key, required this.title}) : super(key: key);
//
//   final String title;
//
//   @override
//   State<DisconnectButton> createState() => _DisconnectButton();
// }
//
// class _DisconnectButton extends State<DisconnectButton> {
//   TransactionState _state = TransactionState.disconnected;
//   @override
//   Widget build(BuildContext context) {
//     var tasksServices = context.watch<TasksServices>();
//     // if (tasksServices.walletConnectState == null) {
//     //   tasksServices.walletConnectState = _state;
//     // } else {
//     //   setState(() => _state = tasksServices.walletConnectState);
//     // }
//     return TextButton(
//         child: Text('Disconnect'),
//         style: TextButton.styleFrom(
//             primary: Colors.white, backgroundColor: Colors.red),
//         onPressed: () async {
//           await tasksServices.transactionTester?.disconnect();
//           // _transactionStateToAction(context, state: _state);
//           setState(() {});
//           // Navigator.pop(context);
//         });
//   }
// }

class MyWalletPage extends StatefulWidget {
  const MyWalletPage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyWalletPageState createState() => _MyWalletPageState();
}

class _MyWalletPageState extends State<MyWalletPage> {
  String txId = '';
  String _displayUri = '';
  var session;

  static const _networks = ['Ethereum (Ropsten)', 'Algorand (Testnet)'];
  NetworkType? _network = NetworkType.ethereum;
  TransactionState _state = TransactionState.disconnected;
  TransactionState _state2 = TransactionState.disconnected;
  // TransactionTester? _transactionTester = EthereumTransactionTester();
  late TransactionTester? _transactionTester;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var tasksServices = context.watch<TasksServices>();
    _displayUri = tasksServices.walletConnectUri;
    // if (tasksServices.walletConnectUri != '') {
    //   _displayUri = tasksServices.walletConnectUri;
    // }
    if (tasksServices.walletConnectState == TransactionState.disconnected) {
      tasksServices.walletConnectUri = '';
    }

    // setState(() => _state2 = tasksServices.walletConnectState);
    // if (tasksServices.walletConnectState == null) {
    //   tasksServices.walletConnectState = _state;
    // } else {
    //   setState(() => _state = tasksServices.walletConnectState);
    // }

    return AlertDialog(
      title: Text('Connect your wallet'),
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
              height: 400,
              width: 300,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  (_displayUri.isEmpty)
                      ? Padding(
                          padding: const EdgeInsets.only(
                            left: 16,
                            right: 16,
                            bottom: 16,
                          ),
                          // child: Text(
                          //   'Click to connect ${_network == NetworkType.ethereum ? 'to Ethereum' : 'to Algorand'}',
                          //   style: Theme.of(context).textTheme.headline6,
                          //   textAlign: TextAlign.center,
                          // ),
                        )
                      : QrImage(
                          data: _displayUri,
                          size: 300,
                          gapless: false,
                        ),
                  // ElevatedButton(
                  //   onPressed: _transactionStateToAction(context, state2: _state2),
                  //   // onPressed: (() {}),
                  //   child: Text(
                  //     _transactionStateToString(state: _state),
                  //   ),
                  // ),
                  // ElevatedButton(
                  //   onPressed: () async {
                  //     await tasksServices.transactionTester?.disconnect();
                  //     //await tasksServices.connectWallet();
                  //     // tasksServices.walletConnectState = TransactionState.disconnected;
                  //     // setState(() => _state = TransactionState.disconnected);
                  //   },
                  //   child: Text(
                  //     'Disconnect',
                  //   ),
                  // ),
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 16,
                      right: 16,
                      bottom: 16,
                    ),
                    child: Text(
                      tasksServices.walletConnectConnected
                          ? 'Wallet connected'
                          : 'Wallet disconnected',
                      style: Theme.of(context).textTheme.headline6,
                      textAlign: TextAlign.center,
                    ),
                  )
                ],
              ),
            ),

            // RichText(text: TextSpan(
            //     style: DefaultTextStyle.of(context).style.apply(fontSizeFactor: 1.0),
            //     children: <TextSpan>[
            //
            //       TextSpan(
            //           text: 'Wallet link: \n',
            //           style: const TextStyle(height: 2, fontWeight: FontWeight.bold)),
            //       // TextSpan(
            //       //     text: widget.displayUri,
            //       //     style: DefaultTextStyle.of(context).style.apply(fontSizeFactor: 0.5)
            //       // )
            //     ]
            // )),
          ],
        ),
      ),
      actions: [
        TextButton(
            child: Text('Close'), onPressed: () => Navigator.pop(context)),
        if (tasksServices.walletConnectConnected)
          TextButton(
              child: Text('Disconnect'),
              style: TextButton.styleFrom(
                  primary: Colors.white, backgroundColor: Colors.red),
              onPressed: () async {
                await tasksServices.transactionTester?.disconnect();
                // _transactionStateToAction(context, state: _state);
                setState(() {});
                // Navigator.pop(context);
              }),
        if (!tasksServices.walletConnectConnected)
          TextButton(
            child: Text('Connect'),
            style: TextButton.styleFrom(
                primary: Colors.white, backgroundColor: Colors.green),
            onPressed: _transactionStateToAction(context, state2: _state2),
            // _transactionStateToAction(context, state: _state);
            // setState(() {});
            // Navigator.pop(context)
          ),
      ],
    );

    // return Scaffold(
    //   appBar: AppBar(
    //     title: Text(widget.title),
    //   ),
    //   body: Column(
    //     children: [
    //       Row(
    //         children: [
    //           Expanded(
    //             child: Padding(
    //               padding: const EdgeInsets.only(left: 8),
    //               child: Text('Select network: ',
    //                   style: Theme.of(context).textTheme.headline6),
    //             ),
    //           ),
    //           Padding(
    //             padding: const EdgeInsets.only(right: 8),
    //             child: DropdownButton(
    //                 value: _networks[_network!.index],
    //                 items: _networks
    //                     .map(
    //                       (value) => DropdownMenuItem(
    //                           value: value, child: Text(value)),
    //                     )
    //                     .toList(),
    //                 onChanged: _changeNetworks),
    //           ),
    //         ],
    //       ),
    //       Expanded(
    //         child: Column(
    //           mainAxisAlignment: MainAxisAlignment.center,
    //           children: [
    //             (_displayUri.isEmpty)
    //                 ? Padding(
    //                     padding: const EdgeInsets.only(
    //                       left: 16,
    //                       right: 16,
    //                       bottom: 16,
    //                     ),
    //                     child: Text(
    //                       'Click on the button below to transfer ${_network == NetworkType.ethereum ? '0.0001 Eth from Ethereum' : '0.0001 Algo from the Algorand'} account connected through WalletConnect to the same account.',
    //                       style: Theme.of(context).textTheme.headline6,
    //                       textAlign: TextAlign.center,
    //                     ),
    //                   )
    //                 : QrImage(data: _displayUri),
    //             ElevatedButton(
    //               onPressed: _transactionStateToAction(context, state: _state),
    //               child: Text(
    //                 _transactionStateToString(state: _state),
    //               ),
    //             ),
    //             ElevatedButton(
    //               onPressed: () async {
    //                 await _transactionTester?.disconnect();
    //               },
    //               child: Text(
    //                 'Close',
    //               ),
    //             ),
    //           ],
    //         ),
    //       ),
    //     ],
    //   ),
    // );
  }

  void _changeNetworks(String? network) {
    if (network == null) return null;
    final newNetworkIndex = _networks.indexOf(network);
    final newNetwork = NetworkType.values[newNetworkIndex];

    switch (newNetwork) {
      case NetworkType.algorand:
        _transactionTester = AlgorandTransactionTester();
        break;
      case NetworkType.ethereum:
        _transactionTester = EthereumTransactionTester();
        break;
    }

    setState(
      () => _network = newNetwork,
    );
  }

  String _transactionStateToString({required TransactionState state}) {
    switch (state) {
      case TransactionState.disconnected:
        return 'Connect!';
      case TransactionState.connecting:
        return 'Connecting';
      case TransactionState.connected:
        return 'Session connected..';
      case TransactionState.connectionFailed:
        return 'Connection failed';
      case TransactionState.transferring:
        return 'Transaction in progress...';
      case TransactionState.success:
        return 'Transaction successful';
      case TransactionState.failed:
        return 'Transaction failed';
    }
  }

  String _transactionStateToString2({required TransactionState state}) {
    switch (state) {
      case TransactionState.disconnected:
        return 'Disconnected';
      case TransactionState.connecting:
        return 'Connecting';
      case TransactionState.connected:
        return 'Connected';
      case TransactionState.connectionFailed:
        return 'Connection failed';
      case TransactionState.transferring:
        return 'Transaction in progress...';
      case TransactionState.success:
        return 'Transaction successful';
      case TransactionState.failed:
        return 'Transaction failed';
    }
  }

  // Future<void> connectWallet(BuildContext context) async {
  //   var tasksServices = context.watch<TasksServices>();
  //   session = await _transactionTester?.connect(
  //     onDisplayUri: (uri) => setState(() => _displayUri = uri),
  //   );
  //   if (session == null) {
  //     print('Unable to connect');
  //     // setState(() => _state = TransactionState.failed);
  //     tasksServices.walletConnectState = TransactionState.failed;
  //   } else {
  //     tasksServices.walletConnectState = TransactionState.connected;
  //   }
  // }

  // Future<void> connectWallet3(tasksServices) async {
  //   if (tasksServices.transactionTester == null) {
  //     tasksServices.transactionTester = EthereumTransactionTester();
  //   }
  //   _transactionTester = tasksServices.transactionTester;

  //   var connector = await _transactionTester?.initWalletConnect();

  //   //if (tasksServices.walletConnectState == null ||
  //   // tasksServices.walletConnectState == TransactionState.disconnected) {
  //   if (tasksServices.walletConnectConnected == false) {
  //     print("disconnected");
  //     tasksServices.walletConnectUri = '';
  //     setState(() => _displayUri = '');
  //     setState(() => _state = TransactionState.connecting);
  //     // await _transactionTester?.disconnect();
  //     // connector = await _transactionTester?.initWalletConnect();
  //   }
  //   tasksServices.walletConnectState = TransactionState.connecting;
  //   // Subscribe to events
  //   connector.on('connect', (session) {
  //     print(session);
  //     tasksServices.walletConnectState = TransactionState.connected;
  //     setState(() => _state2 = tasksServices.walletConnectState);
  //     tasksServices.walletConnectConnected = true;
  //   });
  //   connector.on('session_request', (payload) {
  //     print(payload);
  //     // tasksServices.walletConnectState = TransactionState.session_request;
  //   });
  //   connector.on('session_update', (payload) {
  //     print(payload);
  //     // tasksServices.walletConnectState = TransactionState.session_update;
  //   });
  //   connector.on('display_uri', (uri) {
  //     print(uri);
  //     // tasksServices.walletConnectState = TransactionState.session_update;
  //   });
  //   connector.on('disconnect', (session) {
  //     print(session);
  //     tasksServices.walletConnectState = TransactionState.disconnected;
  //     setState(() => _state2 = tasksServices.walletConnectState);
  //     tasksServices.walletConnectConnected = false;
  //     tasksServices.walletConnectUri = '';
  //     setState(() => _displayUri = '');
  //   });
  //   final SessionStatus? session = await _transactionTester?.connect(
  //     onDisplayUri: (uri) => tasksServices.walletConnectUri = uri,
  //   );
  //   setState(() => _displayUri = tasksServices.walletConnectUri);

  //   if (session == null) {
  //     print('Unable to connect');
  //     tasksServices.walletConnectState = TransactionState.failed;
  //   } else if (tasksServices.walletConnectState == TransactionState.connected) {
  //     tasksServices.credentials = await _transactionTester?.getCredentials();
  //     tasksServices.publicAddress =
  //         await _transactionTester?.getPublicAddress(session);
  //   } else {
  //     tasksServices.walletConnectState = TransactionState.failed;
  //   }
  //   setState(() => _state2 = tasksServices.walletConnectState);
  // }

  VoidCallback? _transactionStateToAction(BuildContext context,
      {required TransactionState state2}) {
    var tasksServices = context.watch<TasksServices>();
    if (tasksServices.walletConnectState != null) {
      setState(() => _state2 = tasksServices.walletConnectState);
    }
    switch (state2) {
      // Progress, action disabled
      case TransactionState.connecting:
      case TransactionState.transferring:
      case TransactionState.connected:
        return null;

      // Initiate the connection
      case TransactionState.disconnected:
      case TransactionState.connectionFailed:
        return () async {
          // connectWallet3(tasksServices);
          tasksServices.connectWallet4();
        };

      // Finished
      case TransactionState.success:
      case TransactionState.failed:
        return null;
    }
  }
}
