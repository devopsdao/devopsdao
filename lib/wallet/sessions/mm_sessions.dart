import 'dart:async';

import 'package:dodao/wallet/services/wallet_service.dart';
import 'package:provider/provider.dart';
import 'package:webthree/browser.dart';

import '../../blockchain/task_services.dart';
import '../model_view/metamask_model.dart';
import '../model_view/wallet_model.dart';

class MMSessions {
  StreamSubscription<dynamic>? chainChanged;
  StreamSubscription<dynamic>? accountsChanged;

  initMMCreateSessions (Ethereum eth, metamaskModel, tasksServices, walletModel) {
    log.fine('initMMCreateSessions');
    chainChanged = eth.chainChanged.asBroadcastStream().listen((event) {
      int chainId = int.parse(event.substring(2), radix: 16);
      print('mm_sessions->chainChanged chainId: $chainId');
      // walletModel.test(chainId.toString());
      metamaskModel.onSwitchNetworkMM(tasksServices, walletModel, chainId);
    });
    accountsChanged = eth.accountsChanged.asBroadcastStream().listen((event) {
      String publicAddress = event.first;
      print('mm_sessions->accountsChanged publicAddress: $publicAddress');
      // walletModel.test(publicAddress);
      metamaskModel.onSwitchNetworkMM(tasksServices, walletModel, WalletService.chainId);
    });
    // eth.chainChanged.listen((event) { print('chainChanged');});
  }

  initUnsubscribe() {

    chainChanged?.cancel();
    accountsChanged?.cancel();
  }
}

