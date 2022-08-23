import 'dart:typed_data';

import 'package:http/http.dart';
import 'transaction_tester.dart';
import 'package:walletconnect_dart/walletconnect_dart.dart';
import 'package:walletconnect_secure_storage/walletconnect_secure_storage.dart';
import 'package:web3dart/src/crypto/secp256k1.dart';
import 'package:web3dart/web3dart.dart';

class WalletConnectEthereumCredentials extends CustomTransactionSender {
  WalletConnectEthereumCredentials({required this.provider});

  final EthereumWalletConnectProvider provider;

  @override
  Future<EthereumAddress> extractAddress() {
    // TODO: implement extractAddress
    throw UnimplementedError();
  }

  @override
  Future<String> sendTransaction(Transaction transaction) async {
    final hash = await provider.sendTransaction(
      from: transaction.from!.hex,
      to: transaction.to?.hex,
      data: transaction.data,
      gas: transaction.maxGas,
      gasPrice: transaction.gasPrice?.getInWei,
      value: transaction.value?.getInWei,
      nonce: transaction.nonce,
    );

    return hash;
  }

  @override
  Future<MsgSignature> signToSignature(Uint8List payload,
      {int? chainId, bool isEIP1559 = false}) {
    // TODO: implement signToSignature
    throw UnimplementedError();
  }
}

class EthereumTransactionTester extends TransactionTester {
  late final Web3Client ethereum;
  late EthereumWalletConnectProvider provider;
  late WalletConnectSession? session;
  late EthereumAddress? publicAddress;
  late WalletConnect connector;

  // EthereumTransactionTester(connector) : super(connector: connector);

  EthereumTransactionTester() {
    // initWalletConnect();
  }

  // EthereumTransactionTester._internal({
  //   required WalletConnect connector,
  //   required this.ethereum,
  //   required this.provider,
  // }) : super(connector: connector);

  // factory EthereumTransactionTester() {
  //   final ethereum = Web3Client('https://ropsten.infura.io/', Client());

  //   final sessionStorage = WalletConnectSecureStorage();

  //   final connector = WalletConnect(
  //     bridge: 'https://bridge.walletconnect.org',
  //     session: session,
  //     sessionStorage: sessionStorage,
  //     clientMeta: PeerMeta
  //       name: 'Devopsdao Wallet connect session',
  //       description: 'Devopsdao App',
  //       url: 'https://devopsdao.com',
  //       icons: [
  //         'https://gblobscdn.gitbook.com/spaces%2F-LJJeCjcLrr53DcT1Ml7%2Favatar.png?alt=media'
  //       ],
  //     ),
  //   );

  //   final provider = EthereumWalletConnectProvider(connector);

  //   return EthereumTransactionTester._internal(
  //     connector: connector,
  //     ethereum: ethereum,
  //     provider: provider,
  //   );
  // }
  // late WalletConnect connector;

  Future<WalletConnect> initWalletConnect() async {
    final sessionStorage = WalletConnectSecureStorage();
    session = await sessionStorage.getSession();

    // Create a connector
    connector = WalletConnect(
      bridge: 'https://bridge.walletconnect.org',
      session: session,
      sessionStorage: sessionStorage,
      clientMeta: const PeerMeta(
        name: 'Devopsdao',
        description: 'Devopsdao WalletConnect',
        url: 'https://devopsdao.com',
        icons: [
          'https://gblobscdn.gitbook.com/spaces%2F-LJJeCjcLrr53DcT1Ml7%2Favatar.png?alt=media'
        ],
      ),
    );
    provider = EthereumWalletConnectProvider(connector);

    return connector;
  }

  Future createSession({OnDisplayUriCallback? onDisplayUri}) async {
    // Create a new session
    if (connector.connected && !connector.bridgeConnected) {
      print('Attempt to recover');
      connector.reconnect();
    }
    if (!connector.connected) {
      final session = connector.createSession(
        chainId: 4160,
        onDisplayUri: (uri) => print(uri),
      );

      print('Connected: $session');
    }
    return session;
  }

  @override
  Future<SessionStatus> connect({OnDisplayUriCallback? onDisplayUri}) async {
    // WalletConnectSecureStorage sessionStorage = WalletConnectSecureStorage();
    // session = await sessionStorage.getSession();
    // // this.session = session;
    // this.publicAddress = EthereumAddress.fromHex(session!.accounts[0]);
    final session = connector.connect(chainId: 3, onDisplayUri: onDisplayUri);

    return session;
  }

  @override
  Future<void> disconnect() async {
    await connector.killSession();
  }

  @override
  Future<String> signTransaction(SessionStatus session) async {
    final sender = EthereumAddress.fromHex(session.accounts[0]);

    final transaction = Transaction(
      to: sender,
      from: sender,
      gasPrice: EtherAmount.inWei(BigInt.one),
      maxGas: 100000,
      value: EtherAmount.fromUnitAndValue(EtherUnit.finney, 1),
    );

    final credentials = WalletConnectEthereumCredentials(provider: provider);

    // Sign the transaction
    final txBytes = await ethereum.sendTransaction(credentials, transaction);

    // Kill the session
    connector.killSession();

    return txBytes;
  }

  @override
  Future<String> sendTransactionWC(transaction) async {
    final credentials = WalletConnectEthereumCredentials(provider: provider);

    // Sign the transaction
    final txBytes = await ethereum.sendTransaction(credentials, transaction);

    return txBytes;
  }

  Future<EthereumAddress> getPublicAddress(SessionStatus session) async {
    final addr = EthereumAddress.fromHex(session.accounts[0]);

    return addr;
  }

  Future<WalletConnectEthereumCredentials> getCredentials() async {
    final credentials = WalletConnectEthereumCredentials(provider: provider);

    return credentials;
  }

  @override
  Future<String> signTransactions(SessionStatus session) {
    // TODO: implement signTransactions
    throw UnimplementedError();
  }
}
