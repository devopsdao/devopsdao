// Generated code, do not modify. Run `build_runner build` to re-generate!
// @dart=2.12
// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:webthree/webthree.dart' as _i1;
import 'dart:typed_data' as _i2;

final _contractAbi = _i1.ContractAbi.fromJson(
  '[{"anonymous":false,"inputs":[{"indexed":false,"internalType":"uint32","name":"origin","type":"uint32"},{"indexed":false,"internalType":"bytes32","name":"sender","type":"bytes32"},{"indexed":false,"internalType":"bytes","name":"message","type":"bytes"}],"name":"ReceivedMessage","type":"event"},{"anonymous":false,"inputs":[{"indexed":false,"internalType":"uint32","name":"destinationDomain","type":"uint32"},{"indexed":false,"internalType":"address","name":"destinationAddress","type":"address"},{"indexed":false,"internalType":"bytes","name":"payload","type":"bytes"}],"name":"SentMessage","type":"event"},{"anonymous":false,"inputs":[{"indexed":false,"internalType":"address","name":"_sender","type":"address"},{"indexed":false,"internalType":"string","name":"_nanoId","type":"string"},{"indexed":false,"internalType":"string","name":"_taskType","type":"string"},{"indexed":false,"internalType":"string","name":"_title","type":"string"},{"indexed":false,"internalType":"string","name":"_description","type":"string"},{"indexed":false,"internalType":"string[]","name":"_tags","type":"string[]"},{"indexed":false,"internalType":"string[][]","name":"_tokenNames","type":"string[][]"}],"name":"TaskContractCreating","type":"event"},{"anonymous":false,"inputs":[{"indexed":false,"internalType":"address","name":"_sender","type":"address"},{"indexed":false,"internalType":"address","name":"_contractAddress","type":"address"},{"indexed":false,"internalType":"string","name":"_message","type":"string"},{"indexed":false,"internalType":"uint256","name":"_replyTo","type":"uint256"}],"name":"TaskParticipating","type":"event"},{"anonymous":false,"inputs":[{"indexed":false,"internalType":"address","name":"_sender","type":"address"},{"indexed":false,"internalType":"address","name":"_contractAddress","type":"address"},{"indexed":false,"internalType":"string","name":"_message","type":"string"},{"indexed":false,"internalType":"uint256","name":"_replyTo","type":"uint256"}],"name":"TaskSendMessaging","type":"event"},{"anonymous":false,"inputs":[{"indexed":false,"internalType":"address","name":"_sender","type":"address"},{"indexed":false,"internalType":"address","name":"_contractAddress","type":"address"},{"indexed":false,"internalType":"address","name":"_participant","type":"address"},{"indexed":false,"internalType":"string","name":"_state","type":"string"},{"indexed":false,"internalType":"string","name":"_message","type":"string"},{"indexed":false,"internalType":"uint256","name":"_replyTo","type":"uint256"},{"indexed":false,"internalType":"uint256","name":"_rating","type":"uint256"}],"name":"TaskStateChanging","type":"event"},{"anonymous":false,"inputs":[{"indexed":false,"internalType":"address","name":"_sender","type":"address"},{"indexed":false,"internalType":"address","name":"_contractAddress","type":"address"},{"indexed":false,"internalType":"string","name":"_favour","type":"string"},{"indexed":false,"internalType":"string","name":"_message","type":"string"},{"indexed":false,"internalType":"uint256","name":"_replyTo","type":"uint256"},{"indexed":false,"internalType":"uint256","name":"_rating","type":"uint256"}],"name":"taskAuditDecisioning","type":"event"},{"inputs":[{"internalType":"address","name":"_sender","type":"address"},{"components":[{"internalType":"string","name":"nanoId","type":"string"},{"internalType":"string","name":"taskType","type":"string"},{"internalType":"string","name":"title","type":"string"},{"internalType":"string","name":"description","type":"string"},{"internalType":"string","name":"repository","type":"string"},{"internalType":"string[]","name":"tags","type":"string[]"},{"internalType":"string[][]","name":"tokenNames","type":"string[][]"},{"internalType":"address[]","name":"tokenContracts","type":"address[]"},{"internalType":"uint256[][]","name":"tokenIds","type":"uint256[][]"},{"internalType":"uint256[][]","name":"tokenAmounts","type":"uint256[][]"}],"internalType":"struct TaskData","name":"_taskData","type":"tuple"}],"name":"createTaskContractHyperlane","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[{"internalType":"uint32","name":"_origin","type":"uint32"},{"internalType":"bytes32","name":"_sourceAddress","type":"bytes32"},{"internalType":"bytes","name":"_payload","type":"bytes"}],"name":"handle","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[{"internalType":"address","name":"_sender","type":"address"},{"internalType":"address","name":"_contractAddress","type":"address"},{"internalType":"string","name":"_message","type":"string"},{"internalType":"uint256","name":"_replyTo","type":"uint256"}],"name":"sendMessageHyperlane","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[{"internalType":"address","name":"_sender","type":"address"},{"internalType":"address","name":"_contractAddress","type":"address"},{"internalType":"string","name":"_favour","type":"string"},{"internalType":"string","name":"_message","type":"string"},{"internalType":"uint256","name":"_replyTo","type":"uint256"},{"internalType":"uint256","name":"_rating","type":"uint256"}],"name":"taskAuditDecisionHyperlane","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[{"internalType":"address","name":"_sender","type":"address"},{"internalType":"address","name":"_contractAddress","type":"address"},{"internalType":"string","name":"_message","type":"string"},{"internalType":"uint256","name":"_replyTo","type":"uint256"}],"name":"taskAuditParticipateHyperlane","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[{"internalType":"address","name":"_sender","type":"address"},{"internalType":"address","name":"_contractAddress","type":"address"},{"internalType":"string","name":"_message","type":"string"},{"internalType":"uint256","name":"_replyTo","type":"uint256"}],"name":"taskParticipateHyperlane","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[{"internalType":"address","name":"_sender","type":"address"},{"internalType":"address","name":"_contractAddress","type":"address"},{"internalType":"address payable","name":"_participant","type":"address"},{"internalType":"string","name":"_state","type":"string"},{"internalType":"string","name":"_message","type":"string"},{"internalType":"uint256","name":"_replyTo","type":"uint256"},{"internalType":"uint256","name":"_rating","type":"uint256"}],"name":"taskStateChangeHyperlane","outputs":[],"stateMutability":"nonpayable","type":"function"}]',
  'HyperlaneFacet',
);

class HyperlaneFacet extends _i1.GeneratedContract {
  HyperlaneFacet({
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
  Future<String> createTaskContractHyperlane(
    _i1.EthereumAddress _sender,
    dynamic _taskData, {
    required _i1.Credentials credentials,
    _i1.Transaction? transaction,
  }) async {
    final function = self.abi.functions[0];
    assert(checkSignature(function, 'f6c0020a'));
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
  Future<String> handle(
    BigInt _origin,
    _i2.Uint8List _sourceAddress,
    _i2.Uint8List _payload, {
    required _i1.Credentials credentials,
    _i1.Transaction? transaction,
  }) async {
    final function = self.abi.functions[1];
    assert(checkSignature(function, '56d5d475'));
    final params = [
      _origin,
      _sourceAddress,
      _payload,
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
  Future<String> sendMessageHyperlane(
    _i1.EthereumAddress _sender,
    _i1.EthereumAddress _contractAddress,
    String _message,
    BigInt _replyTo, {
    required _i1.Credentials credentials,
    _i1.Transaction? transaction,
  }) async {
    final function = self.abi.functions[2];
    assert(checkSignature(function, 'a39410b4'));
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
  Future<String> taskAuditDecisionHyperlane(
    _i1.EthereumAddress _sender,
    _i1.EthereumAddress _contractAddress,
    String _favour,
    String _message,
    BigInt _replyTo,
    BigInt _rating, {
    required _i1.Credentials credentials,
    _i1.Transaction? transaction,
  }) async {
    final function = self.abi.functions[3];
    assert(checkSignature(function, '4a6fe41a'));
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
  Future<String> taskAuditParticipateHyperlane(
    _i1.EthereumAddress _sender,
    _i1.EthereumAddress _contractAddress,
    String _message,
    BigInt _replyTo, {
    required _i1.Credentials credentials,
    _i1.Transaction? transaction,
  }) async {
    final function = self.abi.functions[4];
    assert(checkSignature(function, 'ceed9b7d'));
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
  Future<String> taskParticipateHyperlane(
    _i1.EthereumAddress _sender,
    _i1.EthereumAddress _contractAddress,
    String _message,
    BigInt _replyTo, {
    required _i1.Credentials credentials,
    _i1.Transaction? transaction,
  }) async {
    final function = self.abi.functions[5];
    assert(checkSignature(function, '802480ac'));
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
  Future<String> taskStateChangeHyperlane(
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
    final function = self.abi.functions[6];
    assert(checkSignature(function, '7fcfaeac'));
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

  /// Returns a live stream of all ReceivedMessage events emitted by this contract.
  Stream<ReceivedMessage> receivedMessageEvents({
    _i1.BlockNum? fromBlock,
    _i1.BlockNum? toBlock,
  }) {
    final event = self.event('ReceivedMessage');
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
      return ReceivedMessage(decoded);
    });
  }

  /// Returns a live stream of all SentMessage events emitted by this contract.
  Stream<SentMessage> sentMessageEvents({
    _i1.BlockNum? fromBlock,
    _i1.BlockNum? toBlock,
  }) {
    final event = self.event('SentMessage');
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
      return SentMessage(decoded);
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

class ReceivedMessage {
  ReceivedMessage(List<dynamic> response)
      : origin = (response[0] as BigInt),
        sender = (response[1] as _i2.Uint8List),
        message = (response[2] as _i2.Uint8List);

  final BigInt origin;

  final _i2.Uint8List sender;

  final _i2.Uint8List message;
}

class SentMessage {
  SentMessage(List<dynamic> response)
      : destinationDomain = (response[0] as BigInt),
        destinationAddress = (response[1] as _i1.EthereumAddress),
        payload = (response[2] as _i2.Uint8List);

  final BigInt destinationDomain;

  final _i1.EthereumAddress destinationAddress;

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
