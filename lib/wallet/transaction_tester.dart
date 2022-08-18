import 'package:walletconnect_dart/walletconnect_dart.dart';
import './ethereum_transaction_tester.dart';
import 'package:web3dart/web3dart.dart';

abstract class TransactionTester {
  TransactionTester({required this.connector});

  final WalletConnect connector;
  late final EthereumAddress? publicAddress;

  Future<String> signTransaction(SessionStatus session);

  Future<String> sendTransactionWC(transaction);

  Future<WalletConnectEthereumCredentials> getCredentials();

  Future<EthereumAddress> getPublicAddress(SessionStatus session);

  Future<String> signTransactions(SessionStatus session);

  Future<SessionStatus> connect({OnDisplayUriCallback? onDisplayUri});

  Future<void> disconnect();
}
