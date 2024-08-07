import 'dart:async';
import 'dart:convert';

import 'package:url_launcher/url_launcher_string.dart';
import 'package:walletconnect_flutter_v2/walletconnect_flutter_v2.dart';
import 'package:logging/logging.dart';

import '../../blockchain/chain_presets/chains_presets.dart';
import '../../config/utils/platform.dart';
import '../widgets/pages/2_wc/debug/wc_debug.dart';

class WCService {
  // utils:
  final _platform = PlatformAndBrowser();
  final _chainPresets = ChainPresets();

  static Web3App? web3App;
  late ConnectResponse? connectResponse;

  final log = Logger('WCModelView');

  Future<bool> initWCInstance() async {
    try {
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
      return true;
    } catch (e) {
      log.severe(e);
      return false;
    }
  }

  Future<String> initCreateWalletConnection(int chainId) async {
    ChainInfo networkParams = ChainPresets.chains.entries.firstWhere((element) {
      return element.key == chainId;
    }).value;

    try {
      connectResponse = await web3App!.connect(
        requiredNamespaces: networkParams.requiredNamespaces,
        optionalNamespaces: networkParams.optionalNamespaces,
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
    late String walletConnectUri;
    final String encodedUrl = Uri.encodeComponent('${connectResponse?.uri}');

    if (encodedUrl.isNotEmpty) {
      // if (selectedDebugLink == 'metamask:') {
      //   walletConnectUri = 'metamask://wc?uri=$encodedUrl';
      // } else if (selectedDebugLink == 'wc:') {
      //   walletConnectUri = connectResponse!.uri.toString();
      // } else if (selectedDebugLink == 'universal') {
      //   walletConnectUri = 'https://metamask.app.link/wc?uri=$encodedUrl';
      // }
      walletConnectUri = 'metamask://wc?uri=$encodedUrl';

      if (_platform.browserPlatform == 'ios') {
        walletConnectUri = 'https://metamask.app.link/wc?uri=$encodedUrl';
      }
    }

    log.fine("browserPlatform: ${_platform.browserPlatform}");
    if (_platform.platform == 'mobile') {
      await launchUrlString(
        walletConnectUri,
        mode: LaunchMode.externalNonBrowserApplication,
      );
    } else if (_platform.platform == 'web') {
      if (_platform.browserPlatform == 'android') {
        await launchUrlString(
          walletConnectUri,
          mode: LaunchMode.externalNonBrowserApplication,
        );
      } else if (_platform.browserPlatform == 'ios') {
        await launchUrlString(
          walletConnectUri,
          mode: LaunchMode.externalNonBrowserApplication,
        );
      }
    } else {
      // await launchUrlString(
      //   walletConnectUri,
      //   mode: LaunchMode.externalNonBrowserApplication,
      // );
    }
    return walletConnectUri;
  }

  Future<bool> initSwitchNetwork(int changeFrom, int changeTo) async {
    late SessionData sessionData;

    try {
      sessionData = await connectResponse!.session.future;
    } catch (e) {
      log.severe(e);
      return false;
    }

    log.fine('wallet_service->switchNetwork from: $changeFrom to: $changeTo');
    final params = <String, dynamic>{
      'chainId': '0x${changeTo.toRadixString(16)}',
    };

    try {
      await web3App!.request(
        topic: sessionData.topic,
        chainId: 'eip155:$changeFrom',
        request: SessionRequestParams(
          method: 'wallet_switchEthereumChain',
          params: [params],
        ),
      );
      return true;
    } on JsonRpcError catch (e) {
      return await _handleJsonRpcError(e, changeFrom, changeTo);
    } catch (e) {
      log.severe(e);
      return false;
    }
  }

  Future<bool> _handleJsonRpcError(JsonRpcError e, int changeFrom, int changeTo) async {
    if (e.message != null) {
      final error = jsonDecode(e.message!);

      if (error['data'] != null && error['data']['originalError'] != null) {
        final int errorCode = error['data']['originalError']['code'];

        if (errorCode == 4902) {
          return await _attemptAddNetwork(changeFrom, changeTo);
        } else if (errorCode == 4001) {
          log.severe('User rejected the request');
          return false;
        }
      }
    }
    log.severe(e);
    return false;
  }

  Future<bool> _attemptAddNetwork(int changeFrom, int changeTo) async {
    try {
      await _addNetwork(changeFrom, changeTo);
      return true;
    } on JsonRpcError catch (e) {
      _logJsonRpcError(e);
      return false;
    } catch (e) {
      log.severe(e);
      return false;
    }
  }

  void _logJsonRpcError(JsonRpcError e) {
    if (e.message != null) {
      final error = jsonDecode(e.message!);
      if (error['code'] != 4001) {
        log.severe(error);
      }
    }
    log.severe(e);
  }


  Future<void> _addNetwork(int currentChainId, int changeTo) async {
    final SessionData sessionData = await connectResponse!.session.future;
    log.fine('wallet_service->addNetwork, currentChainId: $currentChainId sessionData.topic: ${sessionData.topic}');

    ChainInfo networkParams = _chainPresets.readChainInfo(changeTo);

    final params = {
      'chainId': networkParams.chainIdHex,
      'chainName': networkParams.chainName,
      'nativeCurrency': {
        //
        'name': networkParams.nativeCurrency?.name,
        'symbol': networkParams.nativeCurrency?.symbol,
        'decimals': networkParams.nativeCurrency?.decimals,
      },
      'rpcUrls': [networkParams.rpcUrl],
      'blockExplorerUrls': [networkParams.blockExplorer?.url],
      'iconUrls': [networkParams.iconUrl],
    };

    await web3App!.request(
        topic: sessionData.topic,
        chainId: 'eip155:$currentChainId',
        request: SessionRequestParams(
          method: 'wallet_addEthereumChain',
          params: [params],
        ));
    // initConnectAndCollectData(tasksServices, 855456);
    // return session;
  }

  Future<void> registerEventHandlers(List<int> chains) async {
    for (int chain in chains) {
      web3App?.registerEventHandler(
        chainId: 'eip155:$chain',
        event: 'chainChanged',
      );
      web3App?.registerEventHandler(
        chainId: 'eip155:$chain',
        event: 'accountsChanged',
      );
    }
  }

  Future<void> disconnectAndUnsubscribe() async {
    log.fine('WCService -> disconnectAndUnsubscribe');
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

  Future<Web3App?> readWeb3App() async {
    return web3App;
  }
}
