// import 'package:algorand_dart/algorand_dart.dart';
// import 'package:flutter/material.dart';
// import 'package:qr_flutter/qr_flutter.dart';
// import 'package:walletconnect_dart/walletconnect_dart.dart';
// import 'package:walletconnect_secure_storage/walletconnect_secure_storage.dart';

// void main() {
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'WalletConnect Demo',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       home: const MyHomePage(title: 'WalletConnect Demo Home Page'),
//     );
//   }
// }

// class MyHomePage extends StatefulWidget {
//   const MyHomePage({Key? key, required this.title}) : super(key: key);

//   final String title;

//   @override
//   State<MyHomePage> createState() => _MyHomePageState();
// }

// class _MyHomePageState extends State<MyHomePage> {
//   final algorand = Algorand(
//     algodClient: AlgodClient(apiUrl: AlgoExplorer.MAINNET_ALGOD_API_URL),
//     indexerClient: IndexerClient(apiUrl: AlgoExplorer.MAINNET_INDEXER_API_URL),
//   );

//   // Create a connector
//   late WalletConnect connector;

//   String _displayUri = '';
//   String _account = '';

//   void _changeDisplayUri(String uri) {
//     setState(() {
//       _displayUri = uri;
//     });
//   }

//   Future createSession() async {
//     // Create a new session
//     if (!connector.connected) {
//       final session = await connector.createSession(
//         chainId: 4160,
//         onDisplayUri: (uri) => _changeDisplayUri(uri),
//       );

//       print('Connected: $session');
//     }
//   }

//   Future initWalletConnect() async {
//     // Define a session storage
//     final sessionStorage = WalletConnectSecureStorage();
//     final session = await sessionStorage.getSession();

//     // Create a connector
//     connector = WalletConnect(
//       bridge: 'https://bridge.walletconnect.org',
//       session: session,
//       sessionStorage: sessionStorage,
//       clientMeta: const PeerMeta(
//         name: 'WalletConnect',
//         description: 'WalletConnect Developer App',
//         url: 'https://walletconnect.org',
//         icons: [
//           'https://gblobscdn.gitbook.com/spaces%2F-LJJeCjcLrr53DcT1Ml7%2Favatar.png?alt=media'
//         ],
//       ),
//     );

//     setState(() {
//       _account = session?.accounts.first ?? '';
//     });

//     connector.registerListeners(
//       onConnect: (status) {
//         setState(() {
//           _account = status.accounts[0];
//         });
//       },
//     );
//   }

//   @override
//   void initState() {
//     super.initState();
//     initWalletConnect();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(widget.title),
//       ),
//       body: Column(
//         children: [
//           Center(
//             child: _displayUri.isNotEmpty
//                 ? QrImage(
//                     data: _displayUri,
//                     version: QrVersions.auto,
//                     size: 200.0,
//                   )
//                 : Container(),
//           ),
//           ElevatedButton(
//             child: const Text(
//               'Sign transaction',
//             ),
//             onPressed: () async {
//               final params = await algorand.getSuggestedTransactionParams();

//               final address = Address.fromAlgorandAddress(address: _account);

//               // Build the transaction
//               final transaction = await (PaymentTransactionBuilder()
//                     ..sender = address
//                     ..amount = 0
//                     ..receiver = address
//                     ..suggestedParams = params)
//                   .build();

//               // Sign the transaction
//               final signedTxs = await connector.signTransaction(
//                 transaction.toBytes(),
//                 params: {
//                   'message': 'Payment transaction,',
//                 },
//               );
//             },
//           ),
//           ElevatedButton(
//             child: const Text(
//               'Kill session',
//             ),
//             onPressed: () async {
//               await connector.killSession();
//             },
//           ),
//         ],
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () async {
//           await createSession();
//         },
//         tooltip: 'Connect',
//         child: const Icon(Icons.add),
//       ),
//     );
//   }

//   @override
//   void dispose() {
//     super.dispose();
//     connector.killSession();
//   }
// }
