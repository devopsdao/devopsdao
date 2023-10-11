// import 'package:flutter/cupertino.dart';
// import 'package:webthree/webthree.dart';

// import 'abi/WitnetFacet.g.dart';





// class WitnetServices extends ChangeNotifier {
//   late WitnetFacet witnetFacet;
//   Map<String, Map<String, Map<String, dynamic>>> transactionStatuses = {};

//   late String witnetPostResult = 'check not initialized';
//   late bool witnetAvailabilityResult = false;
//   late List witnetGetLastResult = [false, false, ''];
//   // late String saveSuccessfulWitnetResult = witnetSuccessfulResult;

//   Future<String> postWitnetRequest(EthereumAddress taskAddress, String nanoId) async {
//     print('postWitnetRequest');
//     transactionStatuses[nanoId] = {
//       'postWitnetRequest': {
//         'status': 'pending',
//         'txn': 'initial',
//         'witnetPostResult': 'initialized request',
//         'witnetGetLastResult': [false, false, '']
//       }
//     };
//     witnetPostResult = 'initialized request';
//     notifyListeners();
//     var creds;
//     var senderAddress;
//     if (hardhatDebug == true) {
//       creds = EthPrivateKey.fromHex(hardhatAccounts[0]["key"]);
//       senderAddress = EthereumAddress.fromHex(hardhatAccounts[0]["address"]);
//     } else {
//       creds = credentials;
//       senderAddress = publicAddress;
//     }
//     final transaction = Transaction(from: senderAddress, value: EtherAmount.fromUnitAndValue(EtherUnit.gwei, 10000000), maxGas: 2000000);
//     // maxFeePerGas: EtherAmount.fromUnitAndValue(EtherUnit.gwei, 10000000));

//     // List args = ["devopsdao/devopsdao-smart-contract-diamond", "preparing witnet release"];
//     String txn = await witnetFacet.postRequest$2(taskAddress, credentials: creds, transaction: transaction);
//     transactionStatuses[nanoId]!['postWitnetRequest']!['status'] = 'confirmed';
//     transactionStatuses[nanoId]!['postWitnetRequest']!['txn'] = txn;
//     notifyListeners();
//     tellMeHasItMined(txn, 'postWitnetRequest', nanoId);
//     if (txn.length == 66) {
//       witnetPostResult = 'request mined';
//       witnetGetLastResult = [false, false, 'checking'];
//       transactionStatuses[nanoId]!['postWitnetRequest']!['witnetPostResult'] = 'request mined';
//       transactionStatuses[nanoId]!['postWitnetRequest']!['witnetGetLastResult'] = [false, false, 'checking'];
//       checkWitnetResultAvailabilityTimer(taskAddress, nanoId);
//     } else {
//       witnetPostResult = 'request failed';
//       transactionStatuses[nanoId]!['postWitnetRequest']!['witnetPostResult'] = 'request failed';
//     }
//     notifyListeners();
//     return txn;
//   }

//   Future checkWitnetResultAvailabilityTimer(EthereumAddress taskAddress, String nanoId) async {
//     BigInt appId = BigInt.from(100);
//     Timer.periodic(const Duration(seconds: 15), (timer) async {
//       // print('checkWitnetResultAvailabilityTimer: ${timer.tick}');
//       bool result = await witnetFacet.checkResultAvailability(taskAddress);
//       print('checkWitnetResultAvailabilityTimer: $result');
//       if (result) {
//         var lastResult = await witnetFacet.getLastResult(taskAddress);

//         if (lastResult[0] == false && lastResult[1] == false && lastResult[2] == '') {
//           print('checkWitnetResultAvailabilityTimer: old result received');
//         } else {
//           if (transactionStatuses.containsKey(nanoId)) {
//             witnetPostResult = 'result available';
//           } else {
//             transactionStatuses[nanoId] = {
//               'postWitnetRequest': {
//                 'status': 'confirmed',
//                 'txn': 'none',
//                 'witnetPostResult': 'result available',
//                 'witnetGetLastResult': [false, false, 'checking']
//               }
//             };
//           }
//           witnetAvailabilityResult = result;
//           notifyListeners();
//           getLastWitnetResultTimer(taskAddress, nanoId);
//           getLastWitnetResult(taskAddress, nanoId);
//           timer.cancel();
//         }
//       }
//     });
//     // return result;
//   }

//   Future checkWitnetResultAvailability(EthereumAddress taskAddress, String nanoId) async {
//     BigInt appId = BigInt.from(100);
//     // print(timer.tick);
//     bool result = await witnetFacet.checkResultAvailability(taskAddress);
//     print('checkWitnetResultAvailability: $result');
//     if (result) {
//       var lastResult = await witnetFacet.getLastResult(taskAddress);

//       if (lastResult[0] == false && lastResult[1] == false && lastResult[2] == '') {
//         print('checkWitnetResultAvailability: old result received');
//       } else {
//         if (transactionStatuses.containsKey(nanoId)) {
//           witnetPostResult = 'result available';
//         } else {
//           transactionStatuses[nanoId] = {
//             'postWitnetRequest': {
//               'status': 'confirmed',
//               'txn': 'none',
//               'witnetPostResult': 'result available',
//               'witnetGetLastResult': [false, false, 'checking']
//             }
//           };
//         }
//         witnetAvailabilityResult = result;
//         notifyListeners();
//         getLastWitnetResult(taskAddress, nanoId);
//       }
//     }
//     // return result;
//   }

//   /*
//     getLastWitnetResult returns result array:
//     0 failed: bool,
//     1 pendingMerge: bool,
//     2 status: text(closed/(unmerged))
//   */
//   Future<dynamic> getLastWitnetResultTimer(EthereumAddress taskAddress, String nanoId) async {
//     Timer.periodic(const Duration(seconds: 15), (timer) async {
//       // print(timer.tick);

//       var result = await witnetFacet.getLastResult(taskAddress);
//       print('getLastWitnetResultTimer: $result');

//       transactionStatuses[nanoId]!['postWitnetRequest']!['witnetGetLastResult'] = result;
//       witnetGetLastResult = result;
//       timer.cancel();
//       notifyListeners();
//     });
//   }

//   Future<dynamic> getLastWitnetResult(EthereumAddress taskAddress, String nanoId) async {
//     // print(timer.tick);
//     var result = await witnetFacet.getLastResult(taskAddress);
//     print('getLastWitnetResult: $result');

//     transactionStatuses[nanoId]!['postWitnetRequest']!['witnetGetLastResult'] = result;
//     witnetGetLastResult = result;
//     notifyListeners();
//   }

//   Future<dynamic> saveSuccessfulWitnetResult(EthereumAddress taskAddress, String nanoId) async {
//     print('saveSuccessfulWitnetResult');
//     transactionStatuses[nanoId]!['saveLastWitnetResult'] = {'status': 'pending', 'txn': 'initial'};
//     var creds;
//     var senderAddress;
//     if (hardhatDebug == true) {
//       creds = EthPrivateKey.fromHex(hardhatAccounts[0]["key"]);
//       senderAddress = EthereumAddress.fromHex(hardhatAccounts[0]["address"]);
//     } else {
//       creds = credentials;
//       senderAddress = publicAddress;
//     }
//     final transaction = Transaction(from: senderAddress, maxGas: 2000000);

//     String txn = await witnetFacet.saveSuccessfulResult(taskAddress, credentials: creds, transaction: transaction);
//     transactionStatuses[nanoId]!['saveLastWitnetResult']!['status'] = 'confirmed';
//     transactionStatuses[nanoId]!['saveLastWitnetResult']!['txn'] = txn;
//     notifyListeners();
//     tellMeHasItMined(txn, 'saveLastWitnetResult', nanoId);
//     return txn;
//   }


// }
