import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:walletconnect_flutter_v2/walletconnect_flutter_v2.dart';
import 'package:webthree/credentials.dart';
import 'package:logging/logging.dart';

import '../blockchain/chain_presets/chains_presets.dart';
import '../blockchain/chain_presets/chains_presets.dart';


class WalletService {
  // Service and state storage (temporary)
  static bool walletConnected = false;
  static bool allowedChainId = false;
  Future<void> initialize() async {
    walletConnected = false;
    allowedChainId = false;
  }

  void chainIdService(bool state) {
    allowedChainId = state;

  }

  void walletConnectedService(bool state) {
    walletConnected = state;
  }
}

class WalletModelState {
  final bool walletConnected;
  final bool allowedChainId;
  WalletModelState({
    required this.walletConnected,
    required this.allowedChainId,
  });
}


class WalletModelProvider extends ChangeNotifier {
  //////////// *******New State Model******** //////////////////
  final _walletService = WalletService();

  void loadValue() async {
    await _walletService.initialize();
    _updateState();
  }

  WalletModelProvider() {
    loadValue();
  }

  var _state = WalletModelState(
    allowedChainId: false,
    walletConnected: false,
  );
  WalletModelState get state => _state;

  Future<void> setAllowedChainId(bool state) async {
    _walletService.chainIdService(state);
    _updateState();
  }

  Future<void> setWalletConnected(bool state) async {
    _walletService.walletConnectedService(state);
    _updateState();
  }

  void _updateState() {
    final allowedChainId = WalletService.allowedChainId;
    final walletConnected = WalletService.walletConnected;
    _state = WalletModelState(
        walletConnected: walletConnected,
        allowedChainId: allowedChainId,
    );
    notifyListeners();
  }
  //////////// *******New State Model END******** //////////////////
}
