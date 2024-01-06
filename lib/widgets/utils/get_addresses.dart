import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:webthree/credentials.dart';

import '../../wallet/services/wallet_service.dart';


class GetAddresses {
  static EthereumAddress zeroAddress = EthereumAddress.fromHex('0x0000000000000000000000000000000000000000');

  int chainIdAxelar = 80001;
  int chainIdHyperlane = 80001;
  int chainIdLayerzero = 80001;
  int chainIdWormhole = 80001;

  Future<EthereumAddress> requestContractAddress(chainId) async {
    String addressesFile = await rootBundle.loadString('lib/blockchain/abi/addresses.json');
    var addresses = jsonDecode(addressesFile);
    return EthereumAddress.fromHex(addresses['contracts'][chainId.toString()]["Diamond"]);
  }
  Future<EthereumAddress> requestAxelarAddress() async {
    String addressesFileAxelar = await rootBundle.loadString('lib/blockchain/abi/axelar-addresses.json');
    var addressesAxelar = jsonDecode(addressesFileAxelar);
    return EthereumAddress.fromHex(addressesAxelar['contracts'][chainIdAxelar.toString()]["Diamond"]);
  }
  Future<EthereumAddress> requestHyperlaneAddress() async {
    String addressesFileHyperlane = await rootBundle.loadString('lib/blockchain/abi/hyperlane-addresses.json');
    var addressesHyperlane = jsonDecode(addressesFileHyperlane);
    return EthereumAddress.fromHex(addressesHyperlane['contracts'][chainIdHyperlane.toString()]["Diamond"]);
  }
  Future<EthereumAddress> requestLayerzeroAddress() async {
    String addressesFileLayerzero = await rootBundle.loadString('lib/blockchain/abi/layerzero-addresses.json');
    var addressesLayerzero = jsonDecode(addressesFileLayerzero);
    return EthereumAddress.fromHex(addressesLayerzero['contracts'][chainIdLayerzero.toString()]["Diamond"]);
  }
  Future<EthereumAddress> requestWormholeAddress() async {
    String addressesFileWormhole = await rootBundle.loadString('lib/blockchain/abi/wormhole-addresses.json');
    var addressesWormhole = jsonDecode(addressesFileWormhole);
    return EthereumAddress.fromHex(addressesWormhole['contracts'][chainIdWormhole.toString()]["Diamond"]);
  }
}