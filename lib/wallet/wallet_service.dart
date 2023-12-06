import 'dart:async';
import 'dart:convert';

import 'package:dodao/wallet/wallet_model_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:walletconnect_flutter_v2/walletconnect_flutter_v2.dart';
import 'package:webthree/credentials.dart';
import 'package:logging/logging.dart';

import '../blockchain/chain_presets/chains_presets.dart';
import '../blockchain/chain_presets/chains_presets.dart';

enum WCStatus {
  loadingQr, // Waiting for QR code. resetting views; shimmer running; Disconnect button
  // :: Initial Start, Connect, Refresh Qr, Disconnect, On selected Network ::
  loadingWc, // Pairing progress; Disconnect button :: onSessionConnect fires
  wcNotConnected, // show nothing and Connect button // !!! will be deprecated
  wcNotConnectedWithQrReady, // Ready to scan Qr message; Refresh Qr button :: should run probably after loadingQr
  wcNotConnectedAddNetwork,
  wcConnectedNetworkMatch, // connected Ok message; show network name; Disconnect button
  wcConnectedNetworkNotMatch, // Show "not match" message; connect button (switch network in next build);
  wcConnectedNetworkUnknown, // Show Unknown network message; connect button (switch network in next build);
  error, // error message; resetting views; show connect button;
  none,
}

//
// class WalletStatesStorage {
//   bool walletConnected = false;
//   bool allowedChainId = false;
//
//   // late bool unknownChainIdWC = false;
//   // late bool preventEvent = false; // sets true once in onSessionConnect, is necessary to prevent the first onSessionEvent(chainChanged)
//   // late String selectedChainNameOnApp = ''; // if empty, initially will be rewritten with tasksServices.defaultNetworkName
//   // late int chainIdOnWallet = 0;
//   // late int lastErrorOnNetworkChainId = 0;
//   // late String chainNameOnWallet = '';
//   // late String walletConnectUri = '';
//   // late String errorMessage = '';
//   // late WCStatus wcCurrentState = WCStatus.loadingQr;
//   //
//   // /// Metamask part:
//   // String platform = '';
//   // var credentials;
//   // EthereumAddress? publicAddress;
//   // EthereumAddress? publicAddressMM;
//   //
//   // /// WalletConnect part:
//   // EthereumAddress? publicAddressWC;
// }


// class WalletService {
//   // Service and state storage (temporary)
//   bool walletConnected = false;
//   bool allowedChainId = false;
//   Future<void> initialize() async {
//     walletConnected = false;
//     allowedChainId = false;
//   }
//
//   void chainIdService(bool state) {
//     allowedChainId = state;
//
//   }
//
//   void walletConnectedService(bool state) {
//     walletConnected = state;
//   }
// }


// class WalletModel extends ChangeNotifier {
//   bool walletConnected = false;
//
//   late WCStatus wcCurrentState = WCStatus.loadingQr;
//   Future<void> setWcState({required WCStatus state, required tasksServices, String error = ''}) async {
//     wcCurrentState = state;
//     switch (state) {
//       case WCStatus.loadingQr:
//         await resetView(tasksServices);
//         break;
//       case WCStatus.loadingWc:
//         break;
//       case WCStatus.wcNotConnected:
//         break;
//       case WCStatus.wcConnectedNetworkMatch:
//         break;
//       case WCStatus.wcConnectedNetworkNotMatch:
//         break;
//       case WCStatus.wcConnectedNetworkUnknown:
//         break;
//       case WCStatus.error:
//         errorMessage = error;
//         await resetView(tasksServices);
//         selectedChainNameOnApp = tasksServices.defaultNetworkName;
//         tasksServices.chainId = tasksServices.allowedChainIds[tasksServices.defaultNetworkName]!;
//         break;
//       case WCStatus.wcNotConnectedWithQrReady:
//       // TODO: Handle this case.
//         break;
//       case WCStatus.none:
//       // TODO: Handle this case.
//         break;
//     }
//     notifyListeners();
//   }
//
//   Future<void> resetView(tasksServices) async {
//     walletConnected = false;
//     tasksServices.walletConnectedWC = false;
//     tasksServices.publicAddress = null;
//     tasksServices.publicAddressWC = null;
//     tasksServices.allowedChainId = false;
//     unknownChainIdWC = false;
//     chainIdOnWallet = 0;
//     chainNameOnWallet = '';
//     tasksServices.ethBalance = 0.0;
//     tasksServices.ethBalanceToken = 0.0;
//     tasksServices.pendingBalance = 0.0;
//     tasksServices.pendingBalanceToken = 0.0;
//     walletConnectUri = '';
//   }
//
// }

class WalletProvider extends ChangeNotifier {
  //////////// *******New State Model******** //////////////////
  final _walletService = WalletService();

  var _state = WalletModelState(
    allowedChainId: false,
    walletConnected: false,
  );
  WalletModelState get state => _state;

  Future<void> setAllowedChainId(bool state) async {
    _walletService.chainIdService(state);
    _updateState();
  }

  Future<void> setWalletConnected(bool state) async {
    _walletService.walletConnectedService(state);
    _updateState();
  }

  void _updateState() {
    final allowedChainId = WalletService.allowedChainId;
    final walletConnected = WalletService.walletConnected;
    _state = WalletModelState(
        walletConnected: walletConnected,
        allowedChainId: allowedChainId,
    );
    notifyListeners();
  }
  //////////// *******New State Model END******** //////////////////


  late Web3App? web3App;
  late ConnectResponse? connectResponse;

  late bool initComplete = false;
  late bool unknownChainIdWC = false;
  late bool walletConnectedWC = false;
  late bool preventEvent = false; // sets true once in onSessionConnect, is necessary to prevent the first onSessionEvent(chainChanged)
  late String selectedChainNameOnApp = ''; // if empty, initially will be rewritten with tasksServices.defaultNetworkName
  late int chainIdOnWallet = 0;
  late int lastErrorOnNetworkChainId = 0;
  late String chainNameOnWallet = '';
  late String walletConnectUri = '';
  late String errorMessage = '';
  late WCStatus wcCurrentState = WCStatus.loadingQr;

  final log = Logger('WalletProvider');
  // late int currentSelectedChainId = 0;

  WalletProvider() {
    init();
  }

  Future<void> init() async {
    await _walletService.initialize();
    _updateState();
    await initWalletConnect();
    initComplete = true;
    // notifyListeners();
  }

  Future<void> setWcState({required WCStatus state, required tasksServices, String error = ''}) async {
    wcCurrentState = state;
    switch (state) {
      case WCStatus.loadingQr:
        await resetView(tasksServices);
        break;
      case WCStatus.loadingWc:
        break;
      case WCStatus.wcNotConnected:
        break;
      case WCStatus.wcConnectedNetworkMatch:
        break;
      case WCStatus.wcConnectedNetworkNotMatch:
        break;
      case WCStatus.wcConnectedNetworkUnknown:
        break;
      case WCStatus.error:
        errorMessage = error;
        await resetView(tasksServices);
        selectedChainNameOnApp = tasksServices.defaultNetworkName;
        tasksServices.chainId = tasksServices.allowedChainIds[tasksServices.defaultNetworkName]!;
        break;
      case WCStatus.wcNotConnectedWithQrReady:
        // TODO: Handle this case.
        break;
      case WCStatus.none:
        // TODO: Handle this case.
        break;
      case WCStatus.wcNotConnectedAddNetwork:
        // TODO: Handle this case.
        break;
    }
    notifyListeners();
  }

  Future<void> setSelectedNetworkName(value) async {
    selectedChainNameOnApp = value;
  }
  //
  // Future<void> closeWalletDialog(tasksServices) async {
  //   tasksServices.closeWalletDialog = true;
  //   notifyListeners();
  // }

  Future<void> initWalletConnect() async {
    web3App = await Web3App.createInstance(
      projectId: '98a940d6677c21307eaa65e2290a7882',
      metadata: const PairingMetadata(
        name: 'dodao.dev',
        description: 'Decentralzied marketplace for coders and art-creators',
        url: 'https://walletconnect.com/',
        icons: [
          'https://walletconnect.com/walletconnect-logo.png',
        ],
      ),
    );
  }

  Future<void> registerEventHandlers(taskServices) async {
    final Map<String, int> chain = taskServices.allowedChainIds;
    for (String key in chain.keys) {
      web3App?.registerEventHandler(
        chainId: 'eip155:${chain[key]}',
        event: 'chainChanged',
      );
      web3App?.registerEventHandler(
        chainId: 'eip155:${chain[key]}',
        event: 'accountsChanged',
      );
    }
  }

  Future<void> switchNetwork(tasksServices, int changeTo) async {
    final SessionData sessionData = await connectResponse!.session.future;
    int changeFrom = chainIdOnWallet;
    log.fine('wallet_service->switchNetwork from: $changeFrom to: $changeTo');
    // log.fine('wallet_service -> switchNetwork namespaces: ${sessionData!.namespaces.values.first}');
    final params = <String, dynamic> {
      'chainId': '0x${changeTo.toRadixString(16)}',
    };
    // bool switchNetworkSuccess = true;
    try {
      await web3App!.request(
          topic: sessionData.topic,
          chainId: 'eip155:$changeFrom',
          request: SessionRequestParams(
            method: 'wallet_switchEthereumChain',
            params: [params],
          ));
    } on JsonRpcError catch (e) {
      if (e.message != null) {
        final error = jsonDecode(e.message!);
        if (error['data'] != null && error['data']['originalError'] != null && error['data']['originalError']['code'] != null) {
          if (error['data']['originalError']['code'] == 4902) {
            try {

              await addNetwork(tasksServices, changeFrom);
            } on JsonRpcError catch (e) {
              if (e.message != null) {
                final error = jsonDecode(e.message!);
                if (error['code'] != 4001) {
                  log.severe(error);
                }
              }
              log.severe(e);
            } catch (e) {
              log.severe(e);
            }
          }
        }
      }
    } catch (e) {
      log.severe(e);
    }

    // final chainId = await web3App!
    //     .request(topic: sessionData.topic, chainId: 'eip155:$changeTo', request: SessionRequestParams(method: 'eth_chainId', params: []));
    // chainIdHex = await web3client.makeRPCCall('eth_chainId');

    // setChainAndConnect(tasksServices, changeTo);
    // return session;
  }

  Future<void> addNetwork(tasksServices, int currentChainId) async {
    final SessionData sessionData = await connectResponse!.session.future;
    log.fine('wallet_service->addNetwork, currentChainId: $currentChainId sessionData.topic: ${sessionData.topic}');
    // await setWcState(state: WCStatus.wcNotConnectedAddNetwork, tasksServices: tasksServices);
    // log.fine('wallet_service -> switchNetwork namespaces: ${sessionData!.namespaces.values.first}');
    ChainInfo entry = ChainPresets.chains.entries.firstWhere((element) {
      return element.key==tasksServices.allowedChainIds[selectedChainNameOnApp];
    }).value;
    final params = {
      'chainId': entry.chainIdHex,
      'chainName': entry.chainName,
      'nativeCurrency': { //
          'name': entry.nativeCurrency?.name,
          'symbol': entry.nativeCurrency?.symbol,
          'decimals': entry.nativeCurrency?.decimals,
      },
      'rpcUrls': [entry.rpcUrl],
      'blockExplorerUrls': [entry.blockExplorer?.url],
      'iconUrls': [entry.iconUrl],
    };

    // final int appChainId = tasksServices.allowedChainIds[selectedChainNameOnApp];
    // final params = {
    //   'chainId': ChainPresets.chains[appChainId]?.chainIdHex,
    //   'chainName': ChainPresets.chains[appChainId]?.chainName,
    //   'nativeCurrency': ChainPresets.chains[appChainId]?.nativeCurrency,
    //   'rpcUrls': [ChainPresets.chains[appChainId]?.rpcUrl],
    //   'blockExplorerUrls': [ChainPresets.chains[appChainId]?.blockExplorer?.url],
    //   'iconUrls': [ChainPresets.chains[appChainId]?.iconUrl],
    // };
    await web3App!.request(
        topic: sessionData.topic,
        chainId: 'eip155:$currentChainId',
        request: SessionRequestParams(
          method: 'wallet_addEthereumChain',
          params: [params],
        ));
    // setChainAndConnect(tasksServices, 855456);
    // return session;
  }


  Future<void> setChainAndConnect(tasksServices, context, int newChainId) async {
    final Map<String, int> allowedChainIds = tasksServices.allowedChainIds;
    WalletModelProvider walletModelProvider = Provider.of<WalletModelProvider>(context, listen: false);
    // change back to WCStatus.loadingWc if WCStatus.wcConnectedNetworkUnknown was set by onSessionConnect:
    if (wcCurrentState == WCStatus.wcConnectedNetworkUnknown) {
      wcCurrentState = WCStatus.loadingWc;
    }

    log.fine('wallet_service->setChainAndConnect chainId on app: '
        '${tasksServices.allowedChainIds[selectedChainNameOnApp]!}'
        ' , will be rewritten by id on wallet): $newChainId'
        ' , allowedChainIds: ${allowedChainIds.containsValue(newChainId)}');
    if (allowedChainIds.containsValue(newChainId)) {
      chainIdOnWallet = newChainId;
      tasksServices.chainId = newChainId;
      // save actual network names
      chainNameOnWallet = tasksServices.allowedChainIds.keys.firstWhere((k) {
            return tasksServices.allowedChainIds[k] == newChainId;
          }, orElse: () => 'unknown');
      await setSelectedNetworkName(chainNameOnWallet); // update selectedChainNameOnApp with chainNameOnWallet
      walletModelProvider.setAllowedChainId(true);
      // notifyListeners();
      await tasksServices.connectRPC(tasksServices.chainId);
      try {
        await tasksServices.startup();
        await tasksServices.collectMyTokens();
      } catch (e) {
        log.severe('wallet_service->tasksServices.startup() error: $e');
        await setWcState(state: WCStatus.error, tasksServices: tasksServices, error: 'Opps... something went wrong, try again \nBlockchain connection error');
        lastErrorOnNetworkChainId = newChainId;
        return;
      }

      await setWcState(state: WCStatus.wcConnectedNetworkMatch, tasksServices: tasksServices);

      // Timer(const Duration(seconds: 2), () {
      //   closeWalletDialog(tasksServices);
      // });

    } else {
      await setWcState(state: WCStatus.wcConnectedNetworkNotMatch, tasksServices: tasksServices);
    }
    // selectedChainNameOnApp = tasksServices.allowedChainIds.keys.firstWhere((k) => tasksServices.allowedChainIds[k]==chainIdOnApp, orElse: () => 'unknown');
  }

  Future<ConnectResponse?> createSession(tasksServices, int chainId) async {
    final String kFullChainId = 'eip155:$chainId';

    // if (walletProvider.web3App == null) {
    //   await walletProvider.initWalletConnect();
    // }

    try {
      connectResponse = await web3App!.connect(

        // requiredNamespaces: {
        //   'eip155': RequiredNamespace(
        //     chains: [kFullChainId],
        //     methods: [
        //       'eth_sign',
        //       'eth_signTransaction',
        //       'eth_sendTransaction',
        //     ],
        //     events: [
        //       'chainChanged',
        //       'accountsChanged',
        //     ],
        //   ),
        // },
        optionalNamespaces: {
          'eip155': RequiredNamespace(
            methods: [
              'eth_sign',
              'eth_signTransaction',
              'eth_sendTransaction',
              'wallet_switchEthereumChain',
              'wallet_addEthereumChain',
              'eth_chainId'
            ],
            chains: [kFullChainId],
            events: [
              'chainChanged',
              'accountsChanged',
            ],
          ),
        },
        // sessionProperties:

      );
    } on JsonRpcError catch (e) {
      if (e.message != null) {
        final error = jsonDecode(e.message!);
        if (error['code'] != 4001) {
          log.severe(error);
        }
      }
    } catch (e) {
      log.severe(e);
    }

    final String encodedUrl = Uri.encodeComponent('${connectResponse?.uri}');
    if (encodedUrl.isNotEmpty) {
      walletConnectUri = 'metamask://wc?uri=$encodedUrl';
    }
    if (tasksServices.platform == 'mobile') {
      await launchUrlString(
        walletConnectUri,
        mode: LaunchMode.externalApplication,
      );
    }
    return connectResponse;
  }

  Future<void> disconnectSessionsAndPairings() async {
    log.fine('wallet_service -> disconnect');
    // if (connectResponse != null && connectResponse?.pairingTopic != null) {
    //   await web3App?.disconnectSession(
    //     topic: connectResponse!.pairingTopic,
    //     reason: Errors.getSdkError(Errors.USER_DISCONNECTED),
    //   );
    // }

    List<PairingInfo> pairings = [];
    pairings = web3App!.pairings.getAll();
    for (var pairing in pairings) {
      web3App!.core.pairing.disconnect(
        topic: pairing.topic,
      );
    }

    // disconnectAllSessions:
    for (final SessionData session in web3App!.sessions.getAll()) {
      // Disconnecting the session will produce the onSessionDisconnect callback
      await web3App!.disconnectSession(
        topic: session.topic,
        reason: const WalletConnectError(code: 0, message: 'User disconnected'),
      );
      // Disconnect both the pairing and session
      await web3App!.disconnectSession(
        topic: session.pairingTopic,
        reason: const WalletConnectError(code: 0, message: 'User disconnected'),
      );
    }
  }

  Future<void> resetView(tasksServices) async {
    setWalletConnected(false);
    walletConnectedWC = false;
    tasksServices.publicAddress = null;
    tasksServices.publicAddressWC = null;
    setAllowedChainId(false);
    unknownChainIdWC = false;
    chainIdOnWallet = 0;
    chainNameOnWallet = '';
    tasksServices.ethBalance = 0.0;
    tasksServices.ethBalanceToken = 0.0;
    tasksServices.pendingBalance = 0.0;
    tasksServices.pendingBalanceToken = 0.0;
    walletConnectUri = '';
  }

  Future<void> unsubscribeAll() async {
    log.fine('wallet_service -> unsubscribe');
    web3App?.onSessionDelete.unsubscribeAll();
    web3App?.onSessionEvent.unsubscribeAll();
    // web3App?.onSessionEvent.unsubscribe(onSessionEvent);
    web3App?.onProposalExpire.unsubscribeAll();
    web3App?.onSessionExtend.unsubscribeAll();
    web3App?.onSessionPing.unsubscribeAll();
    web3App?.onSessionUpdate.unsubscribeAll();
    web3App?.onSessionConnect.unsubscribeAll();
    web3App?.onSessionExpire.unsubscribeAll();
  }

  Widget networkLogo(chainId, Color color, double height) {
    var networkLogoImage;
    if (chainId == 1287) {
      return networkLogoImage = Image.asset(
        'assets/images/net_icon_moonbeam.png',
        height: height,
        filterQuality: FilterQuality.medium,
      );
    } else if (chainId == 4002) {
      return networkLogoImage = Image.asset(
        'assets/images/net_icon_fantom.png',
        height: height,
        filterQuality: FilterQuality.medium,
      );
    } else if (chainId == 80001) {
      return networkLogoImage = Image.asset(
        'assets/images/net_icon_mumbai_polygon.png',
        height: height,
        filterQuality: FilterQuality.medium,
      );
    } else if (chainId == 855456) {
      return networkLogoImage = Image.asset(
        'assets/images/logo.png',
        height: height,
        filterQuality: FilterQuality.medium,
      );
    } else if (chainId == 280) {
      return networkLogoImage = Image.asset(
        'assets/images/zksync.png',
        height: height,
        filterQuality: FilterQuality.medium,
      );
    } else {
      return networkLogoImage = Image.asset(
        'assets/images/net_icon_eth.png',
        height: height,
        filterQuality: FilterQuality.medium,
      );
    }
  }
}
