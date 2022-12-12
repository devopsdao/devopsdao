// Generated code, do not modify. Run `build_runner build` to re-generate!
// @dart=2.12
// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:webthree/webthree.dart' as _i1;
import 'dart:typed_data' as _i2;

final _contractAbi = _i1.ContractAbi.fromJson(
  '[{"inputs":[{"internalType":"address","name":"gateway_","type":"address"},{"internalType":"address","name":"gasReceiver_","type":"address"}],"stateMutability":"nonpayable","type":"constructor"},{"inputs":[],"name":"InvalidAddress","type":"error"},{"inputs":[],"name":"NotApprovedByGateway","type":"error"},{"anonymous":false,"inputs":[{"indexed":false,"internalType":"string","name":"logname","type":"string"}],"name":"LogSimple","type":"event"},{"anonymous":false,"inputs":[{"indexed":false,"internalType":"string","name":"logname","type":"string"},{"indexed":false,"internalType":"string","name":"sourceChain","type":"string"},{"indexed":false,"internalType":"string","name":"sourceAddress","type":"string"},{"indexed":false,"internalType":"bytes","name":"payload","type":"bytes"}],"name":"Logs","type":"event"},{"anonymous":false,"inputs":[{"indexed":false,"internalType":"string","name":"_nanoId","type":"string"},{"indexed":false,"internalType":"string","name":"_taskType","type":"string"},{"indexed":false,"internalType":"string","name":"_title","type":"string"},{"indexed":false,"internalType":"string","name":"_description","type":"string"},{"indexed":false,"internalType":"string","name":"_symbol","type":"string"},{"indexed":false,"internalType":"uint256","name":"_amount","type":"uint256"}],"name":"TaskContractCreating","type":"event"},{"inputs":[{"internalType":"string","name":"_nanoId","type":"string"},{"internalType":"string","name":"_taskType","type":"string"},{"internalType":"string","name":"_title","type":"string"},{"internalType":"string","name":"_description","type":"string"},{"internalType":"string","name":"_symbol","type":"string"},{"internalType":"uint256","name":"_amount","type":"uint256"}],"name":"createTaskContract","outputs":[],"stateMutability":"payable","type":"function"},{"inputs":[{"internalType":"bytes32","name":"commandId","type":"bytes32"},{"internalType":"string","name":"sourceChain","type":"string"},{"internalType":"string","name":"sourceAddress","type":"string"},{"internalType":"bytes","name":"payload","type":"bytes"}],"name":"execute","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[{"internalType":"bytes32","name":"commandId","type":"bytes32"},{"internalType":"string","name":"sourceChain","type":"string"},{"internalType":"string","name":"sourceAddress","type":"string"},{"internalType":"bytes","name":"payload","type":"bytes"},{"internalType":"string","name":"tokenSymbol","type":"string"},{"internalType":"uint256","name":"amount","type":"uint256"}],"name":"executeWithToken","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[],"name":"gasReceiver","outputs":[{"internalType":"contract IAxelarGasService","name":"","type":"address"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"gateway","outputs":[{"internalType":"contract IAxelarGateway","name":"","type":"address"}],"stateMutability":"view","type":"function"}]',
  'AxelarGMP',
);

class AxelarGMP extends _i1.GeneratedContract {
  AxelarGMP({
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
  Future<String> createTaskContract(
    String _nanoId,
    String _taskType,
    String _title,
    String _description,
    String _symbol,
    BigInt _amount, {
    required _i1.Credentials credentials,
    _i1.Transaction? transaction,
  }) async {
    final function = self.abi.functions[1];
    assert(checkSignature(function, 'd06d6da4'));
    final params = [
      _nanoId,
      _taskType,
      _title,
      _description,
      _symbol,
      _amount,
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
  Future<String> execute(
    _i2.Uint8List commandId,
    String sourceChain,
    String sourceAddress,
    _i2.Uint8List payload, {
    required _i1.Credentials credentials,
    _i1.Transaction? transaction,
  }) async {
    final function = self.abi.functions[2];
    assert(checkSignature(function, '49160658'));
    final params = [
      commandId,
      sourceChain,
      sourceAddress,
      payload,
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
  Future<String> executeWithToken(
    _i2.Uint8List commandId,
    String sourceChain,
    String sourceAddress,
    _i2.Uint8List payload,
    String tokenSymbol,
    BigInt amount, {
    required _i1.Credentials credentials,
    _i1.Transaction? transaction,
  }) async {
    final function = self.abi.functions[3];
    assert(checkSignature(function, '1a98b2e0'));
    final params = [
      commandId,
      sourceChain,
      sourceAddress,
      payload,
      tokenSymbol,
      amount,
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
  Future<_i1.EthereumAddress> gasReceiver({
    _i1.BlockNum? atBlock,
    _i1.EthereumAddress? sender,
  }) async {
    final function = self.abi.functions[4];
    assert(checkSignature(function, '80d14b4a'));
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
  Future<_i1.EthereumAddress> gateway({
    _i1.BlockNum? atBlock,
    _i1.EthereumAddress? sender,
  }) async {
    final function = self.abi.functions[5];
    assert(checkSignature(function, '116191b6'));
    final params = [];
    final response = await read(
      sender,
      function,
      params,
      atBlock,
    );
    return (response[0] as _i1.EthereumAddress);
  }

  /// Returns a live stream of all LogSimple events emitted by this contract.
  Stream<LogSimple> logSimpleEvents({
    _i1.BlockNum? fromBlock,
    _i1.BlockNum? toBlock,
  }) {
    final event = self.event('LogSimple');
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
      return LogSimple(decoded);
    });
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

  /// Returns a live stream of all TaskContractCreating events emitted by this contract.
  Stream<TaskContractCreating> taskContractCreatingEvents({
    _i1.BlockNum? fromBlock,
    _i1.BlockNum? toBlock,
  }) {
    final event = self.event('TaskContractCreating');
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
      return TaskContractCreating(decoded);
    });
  }
}

class LogSimple {
  LogSimple(List<dynamic> response) : logname = (response[0] as String);

  final String logname;
}

class Logs {
  Logs(List<dynamic> response)
      : logname = (response[0] as String),
        sourceChain = (response[1] as String),
        sourceAddress = (response[2] as String),
        payload = (response[3] as _i2.Uint8List);

  final String logname;

  final String sourceChain;

  final String sourceAddress;

  final _i2.Uint8List payload;
}

class TaskContractCreating {
  TaskContractCreating(List<dynamic> response)
      : nanoId = (response[0] as String),
        taskType = (response[1] as String),
        title = (response[2] as String),
        description = (response[3] as String),
        symbol = (response[4] as String),
        amount = (response[5] as BigInt);

  final String nanoId;

  final String taskType;

  final String title;

  final String description;

  final String symbol;

  final BigInt amount;
}
