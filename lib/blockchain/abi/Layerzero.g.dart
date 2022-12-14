// Generated code, do not modify. Run `build_runner build` to re-generate!
// @dart=2.12
// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:webthree/webthree.dart' as _i1;
import 'dart:typed_data' as _i2;

final _contractAbi = _i1.ContractAbi.fromJson(
  '[{"inputs":[{"internalType":"address","name":"_endpoint","type":"address"}],"stateMutability":"nonpayable","type":"constructor"},{"anonymous":false,"inputs":[{"indexed":false,"internalType":"string","name":"logname","type":"string"},{"indexed":false,"internalType":"uint16","name":"sourceChain","type":"uint16"},{"indexed":false,"internalType":"bytes","name":"sourceAddress","type":"bytes"},{"indexed":false,"internalType":"uint256","name":"_nonce","type":"uint256"},{"indexed":false,"internalType":"bytes","name":"payload","type":"bytes"}],"name":"Logs","type":"event"},{"anonymous":false,"inputs":[{"indexed":false,"internalType":"uint16","name":"_srcChainId","type":"uint16"},{"indexed":false,"internalType":"address","name":"_from","type":"address"},{"indexed":false,"internalType":"uint16","name":"_count","type":"uint16"},{"indexed":false,"internalType":"bytes","name":"_payload","type":"bytes"}],"name":"ReceiveMsg","type":"event"},{"anonymous":false,"inputs":[{"indexed":false,"internalType":"string","name":"_nanoId","type":"string"},{"indexed":false,"internalType":"string","name":"_taskType","type":"string"},{"indexed":false,"internalType":"string","name":"_title","type":"string"},{"indexed":false,"internalType":"string","name":"_description","type":"string"},{"indexed":false,"internalType":"string","name":"_symbol","type":"string"},{"indexed":false,"internalType":"uint256","name":"_amount","type":"uint256"}],"name":"TaskContractCreating","type":"event"},{"inputs":[{"internalType":"string","name":"_nanoId","type":"string"},{"internalType":"string","name":"_taskType","type":"string"},{"internalType":"string","name":"_title","type":"string"},{"internalType":"string","name":"_description","type":"string"},{"internalType":"string","name":"_symbol","type":"string"},{"internalType":"uint256","name":"_amount","type":"uint256"}],"name":"createTaskContract","outputs":[],"stateMutability":"payable","type":"function"},{"inputs":[],"name":"endpoint","outputs":[{"internalType":"contract ILayerZeroEndpoint","name":"","type":"address"}],"stateMutability":"view","type":"function"},{"inputs":[{"internalType":"uint16","name":"_dstChainId","type":"uint16"},{"internalType":"address","name":"_userApplication","type":"address"},{"internalType":"bytes","name":"_payload","type":"bytes"},{"internalType":"bool","name":"_payInZRO","type":"bool"},{"internalType":"bytes","name":"_adapterParams","type":"bytes"}],"name":"estimateFees","outputs":[{"internalType":"uint256","name":"nativeFee","type":"uint256"},{"internalType":"uint256","name":"zroFee","type":"uint256"}],"stateMutability":"view","type":"function"},{"inputs":[{"internalType":"uint16","name":"_srcChainId","type":"uint16"},{"internalType":"bytes","name":"_from","type":"bytes"},{"internalType":"uint64","name":"_nonce","type":"uint64"},{"internalType":"bytes","name":"_payload","type":"bytes"}],"name":"lzReceive","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[],"name":"message","outputs":[{"internalType":"bytes","name":"","type":"bytes"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"messageCount","outputs":[{"internalType":"uint16","name":"","type":"uint16"}],"stateMutability":"view","type":"function"}]',
  'Layerzero',
);

class Layerzero extends _i1.GeneratedContract {
  Layerzero({
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

  /// The optional [atBlock] parameter can be used to view historical data. When
  /// set, the function will be evaluated in the specified block. By default, the
  /// latest on-chain block will be used.
  Future<_i1.EthereumAddress> endpoint({
    _i1.BlockNum? atBlock,
    _i1.EthereumAddress? sender,
  }) async {
    final function = self.abi.functions[2];
    assert(checkSignature(function, '5e280f11'));
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
  Future<EstimateFees> estimateFees(
    BigInt _dstChainId,
    _i1.EthereumAddress _userApplication,
    _i2.Uint8List _payload,
    bool _payInZRO,
    _i2.Uint8List _adapterParams, {
    _i1.BlockNum? atBlock,
    _i1.EthereumAddress? sender,
  }) async {
    final function = self.abi.functions[3];
    assert(checkSignature(function, '40a7bb10'));
    final params = [
      _dstChainId,
      _userApplication,
      _payload,
      _payInZRO,
      _adapterParams,
    ];
    final response = await read(
      sender,
      function,
      params,
      atBlock,
    );
    return EstimateFees(response);
  }

  /// The optional [transaction] parameter can be used to override parameters
  /// like the gas price, nonce and max gas. The `data` and `to` fields will be
  /// set by the contract.
  Future<String> lzReceive(
    BigInt _srcChainId,
    _i2.Uint8List _from,
    BigInt _nonce,
    _i2.Uint8List _payload, {
    required _i1.Credentials credentials,
    _i1.Transaction? transaction,
  }) async {
    final function = self.abi.functions[4];
    assert(checkSignature(function, '001d3567'));
    final params = [
      _srcChainId,
      _from,
      _nonce,
      _payload,
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
  Future<_i2.Uint8List> message({
    _i1.BlockNum? atBlock,
    _i1.EthereumAddress? sender,
  }) async {
    final function = self.abi.functions[5];
    assert(checkSignature(function, 'e21f37ce'));
    final params = [];
    final response = await read(
      sender,
      function,
      params,
      atBlock,
    );
    return (response[0] as _i2.Uint8List);
  }

  /// The optional [atBlock] parameter can be used to view historical data. When
  /// set, the function will be evaluated in the specified block. By default, the
  /// latest on-chain block will be used.
  Future<BigInt> messageCount({
    _i1.BlockNum? atBlock,
    _i1.EthereumAddress? sender,
  }) async {
    final function = self.abi.functions[6];
    assert(checkSignature(function, '3dbcc8d1'));
    final params = [];
    final response = await read(
      sender,
      function,
      params,
      atBlock,
    );
    return (response[0] as BigInt);
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

  /// Returns a live stream of all ReceiveMsg events emitted by this contract.
  Stream<ReceiveMsg> receiveMsgEvents({
    _i1.BlockNum? fromBlock,
    _i1.BlockNum? toBlock,
  }) {
    final event = self.event('ReceiveMsg');
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
      return ReceiveMsg(decoded);
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

class EstimateFees {
  EstimateFees(List<dynamic> response)
      : nativeFee = (response[0] as BigInt),
        zroFee = (response[1] as BigInt);

  final BigInt nativeFee;

  final BigInt zroFee;
}

class Logs {
  Logs(List<dynamic> response)
      : logname = (response[0] as String),
        sourceChain = (response[1] as BigInt),
        sourceAddress = (response[2] as _i2.Uint8List),
        nonce = (response[3] as BigInt),
        payload = (response[4] as _i2.Uint8List);

  final String logname;

  final BigInt sourceChain;

  final _i2.Uint8List sourceAddress;

  final BigInt nonce;

  final _i2.Uint8List payload;
}

class ReceiveMsg {
  ReceiveMsg(List<dynamic> response)
      : srcChainId = (response[0] as BigInt),
        from = (response[1] as _i1.EthereumAddress),
        count = (response[2] as BigInt),
        payload = (response[3] as _i2.Uint8List);

  final BigInt srcChainId;

  final _i1.EthereumAddress from;

  final BigInt count;

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
