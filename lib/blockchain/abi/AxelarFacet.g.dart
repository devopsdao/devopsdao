// Generated code, do not modify. Run `build_runner build` to re-generate!
// @dart=2.12
// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:webthree/webthree.dart' as _i1;
import 'dart:typed_data' as _i2;

final _contractAbi = _i1.ContractAbi.fromJson(
  '[{"inputs":[],"name":"InvalidAddress","type":"error"},{"inputs":[],"name":"NotApprovedByGateway","type":"error"},{"anonymous":false,"inputs":[{"indexed":false,"internalType":"string","name":"logname","type":"string"}],"name":"LogSimple","type":"event"},{"anonymous":false,"inputs":[{"indexed":false,"internalType":"string","name":"logname","type":"string"},{"indexed":false,"internalType":"string","name":"sourceChain","type":"string"},{"indexed":false,"internalType":"string","name":"sourceAddress","type":"string"},{"indexed":false,"internalType":"bytes","name":"payload","type":"bytes"}],"name":"Logs","type":"event"},{"anonymous":false,"inputs":[{"indexed":false,"internalType":"address","name":"_sender","type":"address"},{"indexed":false,"internalType":"string","name":"_nanoId","type":"string"},{"indexed":false,"internalType":"string","name":"_taskType","type":"string"},{"indexed":false,"internalType":"string","name":"_title","type":"string"},{"indexed":false,"internalType":"string","name":"_description","type":"string"},{"indexed":false,"internalType":"string[]","name":"_tags","type":"string[]"},{"indexed":false,"internalType":"string[][]","name":"_tokenNames","type":"string[][]"}],"name":"TaskContractCreating","type":"event"},{"anonymous":false,"inputs":[{"indexed":false,"internalType":"address","name":"_sender","type":"address"},{"indexed":false,"internalType":"address","name":"_contractAddress","type":"address"},{"indexed":false,"internalType":"string","name":"_message","type":"string"},{"indexed":false,"internalType":"uint256","name":"_replyTo","type":"uint256"}],"name":"TaskParticipating","type":"event"},{"anonymous":false,"inputs":[{"indexed":false,"internalType":"address","name":"_sender","type":"address"},{"indexed":false,"internalType":"address","name":"_contractAddress","type":"address"},{"indexed":false,"internalType":"string","name":"_message","type":"string"},{"indexed":false,"internalType":"uint256","name":"_replyTo","type":"uint256"}],"name":"TaskSendMessaging","type":"event"},{"anonymous":false,"inputs":[{"indexed":false,"internalType":"address","name":"_sender","type":"address"},{"indexed":false,"internalType":"address","name":"_contractAddress","type":"address"},{"indexed":false,"internalType":"address","name":"_participant","type":"address"},{"indexed":false,"internalType":"string","name":"_state","type":"string"},{"indexed":false,"internalType":"string","name":"_message","type":"string"},{"indexed":false,"internalType":"uint256","name":"_replyTo","type":"uint256"},{"indexed":false,"internalType":"uint256","name":"_rating","type":"uint256"}],"name":"TaskStateChanging","type":"event"},{"anonymous":false,"inputs":[{"indexed":false,"internalType":"address","name":"_sender","type":"address"},{"indexed":false,"internalType":"address","name":"_contractAddress","type":"address"},{"indexed":false,"internalType":"string","name":"_favour","type":"string"},{"indexed":false,"internalType":"string","name":"_message","type":"string"},{"indexed":false,"internalType":"uint256","name":"_replyTo","type":"uint256"},{"indexed":false,"internalType":"uint256","name":"_rating","type":"uint256"}],"name":"taskAuditDecisioning","type":"event"},{"inputs":[{"internalType":"address","name":"_sender","type":"address"},{"components":[{"internalType":"string","name":"nanoId","type":"string"},{"internalType":"string","name":"taskType","type":"string"},{"internalType":"string","name":"title","type":"string"},{"internalType":"string","name":"description","type":"string"},{"internalType":"string","name":"repository","type":"string"},{"internalType":"string[]","name":"tags","type":"string[]"},{"internalType":"string[][]","name":"tokenNames","type":"string[][]"},{"internalType":"address[]","name":"tokenContracts","type":"address[]"},{"internalType":"uint256[][]","name":"tokenIds","type":"uint256[][]"},{"internalType":"uint256[][]","name":"tokenAmounts","type":"uint256[][]"}],"internalType":"struct TaskData","name":"_taskData","type":"tuple"}],"name":"createTaskContractAxelar","outputs":[],"stateMutability":"payable","type":"function"},{"inputs":[{"internalType":"bytes32","name":"commandId","type":"bytes32"},{"internalType":"string","name":"sourceChain","type":"string"},{"internalType":"string","name":"sourceAddress","type":"string"},{"internalType":"bytes","name":"payload","type":"bytes"}],"name":"execute","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[{"internalType":"bytes32","name":"commandId","type":"bytes32"},{"internalType":"string","name":"sourceChain","type":"string"},{"internalType":"string","name":"sourceAddress","type":"string"},{"internalType":"bytes","name":"payload","type":"bytes"},{"internalType":"string","name":"tokenSymbol","type":"string"},{"internalType":"uint256","name":"amount","type":"uint256"}],"name":"executeWithToken","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[],"name":"gateway","outputs":[{"internalType":"contract IAxelarGateway","name":"","type":"address"}],"stateMutability":"view","type":"function"},{"inputs":[{"internalType":"address","name":"_sender","type":"address"},{"internalType":"address","name":"_contractAddress","type":"address"},{"internalType":"string","name":"_message","type":"string"},{"internalType":"uint256","name":"_replyTo","type":"uint256"}],"name":"sendMessageAxelar","outputs":[],"stateMutability":"payable","type":"function"},{"inputs":[{"internalType":"address","name":"_sender","type":"address"},{"internalType":"address","name":"_contractAddress","type":"address"},{"internalType":"string","name":"_favour","type":"string"},{"internalType":"string","name":"_message","type":"string"},{"internalType":"uint256","name":"_replyTo","type":"uint256"},{"internalType":"uint256","name":"_rating","type":"uint256"}],"name":"taskAuditDecisionAxelar","outputs":[],"stateMutability":"payable","type":"function"},{"inputs":[{"internalType":"address","name":"_sender","type":"address"},{"internalType":"address","name":"_contractAddress","type":"address"},{"internalType":"string","name":"_message","type":"string"},{"internalType":"uint256","name":"_replyTo","type":"uint256"}],"name":"taskAuditParticipateAxelar","outputs":[],"stateMutability":"payable","type":"function"},{"inputs":[{"internalType":"address","name":"_sender","type":"address"},{"internalType":"address","name":"_contractAddress","type":"address"},{"internalType":"string","name":"_message","type":"string"},{"internalType":"uint256","name":"_replyTo","type":"uint256"}],"name":"taskParticipateAxelar","outputs":[],"stateMutability":"payable","type":"function"},{"inputs":[{"internalType":"address","name":"_sender","type":"address"},{"internalType":"address","name":"_contractAddress","type":"address"},{"internalType":"address payable","name":"_participant","type":"address"},{"internalType":"string","name":"_state","type":"string"},{"internalType":"string","name":"_message","type":"string"},{"internalType":"uint256","name":"_replyTo","type":"uint256"},{"internalType":"uint256","name":"_rating","type":"uint256"}],"name":"taskStateChangeAxelar","outputs":[],"stateMutability":"payable","type":"function"}]',
  'AxelarFacet',
);

class AxelarFacet extends _i1.GeneratedContract {
  AxelarFacet({
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
  Future<String> createTaskContractAxelar(
    _i1.EthereumAddress _sender,
    dynamic _taskData, {
    required _i1.Credentials credentials,
    _i1.Transaction? transaction,
  }) async {
    final function = self.abi.functions[0];
    assert(checkSignature(function, '20504757'));
    final params = [
      _sender,
      _taskData,
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
    final function = self.abi.functions[1];
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
    final function = self.abi.functions[2];
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
  Future<_i1.EthereumAddress> gateway({
    _i1.BlockNum? atBlock,
    _i1.EthereumAddress? sender,
  }) async {
    final function = self.abi.functions[3];
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

  /// The optional [transaction] parameter can be used to override parameters
  /// like the gas price, nonce and max gas. The `data` and `to` fields will be
  /// set by the contract.
  Future<String> sendMessageAxelar(
    _i1.EthereumAddress _sender,
    _i1.EthereumAddress _contractAddress,
    String _message,
    BigInt _replyTo, {
    required _i1.Credentials credentials,
    _i1.Transaction? transaction,
  }) async {
    final function = self.abi.functions[4];
    assert(checkSignature(function, '1e7e62dc'));
    final params = [
      _sender,
      _contractAddress,
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
  Future<String> taskAuditDecisionAxelar(
    _i1.EthereumAddress _sender,
    _i1.EthereumAddress _contractAddress,
    String _favour,
    String _message,
    BigInt _replyTo,
    BigInt _rating, {
    required _i1.Credentials credentials,
    _i1.Transaction? transaction,
  }) async {
    final function = self.abi.functions[5];
    assert(checkSignature(function, '7e231db3'));
    final params = [
      _sender,
      _contractAddress,
      _favour,
      _message,
      _replyTo,
      _rating,
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
  Future<String> taskAuditParticipateAxelar(
    _i1.EthereumAddress _sender,
    _i1.EthereumAddress _contractAddress,
    String _message,
    BigInt _replyTo, {
    required _i1.Credentials credentials,
    _i1.Transaction? transaction,
  }) async {
    final function = self.abi.functions[6];
    assert(checkSignature(function, '6d2acd61'));
    final params = [
      _sender,
      _contractAddress,
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
  Future<String> taskParticipateAxelar(
    _i1.EthereumAddress _sender,
    _i1.EthereumAddress _contractAddress,
    String _message,
    BigInt _replyTo, {
    required _i1.Credentials credentials,
    _i1.Transaction? transaction,
  }) async {
    final function = self.abi.functions[7];
    assert(checkSignature(function, '8458bc1e'));
    final params = [
      _sender,
      _contractAddress,
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
  Future<String> taskStateChangeAxelar(
    _i1.EthereumAddress _sender,
    _i1.EthereumAddress _contractAddress,
    _i1.EthereumAddress _participant,
    String _state,
    String _message,
    BigInt _replyTo,
    BigInt _rating, {
    required _i1.Credentials credentials,
    _i1.Transaction? transaction,
  }) async {
    final function = self.abi.functions[8];
    assert(checkSignature(function, 'a4c2c4f2'));
    final params = [
      _sender,
      _contractAddress,
      _participant,
      _state,
      _message,
      _replyTo,
      _rating,
    ];
    return write(
      credentials,
      transaction,
      function,
      params,
    );
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

  /// Returns a live stream of all TaskParticipating events emitted by this contract.
  Stream<TaskParticipating> taskParticipatingEvents({
    _i1.BlockNum? fromBlock,
    _i1.BlockNum? toBlock,
  }) {
    final event = self.event('TaskParticipating');
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
      return TaskParticipating(decoded);
    });
  }

  /// Returns a live stream of all TaskSendMessaging events emitted by this contract.
  Stream<TaskSendMessaging> taskSendMessagingEvents({
    _i1.BlockNum? fromBlock,
    _i1.BlockNum? toBlock,
  }) {
    final event = self.event('TaskSendMessaging');
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
      return TaskSendMessaging(decoded);
    });
  }

  /// Returns a live stream of all TaskStateChanging events emitted by this contract.
  Stream<TaskStateChanging> taskStateChangingEvents({
    _i1.BlockNum? fromBlock,
    _i1.BlockNum? toBlock,
  }) {
    final event = self.event('TaskStateChanging');
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
      return TaskStateChanging(decoded);
    });
  }

  /// Returns a live stream of all taskAuditDecisioning events emitted by this contract.
  Stream<taskAuditDecisioning> taskAuditDecisioningEvents({
    _i1.BlockNum? fromBlock,
    _i1.BlockNum? toBlock,
  }) {
    final event = self.event('taskAuditDecisioning');
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
      return taskAuditDecisioning(decoded);
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
      : sender = (response[0] as _i1.EthereumAddress),
        nanoId = (response[1] as String),
        taskType = (response[2] as String),
        title = (response[3] as String),
        description = (response[4] as String),
        tags = (response[5] as List<dynamic>).cast<String>(),
        tokenNames = (response[6] as List<dynamic>)
            .cast<List<dynamic>>()
            .map<List<String>>((e) {
          return e.cast<String>();
        }).toList();

  final _i1.EthereumAddress sender;

  final String nanoId;

  final String taskType;

  final String title;

  final String description;

  final List<String> tags;

  final List<List<String>> tokenNames;
}

class TaskParticipating {
  TaskParticipating(List<dynamic> response)
      : sender = (response[0] as _i1.EthereumAddress),
        contractAddress = (response[1] as _i1.EthereumAddress),
        message = (response[2] as String),
        replyTo = (response[3] as BigInt);

  final _i1.EthereumAddress sender;

  final _i1.EthereumAddress contractAddress;

  final String message;

  final BigInt replyTo;
}

class TaskSendMessaging {
  TaskSendMessaging(List<dynamic> response)
      : sender = (response[0] as _i1.EthereumAddress),
        contractAddress = (response[1] as _i1.EthereumAddress),
        message = (response[2] as String),
        replyTo = (response[3] as BigInt);

  final _i1.EthereumAddress sender;

  final _i1.EthereumAddress contractAddress;

  final String message;

  final BigInt replyTo;
}

class TaskStateChanging {
  TaskStateChanging(List<dynamic> response)
      : sender = (response[0] as _i1.EthereumAddress),
        contractAddress = (response[1] as _i1.EthereumAddress),
        participant = (response[2] as _i1.EthereumAddress),
        state = (response[3] as String),
        message = (response[4] as String),
        replyTo = (response[5] as BigInt),
        rating = (response[6] as BigInt);

  final _i1.EthereumAddress sender;

  final _i1.EthereumAddress contractAddress;

  final _i1.EthereumAddress participant;

  final String state;

  final String message;

  final BigInt replyTo;

  final BigInt rating;
}

class taskAuditDecisioning {
  taskAuditDecisioning(List<dynamic> response)
      : sender = (response[0] as _i1.EthereumAddress),
        contractAddress = (response[1] as _i1.EthereumAddress),
        favour = (response[2] as String),
        message = (response[3] as String),
        replyTo = (response[4] as BigInt),
        rating = (response[5] as BigInt);

  final _i1.EthereumAddress sender;

  final _i1.EthereumAddress contractAddress;

  final String favour;

  final String message;

  final BigInt replyTo;

  final BigInt rating;
}
