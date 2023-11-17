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
      walletProvider.selectedChainNameMenu = tasksServices.defaultNetworkName;
      walletProvider.chainNameOnApp = tasksServices.defaultNetworkName;
    }

    if (!tasksServices.walletConnected) {
      connectWallet();
    }
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
        callDisconnectWallet: disconnectWCv2,
      );
    });
  }


  Future<void> connectWallet() async {
    log.fine('walletconnectv2.dart -> connectWallet() start');
    TasksServices tasksServices = Provider.of<TasksServices>(context, listen: false);
    WalletProvider walletProvider = Provider.of<WalletProvider>(context, listen: false);

    if (tasksServices.walletConnected == false) {
      log.fine("walletconnectv2.dart -> walletConnected = false, remove value in walletConnectUri & walletConnectSessionUri");
      walletProvider.walletConnectUri = '';
      tasksServices.walletConnectSessionUri = '';
    }
    // if (walletProvider.web3App == null) {
    //   await walletProvider.initWalletConnect();
    // }
    await walletProvider.disconnectPairings();
    await walletProvider.unsubscribe();

    walletProvider.web3App?.onSessionDelete.subscribe((onSessionDelete) async {
      log.fine('walletconnectv2.dart -> onSessionDelete');
    });
    walletProvider.web3App?.onSessionEvent.subscribe((onSessionEvent) async {
      log.fine('walletconnectv2.dart -> onSessionEvent -> name: ${onSessionEvent?.name}');
      log.fine('walletconnectv2.dart -> onSessionEvent -> chainId: ${onSessionEvent?.chainId}');
      log.fine('walletconnectv2.dart -> onSessionEvent -> id: ${onSessionEvent?.id}');
      log.fine('walletconnectv2.dart -> onSessionEvent -> data: '
          '${onSessionEvent?.data}, tasksServices.chainId: '
          '${tasksServices.chainId}, walletConnectedWC:'
          '${tasksServices.walletConnectedWC}'
      );
      if (onSessionEvent?.name == 'chainChanged' && onSessionEvent?.data != tasksServices.chainId) {
        // await walletProvider.switchNetwork(tasksServices, onSessionEvent?.data, tasksServices.allowedChainIds[walletProvider.chainNameOnApp]!); // default network
        // tasksServices.walletConnected = false;
        // tasksServices.walletConnectedWC = false;
        // tasksServices.publicAddress = null;
        // tasksServices.publicAddressWC = null;
        // tasksServices.allowedChainId = false;
        // walletProvider.unknownChainIdWC = false;
        // tasksServices.ethBalance = 0;
        // tasksServices.ethBalanceToken = 0;
        // tasksServices.pendingBalance = 0;
        // tasksServices.pendingBalanceToken = 0;
        // walletProvider.walletConnectUri = '';
        // tasksServices.walletConnectSessionUri = '';
        // tasksServices.closeWalletDialog = true;
        // tasksServices.chainId = onSessionEvent?.data;
        // tasksServices.allowedChainId = true;
        // walletProvider.unknownChainIdWC = false;
        // walletProvider.notifyListeners();
        // await tasksServices.connectRPC(tasksServices.chainId);
        // await tasksServices.startup();
        // await tasksServices.collectMyTokens();
        // walletProvider.chainNameOnWallet = tasksServices.allowedChainIds.keys.firstWhere((k) => tasksServices.allowedChainIds[k]==onSessionEvent?.data, orElse: () => 'unknown');
        // final chainIdOnApp = tasksServices.allowedChainIds[walletProvider.chainNameOnApp]!;
        // walletProvider.chainNameOnApp = tasksServices.allowedChainIds.keys.firstWhere((k) => tasksServices.allowedChainIds[k]==chainIdOnApp, orElse: () => 'unknown');
        walletProvider.setChainAndConnect(tasksServices,  onSessionEvent?.data);
      }
      if (
          onSessionEvent?.name == 'accountsChanged' &&
          onSessionEvent?.data != tasksServices.chainId &&
          tasksServices.walletConnectedWC
      ) {
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
      // log.fine('walletconnectv2.dart -> onSessionPing -> topic: ${onSessionPing?.topic}');
    });
    walletProvider.web3App?.onSessionUpdate.subscribe((onSessionUpdate) async {
      log.fine('walletconnectv2.dart -> onSessionUpdate -> id: ${onSessionUpdate?.id}');
      // log.fine('walletconnectv2.dart -> onSessionUpdate -> namespaces: ${onSessionUpdate?.namespaces}');
      // log.fine('walletconnectv2.dart -> onSessionUpdate -> topic: ${onSessionUpdate?.topic}');
    });
    walletProvider.web3App?.onSessionConnect.subscribe(onSessionConnect);
    walletProvider.web3App?.onSessionExpire.subscribe(onSessionExpire);

    // /// onSessionDelete:
    // web3App?.onSessionDelete.subscribe((sessionConnect) async {
    //   log.fine('walletconnectv2.dart -> onSessionDelete');
    //   // walletConnectState = TransactionState.disconnected;
    //   await resetView();

    //   List<EthereumAddress> taskList = await tasksServices.getTaskListFull();
    //   await tasksServices.fetchTasksBatch(taskList);
    //
    //   // await connectWalletWCv2(true);
    // });
    log.fine('walletconnectv2.dart -> createSession chainId: ${tasksServices.allowedChainIds[walletProvider.chainNameOnApp]!} , walletProvider.chainNameOnApp: ${walletProvider.chainNameOnApp}');
    await walletProvider.createSession(tasksServices.allowedChainIds[walletProvider.chainNameOnApp]!);

    tasksServices.notifyListeners();
    // log.fine('walletconnectv2.dart -> connectWallet -> result walletConnectUri: ' + walletProvider.walletConnectUri);
  }

  Future<void> disconnectWCv2() async {
    WalletProvider walletProvider = Provider.of<WalletProvider>(context, listen: false);
    TasksServices tasksServices = Provider.of<TasksServices>(context, listen: false);
    log.fine('walletconnectv2.dart -> disconnectWCv2');
    await resetView();
    await walletProvider.disconnect();
    await walletProvider.disconnectPairings();
    List<EthereumAddress> taskList = await tasksServices.getTaskListFull();
    await tasksServices.fetchTasksBatch(taskList);
    connectWallet();
  }

  // void onSessionEvent(SessionEvent? args) {
  //   TasksServices tasksServices = Provider.of<TasksServices>(context, listen: false);
  //   WalletProvider walletProvider = Provider.of<WalletProvider>(context, listen: false);
  //   log.fine('walletconnectv2.dart -> onSessionEvent -> name: ${args?.name}');
  //   log.fine('walletconnectv2.dart -> onSessionEvent -> chainId: ${args?.chainId}');
  //   log.fine('walletconnectv2.dart -> onSessionEvent -> data: ${args?.data}');
  //   if (args?.name == 'chainChanged') {
  //     // tasksServices.chainId = args?.data;
  //     walletProvider.setChainAndConnect(tasksServices,  args?.data);
  //     // tasksServices.notifyListeners();
  //     // if (W3MChainPresets.chains.containsKey('${args?.data}')) {
  //     //   final chain = W3MChainPresets.chains['${args?.data}'];
  //     //   selectChain(chain);
  //     // }
  //   }
  // }

  Future<void> onSessionExpire(SessionExpire? event) async {
    log.fine('walletconnectv2.dart -> onSessionExpire');
    TasksServices tasksServices = Provider.of<TasksServices>(context, listen: false);
    WalletProvider walletProvider = Provider.of<WalletProvider>(context, listen: false);

    await resetView();

    List<EthereumAddress> taskList = await tasksServices.getTaskListFull();
    await tasksServices.fetchTasksBatch(taskList);

    // await connectWalletWCv2(true);
  }

  Future<void> onSessionConnect(SessionConnect? event) async {
    TasksServices tasksServices = Provider.of<TasksServices>(context, listen: false);
    WalletProvider walletProvider = Provider.of<WalletProvider>(context, listen: false);
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

      if (
          tasksServices.allowedChainIds.values.contains(chainIdOnWallet) ||
              chainIdOnWallet == tasksServices.chainIdAxelar ||
              chainIdOnWallet == tasksServices.chainIdHyperlane ||
              chainIdOnWallet == tasksServices.chainIdLayerzero ||
              chainIdOnWallet == tasksServices.chainIdWormhole) {
        // await walletProvider.setChainAndConnect(tasksServices, chainIdOnWallet);
      } else {
        log.fine('walletconnectv2.dart -> selectedChainId not in tasksServices.allowedChainIds List');
        tasksServices.allowedChainId = false;
        walletProvider.unknownChainIdWC = true;
        // walletProvider.walletConnectUri = '';
        // tasksServices.walletConnectSessionUri = '';
        tasksServices.notifyListeners();
        // await walletProvider.setChainAndConnect(tasksServices, chainIdOnWallet);
        // await walletProvider.switchNetwork(tasksServices, chainIdOnWallet, tasksServices.allowedChainIds[walletProvider.chainNameOnApp]!); // default network
      }
      await walletProvider.switchNetwork(
          tasksServices,
          chainIdOnWallet,
          tasksServices.allowedChainIds[walletProvider.chainNameOnApp]!);
    } else {
      tasksServices.chainId = 31337;
      tasksServices.allowedChainId = true;
    }
    List<EthereumAddress> taskList = await tasksServices.getTaskListFull();
    await tasksServices.fetchTasksBatch(taskList);

    tasksServices.myBalance();
    tasksServices.notifyListeners();
  }

  Future<void> resetView() async {
    WalletProvider walletProvider = Provider.of<WalletProvider>(context, listen: false);
    TasksServices tasksServices = Provider.of<TasksServices>(context, listen: false);
    tasksServices.walletConnected = false;
    tasksServices.walletConnectedWC = false;
    tasksServices.publicAddress = null;
    tasksServices.publicAddressWC = null;
    tasksServices.allowedChainId = false;
    walletProvider.unknownChainIdWC = false;
    tasksServices.ethBalance = 0;
    tasksServices.ethBalanceToken = 0;
    tasksServices.pendingBalance = 0;
    tasksServices.pendingBalanceToken = 0;
    walletProvider.walletConnectUri = '';
    tasksServices.walletConnectSessionUri = '';
    tasksServices.notifyListeners();
  }
}

class WalletConnectEthereumCredentialsV2 extends CustomTransactionSender {
  final TasksServices tasksServices;
  final WalletProvider walletProvider;
  final Web3App wcClient;
  final SessionData session;
  WalletConnectEthereumCredentialsV2({
    required this.wcClient,
    required this.session,
    required this.tasksServices,
    required this.walletProvider
  });

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
