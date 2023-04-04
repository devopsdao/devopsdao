// Generated code, do not modify. Run `build_runner build` to re-generate!
// @dart=2.12
// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:webthree/webthree.dart' as _i1;
import 'dart:typed_data' as _i2;

final _contractAbi = _i1.ContractAbi.fromJson(
  '[{"inputs":[{"internalType":"contract WitnetRequestBoard","name":"_witnetRequestBoard","type":"address"}],"stateMutability":"nonpayable","type":"constructor"},{"inputs":[{"internalType":"contract WitnetRequestFactory","name":"factory","type":"address"},{"internalType":"bytes32","name":"httpGetValuesArray","type":"bytes32"},{"internalType":"bytes32","name":"reducerModeNoFilters","type":"bytes32"}],"name":"buildRequestTemplate","outputs":[{"internalType":"contract WitnetRequestTemplate","name":"valuesArrayRequestTemplate","type":"address"}],"stateMutability":"nonpayable","type":"function"},{"inputs":[],"name":"witnet","outputs":[{"internalType":"contract WitnetRequestBoard","name":"","type":"address"}],"stateMutability":"view","type":"function"}]',
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
    _i1.EthereumAddress factory,
    _i2.Uint8List httpGetValuesArray,
    _i2.Uint8List reducerModeNoFilters, {
    required _i1.Credentials credentials,
    _i1.Transaction? transaction,
  }) async {
    final function = self.abi.functions[1];
    assert(checkSignature(function, '07009d0d'));
    final params = [
      factory,
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

  /// The optional [atBlock] parameter can be used to view historical data. When
  /// set, the function will be evaluated in the specified block. By default, the
  /// latest on-chain block will be used.
  Future<_i1.EthereumAddress> witnet({
    _i1.BlockNum? atBlock,
    _i1.EthereumAddress? sender,
  }) async {
    final function = self.abi.functions[2];
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
}
