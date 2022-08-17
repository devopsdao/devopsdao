import 'dart:typed_data';
import 'dart:io';

import 'package:web_socket_channel/io.dart';
import 'transaction_tester.dart';
import 'package:walletconnect_dart/walletconnect_dart.dart';
import 'package:web3dart/src/crypto/secp256k1.dart';
import 'package:web3dart/web3dart.dart';

import 'package:http/http.dart' as http;

import 'package:flutter/foundation.dart';

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

class EthereumTransactionSender extends TransactionTester {
  final Web3Client ethereum;
  final EthereumWalletConnectProvider provider;

  EthereumTransactionSender._internal({
    required WalletConnect connector,
    required this.ethereum,
    required this.provider,
  }) : super(connector: connector);

  factory EthereumTransactionSender() {
    // final ethereum = Web3Client(
    //     'https://ropsten.infura.io/v3/9aa3d95b3bc440fa88ea12eaa4456161',
    //     Client());

    final String _rpcUrl = Platform.isAndroid
        ? 'https://ropsten.infura.io/v3/9aa3d95b3bc440fa88ea12eaa4456161'
        : 'https://ropsten.infura.io/v3/9aa3d95b3bc440fa88ea12eaa4456161';
    final String _wsUrl = Platform.isAndroid
        ? 'https://ropsten.infura.io/v3/9aa3d95b3bc440fa88ea12eaa4456161'
        : 'wss://ropsten.infura.io/ws/v3/9aa3d95b3bc440fa88ea12eaa4456161';

    final ethereum = Web3Client(
      _rpcUrl,
      http.Client(),
      socketConnector: () {
        return IOWebSocketChannel.connect(_wsUrl).cast<String>();
      },
    );

    final connector = WalletConnect(
      bridge: 'https://bridge.walletconnect.org',
      clientMeta: PeerMeta(
        name: 'WalletConnect',
        description: 'WalletConnect Developer App',
        url: 'https://walletconnect.org',
        icons: [
          'https://gblobscdn.gitbook.com/spaces%2F-LJJeCjcLrr53DcT1Ml7%2Favatar.png?alt=media'
        ],
      ),
    );

    final provider = EthereumWalletConnectProvider(connector);

    // Create a new session
    if (!connector.connected) {
      var sessionStatus = connector.createSession(
        chainId: 3, //pass the chain id of a network. 137 is Polygon
        onDisplayUri: (uri) {
          print(uri);
          //AppMehtods.openUrl(uri); //call the launchUrl(uri) method
          // _launchURL(uri);
          //launch(uri);
        },
        // onDisplayUri: (uri) => print(uri),
      );
      debugPrint("starting session");
    } else {
      debugPrint("already connected");
      // address = session?.accounts[0];
      // chainId = session?.chainId;

      // // debugPrint("Address: " + address!);
      // debugPrint("Address: " + address);
      // debugPrint("Chain Id: " + chainId.toString());
    }

    // Subscribe to events
    connector.on('connect', (session) {
      debugPrint("connect: " + session.toString());

      // address = sessionStatus?.accounts[0];
      // chainId = sessionStatus?.chainId;

      // // debugPrint("Address: " + address!);
      // debugPrint("Address: " + address);
      // debugPrint("Chain Id: " + chainId.toString());
    });

    connector.on('session_request', (payload) {
      debugPrint("session request: " + payload.toString());
    });

    connector.on('disconnect', (session) {
      debugPrint("disconnect: " + session.toString());
    });

    return EthereumTransactionSender._internal(
      connector: connector,
      ethereum: ethereum,
      provider: provider,
    );
  }

  @override
  Future<SessionStatus> connect({OnDisplayUriCallback? onDisplayUri}) async {
    return connector.connect(chainId: 3, onDisplayUri: onDisplayUri);
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
  Future<String> signTransactions(SessionStatus session) {
    // TODO: implement signTransactions
    throw UnimplementedError();
  }
}
