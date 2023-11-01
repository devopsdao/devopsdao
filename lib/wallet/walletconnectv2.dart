import 'dart:typed_data';

import 'package:web3dart/crypto.dart';
import 'package:webthree/webthree.dart';

import 'package:walletconnect_flutter_v2/walletconnect_flutter_v2.dart';

class WalletConnectClient {
  // late final Web3App wcClient;

  // Future<void> initSession() async {
  //   wcClient = await initWalletConnect();
  // }

  Web3App? walletConnect;



  Future<void> initWalletConnect() async {
    walletConnect = await Web3App.createInstance(
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
    // print('walletConnect: ${walletConnect}');
  }



  static const String launchError = 'Metamask wallet not installed';
  static const String kShortChainId = 'eip155';
  late String kFullChainId;

  static String? _url;
  static SessionData? _sessionData;

  String get deepLinkUrl => 'metamask://wc?uri=$_url';

  String? _pairingTopic;

  Future<ConnectResponse?> createSession(int chainId) async {
    kFullChainId = 'eip155:$chainId';
    // final bool isInstalled = await metamaskIsInstalled();
    final bool isInstalled = true;

    if (!isInstalled) {
      return Future.error(launchError);
    }

    if (walletConnect == null) {
      await initWalletConnect();
    }

    final ConnectResponse connectResponse = await walletConnect!.connect(
      requiredNamespaces: {
        kShortChainId: RequiredNamespace(
          chains: [kFullChainId],
          methods: [
            'eth_sign',
            'eth_signTransaction',
            'eth_sendTransaction',
          ],
          events: [
            'chainChanged',
            'accountsChanged',
          ],
        ),
      },
    );
    final Uri? uri = connectResponse.uri;
    _url = Uri.encodeComponent('$uri');

    _pairingTopic = connectResponse.pairingTopic;

    return connectResponse;

    //

    // if (uri != null) {
    //   final String encodedUrl = Uri.encodeComponent('$uri');

    //   _url = encodedUrl;

    //   // await launchUrlString(
    //   //   deepLinkUrl,
    //   //   mode: LaunchMode.externalApplication,
    //   // );

    //   // _sessionData = await connectResponse.session.future;

    //   // final String account = NamespaceUtils.getAccount(
    //   //   _sessionData!.namespaces.values.first.accounts.first,
    //   // );

    //   // return account;
    // }

    // return null;
  }

  Future<void> disconnect() async {
    if (_pairingTopic != null) {
      await walletConnect?.disconnectSession(
        topic: _pairingTopic!,
        reason: Errors.getSdkError(Errors.USER_DISCONNECTED),
      );
    }
  }

  Future<void> disconnectPairings() async {
    List<PairingInfo> pairings = [];
    pairings = walletConnect!.pairings.getAll();
    for (var pairing in pairings) {
      walletConnect!.core.pairing.disconnect(
        topic: pairing.topic,
      );
    }
  }

  Future<void> switchNetwork(String chainId) async {
    final params = <String, dynamic>{
      'chainId': chainId,
    };
    final response = await walletConnect!.request(
        topic: _pairingTopic!,
        chainId: 'eip155:$chainId',
        request: SessionRequestParams(
          method: 'wallet_switchEthereumChain',
          params: [params],
        ));
    // return session;
  }

  Future<void> addNetwork(String chainId) async {
    final params = <String, dynamic>{
      'chainId': '0x507',
      'chainName': 'Moonbase alpha',
      'nativeCurrency': <String, dynamic>{
        'name': 'DEV',
        'symbol': 'DEV',
        'decimals': 18,
      },
      'rpcUrls': ['https://rpc.api.moonbase.moonbeam.network'],
      'blockExplorerUrls': ['https://moonbase.moonscan.io'],
      'iconUrls': [''],
    };

    final response = await walletConnect!.request(
        topic: _pairingTopic!,
        chainId: 'eip155:1287',
        request: SessionRequestParams(
          method: 'wallet_addEthereumChain',
          params: [params],
        ));

    // final response = await connector.sendCustomRequest(method: 'wallet_addEthereumChain', params: [params]);
    print('wc response: $response');

    // return session;
  }

  // Future<int> getChainId() async {
  //   // final params = <String, dynamic>{
  //   //   'chainId': '0x507',
  //   // };
  //   final response = await connector.sendCustomRequest(method: 'eth_chainId', params: []);
  //   print(response);
  //   return int.parse(response);

  //   // return session;
  // }

  // @override
  // Future<String> signTransaction(SessionStatus session) async {
  //   final sender = EthereumAddress.fromHex(session.accounts[0]);

  //   final transaction = Transaction(
  //     to: sender,
  //     from: sender,
  //     gasPrice: EtherAmount.inWei(BigInt.one),
  //     maxGas: EtherAmount.fromUnitAndValue(EtherUnit.gwei, 1).getValueInUnit(EtherUnit.gwei).toInt(),
  //     value: EtherAmount.fromUnitAndValue(EtherUnit.finney, 1),
  //   );

  //   final credentials = WalletConnectEthereumCredentials(provider: provider);

  //   // Sign the transaction
  //   final txBytes = await ethereum.sendTransaction(credentials, transaction);

  //   // Kill the session
  //   connector.killSession();

  //   return txBytes;
  // }

  // @override
  // Future<String> sendTransactionWC(transaction) async {
  //   final credentials = WalletConnectEthereumCredentials(provider: provider);

  //   // Sign the transaction
  //   final txBytes = await ethereum.sendTransaction(credentials, transaction);

  //   return txBytes;
  // }

  // Future<EthereumAddress> getPublicAddress(SessionStatus session) async {
  //   final addr = EthereumAddress.fromHex(session.accounts[0]);

  //   return addr;
  // }

  // Future<WalletConnectEthereumCredentials> getCredentials() async {
  //   final credentials = WalletConnectEthereumCredentials(provider: provider);

  //   return credentials;
  // }

  // @override
  // Future<String> signTransactions(SessionStatus session) {
  //   // TODO: implement signTransactions
  //   throw UnimplementedError();
  // }
}

class WalletConnectEthereumCredentialsV2 extends CustomTransactionSender {
  WalletConnectEthereumCredentialsV2({required this.wcClient, required this.session});

  final Web3App wcClient;
  final SessionData session;

  @override
  Future<String> sendTransaction(Transaction transaction) async {
    int chainId = int.parse(NamespaceUtils.getChainFromAccount(
      session.namespaces.values.first.accounts.last,
    ).split(":").last);
    // int chainId = this.session.namespaces.
    final from = await extractAddress();
    final signResponse = await wcClient.request(
      topic: session.topic,
      chainId: 'eip155:$chainId',
      request: SessionRequestParams(
        method: 'eth_sendTransaction',
        params: [
          {
            'from': from.hex,
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
