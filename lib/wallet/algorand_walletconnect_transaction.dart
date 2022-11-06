import 'package:algorand_dart/algorand_dart.dart';
import 'walletconnect_provider.dart';
import 'package:walletconnect_dart/walletconnect_dart.dart';
import 'package:walletconnect_secure_storage/walletconnect_secure_storage.dart';

class AlgorandWalletConnectTransaction extends WallectConnectTransaction {
  late final Algorand algorand;
  late final AlgorandWalletConnectProvider provider;
  late final WalletConnect connector;

  AlgorandWalletConnectTransaction() {
    initWalletConnect();
  }

  // AlgorandWalletConnectTransaction._internal({
  //   required WalletConnect connector,
  //   required this.algorand,
  //   required this.provider,
  // }) : super(connector: connector);

  // factory AlgorandWalletConnectTransaction() {
  //   final algorand = Algorand(
  //     algodClient: AlgodClient(apiUrl: AlgoExplorer.TESTNET_ALGOD_API_URL),
  //   );

  //   final connector = WalletConnect(
  //     bridge: 'https://bridge.walletconnect.org',
  //     clientMeta: PeerMeta(
  //       name: 'WalletConnect',
  //       description: 'WalletConnect Developer App',
  //       url: 'https://walletconnect.org',
  //       icons: [
  //         'https://gblobscdn.gitbook.com/spaces%2F-LJJeCjcLrr53DcT1Ml7%2Favatar.png?alt=media'
  //       ],
  //     ),
  //   );

  //   final provider = AlgorandWalletConnectProvider(connector);

  //   return AlgorandWalletConnectTransaction._internal(
  //     connector: connector,
  //     algorand: algorand,
  //     provider: provider,
  //   );
  // }

  @override
  Future<void> initSession() async {
    throw UnimplementedError();
  }

  @override
  Future initWalletConnect() async {
    final sessionStorage = WalletConnectSecureStorage();
    final session = await sessionStorage.getSession();

    // Create a connector
    connector = WalletConnect(
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
  }

  @override
  Future createSession({OnDisplayUriCallback? onDisplayUri}) async {
    // TODO: implement createSession
    throw UnimplementedError();
  }

  @override
  Future<SessionStatus> connect({OnDisplayUriCallback? onDisplayUri}) async {
    return connector.connect(chainId: 4160, onDisplayUri: onDisplayUri);
  }

  @override
  Future<void> disconnect() async {
    await connector.close(forceClose: true);
  }

  @override
  Future<void> removeSession() async {
    throw UnimplementedError();
  }

  @override
  Future<String> signTransaction(SessionStatus session) async {
    final sender = Address.fromAlgorandAddress(address: session.accounts[0]);

    // Fetch the suggested transaction params
    final params = await algorand.getSuggestedTransactionParams();

    // Build the transaction
    final tx = await (PaymentTransactionBuilder()
          ..sender = sender
          ..noteText = 'Signed with WalletConnect'
          ..amount = Algo.toMicroAlgos(0.0001)
          ..receiver = sender
          ..suggestedParams = params)
        .build();

    // Sign the transaction
    final signedBytes = await provider.signTransaction(
      tx.toBytes(),
      params: {
        'message': 'Optional description message',
      },
    );

    // Broadcast the transaction
    final txId = await algorand.sendRawTransactions(
      signedBytes,
      waitForConfirmation: true,
    );

    // Kill the session
    connector.killSession();

    return txId;
  }

  @override
  Future<String> sendTransactionWC(transaction) async {
    // TODO: implement signTransactions
    throw UnimplementedError();
  }

  @override
  getCredentials() async {
    // TODO: implement signTransactions
    throw UnimplementedError();
  }

  @override
  getPublicAddress(SessionStatus session) async {
    // TODO: implement signTransactions
    throw UnimplementedError();
  }

  @override
  Future<String> signTransactions(SessionStatus session) async {
    final sender = Address.fromAlgorandAddress(address: session.accounts[0]);

    // Fetch the suggested transaction params
    final params = await algorand.getSuggestedTransactionParams();

    // Build the transaction
    final tx1 = await (PaymentTransactionBuilder()
          ..sender = sender
          ..noteText = 'Signed with WalletConnect - 1'
          ..amount = Algo.toMicroAlgos(0.0001)
          ..receiver = sender
          ..suggestedParams = params)
        .build();

    final tx2 = await (PaymentTransactionBuilder()
          ..sender = sender
          ..noteText = 'Signed with WalletConnect - 2'
          ..amount = Algo.toMicroAlgos(0.0002)
          ..receiver = sender
          ..suggestedParams = params)
        .build();

    AtomicTransfer.group([tx1, tx2]);

    // Sign the transaction
    final signedBytes = await provider.signTransactions(
      [tx1.toBytes(), tx2.toBytes()],
      params: {
        'message': 'Optional description message',
      },
    );

    // Broadcast the transaction
    final txId = await algorand.sendRawTransactions(
      signedBytes,
      waitForConfirmation: true,
    );

    // Kill the session
    connector.killSession();

    return txId;
  }
}
