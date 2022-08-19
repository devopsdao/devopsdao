import 'package:flutter/material.dart';
import 'algorand_transaction_tester.dart';
import 'ethereum_transaction_tester.dart';
import 'transaction_tester.dart';
import 'wallet_connect_lifecycle.dart';
import 'package:qr_flutter/qr_flutter.dart';

import 'package:provider/provider.dart';
import 'package:devopsdao/blockchain/task_services.dart';

void main() {
  runApp(const MyApp());
}

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

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mobile dApp',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyWalletPage(title: 'WalletConnect'),
    );
  }
}

class MyWalletPage extends StatefulWidget {
  const MyWalletPage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyWalletPage> createState() => _MyWalletPageState();
}

class _MyWalletPageState extends State<MyWalletPage> {
  String txId = '';
  String _displayUri = '';

  static const _networks = ['Ethereum (Ropsten)', 'Algorand (Testnet)'];
  NetworkType? _network = NetworkType.ethereum;
  TransactionState _state = TransactionState.disconnected;
  TransactionTester? _transactionTester = EthereumTransactionTester();

  @override
  Widget build(BuildContext context) {
    var tasksServices = context.watch<TasksServices>();
    if (tasksServices.walletConnectUri != '' &&
        tasksServices.walletConnectState != TransactionState.disconnected) {
      _displayUri = tasksServices.walletConnectUri;
    }
    if (tasksServices.walletConnectState == TransactionState.disconnected) {
      tasksServices.walletConnectUri = '';
    }
    if (tasksServices.walletConnectState == null) {
      tasksServices.walletConnectState = _state;
    } else {
      setState(() => _state = tasksServices.walletConnectState);
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: Text('Select network: ',
                      style: Theme.of(context).textTheme.headline6),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 8),
                child: DropdownButton(
                    value: _networks[_network!.index],
                    items: _networks
                        .map(
                          (value) => DropdownMenuItem(
                              value: value, child: Text(value)),
                        )
                        .toList(),
                    onChanged: _changeNetworks),
              ),
            ],
          ),
          Expanded(
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
                        child: Text(
                          'Click on the button below to transfer ${_network == NetworkType.ethereum ? '0.0001 Eth from Ethereum' : '0.0001 Algo from the Algorand'} account connected through WalletConnect to the same account.',
                          style: Theme.of(context).textTheme.headline6,
                          textAlign: TextAlign.center,
                        ),
                      )
                    : QrImage(data: _displayUri),
                ElevatedButton(
                  onPressed: _transactionStateToAction(context, state: _state),
                  child: Text(
                    _transactionStateToString(state: _state),
                  ),
                ),
                ElevatedButton(
                  onPressed: () async {
                    await _transactionTester?.disconnect();
                    setState(() => _state = TransactionState.disconnected);
                    tasksServices.walletConnectState =
                        TransactionState.disconnected;
                    tasksServices.walletConnectUri = '';
                    setState(() => _displayUri = '');
                  },
                  child: Text(
                    'Close',
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
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
        return 'Session connected, preparing transaction...';
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

  VoidCallback? _transactionStateToAction(BuildContext context,
      {required TransactionState state}) {
    var tasksServices = context.watch<TasksServices>();
    switch (state) {
      // Progress, action disabled
      case TransactionState.connecting:
      case TransactionState.transferring:
      case TransactionState.connected:
        return null;

      // Initiate the connection
      case TransactionState.disconnected:
      case TransactionState.connectionFailed:
        return () async {
          tasksServices.walletConnectUri = '';
          setState(() => _displayUri = '');
          setState(() => _state = TransactionState.connecting);
          tasksServices.walletConnectState = TransactionState.connecting;
          final session = await _transactionTester?.connect(
            onDisplayUri: (uri) => setState(() => _displayUri = uri),
          );
          tasksServices.walletConnectUri = _displayUri;
          // final session = await _transactionTester?.createSession(
          //   onDisplayUri: (uri) => setState(() => _displayUri = uri),
          // );

          if (session == null) {
            print('Unable to connect');
            setState(() => _state = TransactionState.failed);
            tasksServices.walletConnectState = TransactionState.failed;
            return;
          }

          setState(() => _state = TransactionState.connected);
          tasksServices.walletConnectState = TransactionState.connected;
          setState(() => _displayUri = '');
          tasksServices.walletConnectUri = '';

          tasksServices.credentials =
              await _transactionTester?.getCredentials();
          tasksServices.publicAddress =
              await _transactionTester?.getPublicAddress(session);
          // tasksServices.publicAddress = _transactionTester?.publicAddress;
          // Future.delayed(const Duration(seconds: 1), () async {
          //   // Initiate the transaction
          //   setState(() => _state = TransactionState.transferring);

          //   try {
          //     await _transactionTester?.signTransaction(session);
          //     setState(() => _state = TransactionState.success);
          //   } catch (e) {
          //     print('Transaction error: $e');
          //     setState(() => _state = TransactionState.failed);
          //   }
          // });
        };

      // Finished
      case TransactionState.success:
      case TransactionState.failed:
        return null;
    }
  }
}
