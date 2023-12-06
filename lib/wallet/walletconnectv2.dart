import 'dart:async';
import 'dart:typed_data';

import 'package:dodao/wallet/pages/2_wallet_connect.dart';
import 'package:dodao/wallet/wallet_model_provider.dart';
import 'package:dodao/wallet/wallet_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:web3dart/crypto.dart';
import 'package:webthree/webthree.dart';
import 'package:walletconnect_flutter_v2/walletconnect_flutter_v2.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../blockchain/task_services.dart';

class WalletConnectController extends StatefulWidget {
  final double innerPaddingWidth;
  final double screenHeightSizeNoKeyboard;

  const WalletConnectController({
    Key? key,
    required this.innerPaddingWidth,
    required this.screenHeightSizeNoKeyboard,
  }) : super(key: key);

  @override
  _WalletConnectControllerState createState() => _WalletConnectControllerState();
}

class _WalletConnectControllerState extends State<WalletConnectController> {


  @override
  void initState() {
    TasksServices tasksServices = Provider.of<TasksServices>(context, listen: false);
    WalletProvider walletProvider = Provider.of<WalletProvider>(context, listen: false);
    // final walletConnected = context.select((WalletModelProvider vm) => vm.state.walletConnected);
    final _walletService = WalletService();

    // initial network name set:
    if (walletProvider.selectedChainNameOnApp.isEmpty) {
      walletProvider.setSelectedNetworkName(tasksServices.defaultNetworkName);
    }
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      if (!WalletService.walletConnected) {
        connectWallet();
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // var interface = context.watch<InterfaceServices>();
    // var tasksServices = context.watch<TasksServices>();
    // WalletProvider walletProvider = context.read<WalletProvider>();

    return LayoutBuilder(builder: (ctx, dialogConstraints) {
      return WalletConnect(
        screenHeightSizeNoKeyboard: widget.screenHeightSizeNoKeyboard,
        innerPaddingWidth: widget.innerPaddingWidth,
        callConnectWallet: connectWallet,
      );
    });
  }

  Future<void> connectWallet() async {
    log.fine('walletconnectv2.dart -> connectWallet() start.');
    TasksServices tasksServices = Provider.of<TasksServices>(context, listen: false);
    WalletProvider walletProvider = Provider.of<WalletProvider>(context, listen: false);

    await walletProvider.setWcState(state: WCStatus.loadingQr, tasksServices: tasksServices);
    await walletProvider.resetView(tasksServices);
    await walletProvider.disconnectSessionsAndPairings();
    await walletProvider.unsubscribeAll();
    await tasksServices.getTaskListFullThenFetchIt();

    walletProvider.web3App?.onSessionDelete.subscribe((onSessionDelete) async {
      log.fine('walletconnectv2.dart -> onSessionDelete id: ${onSessionDelete?.id}');
      log.fine('walletconnectv2.dart -> onSessionDelete topic: ${onSessionDelete?.topic}');
      // connectWallet(); // unsubscribeAll disconnectSessionsAndPairings resetView
    });

    walletProvider.web3App?.onSessionEvent.subscribe((onSessionEvent) async {
      log.fine('walletconnectv2.dart->onSessionEvent: ${onSessionEvent?.name}, '
          'data: ${onSessionEvent?.data}, '
          'tasksServices.chainId: ${tasksServices.chainId}');
      if (onSessionEvent?.data == walletProvider.lastErrorOnNetworkChainId) {
        log.warning('walletconnectv2.dart->onSessionEvent: error on this '
            'network, chain id: ${onSessionEvent?.chainId}. stopped');
        walletProvider.lastErrorOnNetworkChainId = 0; // reset error
        return;
      }
      if (walletProvider.wcCurrentState == WCStatus.error) {
        log.warning('walletconnectv2.dart->onSessionEvent: '
            'wallet on error state. stopped.');
        return;
      }

      if (onSessionEvent?.name == 'chainChanged') {
        if (walletProvider.preventEvent) {
          walletProvider.preventEvent = false;
        } else {
          walletProvider.setChainAndConnect(tasksServices, context, onSessionEvent?.data);
        }
      }

      if (onSessionEvent?.name == 'accountsChanged' && onSessionEvent?.data != tasksServices.chainId && walletProvider.walletConnectedWC) {
        // final String newAccount = onSessionEvent!.data.toString().split(":").last;
        final EthereumAddress newAccount = EthereumAddress.fromHex(NamespaceUtils.getAccount(
          onSessionEvent!.data.first.toString(),
        ));
        if (newAccount != tasksServices.publicAddress) {
          // walletProvider.updateAccountAddress(tasksServices, newAccount);
          // await walletProvider.switchNetwork(tasksServices, onSessionEvent?.data, tasksServices.allowedChainIds[walletProvider.selectedChainNameOnApp]!); // default network
          tasksServices.publicAddress = newAccount;
          tasksServices.publicAddressWC = newAccount;
          await tasksServices.connectRPC(tasksServices.chainId);
          await tasksServices.startup();
          await tasksServices.collectMyTokens();
        }
      }
    });
    walletProvider.web3App?.onProposalExpire.subscribe((onProposalExpire) async {
      log.fine('walletconnectv2.dart -> onProposalExpire');
    });
    walletProvider.web3App?.onSessionExtend.subscribe((onSessionExtend) async {
      log.fine('walletconnectv2.dart -> onSessionExtend');
    });
    walletProvider.web3App?.onSessionPing.subscribe((onSessionPing) async {
      log.fine('walletconnectv2.dart -> onSessionPing -> id: ${onSessionPing?.id}');
    });
    walletProvider.web3App?.onSessionUpdate.subscribe((onSessionUpdate) async {
      log.fine('walletconnectv2.dart -> onSessionUpdate -> id: ${onSessionUpdate?.id}');
    });
    walletProvider.web3App?.onProposalExpire.subscribe((onProposalExpire) async {
      log.fine('walletconnectv2.dart -> onProposalExpire -> params: ${onProposalExpire?.params}');
      log.fine('walletconnectv2.dart -> onProposalExpire -> verifyUrl: ${onProposalExpire?.verifyContext?.verifyUrl}');
    });
    walletProvider.web3App?.onSessionConnect.subscribe(onSessionConnect);
    walletProvider.web3App?.onSessionExpire.subscribe(onSessionExpire);

    // log.fine(
    //     'walletconnectv2.dart -> createSession chainId: ${tasksServices.allowedChainIds[walletProvider.selectedChainNameOnApp]!} , walletProvider.selectedChainNameOnApp: ${walletProvider.selectedChainNameOnApp}');
    await walletProvider.createSession(tasksServices, tasksServices.allowedChainIds[walletProvider.selectedChainNameOnApp]!);
    if (walletProvider.walletConnectUri.isNotEmpty) {
      walletProvider.setWcState(state: WCStatus.wcNotConnectedWithQrReady, tasksServices: tasksServices);
    } else {
      walletProvider.setWcState(state: WCStatus.error, tasksServices: tasksServices, error: 'Opps... something went wrong, try again \nreason: WC connection error');
      log.severe('walletconnectv2->connectWallet error: walletConnectUri is empty');
    }
  }

  Future<void> onSessionExpire(SessionExpire? event) async {
    log.fine('walletconnectv2.dart -> onSessionExpire');
    TasksServices tasksServices = Provider.of<TasksServices>(context, listen: false);
    WalletProvider walletProvider = Provider.of<WalletProvider>(context, listen: false);

    await walletProvider.resetView(tasksServices);
    await tasksServices.getTaskListFullThenFetchIt();
  }

  Future<void> onSessionConnect(SessionConnect? event) async {
    TasksServices tasksServices = Provider.of<TasksServices>(context, listen: false);
    WalletProvider walletProvider = Provider.of<WalletProvider>(context, listen: false);
    walletProvider.setWcState(state: WCStatus.loadingWc, tasksServices: tasksServices);
    walletProvider.setWalletConnected(true);
    walletProvider.walletConnectedWC = true;

    if (tasksServices.hardhatDebug == false) {
      tasksServices.credentials = WalletConnectEthereumCredentialsV2(
        wcClient: walletProvider.web3App!,
        session: event!.session,
        tasksServices: tasksServices,
        walletProvider: walletProvider,
      );

      tasksServices.publicAddressWC = EthereumAddress.fromHex(NamespaceUtils.getAccount(
        event.session.namespaces.values.first.accounts.last,
      ));
      final int chainIdOnWallet = int.parse(NamespaceUtils.getChainFromAccount(
        event.session.namespaces.values.first.accounts.last,
      ).split(":").last);
      final chainNameOnWallet = tasksServices.allowedChainIds.keys.firstWhere((k) {
        return tasksServices.allowedChainIds[k] == chainIdOnWallet;
      }, orElse: () => 'unknown');

      if (chainIdOnWallet == walletProvider.lastErrorOnNetworkChainId) {
        log.severe('walletconnectv2.dart->onSessionConnect: Previously there '
            'were error on this network '
            'id(chainIdOnWallet): ${chainIdOnWallet} , onSessionConnect stopped');
        walletProvider.setWcState(
            state: WCStatus.error,
            tasksServices: tasksServices,
            error: 'Opps... something went wrong. \nCannot connect to '
                '${chainNameOnWallet}, please change it and try again');
        walletProvider.lastErrorOnNetworkChainId = 0; // reset error
        return;
      }

      walletProvider.chainIdOnWallet = chainIdOnWallet;
      walletProvider.chainNameOnWallet = chainNameOnWallet;
      // log.fine(
      //     'walletconnectv2.dart -> last namespace: ${event.session.namespaces.values.first.accounts.last}');

      await walletProvider.registerEventHandlers(tasksServices);

      tasksServices.publicAddress = tasksServices.publicAddressWC;

      if (tasksServices.allowedChainIds.values.contains(chainIdOnWallet) ||
          chainIdOnWallet == tasksServices.chainIdAxelar ||
          chainIdOnWallet == tasksServices.chainIdHyperlane ||
          chainIdOnWallet == tasksServices.chainIdLayerzero ||
          chainIdOnWallet == tasksServices.chainIdWormhole
      ){
        walletProvider.setAllowedChainId(true);
        walletProvider.unknownChainIdWC = false;
        try {
          await tasksServices.getTaskListFullThenFetchIt();
        } catch (e) {
          log.severe('walletconnectv2.dart->error: $e');
          log.severe('walletconnectv2.dart->error: id(chainIdOnWallet): ${chainIdOnWallet} '
              'id(tasksServices.chainId): ${tasksServices.chainId}, '
              'id(walletProvider.chainIdOnWallet): ${walletProvider.chainIdOnWallet}, '
              'id(walletProvider.chainNameOnWallet): ${walletProvider.chainNameOnWallet} .');
          walletProvider.setWcState(state: WCStatus.error, tasksServices: tasksServices, error: 'Opps... something went wrong, try again \nBlockchain connection error');
          // return;
        }
      } else {
        log.warning('walletconnectv2.dart -> selectedChainId unknown chainId: $chainIdOnWallet.');
        walletProvider.setAllowedChainId(false);
        walletProvider.unknownChainIdWC = true;
        await walletProvider.setWcState(state: WCStatus.wcConnectedNetworkUnknown, tasksServices: tasksServices);
      }
      if (chainIdOnWallet == tasksServices.allowedChainIds[walletProvider.selectedChainNameOnApp]!) {
        await walletProvider.setChainAndConnect(tasksServices, context, tasksServices.allowedChainIds[walletProvider.selectedChainNameOnApp]!);
        Timer(const Duration(milliseconds: 1400), () {
          Navigator.of(context, rootNavigator: true).pop();
        });
      } else {
        // if (!tasksServices.allowedChainIds.values.contains(chainIdOnWallet)) {
        //   walletProvider.preventEvent = true; // only prevent from unknown chainid
        // }
        await walletProvider.switchNetwork(
            tasksServices,
            tasksServices.allowedChainIds[walletProvider.selectedChainNameOnApp]!);
      }
      await tasksServices.myBalance();

    } else {
      tasksServices.chainId = 31337;
      walletProvider.setAllowedChainId(true);
      try {
        await tasksServices.getTaskListFullThenFetchIt();
      } catch (e) {
        log.severe('walletconnectv2.dart->error: $e');
        walletProvider.setWcState(state: WCStatus.error, tasksServices: tasksServices, error: 'Opps... something went wrong, try again \nBlockchain connection error');
        return;
      }
      await tasksServices.myBalance();
      await walletProvider.setWcState(state: WCStatus.wcConnectedNetworkMatch, tasksServices: tasksServices);
    }
  }
}

class WalletConnectEthereumCredentialsV2 extends CustomTransactionSender {
  final TasksServices tasksServices;
  final WalletProvider walletProvider;
  final Web3App wcClient;
  final SessionData session;
  WalletConnectEthereumCredentialsV2({required this.wcClient, required this.session, required this.tasksServices, required this.walletProvider});

  @override
  Future<String> sendTransaction(Transaction transaction) async {
    // int chainId = int.parse(NamespaceUtils.getChainFromAccount(
    //   session.namespaces.values.first.accounts.last,
    // ).split(":").last);
    // print('WalletConnectEthereumCredentialsV2: ${session.namespaces.values.first} ');
    // print('WalletConnectEthereumCredentialsV2: $chainId ');
    // int chainId = this.session.namespaces.
    // final from = await extractAddress();
    final from = tasksServices.publicAddress;
    final signResponse = await wcClient.request(
      topic: session.topic,
      chainId: 'eip155:${tasksServices.allowedChainIds[walletProvider.selectedChainNameOnApp]!}',
      request: SessionRequestParams(
        method: 'eth_sendTransaction',
        params: [
          {
            'from': from?.hex,
            'to': transaction.to?.hex,
            // 'gas': '0x${transaction.maxGas!.toRadixString(16)}',
            // 'gasPrice': '0x${transaction.gasPrice?.getInWei.toRadixString(16) ?? '0'}',
            'value': '0x${transaction.value?.getInWei.toRadixString(16) ?? '0'}',
            'data': transaction.data != null ? bytesToHex(transaction.data!) : null,
            'nonce': transaction.nonce,
          }
        ],
      ),
    );
    return signResponse.toString();
  }

  @override
  EthereumAddress get address => EthereumAddress.fromHex(session.namespaces.values.first.accounts.first.split(':').last);

  @override
  Future<EthereumAddress> extractAddress() => Future(() => EthereumAddress.fromHex(session.namespaces.values.first.accounts.first.split(':').last));

  @override
  MsgSignature signToEcSignature(Uint8List payload, {int? chainId, bool isEIP1559 = false}) {
    // TODO: implement signToEcSignature
    throw UnimplementedError();
  }

  @override
  signToSignature(Uint8List payload, {int? chainId, bool isEIP1559 = false}) {
    // TODO: implement signToSignature
    throw UnimplementedError();
  }
}
