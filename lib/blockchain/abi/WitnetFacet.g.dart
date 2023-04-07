// Generated code, do not modify. Run `build_runner build` to re-generate!
// @dart=2.12
// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:webthree/webthree.dart' as _i1;
import 'dart:typed_data' as _i2;

final _contractAbi = _i1.ContractAbi.fromJson(
  '[{"inputs":[{"internalType":"address","name":"_witnetRequestBoard","type":"address"},{"internalType":"address","name":"_witnetRequestFactory","type":"address"}],"stateMutability":"nonpayable","type":"constructor"},{"anonymous":false,"inputs":[{"indexed":false,"internalType":"address","name":"contractAdr","type":"address"},{"indexed":false,"internalType":"string","name":"message","type":"string"}],"name":"Logs","type":"event"},{"inputs":[{"internalType":"bytes32","name":"httpGetValuesArray","type":"bytes32"},{"internalType":"bytes32","name":"reducerModeNoFilters","type":"bytes32"}],"name":"buildRequestTemplate","outputs":[{"internalType":"contract WitnetRequestTemplate","name":"valuesArrayRequestTemplate","type":"address"}],"stateMutability":"nonpayable","type":"function"},{"inputs":[{"internalType":"address","name":"taskAddress","type":"address"}],"name":"createWitnetRequest","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[],"name":"witnet","outputs":[{"internalType":"contract WitnetRequestBoard","name":"","type":"address"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"witnetRequestFactory","outputs":[{"internalType":"address","name":"","type":"address"}],"stateMutability":"view","type":"function"}]',
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

  /// The optional [transaction] parameter can be used to override parameters
  /// like the gas price, nonce and max gas. The `data` and `to` fields will be
  /// set by the contract.
  Future<String> buildRequestTemplate(
    _i2.Uint8List httpGetValuesArray,
    _i2.Uint8List reducerModeNoFilters, {
    required _i1.Credentials credentials,
    _i1.Transaction? transaction,
  }) async {
    final function = self.abi.functions[1];
    assert(checkSignature(function, 'aa5f7d4e'));
    final params = [
      httpGetValuesArray,
      reducerModeNoFilters,
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
  Future<String> createWitnetRequest(
    _i1.EthereumAddress taskAddress, {
    required _i1.Credentials credentials,
    _i1.Transaction? transaction,
  }) async {
    final function = self.abi.functions[2];
    assert(checkSignature(function, '0e627947'));
    final params = [taskAddress];
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
    final function = self.abi.functions[3];
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
  Future<_i1.EthereumAddress> witnetRequestFactory({
    _i1.BlockNum? atBlock,
    _i1.EthereumAddress? sender,
  }) async {
    final function = self.abi.functions[4];
    assert(checkSignature(function, 'f9580227'));
    final params = [];
    final response = await read(
      sender,
      function,
      params,
      atBlock,
    );
    return (response[0] as _i1.EthereumAddress);
  }

  /// Returns a live stream of all Logs events emitted by this contract.
  Stream<Logs> logsEvents({
    _i1.BlockNum? fromBlock,
    _i1.BlockNum? toBlock,
  }) {
    final event = self.event('Logs');
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
      return Logs(decoded);
    });
  }
}

class Logs {
  Logs(List<dynamic> response)
      : contractAdr = (response[0] as _i1.EthereumAddress),
        message = (response[1] as String);

  final _i1.EthereumAddress contractAdr;

  final String message;
}
