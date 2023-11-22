import 'dart:async';
import 'dart:typed_data';

import 'package:dodao/wallet/pages/2_wallet_connect.dart';
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

    // initial network name set:
    if (walletProvider.chainNameOnApp.isEmpty) {
      walletProvider.chainNameOnApp = tasksServices.defaultNetworkName;
    }
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      if (!tasksServices.walletConnected) {
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
    log.fine('walletconnectv2.dart -> connectWallet() start');
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
          // 'chainId: ${onSessionEvent?.chainId}, '
          'data: ${onSessionEvent?.data} :: '
          'local tasksServices.chainId: ${tasksServices.chainId}, '
          'walletConnectedWC: ${tasksServices.walletConnectedWC}');

      if (onSessionEvent?.name == 'chainChanged' && onSessionEvent?.data != tasksServices.chainId) {
        walletProvider.setChainAndConnect(tasksServices, onSessionEvent?.data);
      } else if (onSessionEvent?.name == 'chainChanged' && onSessionEvent?.data == tasksServices.chainId) {
        walletProvider.setChainAndConnect(tasksServices, onSessionEvent?.data);
      }

      if (onSessionEvent?.name == 'accountsChanged' && onSessionEvent?.data != tasksServices.chainId && tasksServices.walletConnectedWC) {
        // final String newAccount = onSessionEvent!.data.toString().split(":").last;
        final EthereumAddress newAccount = EthereumAddress.fromHex(NamespaceUtils.getAccount(
          onSessionEvent!.data.first.toString(),
        ));
        if (newAccount != tasksServices.publicAddress) {
          // walletProvider.updateAccountAddress(tasksServices, newAccount);
          // await walletProvider.switchNetwork(tasksServices, onSessionEvent?.data, tasksServices.allowedChainIds[walletProvider.chainNameOnApp]!); // default network
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

    log.fine(
        'walletconnectv2.dart -> createSession chainId: ${tasksServices.allowedChainIds[walletProvider.chainNameOnApp]!} , walletProvider.chainNameOnApp: ${walletProvider.chainNameOnApp}');
    await walletProvider.createSession(tasksServices.allowedChainIds[walletProvider.chainNameOnApp]!);
    if (walletProvider.walletConnectUri.isNotEmpty) {
      walletProvider.setWcState(state: WCStatus.wcNotConnectedWithQrReady, tasksServices: tasksServices);
    } else {
      walletProvider.setWcState(state: WCStatus.error, tasksServices: tasksServices, error: 'WC connection error');
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
    tasksServices.walletConnected = true;
    tasksServices.walletConnectedWC = true;

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

      // log.fine(
      //     'walletconnectv2.dart -> last namespace: ${event.session.namespaces.values.first.accounts.last}');

      await walletProvider.registerEventHandlers(tasksServices);

      tasksServices.publicAddress = tasksServices.publicAddressWC;

      if (tasksServices.allowedChainIds.values.contains(chainIdOnWallet) ||
          chainIdOnWallet == tasksServices.chainIdAxelar ||
          chainIdOnWallet == tasksServices.chainIdHyperlane ||
          chainIdOnWallet == tasksServices.chainIdLayerzero ||
          chainIdOnWallet == tasksServices.chainIdWormhole) {
        // await walletProvider.setChainAndConnect(tasksServices, chainIdOnWallet);
        tasksServices.allowedChainId = true;
        walletProvider.unknownChainIdWC = false;
        try {
          await tasksServices.getTaskListFullThenFetchIt();
        } catch (e) {
          log.severe('walletconnectv2.dart->error: $e');
          walletProvider.setWcState(state: WCStatus.error, tasksServices: tasksServices, error: 'Blockchain connection error');
          return;
        }
      } else {
        log.fine('walletconnectv2.dart -> selectedChainId not in tasksServices.allowedChainIds List');
        tasksServices.allowedChainId = false;
        walletProvider.unknownChainIdWC = true;
        walletProvider.setWcState(state: WCStatus.wcConnectedNetworkUnknown, tasksServices: tasksServices);
        // walletProvider.walletConnectUri = '';
        // await walletProvider.setChainAndConnect(tasksServices, chainIdOnWallet);
        // await walletProvider.switchNetwork(tasksServices, chainIdOnWallet, tasksServices.allowedChainIds[walletProvider.chainNameOnApp]!); // default network
      }
      if (chainIdOnWallet != tasksServices.allowedChainIds[walletProvider.chainNameOnApp]!) {
        await walletProvider.switchNetwork(tasksServices, chainIdOnWallet, tasksServices.allowedChainIds[walletProvider.chainNameOnApp]!);
      } else {
        await walletProvider.setChainAndConnect(tasksServices, tasksServices.allowedChainIds[walletProvider.chainNameOnApp]!);
      }

      tasksServices.myBalance();
    } else {
      tasksServices.chainId = 31337;
      tasksServices.allowedChainId = true;
      try {
        await tasksServices.getTaskListFullThenFetchIt();
      } catch (e) {
        log.severe('walletconnectv2.dart->error: $e');
        walletProvider.setWcState(state: WCStatus.error, tasksServices: tasksServices, error: 'Blockchain connection error');
        return;
      }
      await tasksServices.myBalance();
      await walletProvider.setWcState(state: WCStatus.wcConnectedNetworkMatch, tasksServices: tasksServices);
      Timer(const Duration(seconds: 2), () {
        walletProvider.closeWalletDialog(tasksServices);
      });
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
      chainId: 'eip155:${tasksServices.allowedChainIds[walletProvider.chainNameOnApp]!}',
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
