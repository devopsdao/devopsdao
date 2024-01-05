import 'dart:async';
import 'dart:io';
import 'dart:js_util';
import 'package:dodao/wallet/wallet_model_provider.dart';
import 'package:dodao/wallet/wallet_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:logging/logging.dart';
import 'package:provider/provider.dart';
import 'package:webthree/browser.dart';
import 'package:webthree/webthree.dart';
import "package:universal_html/html.dart" hide Platform;
import 'package:g_json/g_json.dart';

import '../blockchain/task_services.dart';

final log = Logger('TaskServices');

class MetamaskProvider extends ChangeNotifier {
  //////////// *******New State Model******** //////////////////
  // final _walletService = WalletService();
  //
  // var _state = WalletModelState(
  //   allowedChainId: false,
  //   walletConnected: false,
  // );
  // WalletModelState get state => _state;
  //
  // Future<void> setAllowedChainId(bool state) async {
  //   _walletService.chainIdService(state);
  //   _updateState();
  // }
  //
  // Future<void> setWalletConnected(bool state) async {
  //   _walletService.walletConnectedService(state);
  //   _updateState();
  // }
  //
  // void _updateState() {
  //   final allowedChainId = WalletService.allowedChainId;
  //   final walletConnected = WalletService.walletConnected;
  //   _state = WalletModelState(
  //     walletConnected: walletConnected,
  //     allowedChainId: allowedChainId,
  //   );
  //   notifyListeners();
  // }
  //////////// *******New State Model END******** //////////////////
  String platform = '';
  // CredentialsWithKnownAddress credentials;
  // var credentials;
  EthereumAddress? publicAddressMM;
  bool walletConnectedMM = false;
  bool allowedChainIdMM = false;

  MetamaskProvider() {
    try {
      if (Platform.isAndroid || Platform.isIOS) {
        platform = 'mobile';
      } else if (Platform.isLinux) {
        platform = 'linux';
      }
    } catch (e) {
      platform = 'web';
    }
  }

  Future<void> connectWalletMM(context) async {
    TasksServices tasksServices = Provider.of<TasksServices>(context, listen: false);
    WalletModelProvider walletModelProvider = Provider.of<WalletModelProvider>(context, listen: false);

    if (platform == 'web' && window.ethereum != null) {
      final eth = window.ethereum;

      if (eth == null) {
        log.info('MetaMask is not available');
        return;
      }
      var ethRPC = eth.asRpcService();

      final client = Web3Client.custom(ethRPC);
      bool userRejected = false;
      try {
        final accounts = await eth.requestAccounts();
        tasksServices.credentials = accounts[0];
        print('got accounts');
      } catch (e) {
        userRejected = true;
        log.severe(e);
      }
      if (!userRejected && tasksServices.credentials != null) {
        publicAddressMM = tasksServices.credentials.address;
        tasksServices.publicAddress = publicAddressMM;
        walletModelProvider.setWalletConnected(true);
        walletConnectedMM = true;
        late final chainIdHex;
        try {
          chainIdHex = await eth.rawRequest('eth_chainId');
        } catch (e) {
          String errorJson = stringify(e);
          final error = JSON.parse(errorJson);
          if (error['code'] == 4902) {}
          log.severe(e);
        }
        if (chainIdHex != null) {
          tasksServices.chainId = int.parse(chainIdHex);
        }
        if (tasksServices.allowedChainIds.values.contains(tasksServices.chainId) ||
            tasksServices.chainId == tasksServices.chainIdAxelar ||
            tasksServices.chainId == tasksServices.chainIdHyperlane ||
            tasksServices.chainId == tasksServices.chainIdLayerzero ||
            tasksServices.chainId == tasksServices.chainIdWormhole) {
          walletModelProvider.setAllowedChainId(true);
          // tasksServices.allowedChainId = true;
          allowedChainIdMM = true;
          await tasksServices.connectRPC(tasksServices.chainId);
          await tasksServices.startup();
          await tasksServices.collectMyTokens();
        } else {
          walletModelProvider.setAllowedChainId(false);
          // tasksServices.allowedChainId = false;
          allowedChainIdMM = false;
          log.warning('invalid chainId $tasksServices.chainId');
          await switchNetworkMM(context);
        }
        if (WalletService.walletConnected && walletConnectedMM && WalletService.allowedChainId) {
          // fetchTasksByState("new");
          final eth = window.ethereum;
          if (eth == null) {
            log.info('MetaMask is not available');
            return;
          }

          // await for (final value in eth.accountsChanged) {
          //   print(value);
          // }
          // ;

          // await for (final value in eth.stream('accountsChanged').cast()) {
          //   print(value);
          // }
          // await for (final value in eth.stream('chainChanged').cast()) {
          //   print(value);
          // }
          // print('init stream listener');
          // eth.stream('accountsChanged').cast().listen((event) {
          //   print('accountsChanged');
          // });
          // eth.stream('chainChanged').cast().listen((event) {
          //   print('accountsChanged');
          // });

          // eth.chainChanged.asBroadcastStream();

          eth.chainChanged.asBroadcastStream().listen((event) {
            print('chainChanged');
            print(event);
          });

          // eth.chainChanged.listen((event) {
          //   print('chainChanged');
          //   print(event);
          // });

          // await for (final value in eth.chainChanged) {
          //   print(value);
          // }

          // eth.accountsChanged.listen((event) {
          //   print('accountsChanged');
          // });

          List<EthereumAddress> taskList = await tasksServices.getTaskListFull();
          await tasksServices.fetchTasksBatch(taskList);

          tasksServices.myBalance();
          notifyListeners();
        }
      }
    } else {
      log.warning("eth not initialized");
    }
  }

  Future<void> switchNetworkMM(context) async {
    await disconnectMM(context);
    final eth = window.ethereum;
    if (eth == null) {
      log.info('MetaMask is not available');
      return;
    }

    late final String chainIdHex;
    bool chainChangeRequest = false;
    bool userRejected = false;
    bool chainNotAdded = false;
    try {
      await eth.rawRequest('wallet_switchEthereumChain', params: [JSrawRequestSwitchChainParams(chainId: '0xd0da0')]);
    } on EthereumException catch (e) {
      if (e.code == 4902) {
        await addNetworkMM(context);
      } else {
        userRejected = true;
      }
    } on WebThreeRPCError catch (e) {
      if (e.code == 4902) {
        await addNetworkMM(context);
      } else {
        userRejected = true;
      }
    } catch (e) {
      print(e);
    }
    // if (!userRejected && chainChangeRequest) {
    //   try {
    //     // chainIdHex = await eth.rawRequest('eth_chainId');
    //     chainIdHex = await tasksServices.web3client.makeRPCCall('eth_chainId');
    //   } catch (e) {
    //     log.severe(e);
    //   }
    //   if (chainIdHex != null) {
    //     chainId = int.parse(chainIdHex);
    //   }
    //   if (allowedChainIds.values.contains(chainId) ||
    //       tasksServices.chainId == chainIdAxelar ||
    //       chainId == chainIdHyperlane ||
    //       chainId == chainIdLayerzero ||
    //       chainId == chainIdWormhole) {
    //     allowedChainId = true;
    //     allowedChainIdMM = true;
    //     publicAddress = publicAddressMM;
    //     List<EthereumAddress> taskList = await getTaskListFull();
    //     await tasksServices.fetchTasksBatch(taskList);
    //     tasksServices.myBalance();
    //   } else {
    //     allowedChainId = false;
    //     allowedChainIdMM = false;
    //   }
    // }
    notifyListeners();
  }

  Future<void> addNetworkMM(context) async {
    TasksServices tasksServices = Provider.of<TasksServices>(context, listen: false);
    WalletModelProvider walletModelProvider = Provider.of<WalletModelProvider>(context, listen: false);
    final eth = window.ethereum;
    if (eth == null) {
      log.info('MetaMask compatible wallet is not available');
      return;
    }
    bool addBlockExplorer = true;
    if (eth.isTrust == true) {
      //TrustWallet does not support Tanssi block explorer due to url with a query
      addBlockExplorer = false;
    }
    if (eth == null) {
      log.info('MetaMask is not available');
      return;
    }
    late final String chainIdHex;
    bool chainAddRequest = false;
    bool userRejected = false;
    try {
      final params = {
        'chainId': '0xd0da0',
        'chainName': 'Dodao',
        'nativeCurrency': {
          'name': 'Dodao',
          'symbol': 'DODAO',
          'decimals': 18,
        },
        'rpcUrls': ['https://fraa-dancebox-3041-rpc.a.dancebox.tanssi.network'],
        'iconUrls': ['https://ipfs.io/ipfs/bafybeihbpxhz4urjr27gf6hjdmvmyqs36f3yn4k3iuz3w3pb5dd7grdnjy'],
      };
      if (addBlockExplorer) {
        params['blockExplorerUrls'] = ['https://tanssi-evmexplorer.netlify.app/?rpcUrl=https://fraa-dancebox-3041-rpc.a.dancebox.tanssi.network'];
      }

      try {
        await eth.rawRequest('wallet_addEthereumChain', params: jsify([params]));
      } catch (e) {
        print(e);
      }

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
        chainIdHex = await tasksServices.web3client.makeRPCCall('eth_chainId');
      } catch (e) {
        log.severe(e);
      }
      if (chainIdHex != null) {
        tasksServices.chainId = int.parse(chainIdHex);
      }
      if (tasksServices.allowedChainIds.values.contains(tasksServices.chainId) ||
          tasksServices.chainId == tasksServices.chainIdAxelar ||
          tasksServices.chainId == tasksServices.chainIdHyperlane ||
          tasksServices.chainId == tasksServices.chainIdLayerzero ||
          tasksServices.chainId == tasksServices.chainIdWormhole) {
        walletModelProvider.setAllowedChainId(true);
        allowedChainIdMM = true;
        tasksServices.publicAddress = publicAddressMM;
        List<EthereumAddress> taskList = await tasksServices.getTaskListFull();
        await tasksServices.fetchTasksBatch(taskList);
        tasksServices.myBalance();
      } else {
        walletModelProvider.setAllowedChainId(false);
        allowedChainIdMM = false;
      }
    }
    notifyListeners();
  }

  Future<void> disconnectMM(context) async {
    TasksServices tasksServices = Provider.of<TasksServices>(context, listen: false);
    WalletModelProvider walletModelProvider = Provider.of<WalletModelProvider>(context, listen: false);
    walletModelProvider.setWalletConnected(false);
    walletModelProvider.setAllowedChainId(false);
    walletConnectedMM = false;
    tasksServices.publicAddress = null;
    publicAddressMM = null;
    // tasksServices.allowedChainId = false;
    allowedChainIdMM = false;
    tasksServices.ethBalance = 0;
    tasksServices.ethBalanceToken = 0;
    tasksServices.pendingBalance = 0;
    tasksServices.pendingBalanceToken = 0;
    List<EthereumAddress> taskList = await tasksServices.getTaskListFull();
    await tasksServices.fetchTasksBatch(taskList);
    notifyListeners();
  }
}
