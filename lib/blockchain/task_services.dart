// ignore_for_file: unnecessary_import

import 'dart:async';
import 'dart:convert';
import 'package:convert/convert.dart';
// import 'dart:ffi';
import 'dart:io';
// import 'dart:js';
import 'dart:math';
import 'package:collection/collection.dart';
import 'package:js/js.dart' if (dart.library.io) 'package:webthree/src/browser/js_stub.dart' if (dart.library.js) 'package:js/js.dart';

import 'package:js/js_util.dart' if (dart.library.io) 'package:webthree/src/browser/js_util_stub.dart' if (dart.library.js) 'package:js/js_util.dart';

import 'package:week_of_year/week_of_year.dart';

import 'package:dodao/config/flutter_flow_util.dart';
import 'package:nanoid/nanoid.dart';
import 'package:throttling/throttling.dart';

import 'package:jovial_svg/jovial_svg.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:walletconnect_flutter_v2/walletconnect_flutter_v2.dart';
import 'package:walletconnect_dart/walletconnect_dart.dart';
import 'abi/TaskCreateFacet.g.dart';
import 'abi/TaskDataFacet.g.dart';
import 'abi/AccountFacet.g.dart';
import 'abi/TokenFacet.g.dart';
import 'abi/TokenDataFacet.g.dart';
import 'abi/TaskContract.g.dart';
import 'abi/AxelarFacet.g.dart';
import 'abi/HyperlaneFacet.g.dart';
import 'abi/LayerzeroFacet.g.dart';
import 'abi/WormholeFacet.g.dart';
import 'abi/WitnetFacet.g.dart';
// import 'abi/Wormhole.g.dart';
import 'abi/IERC165.g.dart';
import 'abi/IERC1155.g.dart';
import 'abi/IERC721.g.dart';
import 'abi/IERC20.g.dart';
import 'accounts.dart';
import 'classes.dart';
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

import '../wallet/walletconnectv2.dart';

import '../wallet/ethereum_walletconnect_transaction.dart';
import '../wallet/main.dart';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart'; // import 'package:device_info_plus/device_info_plus.dart';
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
  //     'name': 'FTM',
  //     'symbol': 'FTM',
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
  bool hardhatLive = false;
  Map<EthereumAddress, Task> tasks = {};
  Map<EthereumAddress, Task> filterResults = {};
  Map<EthereumAddress, Task> tasksNew = {};
  Map<EthereumAddress, Task> tasksAuditPending = {};
  Map<EthereumAddress, Task> tasksAuditApplied = {};
  Map<EthereumAddress, Task> tasksAuditWorkingOn = {};
  Map<EthereumAddress, Task> tasksAuditComplete = {};

  Map<EthereumAddress, Task> tasksPerformerParticipate = {};
  Map<EthereumAddress, Task> tasksPerformerProgress = {};
  Map<EthereumAddress, Task> tasksPerformerComplete = {};

  Map<EthereumAddress, Task> tasksCustomerSelection = {};
  Map<EthereumAddress, Task> tasksCustomerProgress = {};
  Map<EthereumAddress, Task> tasksCustomerComplete = {};

  Map<String, Account> accountsData = {};

  Map<String, int> statsCreateTimeListCounts = {};
  Map<String, int> statsTaskTypeListCounts = {};
  Map<String, int> statsTagsListCounts = {};
  Map<String, int> statsTagsNFTListCounts = {};
  Map<String, int> statsTaskStateListCounts = {};
  Map<String, int> statsAuditStateListCounts = {};
  Map<String, int> statsRatingListCounts = {};
  Map<String, int> statsContractOwnerListCounts = {};
  Map<String, int> statsPerformerListCounts = {};
  Map<String, int> statsParticipantsListCounts = {};
  Map<String, int> statsFundersListCounts = {};
  Map<String, int> statsAuditorListCounts = {};
  Map<String, int> statsAuditorsListCounts = {};
  Map<String, int> statsTokenNamesListCounts = {};
  Map<String, int> statsTokenValuesListCounts = {};

  // Map<String, Account> accountsTemp = {
  //   '1': Account(nickName: 'Als', about: 'about', walletAddress: EthereumAddress.fromHex('0x0000000000000000000000000000000000000000'), rating: 5),
  //   '2': Account(
  //       nickName: 'MyNameIsC',
  //       about: 'about super puper MyNameIsC',
  //       walletAddress: EthereumAddress.fromHex('0x0000000000000000000000000000000000000222'),
  //       rating: 12),
  //   '3': Account(
  //       nickName: 'Huh', about: 'super HUH', walletAddress: EthereumAddress.fromHex('0x0000000000000000000000000000000000000333'), rating: 342),
  // };

  Map<String, Map<String, Map<String, dynamic>>> transactionStatuses = {};

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

  var walletConnectClient;

  var walletConnectState;
  bool walletConnected = false;
  bool walletConnectedWC = false;
  bool walletConnectedMM = false;
  bool mmAvailable = false;
  String walletConnectUri = '';
  String walletConnectSessionUri = '';
  // var walletConnectSession;
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

  late String _rpcUrlFantom;
  late String _wsUrlFantom;

  late String _rpcUrlZksync;
  late String _wsUrlZksync;

  int chainId = 0;
  List allowedChainIds = [1287, 4002, 280, 80001];
  Map<int, String> chainTickers = {1287: 'DEV', 4002: 'FTM', 280: 'ETH'};
  late String chainTicker = 'ETH';

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
      chainTicker = 'ETH';
      _rpcUrl = 'http://localhost:8545';
      _wsUrl = 'ws://localhost:8545';
    } else {
      chainId = 1287;
    }

    isDeviceConnected = await InternetConnectionCheckerPlus().hasConnection;

    // if (platform != 'web') {
    final StreamSubscription subscription = Connectivity().onConnectivityChanged.listen((ConnectivityResult result) async {
      if (result != ConnectivityResult.none) {
        // print('connectivity: ${result}');
        isDeviceConnected = await InternetConnectionCheckerPlus().hasConnection;
        // print('isDeviceConnected: ${isDeviceConnected}');
        // await getTransferFee(sourceChainName: 'moonbeam', destinationChainName: 'ethereum', assetDenom: 'uausdc', amountInDenom: 100000);
      }
    });
    // }

    await connectRPC(chainId);
    await startup();
    // await nftInitialCollection();
    await collectMyTokens();
    // await getABI();
    // await getDeployedContract();

    if (platform == 'web') {}

    initComplete = true;
    // testTaskCreation();
  }

  Future<void> connectRPC(int chainId) async {
    if (chainId == 31337) {
      chainTicker = 'ETH';
      _rpcUrl = 'http://localhost:8545';
      _wsUrl = 'ws://localhost:8545';
    } else if (chainId == 1287) {
      chainTicker = 'DEV';
      _rpcUrl = 'https://moonbeam-alpha.api.onfinality.io/rpc?apikey=a574e9f5-b1db-4984-8362-89b749437b81';
      _wsUrl = 'wss://moonbeam-alpha.api.onfinality.io/rpc?apikey=a574e9f5-b1db-4984-8362-89b749437b81';
    } else if (chainId == 4002) {
      chainTicker = 'FTM';
      _rpcUrl = 'https://fantom-testnet.blastapi.io/5adb17c5-f79f-4542-b37c-b9cf98d6b28f';
      _wsUrl = 'wss://fantom-testnet.blastapi.io/5adb17c5-f79f-4542-b37c-b9cf98d6b28f';
    } else if (chainId == 80001) {
      chainTicker = 'MATIC';
      _rpcUrl = 'https://matic-mumbai.chainstacklabs.com';
      _wsUrl = 'wss://ws-matic-mumbai.chainstacklabs.com';
      // _rpcUrl = 'https://rpc-mumbai.matic.today';
      // _wsUrl = 'wss://rpc-mumbai.matic.today';
    } else if (chainId == 280) {
      chainTicker = 'ETH';
      _rpcUrl = 'https://zksync2-testnet.zksync.dev';
      _wsUrl = 'wss://zksync2-testnet.zksync.dev';
    }

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

    _rpcUrlFantom = 'https://fantom-testnet.blastapi.io/5adb17c5-f79f-4542-b37c-b9cf98d6b28f';
    _wsUrlFantom = 'wss://fantom-testnet.blastapi.io/5adb17c5-f79f-4542-b37c-b9cf98d6b28f';

    _rpcUrlZksync = 'https://zksync2-testnet.zksync.dev';
    _wsUrlZksync = 'wss://zksync2-testnet.zksync.dev';
    // _rpcUrl = 'https://rpc.api.moonbase.moonbeam.network';
    // _wsUrl = 'wss://wss.api.moonbase.moonbeam.network';

    if (wallectConnectTransaction == null) {
      wallectConnectTransaction = EthereumWallectConnectTransaction();
    }
    // await wallectConnectTransaction?.initSession();
    // await wallectConnectTransaction?.removeSession();

    if (walletConnectClient == null) {
      walletConnectClient = WalletConnectClient();
    }

    // await walletConnectClient?.initSession();

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
  }

  late ContractAbi _abiCode;

  late num totalTaskLen = 0;
  int tasksLoaded = 0;
  late EthereumAddress _contractAddress;
  late EthereumAddress _contractAddressAxelar;
  late EthereumAddress _contractAddressHyperlane;
  late EthereumAddress _contractAddressLayerzero;
  late EthereumAddress _contractAddressWormhole;

  EthereumAddress get contractAddress => _contractAddress;

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

  Future<void> connectWalletWCv2(bool refresh) async {
    print('async');
    if (wallectConnectTransaction != null) {
      // var _walletConnect = await walletConnectClient._initWalletConnect();

      if (walletConnected == false) {
        print("disconnected");
        walletConnectUri = '';
        walletConnectSessionUri = '';
      }

      await walletConnectClient.initWalletConnect();
      // Subscribe to events
      // walletConnectClient._walletConnect.on('onSessionConnect');
      walletConnectClient.walletConnect.onSessionConnect.subscribe((sessionConnect) {
        // walletConnectSession = session;
        walletConnectState = TransactionState.connected;
        walletConnected = true;
        walletConnectedWC = true;
        closeWalletDialog = true;
        () async {
          if (hardhatDebug == false) {
            credentials = WalletConnectEthereumCredentialsV2(
              wcClient: walletConnectClient.walletConnect,
              session: sessionConnect.session,
            );
            chainId = int.parse(NamespaceUtils.getChainFromAccount(
              sessionConnect.session.namespaces.values.first.accounts.first,
            ).split(":").last);
            publicAddressWC = EthereumAddress.fromHex(NamespaceUtils.getAccount(
              sessionConnect.session.namespaces.values.first.accounts.first,
            ));
            publicAddress = publicAddressWC;

            if (allowedChainIds.contains(chainId) ||
                chainId == chainIdAxelar ||
                chainId == chainIdHyperlane ||
                chainId == chainIdLayerzero ||
                chainId == chainIdWormhole) {
              validChainID = true;
              validChainIDWC = true;
              await connectRPC(chainId);
              await startup();
              await collectMyTokens();
            } else {
              validChainID = false;
              validChainIDWC = false;
              await switchNetworkWC();
            }
          } else {
            chainId = 31337;
            validChainID = true;
          }
          List<EthereumAddress> taskList = await getTaskListFull();
          await fetchTasksBatch(taskList);

          myBalance();
          // isLoading = true;
        }();
        notifyListeners();
      });
      // wcClient.onSessionConnect('session_request', (payload) {
      //   print(payload);
      // });
      // wcClient.onSessionConnect('session_update', (payload) {
      //   print(payload);
      //   if (payload.approved == true) {
      //     // walletConnectActionApproved = true;
      //     // notifyListeners();
      //   }
      // });
      walletConnectClient.walletConnect.onSessionDelete.subscribe((sessionConnect) async {
        // print(sessionConnect);
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

        await connectWalletWCv2(true);
        notifyListeners();
      });

      walletConnectClient.walletConnect.onSessionExpire.subscribe((sessionConnect) async {
        // print(sessionConnect);
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

        await connectWalletWCv2(true);
        notifyListeners();
      });

      var connectResponse = await walletConnectClient?.createSession(
          // onDisplayUri: (uri) => {
          //   walletConnectSessionUri = uri.split("?").first,
          //   (platform == 'mobile' || browserPlatform == 'android' || browserPlatform == 'ios') && !refresh
          //       ? {launchURL(uri), walletConnectUri = uri}
          //       : walletConnectUri = uri,
          //   notifyListeners()
          // },
          );

      final Uri? uri = connectResponse.uri;

      final String encodedUrl = Uri.encodeComponent('$uri');

      walletConnectUri = 'metamask://wc?uri=$encodedUrl';
      notifyListeners();

      // SessionData session = await connectResponse.session.future;

      // publicAddressWC = EthereumAddress.fromHex(NamespaceUtils.getAccount(
      //   session.namespaces.values.first.accounts.first,
      // ));
      // publicAddress = publicAddressWC;

      // chainId = int.parse(NamespaceUtils.getChainFromAccount(
      //   session.namespaces.values.first.accounts.first,
      // ).split(":").last);

      // credentials = WalletConnectEthereumCredentialsV2(
      //   wcClient: walletConnectClient.walletConnect,
      //   session: session,
      // );

      // print(walletConnectClient.deepLinkUrl);

      // Uri? uri = resp.uri;
      // walletConnectUri = walletConnectClient.deepLinkUrl;
      print(walletConnectUri);
    } else {
      print("not initialized");
      print(walletConnectState);
    }
  }

  // Future<void> connectWalletWC(bool refresh) async {
  //   print('async');
  //   if (wallectConnectTransaction != null) {
  //     var connector = await wallectConnectTransaction.initWalletConnect();

  //     if (walletConnected == false) {
  //       print("disconnected");
  //       walletConnectUri = '';
  //       walletConnectSessionUri = '';
  //     }
  //     // Subscribe to events
  //     connector.on('connect', (session) {
  //       walletConnectSession = session;
  //       walletConnectState = TransactionState.connected;
  //       walletConnected = true;
  //       walletConnectedWC = true;
  //       closeWalletDialog = true;
  //       () async {
  //         if (hardhatDebug == false) {
  //           credentials = await wallectConnectTransaction?.getCredentials();
  //           chainId = session.chainId;
  //           if (allowedChainIds.contains(chainId) ||
  //               chainId == chainIdAxelar ||
  //               chainId == chainIdHyperlane ||
  //               chainId == chainIdLayerzero ||
  //               chainId == chainIdWormhole) {
  //             validChainID = true;
  //             validChainIDWC = true;
  //             await connectRPC(chainId);
  //             await startup();
  //             await collectMyTokens();
  //           } else {
  //             validChainID = false;
  //             validChainIDWC = false;
  //             await switchNetworkWC();
  //           }
  //           publicAddressWC = await wallectConnectTransaction?.getPublicAddress(session);
  //           publicAddress = publicAddressWC;
  //         } else {
  //           chainId = 31337;
  //           validChainID = true;
  //         }
  //         List<EthereumAddress> taskList = await getTaskListFull();
  //         await fetchTasksBatch(taskList);

  //         myBalance();
  //         // isLoading = true;
  //       }();
  //       notifyListeners();
  //     });
  //     connector.on('session_request', (payload) {
  //       print(payload);
  //     });
  //     connector.on('session_update', (payload) {
  //       print(payload);
  //       if (payload.approved == true) {
  //         // walletConnectActionApproved = true;
  //         // notifyListeners();
  //       }
  //     });
  //     connector.on('disconnect', (session) async {
  //       print(session);
  //       walletConnectState = TransactionState.disconnected;
  //       walletConnected = false;
  //       walletConnectedWC = false;
  //       publicAddress = null;
  //       publicAddressWC = null;
  //       validChainID = false;
  //       validChainIDWC = false;
  //       ethBalance = 0;
  //       ethBalanceToken = 0;
  //       pendingBalance = 0;
  //       pendingBalanceToken = 0;
  //       walletConnectUri = '';
  //       walletConnectSessionUri = '';
  //       List<EthereumAddress> taskList = await getTaskListFull();
  //       await fetchTasksBatch(taskList);

  //       await connectWalletWC(true);
  //       notifyListeners();
  //     });
  //     final SessionStatus? session = await wallectConnectTransaction?.connect(
  //       onDisplayUri: (uri) => {
  //         walletConnectSessionUri = uri.split("?").first,
  //         (platform == 'mobile' || browserPlatform == 'android' || browserPlatform == 'ios') && !refresh
  //             ? {launchURL(uri), walletConnectUri = uri}
  //             : walletConnectUri = uri,
  //         notifyListeners()
  //       },
  //     );

  //     if (session == null) {
  //       print('Unable to connect');
  //       walletConnectState = TransactionState.failed;
  //     } else if (walletConnected == true) {
  //       if (hardhatDebug == false) {
  //         credentials = await wallectConnectTransaction?.getCredentials();
  //       }
  //       publicAddressWC = await wallectConnectTransaction?.getPublicAddress(session);
  //       publicAddress = publicAddressWC;
  //     } else {
  //       walletConnectState = TransactionState.failed;
  //     }
  //   } else {
  //     print("not initialized");
  //     print(walletConnectState);
  //   }
  // }

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
        if (allowedChainIds.contains(chainId) ||
            chainId == chainIdAxelar ||
            chainId == chainIdHyperlane ||
            chainId == chainIdLayerzero ||
            chainId == chainIdWormhole) {
          validChainID = true;
          validChainIDMM = true;
          await connectRPC(chainId);
          await startup();
          await collectMyTokens();
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
      //       if (chainId == defaultChainId) {
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
      if (allowedChainIds.contains(chainId) ||
          chainId == chainIdAxelar ||
          chainId == chainIdHyperlane ||
          chainId == chainIdLayerzero ||
          chainId == chainIdWormhole) {
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
      if (allowedChainIds.contains(chainId) ||
          chainId == chainIdAxelar ||
          chainId == chainIdHyperlane ||
          chainId == chainIdLayerzero ||
          chainId == chainIdWormhole) {
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
      if (allowedChainIds.contains(chainId) ||
          chainId == chainIdAxelar ||
          chainId == chainIdHyperlane ||
          chainId == chainIdLayerzero ||
          chainId == chainIdWormhole) {
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
      if (allowedChainIds.contains(chainId) ||
          chainId == chainIdAxelar ||
          chainId == chainIdHyperlane ||
          chainId == chainIdLayerzero ||
          chainId == chainIdWormhole) {
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

  Future<void> disconnectWCv2() async {
    await walletConnectClient?.disconnect();
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
    connectWalletWCv2(true);
    notifyListeners();
  }

  // Future<void> disconnectWC() async {
  //   await wallectConnectTransaction?.disconnect();
  //   walletConnected = false;
  //   walletConnectedWC = false;
  //   publicAddress = null;
  //   publicAddressWC = null;
  //   validChainID = false;
  //   validChainIDWC = false;
  //   ethBalance = 0;
  //   ethBalanceToken = 0;
  //   pendingBalance = 0;
  //   pendingBalanceToken = 0;
  //   walletConnectUri = '';
  //   walletConnectSessionUri = '';
  //   List<EthereumAddress> taskList = await getTaskListFull();
  //   await fetchTasksBatch(taskList);
  //   connectWalletWC(true);
  //   notifyListeners();
  // }

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
  late AccountFacet accountFacet;
  late TokenFacet tokenFacet;
  late TokenDataFacet tokenDataFacet;
  late AxelarFacet axelarFacet;
  late HyperlaneFacet hyperlaneFacet;
  late LayerzeroFacet layerzeroFacet;
  late WormholeFacet wormholeFacet;
  late WitnetFacet witnetFacet;
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
    isLoadingBackground = true;
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
      credentials = EthPrivateKey.fromHex(hardhatAccounts[2]["key"]);
      publicAddress = EthereumAddress.fromHex(hardhatAccounts[2]["address"]);
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
    notifyListeners();

    List<EthereumAddress> accountsList = await getAccountsList();
    accountsData = await getAccountsData(accountsList);
    isLoadingBackground = false;

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
    accountFacet = AccountFacet(address: _contractAddress, client: _web3client, chainId: chainId);
    tokenFacet = TokenFacet(address: _contractAddress, client: _web3client, chainId: chainId);
    tokenDataFacet = TokenDataFacet(address: _contractAddress, client: _web3client, chainId: chainId);
    //templorary fix:
    if (hardhatLive == false) {
      axelarFacet = AxelarFacet(address: _contractAddressAxelar, client: _web3clientAxelar, chainId: chainIdAxelar);
      hyperlaneFacet = HyperlaneFacet(address: _contractAddressHyperlane, client: _web3clientHyperlane, chainId: chainIdHyperlane);
      layerzeroFacet = LayerzeroFacet(address: _contractAddressLayerzero, client: _web3clientLayerzero, chainId: chainIdLayerzero);
      wormholeFacet = WormholeFacet(address: _contractAddressWormhole, client: _web3clientWormhole, chainId: chainIdWormhole);
      witnetFacet = WitnetFacet(address: _contractAddress, client: _web3client, chainId: chainId);
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
        // weiBalanceToken = await web3GetBalanceToken(publicAddress!, 'USDC');
      }

      final ethBalancePreciseToken = weiBalanceToken.toDouble() / pow(10, 6);
      ethBalanceToken = (((ethBalancePreciseToken * 10000).floor()) / 10000).toDouble();

      final List<EthereumAddress> shared = List.filled(roleNfts.keys.toList().length, publicAddress!);
      final List roleNftsBalance = await balanceOfBatchName(shared, roleNfts.keys.toList());
      // print('roleNftsBalance: $roleNftsBalance');

      int keyId = 0;
      roleNfts = roleNfts.map((key, value) {
        // print(keyId);
        int newBalance = roleNftsBalance[keyId].toInt();
        late MapEntry<String, int> mapEnt = MapEntry(key, newBalance);
        keyId++;
        return mapEnt;
      });
    }
  }

  late Map<String, NftCollection> resultInitialCollectionMap = {};
  late Map<String, NftCollection> resultNftsMap = {};
  Future<void> collectMyTokens() async {
    if (publicAddress != null) {
      // late Map<String, dynamic> resultCollectionMap;
      // final List<EthereumAddress> shared = List.filled(resultInitialCollectionMap.entries.length, publicAddress!);
      // final List<String> collectionList = resultInitialCollectionMap.entries.map((e) => e.key).toList();
      // final List roleNftsBalance = await balanceOfBatchName(shared, collectionList);
      //
      // int keyId = 0;
      // resultCollectionMap = resultInitialCollectionMap.map((key, value) {
      //   // print(keyId);
      //   int newBalance = roleNftsBalance[keyId].toInt();
      //   late MapEntry<String, int> mapEnt = MapEntry(key, newBalance);
      //   keyId++;
      //   return mapEnt;
      // });
      //
      // for (var e in resultCollectionMap.entries) {
      //   if (e.value != 0) {
      //     late Map<BigInt, TokenItem> bunch = {};
      //     for (int i = 0; i < e.value; i++) {
      //       bunch[BigInt.from(i)] = TokenItem(tag: e.key, collection: true, nft: true, id: BigInt.from(i));
      //     }
      //     resultNftsMap[e.key] = NftCollection(bunch: bunch, selected: false, tag: e.key);
      //   }
      // }

      final List<String> names = await getCreatedTokenNames();
      for (var e in names) {
        resultInitialCollectionMap[e] = NftCollection(bunch: {BigInt.from(0): TokenItem(name: e, collection: true)}, selected: false, name: e);
      }

      final List<String> tokenNames = await getTokenNames(publicAddress!);
      final List<BigInt> tokenIds = await getTokenIds(publicAddress!);
      // print(tokenIds);
      // final List<int> tokenIds = tokenIdsBI.map((bigInt) => bigInt.toInt()).toList();
      final Map<BigInt, String> combinedTokenMap = Map.fromIterables(tokenIds, tokenNames);

      final Map<String, List<BigInt>> result = combinedTokenMap.entries.fold(
        {},
        (Map<String, List<BigInt>> acc, entry) {
          final key = entry.value;
          final value = entry.key;
          acc.putIfAbsent(key, () => []).add(value);
          return acc;
        },
      );
      resultNftsMap.clear();
      for (var e in result.entries) {
        if (e.value.isNotEmpty) {
          late Map<BigInt, TokenItem> bunch = {};
          for (int i = 0; i < e.value.length; i++) {
            bunch[e.value[i]] = TokenItem(name: e.key, collection: true, nft: true, id: e.value[i]);
          }
          resultNftsMap[e.key] = NftCollection(bunch: bunch, selected: false, name: e.key);
        }
      }
    }
  }

  // EthereumAddress lastJobContract;
  Future<void> monitorEvents() async {
    final subscription = taskCreateFacet.taskCreatedEvents().listen((event) async {
      print('monitorEvents received event for contract ${event.contractAdr} message: ${event.message} timestamp: ${event.timestamp}');
      try {
        // tasks[event.contractAdr] = await getTaskData(event.contractAdr);
        // await refreshTask(tasks[event.contractAdr]!);
        // print('refreshed task: ${tasks[event.contractAdr]!.title}');
        // await myBalance();
        await monitorTaskEvents(event.contractAdr);
      } on GetTaskException {
        print('could not get task ${event.contractAdr} from blockchain');
      } catch (e) {
        print(e);
      }
    });

    tokenFacet.transferBatchEvents().listen((event) async {
      print(
          'received event approvalEvents from: ${event.from} operator: ${event.operator} to: ${event.to} ids: ${event.ids} values: ${event.values}');
      if (event.from == publicAddress || event.to == publicAddress) {
        await collectMyTokens();
      }
    });

    tokenFacet.approvalForAllEvents().listen((event) async {
      print('received event approvalEvents account: ${event.account} operator: ${event.operator} approved: ${event.approved}');
      if (event.account == publicAddress) {}
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
        final Map<EthereumAddress, Task> tasksTemp = await getTasksData([event.contractAdr]);
        tasks[event.contractAdr] = tasksTemp[event.contractAdr]!;
        await refreshTask(tasks[event.contractAdr]!);
        print('refreshed task: ${tasks[event.contractAdr]!.title}');
        await myBalance();
        notifyListeners();
      } on GetTaskException {
        print('could not get task ${event.contractAdr} from blockchain');
      } catch (e) {
        print(e);
      }
    });
  }

  Future tellMeHasItMined(String hash, String taskAction, String nanoId, [String messageNanoId = '']) async {
    if (hash.length == 66) {
      TransactionReceipt? transactionReceipt = await web3GetTransactionReceipt(hash);
      while (transactionReceipt == null) {
        Future.delayed(const Duration(milliseconds: 3000));
        transactionReceipt = await web3GetTransactionReceipt(hash);
      }
      if (messageNanoId != '') {
        // sendChatMessage_$messageNanoID
        taskAction = '${taskAction}_$messageNanoId';
      }

      //handle rejection when postWitnetRequest was already posted, check for this taskAction and allow status==false
      if (transactionReceipt.status == true) {
        transactionStatuses[nanoId]![taskAction]!['status'] = 'minted';
        transactionStatuses[nanoId]![taskAction]!['txn'] = hash;
        // thr.debounce(() {
        //   fetchTasks();
        // });
      }
      // await myBalance();
    } else {
      isLoadingBackground = false;
    }
    isLoadingBackground = false;
    notifyListeners();
  }

  // List<String> _tagsList = [];
  // List<String> get tagsList => _tagsList;
  // set tagsList(List<String> value) {
  //   if (value != tagsList) {
  //     _tagsList = value;
  //     runFilter();
  //   }
  // }

  // late Map<EthereumAddress, Task> lastTaskList = {};
  // late String lastEnteredKeyword = '';

  Future<void> runFilter(
      {required Map<EthereumAddress, Task> taskList, required String enteredKeyword, required Map<String, NftCollection> tagsMap}) async {
    final List<String> tagsList = tagsMap.entries.map((e) => e.value.name).toList();
    // enteredKeyword ??= lastEnteredKeyword;
    // taskList ??= lastTaskList;
    // tagsList ??= [];
    filterResults.clear();
    // searchKeyword = enteredKeyword;
    // if (enteredKeyword.isEmpty && (tagsList.length == 1 && tagsList.first == '#')) {
    if (enteredKeyword.isEmpty) {
      filterResults = Map.from(taskList);
    } else {
      // for (EthereumAddress taskAddress in taskList.keys) {
      //   if (taskList[taskAddress]!.title.toLowerCase().contains(enteredKeyword.toLowerCase())) {
      //     if (taskList.isNotEmpty && taskList[taskAddress]!.names.isNotEmpty) {
      //     } else {
      //       filterResults[taskAddress] = taskList[taskAddress]!;
      //     }
      //   }
      // }

      final filterResultsTitle = Map.from(taskList)
        ..removeWhere((taskAddress, task) => !task.title.toLowerCase().contains(enteredKeyword.toLowerCase()));
      final filterResultsDescription = Map.from(taskList)
        ..removeWhere((taskAddress, task) => !task.description.toLowerCase().contains(enteredKeyword.toLowerCase()));
      late Map<EthereumAddress, Task> filterResultsTaskAddress = {};
      late Map<EthereumAddress, Task> filterResultsContractOwner = {};
      late Map<EthereumAddress, Task> filterResultsPerformer = {};
      late Map<EthereumAddress, Task> filterResultsAuditor = {};
      if (enteredKeyword.length > 41 && enteredKeyword.length <= 43) {
        filterResultsTaskAddress = Map.from(taskList)..removeWhere((taskAddress, task) => !task.taskAddress.toString().contains(enteredKeyword!));
        filterResultsContractOwner = Map.from(taskList)..removeWhere((taskAddress, task) => !task.contractOwner.toString().contains(enteredKeyword!));
        filterResultsPerformer = Map.from(taskList)..removeWhere((taskAddress, task) => !task.performer.toString().contains(enteredKeyword!));
        filterResultsAuditor = Map.from(taskList)..removeWhere((taskAddress, task) => !task.auditor.toString().contains(enteredKeyword!));
      }
      Map<EthereumAddress, Task> filterResultsSearch = {
        ...filterResultsTitle,
        ...filterResultsDescription,
        ...filterResultsTaskAddress,
        ...filterResultsContractOwner,
        ...filterResultsPerformer,
        ...filterResultsAuditor,
        // ...filterResultsTags,
        // ...filterResultsTagsNFT
      };

      // filtering by TAGS:

      // filterResults = Map.from(filterResultsSearch)
      //   ..removeWhere((taskAddress, task) => task.tags.toSet().intersection(tagsList.toSet()).isNotEmpty);
      // print(filterResultsSearch);
      // final filterResultsTagsNFT = Map.from(taskList)
      //   ..removeWhere((taskAddress, task) => task.tagsNFT.toSet.intersection(tagsList!.toSet().length == 0));

      // if (tagsList.isNotEmpty && (tagsList.length != 1)) {
      if (tagsList.isNotEmpty) {
        Map<EthereumAddress, Task> filterResultsTags = filterResultsSearch;
        for (var tag in tagsList) {
          if (tag != '#') {
            filterResultsTags = Map.from(filterResultsTags)..removeWhere((key, value) => !value.tags.contains(tag));
          }
        }
        filterResults = filterResultsTags;
        // filterResults = Map.from(filterResultsSearch)..removeWhere((key, value) => value.tags.every((tag) => !tagsList.contains(tag)));
      } else {
        filterResults = Map.from(filterResultsSearch);
      }
    }
    print(filterResults);
    // Refresh the UI
    notifyListeners();
  }

  Future<void> resetFilter({required Map<EthereumAddress, Task> taskList, required Map<String, NftCollection> tagsMap}) async {
    final List<String> tagsList = tagsMap.entries.map((e) => e.value.name).toList();

    filterResults.clear();
    //
    // taskList = Map.fromEntries(
    //     taskList.entries.where((entry) => tagsList.contains(entry.value.name))
    // );
    // if (tagsList.isNotEmpty && (tagsList.length != 1)) {
    if (tagsList.isNotEmpty) {
      Map<EthereumAddress, Task> filterResultsTags = taskList;
      for (var tag in tagsList) {
        if (tag != '#') {
          filterResultsTags = Map.from(filterResultsTags)..removeWhere((key, value) => !value.tags.contains(tag));
        }
      }
      filterResults = filterResultsTags;
      // filterResults = Map.from(taskList)..removeWhere((key, value) => value.tags.every((tag) => !tagsList.contains(tag)));
    } else {
      filterResults = Map.from(taskList);
    }
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
        // weiBalanceToken = await web3GetBalanceToken(taskAddress, 'USDC');
      }
      final double ethBalancePreciseToken = weiBalanceToken.toDouble() / pow(10, 18);
      final double ethBalanceToken = (((ethBalancePreciseToken * 10000).floor()) / 10000).toDouble();

      // print('Task loaded: ${task.title}');
      var taskObject = Task(
          // nanoId: task[0],
          nanoId: task[0].toString(),
          createTime: DateTime.fromMillisecondsSinceEpoch(task[1].toInt() * 1000),
          taskType: task[2],
          title: task[3],
          description: task[4],
          repository: task[5],
          tags: task[6],
          tagsNFT: task[7],
          tokenContracts: task[0][9],
          tokenIds: task[0][10],
          tokenAmounts: task[0][11],
          taskState: task[10],
          auditState: task[11],
          rating: task[12].toInt(),
          contractOwner: task[13],
          performer: task[14],
          auditInitiator: task[15],
          auditor: task[16],
          participants: task[17],
          funders: task[18],
          auditors: task[19],
          messages: task[20],
          taskAddress: taskAddress,
          loadingIndicator: false,
          tokenNames: task[0][8],
          tokenBalances: [ethBalanceToken],

          // temporary solution. in the future "transport" String name will come directly from the block:
          transport: (task[9] == transportAxelarAdr || task[9] == transportHyperlaneAdr) ? task[9] : '');
      return taskObject;
    }
    throw (GetTaskException);
  }

  Future<Map<EthereumAddress, Task>> getTasksData(List<EthereumAddress> taskAddresses) async {
    Map<EthereumAddress, Task> tasks = {};
    final rawTasksList = await taskDataFacet.getTasksData(taskAddresses);
    late int i = 0;
    for (final task in rawTasksList) {
      List<double> tokenValues = [];
      for (final tokenBalances in task[2]) {
        for (final tokenValueRaw in tokenBalances) {
          final double ethBalancePreciseToken = tokenValueRaw.toDouble() / pow(10, 18);
          final double ethBalanceToken = (((ethBalancePreciseToken * 10000).floor()) / 10000).toDouble();
          tokenValues.add(ethBalancePreciseToken);
        }
      }

      // print('Task loaded: ${task.title}');
      var taskObject = Task(
          // nanoId: task[0],
          nanoId: task[0][0].toString(),
          createTime: DateTime.fromMillisecondsSinceEpoch(task[0][1].toInt() * 1000),
          taskType: task[0][2],
          title: task[0][3],
          description: task[0][4],
          repository: task[0][5],
          tags: task[0][6],
          tagsNFT: task[0][7],
          tokenContracts: task[0][8],
          tokenIds: task[0][9],
          tokenAmounts: task[0][10],
          taskState: task[0][11],
          auditState: task[0][12],
          rating: task[0][13].toInt(),
          contractOwner: task[0][14],
          performer: task[0][15],
          auditInitiator: task[0][16],
          auditor: task[0][17],
          participants: task[0][18],
          funders: task[0][19],
          auditors: task[0][20],
          messages: task[0][21],
          taskAddress: taskAddresses[i],
          loadingIndicator: false,
          tokenNames: task[1],
          tokenBalances: tokenValues,

          // temporary solution. in the future "transport" String name will come directly from the block:
          transport: (task[0][9] == transportAxelarAdr || task[0][9] == transportHyperlaneAdr) ? task[9] : '');
      tasks[taskAddresses[i]] = taskObject;
      i++;
    }

    return tasks;
  }

  Future<Map<String, Map<EthereumAddress, Task>>> getTasksDateMap(Map<EthereumAddress, Task> tasks) async {
    late Map<String, Map<EthereumAddress, Task>> tasksDateMap = {};
    // Map<String, List<Task>> taskStatsLists = {};

    for (final taskContract in tasks.keys) {
      String taskDate = DateFormat('yyyy-MM-dd').format(tasks[taskContract]!.createTime);
      if (tasksDateMap[taskDate] == null) {
        tasksDateMap[taskDate] = {};
      }
      tasksDateMap[taskDate]![taskContract] = tasks[taskContract]!;
    }

    return tasksDateMap;
  }

  Future<Map<String, Map<EthereumAddress, Task>>> getTasksWeekMap(Map<EthereumAddress, Task> tasks) async {
    late Map<String, Map<EthereumAddress, Task>> tasksDateMap = {};
    // Map<String, List<Task>> taskStatsLists = {};

    for (final taskContract in tasks.keys) {
      String taskDateWeek = tasks[taskContract]!.createTime.weekOfYear.toString();
      if (tasksDateMap[taskDateWeek] == null) {
        tasksDateMap[taskDateWeek] = {};
      }
      tasksDateMap[taskDateWeek]![taskContract] = tasks[taskContract]!;
    }

    return tasksDateMap;
  }

  Future<Map<String, Map<EthereumAddress, Task>>> getTasksMonthMap(Map<EthereumAddress, Task> tasks) async {
    late Map<String, Map<EthereumAddress, Task>> tasksDateMap = {};
    // Map<String, List<Task>> taskStatsLists = {};

    for (final taskContract in tasks.keys) {
      String taskDateMonth = DateFormat('yyyy-MM').format(tasks[taskContract]!.createTime);
      if (tasksDateMap[taskDateMonth] == null) {
        tasksDateMap[taskDateMonth] = {};
      }
      tasksDateMap[taskDateMonth]![taskContract] = tasks[taskContract]!;
    }

    return tasksDateMap;
  }

  Future<Map<String, Map<String, int>>> getTasksStats(Map<EthereumAddress, Task> tasks) async {
    late List createTimeList = [];
    late List taskTypeList = [];
    late List tagsList = [];
    late List tagsNFTList = [];
    late List taskStateList = [];
    late List auditStateList = [];
    late List ratingList = [];
    late List contractOwnerList = [];
    late List performerList = [];
    late List participantsList = [];
    late List fundersList = [];
    late List auditorList = [];
    late List auditorsList = [];
    late List tokenNamesList = [];
    late List tokenValuesList = [];
    // Map<String, List<Task>> taskStatsLists = {};

    for (final task in tasks.values) {
      String taskDate = DateFormat('yyyy-MM-dd').format(task.createTime);
      // taskStatsLists[taskDate]!.add(task);
      createTimeList.add(taskDate);
      taskTypeList.add(task.taskType);
      tagsList.addAll(task.tags);
      tagsNFTList.addAll(task.tagsNFT);
      taskStateList.add(task.taskState);
      auditStateList.add(task.auditState);
      ratingList.add(task.rating);
      contractOwnerList.add(task.contractOwner);
      performerList.add(task.performer);
      participantsList.addAll(task.participants);
      fundersList.addAll(task.funders);
      auditorList.add(task.auditor);
      auditorsList.addAll(task.auditors);
      // tokenNamesList.add(task.tokenBalanceNames);
      tokenValuesList.add(task.tokenBalances);
    }

    // tagsList.map((e) {
    //   return statsTagsListCounts.containsKey(e) ? statsTagsListCounts[e]++ : statsTagsListCounts[e] = 1;
    // });

    // print(statsTagsListCounts);

    Map<String, Map<String, int>> stats = {};

    stats['statsCreateTimeListCounts'] = countOccurences(createTimeList);
    stats['statsTaskTypeListCounts'] = countOccurences(taskTypeList);
    stats['statsTagsListCounts'] = countOccurences(tagsList);
    stats['statsTagsNFTListCounts'] = countOccurences(tagsNFTList);
    stats['statsTaskStateListCounts'] = countOccurences(taskStateList);
    stats['statsAuditStateListCounts'] = countOccurences(auditStateList);
    stats['statsRatingListCounts'] = countOccurences(ratingList);
    stats['statsContractOwnerListCounts'] = countOccurences(contractOwnerList);
    stats['statsPerformerListCounts'] = countOccurences(performerList);
    stats['statsParticipantsListCounts'] = countOccurences(participantsList);
    stats['statsFundersListCounts'] = countOccurences(fundersList);
    stats['statsAuditorListCounts'] = countOccurences(auditorList);
    stats['statsAuditorsListCounts'] = countOccurences(auditorsList);
    stats['statsTokenNamesListCounts'] = countOccurences(tokenNamesList);
    stats['statsTokenValuesListCounts'] = countOccurences(tokenValuesList);
    return stats;
  }

  countOccurences(list) {
    Map<String, int> map = {};
    for (var i in list) {
      if (!map.containsKey(i)) {
        map[i.toString()] = 1;
      } else {
        map[i] = map[i]! + 1;
      }
    }
    return map;
  }

  countOccurencesDate(List<DateTime> list) {
    Map<String, int> map = {};
    for (var i in list) {
      final String date = DateFormat('yyyy-MM-dd').format(i);
      if (!map.containsKey(i)) {
        map[date.toString()] = 1;
      } else {
        map[date] = map[date]! + 1;
      }
    }
    return map;
  }

  Future<Task> loadOneTask(taskAddress) async {
    // print('loadOneTask start');
    // print(taskAddress);
    if (tasks.containsKey(taskAddress)) {
      return tasks[taskAddress]!;
    } else {
      // print('containsKey != start:');
      final Map<EthereumAddress, Task> tasksTemp = await getTasksData([taskAddress]);

      tasks[taskAddress] = tasksTemp[taskAddress]!;
      refreshTask(tasks[taskAddress]!);

      // print(tasks[taskAddress]!);
      // print('loadOneTask end');

      return tasks[taskAddress]!;
    }
  }

  Future<void> refreshTask(Task task) async {
    // Who participate in the TASK:
    if (task.performer == publicAddress) {
      // Calculate Pending among:
      // if ((task.tokenBalances[0] != 0 || task.tokenBalances[0] != 0)) {
      //   if (task.taskState == "agreed" || task.taskState == "progress" || task.taskState == "review" || task.taskState == "completed") {
      //     final double ethBalancePreciseToken = task.tokenBalances[0].toDouble() / pow(10, 18);
      //     final double ethBalanceToken = (((ethBalancePreciseToken * 10000).floor()) / 10000).toDouble();
      //     pendingBalance = pendingBalance! + ethBalanceToken;
      //     pendingBalanceToken = pendingBalanceToken! + 0;
      //   }
      // }
      // add all scored Task for calculation:
      if (task.rating != 0) {
        score = score + task.rating;
        scoredTaskCount++;
      }
    }

    // if (tasksAuditPending[task.taskAddress] != null) {
    tasksNew.remove(task.taskAddress);
    filterResults.remove(task.taskAddress);
    tasksAuditPending.remove(task.taskAddress);
    tasksAuditApplied.remove(task.taskAddress);
    tasksAuditWorkingOn.remove(task.taskAddress);
    tasksAuditComplete.remove(task.taskAddress);

    tasksCustomerSelection.remove(task.taskAddress);
    tasksCustomerProgress.remove(task.taskAddress);
    tasksCustomerComplete.remove(task.taskAddress);

    tasksPerformerParticipate.remove(task.taskAddress);
    tasksPerformerProgress.remove(task.taskAddress);
    tasksPerformerComplete.remove(task.taskAddress);
    // }

    if (task.taskState != "" &&
        (task.taskState == "agreed" || task.taskState == "progress" || task.taskState == "review" || task.taskState == "audit")) {
      if (task.contractOwner == publicAddress) {
        tasksCustomerProgress[task.taskAddress] = task;
      } else if (task.performer == publicAddress) {
        tasksPerformerProgress[task.taskAddress] = task;
      }
      if (hardhatDebug == true) {
        tasksPerformerProgress[task.taskAddress] = task;
      }
    }

    // New TASKs for all users:
    if (task.taskState != "" && task.taskState == "new") {
      if (hardhatDebug == true) {
        tasksNew[task.taskAddress] = task;
        filterResults[task.taskAddress] = task;
      }
      if (task.contractOwner == publicAddress) {
        tasksCustomerSelection[task.taskAddress] = task;
      } else if (task.participants.isNotEmpty) {
        var taskExist = false;
        for (var p = 0; p < task.participants.length; p++) {
          if (task.participants[p] == publicAddress) {
            taskExist = true;
          }
        }
        if (taskExist) {
          tasksPerformerParticipate[task.taskAddress] = task;
        } else {
          tasksNew[task.taskAddress] = task;
          filterResults[task.taskAddress] = task;
          // tasksNew.add(task);
          // filterResults.add(task);
        }
      } else {
        tasksNew[task.taskAddress] = task;
        filterResults[task.taskAddress] = task;
        // tasksNew.add(task);
        // filterResults.add(task);
      }
    }

    if (task.taskState != "" && (task.taskState == "completed" || task.taskState == "canceled")) {
      if (task.contractOwner == publicAddress) {
        tasksCustomerComplete[task.taskAddress] = task;
      } else if (task.performer == publicAddress) {
        tasksPerformerComplete[task.taskAddress] = task;
      }
      if (hardhatDebug == true) {
        tasksPerformerComplete[task.taskAddress] = task;
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
            tasksAuditApplied[task.taskAddress] = task;
          } else {
            tasksAuditPending[task.taskAddress] = task;
          }
        } else {
          tasksAuditPending[task.taskAddress] = task;
        }
      }

      if (task.auditor == publicAddress) {
        if (task.auditState == "performing") {
          tasksAuditWorkingOn[task.taskAddress] = task;
        } else if (task.auditState == "complete" || task.auditState == "finished") {
          tasksAuditComplete[task.taskAddress] = task;
        }
      }

      if (hardhatDebug == true) {
        tasksAuditApplied[task.taskAddress] = task;
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
    // isLoadingBackground = true;

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
      print('will monitor tasks in ${totalBatches} batches');
      for (var batchId = 0; batchId < totalBatches; batchId++) {
        await Future.wait<void>(monitorBatches[batchId]);
        print('monitoring ${batchId + 1} batch| total: $totalBatches batches');
        await Future.delayed(const Duration(milliseconds: 200));
      }
    } on GetTaskException {}
  }

  Future<Map<EthereumAddress, Task>> getTasksBatch(List<EthereumAddress> taskList) async {
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
        print('downloaded ${batchId + 1} batch | total: ${downloadBatches.length} batches');
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

    Map<String, Map<String, int>> totalStats = await getTasksStats(tasks);
    print(statsTagsListCounts);

    Map<String, Map<EthereumAddress, Task>> tasksDateMap = await getTasksDateMap(tasks);
    Map<String, Map<EthereumAddress, Task>> tasksWeekMap = await getTasksWeekMap(tasks);
    Map<String, Map<EthereumAddress, Task>> tasksMonthMap = await getTasksMonthMap(tasks);

    late Map<String, Map<String, Map<String, int>>> dailyStats = {};
    for (String taskDate in tasksDateMap.keys) {
      dailyStats[taskDate] = await getTasksStats(tasksDateMap[taskDate]!);
    }

    late Map<String, Map<String, Map<String, int>>> weeklyStats = {};
    for (String taskDateWeek in tasksWeekMap.keys) {
      weeklyStats[taskDateWeek] = await getTasksStats(tasksWeekMap[taskDateWeek]!);
    }

    late Map<String, Map<String, Map<String, int>>> monthlyStats = {};
    for (String taskDateMonth in tasksMonthMap.keys) {
      monthlyStats[taskDateMonth] = await getTasksStats(tasksMonthMap[taskDateMonth]!);
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
    isLoadingBackground = true;
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

    Map<EthereumAddress, Task> tasks = await getTasksBatch(taskList.reversed.toList());

    for (Task task in tasks.values) {
      await refreshTask(task);
    }

    // isLoading = false;
    isLoadingBackground = false;
    // await myBalance();
    // notifyListeners();
  }

  Future<void> fetchTasksCustomer(EthereumAddress publicAddress) async {
    isLoadingBackground = true;
    List<EthereumAddress> taskList = await taskDataFacet.getTaskContractsCustomer(publicAddress);

    filterResults.clear();

    tasksAuditPending.clear();
    tasksAuditApplied.clear();
    tasksAuditWorkingOn.clear();
    tasksAuditComplete.clear();

    tasksCustomerSelection.clear();
    tasksCustomerProgress.clear();
    tasksCustomerComplete.clear();

    Map<EthereumAddress, Task> tasks = await getTasksBatch(taskList.reversed.toList());

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
    isLoadingBackground = true;
    List<EthereumAddress> taskList = await taskDataFacet.getTaskContractsPerformer(publicAddress);

    filterResults.clear();

    tasksAuditPending.clear();
    tasksAuditApplied.clear();
    tasksAuditWorkingOn.clear();
    tasksAuditComplete.clear();

    tasksPerformerParticipate.clear();
    tasksPerformerProgress.clear();
    tasksPerformerComplete.clear();

    Map<EthereumAddress, Task> tasks = await getTasksBatch(taskList.reversed.toList());

    for (Task task in tasks.values) {
      await refreshTask(task);
    }

    isLoading = false;
    isLoadingBackground = false;
    await myBalance();
    notifyListeners();
  }

  Future<Map<String, Account>> getAccountsData(List<EthereumAddress> accountsList) async {
    List accountsDataList = await accountFacet.getAccountsData(accountsList);

    Map<String, Account> accountsData = {};
    for (final accountData in accountsDataList) {
      accountsData[accountData[0].toString()] = Account(
          walletAddress: accountData[0],
          nickName: accountData[1].toString(),
          about: accountData[2].toString(),
          customerTasks: accountData[3].cast<EthereumAddress>(),
          participantTasks: accountData[4].cast<EthereumAddress>(),
          auditParticipantTasks: accountData[5].cast<EthereumAddress>(),
          customerRating: accountData[6].cast<int>(),
          performerRating: accountData[7].cast<int>());
    }
    return accountsData;
  }

  Future<List<EthereumAddress>> getAccountsList() async {
    isLoadingBackground = true;
    List<EthereumAddress> accountsList = await accountFacet.getAccountsList();
    isLoadingBackground = false;
    return accountsList;
  }

  Future<List<EthereumAddress>> getTaskListFull() async {
    isLoadingBackground = true;
    List<EthereumAddress> taskList = await taskDataFacet.getTaskContracts();
    List<EthereumAddress> taskListReversed = List.from(taskList.reversed);
    isLoadingBackground = false;
    return taskListReversed;
  }

  Future<List> getTaskListCustomers(List<EthereumAddress> publicAddresses) async {
    isLoadingBackground = true;
    List taskList = await taskDataFacet.getTaskContractsCustomers(publicAddresses);
    List taskListReversed = List.from(taskList.reversed);
    isLoadingBackground = false;
    return taskListReversed;
  }

  Future<List> getTaskListPerformers(List<EthereumAddress> publicAddresses) async {
    isLoadingBackground = true;
    List taskList = await taskDataFacet.getTaskContractsPerformers(publicAddresses);
    List taskListReversed = List.from(taskList.reversed);
    isLoadingBackground = false;
    return taskListReversed;
  }

  Future<List> getTaskListCustomer(EthereumAddress publicAddress) async {
    isLoadingBackground = true;
    List taskList = await taskDataFacet.getTaskContractsCustomer(publicAddress);
    List taskListReversed = List.from(taskList.reversed);
    isLoadingBackground = false;
    return taskListReversed;
  }

  Future<List> getTaskListPerformer(EthereumAddress publicAddress) async {
    isLoadingBackground = true;
    List taskList = await taskDataFacet.getTaskContractsPerformer(publicAddress);
    List taskListReversed = List.from(taskList.reversed);
    isLoadingBackground = false;
    return taskListReversed;
  }

  Future<List> getTaskListByState(String state) async {
    isLoadingBackground = true;
    List taskList = await taskDataFacet.getTaskContractsByState(state);
    List taskListReversed = List.from(taskList.reversed);
    isLoadingBackground = false;
    return taskListReversed;
  }

  // Future<Map<EthereumAddress, Task>> getTasks(List taskList) async {
  //   Map<EthereumAddress, Task> tasks = {};
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

  Future<void> approveSpend(
      EthereumAddress _contractAddress, EthereumAddress publicAddress, BigInt amount, String nanoId, bool initial, String operationName) async {
    var creds;
    var senderAddress;
    if (initial) {
      transactionStatuses[nanoId] = {
        operationName: {'status': 'pending', 'tokenApproved': 'initial', 'txn': 'initial'}
      };
    }
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
    transactionStatuses[nanoId]![operationName]!['tokenApproved'] = 'approved';
    notifyListeners();
    await tellMeHasItMined(result, operationName, nanoId);

    // print('mined');
  }

  late bool isRequestApproved = false;

  Future<void> isApproved() async {
    isLoadingBackground = true;
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

    List<EthereumAddress> tokenContracts = [_contractAddress];

    for (var i = 0; i < tokenContracts.length; i++) {
      var ierc165 = IERC165(address: tokenContracts[i], client: _web3client, chainId: chainId);
      //check if ERC-1155
      var interfaceID = Uint8List.fromList(hex.decode('4e2312e0'));
      var supportsInterface = await ierc165.supportsInterface(interfaceID);
      if (await ierc165.supportsInterface(Uint8List.fromList(interfaceID)) == true) {
        var ierc1155 = IERC1155(address: tokenContracts[i], client: _web3client, chainId: chainId);
        if (await ierc1155.isApprovedForAll(senderAddress, _contractAddress) == false) {
          isRequestApproved = true;
          await ierc1155.setApprovalForAll(_contractAddress, true, credentials: creds, transaction: transaction);
          notifyListeners();
        }
      }
    }
    isLoadingBackground = false;
  }

  Future<Map<EthereumAddress, bool>> isTokenApproved(tokenContracts, amounts) async {
    isLoadingBackground = true;
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

    Map<EthereumAddress, bool> tokenContractsApproved = {};

    for (var i = 0; i < tokenContracts.length; i++) {
      var ierc165 = IERC165(address: tokenContracts[i], client: _web3client, chainId: chainId);
      //check if ERC-1155
      var erc1155InterfaceID = Uint8List.fromList(hex.decode('4e2312e0'));
      var erc20InterfaceID = Uint8List.fromList(hex.decode('36372b07'));
      var erc721InterfaceID = Uint8List.fromList(hex.decode('80ac58cd'));
      if (await ierc165.supportsInterface(Uint8List.fromList(erc1155InterfaceID)) == true) {
        var ierc1155 = IERC1155(address: tokenContracts[i], client: _web3client, chainId: chainId);
        if (await ierc1155.isApprovedForAll(senderAddress, tokenContracts[i]) == false) {
          tokenContractsApproved[tokenContracts[i]] = false;
        } else {
          tokenContractsApproved[tokenContracts[i]] = true;
        }
      } else if (await ierc165.supportsInterface(Uint8List.fromList(erc20InterfaceID)) == true) {
        var ierc20 = IERC20(address: tokenContracts[i], client: _web3client, chainId: chainId);
        if (await ierc20.allowance(senderAddress, tokenContracts[i]) >= amounts[i]) {
          tokenContractsApproved[tokenContracts[i]] = false;
        } else {
          tokenContractsApproved[tokenContracts[i]] = true;
        }
      } else if (await ierc165.supportsInterface(Uint8List.fromList(erc721InterfaceID)) == true) {
        var ierc721 = IERC721(address: tokenContracts[i], client: _web3client, chainId: chainId);
        if (await ierc721.isApprovedForAll(senderAddress, tokenContracts[i]) == false) {
          tokenContractsApproved[tokenContracts[i]] = false;
        } else {
          tokenContractsApproved[tokenContracts[i]] = true;
        }
      }
    }
    isLoadingBackground = false;
    return tokenContractsApproved;
  }

  Future<void> setApprovalForAll(tokenContracts, amounts) async {
    var creds;
    var senderAddress;

    transactionStatuses['setApprovalForAll'] = {
      'setApprovalForAll': {'status': 'pending', 'txn': 'initial'}
    };
    late String txn;

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

    Map<EthereumAddress, bool> tokenContractsApproved = {};

    for (var i = 0; i < tokenContracts.length; i++) {
      var ierc165 = IERC165(address: tokenContracts[i], client: _web3client, chainId: chainId);
      //check if ERC-1155
      var interfaceID = Uint8List.fromList(hex.decode('4e2312e0'));
      var erc20InterfaceID = Uint8List.fromList(hex.decode('36372b07'));
      var erc721InterfaceID = Uint8List.fromList(hex.decode('80ac58cd'));
      if (await ierc165.supportsInterface(Uint8List.fromList(interfaceID)) == true) {
        var ierc1155 = IERC1155(address: tokenContracts[i], client: _web3client, chainId: chainId);
        if (await ierc1155.isApprovedForAll(senderAddress, tokenContracts[i]) == false) {
          txn = await ierc1155.setApprovalForAll(_contractAddress, true, credentials: creds, transaction: transaction);
        }
      } else if (await ierc165.supportsInterface(Uint8List.fromList(erc20InterfaceID)) == true) {
        var ierc20 = IERC20(address: tokenContracts[i], client: _web3client, chainId: chainId);
        if (await ierc20.allowance(senderAddress, tokenContracts[i]) < amounts[i]) {
          txn = await ierc20.approve(_contractAddress, amounts[i], credentials: creds, transaction: transaction);
        }
      } else if (await ierc165.supportsInterface(Uint8List.fromList(erc721InterfaceID)) == true) {
        var ierc721 = IERC721(address: tokenContracts[i], client: _web3client, chainId: chainId);
        if (await ierc721.isApprovedForAll(senderAddress, tokenContracts[i]) == false) {
          txn = await ierc721.setApprovalForAll(_contractAddress, true, credentials: creds, transaction: transaction);
        }
      }
    }

    transactionStatuses['setApprovalForAll']!['setApprovalForAll']!['status'] = 'confirmed';
    transactionStatuses['setApprovalForAll']!['setApprovalForAll']!['tokenApproved'] = 'complete';
    transactionStatuses['setApprovalForAll']!['setApprovalForAll']!['txn'] = txn;
    notifyListeners();
    await tellMeHasItMined(txn, 'setApprovalForAll', 'setApprovalForAll');
  }

  String taskTokenSymbol = 'ETH';
  Future<void> createTaskContract(String title, String description, String repository, double price, String nanoId, List<String> tags,
      List<List<BigInt>> tokenIds, List<List<BigInt>> tokenAmounts, List<EthereumAddress> tokenContracts) async {
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
        creds = EthPrivateKey.fromHex(hardhatAccounts[0]["key"]);
        senderAddress = EthereumAddress.fromHex(hardhatAccounts[0]["address"]);
      } else {
        creds = credentials;
        senderAddress = publicAddress;
      }
      int historicalBlocks = 10;
      if (hardhatDebug || hardhatLive) {
        historicalBlocks = 1;
      }
      // final fees = await _web3client.getGasInEIP1559(historicalBlocks: historicalBlocks);
      // final gasPrice = await _web3client.getGasPrice();

      final transaction = Transaction(
        from: senderAddress,
        // gasPrice: gasPrice,
        // maxFeePerGas: fees['medium']?.maxFeePerGas,
        // maxPriorityFeePerGas: fees['medium']?.maxPriorityFeePerGas
      );

      // List<String> tags = [];
      // List<List<String>> tokenNames = [
      //   ["dodao"]
      // ];
      // List<EthereumAddress> tokenContracts = [_contractAddress];
      // List<List<BigInt>> tokenIds = [tokenIds];
      // List<List<BigInt>> tokenAmounts = [amounts];

      for (var i = 0; i < tokenContracts.length; i++) {
        if (tokenContracts[i] != EthereumAddress.fromHex('0x0000000000000000000000000000000000000000')) {
          var ierc165 = IERC165(address: tokenContracts[i], client: _web3client, chainId: chainId);
          //check if ERC-1155
          var interfaceID = Uint8List.fromList(hex.decode('4e2312e0'));
          var supportsInterface = await ierc165.supportsInterface(interfaceID);
          if (await ierc165.supportsInterface(Uint8List.fromList(interfaceID)) == true) {
            var ierc1155 = IERC1155(address: tokenContracts[i], client: _web3client, chainId: chainId);
            if (await ierc1155.isApprovedForAll(senderAddress, _contractAddress) == false) {
              isRequestApproved = true;
              await ierc1155.setApprovalForAll(_contractAddress, true, credentials: creds, transaction: transaction);
            }
          }
        }
      }
      // late TaskData taskData =
      //     new TaskData(nanoId: nanoId, taskType: taskType, title: title, description: description, symbols: symbols, amounts: amounts);

      Map<String, dynamic> taskData = {
        "nanoId": nanoId,
        "taskType": taskType,
        "title": title,
        "description": description,
        "repository": repository,
        "tags": tags,
        "tokenContracts": tokenContracts,
        "tokenIds": tokenIds,
        "tokenAmounts": tokenAmounts
      };

      if (taskTokenSymbol == 'ETH') {
        final transaction = Transaction(
          from: senderAddress,
          value: EtherAmount.fromUnitAndValue(EtherUnit.gwei, priceInGwei),
        );

        // txn = await taskDataFacet.createTaskContract(nanoId, taskType, title, description, taskTokenSymbol, priceInBigInt,
        //     credentials: creds, transaction: transaction);

        if ((!allowedChainIds.contains(chainId) && chainId != 31337) && interchainSelected == 'axelar') {
          txn = await axelarFacet.createTaskContractAxelar(senderAddress, taskData, credentials: credentials, transaction: transaction);
        } else if ((!allowedChainIds.contains(chainId) && chainId != 31337) && interchainSelected == 'hyperlane') {
          txn = await hyperlaneFacet.createTaskContractHyperlane(senderAddress, taskData, credentials: credentials, transaction: transaction);
        } else if ((!allowedChainIds.contains(chainId) && chainId != 31337) && interchainSelected == 'layerzero') {
          txn = await layerzeroFacet.createTaskContractLayerzero(senderAddress, taskData, credentials: credentials, transaction: transaction);
        } else if ((!allowedChainIds.contains(chainId) && chainId != 31337) && interchainSelected == 'wormhole') {
          txn = await wormholeFacet.createTaskContractWormhole(senderAddress, taskData, credentials: credentials, transaction: transaction);
        } else {
          txn = await taskCreateFacet.createTaskContract(senderAddress, taskData, credentials: creds, transaction: transaction);
        }
      } else if (taskTokenSymbol == 'USDC') {
        isRequestApproved = true;
        await approveSpend(_contractAddress, publicAddress!, priceInBigInt, nanoId, false, 'createTaskContract');
        final transaction = Transaction(
          from: senderAddress,
          // value: EtherAmount.fromUnitAndValue(EtherUnit.gwei, priceInGwei),
        );

        // txn = await taskCreateFacet.createTaskContract(nanoId, taskType, title, description, taskTokenSymbol, priceInBigInt,
        //     credentials: creds, transaction: transaction);

        if ((!allowedChainIds.contains(chainId) && chainId != 31337) && interchainSelected == 'axelar') {
          txn = await axelarFacet.createTaskContractAxelar(senderAddress, taskData, credentials: credentials, transaction: transaction);
        } else if ((!allowedChainIds.contains(chainId) && chainId != 31337) && interchainSelected == 'hyperlane') {
          txn = await hyperlaneFacet.createTaskContractHyperlane(senderAddress, taskData, credentials: credentials, transaction: transaction);
        } else if ((!allowedChainIds.contains(chainId) && chainId != 31337) && interchainSelected == 'layerzero') {
          txn = await layerzeroFacet.createTaskContractLayerzero(senderAddress, taskData, credentials: credentials, transaction: transaction);
        } else if ((!allowedChainIds.contains(chainId) && chainId != 31337) && interchainSelected == 'wormhole') {
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
      notifyListeners();
      tellMeHasItMined(txn, 'createTaskContract', nanoId);

      // notifyListeners();
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
    } else if (taskTokenSymbol == 'USDC') {
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
    notifyListeners();
    tellMeHasItMined(txn, 'addTokens', nanoId);
    // notifyListeners();
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
    if ((!allowedChainIds.contains(chainId) && chainId != 31337) && interchainSelected == 'axelar') {
      txn = await axelarFacet.taskParticipateAxelar(senderAddress, contractAddress, message, replyTo, credentials: creds, transaction: transaction);
    } else if ((!allowedChainIds.contains(chainId) && chainId != 31337) && interchainSelected == 'hyperlane') {
      txn = await hyperlaneFacet.taskParticipateHyperlane(senderAddress, contractAddress, message, replyTo,
          credentials: creds, transaction: transaction);
    } else if ((!allowedChainIds.contains(chainId) && chainId != 31337) && interchainSelected == 'layerzero') {
      txn = await layerzeroFacet.taskParticipateLayerzero(senderAddress, contractAddress, message, replyTo,
          credentials: creds, transaction: transaction);
    } else if ((!allowedChainIds.contains(chainId) && chainId != 31337) && interchainSelected == 'wormhole') {
      txn =
          await wormholeFacet.taskParticipateWormhole(senderAddress, contractAddress, message, replyTo, credentials: creds, transaction: transaction);
    } else {
      txn = await taskContract.taskParticipate(senderAddress, message, replyTo, credentials: creds, transaction: transaction);
    }
    if (txn.length != 66) {
      Task task = await loadOneTask(contractAddress);
      tasks[contractAddress]!.loadingIndicator = false;
      await refreshTask(task);
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
    // if ((!allowedChainIds.contains(chainId) && chainId != 31337) && interchainSelected == 'axelar') {
    //   txn = await axelarFacet.taskAuditParticipateAxelar(contractAddress, message, replyTo,
    //       credentials: creds, transaction: transaction);
    // } else if ((!allowedChainIds.contains(chainId) && chainId != 31337) && interchainSelected == 'hyperlane') {
    //   txn = await hyperlaneFacet.taskAuditParticipateHyperlane(contractAddress, message, replyTo,
    //       credentials: creds, transaction: transaction);
    // } else if ((!allowedChainIds.contains(chainId) && chainId != 31337) && interchainSelected == 'layerzero') {
    //   txn = await layerzeroFacet.taskAuditParticipateLayerzero(contractAddress, message, replyTo,
    //       credentials: creds, transaction: transaction);
    // } else if ((!allowedChainIds.contains(chainId) && chainId != 31337) && interchainSelected == 'wormhole') {
    //   txn = await wormholeFacet.taskAuditParticipateWormhole(contractAddress, message, replyTo,
    //       credentials: creds, transaction: transaction);
    // } else {
    //   txn = await taskContract.taskAuditParticipate(message, replyTo, credentials: creds, transaction: transaction);
    // }
    txn = await taskContract.taskAuditParticipate(senderAddress, message, replyTo, credentials: creds, transaction: transaction);
    if (txn.length != 66) {
      Task task = await loadOneTask(contractAddress);
      tasks[contractAddress]!.loadingIndicator = false;
      await refreshTask(task);
    }
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
    // if ((!allowedChainIds.contains(chainId) && chainId != 31337) && interchainSelected == 'axelar') {
    //   txn = await axelarFacet.taskStateChangeAxelar(contractAddress, participantAddress, state, message, replyTo, score,
    //       credentials: creds, transaction: transaction);
    // } else if ((!allowedChainIds.contains(chainId) && chainId != 31337) && interchainSelected == 'hyperlane') {
    //   txn = await hyperlaneFacet.taskStateChangeHyperlane(contractAddress, participantAddress, state, message, replyTo, score,
    //       credentials: creds, transaction: transaction);
    // } else if ((!allowedChainIds.contains(chainId) && chainId != 31337) && interchainSelected == 'layerzero') {
    //   txn = await layerzeroFacet.taskStateChangeLayerzero(contractAddress, participantAddress, state, message, replyTo, score,
    //       credentials: creds, transaction: transaction);
    // } else if ((!allowedChainIds.contains(chainId) && chainId != 31337) && interchainSelected == 'wormhole') {
    //   txn = await wormholeFacet.taskStateChangeWormhole(contractAddress, participantAddress, state, message, replyTo, score,
    //       credentials: creds, transaction: transaction);
    // } else {
    //   txn = await taskContract.taskStateChange(participantAddress, state, message, replyTo, score,
    //       credentials: creds, transaction: transaction);
    // }
    txn = await taskContract.taskStateChange(senderAddress, participantAddress, state, message, replyTo, score,
        credentials: creds, transaction: transaction);
    if (txn.length != 66) {
      Task task = await loadOneTask(contractAddress);
      tasks[contractAddress]!.loadingIndicator = false;
      await refreshTask(task);
    }
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
    // if ((!allowedChainIds.contains(chainId) && chainId != 31337) && interchainSelected == 'axelar') {
    //   txn = await axelarFacet.taskAuditDecisionAxelar(contractAddress, favour, message, replyTo, score,
    //       credentials: creds, transaction: transaction);
    // } else if ((!allowedChainIds.contains(chainId) && chainId != 31337) && interchainSelected == 'hyperlane') {
    //   txn = await hyperlaneFacet.taskAuditDecisionHyperlane(contractAddress, favour, message, replyTo, score,
    //       credentials: creds, transaction: transaction);
    // } else if ((!allowedChainIds.contains(chainId) && chainId != 31337) && interchainSelected == 'layerzero') {
    //   txn = await layerzeroFacet.taskAuditDecisionLayerzero(contractAddress, favour, message, replyTo, score,
    //       credentials: creds, transaction: transaction);
    // } else if ((!allowedChainIds.contains(chainId) && chainId != 31337) && interchainSelected == 'wormhole') {
    //   txn = await wormholeFacet.taskAuditDecisionWormhole(contractAddress, favour, message, replyTo, score,
    //       credentials: creds, transaction: transaction);
    // } else {
    //   txn = await taskContract.taskAuditDecision(favour, message, replyTo, score, credentials: creds, transaction: transaction);
    // }
    txn = await taskContract.taskAuditDecision(senderAddress, favour, message, replyTo, score, credentials: creds, transaction: transaction);
    if (txn.length != 66) {
      Task task = await loadOneTask(contractAddress);
      tasks[contractAddress]!.loadingIndicator = false;
      await refreshTask(task);
    }
    isLoading = false;
    // isLoadingBackground = true;
    lastTxn = txn;
    transactionStatuses[nanoId]!['taskAuditDecision']!['status'] = 'confirmed';
    transactionStatuses[nanoId]!['taskAuditDecision']!['txn'] = txn;
    notifyListeners();
    tellMeHasItMined(txn, 'taskAuditDecision', nanoId);
  }

  Future<void> sendChatMessage(EthereumAddress contractAddress, String nanoId, String message, String messageNanoID, {BigInt? replyTo}) async {
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
    // if ((!allowedChainIds.contains(chainId) && chainId != 31337) && interchainSelected == 'axelar') {
    //   txn = await axelarFacet.sendMessageAxelar(contractAddress, message, replyTo, credentials: creds, transaction: transaction);
    // } else if ((!allowedChainIds.contains(chainId) && chainId != 31337) && interchainSelected == 'hyperlane') {
    //   txn = await hyperlaneFacet.sendMessageHyperlane(contractAddress, message, replyTo, credentials: creds, transaction: transaction);
    // } else if ((!allowedChainIds.contains(chainId) && chainId != 31337) && interchainSelected == 'layerzero') {
    //   txn = await layerzeroFacet.sendMessageLayerzero(contractAddress, message, replyTo, credentials: creds, transaction: transaction);
    // } else if ((!allowedChainIds.contains(chainId) && chainId != 31337) && interchainSelected == 'wormhole') {
    //   txn = await wormholeFacet.sendMessageWormhole(contractAddress, message, replyTo, credentials: creds, transaction: transaction);
    // } else {
    //   txn = await taskContract.sendMessage(message, replyTo, credentials: creds, transaction: transaction);
    // }
    txn = await taskContract.sendMessage(senderAddress, message, replyTo, credentials: creds, transaction: transaction);
    if (txn.length != 66) {
      Task task = await loadOneTask(contractAddress);
      tasks[contractAddress]!.loadingIndicator = false;
      await refreshTask(task);
    }
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
    String chain = 'Moonbase';
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
    if (txn.length != 66) {
      Task task = await loadOneTask(contractAddress);
      tasks[contractAddress]!.loadingIndicator = false;
      await refreshTask(task);
    }
    isLoading = false;
    // isLoadingBackground = true;
    lastTxn = txn;
    transactionStatuses[nanoId]!['withdrawToChain']!['status'] = 'confirmed';
    transactionStatuses[nanoId]!['withdrawToChain']!['txn'] = txn;
    notifyListeners();
    tellMeHasItMined(txn, 'withdrawToChain', nanoId);
  }

  Future<List<String>> getCreatedTokenNames() async {
    List<String> createdTokenNames = await tokenDataFacet.getCreatedTokenNames();
    return createdTokenNames;
  }

  Future<List> balanceOfBatchName(List<EthereumAddress> addresses, List<String> names) async {
    isLoadingBackground = true;
    List balanceList = await tokenDataFacet.balanceOfBatchName(addresses, names);
    isLoadingBackground = false;
    return balanceList;
  }

  Future<List> totalSupplyOfBatchName(List<String> names) async {
    isLoadingBackground = true;
    List totalSupply = await tokenDataFacet.totalSupplyOfBatchName(names);
    isLoadingBackground = false;
    return totalSupply;
  }

  Future getTokenNames(EthereumAddress address) async {
    isLoadingBackground = true;
    List accountTokenNames = await tokenDataFacet.getTokenNames(address);
    print('getTokenNames');
    print(await tokenDataFacet.getTokenNames(address));
    isLoadingBackground = false;
    return accountTokenNames;
  }

  Future getTokenIds(EthereumAddress address) async {
    isLoadingBackground = true;
    List accountTokenIds = await tokenDataFacet.getTokenIds(address);
    isLoadingBackground = false;
    return accountTokenIds;
  }

  Future<List> uriOfBatchName(List<String> names) async {
    isLoadingBackground = true;
    List totalSupply = await tokenDataFacet.uriOfBatchName(names);
    isLoadingBackground = false;
    return totalSupply;
  }

  Future<String> createNft(String uri, String name, bool isNF) async {
    print('createNft');
    // uri - exmple.com
    // isNF - fungible or nonfungible
    transactionStatuses['createNFT'] = {
      'createNFT': {'status': 'pending', 'txn': 'initial'}
    };
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
    String txn = await tokenFacet.create(uri, name, isNF, credentials: creds, transaction: transaction);
    transactionStatuses['createNFT']!['createNFT']!['status'] = 'confirmed';
    transactionStatuses['createNFT']!['createNFT']!['txn'] = txn;
    notifyListeners();
    tellMeHasItMined(txn, 'createNFT', 'createNFT');
    return txn;
  }

  Future<String> mintFungibleByName(String name, List<EthereumAddress> addresses, List<BigInt> quantities) async {
    print('mintFungibleByName');
    transactionStatuses['mintFungible'] = {
      'mintFungible': {'status': 'pending', 'txn': 'initial'}
    };
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
    transactionStatuses['mintFungible']!['mintFungible']!['status'] = 'confirmed';
    transactionStatuses['mintFungible']!['mintFungible']!['txn'] = txn;
    notifyListeners();
    tellMeHasItMined(txn, 'mintFungible', 'mintFungible');
    return txn;
  }

  Future<String> mintNonFungibleByName(String name, List<EthereumAddress> addresses, List<BigInt> quantities) async {
    print('mintNonFungibleByName');
    transactionStatuses['mintNonFungible'] = {
      'mintNonFungible': {'status': 'pending', 'txn': 'initial'}
    };
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
    transactionStatuses['mintNonFungible']!['mintNonFungible']!['status'] = 'confirmed';
    transactionStatuses['mintNonFungible']!['mintNonFungible']!['txn'] = txn;
    notifyListeners();
    tellMeHasItMined(txn, 'mintNonFungible', 'mintNonFungible');
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

  late String witnetPostResult = 'check not initialized';
  late bool witnetAvailabilityResult = false;
  late List witnetGetLastResult = [false, false, ''];
  // late String saveSuccessfulWitnetResult = witnetSuccessfulResult;

  Future<String> postWitnetRequest(EthereumAddress taskAddress, String nanoId) async {
    print('postWitnetRequest');
    transactionStatuses[nanoId] = {
      'postWitnetRequest': {
        'status': 'pending',
        'txn': 'initial',
        'witnetPostResult': 'initialized request',
        'witnetGetLastResult': [false, false, '']
      }
    };
    witnetPostResult = 'initialized request';
    notifyListeners();
    var creds;
    var senderAddress;
    if (hardhatDebug == true) {
      creds = EthPrivateKey.fromHex(hardhatAccounts[0]["key"]);
      senderAddress = EthereumAddress.fromHex(hardhatAccounts[0]["address"]);
    } else {
      creds = credentials;
      senderAddress = publicAddress;
    }
    final transaction = Transaction(from: senderAddress, value: EtherAmount.fromUnitAndValue(EtherUnit.gwei, 10000000), maxGas: 2000000);
    // maxFeePerGas: EtherAmount.fromUnitAndValue(EtherUnit.gwei, 10000000));

    // List args = ["devopsdao/devopsdao-smart-contract-diamond", "preparing witnet release"];
    String txn = await witnetFacet.postRequest$2(taskAddress, credentials: creds, transaction: transaction);
    transactionStatuses[nanoId]!['postWitnetRequest']!['status'] = 'confirmed';
    transactionStatuses[nanoId]!['postWitnetRequest']!['txn'] = txn;
    notifyListeners();
    tellMeHasItMined(txn, 'postWitnetRequest', nanoId);
    if (txn.length == 66) {
      witnetPostResult = 'request mined';
      witnetGetLastResult = [false, false, 'checking'];
      transactionStatuses[nanoId]!['postWitnetRequest']!['witnetPostResult'] = 'request mined';
      transactionStatuses[nanoId]!['postWitnetRequest']!['witnetGetLastResult'] = [false, false, 'checking'];
      checkWitnetResultAvailabilityTimer(taskAddress, nanoId);
    } else {
      witnetPostResult = 'request failed';
      transactionStatuses[nanoId]!['postWitnetRequest']!['witnetPostResult'] = 'request failed';
    }
    notifyListeners();
    return txn;
  }

  Future checkWitnetResultAvailabilityTimer(EthereumAddress taskAddress, String nanoId) async {
    BigInt appId = BigInt.from(100);
    Timer.periodic(const Duration(seconds: 15), (timer) async {
      // print(timer.tick);
      bool result = await witnetFacet.checkResultAvailability(taskAddress);
      print(result);
      if (result) {
        var lastResult = await witnetFacet.getLastResult(taskAddress);

        if (lastResult[0] == false && lastResult[1] == false && lastResult[2] == '') {
          print('old result received');
        } else {
          if (transactionStatuses.containsKey(nanoId)) {
            witnetPostResult = 'result available';
          } else {
            transactionStatuses[nanoId] = {
              'postWitnetRequest': {
                'status': 'confirmed',
                'txn': 'none',
                'witnetPostResult': 'result available',
                'witnetGetLastResult': [false, false, 'checking']
              }
            };
          }
          witnetAvailabilityResult = result;
          notifyListeners();
          getLastWitnetResultTimer(taskAddress, nanoId);
          getLastWitnetResult(taskAddress, nanoId);
          timer.cancel();
        }
      }
    });
    // return result;
  }

  Future checkWitnetResultAvailability(EthereumAddress taskAddress, String nanoId) async {
    BigInt appId = BigInt.from(100);
    // print(timer.tick);
    bool result = await witnetFacet.checkResultAvailability(taskAddress);
    print(result);
    if (result) {
      var lastResult = await witnetFacet.getLastResult(taskAddress);

      if (lastResult[0] == false && lastResult[1] == false && lastResult[2] == '') {
        print('old result received');
      } else {
        if (transactionStatuses.containsKey(nanoId)) {
          witnetPostResult = 'result available';
        } else {
          transactionStatuses[nanoId] = {
            'postWitnetRequest': {
              'status': 'confirmed',
              'txn': 'none',
              'witnetPostResult': 'result available',
              'witnetGetLastResult': [false, false, 'checking']
            }
          };
        }
        witnetAvailabilityResult = result;
        notifyListeners();
        getLastWitnetResult(taskAddress, nanoId);
      }
    }
    // return result;
  }

  /*
    getLastWitnetResult returns result array:
    0 failed: bool,
    1 pendingMerge: bool,
    2 status: text(closed/(unmerged))
  */
  Future<dynamic> getLastWitnetResultTimer(EthereumAddress taskAddress, String nanoId) async {
    Timer.periodic(const Duration(seconds: 15), (timer) async {
      // print(timer.tick);

      var result = await witnetFacet.getLastResult(taskAddress);
      print(result);

      transactionStatuses[nanoId]!['postWitnetRequest']!['witnetGetLastResult'] = result;
      witnetGetLastResult = result;
      timer.cancel();
      notifyListeners();
    });
  }

  Future<dynamic> getLastWitnetResult(EthereumAddress taskAddress, String nanoId) async {
    // print(timer.tick);
    var result = await witnetFacet.getLastResult(taskAddress);
    print(result);

    transactionStatuses[nanoId]!['postWitnetRequest']!['witnetGetLastResult'] = result;
    witnetGetLastResult = result;
    notifyListeners();
  }

  Future<dynamic> saveSuccessfulWitnetResult(EthereumAddress taskAddress, String nanoId) async {
    transactionStatuses[nanoId]!['saveLastWitnetResult'] = {'status': 'pending', 'txn': 'initial'};
    var creds;
    var senderAddress;
    if (hardhatDebug == true) {
      creds = EthPrivateKey.fromHex(hardhatAccounts[0]["key"]);
      senderAddress = EthereumAddress.fromHex(hardhatAccounts[0]["address"]);
    } else {
      creds = credentials;
      senderAddress = publicAddress;
    }
    final transaction = Transaction(from: senderAddress, maxGas: 2000000);

    String txn = await witnetFacet.saveSuccessfulResult(taskAddress, credentials: creds, transaction: transaction);
    transactionStatuses[nanoId]!['saveLastWitnetResult']!['status'] = 'confirmed';
    transactionStatuses[nanoId]!['saveLastWitnetResult']!['txn'] = txn;
    notifyListeners();
    tellMeHasItMined(txn, 'saveLastWitnetResult', nanoId);
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

  Uint8List convertStringToUint8List(String str) {
    final List<int> codeUnits = str.codeUnits;
    final Uint8List unit8List = Uint8List.fromList(codeUnits);

    return unit8List;
  }

  Uint8List hexToUint8List(String hex) {
    if (hex.length % 2 != 0) {
      throw 'Odd number of hex digits';
    }
    var l = hex.length ~/ 2;
    var result = Uint8List(l);
    for (var i = 0; i < l; ++i) {
      var x = int.parse(hex.substring(2 * i, 2 * (i + 1)), radix: 16);
      if (x.isNaN) {
        throw 'Expected hex string';
      }
      result[i] = x;
    }
    return result;
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
