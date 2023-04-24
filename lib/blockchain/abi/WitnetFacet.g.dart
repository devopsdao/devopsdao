// Generated code, do not modify. Run `build_runner build` to re-generate!
// @dart=2.12
// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:webthree/webthree.dart' as _i1;
import 'dart:typed_data' as _i2;

final _contractAbi = _i1.ContractAbi.fromJson(
  '[{"inputs":[{"internalType":"contract WitnetRequestBoard","name":"_witnetRequestBoard","type":"address"},{"internalType":"contract WitnetRequestTemplate","name":"_witnetRequestTemplate","type":"address"},{"components":[{"internalType":"uint256","name":"numWitnesses","type":"uint256"},{"internalType":"uint256","name":"minConsensusPercentage","type":"uint256"},{"internalType":"uint256","name":"witnessReward","type":"uint256"},{"internalType":"uint256","name":"witnessCollateral","type":"uint256"},{"internalType":"uint256","name":"minerCommitRevealFee","type":"uint256"}],"internalType":"struct WitnetV2.RadonSLA","name":"_witnetRadonSLA","type":"tuple"}],"stateMutability":"nonpayable","type":"constructor"},{"inputs":[{"internalType":"uint256","name":"index","type":"uint256"},{"internalType":"uint256","name":"range","type":"uint256"}],"name":"IndexOutOfBounds","type":"error"},{"inputs":[{"internalType":"uint256","name":"length","type":"uint256"}],"name":"InvalidLengthEncoding","type":"error"},{"inputs":[{"internalType":"uint256","name":"read","type":"uint256"},{"internalType":"uint256","name":"expected","type":"uint256"}],"name":"UnexpectedMajorType","type":"error"},{"anonymous":false,"inputs":[{"indexed":false,"internalType":"bytes32","name":"hash","type":"bytes32"}],"name":"NewRadonRequestHash","type":"event"},{"inputs":[{"internalType":"address","name":"taskAddress","type":"address"}],"name":"checkResultAvailability","outputs":[{"internalType":"bool","name":"","type":"bool"}],"stateMutability":"view","type":"function"},{"inputs":[{"internalType":"address","name":"taskAddress","type":"address"}],"name":"getLastResult","outputs":[{"components":[{"internalType":"bool","name":"failed","type":"bool"},{"internalType":"bool","name":"pendingMerge","type":"bool"},{"internalType":"string","name":"status","type":"string"}],"internalType":"struct LibWitnetFacet.Result","name":"_result","type":"tuple"}],"stateMutability":"view","type":"function"},{"inputs":[{"internalType":"address","name":"taskAddress","type":"address"}],"name":"getLastWitnetQuery","outputs":[{"components":[{"components":[{"internalType":"address","name":"addr","type":"address"},{"internalType":"bytes32","name":"slaHash","type":"bytes32"},{"internalType":"bytes32","name":"radHash","type":"bytes32"},{"internalType":"uint256","name":"gasprice","type":"uint256"},{"internalType":"uint256","name":"reward","type":"uint256"}],"internalType":"struct Witnet.Request","name":"request","type":"tuple"},{"components":[{"internalType":"address","name":"reporter","type":"address"},{"internalType":"uint256","name":"timestamp","type":"uint256"},{"internalType":"bytes32","name":"drTxHash","type":"bytes32"},{"internalType":"bytes","name":"cborBytes","type":"bytes"}],"internalType":"struct Witnet.Response","name":"response","type":"tuple"},{"internalType":"address","name":"from","type":"address"}],"internalType":"struct Witnet.Query","name":"","type":"tuple"}],"stateMutability":"view","type":"function"},{"inputs":[{"internalType":"address","name":"taskAddress","type":"address"}],"name":"getLastWitnetResult","outputs":[{"components":[{"internalType":"bool","name":"success","type":"bool"},{"components":[{"components":[{"internalType":"bytes","name":"data","type":"bytes"},{"internalType":"uint256","name":"cursor","type":"uint256"}],"internalType":"struct WitnetBuffer.Buffer","name":"buffer","type":"tuple"},{"internalType":"uint8","name":"initialByte","type":"uint8"},{"internalType":"uint8","name":"majorType","type":"uint8"},{"internalType":"uint8","name":"additionalInformation","type":"uint8"},{"internalType":"uint64","name":"len","type":"uint64"},{"internalType":"uint64","name":"tag","type":"uint64"}],"internalType":"struct WitnetCBOR.CBOR","name":"value","type":"tuple"}],"internalType":"struct Witnet.Result","name":"","type":"tuple"}],"stateMutability":"view","type":"function"},{"inputs":[{"internalType":"address","name":"taskAddress","type":"address"},{"internalType":"bytes32","name":"_radHash","type":"bytes32"}],"name":"postRequest","outputs":[{"internalType":"uint256","name":"_queryId","type":"uint256"}],"stateMutability":"payable","type":"function"},{"inputs":[{"internalType":"address","name":"taskAddress","type":"address"}],"name":"postRequest","outputs":[{"internalType":"uint256","name":"_queryId","type":"uint256"}],"stateMutability":"payable","type":"function"},{"inputs":[{"internalType":"address","name":"taskAddress","type":"address"},{"components":[{"internalType":"string","name":"subpath","type":"string"},{"internalType":"string","name":"title","type":"string"}],"internalType":"struct LibWitnetFacet.Args","name":"_args","type":"tuple"}],"name":"postRequestTest","outputs":[{"internalType":"uint256","name":"_queryId","type":"uint256"}],"stateMutability":"payable","type":"function"},{"inputs":[{"internalType":"bytes32","name":"slaHash","type":"bytes32"}],"name":"updateRadonSLA","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[],"name":"witnet","outputs":[{"internalType":"contract WitnetRequestBoard","name":"","type":"address"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"witnetRadonSLA","outputs":[{"components":[{"internalType":"uint256","name":"numWitnesses","type":"uint256"},{"internalType":"uint256","name":"minConsensusPercentage","type":"uint256"},{"internalType":"uint256","name":"witnessReward","type":"uint256"},{"internalType":"uint256","name":"witnessCollateral","type":"uint256"},{"internalType":"uint256","name":"minerCommitRevealFee","type":"uint256"}],"internalType":"struct WitnetV2.RadonSLA","name":"","type":"tuple"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"witnetRequestTemplate","outputs":[{"internalType":"contract WitnetRequestTemplate","name":"","type":"address"}],"stateMutability":"view","type":"function"}]',
  'WitnetFacet',
);

class WitnetFacet extends _i1.GeneratedContract {
  WitnetFacet({
    required _i1.EthereumAddress address,
    required _i1.Web3Client client,
    int? chainId,
  }) : super(
          _i1.DeployedContract(
            _contractAbi,
            address,
          ),
          client,
          chainId,
        );

  /// The optional [atBlock] parameter can be used to view historical data. When
  /// set, the function will be evaluated in the specified block. By default, the
  /// latest on-chain block will be used.
  Future<bool> checkResultAvailability(
    _i1.EthereumAddress taskAddress, {
    _i1.BlockNum? atBlock,
    _i1.EthereumAddress? sender,
  }) async {
    final function = self.abi.functions[1];
    assert(checkSignature(function, '6fe4caca'));
    final params = [taskAddress];
    final response = await read(
      sender,
      function,
      params,
      atBlock,
    );
    return (response[0] as bool);
  }

  /// The optional [atBlock] parameter can be used to view historical data. When
  /// set, the function will be evaluated in the specified block. By default, the
  /// latest on-chain block will be used.
  Future<dynamic> getLastResult(
    _i1.EthereumAddress taskAddress, {
    _i1.BlockNum? atBlock,
    _i1.EthereumAddress? sender,
  }) async {
    final function = self.abi.functions[2];
    assert(checkSignature(function, '0546aa16'));
    final params = [taskAddress];
    final response = await read(
      sender,
      function,
      params,
      atBlock,
    );
    return (response[0] as dynamic);
  }

  /// The optional [atBlock] parameter can be used to view historical data. When
  /// set, the function will be evaluated in the specified block. By default, the
  /// latest on-chain block will be used.
  Future<dynamic> getLastWitnetQuery(
    _i1.EthereumAddress taskAddress, {
    _i1.BlockNum? atBlock,
    _i1.EthereumAddress? sender,
  }) async {
    final function = self.abi.functions[3];
    assert(checkSignature(function, 'f9f0d3c7'));
    final params = [taskAddress];
    final response = await read(
      sender,
      function,
      params,
      atBlock,
    );
    return (response[0] as dynamic);
  }

  /// The optional [atBlock] parameter can be used to view historical data. When
  /// set, the function will be evaluated in the specified block. By default, the
  /// latest on-chain block will be used.
  Future<dynamic> getLastWitnetResult(
    _i1.EthereumAddress taskAddress, {
    _i1.BlockNum? atBlock,
    _i1.EthereumAddress? sender,
  }) async {
    final function = self.abi.functions[4];
    assert(checkSignature(function, 'a6d5e5bf'));
    final params = [taskAddress];
    final response = await read(
      sender,
      function,
      params,
      atBlock,
    );
    return (response[0] as dynamic);
  }

  /// The optional [transaction] parameter can be used to override parameters
  /// like the gas price, nonce and max gas. The `data` and `to` fields will be
  /// set by the contract.
  Future<String> postRequest(
    _i1.EthereumAddress taskAddress,
    _i2.Uint8List _radHash, {
    required _i1.Credentials credentials,
    _i1.Transaction? transaction,
  }) async {
    final function = self.abi.functions[5];
    assert(checkSignature(function, '05743234'));
    final params = [
      taskAddress,
      _radHash,
    ];
    return write(
      credentials,
      transaction,
      function,
      params,
    );
  }

  /// The optional [transaction] parameter can be used to override parameters
  /// like the gas price, nonce and max gas. The `data` and `to` fields will be
  /// set by the contract.
  Future<String> postRequest$2(
    _i1.EthereumAddress taskAddress, {
    required _i1.Credentials credentials,
    _i1.Transaction? transaction,
  }) async {
    final function = self.abi.functions[6];
    assert(checkSignature(function, 'b281a7bd'));
    final params = [taskAddress];
    return write(
      credentials,
      transaction,
      function,
      params,
    );
  }

  /// The optional [transaction] parameter can be used to override parameters
  /// like the gas price, nonce and max gas. The `data` and `to` fields will be
  /// set by the contract.
  Future<String> postRequestTest(
    _i1.EthereumAddress taskAddress,
    dynamic _args, {
    required _i1.Credentials credentials,
    _i1.Transaction? transaction,
  }) async {
    final function = self.abi.functions[7];
    assert(checkSignature(function, '2587e269'));
    final params = [
      taskAddress,
      _args,
    ];
    return write(
      credentials,
      transaction,
      function,
      params,
    );
  }

  /// The optional [transaction] parameter can be used to override parameters
  /// like the gas price, nonce and max gas. The `data` and `to` fields will be
  /// set by the contract.
  Future<String> updateRadonSLA(
    _i2.Uint8List slaHash, {
    required _i1.Credentials credentials,
    _i1.Transaction? transaction,
  }) async {
    final function = self.abi.functions[8];
    assert(checkSignature(function, '664801df'));
    final params = [slaHash];
    return write(
      credentials,
      transaction,
      function,
      params,
    );
  }

  /// The optional [atBlock] parameter can be used to view historical data. When
  /// set, the function will be evaluated in the specified block. By default, the
  /// latest on-chain block will be used.
  Future<_i1.EthereumAddress> witnet({
    _i1.BlockNum? atBlock,
    _i1.EthereumAddress? sender,
  }) async {
    final function = self.abi.functions[9];
    assert(checkSignature(function, '46d1d21a'));
    final params = [];
    final response = await read(
      sender,
      function,
      params,
      atBlock,
    );
    return (response[0] as _i1.EthereumAddress);
  }

  /// The optional [atBlock] parameter can be used to view historical data. When
  /// set, the function will be evaluated in the specified block. By default, the
  /// latest on-chain block will be used.
  Future<dynamic> witnetRadonSLA({
    _i1.BlockNum? atBlock,
    _i1.EthereumAddress? sender,
  }) async {
    final function = self.abi.functions[10];
    assert(checkSignature(function, '0894fc02'));
    final params = [];
    final response = await read(
      sender,
      function,
      params,
      atBlock,
    );
    return (response[0] as dynamic);
  }

  /// The optional [atBlock] parameter can be used to view historical data. When
  /// set, the function will be evaluated in the specified block. By default, the
  /// latest on-chain block will be used.
  Future<_i1.EthereumAddress> witnetRequestTemplate({
    _i1.BlockNum? atBlock,
    _i1.EthereumAddress? sender,
  }) async {
    final function = self.abi.functions[11];
    assert(checkSignature(function, '4db820d5'));
    final params = [];
    final response = await read(
      sender,
      function,
      params,
      atBlock,
    );
    return (response[0] as _i1.EthereumAddress);
  }

  /// Returns a live stream of all NewRadonRequestHash events emitted by this contract.
  Stream<NewRadonRequestHash> newRadonRequestHashEvents({
    _i1.BlockNum? fromBlock,
    _i1.BlockNum? toBlock,
  }) {
    final event = self.event('NewRadonRequestHash');
    final filter = _i1.FilterOptions.events(
      contract: self,
      event: event,
      fromBlock: fromBlock,
      toBlock: toBlock,
    );
    return client.events(filter).map((_i1.FilterEvent result) {
      final decoded = event.decodeResults(
        result.topics!,
        result.data!,
      );
      return NewRadonRequestHash(decoded);
    });
  }
}

class NewRadonRequestHash {
  NewRadonRequestHash(List<dynamic> response)
      : hash = (response[0] as _i2.Uint8List);

  final _i2.Uint8List hash;
}
