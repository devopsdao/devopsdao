// Generated code, do not modify. Run `build_runner build` to re-generate!
// @dart=2.12
// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:webthree/webthree.dart' as _i1;

final _contractAbi = _i1.ContractAbi.fromJson(
  '[{"inputs":[{"internalType":"string","name":"_nanoId","type":"string"},{"internalType":"string","name":"_taskType","type":"string"},{"internalType":"string","name":"_title","type":"string"},{"internalType":"string","name":"_description","type":"string"},{"internalType":"string","name":"_symbol","type":"string"},{"internalType":"address payable","name":"_contractOwner","type":"address"}],"stateMutability":"payable","type":"constructor"},{"inputs":[{"internalType":"string","name":"message","type":"string"}],"name":"RevertReason","type":"error"},{"anonymous":false,"inputs":[{"indexed":false,"internalType":"address","name":"contractAdr","type":"address"},{"indexed":false,"internalType":"string","name":"message","type":"string"}],"name":"Logs","type":"event"},{"anonymous":false,"inputs":[{"indexed":false,"internalType":"address","name":"contractAdr","type":"address"},{"indexed":false,"internalType":"string","name":"message","type":"string"},{"indexed":false,"internalType":"uint256","name":"value","type":"uint256"}],"name":"LogsValue","type":"event"},{"anonymous":false,"inputs":[{"indexed":false,"internalType":"address","name":"contractAdr","type":"address"},{"indexed":false,"internalType":"string","name":"message","type":"string"},{"indexed":false,"internalType":"uint256","name":"timestamp","type":"uint256"}],"name":"TaskUpdated","type":"event"},{"inputs":[],"name":"gateway","outputs":[{"internalType":"contract IAxelarGateway","name":"","type":"address"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"getBalance","outputs":[{"internalType":"uint256","name":"","type":"uint256"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"getTaskInfo","outputs":[{"components":[{"internalType":"string","name":"nanoId","type":"string"},{"internalType":"uint256","name":"createTime","type":"uint256"},{"internalType":"string","name":"taskType","type":"string"},{"internalType":"string","name":"title","type":"string"},{"internalType":"string","name":"description","type":"string"},{"internalType":"string","name":"symbol","type":"string"},{"internalType":"string","name":"taskState","type":"string"},{"internalType":"string","name":"auditState","type":"string"},{"internalType":"uint256","name":"rating","type":"uint256"},{"internalType":"address payable","name":"contractOwner","type":"address"},{"internalType":"address payable","name":"participant","type":"address"},{"internalType":"address","name":"auditInitiator","type":"address"},{"internalType":"address","name":"auditor","type":"address"},{"internalType":"address[]","name":"participants","type":"address[]"},{"internalType":"address[]","name":"funders","type":"address[]"},{"internalType":"address[]","name":"auditors","type":"address[]"},{"components":[{"internalType":"uint256","name":"id","type":"uint256"},{"internalType":"string","name":"text","type":"string"},{"internalType":"uint256","name":"timestamp","type":"uint256"},{"internalType":"address","name":"sender","type":"address"},{"internalType":"string","name":"taskState","type":"string"},{"internalType":"uint256","name":"replyTo","type":"uint256"}],"internalType":"struct Message[]","name":"messages","type":"tuple[]"},{"internalType":"address","name":"contractParent","type":"address"}],"internalType":"struct Task","name":"task","type":"tuple"}],"stateMutability":"view","type":"function"},{"inputs":[{"internalType":"string","name":"_message","type":"string"},{"internalType":"uint256","name":"_replyTo","type":"uint256"}],"name":"sendMessage","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[{"internalType":"string","name":"_favour","type":"string"},{"internalType":"string","name":"_message","type":"string"},{"internalType":"uint256","name":"_replyTo","type":"uint256"},{"internalType":"uint256","name":"rating","type":"uint256"}],"name":"taskAuditDecision","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[{"internalType":"string","name":"_message","type":"string"},{"internalType":"uint256","name":"_replyTo","type":"uint256"}],"name":"taskAuditParticipate","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[{"internalType":"string","name":"_message","type":"string"},{"internalType":"uint256","name":"_replyTo","type":"uint256"}],"name":"taskParticipate","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[{"internalType":"address payable","name":"_participant","type":"address"},{"internalType":"string","name":"_state","type":"string"},{"internalType":"string","name":"_message","type":"string"},{"internalType":"uint256","name":"_replyTo","type":"uint256"},{"internalType":"uint256","name":"_score","type":"uint256"}],"name":"taskStateChange","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[{"internalType":"address payable","name":"_addressToSend","type":"address"},{"internalType":"string","name":"_chain","type":"string"}],"name":"transferToaddress","outputs":[],"stateMutability":"payable","type":"function"},{"stateMutability":"payable","type":"receive"}]',
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
  Future<_i1.EthereumAddress> gateway({
    _i1.BlockNum? atBlock,
    _i1.EthereumAddress? sender,
  }) async {
    final function = self.abi.functions[1];
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

  /// The optional [atBlock] parameter can be used to view historical data. When
  /// set, the function will be evaluated in the specified block. By default, the
  /// latest on-chain block will be used.
  Future<BigInt> getBalance({
    _i1.BlockNum? atBlock,
    _i1.EthereumAddress? sender,
  }) async {
    final function = self.abi.functions[2];
    assert(checkSignature(function, '12065fe0'));
    final params = [];
    final response = await read(
      sender,
      function,
      params,
      atBlock,
    );
    return (response[0] as BigInt);
  }

  /// The optional [atBlock] parameter can be used to view historical data. When
  /// set, the function will be evaluated in the specified block. By default, the
  /// latest on-chain block will be used.
  Future<dynamic> getTaskInfo({
    _i1.BlockNum? atBlock,
    _i1.EthereumAddress? sender,
  }) async {
    final function = self.abi.functions[3];
    assert(checkSignature(function, 'bac64a2e'));
    final params = [];
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
  Future<String> sendMessage(
    String message,
    BigInt replyTo, {
    required _i1.Credentials credentials,
    _i1.Transaction? transaction,
  }) async {
    final function = self.abi.functions[4];
    assert(checkSignature(function, 'd013bef0'));
    final params = [
      message,
      replyTo,
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
  Future<String> taskAuditDecision(
    String favour,
    String message,
    BigInt replyTo,
    BigInt rating, {
    required _i1.Credentials credentials,
    _i1.Transaction? transaction,
  }) async {
    final function = self.abi.functions[5];
    assert(checkSignature(function, '05923940'));
    final params = [
      favour,
      message,
      replyTo,
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
    String message,
    BigInt replyTo, {
    required _i1.Credentials credentials,
    _i1.Transaction? transaction,
  }) async {
    final function = self.abi.functions[6];
    assert(checkSignature(function, '16da43f6'));
    final params = [
      message,
      replyTo,
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
    String message,
    BigInt replyTo, {
    required _i1.Credentials credentials,
    _i1.Transaction? transaction,
  }) async {
    final function = self.abi.functions[7];
    assert(checkSignature(function, '14f99556'));
    final params = [
      message,
      replyTo,
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
    _i1.EthereumAddress participant,
    String state,
    String message,
    BigInt replyTo,
    BigInt score, {
    required _i1.Credentials credentials,
    _i1.Transaction? transaction,
  }) async {
    final function = self.abi.functions[8];
    assert(checkSignature(function, '45345850'));
    final params = [
      participant,
      state,
      message,
      replyTo,
      score,
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
    _i1.EthereumAddress addressToSend,
    String chain, {
    required _i1.Credentials credentials,
    _i1.Transaction? transaction,
  }) async {
    final function = self.abi.functions[9];
    assert(checkSignature(function, 'f74657bb'));
    final params = [
      addressToSend,
      chain,
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
