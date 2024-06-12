import 'dart:async';
import 'package:external_app_launcher/external_app_launcher.dart';
import '../../blockchain/chain_presets/chains_presets.dart';
import '../../blockchain/classes.dart';
import '../../blockchain/task_services.dart';
import 'package:js/js_util.dart' if (dart.library.io) 'package:webthree/src/browser/js_util_stub.dart' if (dart.library.js) 'package:js/js_util.dart';

import 'package:webthree/browser.dart';
import 'package:webthree/webthree.dart';
import "package:universal_html/html.dart" hide Platform;
import 'package:g_json/g_json.dart';

// get -> read ->
// set -> write ->
// on -> init ->
// ... -> check (logic with bool return(not bool stored data))


class MMService {
  final _chainPresets = ChainPresets();

  EthereumAddress? publicAddressMM;
  static Ethereum? eth;

  Future<Map<String, dynamic>?> initCreateWalletConnection(TasksServices tasksServices, bool onStartup) async {
    tasksServices.credentials = {};
    eth = window.ethereum;
    final List<CredentialsWithKnownAddress> accounts;
    late String chainIdHex;
    bool accountConnected = await isAccountsConnected();
    print('wallet is connected: $accountConnected');
    if (eth == null) {
      log.info('metamask_services.dart->initCreateWalletConnection MetaMask is not available');
      return null;
    } else if (onStartup && !accountConnected) {
      log.info('onStartup');
      // try {
      //   await tasksServices.initAccountStats();
      // } catch (e) {
      //   log.severe('mm_service->initFinalCollectData->initAccountStats error: $e');
      // }
      try {
        await tasksServices.initTaskStats();
      } catch (e) {
        log.severe('mm_service->initFinalCollectData->initTaskStats error: $e');
      }
      await tasksServices.refreshTasksForAccount(EthereumAddress.fromHex('0x0000000000000000000000000000000000000000'), "new");
      await Future.delayed(const Duration(milliseconds: 200));
      // await tasksServices.monitorEvents();
      return null;
    }

    var ethRPC = eth?.asRpcService();

    final client = Web3Client.custom(ethRPC!);
    try {
      accounts = await eth!.requestAccounts();
      CredentialsWithKnownAddress credentials = accounts[0];

      publicAddressMM = credentials.address;
      tasksServices.credentials = credentials;
      tasksServices.publicAddress = publicAddressMM;
      try {
        chainIdHex = await eth?.rawRequest('eth_chainId');
        return {'public_address': publicAddressMM, 'chainId': int.parse(chainIdHex)};
      } catch (e) {
        String errorJson = stringify(e);
        final error = JSON.parse(errorJson);
        if (error['code'] == 4902) {}
        log.severe(e);
        return null;
      }
    } catch (e) {
      log.severe(e);
      return null;
    }
  }

  Future<bool> isAccountsConnected() async {
    try {
      List accounts = await eth!.rawRequest('eth_accounts');
      if (accounts.isNotEmpty) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print(e);
    }
    return false;
  }

  Future<String> initSwitchNetworkMM(changeTo) async {
    try {
      await eth!.rawRequest('wallet_switchEthereumChain', params: [JSrawRequestSwitchChainParams(chainId: '0x${changeTo.toRadixString(16)}')]);
      return 'network_switched';
    } on EthereumException catch (e) {
      if (e.code == 4902) {
        return 'add_network';
      } else {
        return 'user_rejected';
      }
    } on WebThreeRPCError catch (e) {
      if (e.code == 4902) {
        return 'add_network';
      } else {
        return 'user_rejected';
      }
    } on EthereumUserRejected catch (e) {
      if (e.code == 4001) {
        return 'user_rejected';
      } else {
        return 'error';
      }
    } catch (e) {
      print(e);
      return 'error';
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
    //     publicAddress = publicAddressMM;
    //     List<EthereumAddress> taskList = await getTaskListFull();
    //     await tasksServices.fetchTasksBatch(taskList);
    //     tasksServices.myBalance();
    //   } else {
    //     allowedChainId = false;
    //   }
    // }
  }

  Future<bool> initAddNetworkMM(changeTo) async {
    final eth = window.ethereum;
    if (eth == null) {
      log.info('MetaMask compatible wallet is not available');
      return false;
    }
    bool addBlockExplorer = true;
    if (eth.isTrust == true) {
      //TrustWallet does not support Tanssi block explorer due to url with a query
      addBlockExplorer = false;
    }
    try {
      ChainInfo networkParams = _chainPresets.readChainInfo(changeTo);

      // final params = {
      //   'chainId': '0xd0da0',
      //   'chainName': 'Dodao',
      //   'nativeCurrency': {
      //     'name': 'Dodao',
      //     'symbol': 'DODAO',
      //     'decimals': 18,
      //   },
      //   'rpcUrls': ['https://fraa-dancebox-3041-rpc.a.dancebox.tanssi.network'],
      //   'iconUrls': ['https://ipfs.io/ipfs/bafybeihbpxhz4urjr27gf6hjdmvmyqs36f3yn4k3iuz3w3pb5dd7grdnjy'],
      // };
      final params = {
        'chainId': networkParams.chainIdHex,
        'chainName': networkParams.chainName,
        'nativeCurrency': {
          'name': networkParams.nativeCurrency?.name,
          'symbol': networkParams.nativeCurrency?.symbol,
          'decimals': networkParams.nativeCurrency?.decimals,
        },
        'rpcUrls': [networkParams.rpcUrl],
        // 'blockExplorerUrls': [networkParams.blockExplorer?.url],
        'iconUrls': [networkParams.iconUrl],
      };

      if (addBlockExplorer) {
        params['blockExplorerUrls'] = [networkParams.blockExplorer?.url];
      }

      try {
        await eth.rawRequest('wallet_addEthereumChain', params: jsify([params]));
      } catch (e) {
        print(e);
      }
      return true;
    } catch (e) {
      var error = jsObjectToMap(e);
      if (error['code'] == 4902) {
      } else {}
      log.warning('Cannot add network');
      return false;
    }
  }

  Future<bool> initFinalConnect(int newChainId, tasksServices) async {
    try {
      try {
        await tasksServices.connectRPC(newChainId);
      } catch (e) {
        log.severe('mm_service->initFinalConnect->connectRPC error: $e');
        return false;
      }
      try {
        await tasksServices.startup();
      } catch (e) {
        log.severe('mm_service->initFinalConnect->startup() error: $e');
        return false;
      }
      return true;
    } catch (e) {
      log.severe('metamask_service->initFinalConnect error: $e');
      return false;
    }
  }

  Future<bool> initFinalCollectData(int newChainId, tasksServices) async {
    try {
      // try {
      //   await tasksServices.initAccountStats();
      // } catch (e) {
      //   log.severe('mm_service->initFinalCollectData->initAccountStats error: $e');
      //   return false;
      // }
      try {
        await tasksServices.initTaskStats();
      } catch (e) {
        log.severe('mm_service->initFinalCollectData->initTaskStats error: $e');
        return false;
      }
      try {
        await tasksServices.collectMyTokens();
      } catch (e) {
        log.severe('mm_service->initFinalCollectData->collectMyTokens error: $e');
        return false;
      }
      try {
        await tasksServices.myBalance();
      } catch (e) {
        log.severe('mm_service->initFinalCollectData->myBalance() error: $e');
        return false;
      }
      if (publicAddressMM != null) {
        await tasksServices.refreshTasksForAccount(publicAddressMM, "refresh");
      } else {
        await tasksServices.refreshTasksForAccount(EthereumAddress.fromHex('0x0000000000000000000000000000000000000000'), "new");
      }
      await Future.delayed(const Duration(milliseconds: 200));
      await tasksServices.monitorEvents();
      return true;
    } catch (e) {
      log.severe('metamask_service->initFinalCollectData error: $e');
      return false;
    }
  }

  Future<bool> metamaskIsInstalled() async {
    return await LaunchApp.isAppInstalled(
      iosUrlScheme: 'metamask://',
      androidPackageName: 'io.metamask',
    );
  }

  Future<bool> checkAllowedChainId(int chainId, tasksServices) async {
    if (ChainPresets.chains.keys.contains(chainId) ||
        chainId == tasksServices.chainIdAxelar ||
        chainId == tasksServices.chainIdHyperlane ||
        chainId == tasksServices.chainIdLayerzero ||
        chainId == tasksServices.chainIdWormhole) {
      return true;
    } else {
      return false;
    }
  }
}
