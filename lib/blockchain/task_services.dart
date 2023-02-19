// ignore_for_file: unnecessary_import

import 'dart:async';
import 'dart:convert';
import 'dart:ffi';
import 'dart:io';
// import 'dart:js';
import 'dart:math';
import 'package:collection/collection.dart';
import 'package:js/js.dart' if (dart.library.io) 'package:webthree/src/browser/js_stub.dart' if (dart.library.js) 'package:js/js.dart';

import 'package:js/js_util.dart' if (dart.library.io) 'package:webthree/src/browser/js_util_stub.dart' if (dart.library.js) 'package:js/js_util.dart';

import 'package:devopsdao/flutter_flow/flutter_flow_util.dart';
import 'package:nanoid/nanoid.dart';
import 'package:throttling/throttling.dart';

import 'package:jovial_svg/jovial_svg.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:walletconnect_dart/walletconnect_dart.dart';
import 'abi/TaskCreateFacet.g.dart';
import 'abi/TaskDataFacet.g.dart';
import 'abi/TokenFacet.g.dart';
import 'abi/TokenDataFacet.g.dart';
import 'abi/TaskContract.g.dart';
import 'abi/AxelarFacet.g.dart';
import 'abi/HyperlaneFacet.g.dart';
import 'abi/LayerzeroFacet.g.dart';
import 'abi/WormholeFacet.g.dart';
// import 'abi/Wormhole.g.dart';
import 'abi/IERC20.g.dart';
import 'accounts.dart';
import 'task.dart';
import "package:universal_html/html.dart" hide Platform;
import 'package:webthree/browser.dart'
    if (dart.library.io) 'package:webthree/src/browser/dart_wrappers_stub.dart'
    if (dart.library.js) 'package:webthree/browser.dart';
import 'package:webthree/webthree.dart';
import 'package:http/http.dart' as http;
import 'package:web_socket_channel/io.dart';
// if (dart.library.html) 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
// import 'dart:io' if (dart.library.html) 'dart:html';

import '../wallet/ethereum_walletconnect_transaction.dart';
import '../wallet/main.dart';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
// import 'package:device_info_plus/device_info_plus.dart';
import 'package:browser_detector/browser_detector.dart' hide Platform;

import 'package:package_info_plus/package_info_plus.dart';

import 'package:g_json/g_json.dart';

// import 'dart:html' hide Platform;

Object mapToJsObject(Map map) {
  var object = newObject();
  map.forEach((k, v) {
    if (v is Map) {
      setProperty(object, k, mapToJsObject(v));
    } else {
      setProperty(object, k, v);
    }
  });
  return object;
}

Map jsObjectToMap(dynamic jsObject) {
  Map result = {};
  List keys = _objectKeys(jsObject);
  for (dynamic key in keys) {
    dynamic value = getProperty(jsObject, key);
    List nestedKeys = [];
    if (value is List) {
      nestedKeys = objectKeys(value);
    }
    if ((nestedKeys).isNotEmpty) {
      //nested property
      result[key] = jsObjectToMap(value);
    } else {
      result[key] = value;
    }
  }
  return result;
}

List<String> objectKeys(dynamic jsObject) {
  // if (jsObject == null || jsObject is String || jsObject is num || jsObject is bool) return;
  return _objectKeys(jsObject);
}

@JS('Object.keys')
external List<String> _objectKeys(jsObject);

@JS()
@anonymous
class JSrawRequestSwitchChainParams {
  external String get chainId;

  // Must have an unnamed factory constructor with named arguments.
  external factory JSrawRequestSwitchChainParams({String chainId});
}

@JS()
@anonymous
class JSrawRequestAddChainParams {
  // external String get params;
  external String get chainId;
  external String get chainName;
  external Map<String, dynamic> get nativeCurrency;
  external List get rpcUrls;
  external String get blockExplorerUrls;
  external String get iconUrls;
  //   final params = <String, dynamic>{
  //   'chainId': '0x507',
  //   'chainName': 'Moonbase alpha',
  //   'nativeCurrency': <String, dynamic>{
  //     'name': 'DEV',
  //     'symbol': 'DEV',
  //     'decimals': 18,
  //   },
  //   'rpcUrls': ['https://rpc.api.moonbase.moonbeam.network'],
  //   'blockExplorerUrls': ['https://moonbase.moonscan.io'],
  //   'iconUrls': [''],
  // };

  // Must have an unnamed factory constructor with named arguments.
  external factory JSrawRequestAddChainParams(
      {String chainId, String chainName, Map<String, dynamic> nativeCurrency, List rpcUrls, List blockExplorerUrls, List iconUrls});
  // Must have an unnamed factory constructor with named arguments.
  // external factory JSrawRequestAddChainParams({params});
}

@JS('JSON.stringify')
external String stringify(Object obj);

// Object jsToDart(jsObject) {
//   if (jsObject is JsArray || jsObject is Iterable) {
//     return jsObject.map(jsToDart).toList();
//   }
//   if (jsObject is JsObject) {
//     return Map.fromIterable(
//       getObjectKeys(jsObject),
//       value: (key) => jsToDart(jsObject[key]),
//     );
//   }
//   return jsObject;
// }

// List<String> getObjectKeys(JsObject object) => context['Object']
//     .callMethod('getOwnPropertyNames', [object])
//     .toList()
//     .cast<String>();

class GetTaskException implements Exception {
  String getTaskExceptionMsg() => 'Oops! something went wrong';
}

class TasksServices extends ChangeNotifier {
  bool hardhatDebug = false;
  bool hardhatLive = true;
  Map<String, Task> tasks = {};
  Map<String, Task> filterResults = {};
  Map<String, Task> tasksNew = {};
  Map<String, Task> tasksAuditPending = {};
  Map<String, Task> tasksAuditApplied = {};
  Map<String, Task> tasksAuditWorkingOn = {};
  Map<String, Task> tasksAuditComplete = {};

  Map<String, Task> tasksPerformerParticipate = {};
  Map<String, Task> tasksPerformerProgress = {};
  Map<String, Task> tasksPerformerComplete = {};

  Map<String, Task> tasksCustomerSelection = {};
  Map<String, Task> tasksCustomerProgress = {};
  Map<String, Task> tasksCustomerComplete = {};

  Map<String, Account> accountsTemp = {
    '1': Account(nickName: 'Als', about: 'about', walletAddress: EthereumAddress.fromHex('0x0000000000000000000000000000000000000000'), rating: 5),
    '2': Account(
        nickName: 'MyNameIsC',
        about: 'about super puper MyNameIsC',
        walletAddress: EthereumAddress.fromHex('0x0000000000000000000000000000000000000222'),
        rating: 12),
    '3': Account(
        nickName: 'Huh', about: 'super HUH', walletAddress: EthereumAddress.fromHex('0x0000000000000000000000000000000000000333'), rating: 342),
  };

  Map<String, Map<String, Map<String, String>>> transactionStatuses = {};

  bool transportEnabled = true;
  String transportUsed = '';
  String interchainSelected = 'axelar';
  EthereumAddress transportAxelarAdr = EthereumAddress.fromHex('0x0000000000000000000000000000000000000000');
  EthereumAddress transportHyperlaneAdr = EthereumAddress.fromHex('0x0000000000000000000000000000000000000000');

  var credentials;
  EthereumAddress? publicAddress;
  EthereumAddress? publicAddressWC;
  EthereumAddress? publicAddressMM;
  var wallectConnectTransaction;

  var walletConnectState;
  bool walletConnected = false;
  bool walletConnectedWC = false;
  bool walletConnectedMM = false;
  bool mmAvailable = false;
  String walletConnectUri = '';
  String walletConnectSessionUri = '';
  var walletConnectSession;
  // bool walletConnectActionApproved = false;
  late Map<String, dynamic> roleNfts = {'auditor': 0, 'governor': 0};

  var eth;
  String lastTxn = '';

  String platform = 'mobile';
  String? browserPlatform;

  String version = '';
  String buildNumber = '';
  //final String _rpcUrl = 'https://rpc.api.moonbase.moonbeam.network';
  //final String _wsUrl = 'wss://wss.api.moonbase.moonbeam.network';

  late String _rpcUrl;
  late String _wsUrl;

  late String _rpcUrlMoonbeam;
  late String _wsUrlMoonbeam;

  late String _rpcUrlMatic;
  late String _wsUrlMatic;

  late String _rpcUrlGoerli;
  late String _wsUrlGoerli;

  int chainId = 0;
  int chainIdAxelar = 80001;
  int chainIdHyperlane = 80001;
  int chainIdLayerzero = 80001;
  int chainIdWormhole = 80001;

  bool isLoading = true;
  bool isLoadingBackground = false;

  late Web3Client _web3client;
  late Web3Client _web3clientAxelar;
  late Web3Client _web3clientHyperlane;
  late Web3Client _web3clientLayerzero;
  late Web3Client _web3clientWormhole;

  bool isDeviceConnected = false;

  late IERC20 ierc20;

  TasksServices() {
    try {
      if (Platform.isAndroid || Platform.isIOS) {
        platform = 'mobile';
      } else if (Platform.isLinux) {
        platform = 'linux';
      }
    } catch (e) {
      platform = 'web';
    }
    print("platform:" + platform);
    init();
  }

  bool initComplete = false;
  Future<void> init() async {
    // final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
    // WebBrowserInfo webBrowserInfo = await deviceInfoPlugin.webBrowserInfo;

    final BrowserDetector browserInfo = BrowserDetector();
    if (browserInfo.platform.isAndroid) {
      browserPlatform = 'android';
    }
    if (browserInfo.platform.isIOS) {
      browserPlatform = 'ios';
    }
    if (platform == 'web' && window.ethereum != null) {
      mmAvailable = true;
    }

    if (hardhatDebug == true || hardhatLive == true) {
      chainId = 31337;
      _rpcUrl = 'http://localhost:8545';
      _wsUrl = 'ws://localhost:8545';
    } else {
      chainId = 1287;
      _rpcUrl = 'https://moonbeam-alpha.api.onfinality.io/rpc?apikey=a574e9f5-b1db-4984-8362-89b749437b81';
      _wsUrl = 'wss://moonbeam-alpha.api.onfinality.io/rpc?apikey=a574e9f5-b1db-4984-8362-89b749437b81';
      // _rpcUrl = 'https://moonbase-alpha.blastapi.io/5adb17c5-f79f-4542-b37c-b9cf98d6b28f';
      // _wsUrl = 'wss://moonbase-alpha.blastapi.io/5adb17c5-f79f-4542-b37c-b9cf98d6b28f';

      // _rpcUrl = 'https://matic-mumbai.chainstacklabs.com';
      // _wsUrl = 'wss://ws-matic-mumbai.chainstacklabs.com';

      _rpcUrlMoonbeam = 'https://moonbase-alpha.blastapi.io/5adb17c5-f79f-4542-b37c-b9cf98d6b28f';
      _wsUrlMoonbeam = 'wss://moonbase-alpha.blastapi.io/5adb17c5-f79f-4542-b37c-b9cf98d6b28f';

      _rpcUrlMatic = 'https://matic-mumbai.chainstacklabs.com';
      _wsUrlMatic = 'wss://ws-matic-mumbai.chainstacklabs.com';

      _rpcUrlGoerli = 'https://rpc.ankr.com/eth_goerli';
      _wsUrlGoerli = 'wss://rpc.ankr.com/eth_goerli';
      // _rpcUrl = 'https://rpc.api.moonbase.moonbeam.network';
      // _wsUrl = 'wss://wss.api.moonbase.moonbeam.network';
    }
    isDeviceConnected = false;

    if (platform != 'web') {
      final StreamSubscription subscription = Connectivity().onConnectivityChanged.listen((ConnectivityResult result) async {
        if (result != ConnectivityResult.none) {
          isDeviceConnected = await InternetConnectionChecker().hasConnection;
          // await getTransferFee(sourceChainName: 'moonbeam', destinationChainName: 'ethereum', assetDenom: 'uausdc', amountInDenom: 100000);
        }
      });
    }

    if (wallectConnectTransaction == null) {
      wallectConnectTransaction = EthereumWallectConnectTransaction();
    }
    await wallectConnectTransaction?.initSession();
    await wallectConnectTransaction?.removeSession();
    _web3client = Web3Client(
      _rpcUrl,
      http.Client(),
      socketConnector: () {
        if (platform == 'web') {
          final uri = Uri.parse(_wsUrl);
          return WebSocketChannel.connect(uri).cast<String>();
        } else {
          return IOWebSocketChannel.connect(_wsUrl).cast<String>();
        }
      },
    );
    // templorary fix:
    if (hardhatLive == false) {
      _web3clientAxelar = Web3Client(
        _rpcUrlMatic,
        http.Client(),
        socketConnector: () {
          if (platform == 'web') {
            final uri = Uri.parse(_wsUrlMatic);
            return WebSocketChannel.connect(uri).cast<String>();
          } else {
            return IOWebSocketChannel.connect(_wsUrlMatic).cast<String>();
          }
        },
      );
      _web3clientHyperlane = Web3Client(
        _rpcUrlMatic,
        http.Client(),
        socketConnector: () {
          if (platform == 'web') {
            final uri = Uri.parse(_wsUrlMatic);
            return WebSocketChannel.connect(uri).cast<String>();
          } else {
            return IOWebSocketChannel.connect(_wsUrlMatic).cast<String>();
          }
        },
      );
      _web3clientLayerzero = Web3Client(
        _rpcUrlMatic,
        http.Client(),
        socketConnector: () {
          if (platform == 'web') {
            final uri = Uri.parse(_wsUrlMatic);
            return WebSocketChannel.connect(uri).cast<String>();
          } else {
            return IOWebSocketChannel.connect(_wsUrlMatic).cast<String>();
          }
        },
      );
      _web3clientWormhole = Web3Client(
        _rpcUrlMatic,
        http.Client(),
        socketConnector: () {
          if (platform == 'web') {
            final uri = Uri.parse(_wsUrlMatic);
            return WebSocketChannel.connect(uri).cast<String>();
          } else {
            return IOWebSocketChannel.connect(_wsUrlMatic).cast<String>();
          }
        },
      );
    }

    await startup();
    // await getABI();
    // await getDeployedContract();

    if (platform == 'web') {}

    initComplete = true;
    // testTaskCreation();
  }

  late ContractAbi _abiCode;

  late num totalTaskLen = 0;
  int tasksLoaded = 0;
  late EthereumAddress _contractAddress;
  late EthereumAddress _contractAddressAxelar;
  late EthereumAddress _contractAddressHyperlane;
  late EthereumAddress _contractAddressLayerzero;
  late EthereumAddress _contractAddressWormhole;
  EthereumAddress zeroAddress = EthereumAddress.fromHex('0x0000000000000000000000000000000000000000');
  // Future<void> getABI() async {
  //   // String abiFile =
  //   //     await rootBundle.loadString('lib/blockchain/abi/TasksFacet.json');

  //   // var jsonABI = jsonDecode(abiFile);
  //   // _abiCode = ContractAbi.fromJson(jsonEncode(jsonABI), 'TasksFacet');

  //   String addressesFile = await rootBundle.loadString('lib/blockchain/abi/addresses.json');
  //   var addresses = jsonDecode(addressesFile);
  //   _contractAddress = EthereumAddress.fromHex(addresses["Diamond"]);

  //   String addressesFileAxelar = await rootBundle.loadString('lib/blockchain/abi/axelar-addresses.json');
  //   var addressesAxelar = jsonDecode(addressesFileAxelar);
  //   _contractAddressAxelar = EthereumAddress.fromHex(addressesAxelar["Diamond"]);

  //   String addressesFileHyperlane = await rootBundle.loadString('lib/blockchain/abi/hyperlane-addresses.json');
  //   var addressesHyperlane = jsonDecode(addressesFileHyperlane);
  //   _contractAddressHyperlane = EthereumAddress.fromHex(addressesHyperlane["Diamond"]);
  // }

  bool validChainID = false;
  bool validChainIDWC = false;
  bool validChainIDMM = false;
  bool closeWalletDialog = false;

  Future<void> connectWalletWC(bool refresh) async {
    print('async');
    if (wallectConnectTransaction != null) {
      var connector = await wallectConnectTransaction.initWalletConnect();

      if (walletConnected == false) {
        print("disconnected");
        walletConnectUri = '';
        walletConnectSessionUri = '';
      }
      // Subscribe to events
      connector.on('connect', (session) {
        walletConnectSession = session;
        walletConnectState = TransactionState.connected;
        walletConnected = true;
        walletConnectedWC = true;
        closeWalletDialog = true;
        () async {
          if (hardhatDebug == false) {
            credentials = await wallectConnectTransaction?.getCredentials();
            chainId = session.chainId;
            if (chainId == 1287 ||
                chainId == chainIdAxelar ||
                chainId == chainIdHyperlane ||
                chainId == chainIdLayerzero ||
                chainId == chainIdWormhole) {
              validChainID = true;
              validChainIDWC = true;
            } else {
              validChainID = false;
              validChainIDWC = false;
              await switchNetworkWC();
            }
            publicAddressWC = await wallectConnectTransaction?.getPublicAddress(session);
            publicAddress = publicAddressWC;
          } else {
            chainId = 31337;
            validChainID = true;
          }
          List<EthereumAddress> taskList = await getTaskListFull();
          await fetchTasksBatch(taskList);

          myBalance();
          isLoading = true;
        }();
        notifyListeners();
      });
      connector.on('session_request', (payload) {
        print(payload);
      });
      connector.on('session_update', (payload) {
        print(payload);
        if (payload.approved == true) {
          // walletConnectActionApproved = true;
          // notifyListeners();
        }
      });
      connector.on('disconnect', (session) async {
        print(session);
        walletConnectState = TransactionState.disconnected;
        walletConnected = false;
        walletConnectedWC = false;
        publicAddress = null;
        publicAddressWC = null;
        validChainID = false;
        validChainIDWC = false;
        ethBalance = 0;
        ethBalanceToken = 0;
        pendingBalance = 0;
        pendingBalanceToken = 0;
        walletConnectUri = '';
        walletConnectSessionUri = '';
        List<EthereumAddress> taskList = await getTaskListFull();
        await fetchTasksBatch(taskList);

        await connectWalletWC(true);
        notifyListeners();
      });
      final SessionStatus? session = await wallectConnectTransaction?.connect(
        onDisplayUri: (uri) => {
          walletConnectSessionUri = uri.split("?").first,
          (platform == 'mobile' || browserPlatform == 'android' || browserPlatform == 'ios') && !refresh
              ? {launchURL(uri), walletConnectUri = uri}
              : walletConnectUri = uri,
          notifyListeners()
        },
      );

      if (session == null) {
        print('Unable to connect');
        walletConnectState = TransactionState.failed;
      } else if (walletConnected == true) {
        if (hardhatDebug == false) {
          credentials = await wallectConnectTransaction?.getCredentials();
        }
        publicAddressWC = await wallectConnectTransaction?.getPublicAddress(session);
        publicAddress = publicAddressWC;
      } else {
        walletConnectState = TransactionState.failed;
      }
    } else {
      print("not initialized");
      print(walletConnectState);
    }
  }

  Future<void> connectWalletMM() async {
    if (platform == 'web' && window.ethereum != null) {
      final eth = window.ethereum;

      if (eth == null) {
        print('MetaMask is not available');
        return;
      }
      var ethRPC = eth.asRpcService();

      final client = Web3Client.custom(ethRPC);
      bool userRejected = false;
      try {
        credentials = await eth.requestAccount();
      } catch (e) {
        userRejected = true;
        print(e);
      }
      if (!userRejected && credentials != null) {
        publicAddressMM = credentials.address;
        publicAddress = publicAddressMM;
        walletConnected = true;
        walletConnectedMM = true;
        closeWalletDialog = true;
        late final chainIdHex;
        try {
          chainIdHex = await eth.rawRequest('eth_chainId');
        } catch (e) {
          String errorJson = stringify(e);
          final error = JSON.parse(errorJson);
          if (error['code'] == 4902) {}
          print(e);
        }
        if (chainIdHex != null) {
          chainId = int.parse(chainIdHex);
        }
        if (chainId == 1287 || chainId == chainIdAxelar || chainId == chainIdHyperlane || chainId == chainIdLayerzero || chainId == chainIdWormhole) {
          validChainID = true;
          validChainIDMM = true;
        } else {
          validChainID = false;
          validChainIDMM = false;
          print('invalid chainId $chainId');
          await switchNetworkMM();
        }
        if (walletConnected && walletConnectedMM && validChainID) {
          // fetchTasksByState("new");
          List<EthereumAddress> taskList = await getTaskListFull();
          await fetchTasksBatch(taskList);

          myBalance();
          notifyListeners();
        }
      }

      // walletConnected = true;

// Subscribe to events
      // var connectStream = eth.connect;
      // connectStream.listen((event) {
      //   print(event);
      // });
      // var disconnectStream = eth.disconnect;
      // disconnectStream.listen((event) {
      //   print(event);
      // });
      // var connect = eth.stream('connect').listen((event) {
      //   print(event);
      // });
      // var disconnect = eth.stream('disconnect').listen((event) {
      //   print(event);
      // });
      // eth.on('connect', (session) {
      //   print(session);
      //   walletConnected = true;
      //   () async {
      //     if (hardhatDebug == false) {
      //       credentials = await eth.requestAccount();
      //       publicAddress = credentials.address;
      //       final chainIdHex = await eth.rawRequest('eth_chainId');
      //       int chainId = int.parse(chainIdHex);
      //       if (chainId == 1287) {
      //         validChainID = true;
      //       } else {
      //         validChainID = false;
      //       }
      //     } else {
      //       chainId = 31337;
      //       validChainID = true;
      //     }
      //     fetchTasks();
      //     myBalance();
      //     isLoading = true;
      //   }();
      //   notifyListeners();
      // });

      // eth.on('disconnect', (session) {
      //   print(session);
      //   walletConnected = false;
      //   publicAddress = null;
      //   ethBalance = 0;
      //   ethBalanceToken = 0;
      //   pendingBalance = 0;
      //   pendingBalanceToken = 0;
      //   notifyListeners();
      // });
    } else {
      print("eth not initialized");
    }
  }

  Future<void> switchNetworkMM() async {
    final eth = window.ethereum;
    if (eth == null) {
      print('MetaMask is not available');
      return;
    }
    late final String chainIdHex;
    bool chainChangeRequest = false;
    bool userRejected = false;
    bool chainNotAdded = false;
    try {
      await eth.rawRequest('wallet_switchEthereumChain', params: [JSrawRequestSwitchChainParams(chainId: '0x507')]);
      chainChangeRequest = true;
    } catch (e) {
      var error = jsObjectToMap(e);
      if (error['code'] == 4902) {
        chainNotAdded = true;
        addNetworkMM();
      } else {
        userRejected = true;
      }
      // print(err);
    }
    if (!userRejected && chainChangeRequest) {
      try {
        // chainIdHex = await eth.rawRequest('eth_chainId');
        chainIdHex = await _web3client.makeRPCCall('eth_chainId');
      } catch (e) {
        print(e);
      }
      if (chainIdHex != null) {
        chainId = int.parse(chainIdHex);
      }
      if (chainId == 1287 || chainId == chainIdAxelar || chainId == chainIdHyperlane || chainId == chainIdLayerzero || chainId == chainIdWormhole) {
        validChainID = true;
        validChainIDMM = true;
        publicAddress = publicAddressMM;
        List<EthereumAddress> taskList = await getTaskListFull();
        await fetchTasksBatch(taskList);
        myBalance();
      } else {
        validChainID = false;
        validChainIDMM = false;
      }
    }
    notifyListeners();
  }

  Future<void> switchNetworkWC() async {
    // final eth = window.ethereum;
    // if (eth == null) {
    //   print('MetaMask is not available');
    //   return;
    // }
    late final String chainIdHex;
    bool chainChangeRequest = false;
    var chainIdWC;
    try {
      // final params = <String, dynamic>{
      //   'chainId': '0x507',
      // };
      var result = await wallectConnectTransaction?.switchNetwork('0x507');
      // await _web3client.makeRPCCall('wallet_switchEthereumChain', [params]);
      chainChangeRequest = true;
    } catch (e) {
      chainChangeRequest = false;
      WalletConnectException error = e as WalletConnectException;
      print(e);
      if (error.message == 'Unrecognized chain ID "0x507". Try adding the chain using wallet_addEthereumChain first.') {
        addNetworkWC();
      }
    }
    if (chainChangeRequest == true) {
      try {
        // chainId = walletConnectSession.chainId;
        // chainId = await wallectConnectTransaction?.getChainId();
        chainIdHex = await _web3client.makeRPCCall('eth_chainId');
      } catch (e) {
        print(e);
      }
      if (chainIdHex != null) {
        chainId = int.parse(chainIdHex);
      }
      if (chainId == 1287 || chainId == chainIdAxelar || chainId == chainIdHyperlane || chainId == chainIdLayerzero || chainId == chainIdWormhole) {
        validChainID = true;
        validChainIDWC = true;
        publicAddress = publicAddressWC;
        List<EthereumAddress> taskList = await getTaskListFull();
        await fetchTasksBatch(taskList);
        myBalance();
      } else {
        validChainID = false;
        validChainIDWC = false;
      }
    }
    notifyListeners();
  }

  Future<void> addNetworkMM() async {
    final eth = window.ethereum;
    if (eth == null) {
      print('MetaMask is not available');
      return;
    }
    late final String chainIdHex;
    bool chainAddRequest = false;
    bool userRejected = false;
    try {
      final params = <String, dynamic>{
        'chainId': '0x507',
        'chainName': 'Moonbase alpha',
        'nativeCurrency': <String, dynamic>{
          'name': 'DEV',
          'symbol': 'DEV',
          'decimals': 18,
        },
        'rpcUrls': ['https://rpc.api.moonbase.moonbeam.network'],
        'blockExplorerUrls': ['https://moonbase.moonscan.io'],
        'iconUrls': [''],
      };
      // await eth.rawRequest('wallet_switchEthereumChain',
      //     params: [JSrawRequestAddChainParams(params: params)]);
      await eth.rawRequest('wallet_addEthereumChain', params: [
        // JSrawRequestAddChainParams(
        //   chainId: params['chainId'],
        //   nativeCurrency: params['nativeCurrency'],
        //   rpcUrls: params['rpcUrls'],
        //   chainName: params['chainName'],
        //   blockExplorerUrls: params['blockExplorerUrls'],
        //   // iconUrls: params['iconUrls']
        // )
        mapToJsObject(params)
      ]);
      chainAddRequest = true;
    } catch (e) {
      userRejected = true;
      var error = jsObjectToMap(e);
      if (error['code'] == 4902) {
      } else {}
    }

    if (!userRejected && chainAddRequest) {
      try {
        // chainIdHex = await eth.rawRequest('eth_chainId');
        chainIdHex = await _web3client.makeRPCCall('eth_chainId');
      } catch (e) {
        print(e);
      }
      if (chainIdHex != null) {
        chainId = int.parse(chainIdHex);
      }
      if (chainId == 1287 || chainId == chainIdAxelar || chainId == chainIdHyperlane || chainId == chainIdLayerzero || chainId == chainIdWormhole) {
        validChainID = true;
        validChainIDMM = true;
        publicAddress = publicAddressMM;
        List<EthereumAddress> taskList = await getTaskListFull();
        await fetchTasksBatch(taskList);
        myBalance();
      } else {
        validChainID = false;
        validChainIDMM = false;
      }
    }
    notifyListeners();
  }

  Future<void> addNetworkWC() async {
    // final eth = window.ethereum;
    // if (eth == null) {
    //   print('MetaMask is not available');
    //   return;
    // }
    late final String chainIdHex;
    bool chainAddRequest = false;
    var chainIdWC;
    try {
      // final params = <String, dynamic>{
      //   'chainId': '0x507',
      // };
      var result = await wallectConnectTransaction?.addNetwork('0x507');
      // await _web3client.makeRPCCall('wallet_switchEthereumChain', [params]);
      chainAddRequest = true;
    } catch (e) {
      chainAddRequest = false;
      print(e);
    }
    if (chainAddRequest == true) {
      try {
        // chainId = walletConnectSession.chainId;
        // chainId = await wallectConnectTransaction?.getChainId();
        chainIdHex = await _web3client.makeRPCCall('eth_chainId');
      } catch (e) {
        print(e);
      }
      if (chainIdHex != null) {
        chainId = int.parse(chainIdHex);
      }
      if (chainId == 1287 || chainId == chainIdAxelar || chainId == chainIdHyperlane || chainId == chainIdLayerzero || chainId == chainIdWormhole) {
        validChainID = true;
        validChainIDWC = true;
        publicAddress = publicAddressWC;
        List<EthereumAddress> taskList = await getTaskListFull();
        await fetchTasksBatch(taskList);
        myBalance();
      } else {
        validChainID = false;
        validChainIDWC = false;
      }
    }
    notifyListeners();
  }

  Future<void> disconnectMM() async {
    walletConnected = false;
    walletConnectedMM = false;
    publicAddress = null;
    publicAddressMM = null;
    validChainID = false;
    validChainIDMM = false;
    ethBalance = 0;
    ethBalanceToken = 0;
    pendingBalance = 0;
    pendingBalanceToken = 0;
    List<EthereumAddress> taskList = await getTaskListFull();
    await fetchTasksBatch(taskList);
    notifyListeners();
  }

  Future<void> disconnectWC() async {
    await wallectConnectTransaction?.disconnect();
    walletConnected = false;
    walletConnectedWC = false;
    publicAddress = null;
    publicAddressWC = null;
    validChainID = false;
    validChainIDWC = false;
    ethBalance = 0;
    ethBalanceToken = 0;
    pendingBalance = 0;
    pendingBalanceToken = 0;
    walletConnectUri = '';
    walletConnectSessionUri = '';
    List<EthereumAddress> taskList = await getTaskListFull();
    await fetchTasksBatch(taskList);
    connectWalletWC(true);
    notifyListeners();
  }

  // Future<void> disconnectWalletMM() {
  //   final eth = window.ethereum;
  //   // eth?.cancel();
  // }

  Future<List<dynamic>> web3Call({
    EthereumAddress? sender,
    required DeployedContract contract,
    required ContractFunction function,
    required List<dynamic> params,
    BlockNum? atBlock,
  }) {
    var response;
    try {
      response = _web3client.call(sender: sender, contract: contract, function: function, params: params, atBlock: atBlock);
    } catch (e) {
      print(e);
    } finally {
      return response;
    }
  }

  Future<String> web3Transaction(Credentials cred, Transaction transaction, {int? chainId = 1, bool fetchChainIdFromNetworkId = false}) async {
    var response;
    try {
      response = _web3client.sendTransaction(cred, transaction, chainId: chainId, fetchChainIdFromNetworkId: fetchChainIdFromNetworkId);
    } catch (e) {
      print(e);
    } finally {
      return response;
    }
  }

  Future<TransactionReceipt?> web3GetTransactionReceipt(String hash) async {
    var response;
    try {
      response = _web3client.getTransactionReceipt(hash);
    } catch (e) {
      print(e);
    } finally {
      return response;
    }
  }

  Future<EtherAmount> web3GetBalance(EthereumAddress address, {BlockNum? atBlock}) async {
    var response;
    try {
      response = _web3client.getBalance(address, atBlock: atBlock);
    } catch (e) {
      print(e);
    } finally {
      return response;
    }
  }

  Future<BigInt> web3GetBalanceToken(EthereumAddress address, String symbol, {BlockNum? atBlock}) async {
    var response;
    try {
      response = await ierc20.balanceOf(address);
    } catch (e) {
      print(e);
    } finally {
      return response;
    }
  }

  Future<BigInt> getAuditorNFTBalance(EthereumAddress address, String symbol, {BlockNum? atBlock}) async {
    var response;
    try {
      response = await tokenFacet.balanceOf(publicAddress!, BigInt.from(1));
    } catch (e) {
      print(e);
    } finally {
      return response;
    }
  }

  late dynamic backgroundSVG;

  // late dynamic credentials;
  late dynamic hardhatAccounts;
  double? ethBalance = 0;
  double? ethBalanceToken = 0;
  double? pendingBalance = 0;
  double? pendingBalanceToken = 0;
  int score = 0;
  int scoredTaskCount = 0;
  double myScore = 0.0;

  late TaskCreateFacet taskCreateFacet;
  late TaskDataFacet taskDataFacet;
  late TokenFacet tokenFacet;
  late TokenDataFacet tokenDataFacet;
  late AxelarFacet axelarFacet;
  late HyperlaneFacet hyperlaneFacet;
  late LayerzeroFacet layerzeroFacet;
  late WormholeFacet wormholeFacet;
  // late TaskContract taskContract;

  late DeployedContract _deployedContract;
  late ContractFunction _withdraw;

  late Debouncing thr;
  late String searchKeyword = '';

  Future<void> listenToEvents() async {
    final JobContractCreated = _deployedContract.event('JobContractCreated');
    final subscription = _web3client.events(FilterOptions.events(contract: _deployedContract, event: JobContractCreated)).listen((event) {
      final decoded = JobContractCreated.decodeResults(event.topics!, event.data!);
      //
      print('event fired');
    });
  }

  late Map fees;
  Future<void> startup() async {
    WidgetsFlutterBinding.ensureInitialized();

    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    version = packageInfo.version;
    buildNumber = packageInfo.buildNumber;
    print('version $version-$buildNumber');

    backgroundSVG = await ScalableImage.fromSvgAsset(rootBundle, 'assets/images/red_cat_logo.svg');

    String addressesFile = await rootBundle.loadString('lib/blockchain/abi/addresses.json');
    var addresses = jsonDecode(addressesFile);
    _contractAddress = EthereumAddress.fromHex(addresses['contracts'][chainId.toString()]["Diamond"]);

    if (hardhatLive == false) {
      String addressesFileAxelar = await rootBundle.loadString('lib/blockchain/abi/axelar-addresses.json');
      var addressesAxelar = jsonDecode(addressesFileAxelar);
      _contractAddressAxelar = EthereumAddress.fromHex(addressesAxelar['contracts'][chainIdAxelar.toString()]["Diamond"]);

      String addressesFileHyperlane = await rootBundle.loadString('lib/blockchain/abi/hyperlane-addresses.json');
      var addressesHyperlane = jsonDecode(addressesFileHyperlane);
      _contractAddressHyperlane = EthereumAddress.fromHex(addressesHyperlane['contracts'][chainIdHyperlane.toString()]["Diamond"]);

      String addressesFileLayerzero = await rootBundle.loadString('lib/blockchain/abi/layerzero-addresses.json');
      var addressesLayerzero = jsonDecode(addressesFileLayerzero);
      _contractAddressLayerzero = EthereumAddress.fromHex(addressesLayerzero['contracts'][chainIdLayerzero.toString()]["Diamond"]);

      String addressesFileWormhole = await rootBundle.loadString('lib/blockchain/abi/wormhole-addresses.json');
      var addressesWormhole = jsonDecode(addressesFileWormhole);
      _contractAddressWormhole = EthereumAddress.fromHex(addressesWormhole['contracts'][chainIdWormhole.toString()]["Diamond"]);
    }

    if (hardhatDebug == true || hardhatLive == true) {
      Random random = Random();
      int randomNum = random.nextInt(2);

      String hardhatAccountsFile = await rootBundle.loadString('lib/blockchain/accounts/hardhat.json');
      hardhatAccounts = jsonDecode(hardhatAccountsFile);
      credentials = EthPrivateKey.fromHex(hardhatAccounts[0]["key"]);
      publicAddress = EthereumAddress.fromHex(hardhatAccounts[0]["address"]);
      walletConnected = true;
      validChainID = true;
    }

    thr = Debouncing(duration: const Duration(seconds: 10));
    await connectContracts();
    // thr.debounce(() {
    // fetchTasksByState("new");
    List<EthereumAddress> taskList = await getTaskListFull();
    await fetchTasksBatch(taskList); // to fix enable fetchTasks
    await Future.delayed(const Duration(milliseconds: 200));
    await monitorTasks(taskList);
    await Future.delayed(const Duration(milliseconds: 200));
    // });
    await myBalance();
    await Future.delayed(const Duration(milliseconds: 200));
    await monitorEvents();

    // fees = await _web3client.getGasInEIP1559();
    // print(fees);
    // print("maxFeePerGas: ${fees['medium'].maxFeePerGas}");
    // print("maxPriorityFeePerGas: ${fees['medium'].maxPriorityFeePerGas}");
    // print("maxPriorityFeePerGas: ${fees['medium'].maxPriorityFeePerGas}");
    // print("maxGas: ${fees['medium'].estimatedGas}");

    // BigInt estimatedGas = await _web3client.estimateGas(
    //     sender: publicAddress,
    //     to: EthereumAddress.fromHex(
    //         '0x3089c7c8f5aa2be20531634df9c12b72eaa79b0a'),
    //     amountOfGas: fees['medium'].estimatedGas,
    //     maxFeePerGas: fees['medium'].maxFeePerGas,
    //     maxPriorityFeePerGas: fees['medium'].maxPriorityFeePerGas);
    // print("maxGas: ${estimatedGas}");

    // print("maxGas: ${fees['medium'].estimatedGas * 10}");
    // print("maxGas: ${fees['medium'].estimatedGas * 1000000}");
  }

  Future<void> connectContracts() async {
    EthereumAddress tokenContractAddress = EthereumAddress.fromHex('0xD1633F7Fb3d716643125d6415d4177bC36b7186b');
    EthereumAddress tokenContractAddressGoerli = EthereumAddress.fromHex('0xD1633F7Fb3d716643125d6415d4177bC36b7186b');

    ierc20 = IERC20(address: tokenContractAddress, client: _web3client, chainId: chainId);
    taskCreateFacet = TaskCreateFacet(address: _contractAddress, client: _web3client, chainId: chainId);
    taskDataFacet = TaskDataFacet(address: _contractAddress, client: _web3client, chainId: chainId);
    tokenFacet = TokenFacet(address: _contractAddress, client: _web3client, chainId: chainId);
    tokenDataFacet = TokenDataFacet(address: _contractAddress, client: _web3client, chainId: chainId);
    //templorary fix:
    if (hardhatLive == false) {
      axelarFacet = AxelarFacet(address: _contractAddressAxelar, client: _web3clientAxelar, chainId: chainIdAxelar);
      hyperlaneFacet = HyperlaneFacet(address: _contractAddressHyperlane, client: _web3clientHyperlane, chainId: chainIdHyperlane);
      layerzeroFacet = LayerzeroFacet(address: _contractAddressLayerzero, client: _web3clientLayerzero, chainId: chainIdLayerzero);
      wormholeFacet = WormholeFacet(address: _contractAddressWormhole, client: _web3clientWormhole, chainId: chainIdWormhole);
    }
    // ierc20Goerli = IERC20(address: tokenContractAddressGoerli, client: _web3client, chainId: chainId);
  }

  Future<void> myBalance() async {
    if (publicAddress != null) {
      final EtherAmount balance = await web3GetBalance(publicAddress!);
      // final BigInt weiBalance = BigInt.from(0);
      final BigInt weiBalance = balance.getInWei;
      final ethBalancePrecise = weiBalance.toDouble() / pow(10, 18);
      ethBalance = (((ethBalancePrecise * 10000).floor()) / 10000).toDouble();

      late BigInt weiBalanceToken = BigInt.from(0);
      if (hardhatDebug == false && hardhatLive == false) {
        weiBalanceToken = await web3GetBalanceToken(publicAddress!, 'aUSDC');
      }

      final ethBalancePreciseToken = weiBalanceToken.toDouble() / pow(10, 6);
      ethBalanceToken = (((ethBalancePreciseToken * 10000).floor()) / 10000).toDouble();

      final List<EthereumAddress> shared = List.filled(roleNfts.keys.toList().length, publicAddress!);
      final List roleNftsBalance = await balanceOfBatchName(shared, roleNfts.keys.toList());
      print(roleNftsBalance);

      int keyId = 0;
      roleNfts = roleNfts.map((key, value) {
        print(keyId);
        int newBalance = roleNftsBalance[keyId].toInt();
        late MapEntry<String, int> mapEnt = MapEntry(key, newBalance);
        keyId++;
        return mapEnt;
      });

      notifyListeners();
    }
  }

  // EthereumAddress lastJobContract;
  Future<void> monitorEvents() async {
    final subscription = taskCreateFacet.taskCreatedEvents().listen((event) async {
      print('monitorEvents received event for contract ${event.contractAdr} message: ${event.message} timestamp: ${event.timestamp}');
      try {
        // tasks[event.contractAdr.toString()] = await getTaskData(event.contractAdr);
        // await refreshTask(tasks[event.contractAdr.toString()]!);
        // print('refreshed task: ${tasks[event.contractAdr.toString()]!.title}');
        // await myBalance();
        await monitorTaskEvents(event.contractAdr);
        notifyListeners();
      } on GetTaskException {
        print('could not get task ${event.contractAdr.toString()} from blockchain');
      } catch (e) {
        print(e);
      }
    });

    final subscription3 = ierc20.approvalEvents().listen((event) async {
      print('received event approvalEvents ${event.owner} spender ${event.spender} value ${event.value}');
      if (event.owner == publicAddress) {
        print(event.owner);
      }
    });
  }

  // EthereumAddress lastJobContract;
  Future<void> monitorTaskEvents(EthereumAddress taskAddress) async {
    // listen for the Transfer event when it's emitted by the contract
    TaskContract taskContract = TaskContract(address: taskAddress, client: _web3client, chainId: chainId);
    final subscription = taskContract.taskUpdatedEvents().listen((event) async {
      print('monitorTaskEvents received event for contract ${event.contractAdr} message: ${event.message} timestamp: ${event.timestamp}');
      try {
        tasks[event.contractAdr.toString()] = await getTaskData(event.contractAdr);
        await refreshTask(tasks[event.contractAdr.toString()]!);
        print('refreshed task: ${tasks[event.contractAdr.toString()]!.title}');
        await myBalance();
        notifyListeners();
      } on GetTaskException {
        print('could not get task ${event.contractAdr.toString()} from blockchain');
      } catch (e) {
        print(e);
      }
    });
  }

  Future tellMeHasItMined(String hash, String taskAction, String nanoId, [String messageNanoId = '']) async {
    if (hash.length == 66) {
      TransactionReceipt? transactionReceipt = await web3GetTransactionReceipt(hash);
      while (transactionReceipt == null) {
        Future.delayed(const Duration(milliseconds: 1000));
        transactionReceipt = await web3GetTransactionReceipt(hash);
      }
      if (messageNanoId != '') {
        taskAction = '${taskAction}_$messageNanoId';
      }

      if (transactionReceipt.status == true) {
        transactionStatuses[nanoId]![taskAction]!['status'] = 'minted';
        transactionStatuses[nanoId]![taskAction]!['txn'] = hash;
        notifyListeners();
        print('tell me has it mined');
        // thr.debounce(() {
        //   fetchTasks();
        // });
      }
      // await myBalance();
    } else {
      isLoadingBackground = false;
    }
  }

  Future<void> runFilter(String enteredKeyword, Map<String, Task> taskList) async {
    filterResults.clear();
    print(enteredKeyword);
    // searchKeyword = enteredKeyword;
    if (enteredKeyword.isEmpty) {
      filterResults = Map.from(taskList);
    } else {
      for (String taskAddress in taskList.keys) {
        if (taskList[taskAddress]!.title.toLowerCase().contains(enteredKeyword.toLowerCase())) {
          filterResults[taskAddress] = taskList[taskAddress]!;
        }
      }
    }
    // Refresh the UI
    notifyListeners();
  }

  Future<void> resetFilter(Map<String, Task> taskList) async {
    filterResults.clear();
    filterResults = Map.from(taskList);
  }

  // late bool loopRunning = false;
  // late bool stopLoopRunning = false;

  Future<Task> getTaskData(taskAddress) async {
    TaskContract taskContract = TaskContract(address: taskAddress, client: _web3client, chainId: chainId);
    var task = await taskContract.getTaskData();
    if (task != null) {
      // final BigInt weiBalance = await taskContract.getBalance();
      // final BigInt weiBalance = BigInt.from(0);
      // final double ethBalancePrecise = weiBalance.toDouble() / pow(10, 18);
      final double ethBalancePrecise = 0;
      BigInt weiBalanceToken = BigInt.from(0);
      if (hardhatDebug == false && hardhatLive == false) {
        weiBalanceToken = await web3GetBalanceToken(taskAddress, 'aUSDC');
      }
      final double ethBalancePreciseToken = weiBalanceToken.toDouble() / pow(10, 6);
      final double ethBalanceToken = (((ethBalancePreciseToken * 10000).floor()) / 10000).toDouble();

      // print('Task loaded: ${task.title}');
      var taskObject = Task(
          // nanoId: task[0],
          nanoId: task[1].toString(),
          createTime: DateTime.fromMillisecondsSinceEpoch(task[1].toInt() * 1000),
          taskType: task[2],
          title: task[3],
          description: task[4],
          tags: task[5],
          tagsNFT: task[6],
          symbols: task[7],
          amounts: task[8],
          taskState: task[9],
          auditState: task[10],
          rating: task[11].toInt(),
          contractOwner: task[12],
          participant: task[13],
          auditInitiator: task[14],
          auditor: task[15],
          participants: task[16],
          funders: task[17],
          auditors: task[18],
          messages: task[19],
          taskAddress: taskAddress,
          justLoaded: true,
          tokenNames: ['ETH'],
          tokenValues: [ethBalancePrecise],

          // temporary solution. in the future "transport" String name will come directly from the block:
          transport: (task[9] == transportAxelarAdr || task[9] == transportHyperlaneAdr) ? task[9] : '');
      return taskObject;
    }
    throw (GetTaskException);
  }

  Future<Map<String, Task>> getTasksData(List<EthereumAddress> taskAddresses) async {
    Map<String, Task> tasks = {};
    final rawTasksList = await taskDataFacet.getTasksData(taskAddresses);
    late int i = 0;
    for (final task in rawTasksList) {
      // print('Task loaded: ${task.title}');
      var taskObject = Task(
          // nanoId: task[0],
          nanoId: task[0][1].toString(),
          createTime: DateTime.fromMillisecondsSinceEpoch(task[0][1].toInt() * 1000),
          taskType: task[0][2],
          title: task[0][3],
          description: task[0][4],
          tags: task[0][5],
          tagsNFT: task[0][6],
          symbols: task[0][7],
          amounts: task[0][8],
          taskState: task[0][9],
          auditState: task[0][10],
          rating: task[0][11].toInt(),
          contractOwner: task[0][12],
          participant: task[0][13],
          auditInitiator: task[0][14],
          auditor: task[0][15],
          participants: task[0][16],
          funders: task[0][17],
          auditors: task[0][18],
          messages: task[0][19],
          taskAddress: taskAddresses[i],
          justLoaded: true,
          tokenNames: task[1].cast<String>(),
          tokenValues: task[2],

          // temporary solution. in the future "transport" String name will come directly from the block:
          transport: (task[0][9] == transportAxelarAdr || task[0][9] == transportHyperlaneAdr) ? task[9] : '');
      tasks[taskAddresses[i].toString()] = taskObject;
      i++;
    }

    return tasks;
  }

  Future<Task> loadOneTask(taskAddress) async {
    if (tasks.containsKey(taskAddress.toString())) {
      return tasks[taskAddress.toString()]!;
    } else {
      Task task = await getTaskData(taskAddress);
      tasks[taskAddress.toString()] = task;
      refreshTask(task);
      return task;
    }
  }

  Future<void> refreshTask(Task task) async {
    // Who participate in the TASK:
    if (task.participant == publicAddress) {
      // Calculate Pending among:
      if ((task.tokenValues[0] != 0 || task.tokenValues[0] != 0)) {
        if (task.taskState == "agreed" || task.taskState == "progress" || task.taskState == "review" || task.taskState == "completed") {
          pendingBalance = pendingBalance! + task.tokenValues[0];
          pendingBalanceToken = pendingBalanceToken! + task.tokenValues[0];
        }
      }
      // add all scored Task for calculation:
      if (task.rating != 0) {
        score = score + task.rating;
        scoredTaskCount++;
      }
    }

    // if (tasksAuditPending[task.taskAddress.toString()] != null) {
    tasksNew.remove(task.taskAddress.toString());
    filterResults.remove(task.taskAddress.toString());
    tasksAuditPending.remove(task.taskAddress.toString());
    tasksAuditApplied.remove(task.taskAddress.toString());
    tasksAuditWorkingOn.remove(task.taskAddress.toString());
    tasksAuditComplete.remove(task.taskAddress.toString());

    tasksCustomerSelection.remove(task.taskAddress.toString());
    tasksCustomerProgress.remove(task.taskAddress.toString());
    tasksCustomerComplete.remove(task.taskAddress.toString());

    tasksPerformerParticipate.remove(task.taskAddress.toString());
    tasksPerformerProgress.remove(task.taskAddress.toString());
    tasksPerformerComplete.remove(task.taskAddress.toString());
    // }

    if (task.taskState != "" &&
        (task.taskState == "agreed" || task.taskState == "progress" || task.taskState == "review" || task.taskState == "audit")) {
      if (task.contractOwner == publicAddress) {
        tasksCustomerProgress[task.taskAddress.toString()] = task;
      } else if (task.participant == publicAddress) {
        tasksPerformerProgress[task.taskAddress.toString()] = task;
      }
      if (hardhatDebug == true) {
        tasksPerformerProgress[task.taskAddress.toString()] = task;
      }
    }

    // New TASKs for all users:
    if (task.taskState != "" && task.taskState == "new") {
      if (hardhatDebug == true) {
        tasksNew[task.taskAddress.toString()] = task;
        filterResults[task.taskAddress.toString()] = task;
      }
      if (task.contractOwner == publicAddress) {
        tasksCustomerSelection[task.taskAddress.toString()] = task;
      } else if (task.participants.isNotEmpty) {
        var taskExist = false;
        for (var p = 0; p < task.participants.length; p++) {
          if (task.participants[p] == publicAddress) {
            taskExist = true;
          }
        }
        if (taskExist) {
          tasksPerformerParticipate[task.taskAddress.toString()] = task;
        } else {
          tasksNew[task.taskAddress.toString()] = task;
          filterResults[task.taskAddress.toString()] = task;
          // tasksNew.add(task);
          // filterResults.add(task);
        }
      } else {
        tasksNew[task.taskAddress.toString()] = task;
        filterResults[task.taskAddress.toString()] = task;
        // tasksNew.add(task);
        // filterResults.add(task);
      }
    }

    if (task.taskState != "" && (task.taskState == "completed" || task.taskState == "canceled")) {
      if (task.contractOwner == publicAddress) {
        tasksCustomerComplete[task.taskAddress.toString()] = task;
      } else if (task.participant == publicAddress) {
        tasksPerformerComplete[task.taskAddress.toString()] = task;
      }
      if (hardhatDebug == true) {
        tasksPerformerComplete[task.taskAddress.toString()] = task;
      }
    }

    // **** AUDIT ****
    // For auditors:
    if (task.taskState == "audit" || task.auditor != EthereumAddress.fromHex('0x0000000000000000000000000000000000000000')) {
      // Auditor side:
      if (task.auditState == "requested") {
        if (task.auditors.isNotEmpty) {
          var contrExist = false;
          for (var p = 0; p < task.auditors.length; p++) {
            if (task.auditors[p] == publicAddress) {
              contrExist = true;
            }
          }
          if (contrExist) {
            tasksAuditApplied[task.taskAddress.toString()] = task;
          } else {
            tasksAuditPending[task.taskAddress.toString()] = task;
          }
        } else {
          tasksAuditPending[task.taskAddress.toString()] = task;
        }
      }

      if (task.auditor == publicAddress) {
        if (task.auditState == "performing") {
          tasksAuditWorkingOn[task.taskAddress.toString()] = task;
        } else if (task.auditState == "complete" || task.auditState == "finished") {
          tasksAuditComplete[task.taskAddress.toString()] = task;
        }
      }

      if (hardhatDebug == true) {
        tasksAuditApplied[task.taskAddress.toString()] = task;
      }
    }
  }

  // Future<void> fetchTasks(List<EthereumAddress> taskList) async {
  //   isLoadingBackground = true;
  //   notifyListeners();

  //   tasks.clear();

  //   List<List<Future<void>>> downloadBatches = [];
  //   List<List<Future<void>>> monitorBatches = [];

  //   List<Future<void>> downloaders = [];
  //   List<Future<void>> monitors = [];
  //   int batchSize = 10;
  //   int totalBatches = (taskList.length / batchSize).ceil();
  //   int batchItemCount = 0;
  //   tasksLoaded = 0;

  //   for (var i = 0; i < taskList.length; i++) {
  //     try {
  //       downloaders.add(getTaskData(taskList[i]).then((result) => tasks[taskList[i].toString()] = result));
  //       monitors.add(getTaskData(taskList[i]).then((result) => tasks[taskList[i].toString()] = result));
  //       batchItemCount++;
  //       // print('batchItemCount: ${batchItemCount}');
  //       if (batchItemCount == batchSize) {
  //         downloadBatches.add([...downloaders]);
  //         monitorBatches.add([...monitors]);
  //         downloaders.clear();
  //         monitors.clear();
  //         batchItemCount = 0;
  //       }
  //     } on GetTaskException {
  //       print('could not get task ${taskList[i]} from blockchain');
  //     }
  //   }
  //   if (batchItemCount > 0) {
  //     downloadBatches.add([...downloaders]);
  //     monitorBatches.add([...monitors]);
  //     downloaders.clear();
  //     monitors.clear();
  //     batchItemCount = 0;
  //   }

  //   try {
  //     for (var batchId = 0; batchId < totalBatches; batchId++) {
  //       await Future.wait<void>(downloadBatches[batchId]);
  //       print('downloaded $batchId | total: $totalBatches');
  //       await Future.delayed(const Duration(milliseconds: 200));
  //       tasksLoaded += batchSize;
  //       notifyListeners();
  //     }
  //   } on GetTaskException {
  //     print('EXEPTI9ON');
  //   }

  //   filterResults.clear();
  //   tasksNew.clear();

  //   tasksAuditPending.clear();
  //   tasksAuditApplied.clear();
  //   tasksAuditWorkingOn.clear();
  //   tasksAuditComplete.clear();

  //   tasksCustomerSelection.clear();
  //   tasksCustomerProgress.clear();
  //   tasksCustomerComplete.clear();

  //   tasksPerformerParticipate.clear();
  //   tasksPerformerProgress.clear();
  //   tasksPerformerComplete.clear();

  //   pendingBalance = 0;
  //   pendingBalanceToken = 0;
  //   score = 0;
  //   scoredTaskCount = 0;

  //   for (Task task in tasks.values) {
  //     await refreshTask(task);
  //   }

  //   // Final Score Calculation
  //   if (score != 0) {
  //     myScore = score / scoredTaskCount;
  //   }

  //   isLoading = false;
  //   isLoadingBackground = false;
  //   await myBalance();
  //   notifyListeners();
  //   // runFilter(searchKeyword); // reset search bar
  //   try {
  //     for (var batchId = 0; batchId < totalBatches; batchId++) {
  //       await Future.wait<void>(monitorBatches[batchId]);
  //       print('monitoring $batchId');
  //       await Future.delayed(const Duration(milliseconds: 200));

  //       // await Future.wait<void>(monitors[batchId]);
  //     }
  //   } on GetTaskException {}
  // }

  Future<void> monitorTasks(List<EthereumAddress> taskList) async {
    isLoadingBackground = true;

    List<List<Future<void>>> monitorBatches = [];

    List<Future<void>> monitors = [];
    int batchSize = 10;
    int totalBatches = (taskList.length / batchSize).ceil();
    int batchItemCount = 0;
    tasksLoaded = 0;

    for (var i = 0; i < taskList.length; i++) {
      try {
        monitors.add(monitorTaskEvents(taskList[i]));
        batchItemCount++;
        // print('batchItemCount: ${batchItemCount}');
        if (batchItemCount == batchSize) {
          monitorBatches.add([...monitors]);
          monitors.clear();
          batchItemCount = 0;
        }
      } on GetTaskException {
        print('could not get task ${taskList[i]} from blockchain');
      }
    }
    if (batchItemCount > 0) {
      monitorBatches.add([...monitors]);
      monitors.clear();
      batchItemCount = 0;
    }

    try {
      print('will monitor tasks in ${totalBatches}');
      for (var batchId = 0; batchId < totalBatches; batchId++) {
        await Future.wait<void>(monitorBatches[batchId]);
        print('monitoring ${batchId + 1}| total: $totalBatches');
        await Future.delayed(const Duration(milliseconds: 200));
      }
    } on GetTaskException {}
  }

  Future<Map<String, Task>> getTasksBatch(List<EthereumAddress> taskList) async {
    List<List<Future<void>>> downloadBatches = [];
    List<List<Future<void>>> monitorBatches = [];

    List<Future<void>> downloaders = [];
    List<Future<void>> monitors = [];

    int requestBatchSize = 10;
    int downloadBatchSize = 10;
    // int totalBatches = (totalTaskListReversed.length / batchSize).ceil();
    int batchItemCount = 0;
    tasksLoaded = 0;

    final batches = taskList.slices(requestBatchSize).toList();
    final batchesResults = [];

    for (var i = 0; i < batches.length; i++) {
      try {
        downloaders.add(getTasksData(batches[i].toList().cast<EthereumAddress>()).then((result) => batchesResults.add(result)));
        // monitors.add(getTasksData(batches[i].toList().cast<EthereumAddress>()).then((result) => batchesResults.add(result)));
        batchItemCount++;
        // print('batchItemCount: ${batchItemCount}');
        if (batchItemCount == downloadBatchSize) {
          downloadBatches.add([...downloaders]);
          // monitorBatches.add([...monitors]);
          downloaders.clear();
          monitors.clear();
          batchItemCount = 0;
        }
      } on GetTaskException {
        print('could not get task ${taskList[i]} from blockchain');
      }
    }
    if (batchItemCount > 0) {
      downloadBatches.add([...downloaders]);
      // monitorBatches.add([...monitors]);
      downloaders.clear();
      // monitors.clear();
      batchItemCount = 0;
    }

    try {
      print(
          'will download ${taskList.length} tasks in ${downloadBatches.length} batches of ${downloadBatchSize} downloaders of ${requestBatchSize} requests');
      for (var batchId = 0; batchId < downloadBatches.length; batchId++) {
        await Future.wait<void>(downloadBatches[batchId]);
        print('downloaded ${batchId + 1} | total: ${downloadBatches.length}');
        await Future.delayed(const Duration(milliseconds: 200));
        tasksLoaded += downloadBatchSize * requestBatchSize;
        notifyListeners();
      }
    } on GetTaskException {
      print('EXEPTI9ON');
    }

    //combine all batches of tasks to one map
    tasks = Map.fromEntries(batchesResults.expand((map) => map.entries));
    return tasks;
  }

  Future<void> refreshTasksForAccount(EthereumAddress address) async {
    await fetchTasksByState('new');
    await fetchTasksCustomer(address);
    await fetchTasksPerformer(address);
  }

  Future<void> fetchTasksBatch(List<EthereumAddress> taskList) async {
    isLoadingBackground = true;
    tasks.clear();

    // getTaskData(totalTaskListReversed[i]);

    filterResults.clear();
    tasksNew.clear();

    tasksAuditPending.clear();
    tasksAuditApplied.clear();
    tasksAuditWorkingOn.clear();
    tasksAuditComplete.clear();

    tasksCustomerSelection.clear();
    tasksCustomerProgress.clear();
    tasksCustomerComplete.clear();

    tasksPerformerParticipate.clear();
    tasksPerformerProgress.clear();
    tasksPerformerComplete.clear();

    pendingBalance = 0;
    pendingBalanceToken = 0;
    score = 0;
    scoredTaskCount = 0;

    tasks = await getTasksBatch(taskList);

    for (Task task in tasks.values) {
      await refreshTask(task);
    }

    // Final Score Calculation
    if (score != 0) {
      myScore = score / scoredTaskCount;
    }

    isLoading = false;
    isLoadingBackground = false;
    await Future.delayed(const Duration(milliseconds: 200));
    await myBalance();
    notifyListeners();
  }

  Future<void> fetchTasksByState(String state) async {
    List<EthereumAddress> taskList = await taskDataFacet.getTaskContractsByState(state);

    filterResults.clear();

    if (state == "new") {
      tasksNew.clear();
      tasksCustomerSelection.clear();
      tasksPerformerParticipate.clear();
    } else if (state == "agreed" || state == "progress" || state == "review") {
      tasksCustomerProgress.clear();
      tasksPerformerProgress.clear();
    } else if (state == 'audit') {
      tasksAuditPending.clear();
      tasksAuditApplied.clear();
      tasksAuditWorkingOn.clear();
      tasksAuditComplete.clear();
    } else if (state == "completed" || state == "canceled") {
      tasksCustomerComplete.clear();
      tasksPerformerComplete.clear();
    }

    Map<String, Task> tasks = await getTasksBatch(taskList.reversed.toList());

    for (Task task in tasks.values) {
      await refreshTask(task);
    }

    // isLoading = false;
    // isLoadingBackground = false;
    // await myBalance();
    // notifyListeners();
  }

  Future<void> fetchTasksCustomer(EthereumAddress publicAddress) async {
    List<EthereumAddress> taskList = await taskDataFacet.getTaskContractsCustomer(publicAddress);

    filterResults.clear();

    tasksAuditPending.clear();
    tasksAuditApplied.clear();
    tasksAuditWorkingOn.clear();
    tasksAuditComplete.clear();

    tasksCustomerSelection.clear();
    tasksCustomerProgress.clear();
    tasksCustomerComplete.clear();

    Map<String, Task> tasks = await getTasksBatch(taskList.reversed.toList());

    for (Task task in tasks.values) {
      await refreshTask(task);
    }

    for (Task task in tasks.values) {
      await refreshTask(task);
    }
    for (Task task in tasks.values) {
      await refreshTask(task);
    }

    isLoading = false;
    isLoadingBackground = false;
    await myBalance();
    notifyListeners();
  }

  Future<void> fetchTasksPerformer(EthereumAddress publicAddress) async {
    List<EthereumAddress> taskList = await taskDataFacet.getTaskContractsPerformer(publicAddress);

    filterResults.clear();

    tasksAuditPending.clear();
    tasksAuditApplied.clear();
    tasksAuditWorkingOn.clear();
    tasksAuditComplete.clear();

    tasksPerformerParticipate.clear();
    tasksPerformerProgress.clear();
    tasksPerformerComplete.clear();

    Map<String, Task> tasks = await getTasksBatch(taskList.reversed.toList());

    for (Task task in tasks.values) {
      await refreshTask(task);
    }

    isLoading = false;
    isLoadingBackground = false;
    await myBalance();
    notifyListeners();
  }

  Future<List> getAccountsList() async {
    List accountsList = await taskDataFacet.getAccountsList();
    return accountsList;
  }

  Future<List<EthereumAddress>> getTaskListFull() async {
    List<EthereumAddress> taskList = await taskDataFacet.getTaskContracts();
    List<EthereumAddress> taskListReversed = List.from(taskList.reversed);
    return taskListReversed;
  }

  Future<List> getTaskListCustomer(EthereumAddress publicAddress) async {
    List taskList = await taskDataFacet.getTaskContractsCustomer(publicAddress);
    List taskListReversed = List.from(taskList.reversed);
    return taskListReversed;
  }

  Future<List> getTaskListPerformer(EthereumAddress publicAddress) async {
    List taskList = await taskDataFacet.getTaskContractsCustomer(publicAddress);
    List taskListReversed = List.from(taskList.reversed);
    return taskListReversed;
  }

  Future<List> getTaskListByState(String state) async {
    List taskList = await taskDataFacet.getTaskContractsByState(state);
    List taskListReversed = List.from(taskList.reversed);
    return taskListReversed;
  }

  // Future<Map<String, Task>> getTasks(List taskList) async {
  //   Map<String, Task> tasks = {};
  //   totalTaskLen = taskList.length;

  //   List<List<Future<Task>>> downloadBatches = [];

  //   List<Future<Task>> downloaders = [];
  //   int batchSize = 10;
  //   int totalBatches = (taskList.length / batchSize).floor();
  //   int batchItemCount = 0;
  //   tasksLoaded = 0;

  //   for (var i = 0; i < taskList.length; i++) {
  //     try {
  //       // int currentBatchId = (i / batchSize).floor();
  //       downloaders.add(getTaskData(taskList[i]).then((result) => tasks[taskList[i].toString()] = result));
  //       batchItemCount++;
  //       if (batchItemCount == batchSize) {
  //         downloadBatches.add([...downloaders]);
  //         downloaders.clear();
  //         batchItemCount = 0;
  //       }
  //       tasksLoaded++;
  //       notifyListeners();
  //       // await monitorTaskEvents(totalTaskListReversed[i]);
  //     } on GetTaskException {
  //       print('could not get task ${taskList[i]} from blockchain');
  //     }
  //   }

  //   try {
  //     for (var batchId = 0; batchId < totalBatches; batchId++) {
  //       await Future.wait<void>(downloadBatches[batchId]);
  //       print('downloaded $batchId');
  //       await Future.delayed(const Duration(milliseconds: 200));
  //       // await Future.wait<void>(monitors[batchId]);
  //     }
  //   } on GetTaskException {}
  //   return tasks;
  // }

  Future<void> approveSpend(EthereumAddress _contractAddress, EthereumAddress publicAddress, String symbol, BigInt amount, String nanoId) async {
    var creds;
    var senderAddress;
    if (hardhatDebug == true) {
      creds = EthPrivateKey.fromHex(hardhatAccounts[0]["key"]);
      senderAddress = EthereumAddress.fromHex(hardhatAccounts[0]["address"]);
    } else {
      creds = credentials;
      senderAddress = publicAddress;
    }
    final transaction = Transaction(
      from: senderAddress,
    );
    final result = await ierc20.approve(_contractAddress, amount, credentials: creds, transaction: transaction);
    print('result of approveSpend: ' + result);
    transactionStatuses[nanoId]!['createTaskContract']!['tokenApproved'] = 'approved';
    notifyListeners();
    await tellMeHasItMined(result, 'createTaskContract', nanoId);
    print('mined');
  }

  String taskTokenSymbol = 'ETH';
  Future<void> createTaskContract(String title, String description, double price, String nanoId, List<String> tags) async {
    if (taskTokenSymbol != '') {
      transactionStatuses[nanoId] = {
        'createTaskContract': {'status': 'pending', 'tokenApproved': 'initial', 'txn': 'initial'} //
      };
      late int priceInGwei = (price * 1000000000).toInt();
      final BigInt priceInBigInt = BigInt.from(price * 1e6);
      late String txn;
      String taskType = 'public';

      var creds;
      var senderAddress;
      if (hardhatDebug == true) {
        creds = EthPrivateKey.fromHex(hardhatAccounts[1]["key"]);
        senderAddress = EthereumAddress.fromHex(hardhatAccounts[1]["address"]);
      } else {
        creds = credentials;
        senderAddress = publicAddress;
      }
      final transaction = Transaction(
        from: senderAddress,
      );

      // List<String> tags = [];
      List<String> symbols = [taskTokenSymbol];
      List<BigInt> amounts = [BigInt.from(0)];
      // late TaskData taskData =
      //     new TaskData(nanoId: nanoId, taskType: taskType, title: title, description: description, symbols: symbols, amounts: amounts);

      Map<String, dynamic> taskData = {
        "nanoId": nanoId,
        "taskType": taskType,
        "title": title,
        "description": description,
        "tags": tags,
        "symbols": symbols,
        "amounts": amounts
      };

      if (taskTokenSymbol == 'ETH') {
        final transaction = Transaction(
          from: senderAddress,
          value: EtherAmount.fromUnitAndValue(EtherUnit.gwei, priceInGwei),
        );

        // txn = await taskDataFacet.createTaskContract(nanoId, taskType, title, description, taskTokenSymbol, priceInBigInt,
        //     credentials: creds, transaction: transaction);

        if ((chainId != 1287 && chainId != 31337) && interchainSelected == 'axelar') {
          txn = await axelarFacet.createTaskContractAxelar(senderAddress, taskData, credentials: credentials, transaction: transaction);
        } else if ((chainId != 1287 && chainId != 31337) && interchainSelected == 'hyperlane') {
          txn = await hyperlaneFacet.createTaskContractHyperlane(senderAddress, taskData, credentials: credentials, transaction: transaction);
        } else if ((chainId != 1287 && chainId != 31337) && interchainSelected == 'layerzero') {
          txn = await layerzeroFacet.createTaskContractLayerzero(senderAddress, taskData, credentials: credentials, transaction: transaction);
        } else if ((chainId != 1287 && chainId != 31337) && interchainSelected == 'wormhole') {
          txn = await wormholeFacet.createTaskContractWormhole(senderAddress, taskData, credentials: credentials, transaction: transaction);
        } else {
          txn = await taskCreateFacet.createTaskContract(senderAddress, taskData, credentials: creds, transaction: transaction);
        }
      } else if (taskTokenSymbol == 'aUSDC') {
        await approveSpend(_contractAddress, publicAddress!, taskTokenSymbol, priceInBigInt, nanoId);
        final transaction = Transaction(
          from: senderAddress,
          // value: EtherAmount.fromUnitAndValue(EtherUnit.gwei, priceInGwei),
        );

        // txn = await taskCreateFacet.createTaskContract(nanoId, taskType, title, description, taskTokenSymbol, priceInBigInt,
        //     credentials: creds, transaction: transaction);

        if ((chainId != 1287 || chainId != 31337) && interchainSelected == 'axelar') {
          txn = await axelarFacet.createTaskContractAxelar(senderAddress, taskData, credentials: credentials, transaction: transaction);
        } else if ((chainId != 1287 || chainId != 31337) && interchainSelected == 'hyperlane') {
          txn = await hyperlaneFacet.createTaskContractHyperlane(senderAddress, taskData, credentials: credentials, transaction: transaction);
        } else if ((chainId != 1287 || chainId != 31337) && interchainSelected == 'layerzero') {
          txn = await layerzeroFacet.createTaskContractLayerzero(senderAddress, taskData, credentials: credentials, transaction: transaction);
        } else if ((chainId != 1287 || chainId != 31337) && interchainSelected == 'wormhole') {
          txn = await wormholeFacet.createTaskContractWormhole(senderAddress, taskData, credentials: credentials, transaction: transaction);
        } else {
          txn = await taskCreateFacet.createTaskContract(senderAddress, taskData, credentials: creds, transaction: transaction);
        }
        print(txn);
      }
      isLoading = false;
      // isLoadingBackground = true;
      lastTxn = txn;
      transactionStatuses[nanoId]!['createTaskContract']!['status'] = 'confirmed';
      transactionStatuses[nanoId]!['createTaskContract']!['tokenApproved'] = 'complete';
      transactionStatuses[nanoId]!['createTaskContract']!['txn'] = txn;

      tellMeHasItMined(txn, 'createTaskContract', nanoId);
      notifyListeners();
    }
  }

  Future<void> addTokens(EthereumAddress addressToSend, double price, String nanoId, {String? message}) async {
    print(price);
    transactionStatuses[nanoId] = {
      'addTokens': {'status': 'pending', 'tokenApproved': 'initial', 'txn': 'initial'}
    };
    message ??= 'Added $price $taskTokenSymbol to contract';
    late int priceInGwei = (price * 1000000000).toInt();
    final BigInt priceInBigInt = BigInt.from(price * 1e6);
    late String txn;

    // message ??= 'Contract topped up for ${price.toString()} ';

    var creds;
    var senderAddress;
    if (hardhatDebug == true) {
      creds = EthPrivateKey.fromHex(hardhatAccounts[1]["key"]);
      senderAddress = EthereumAddress.fromHex(hardhatAccounts[1]["address"]);
    } else {
      creds = credentials;
      senderAddress = publicAddress;
    }
    final transaction = Transaction(
      from: senderAddress,
    );

    if (taskTokenSymbol == 'ETH') {
      final transaction = Transaction(
        from: senderAddress,
        to: addressToSend,
        value: EtherAmount.fromUnitAndValue(EtherUnit.gwei, priceInGwei),
      );

      txn = await web3Transaction(credentials, transaction, chainId: chainId);
      print(txn);
    } else if (taskTokenSymbol == 'aUSDC') {
      final transaction = Transaction(
        from: senderAddress,
      );

      /// todo: add messages to transfer function in contract
      // txn = await ierc20.transfer(addressToSend, priceInBigInt, message, credentials: creds, transaction: transaction);
      txn = await ierc20.transfer(addressToSend, priceInBigInt, credentials: creds, transaction: transaction);
    }
    isLoading = false;
    // isLoadingBackground = true;
    lastTxn = txn;
    transactionStatuses[nanoId]!['addTokens']!['status'] = 'confirmed';
    transactionStatuses[nanoId]!['addTokens']!['tokenApproved'] = 'complete';
    transactionStatuses[nanoId]!['addTokens']!['txn'] = txn;

    tellMeHasItMined(txn, 'addTokens', nanoId);
    notifyListeners();
  }

  Future<void> taskParticipate(EthereumAddress contractAddress, String nanoId, {String? message, BigInt? replyTo}) async {
    transactionStatuses[nanoId] = {
      'taskParticipate': {'status': 'pending', 'txn': 'initial'}
    };
    late String txn;
    message ??= 'Taking this task';
    replyTo ??= BigInt.from(0);
    TaskContract taskContract = TaskContract(address: contractAddress, client: _web3client, chainId: chainId);
    var creds;
    var senderAddress;
    if (hardhatDebug == true) {
      creds = EthPrivateKey.fromHex(hardhatAccounts[1]["key"]);
      senderAddress = EthereumAddress.fromHex(hardhatAccounts[1]["address"]);
    } else {
      creds = credentials;
      senderAddress = publicAddress;
    }
    final transaction = Transaction(
      from: senderAddress,
    );
    if ((chainId != 1287 || chainId != 31337) && interchainSelected == 'axelar') {
      txn = await axelarFacet.taskParticipateAxelar(senderAddress, contractAddress, message, replyTo, credentials: creds, transaction: transaction);
    } else if ((chainId != 1287 || chainId != 31337) && interchainSelected == 'hyperlane') {
      txn = await hyperlaneFacet.taskParticipateHyperlane(senderAddress, contractAddress, message, replyTo,
          credentials: creds, transaction: transaction);
    } else if ((chainId != 1287 || chainId != 31337) && interchainSelected == 'layerzero') {
      txn = await layerzeroFacet.taskParticipateLayerzero(senderAddress, contractAddress, message, replyTo,
          credentials: creds, transaction: transaction);
    } else if ((chainId != 1287 || chainId != 31337) && interchainSelected == 'wormhole') {
      txn =
          await wormholeFacet.taskParticipateWormhole(senderAddress, contractAddress, message, replyTo, credentials: creds, transaction: transaction);
    } else {
      txn = await taskContract.taskParticipate(senderAddress, message, replyTo, credentials: creds, transaction: transaction);
    }
    // txn = await taskContract.taskParticipate(senderAddress, message, replyTo, credentials: creds, transaction: transaction);
    isLoading = false;
    // isLoadingBackground = true;
    // lastTxn = txn;
    transactionStatuses[nanoId]!['taskParticipate']!['status'] = 'confirmed';
    transactionStatuses[nanoId]!['taskParticipate']!['txn'] = txn;
    notifyListeners();
    tellMeHasItMined(txn, 'taskParticipate', nanoId);
  }

  Future<void> taskAuditParticipate(EthereumAddress contractAddress, String nanoId, {String? message, BigInt? replyTo}) async {
    transactionStatuses[nanoId] = {
      'taskAuditParticipate': {'status': 'pending', 'txn': 'initial'}
    };
    late String txn;
    message ??= 'Taking task for audit';
    replyTo ??= BigInt.from(0);
    TaskContract taskContract = TaskContract(address: contractAddress, client: _web3client, chainId: chainId);
    var creds;
    var senderAddress;
    if (hardhatDebug == true) {
      creds = EthPrivateKey.fromHex(hardhatAccounts[2]["key"]);
      senderAddress = EthereumAddress.fromHex(hardhatAccounts[2]["address"]);
    } else {
      creds = credentials;
      senderAddress = publicAddress;
    }

    final transaction = Transaction(
      from: senderAddress,
    );
    // if ((chainId != 1287 || chainId != 31337) && interchainSelected == 'axelar') {
    //   txn = await axelarFacet.taskAuditParticipateAxelar(contractAddress, message, replyTo,
    //       credentials: creds, transaction: transaction);
    // } else if ((chainId != 1287 || chainId != 31337) && interchainSelected == 'hyperlane') {
    //   txn = await hyperlaneFacet.taskAuditParticipateHyperlane(contractAddress, message, replyTo,
    //       credentials: creds, transaction: transaction);
    // } else if ((chainId != 1287 || chainId != 31337) && interchainSelected == 'layerzero') {
    //   txn = await layerzeroFacet.taskAuditParticipateLayerzero(contractAddress, message, replyTo,
    //       credentials: creds, transaction: transaction);
    // } else if ((chainId != 1287 || chainId != 31337) && interchainSelected == 'wormhole') {
    //   txn = await wormholeFacet.taskAuditParticipateWormhole(contractAddress, message, replyTo,
    //       credentials: creds, transaction: transaction);
    // } else {
    //   txn = await taskContract.taskAuditParticipate(message, replyTo, credentials: creds, transaction: transaction);
    // }
    txn = await taskContract.taskAuditParticipate(senderAddress, message, replyTo, credentials: creds, transaction: transaction);
    isLoading = false;
    // isLoadingBackground = true;
    // lastTxn = txn;
    transactionStatuses[nanoId]!['taskAuditParticipate']!['status'] = 'confirmed';
    transactionStatuses[nanoId]!['taskAuditParticipate']!['txn'] = txn;
    notifyListeners();
    tellMeHasItMined(txn, 'taskAuditParticipate', nanoId);
  }

  Future<void> taskStateChange(EthereumAddress contractAddress, EthereumAddress participantAddress, String state, String nanoId,
      {String? message, BigInt? score, BigInt? replyTo}) async {
    transactionStatuses[nanoId] = {
      'taskStateChange': {'status': 'pending', 'txn': 'initial'}
    };
    // lastTxn = 'pending';
    late String txn;
    // String message = 'moving this task';
    message ??= 'Changing task status to $state';
    replyTo ??= BigInt.from(0);
    score ??= BigInt.from(5);
    TaskContract taskContract = TaskContract(address: contractAddress, client: _web3client, chainId: chainId);
    var creds;
    var senderAddress;
    if (hardhatDebug == true) {
      if (state == 'agreed' || state == 'audit' || state == 'completed' || state == 'canceled') {
        creds = credentials;
        senderAddress = publicAddress;
      } else if (state == 'progress' || state == 'review') {
        creds = EthPrivateKey.fromHex(hardhatAccounts[1]["key"]);
        senderAddress = EthereumAddress.fromHex(hardhatAccounts[1]["address"]);
      } else {
        creds = credentials;
        senderAddress = publicAddress;
      }
    } else {
      creds = credentials;
      senderAddress = publicAddress;
    }
    final transaction = Transaction(
      from: senderAddress,
    );
    // if ((chainId != 1287 || chainId != 31337) && interchainSelected == 'axelar') {
    //   txn = await axelarFacet.taskStateChangeAxelar(contractAddress, participantAddress, state, message, replyTo, score,
    //       credentials: creds, transaction: transaction);
    // } else if ((chainId != 1287 || chainId != 31337) && interchainSelected == 'hyperlane') {
    //   txn = await hyperlaneFacet.taskStateChangeHyperlane(contractAddress, participantAddress, state, message, replyTo, score,
    //       credentials: creds, transaction: transaction);
    // } else if ((chainId != 1287 || chainId != 31337) && interchainSelected == 'layerzero') {
    //   txn = await layerzeroFacet.taskStateChangeLayerzero(contractAddress, participantAddress, state, message, replyTo, score,
    //       credentials: creds, transaction: transaction);
    // } else if ((chainId != 1287 || chainId != 31337) && interchainSelected == 'wormhole') {
    //   txn = await wormholeFacet.taskStateChangeWormhole(contractAddress, participantAddress, state, message, replyTo, score,
    //       credentials: creds, transaction: transaction);
    // } else {
    //   txn = await taskContract.taskStateChange(participantAddress, state, message, replyTo, score,
    //       credentials: creds, transaction: transaction);
    // }
    txn = await taskContract.taskStateChange(senderAddress, participantAddress, state, message, replyTo, score,
        credentials: creds, transaction: transaction);
    isLoading = false;
    // isLoadingBackground = true;
    lastTxn = txn;
    transactionStatuses[nanoId]!['taskStateChange']!['status'] = 'confirmed';
    transactionStatuses[nanoId]!['taskStateChange']!['txn'] = txn;
    notifyListeners();
    tellMeHasItMined(txn, 'taskStateChange', nanoId);
  }

  Future<void> taskAuditDecision(EthereumAddress contractAddress, String favour, String nanoId,
      {String? message, BigInt? score, BigInt? replyTo}) async {
    transactionStatuses[nanoId] = {
      'taskAuditDecision': {'status': 'pending', 'txn': 'initial'}
    };
    late String txn;
    message ??= 'Auditor decision';
    replyTo ??= BigInt.from(0);
    score ??= BigInt.from(5);
    TaskContract taskContract = TaskContract(address: contractAddress, client: _web3client, chainId: chainId);
    var creds;
    var senderAddress;
    if (hardhatDebug == true) {
      creds = EthPrivateKey.fromHex(hardhatAccounts[1]["key"]);
      senderAddress = EthereumAddress.fromHex(hardhatAccounts[1]["address"]);
    } else {
      creds = credentials;
      senderAddress = publicAddress;
    }
    final transaction = Transaction(
      from: senderAddress,
    );
    // if ((chainId != 1287 || chainId != 31337) && interchainSelected == 'axelar') {
    //   txn = await axelarFacet.taskAuditDecisionAxelar(contractAddress, favour, message, replyTo, score,
    //       credentials: creds, transaction: transaction);
    // } else if ((chainId != 1287 || chainId != 31337) && interchainSelected == 'hyperlane') {
    //   txn = await hyperlaneFacet.taskAuditDecisionHyperlane(contractAddress, favour, message, replyTo, score,
    //       credentials: creds, transaction: transaction);
    // } else if ((chainId != 1287 || chainId != 31337) && interchainSelected == 'layerzero') {
    //   txn = await layerzeroFacet.taskAuditDecisionLayerzero(contractAddress, favour, message, replyTo, score,
    //       credentials: creds, transaction: transaction);
    // } else if ((chainId != 1287 || chainId != 31337) && interchainSelected == 'wormhole') {
    //   txn = await wormholeFacet.taskAuditDecisionWormhole(contractAddress, favour, message, replyTo, score,
    //       credentials: creds, transaction: transaction);
    // } else {
    //   txn = await taskContract.taskAuditDecision(favour, message, replyTo, score, credentials: creds, transaction: transaction);
    // }
    txn = await taskContract.taskAuditDecision(senderAddress, favour, message, replyTo, score, credentials: creds, transaction: transaction);
    isLoading = false;
    // isLoadingBackground = true;
    lastTxn = txn;
    transactionStatuses[nanoId]!['taskAuditDecision']!['status'] = 'confirmed';
    transactionStatuses[nanoId]!['taskAuditDecision']!['txn'] = txn;
    notifyListeners();
    tellMeHasItMined(txn, 'taskAuditDecision', nanoId);
  }

  Future<void> sendChatMessage(EthereumAddress contractAddress, String nanoId, String message, {BigInt? replyTo}) async {
    final messageNanoID = customAlphabet('0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ_abcdefghijklmnopqrstuvwxyz-', 5);
    transactionStatuses[nanoId] = {
      'sendChatMessage_$messageNanoID': {'status': 'pending', 'txn': 'initial'}
    };
    late String txn;
    replyTo ??= BigInt.from(0);
    TaskContract taskContract = TaskContract(address: contractAddress, client: _web3client, chainId: chainId);
    var creds;
    var senderAddress;
    if (hardhatDebug == true) {
      creds = EthPrivateKey.fromHex(hardhatAccounts[1]["key"]);
      senderAddress = EthereumAddress.fromHex(hardhatAccounts[1]["address"]);
    } else {
      creds = credentials;
      senderAddress = publicAddress;
    }
    final transaction = Transaction(
      from: senderAddress,
    );
    // if ((chainId != 1287 || chainId != 31337) && interchainSelected == 'axelar') {
    //   txn = await axelarFacet.sendMessageAxelar(contractAddress, message, replyTo, credentials: creds, transaction: transaction);
    // } else if ((chainId != 1287 || chainId != 31337) && interchainSelected == 'hyperlane') {
    //   txn = await hyperlaneFacet.sendMessageHyperlane(contractAddress, message, replyTo, credentials: creds, transaction: transaction);
    // } else if ((chainId != 1287 || chainId != 31337) && interchainSelected == 'layerzero') {
    //   txn = await layerzeroFacet.sendMessageLayerzero(contractAddress, message, replyTo, credentials: creds, transaction: transaction);
    // } else if ((chainId != 1287 || chainId != 31337) && interchainSelected == 'wormhole') {
    //   txn = await wormholeFacet.sendMessageWormhole(contractAddress, message, replyTo, credentials: creds, transaction: transaction);
    // } else {
    //   txn = await taskContract.sendMessage(message, replyTo, credentials: creds, transaction: transaction);
    // }
    txn = await taskContract.sendMessage(senderAddress, message, replyTo, credentials: creds, transaction: transaction);
    isLoading = false;
    // isLoadingBackground = true;
    // lastTxn = txn;

    transactionStatuses[nanoId]!['sendChatMessage_$messageNanoID']!['status'] = 'confirmed';
    transactionStatuses[nanoId]!['sendChatMessage_$messageNanoID']!['txn'] = txn;
    notifyListeners();

    tellMeHasItMined(txn, 'sendChatMessage', nanoId, messageNanoID);
  }

  String destinationChain = 'Moonbase';
  Future<void> withdrawToChain(EthereumAddress contractAddress, String nanoId) async {
    transactionStatuses[nanoId] = {
      'withdrawToChain': {'status': 'pending', 'txn': 'initial'}
    };
    late String txn;
    String chain = 'moonbase';
    TaskContract taskContract = TaskContract(address: contractAddress, client: _web3client, chainId: chainId);
    //should send value now?!
    var creds;
    var senderAddress;
    if (hardhatDebug == true) {
      creds = EthPrivateKey.fromHex(hardhatAccounts[1]["key"]);
      senderAddress = EthereumAddress.fromHex(hardhatAccounts[1]["address"]);
    } else {
      creds = credentials;
      senderAddress = publicAddress;
    }

    // BigInt estimatedGas = await _web3client.estimateGas(
    //     sender: publicAddress,
    //     to: contractAddress,
    //     amountOfGas: fees['medium'].estimatedGas,
    //     maxFeePerGas: fees['medium'].maxFeePerGas,
    //     maxPriorityFeePerGas: fees['medium'].maxPriorityFeePerGas);

    int price = 15;
    int priceInGwei = (price).toInt();
    EtherAmount gasPrice = EtherAmount.fromUnitAndValue(EtherUnit.gwei, priceInGwei);

    final transaction = Transaction(
      from: senderAddress,
      // maxFeePerGas: fees['medium'].maxFeePerGas,
      // maxPriorityFeePerGas: fees['medium'].maxPriorityFeePerGas,
      // maxGas: estimatedGas.toInt(),
      // gasPrice: gasPrice
    );
    txn = await taskContract.transferToaddress(publicAddress!, chain, credentials: creds, transaction: transaction);
    isLoading = false;
    // isLoadingBackground = true;
    lastTxn = txn;
    transactionStatuses[nanoId]!['withdrawToChain']!['status'] = 'confirmed';
    transactionStatuses[nanoId]!['withdrawToChain']!['txn'] = txn;
    notifyListeners();
    tellMeHasItMined(txn, 'withdrawToChain', nanoId);
  }

  Future<List> balanceOfBatchName(List<EthereumAddress> addresses, List<String> names) async {
    List balanceList = await tokenDataFacet.balanceOfBatchName(addresses, names);
    return balanceList;
  }

  Future<List> totalSupplyOfBatchName(List<String> names) async {
    List totalSupply = await tokenDataFacet.totalSupplyOfBatchName(names);
    return totalSupply;
  }

  Future<List> uriOfBatchName(List<String> names) async {
    List totalSupply = await tokenDataFacet.uriOfBatchName(names);
    return totalSupply;
  }

  Future<String> createNft(String uri, String name, bool isNF) async {
    var creds;
    var senderAddress;
    if (hardhatDebug == true) {
      creds = EthPrivateKey.fromHex(hardhatAccounts[0]["key"]);
      senderAddress = EthereumAddress.fromHex(hardhatAccounts[0]["address"]);
    } else {
      creds = credentials;
      senderAddress = publicAddress;
    }
    final transaction = Transaction(
      from: senderAddress,
    );
    String tx = await tokenFacet.create(uri, name, isNF, credentials: creds, transaction: transaction);
    return tx;
  }

  Future<String> mintFungibleByName(String name, List<EthereumAddress> addresses, List<BigInt> quantities) async {
    var creds;
    var senderAddress;
    if (hardhatDebug == true) {
      creds = EthPrivateKey.fromHex(hardhatAccounts[0]["key"]);
      senderAddress = EthereumAddress.fromHex(hardhatAccounts[0]["address"]);
    } else {
      creds = credentials;
      senderAddress = publicAddress;
    }
    final transaction = Transaction(
      from: senderAddress,
    );
    String txn = await tokenFacet.mintFungibleByName(name, addresses, quantities, credentials: creds, transaction: transaction);
    return txn;
  }

  Future<String> mintNonFungibleByName(String name, List<EthereumAddress> addresses, List<BigInt> quantities) async {
    var creds;
    var senderAddress;
    if (hardhatDebug == true) {
      creds = EthPrivateKey.fromHex(hardhatAccounts[0]["key"]);
      senderAddress = EthereumAddress.fromHex(hardhatAccounts[0]["address"]);
    } else {
      creds = credentials;
      senderAddress = publicAddress;
    }
    final transaction = Transaction(
      from: senderAddress,
    );
    String txn = await tokenFacet.mintNonFungibleByName(name, addresses, credentials: creds, transaction: transaction);
    return txn;
  }

  Future<String> safeTransferFrom(EthereumAddress to, BigInt id, BigInt amount, Uint8List data) async {
    var creds;
    var senderAddress;
    if (hardhatDebug == true) {
      creds = EthPrivateKey.fromHex(hardhatAccounts[0]["key"]);
      senderAddress = EthereumAddress.fromHex(hardhatAccounts[0]["address"]);
    } else {
      creds = credentials;
      senderAddress = publicAddress;
    }
    final transaction = Transaction(
      from: senderAddress,
    );
    String txn = await tokenFacet.safeTransferFrom(senderAddress, to, id, amount, data, credentials: creds, transaction: transaction);
    return txn;
  }

  Future<String> safeBatchTransferFrom(EthereumAddress to, List<BigInt> ids, List<BigInt> amounts, Uint8List data) async {
    var creds;
    var senderAddress;
    if (hardhatDebug == true) {
      creds = EthPrivateKey.fromHex(hardhatAccounts[0]["key"]);
      senderAddress = EthereumAddress.fromHex(hardhatAccounts[0]["address"]);
    } else {
      creds = credentials;
      senderAddress = publicAddress;
    }
    final transaction = Transaction(
      from: senderAddress,
    );
    String txn = await tokenFacet.safeBatchTransferFrom(senderAddress, to, ids, amounts, data, credentials: creds, transaction: transaction);
    return txn;
  }
  // Future<void> checkTokenBalance(EthereumAddress address, int tokenType) async {
  //   TokenContract tokenContract = TokenContract(address: contractAddress, client: _web3client, chainId: chainId);
  // }

  double gasPriceValue = 0;
  Future<void> getGasPrice(sourceChain, destinationChain, {tokenAddress, tokenSymbol}) async {
    const env = 'testnet';
    if (env == 'local') ;
    const String AddressZero = "0x0000000000000000000000000000000000000000";
    if (env != 'testnet') throw 'env needs to be "local" or "testnet".';

    if (tokenAddress == AddressZero && tokenSymbol == '') {
      throw 'Either tokenAddress or tokenSymbol must be set.';
    }
    String api_url = 'testnet.api.gmp.axelarscan.io';
    final params = {
      'method': 'getGasPrice',
      'destinationChain': destinationChain,
      'sourceChain': sourceChain,
    };

    if (tokenAddress != AddressZero && tokenAddress != null) {
      params['sourceTokenAddress'] = tokenAddress;
    } else {
      params['sourceTokenSymbol'] = tokenSymbol;
    }

    final uri = Uri.https(api_url, '/', params);

    var response = await http.get(uri);

    var decodedResponse = jsonDecode(response.body) as Map;

    final result = decodedResponse['result'];
    final dest = result['destination_native_token'];
    final destPrice = 1e18 * double.parse(dest['gas_price']) * (dest['token_price']['usd']);
    final gasPrice = destPrice / (result['source_token']['token_price']['usd']);
    print('gas price:');
    print(gasPrice);
    gasPriceValue = gasPrice;
    notifyListeners();
  }

  /**
   * Gest the transfer fee for a given transaction
   * ported to Dart from https://github.com/axelarnetwork/axelarjs-sdk/blob/main/src/libs/AxelarQueryAPI.ts#L85
   * example testnet query: "https://axelartest-lcd.quickapi.com/axelar/nexus/v1beta1/transfer_fee?source_chain=ethereum&destination_chain=terra&amount=100000000uusd"
   * @param sourceChainName
   * @param destinationChainName
   * @param assetDenom
   * @param amountInDenom
   * @returns
   */
  double transferFee = 0;
  Future<void> getTransferFee(
      {String sourceChainName = 'moonbeam', String destinationChainName = 'ethereum', String assetDenom = 'uausdc', double amountInDenom = 0}) async {
    if (amountInDenom <= 0) throw 'amountInDenom must be more than zero';
    String api_url = 'axelartest-lcd.quickapi.com';

    final params = {
      'source_chain': sourceChainName,
      'destination_chain': destinationChainName,
      'amount': '${amountInDenom.toString()}$assetDenom',
    };

    final uri = Uri.https(api_url, '/axelar/nexus/v1beta1/transfer_fee', params);

    var response = await http.get(uri);

    var decodedResponse = jsonDecode(response.body) as Map;
    print(decodedResponse);
    int transferFeeDenum = int.parse(decodedResponse['fee']['amount']);
    transferFee = transferFeeDenum / 1000000;

    notifyListeners();
  }

  Future<void> myNotifyListeners() async {
    notifyListeners();
  }

  Future<void> testTaskCreation() async {
    int price = 5;
    late int priceInGwei = (price * 1000000000).toInt();
    final transaction = Transaction(
      value: EtherAmount.fromUnitAndValue(EtherUnit.gwei, priceInGwei),
    );
    // var createContract = await tasksFacet.createTaskContract(
    //     EthereumAddress.fromHex('0x0'), 'testID', 'public', 'task title', 'task decription', 'ETH', BigInt.from(1),
    //     credentials: credentials, transaction: transaction);
    // var taskContracts = await tasksFacet.getTaskContracts();
    var creds;
    var senderAddress;
    if (hardhatDebug == true) {
      creds = EthPrivateKey.fromHex(hardhatAccounts[0]["key"]);
      senderAddress = EthereumAddress.fromHex(hardhatAccounts[0]["address"]);
    } else {
      creds = credentials;
      senderAddress = publicAddress;
    }

    Map<String, dynamic> taskData = {
      "nanoId": 'test',
      "taskType": 'private',
      "title": 'test job',
      "description": 'test desc',
      "tags": ['ETH'],
      "symbols": ['ETH'],
      "amounts": [BigInt.from(0)]
    };

    // var txn = await taskCreateFacet.createTaskContract(senderAddress, taskData, credentials: creds, transaction: transaction);

    // TaskContract taskContract = TaskContract(address: taskContracts[0], client: _web3client, chainId: chainId);
    // var taskInfo = await taskContract.getTaskInfo();
  }
}
