import 'dart:async';

import 'package:webthree/credentials.dart';
import 'package:webthree/webthree.dart';
import '../../../blockchain/classes.dart';

// get -> read ->
// set -> write ->
// on -> init ->
// ... -> check (logic with bool return(not bool stored data))


class ValueInputService {
  //Utils:

  List<TokenItem> _tags = [];
  List<TokenItem> get tags => _tags;
  Map<String, Map<String, BigInt>> initialEmptyBalance = {};
  static const String tokenContractKeyName = 'dodao';


  Future<void> initRequestBalances(int chainId, tasksServices) async {

  }

}


