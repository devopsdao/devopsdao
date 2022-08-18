import 'package:flutter/foundation.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:walletconnect_dart/walletconnect_dart.dart';
import 'package:walletconnect_secure_storage/walletconnect_secure_storage.dart';
import 'package:qr_flutter/qr_flutter.dart';

import 'dart:io';
import 'package:web3dart/web3dart.dart';
import 'package:http/http.dart' as http;
import 'package:web_socket_channel/io.dart';
import 'dart:typed_data';
import 'package:web3dart/src/crypto/secp256k1.dart';

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

class WalletConnectManager {
  var sessionStatus;
  var session;
  var address;
  var chainId;
  var connector;
  var provider;

  final String _rpcUrl = Platform.isAndroid
      ? 'https://ropsten.infura.io/v3/9aa3d95b3bc440fa88ea12eaa4456161'
      : 'https://ropsten.infura.io/v3/9aa3d95b3bc440fa88ea12eaa4456161';
  final String _wsUrl = Platform.isAndroid
      ? 'https://ropsten.infura.io/v3/9aa3d95b3bc440fa88ea12eaa4456161'
      : 'wss://ropsten.infura.io/ws/v3/9aa3d95b3bc440fa88ea12eaa4456161';
  bool isLoading = true;

  // final String _privatekey =
  //     'f9a150364de5359a07b91b1af8ac1c75ad9e084d7bd2c0e09beb5df7fa6cafa0'; //m's ropsten key
  final String _privatekey =
      'f819f5453032c5166a3a459506058cb46c37d6eca694dafa76f2b6fe33d430e8'; //u's ropsten key
  late Web3Client _web3client;

  // faucet m's key:
  // f9a150364de5359a07b91b1af8ac1c75ad9e084d7bd2c0e09beb5df7fa6cafa0
  // internal key's
  // e1f0d3b368c3aaf8fde11e8da9a6ab2162fbd08f384145b480f16ab9cd746941 - second user
  // 01fe73c191d0433fd7f64390a02469f30044a40a48a548591b630952e084884f

  WalletConnectManager() {
    init();
  }

  Future<void> init() async {
    _web3client = Web3Client(
      _rpcUrl,
      http.Client(),
      socketConnector: () {
        return IOWebSocketChannel.connect(_wsUrl).cast<String>();
      },
    );
  }

// final EthereumWalletConnectProvider provider;
  Future<WalletConnect> connectWallet() async {
    WalletConnectSecureStorage sessionStorage = WalletConnectSecureStorage();
    session = await sessionStorage.getSession();
    this.session = session;

    final connector = WalletConnect(
      bridge: 'https://bridge.walletconnect.org',
      session: session,
      sessionStorage: sessionStorage,
      clientMeta: const PeerMeta(
        name: 'WalletConnect',
        description: 'WalletConnect Developer App',
        url: 'https://walletconnect.org',
        icons: [
          'https://gblobscdn.gitbook.com/spaces%2F-LJJeCjcLrr53DcT1Ml7%2Favatar.png?alt=media'
        ],
      ),
    );
    this.connector = connector;
    this.provider = EthereumWalletConnectProvider(this.connector);

    // Subscribe to events
    connector.on('connect', (session) {
      debugPrint("connect: " + session.toString());

      address = sessionStatus?.accounts[0];
      chainId = sessionStatus?.chainId;

      // debugPrint("Address: " + address!);
      debugPrint("Address: " + address);
      debugPrint("Chain Id: " + chainId.toString());
    });

    connector.on('session_request', (payload) {
      debugPrint("session request: " + payload.toString());
    });

    connector.on('disconnect', (session) {
      debugPrint("disconnect: " + session.toString());
    });

    _launchURL(url) async {
      // const url = 'https://flutter.io';
      if (await canLaunch(url)) {
        await launch(url);
      } else {
        await launch(url);
        throw 'Could not launch $url';
      }
    }

    // Create a new session
    if (!connector.connected) {
      sessionStatus = await connector.createSession(
        chainId: 3, //pass the chain id of a network. 137 is Polygon
        onDisplayUri: (uri) {
          print(uri);
          //AppMehtods.openUrl(uri); //call the launchUrl(uri) method
          // _launchURL(uri);
          launch(uri);
        },
        // onDisplayUri: (uri) => print(uri),
      );
      debugPrint("starting session");
    } else {
      debugPrint("already connected");
      address = session?.accounts[0];
      chainId = session?.chainId;

      // debugPrint("Address: " + address!);
      debugPrint("Address: " + address);
      debugPrint("Chain Id: " + chainId.toString());
    }

    return connector;
  }

  Future<void> disconnect() async {
    await this.connector.killSession();
  }

  Future<String> sendTransaction(Transaction transaction) async {
    final hash = await this.provider.sendTransaction(
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

  Future<String> sendTransaction2() async {
    final sender = EthereumAddress.fromHex(this.session.accounts[0]);
    final amount = 1;
    final transaction = Transaction(
      to: sender,
      from: sender,
      gasPrice: EtherAmount.inWei(BigInt.one),
      maxGas: 100000000,
      value: EtherAmount.fromUnitAndValue(EtherUnit.finney, 1),
    );

    final credentials =
        WalletConnectEthereumCredentials(provider: this.provider);

    // Sign the transaction
    final txBytes =
        await _web3client.sendTransaction(credentials, transaction, chainId: 3);
    print(txBytes);
    return 'good';
  }
}
// launchUrl(Uri.parse(uri));