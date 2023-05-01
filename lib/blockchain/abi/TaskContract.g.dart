// Generated code, do not modify. Run `build_runner build` to re-generate!
// @dart=2.12
// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:webthree/webthree.dart' as _i1;
import 'dart:typed_data' as _i2;

final _contractAbi = _i1.ContractAbi.fromJson(
  '[{"inputs":[{"internalType":"address payable","name":"_sender","type":"address"},{"components":[{"internalType":"string","name":"nanoId","type":"string"},{"internalType":"string","name":"taskType","type":"string"},{"internalType":"string","name":"title","type":"string"},{"internalType":"string","name":"description","type":"string"},{"internalType":"string","name":"repository","type":"string"},{"internalType":"string[]","name":"tags","type":"string[]"},{"internalType":"string[][]","name":"tokenNames","type":"string[][]"},{"internalType":"address[]","name":"tokenContracts","type":"address[]"},{"internalType":"uint256[][]","name":"tokenIds","type":"uint256[][]"},{"internalType":"uint256[][]","name":"tokenAmounts","type":"uint256[][]"}],"internalType":"struct TaskData","name":"_taskData","type":"tuple"}],"stateMutability":"payable","type":"constructor"},{"anonymous":false,"inputs":[{"indexed":false,"internalType":"address","name":"contractAdr","type":"address"},{"indexed":false,"internalType":"string","name":"message","type":"string"}],"name":"Logs","type":"event"},{"anonymous":false,"inputs":[{"indexed":false,"internalType":"address","name":"contractAdr","type":"address"},{"indexed":false,"internalType":"string","name":"message","type":"string"},{"indexed":false,"internalType":"uint256","name":"value","type":"uint256"}],"name":"LogsValue","type":"event"},{"anonymous":false,"inputs":[{"indexed":false,"internalType":"address","name":"contractAdr","type":"address"},{"indexed":false,"internalType":"string","name":"message","type":"string"},{"indexed":false,"internalType":"uint256","name":"timestamp","type":"uint256"}],"name":"TaskUpdated","type":"event"},{"inputs":[],"name":"getTaskData","outputs":[{"components":[{"internalType":"string","name":"nanoId","type":"string"},{"internalType":"uint256","name":"createTime","type":"uint256"},{"internalType":"string","name":"taskType","type":"string"},{"internalType":"string","name":"title","type":"string"},{"internalType":"string","name":"description","type":"string"},{"internalType":"string","name":"repository","type":"string"},{"internalType":"string[]","name":"tags","type":"string[]"},{"internalType":"uint256[]","name":"tagsNFT","type":"uint256[]"},{"internalType":"string[][]","name":"tokenNames","type":"string[][]"},{"internalType":"address[]","name":"tokenContracts","type":"address[]"},{"internalType":"uint256[][]","name":"tokenIds","type":"uint256[][]"},{"internalType":"uint256[][]","name":"tokenAmounts","type":"uint256[][]"},{"internalType":"string","name":"taskState","type":"string"},{"internalType":"string","name":"auditState","type":"string"},{"internalType":"uint256","name":"rating","type":"uint256"},{"internalType":"address payable","name":"contractOwner","type":"address"},{"internalType":"address payable","name":"participant","type":"address"},{"internalType":"address","name":"auditInitiator","type":"address"},{"internalType":"address","name":"auditor","type":"address"},{"internalType":"address[]","name":"participants","type":"address[]"},{"internalType":"address[]","name":"funders","type":"address[]"},{"internalType":"address[]","name":"auditors","type":"address[]"},{"components":[{"internalType":"uint256","name":"id","type":"uint256"},{"internalType":"string","name":"text","type":"string"},{"internalType":"uint256","name":"timestamp","type":"uint256"},{"internalType":"address","name":"sender","type":"address"},{"internalType":"string","name":"taskState","type":"string"},{"internalType":"uint256","name":"replyTo","type":"uint256"}],"internalType":"struct Message[]","name":"messages","type":"tuple[]"},{"internalType":"address","name":"contractParent","type":"address"}],"internalType":"struct Task","name":"task","type":"tuple"}],"stateMutability":"view","type":"function"},{"inputs":[{"internalType":"address","name":"_operator","type":"address"},{"internalType":"address","name":"_from","type":"address"},{"internalType":"uint256[]","name":"_ids","type":"uint256[]"},{"internalType":"uint256[]","name":"_values","type":"uint256[]"},{"internalType":"bytes","name":"_data","type":"bytes"}],"name":"onERC1155BatchReceived","outputs":[{"internalType":"bytes4","name":"","type":"bytes4"}],"stateMutability":"view","type":"function"},{"inputs":[{"internalType":"address","name":"_operator","type":"address"},{"internalType":"address","name":"_from","type":"address"},{"internalType":"uint256","name":"_id","type":"uint256"},{"internalType":"uint256","name":"_value","type":"uint256"},{"internalType":"bytes","name":"_data","type":"bytes"}],"name":"onERC1155Received","outputs":[{"internalType":"bytes4","name":"","type":"bytes4"}],"stateMutability":"view","type":"function"},{"inputs":[{"internalType":"address","name":"_sender","type":"address"},{"internalType":"string","name":"_message","type":"string"},{"internalType":"uint256","name":"_replyTo","type":"uint256"}],"name":"sendMessage","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[{"internalType":"bytes4","name":"interfaceID","type":"bytes4"}],"name":"supportsInterface","outputs":[{"internalType":"bool","name":"","type":"bool"}],"stateMutability":"pure","type":"function"},{"inputs":[{"internalType":"address","name":"_sender","type":"address"},{"internalType":"string","name":"_favour","type":"string"},{"internalType":"string","name":"_message","type":"string"},{"internalType":"uint256","name":"_replyTo","type":"uint256"},{"internalType":"uint256","name":"rating","type":"uint256"}],"name":"taskAuditDecision","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[{"internalType":"address","name":"_sender","type":"address"},{"internalType":"string","name":"_message","type":"string"},{"internalType":"uint256","name":"_replyTo","type":"uint256"}],"name":"taskAuditParticipate","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[{"internalType":"address","name":"_sender","type":"address"},{"internalType":"string","name":"_message","type":"string"},{"internalType":"uint256","name":"_replyTo","type":"uint256"}],"name":"taskParticipate","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[{"internalType":"address","name":"_sender","type":"address"},{"internalType":"address payable","name":"_participant","type":"address"},{"internalType":"string","name":"_state","type":"string"},{"internalType":"string","name":"_message","type":"string"},{"internalType":"uint256","name":"_replyTo","type":"uint256"},{"internalType":"uint256","name":"_score","type":"uint256"}],"name":"taskStateChange","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[{"internalType":"address payable","name":"_addressToSend","type":"address"},{"internalType":"string","name":"_chain","type":"string"}],"name":"transferToaddress","outputs":[],"stateMutability":"payable","type":"function"},{"stateMutability":"payable","type":"receive"}]',
  'TaskContract',
);

class TaskContract extends _i1.GeneratedContract {
  TaskContract({
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
  Future<dynamic> getTaskData({
    _i1.BlockNum? atBlock,
    _i1.EthereumAddress? sender,
  }) async {
    final function = self.abi.functions[1];
    assert(checkSignature(function, 'db48ce0b'));
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
  Future<_i2.Uint8List> onERC1155BatchReceived(
    _i1.EthereumAddress _operator,
    _i1.EthereumAddress _from,
    List<BigInt> _ids,
    List<BigInt> _values,
    _i2.Uint8List _data, {
    _i1.BlockNum? atBlock,
    _i1.EthereumAddress? sender,
  }) async {
    final function = self.abi.functions[2];
    assert(checkSignature(function, 'bc197c81'));
    final params = [
      _operator,
      _from,
      _ids,
      _values,
      _data,
    ];
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
  Future<_i2.Uint8List> onERC1155Received(
    _i1.EthereumAddress _operator,
    _i1.EthereumAddress _from,
    BigInt _id,
    BigInt _value,
    _i2.Uint8List _data, {
    _i1.BlockNum? atBlock,
    _i1.EthereumAddress? sender,
  }) async {
    final function = self.abi.functions[3];
    assert(checkSignature(function, 'f23a6e61'));
    final params = [
      _operator,
      _from,
      _id,
      _value,
      _data,
    ];
    final response = await read(
      sender,
      function,
      params,
      atBlock,
    );
    return (response[0] as _i2.Uint8List);
  }

  /// The optional [transaction] parameter can be used to override parameters
  /// like the gas price, nonce and max gas. The `data` and `to` fields will be
  /// set by the contract.
  Future<String> sendMessage(
    _i1.EthereumAddress _sender,
    String _message,
    BigInt _replyTo, {
    required _i1.Credentials credentials,
    _i1.Transaction? transaction,
  }) async {
    final function = self.abi.functions[4];
    assert(checkSignature(function, 'e2235c58'));
    final params = [
      _sender,
      _message,
      _replyTo,
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
  Future<bool> supportsInterface(
    _i2.Uint8List interfaceID, {
    _i1.BlockNum? atBlock,
    _i1.EthereumAddress? sender,
  }) async {
    final function = self.abi.functions[5];
    assert(checkSignature(function, '01ffc9a7'));
    final params = [interfaceID];
    final response = await read(
      sender,
      function,
      params,
      atBlock,
    );
    return (response[0] as bool);
  }

  /// The optional [transaction] parameter can be used to override parameters
  /// like the gas price, nonce and max gas. The `data` and `to` fields will be
  /// set by the contract.
  Future<String> taskAuditDecision(
    _i1.EthereumAddress _sender,
    String _favour,
    String _message,
    BigInt _replyTo,
    BigInt rating, {
    required _i1.Credentials credentials,
    _i1.Transaction? transaction,
  }) async {
    final function = self.abi.functions[6];
    assert(checkSignature(function, '6675ee96'));
    final params = [
      _sender,
      _favour,
      _message,
      _replyTo,
      rating,
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
  Future<String> taskAuditParticipate(
    _i1.EthereumAddress _sender,
    String _message,
    BigInt _replyTo, {
    required _i1.Credentials credentials,
    _i1.Transaction? transaction,
  }) async {
    final function = self.abi.functions[7];
    assert(checkSignature(function, 'dfc8b24b'));
    final params = [
      _sender,
      _message,
      _replyTo,
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
  Future<String> taskParticipate(
    _i1.EthereumAddress _sender,
    String _message,
    BigInt _replyTo, {
    required _i1.Credentials credentials,
    _i1.Transaction? transaction,
  }) async {
    final function = self.abi.functions[8];
    assert(checkSignature(function, '25969294'));
    final params = [
      _sender,
      _message,
      _replyTo,
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
  Future<String> taskStateChange(
    _i1.EthereumAddress _sender,
    _i1.EthereumAddress _participant,
    String _state,
    String _message,
    BigInt _replyTo,
    BigInt _score, {
    required _i1.Credentials credentials,
    _i1.Transaction? transaction,
  }) async {
    final function = self.abi.functions[9];
    assert(checkSignature(function, '865d1cfe'));
    final params = [
      _sender,
      _participant,
      _state,
      _message,
      _replyTo,
      _score,
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
  Future<String> transferToaddress(
    _i1.EthereumAddress _addressToSend,
    String _chain, {
    required _i1.Credentials credentials,
    _i1.Transaction? transaction,
  }) async {
    final function = self.abi.functions[10];
    assert(checkSignature(function, 'f74657bb'));
    final params = [
      _addressToSend,
      _chain,
    ];
    return write(
      credentials,
      transaction,
      function,
      params,
    );
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

  /// Returns a live stream of all LogsValue events emitted by this contract.
  Stream<LogsValue> logsValueEvents({
    _i1.BlockNum? fromBlock,
    _i1.BlockNum? toBlock,
  }) {
    final event = self.event('LogsValue');
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
      return LogsValue(decoded);
    });
  }

  /// Returns a live stream of all TaskUpdated events emitted by this contract.
  Stream<TaskUpdated> taskUpdatedEvents({
    _i1.BlockNum? fromBlock,
    _i1.BlockNum? toBlock,
  }) {
    final event = self.event('TaskUpdated');
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
      return TaskUpdated(decoded);
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

class LogsValue {
  LogsValue(List<dynamic> response)
      : contractAdr = (response[0] as _i1.EthereumAddress),
        message = (response[1] as String),
        value = (response[2] as BigInt);

  final _i1.EthereumAddress contractAdr;

  final String message;

  final BigInt value;
}

class TaskUpdated {
  TaskUpdated(List<dynamic> response)
      : contractAdr = (response[0] as _i1.EthereumAddress),
        message = (response[1] as String),
        timestamp = (response[2] as BigInt);

  final _i1.EthereumAddress contractAdr;

  final String message;

  final BigInt timestamp;
}
