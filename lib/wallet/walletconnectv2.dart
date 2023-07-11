import 'dart:typed_data';

// import 'walletconnect_provider.dart';
// import 'package:walletconnect_dart/walletconnect_dart.dart';
// import 'package:walletconnect_secure_storage/walletconnect_secure_storage.dart';
import 'package:webthree/src/crypto/secp256k1.dart';
import 'package:webthree/webthree.dart';

import 'package:walletconnect_flutter_v2/walletconnect_flutter_v2.dart';

class WalletConnectV2 {
  // WalletConnectEthereumCredentials({required this.provider});

  // final EthereumWalletConnectProvider provider;

  @override
  Future<EthereumAddress> extractAddress() {
    // TODO: implement extractAddress
    throw UnimplementedError();
  }

  // @override
  // Future<String> sendTransaction(Transaction transaction) async {
  //   String hash = 'failed';
  //   if (provider.connector.connected && !provider.connector.bridgeConnected) {
  //     print('Attempt to recover');
  //     provider.connector.reconnect();
  //   }
  //   try {
  //     hash = await provider.sendTransaction(
  //       from: transaction.from!.hex,
  //       to: transaction.to?.hex,
  //       data: transaction.data,
  //       // maxFeePerGas: transaction.maxFeePerGas?.getInWei,
  //       // maxPriorityFeePerGas: transaction.maxFeePerGas?.getInWei,
  //       // maxGas: transaction.maxFeePerGas,
  //       gas: transaction.maxGas,
  //       gasPrice: transaction.gasPrice?.getInWei,
  //       value: transaction.value?.getInWei,
  //       nonce: transaction.nonce,
  //     );
  //   } catch (e) {
  //     print(e.toString());
  //     if (e.toString() == 'JSON-RPC error -32000: User rejected the transaction') {
  //       hash = 'rejected';
  //     }
  //   }

  //   return hash;
  // }

  @override
  Future<MsgSignature> signToSignature(Uint8List payload, {int? chainId, bool isEIP1559 = false}) {
    // TODO: implement signToSignature
    throw UnimplementedError();
  }
}

class EthereumWallectConnectTransactionV2 {
  // late final Web3App wcClient;

  // Future<void> initSession() async {
  //   wcClient = await initWalletConnect();
  // }

  static Web3App? _walletConnect;

  Future<void> _initWalletConnect() async {
    _walletConnect = await Web3App.createInstance(
      projectId: 'c4f79cc821944d9680842e34466bfb',
      metadata: const PairingMetadata(
        name: 'Flutter WalletConnect',
        description: 'Flutter WalletConnect Dapp Example',
        url: 'https://walletconnect.com/',
        icons: [
          'https://walletconnect.com/walletconnect-logo.png',
        ],
      ),
    );
  }

  static const String launchError = 'Metamask wallet not installed';
  static const String kShortChainId = 'eip155';
  static const String kFullChainId = 'eip155:80001';

  static String? _url;
  static SessionData? _sessionData;

  String get deepLinkUrl => 'metamask://wc?uri=$_url';

  Future<String?> createSession() async {
    // final bool isInstalled = await metamaskIsInstalled();
    final bool isInstalled = true;

    if (!isInstalled) {
      return Future.error(launchError);
    }

    if (_walletConnect == null) {
      await _initWalletConnect();
    }

    final ConnectResponse connectResponse = await _walletConnect!.connect(
      requiredNamespaces: {
        kShortChainId: const RequiredNamespace(
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

    if (uri != null) {
      final String encodedUrl = Uri.encodeComponent('$uri');

      _url = encodedUrl;

      // await launchUrlString(
      //   deepLinkUrl,
      //   mode: LaunchMode.externalApplication,
      // );

      _sessionData = await connectResponse.session.future;

      final String account = NamespaceUtils.getAccount(
        _sessionData!.namespaces.values.first.accounts.first,
      );

      return account;
    }

    return null;
  }
  // @override
  // Future<void> disconnect() async {
  //   if (connector.connected) {
  //     await connector.killSession();
  //   }
  //   await sessionStorage.removeSession();
  // }

  // @override
  // Future<void> removeSession() async {
  //   await sessionStorage.removeSession();
  // }

  // Future<void> switchNetwork(String chainId) async {
  //   final params = <String, dynamic>{
  //     'chainId': chainId,
  //   };
  //   final response = await connector.sendCustomRequest(method: 'wallet_switchEthereumChain', params: [params]);
  //   print(response);

  //   // return session;
  // }

  // Future<void> addNetwork(String chainId) async {
  //   final params = <String, dynamic>{
  //     'chainId': '0x507',
  //     'chainName': 'Moonbase alpha',
  //     'nativeCurrency': <String, dynamic>{
  //       'name': 'DEV',
  //       'symbol': 'DEV',
  //       'decimals': 18,
  //     },
  //     'rpcUrls': ['https://rpc.api.moonbase.moonbeam.network'],
  //     'blockExplorerUrls': ['https://moonbase.moonscan.io'],
  //     'iconUrls': [''],
  //   };

  //   final response = await connector.sendCustomRequest(method: 'wallet_addEthereumChain', params: [params]);
  //   print(response);

  //   // return session;
  // }

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
