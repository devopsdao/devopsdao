import 'dart:async';
import 'dart:math';
import 'dart:typed_data';

import 'package:convert/convert.dart';
import 'package:dodao/wallet/services/wallet_service.dart';
import 'package:webthree/credentials.dart';
import 'package:webthree/webthree.dart';
import '../../../blockchain/abi/IERC1155.g.dart';
import '../../../blockchain/abi/IERC165.g.dart';
import '../../../blockchain/abi/IERC20.g.dart';
import '../../../blockchain/abi/IERC721.g.dart';
import '../../../blockchain/abi/TokenDataFacet.g.dart';
import '../../../blockchain/classes.dart';
import '../../blockchain/chain_presets/get_addresses.dart';

// get -> read ->
// set -> write ->
// on -> init ->
// ... -> check (logic with bool return(not bool stored data))

class StatisticsService {
  //Utils:
  final _getAddresses = GetAddresses();

  List<TokenItem> _tags = [];
  List<TokenItem> get tags => _tags;
  Map<String, Map<String, BigInt>> initialEmptyBalance = {};
  static const String tokenContractKeyName = 'dodao';

  EthereumAddress zeroAddress = GetAddresses.zeroAddress;
  static final StreamController<List<TokenItem>> _controller = StreamController<List<TokenItem>>.broadcast();
  Stream<List<TokenItem>> get statisticsTokenItems => _controller.stream.asBroadcastStream();

  Future<void> initRequestBalances(int chainId, tasksServices) async {

  }

}
