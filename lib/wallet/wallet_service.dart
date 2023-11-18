import 'package:flutter/cupertino.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:walletconnect_flutter_v2/walletconnect_flutter_v2.dart';

class WalletProvider extends ChangeNotifier {
  late Web3App? web3App;
  late ConnectResponse? connectResponse;

  late bool initComplete = false;
  late bool unknownChainIdWC = false;
  late String selectedChainNameMenu = ''; // if empty, initially will be rewritten with tasksServices.defaultNetworkName
  late String chainNameOnApp = ''; // if empty, initially will be rewritten with tasksServices.defaultNetworkName
  late String chainNameOnWallet = '';
  late String walletConnectUri = '';

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
  //
  Future<void> setSelectedNetworkName(value) async {
    chainNameOnApp = value;
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

  Future<void> registerEventHandlers( taskServices) async {
    final Map<String, int> chain = taskServices.allowedChainIds;
    for (String key in chain.keys){
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
    // chainIdOnWallet = chainIdOnWallet;
    bool networkMatched = false;
    if (chainIdOnApp == newChainId && allowedChainIds.containsValue(newChainId)) {
      networkMatched = true;
    }
    print('wallet_service -> setChainAndConnect chainIdOnApp: '
        '$chainIdOnApp , newChainId(id on wallet): '
        '$newChainId , networkMatched: '
        '$networkMatched');
    if (networkMatched) {
      tasksServices.closeWalletDialog = true;
      tasksServices.chainId = newChainId;
      tasksServices.allowedChainId = true;
      unknownChainIdWC = false;
      notifyListeners();
      await tasksServices.connectRPC(tasksServices.chainId);
      await tasksServices.startup();
      await tasksServices.collectMyTokens();
    }
    // save actual network names
    chainNameOnWallet = tasksServices.allowedChainIds.keys.firstWhere((k) => tasksServices.allowedChainIds[k]==newChainId, orElse: () => 'unknown');
    // chainNameOnApp = tasksServices.allowedChainIds.keys.firstWhere((k) => tasksServices.allowedChainIds[k]==chainIdOnApp, orElse: () => 'unknown');
    notifyListeners();
  }

  Future<void> updateAccountAddress(taskServices, address) async {
    final Map<String, int> chain = taskServices.allowedChainIds;
  }

  Future<void> switchNetwork(tasksServices, int changeFrom, int changeTo) async {
    // change from wallet network(changeFrom), to app network(changeTo)
    final SessionData sessionData = await connectResponse!.session.future;
    print('wallet_service -> switchNetwork from: $changeFrom to: $changeTo, sessionData.topic: ${sessionData.topic}');
    // print('wallet_service -> switchNetwork namespaces: ${sessionData!.namespaces.values.first}');
    final params = <String, dynamic>{
      'chainId': '0x${changeTo.toRadixString(16)}',
    };
    await web3App!.request(
        topic: sessionData.topic,
        chainId: 'eip155:$changeFrom',
        request: SessionRequestParams(
          method: 'wallet_switchEthereumChain',
          params: [params],));
    setChainAndConnect(tasksServices, changeTo);
    // return session;
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
    walletConnectUri = 'metamask://wc?uri=$encodedUrl';

    await launchUrlString(
      walletConnectUri,
      mode: LaunchMode.externalApplication,
    );
    return connectResponse;
  }

  Future<void> disconnect() async {
    print('wallet_service -> disconnect');
    if (connectResponse?.pairingTopic != null) {
      await web3App?.disconnectSession(
        topic: connectResponse!.pairingTopic,
        reason: Errors.getSdkError(Errors.USER_DISCONNECTED),
      );
    }

    // disconnectAllSessions:
    for (final SessionData session in web3App!.sessions.getAll()) {
      // Disconnect both the pairing and session
      await web3App!.disconnectSession(
        topic: session.pairingTopic,
        reason: const WalletConnectError(code: 0, message: 'User disconnected'),
      );
      // Disconnecting the session will produce the onSessionDisconnect callback
      await web3App!.disconnectSession(
        topic: session.topic,
        reason: const WalletConnectError(code: 0, message: 'User disconnected'),
      );
    }
  }

  Future<void> disconnectPairings() async {
    print('wallet_service -> disconnectPairings');
    List<PairingInfo> pairings = [];
    pairings = web3App!.pairings.getAll();
    for (var pairing in pairings) {
      web3App!.core.pairing.disconnect(
        topic: pairing.topic,
      );
    }
  }


  Future<void> unsubscribe() async {
    print('wallet_service -> unsubscribe');
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