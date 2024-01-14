import 'dart:async';
import 'dart:typed_data';
import 'package:dodao/wallet/model_view/wallet_model.dart';
import 'package:web3dart/crypto.dart';
import 'package:webthree/webthree.dart';
import 'package:walletconnect_flutter_v2/walletconnect_flutter_v2.dart';
import '../model_view/wc_model.dart';

class WalletConnectEthereumCredentialsV2 extends CustomTransactionSender {
  final WalletModel walletModel;
  final WCModelView wcModelView;
  final Web3App wcClient;
  final SessionData session;
  WalletConnectEthereumCredentialsV2({required this.wcClient, required this.session, required this.walletModel, required this.wcModelView});

  @override
  Future<String> sendTransaction(Transaction transaction) async {

    // int chainId = int.parse(NamespaceUtils.getChainFromAccount(
    //   session.namespaces.values.first.accounts.last,
    // ).split(":").last);
    // print('WalletConnectEthereumCredentialsV2: ${session.namespaces.values.first} ');
    // print('WalletConnectEthereumCredentialsV2: $chainId ');
    // int chainId = this.session.namespaces.
    // final from = await extractAddress();
    final from = walletModel.state.walletAddress;
    final signResponse = await wcClient.request(
      topic: session.topic,
      chainId: 'eip155:${wcModelView.state.selectedChainIdOnApp}',
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
