import 'package:walletconnect_dart/walletconnect_dart.dart';
import './ethereum_transaction_tester.dart';
import 'package:webthree/webthree.dart';

abstract class TransactionTester {
  // TransactionTester({required this.connector});

  TransactionTester();

  Future<void> initSession();

  initWalletConnect();

  // final WalletConnect connector;
  late final EthereumAddress? publicAddress;

  Future<String> signTransaction(SessionStatus session);

  Future<String> sendTransactionWC(transaction);

  Future<WalletConnectEthereumCredentials> getCredentials();

  Future<EthereumAddress> getPublicAddress(SessionStatus session);

  Future<String> signTransactions(SessionStatus session);

  Future<SessionStatus> connect({OnDisplayUriCallback? onDisplayUri});

  // Future<SessionStatus> updateSession(SessionStatus? session);

  Future createSession({OnDisplayUriCallback? onDisplayUri});

  Future<void> disconnect();

  Future<void> removeSession();
}
