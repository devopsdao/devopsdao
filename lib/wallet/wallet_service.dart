import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:walletconnect_flutter_v2/walletconnect_flutter_v2.dart';
import 'package:webthree/credentials.dart';
import 'package:logging/logging.dart';

enum WCStatus {
  loadingQr, // Waiting for QR code. resetting views; shimmer running; Disconnect button
  // :: Initial Start, Connect, Refresh Qr, Disconnect, On selected Network ::
  loadingWc, // Pairing progress; Disconnect button :: onSessionConnect fires
  wcNotConnected, // show nothing and Connect button // !!! will be deprecated
  wcNotConnectedWithQrReady, // Ready to scan Qr message; Refresh Qr button :: should run probably after loadingQr
  wcConnectedNetworkMatch, // connected Ok message; show network name; Disconnect button
  wcConnectedNetworkNotMatch, // Show "not match" message; connect button (switch network in next build);
  wcConnectedNetworkUnknown, // Show Unknown network message; connect button (switch network in next build);
  error, // error message; resetting views; show connect button;
  none,
}

class WalletProvider extends ChangeNotifier {
  late Web3App? web3App;
  late ConnectResponse? connectResponse;

  late bool initComplete = false;
  late bool unknownChainIdWC = false;
  late String chainNameOnApp = ''; // if empty, initially will be rewritten with tasksServices.defaultNetworkName
  late String chainNameOnWallet = '';
  late String walletConnectUri = '';
  late String errorMessage = '';
  late WCStatus wcCurrentState = WCStatus.loadingQr;

  final log = Logger('WalletProvider');
  // late int currentSelectedChainId = 0;
  // late int chainIdOnWallet = 0;

  WalletProvider() {
    init();
  }

  Future<void> init() async {
    await initWalletConnect();
    initComplete = true;
    notifyListeners();
  }

  Future<void> setWcState({required WCStatus state, required tasksServices, String error = ''}) async {
    wcCurrentState = state;
    switch (state) {
      case WCStatus.loadingQr:
        resetView(tasksServices);
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
        resetView(tasksServices);
        break;
    }
    notifyListeners();
  }

  Future<void> setSelectedNetworkName(value) async {
    chainNameOnApp = value;
  }

  Future<void> closeWalletDialog(tasksServices) async {
    tasksServices.closeWalletDialog = true;
    notifyListeners();
  }

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

  Future<void> switchNetwork(tasksServices, int changeFrom, int changeTo) async {
    final SessionData sessionData = await connectResponse!.session.future;
    log.fine('wallet_service -> switchNetwork from: $changeFrom to: $changeTo, sessionData.topic: ${sessionData.topic}');
    // log.fine('wallet_service -> switchNetwork namespaces: ${sessionData!.namespaces.values.first}');
    final params = <String, dynamic>{
      'chainId': '0x${changeTo.toRadixString(16)}',
    };
    await web3App!.request(
        topic: sessionData.topic,
        chainId: 'eip155:$changeFrom',
        request: SessionRequestParams(
          method: 'wallet_switchEthereumChain',
          params: [params],
        ));
    setChainAndConnect(tasksServices, changeTo);
    // return session;
  }

  Future<void> addNetwork(tasksServices, int currentChainId) async {
    final SessionData sessionData = await connectResponse!.session.future;
    log.fine('wallet_service -> addNetwork, currentChainId: $currentChainId sessionData.topic: ${sessionData.topic}');
    // log.fine('wallet_service -> switchNetwork namespaces: ${sessionData!.namespaces.values.first}');
    final params = {
      'chainId': '0xd0da0',
      'chainName': 'Dodao',
      'nativeCurrency': {
        'name': 'Dodao',
        'symbol': 'DODAO',
        'decimals': 18,
      },
      'rpcUrls': ['https://fraa-dancebox-3041-rpc.a.dancebox.tanssi.network'],
      'blockExplorerUrls': ['https://tanssi-evmexplorer.netlify.app/?rpcUrl=https://fraa-dancebox-3041-rpc.a.dancebox.tanssi.network'],
      'iconUrls': ['https://ipfs.io/ipfs/bafybeihbpxhz4urjr27gf6hjdmvmyqs36f3yn4k3iuz3w3pb5dd7grdnjy'],
    };
    await web3App!.request(
        topic: sessionData.topic,
        chainId: 'eip155:$currentChainId',
        request: SessionRequestParams(
          method: 'wallet_addEthereumChain',
          params: [params],
        ));
    setChainAndConnect(tasksServices, 855456);
    // return session;
  }

  // 1. switchNetwork(changeTo(chainNameOnApp)) <- (3)
  //                      changeFrom:           changeTo:
  //    1.'Switch network'(chainNameOnWallet, chainNameOnApp)
  //    ****.onSessionConnect_not_in_allowedlist(chainIdOnWallet(namespaces), defaultNetworkName)
  //    3.DropdownButton_WCwc(chainNameOnWallet, dropdown value)
  // 2. onSessionEvent(ID on wallet)
  // 3. onSessionConnect in allowedlist(chainIdOnWallet(namespaces))
  Future<void> setChainAndConnect(tasksServices, int newChainId) async {
    final Map<String, int> allowedChainIds = tasksServices.allowedChainIds;
    final chainIdOnApp = tasksServices.allowedChainIds[chainNameOnApp]!;

    // change back to WCStatus.loadingWc if WCStatus.wcConnectedNetworkUnknown was set by onSessionConnect
    if (wcCurrentState == WCStatus.wcConnectedNetworkUnknown) {
      wcCurrentState = WCStatus.loadingWc;
    }
    // save actual network names
    chainNameOnWallet = tasksServices.allowedChainIds.keys.firstWhere((k) => tasksServices.allowedChainIds[k] == newChainId, orElse: () => 'unknown');

    bool networkValidAndMatched = false;
    if (chainIdOnApp == newChainId && allowedChainIds.containsValue(newChainId)) {
      networkValidAndMatched = true;
    }

    log.fine('wallet_service -> setChainAndConnect chainIdOnApp: '
        '$chainIdOnApp , newChainId(id on wallet): '
        '$newChainId , networkValidAndMatched: '
        '$networkValidAndMatched');
    if (networkValidAndMatched) {
      tasksServices.chainId = newChainId;
      tasksServices.allowedChainId = true;
      notifyListeners();
      await tasksServices.connectRPC(tasksServices.chainId);
      try {
        await tasksServices.startup();
      } catch (e) {
        log.severe('wallet_service->tasksServices.startup() error: $e');
        await setWcState(state: WCStatus.error, tasksServices: tasksServices, error: 'Blockchain connection error');
        return;
      }
      await tasksServices.collectMyTokens();
      await setWcState(state: WCStatus.wcConnectedNetworkMatch, tasksServices: tasksServices);

      Timer(const Duration(seconds: 2), () {
        closeWalletDialog(tasksServices);
      });
    } else {
      await setWcState(state: WCStatus.wcConnectedNetworkNotMatch, tasksServices: tasksServices);
    }
    // chainNameOnApp = tasksServices.allowedChainIds.keys.firstWhere((k) => tasksServices.allowedChainIds[k]==chainIdOnApp, orElse: () => 'unknown');
  }

  Future<ConnectResponse?> createSession(int chainId) async {
    final String kFullChainId = 'eip155:$chainId';

    // if (walletProvider.web3App == null) {
    //   await walletProvider.initWalletConnect();
    // }
    connectResponse = await web3App!.connect(
      requiredNamespaces: {
        'eip155': RequiredNamespace(
          chains: [kFullChainId],
          methods: [
            'eth_sign',
            'eth_signTransaction',
            'eth_sendTransaction',
          ],
          events: [
            'chainChanged',
            'accountsChanged',
          ],
        ),
      },
      optionalNamespaces: {
        'eip155': RequiredNamespace(
          methods: [
            'wallet_switchEthereumChain',
            'wallet_addEthereumChain',
          ],
          chains: [kFullChainId],
          events: [],
        ),
      },
    );

    final String encodedUrl = Uri.encodeComponent('${connectResponse?.uri}');
    if (encodedUrl.isNotEmpty) {
      walletConnectUri = 'metamask://wc?uri=$encodedUrl';
    }

    await launchUrlString(
      walletConnectUri,
      mode: LaunchMode.externalApplication,
    );
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
    tasksServices.walletConnected = false;
    tasksServices.walletConnectedWC = false;
    tasksServices.publicAddress = null;
    tasksServices.publicAddressWC = null;
    tasksServices.allowedChainId = false;
    unknownChainIdWC = false;
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
