import 'dart:async';
import 'dart:io';
import 'package:dodao/wallet/sessions/mm_sessions.dart';
import 'package:dodao/wallet/services/wallet_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:logging/logging.dart';
import 'package:provider/provider.dart';
import 'package:webthree/browser.dart';
import 'package:webthree/webthree.dart';
import "package:universal_html/html.dart" hide Platform;

import '../../blockchain/chain_presets/chains_presets.dart';
import '../../blockchain/task_services.dart';
import '../../statistics/services/statistics_service.dart';
import '../../config/utils/platform.dart';
import '../services/mm_service.dart';
import 'wallet_model.dart';

enum MMScreenStatus {
  loadingMetamask,
  mmNotConnected,
  mmNotConnectedAddNetwork,
  mmConnectedNetworkMatch,
  mmConnectedNetworkNotMatch,
  mmConnectedNetworkUnknown,
  rejected,
  error,
  none,
}

class MMModelViewState {
  bool initComplete;
  int? chainIdOnMMWallet;
  int selectedChainIdOnMMApp;
  String walletButtonText = '';
  String errorMessage = '';
  late MMScreenStatus mmScreenStatus = MMScreenStatus.mmNotConnected;


  MMModelViewState({
    required this.initComplete,
    required this.selectedChainIdOnMMApp,
    required this.chainIdOnMMWallet,
  });
}

// final log = Logger('TaskServices');

class MetamaskModel extends ChangeNotifier {
  // Utils:
  final _platform = PlatformAndBrowser();
  // Services:
  final _walletService = WalletService();
  final _mmSessions = MMSessions();
  final _mmServices = MMService();
  final _statisticsService = StatisticsService();

  // final _statisticsModel = StatisticsModel();

  MetamaskModel() {
    _state.selectedChainIdOnMMApp = WalletService.defaultNetwork;
  }

  /// State update:
  var _state = MMModelViewState(
    initComplete: false,
    selectedChainIdOnMMApp: 0,
    chainIdOnMMWallet: null,
  );

  MMModelViewState get state => _state;

  void _updateState() {
    final selectedChainIdOnMMApp = _state.selectedChainIdOnMMApp;
    final chainIdOnMMWallet = _state.chainIdOnMMWallet;

    _state = MMModelViewState(
      initComplete: _state.initComplete,
      selectedChainIdOnMMApp: selectedChainIdOnMMApp,
      chainIdOnMMWallet: chainIdOnMMWallet,
    );
    notifyListeners();
  }

  Future<void> setMmScreenState({required MMScreenStatus state, String error = ''}) async {
    _state.mmScreenStatus = state;
    switch (state) {
      case MMScreenStatus.loadingMetamask:
        _state.walletButtonText = 'Disconnect';
        break;
      case MMScreenStatus.mmNotConnected:
        _state.walletButtonText = 'Disconnect';
        break;
      case MMScreenStatus.mmNotConnectedAddNetwork:
        _state.walletButtonText = 'Connect';
        break;
      case MMScreenStatus.mmConnectedNetworkMatch:
        _state.walletButtonText = 'Disconnect';
        break;
      case MMScreenStatus.mmConnectedNetworkNotMatch:
        _state.walletButtonText = 'Switch network';
        break;
      case MMScreenStatus.mmConnectedNetworkUnknown:
        _state.walletButtonText = 'Switch network';
        break;
      case MMScreenStatus.error:
        _state.errorMessage = error;
        _state.walletButtonText = 'Connect';
        break;
      case MMScreenStatus.none:
        _state.walletButtonText = 'Switch network';
        break;
      case MMScreenStatus.rejected:
        _state.walletButtonText = 'Disconnect';
        break;
    }
    notifyListeners();
  }

  Future<void> onCreateMetamaskConnection(tasksServices, walletModel, context) async {
    if (_platform.platform != 'web' || window.ethereum == null) {
      log.warning("eth not initialized");
      return;
    }

    MetamaskModel metamaskModel = Provider.of<MetamaskModel>(context, listen: false);
    // TasksServices tasksServices = Provider.of<TasksServices>(context, listen: false);
    // WalletModel walletModel = Provider.of<WalletModel>(context, listen: false);
    await setMmScreenState(state: MMScreenStatus.loadingMetamask);
    await onResetMM(tasksServices, walletModel);
    _mmSessions.initUnsubscribe();
    Map<String, dynamic>? resultData = await _mmServices.initCreateWalletConnection(tasksServices);

    if (resultData == null) {
      await setMmScreenState(state: MMScreenStatus.error, error: 'Opps... '
          'something went wrong, try again \nBlockchain connection error');
      return;
    }

    int chainId = resultData['chainId'];
    EthereumAddress publicAddress = resultData['public_address'];

    if (await _mmServices.checkAllowedChainId(chainId, tasksServices)
        && chainId == _state.selectedChainIdOnMMApp
    ) {
      await walletModel.onWalletUpdate(
        connectionState: true,
        walletType: WalletSelected.metamask,
        walletAddress: publicAddress,
        chainId: chainId,
        allowedChain: true,
      );
      await onFinalConnectAndCollectData(chainId, tasksServices);
      _mmSessions.initMMCreateSessions(MMService.eth!, metamaskModel, tasksServices, walletModel);
    } else {
      log.warning('mm_model.dart->invalid chainId $chainId');
      int defaultChainId = WalletService.defaultNetwork;
      await setMmScreenState(state: MMScreenStatus.error, error:
          'Wrong network on the wallet, \'will be redirected to \''
            '${_walletService.readChainNameById(defaultChainId)}');
      await walletModel.onWalletUpdate(
        connectionState: true,
        walletType: WalletSelected.metamask,
        walletAddress: publicAddress,
        chainId: defaultChainId,
        allowedChain: false,
      );
      // await onResetMM(tasksServices, walletModel);
      await onSwitchNetworkMM(tasksServices, walletModel, defaultChainId);
    }
  }

  Future<void> onSwitchNetworkMM(TasksServices tasksServices, WalletModel walletModel, chainId) async {
    await setMmScreenState(state: MMScreenStatus.loadingMetamask);
    String result = await _mmServices.initSwitchNetworkMM(chainId);

    if (result == 'network_switched' || result == 'add_network') {
      if (result == 'add_network') {
        bool result = await _mmServices.initAddNetworkMM(chainId);
        if (!result) {
          await setMmScreenState(state: MMScreenStatus.error, error: 'Opps... '
              'Cannot add network \nBlockchain connection error');
          return;
        }
      }

      Map<String, dynamic>? resultData = await _mmServices.initCreateWalletConnection(tasksServices);
      // _mmSessions.initUnsubscribe();

      if (resultData == null) {
        await setMmScreenState(state: MMScreenStatus.error, error: 'Opps... '
            'something went wrong, try again \nBlockchain connection error');
        return;
      }
      await walletModel.onWalletUpdate(
        connectionState: true,
        walletAddress: resultData['public_address'],
        chainId: resultData['chainId'],
        allowedChain: true,
      );
      await onFinalConnectAndCollectData(resultData['chainId'], tasksServices);
      // _mmSessions.initMMCreateSessions(MMService.eth!, walletModel, tasksServices);
    }
    
    if (result == 'user_rejected') {
      await setMmScreenState(state: MMScreenStatus.rejected);
    } else if (result == 'error') {
      await setMmScreenState(state: MMScreenStatus.error, error: 'Opps... '
          'something went wrong, try again');
    }
  }

  Future<void> onResetMM(TasksServices tasksServices, WalletModel walletModel) async {
    walletModel.onWalletReset();
    tasksServices.reset('onResetMM');
    List<EthereumAddress> taskList = await tasksServices.getTaskListFull();
    await tasksServices.fetchTasksBatch(taskList);
  }

  Future<void> onDisconnectButtonPressed(tasksServices, walletModel) async {
    await setMmScreenState(state: MMScreenStatus.mmNotConnected);
    _mmSessions.initUnsubscribe();
    await onResetMM(tasksServices, walletModel);
  }

  Future<void> onFinalConnectAndCollectData(int chainId, tasksServices) async {
    if (!ChainPresets.chains.keys.contains(chainId)) {
      await setMmScreenState(state: MMScreenStatus.error, error: 'Opps... '
          'Unfortunately does not support\nthis network');
      return;
    }
    _state.selectedChainIdOnMMApp = chainId;
    bool result = await _mmServices.initConnectAndCollectData(chainId, tasksServices);
    if (result) {
      onRequestBalances(chainId, tasksServices);
      await setMmScreenState(state: MMScreenStatus.mmConnectedNetworkMatch);
    } else {
      await setMmScreenState(state: MMScreenStatus.error, error: 'Opps... '
          'something went wrong, try again \nBlockchain connection error');
    }
  }

  Future<void> onRequestBalances(int chainId, tasksServices) async =>
      _statisticsService.initRequestBalances(chainId, tasksServices);
  Future<void> setSelectedChainIdOnApp(int value) async =>
      _state.selectedChainIdOnMMApp = value;
}
