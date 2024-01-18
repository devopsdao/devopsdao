import 'dart:async';
import 'package:dodao/blockchain/task_services.dart';
import 'package:dodao/wallet/services/wallet_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:walletconnect_flutter_v2/walletconnect_flutter_v2.dart';
import 'package:logging/logging.dart';
import '../../blockchain/chain_presets/chains_presets.dart';
import '../../statistics/services/statistics_service.dart';
import '../../widgets/utils/platform.dart';
import '../services/wc_service.dart';
import '../sessions/wc_sessions.dart';

enum WCScreenStatus {
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
  disconnected,
}

class WCModelViewState {
  bool initComplete;
  bool mobile;
  // String selectedChainNameOnApp; // if empty, initially will be rewritten with tasksServices.defaultNetwork
  int? chainIdOnWCWallet;
  int selectedChainIdOnApp;
  // int lastErrorOnNetworkChainId = 0;
  String errorMessage = '';
  String walletConnectUri = '';
  String walletButtonText = '';

  WCModelViewState({
    required this.initComplete,
    required this.selectedChainIdOnApp,
    required this.chainIdOnWCWallet,
    required this.mobile,
  });
}


class WCModelView extends ChangeNotifier {
  final _walletService = WalletService();
  final _wcService = WCService();
  final _wcSessions = WCSessions();
  final _statisticsService = StatisticsService();
  // utils:
  final _platformAndBrowser = PlatformAndBrowser();


  final log = Logger('WCModelView');

  late ConnectResponse? connectResponse;
  late WCScreenStatus wcCurrentState = WCScreenStatus.loadingQr;

  /// Init:
  WCModelView() {
    if (_platformAndBrowser.platform == 'mobile'
        || _platformAndBrowser.browserPlatform == 'android'
        || _platformAndBrowser.browserPlatform == 'ios') {
      _state.mobile = true;

    } else if (_platformAndBrowser.platform == 'linux'
        || _platformAndBrowser.platform == 'web'
        && _platformAndBrowser.browserPlatform != 'android'
        && _platformAndBrowser.browserPlatform != 'ios') {
      _state.mobile = false;
    }
    init();
  }

  Future<void> init() async {
    _state.initComplete = await _wcService.initWCInstance();
    _state.selectedChainIdOnApp = WalletService.defaultNetwork;
    await _walletService.writeDefaultChainId();
    _updateState();
  }

  /// State update:
  var _state = WCModelViewState(
    initComplete: false,
    selectedChainIdOnApp: 0,
    chainIdOnWCWallet: null,
    mobile: false,
  );

  WCModelViewState get state => _state;

  void _updateState() {
    final selectedChainIdOnApp = _state.selectedChainIdOnApp;
    final chainIdOnWCWallet = _state.chainIdOnWCWallet;
    _state = WCModelViewState(
      initComplete: _state.initComplete,
      selectedChainIdOnApp: selectedChainIdOnApp,
      chainIdOnWCWallet: chainIdOnWCWallet,
      mobile: _state.mobile,
    );
    notifyListeners();
  }

  Future<void> setWcScreenState({required WCScreenStatus state, String error = ''}) async {
    wcCurrentState = state;
    switch (state) {
      case WCScreenStatus.loadingQr:
        _state.walletButtonText = 'Disconnect';
        break;
      case WCScreenStatus.loadingWc:
        _state.walletButtonText = 'Disconnect';
        break;
      case WCScreenStatus.wcNotConnected:
        _state.walletButtonText = 'Connect';
        break;
      case WCScreenStatus.wcConnectedNetworkMatch:
        _state.walletButtonText = 'Disconnect';
        break;
      case WCScreenStatus.wcConnectedNetworkNotMatch:
        _state.walletButtonText = 'Switch network';
        break;
      case WCScreenStatus.wcConnectedNetworkUnknown:
        _state.walletButtonText = 'Switch network';
        break;
      case WCScreenStatus.error:
        _state.walletButtonText = 'Connect';
        _state.errorMessage = error;
        setSelectedChainIdOnApp(WalletService.defaultNetwork);
        break;
      case WCScreenStatus.wcNotConnectedWithQrReady:
        _state.walletButtonText = 'Refresh QR';
        break;
      case WCScreenStatus.disconnected:
        _state.walletButtonText = 'Connect';
        break;
      case WCScreenStatus.wcNotConnectedAddNetwork:
        _state.walletButtonText = 'Disconnect';
        break;
    }
    notifyListeners();
  }

  onCreateWalletConnection(context) async {
    await setWcScreenState(state: WCScreenStatus.loadingQr);
    await _wcService.disconnectAndUnsubscribe();

    final Web3App? web3App = await _wcService.readWeb3App();
    await _wcSessions.initCreateSessions(context, web3App);
    _state.walletConnectUri = await _wcService.initCreateWalletConnection(_state.selectedChainIdOnApp);
    if (state.walletConnectUri.isNotEmpty) {
      setWcScreenState(state: WCScreenStatus.wcNotConnectedWithQrReady);
      return true;
    } else {
      setWcScreenState(state: WCScreenStatus.error, error: 'Opps... something went wrong, try again \nreason: WC connection error');
      log.severe('walletconnectv2->connectWallet error: walletConnectUri is empty');
      return false;
    }
  }

  onWalletDisconnect() async {
    await setWcScreenState(state: WCScreenStatus.loadingQr);
    await _wcService.disconnectAndUnsubscribe();
    setWcScreenState(state: WCScreenStatus.disconnected);
  }

  // Future<void> setLastErrorOnChainId(int value) async {
  //   _state.lastErrorOnNetworkChainId = value;
  // }
  Future<void> setChainOnWCWallet(int value) async {
    _state.chainIdOnWCWallet = value;
  }
  Future<void> setSelectedChainIdOnApp(int value) async {
    _state.selectedChainIdOnApp = value;
  }

  Future<void> onSwitchNetwork(int changeTo) async {
    int changeFrom = _state.chainIdOnWCWallet!;
    bool result = await _wcService.initSwitchNetwork(changeFrom, changeTo);
    if (!result) {
      setWcScreenState(state: WCScreenStatus.error, error: 'Opps... WC connection error');
      log.severe('walletconnectv2->connectWallet error: onSwitchNetwork');
    }
  }
  Future<void> onNetworkChangeInMenu(String value) async {
    setWcScreenState(state: WCScreenStatus.loadingWc);
    int changeTo = _walletService.readChainIdByName(value);
    await onSwitchNetwork(changeTo);
  }

  Future<void> onFinalConnection(chainId, tasksServices) async {
    _statisticsService.initRequestBalances(chainId, tasksServices);
  }

  Future<void> registerEventHandlers() async {
    late List<int> chains = [];
    for (int chain in ChainPresets.chains.keys) {
      chains.add(chain);
    }
    _wcService.registerEventHandlers(chains);
  }
  Future<Web3App?> getWeb3App() async {
    return _wcService.readWeb3App();
  }
}
