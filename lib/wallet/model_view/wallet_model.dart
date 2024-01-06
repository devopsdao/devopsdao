import 'dart:async';
import 'package:dodao/blockchain/chain_presets/chains_presets.dart';
import 'package:flutter/cupertino.dart';
import 'package:webthree/credentials.dart';
import 'dart:io';

import '../services/wallet_service.dart';
// model - service:
// get -> read
// set -> write
// on -> init
// ... -> check (logic with bool return(not bool stored data))

enum WalletSelected {
  walletConnect,
  metamask,
  none,
}

class WalletModelState {
  bool walletConnected;
  bool allowedChainId;
  WalletSelected walletSelected;
  EthereumAddress? walletAddress;
  int? chainId;
  int currentWalletPage;

  WalletModelState({
    required this.walletConnected,
    required this.allowedChainId,
    required this.walletSelected,
    required this.walletAddress,
    required this.chainId,
    required this.currentWalletPage,
  });
}

class WalletModel extends ChangeNotifier {
  final _walletService = WalletService();

  var _state = WalletModelState(
    allowedChainId: false,
    walletConnected: false,
    walletSelected: WalletSelected.none,
    walletAddress: null,
    chainId: null,
    currentWalletPage: 0,
  );
  WalletModelState get state => _state;

  void _updateState() {
    final walletConnected = WalletService.walletConnected;
    final allowedChainId = WalletService.allowedChainId;
    final walletSelected = WalletService.walletSelected;
    final walletAddress = WalletService.walletAddress;
    final chainId = WalletService.chainId;
    final page = _state.currentWalletPage;
    _state = WalletModelState(
      walletConnected: walletConnected,
      allowedChainId: allowedChainId,
      walletSelected: walletSelected,
      walletAddress: walletAddress,
      chainId: chainId,
      currentWalletPage: page,
    );
    notifyListeners();
  }

  onPageChanged(int page) async {
    _state.currentWalletPage = page;
    notifyListeners();
  }

  Future<void> onWalletUpdate({
    bool? connectionState,
    WalletSelected? walletType,
    bool? allowedChain,
    EthereumAddress? walletAddress,
    int? chainId,
  }) async {
    if (connectionState != null) {
      _walletService.writeWalletConnected(connectionState);
      _state.walletConnected = connectionState;
    }
    if (walletType != null) {
      _walletService.writeWalletSelected(walletType);
      _state.walletSelected = walletType;
    }
    if (allowedChain != null) {
      _walletService.writeAllowedChainId(allowedChain);
      _state.allowedChainId = allowedChain;
    }
    if (walletAddress != null) {
      _walletService.writeWalletAddress(walletAddress);
      _state.walletAddress = walletAddress;
    }
    if (chainId != null) {
      _walletService.writeChainId(chainId);
      _state.chainId = chainId;
    }
    _updateState();
  }

  Future<void> onWalletReset() async {
    _walletService.writeWalletConnected(false);
    _state.walletConnected = false;
    _walletService.writeWalletSelected(WalletSelected.none);
    _state.walletSelected = WalletSelected.none;
    _walletService.writeAllowedChainId(false);
    _state.allowedChainId = false;
    _walletService.writeWalletAddress(null);
    _state.walletAddress = null;
    _walletService.writeDefaultChainId();
    _state.chainId = WalletService.defaultNetwork;
    _updateState();
  }

  String getNetworkChainName(int id) {
    if (id == 0) {
      return 'unknown';
    } else {
      return ChainPresets.chains[id]!.chainName;
    }
  }

  int getNetworkChainId(String networkName) {
    return _walletService.readChainIdByName(networkName);
  }
  // late String myTest = 'empty';
  // late int myTestInt = 0;
  // void test(String test) {
  //   myTestInt++;
  //   myTest = '$test ${myTestInt.toString()}';
  //   notifyListeners();
  // }
}
