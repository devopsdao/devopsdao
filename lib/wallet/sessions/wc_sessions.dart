import 'dart:async';

import 'package:dodao/blockchain/task_services.dart';
import 'package:dodao/wallet/services/wallet_service.dart';
import 'package:dodao/wallet/services/wc_credentials.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:walletconnect_flutter_v2/walletconnect_flutter_v2.dart';
import 'package:webthree/credentials.dart';
import 'package:logging/logging.dart';

import '../../blockchain/chain_presets/chains_presets.dart';
import '../../navigation/beamer_delegate.dart';
import '../model_view/wallet_model.dart';
import '../model_view/wc_model.dart';

class WCSessions {
  final log = Logger('WCSessions');

  initCreateSessions(context, web3App) {
    sessionEvent(context, web3App);
    sessionConnect(context, web3App);

    // web3App?.onProposalExpire.subscribe((onProposalExpire) async {
    //   log.fine('wc_sessions.dart -> onProposalExpire');
    // });
    // web3App?.onSessionExtend.subscribe((onSessionExtend) async {
    //   log.fine('wc_sessions.dart -> onSessionExtend');
    // });
    // web3App?.onSessionPing.subscribe((onSessionPing) async {
    //   log.fine('wc_sessions.dart -> onSessionPing -> id: ${onSessionPing?.id}');
    // });
    // web3App?.onSessionUpdate.subscribe((onSessionUpdate) async {
    //   log.fine('wc_sessions.dart -> onSessionUpdate -> id: ${onSessionUpdate?.id}');
    // });
    // web3App?.onProposalExpire.subscribe((onProposalExpire) async {
    //   log.fine('wc_sessions.dart -> onProposalExpire -> params: ${onProposalExpire?.params}');
    //   log.fine('wc_sessions.dart -> onProposalExpire -> verifyUrl: ${onProposalExpire?.verifyContext?.verifyUrl}');
    // });
    // web3App?.onSessionDelete.subscribe((onSessionDelete) async {
    //   log.fine('wc_sessions.dart -> onSessionDelete id: ${onSessionDelete?.id}');
    //   log.fine('wc_sessions.dart -> onSessionDelete topic: ${onSessionDelete?.topic}');
    // });
    // web3App?.onSessionExpire.subscribe(onSessionExpire);
  }

  sessionEvent(context, web3App) async {
    TasksServices tasksServices = Provider.of<TasksServices>(context, listen: false);
    WCModelView wcModelView = Provider.of<WCModelView>(context, listen: false);
    WalletModel walletModel = Provider.of<WalletModel>(context, listen: false);
    web3App?.onSessionEvent.subscribe((onSessionEvent) async {
      log.fine('wc_service.dart->onSessionEvent: ${onSessionEvent?.name}, '
          'data: ${onSessionEvent?.data}, '
          'WalletService.chainId: ${WalletService.chainId}');
      // if (onSessionEvent?.data == wcModelView.state.lastErrorOnNetworkChainId) {
      //   log.warning('wc_service.dart->onSessionEvent: error on this '
      //       'network, chain id: ${onSessionEvent?.chainId}. stopped');
      //   // wcModelView.setLastErrorOnChainId(0); // reset error
      //   return;
      // }
      // if (wcModelView.wcCurrentState == WCScreenStatus.error) {
      //   log.warning('wc_service.dart->onSessionEvent: '
      //       'wallet on error state. stopped.');
      //
      //   return;
      // }

      if (onSessionEvent?.name == 'chainChanged') {
        await finalConnectAndCollectData(onSessionEvent?.data, tasksServices, wcModelView, walletModel);
      }

      if (onSessionEvent?.name == 'accountsChanged' && onSessionEvent?.data != WalletService.chainId && walletModel.state.walletConnected) {
        print(onSessionEvent!.data.first.toString());
        final EthereumAddress newAccount = EthereumAddress.fromHex(NamespaceUtils.getAccount(
          onSessionEvent!.data.first.toString(),
        ));
        if (newAccount != walletModel.state.walletAddress) {
          String pageName = beamerDelegate.currentPages.first.key.toString();
          if (pageName == '[</auditor>]' || pageName == '[</accounts>]') {
            beamerDelegate.beamToNamed('/home');
          }
          tasksServices.publicAddress = newAccount;
          walletModel.onWalletUpdate(walletAddress: newAccount);
          await finalConnectAndCollectData(WalletService.chainId, tasksServices, wcModelView, walletModel);
        }
      }
    });
  }

  sessionConnect(context, web3App) async {
    TasksServices tasksServices = Provider.of<TasksServices>(context, listen: false);
    WCModelView wcModelView = Provider.of<WCModelView>(context, listen: false);
    WalletModel walletModel = Provider.of<WalletModel>(context, listen: false);

    web3App?.onSessionConnect.subscribe((onSessionConnect) async {
      wcModelView.setWcScreenState(state: WCScreenStatus.loadingWc);

      if (tasksServices.hardhatDebug == true) {
        walletModel.onWalletUpdate(connectionState: true, walletType: WalletSelected.walletConnect, allowedChain: true, chainId: 31337);
        try {
          await tasksServices.getTaskListFullThenFetchIt();
        } catch (e) {
          log.severe('wc_sessions.dart->error: $e');
          wcModelView.setWcScreenState(
              state: WCScreenStatus.error,
              error: 'Opps... '
                  'something went wrong, try again \nBlockchain connection error');
          tasksServices.reset('getTaskListFullThenFetchIt hardhat error');
          return;
        }
        // await tasksServices.myBalance();
        await wcModelView.setWcScreenState(
          state: WCScreenStatus.wcConnectedNetworkMatch,
        );
        return;
      }

      tasksServices.credentials = WalletConnectEthereumCredentialsV2(
        wcClient: web3App!,
        session: onSessionConnect!.session,
        walletModel: walletModel,
        wcModelView: wcModelView,
      );

      final EthereumAddress publicAddress = EthereumAddress.fromHex(NamespaceUtils.getAccount(
        onSessionConnect.session.namespaces.values.first.accounts.last,
      ));
      final int chainIdOnWallet = int.parse(NamespaceUtils.getChainFromAccount(
        onSessionConnect.session.namespaces.values.first.accounts.last,
      ).split(":").last);
      await wcModelView.setChainOnWCWallet(chainIdOnWallet);
      await wcModelView.registerEventHandlers();

      tasksServices.publicAddress = publicAddress;
      int selectedChainId = wcModelView.state.selectedChainIdOnApp;

      if (ChainPresets.chains.keys.contains(selectedChainId) ||
          chainIdOnWallet == tasksServices.chainIdAxelar ||
          chainIdOnWallet == tasksServices.chainIdHyperlane ||
          chainIdOnWallet == tasksServices.chainIdLayerzero ||
          chainIdOnWallet == tasksServices.chainIdWormhole) {
        if (selectedChainId == chainIdOnWallet) {
          await walletModel.onWalletUpdate(
              connectionState: true,
              walletType: WalletSelected.walletConnect,
              walletAddress: publicAddress,
              allowedChain: true,
              chainId: chainIdOnWallet);
          await finalConnectAndCollectData(chainIdOnWallet, tasksServices, wcModelView, walletModel);
          Timer(const Duration(milliseconds: 1600), () {
            // Navigator.of(context, rootNavigator: true).pop();
            // beamerDelegate.beamToNamed('/home');
          });
        } else {
          await wcModelView.onSwitchNetwork(selectedChainId);
          // try {
          //   if (WalletService.tasksLoadingAndMonitorDoneOnNetId != WalletService.chainId) {
          //     await tasksServices.getTaskListFullThenFetchIt();
          //   }
          // } catch (e) {
          //   log.severe('wc_sessions.dart->error: $e');
          //   wcModelView.setWcScreenState(state: WCScreenStatus.error, error: 'Opps... something went wrong, try again \nBlockchain connection error');
          //   tasksServices.reset('getTaskListFullThenFetchIt error');
          // }
          try {
            await tasksServices.refreshTasksForAccount(publicAddress, "refresh");
          } catch (e) {
            log.severe('wc_sessions.dart->refreshTasksForAccount->error: $e');
            wcModelView.setWcScreenState(state: WCScreenStatus.error, error: 'Opps... something went wrong, try again \nBlockchain connection error');
            tasksServices.reset('refreshTasksForAccount error');
          }
        }

      } else {
        log.warning('wc_sessions.dart -> selectedChainId unknown chainId: $chainIdOnWallet.');
        await wcModelView.setWcScreenState(state: WCScreenStatus.wcConnectedNetworkUnknown);
        await wcModelView.onSwitchNetwork(selectedChainId);
        await walletModel.onWalletUpdate(
            connectionState: true,
            walletType: WalletSelected.walletConnect,
            walletAddress: publicAddress,
            allowedChain: false,
            chainId: chainIdOnWallet);
      }
    });
  }

  finalConnectAndCollectData(chainToChange, tasksServices, wcModelView, walletModel) async {
    await wcModelView.setChainOnWCWallet(chainToChange);
    await walletModel.onWalletUpdate(chainId: chainToChange);
    bool result = await initConnectAndCollectData(chainToChange, tasksServices);
    if (result) {
      await wcModelView.setWcScreenState(state: WCScreenStatus.wcConnectedNetworkMatch);
      await initFinalCollectData(chainToChange, tasksServices);
      if (walletModel.state.walletAddress != null) {
        await tasksServices.refreshTasksForAccount(walletModel.state.walletAddress, "refresh");
      } else {
        await tasksServices.refreshTasksForAccount(EthereumAddress.fromHex('0x0000000000000000000000000000000000000000'), "new");
      }
    } else {
      await wcModelView.setWcScreenState(
          state: WCScreenStatus.error,
          error: 'Opps... '
              'something went wrong, try again \nBlockchain connection error');
      // wcModelView.setLastErrorOnChainId(chainToChange);
    }
  }

  Future<bool> initConnectAndCollectData(int newChainId, tasksServices) async {
    // try {
    //   List<EthereumAddress> taskList = await tasksServices.getTaskListFull();
    //   await tasksServices.fetchTasksBatch(taskList);
    // } catch (e) {
    //   log.severe('wc_sessions->initConnectAndCollectData->fetchTasksBatch error: $e');
    //   return false;
    // }
    try { // pre load final
      await tasksServices.connectRPC(newChainId);
    } catch (e) {
      log.severe('wc_sessions->initConnectAndCollectData->connectRPC error: $e');
      return false;
    }
    try { // pre load final
      await tasksServices.startup();
    } catch (e) {
      log.severe('wc_sessions->initConnectAndCollectData->startup() error: $e');
      return false;
    }
    // try {
    //   await tasksServices.myBalance();
    //   // await tasksServices.getAccountBalances(newChainId);
    //   return true;
    // } catch (e) {
    //   log.severe('wc_sessions->initConnectAndCollectData->myBalance error: $e');
    //   return false;
    // }
    return true;
  }

  Future<void> initFinalCollectData(int newChainId, tasksServices) async {
    // try {
    //   await tasksServices.initAccountStats();
    // } catch (e) {
    //   log.severe('wc_sessions->initConnectAndCollectData->initAccountStats error: $e');
    // }
    try {

      await tasksServices.initTaskStats();
    } catch (e) {
      log.severe('wc_sessions->initFinalCollectData->initTaskStats error: $e');
    }
    try { // on final
      await tasksServices.myBalance();
    } catch (e) {
      log.severe('wc_sessions->initFinalCollectData->myBalance() error: $e');
    }
    try { // on final
      await tasksServices.collectMyTokens();
    } catch (e) {
      log.severe('wc_sessions->initFinalCollectData->collectMyTokens error: $e');
    }

    if (tasksServices.roleNfts['auditor'] > 0) {
      try { // on final
        await tasksServices.refreshTasksForAccount(WalletService.walletAddress, "audit");
      } catch (e) {
        log.severe('wc_sessions->initFinalCollectData->refreshTasksForAccount error: $e');
      }
    }

  }
}


