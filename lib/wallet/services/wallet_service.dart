import 'dart:async';

import 'package:dodao/blockchain/chain_presets/chains_presets.dart';
import 'package:webthree/credentials.dart';
import '../../blockchain/task_services.dart';
import '../model_view/wallet_model.dart';

// get -> read ->
// set -> write ->
// on -> init ->
// ... -> check (logic with bool return(not bool stored data))

class WalletService {
  static bool walletConnected = false;
  static bool allowedChainId = false;
  static WalletSelected walletSelected = WalletSelected.none;
  static EthereumAddress? walletAddress;
  // static const int defaultNetwork = 855456;
  static const int defaultNetwork = 855456;
  static int chainId = defaultNetwork;
  // static int chainId = ChainPresets.chains.keys.firstWhere(
  //         (k) => ChainPresets.chains[k]?.chainName == defaultNetwork);

  // WalletService() {
  //   walletConnected = false;
  //   allowedChainId = false;
  //   walletSelected = WalletSelected.none;
  //   // chainId = ChainPresets.chains.keys.firstWhere(
  //   //         (k) => ChainPresets.chains[k]?.chainName == defaultNetwork);
  // }

  /// check:
  bool checkContainedChainInAllowedList(int id) {
    return ChainPresets.chains.keys.contains(id);
  }

  bool checkAllowedChainId({int id = 0}) {
    int chainIdToCheck;
    id == 0 ? chainIdToCheck = chainId : chainIdToCheck = id;
    return checkContainedChainInAllowedList(chainIdToCheck);
  }

  /// write:
  void writeChainId(int chain) {
    // a temporary solution until we translate all the code to the new standard:
    allowedChainId = checkContainedChainInAllowedList(chain);
    chainId = chain;
  }

  void writeWalletAddress(EthereumAddress? address) {
    walletAddress = address;
  }

  void writeAllowedChainId(bool state) {
    allowedChainId = state;
  }

  void writeWalletConnected(bool state) {
    walletConnected = state;
  }

  void writeWalletSelected(WalletSelected state) {
    walletSelected = state;
  }

  Future<void> writeDefaultChainId() async {
    writeChainId(defaultNetwork);
  }

  int readChainIdByName(String name) {
    return ChainPresets.chains.keys.firstWhere((k) => ChainPresets.chains[k]?.chainName == name, orElse: () => 0);
  }

  String readChainNameById(int id) {
    return ChainPresets.chains[id]!.chainName;
  }
}
