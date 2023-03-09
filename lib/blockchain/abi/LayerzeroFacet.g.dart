// Generated code, do not modify. Run `build_runner build` to re-generate!
// @dart=2.12
// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:webthree/webthree.dart' as _i1;
import 'dart:typed_data' as _i2;

final _contractAbi = _i1.ContractAbi.fromJson(
  '[{"anonymous":false,"inputs":[{"indexed":false,"internalType":"string","name":"logname","type":"string"},{"indexed":false,"internalType":"uint16","name":"sourceChain","type":"uint16"},{"indexed":false,"internalType":"bytes","name":"sourceAddress","type":"bytes"},{"indexed":false,"internalType":"uint256","name":"_nonce","type":"uint256"},{"indexed":false,"internalType":"bytes","name":"payload","type":"bytes"}],"name":"Logs","type":"event"},{"anonymous":false,"inputs":[{"indexed":false,"internalType":"uint16","name":"_srcChainId","type":"uint16"},{"indexed":false,"internalType":"address","name":"_from","type":"address"},{"indexed":false,"internalType":"uint16","name":"_count","type":"uint16"},{"indexed":false,"internalType":"bytes","name":"_payload","type":"bytes"}],"name":"ReceiveMsg","type":"event"},{"anonymous":false,"inputs":[{"indexed":false,"internalType":"address","name":"_sender","type":"address"},{"indexed":false,"internalType":"string","name":"_nanoId","type":"string"},{"indexed":false,"internalType":"string","name":"_taskType","type":"string"},{"indexed":false,"internalType":"string","name":"_title","type":"string"},{"indexed":false,"internalType":"string","name":"_description","type":"string"},{"indexed":false,"internalType":"string[]","name":"_tags","type":"string[]"},{"indexed":false,"internalType":"string[]","name":"_symbol","type":"string[]"},{"indexed":false,"internalType":"uint256[]","name":"_amount","type":"uint256[]"}],"name":"TaskContractCreating","type":"event"},{"anonymous":false,"inputs":[{"indexed":false,"internalType":"address","name":"_sender","type":"address"},{"indexed":false,"internalType":"address","name":"_contractAddress","type":"address"},{"indexed":false,"internalType":"string","name":"_message","type":"string"},{"indexed":false,"internalType":"uint256","name":"_replyTo","type":"uint256"}],"name":"TaskParticipating","type":"event"},{"anonymous":false,"inputs":[{"indexed":false,"internalType":"address","name":"_sender","type":"address"},{"indexed":false,"internalType":"address","name":"_contractAddress","type":"address"},{"indexed":false,"internalType":"string","name":"_message","type":"string"},{"indexed":false,"internalType":"uint256","name":"_replyTo","type":"uint256"}],"name":"TaskSendMessaging","type":"event"},{"anonymous":false,"inputs":[{"indexed":false,"internalType":"address","name":"_sender","type":"address"},{"indexed":false,"internalType":"address","name":"_contractAddress","type":"address"},{"indexed":false,"internalType":"address","name":"_participant","type":"address"},{"indexed":false,"internalType":"string","name":"_state","type":"string"},{"indexed":false,"internalType":"string","name":"_message","type":"string"},{"indexed":false,"internalType":"uint256","name":"_replyTo","type":"uint256"},{"indexed":false,"internalType":"uint256","name":"_rating","type":"uint256"}],"name":"TaskStateChanging","type":"event"},{"anonymous":false,"inputs":[{"indexed":false,"internalType":"address","name":"_sender","type":"address"},{"indexed":false,"internalType":"address","name":"_contractAddress","type":"address"},{"indexed":false,"internalType":"string","name":"_favour","type":"string"},{"indexed":false,"internalType":"string","name":"_message","type":"string"},{"indexed":false,"internalType":"uint256","name":"_replyTo","type":"uint256"},{"indexed":false,"internalType":"uint256","name":"_rating","type":"uint256"}],"name":"taskAuditDecisioning","type":"event"},{"inputs":[{"internalType":"address","name":"_sender","type":"address"},{"components":[{"internalType":"string","name":"nanoId","type":"string"},{"internalType":"string","name":"taskType","type":"string"},{"internalType":"string","name":"title","type":"string"},{"internalType":"string","name":"description","type":"string"},{"internalType":"string[]","name":"tags","type":"string[]"},{"internalType":"string[]","name":"symbols","type":"string[]"},{"internalType":"uint256[]","name":"amounts","type":"uint256[]"}],"internalType":"struct TaskData","name":"_taskData","type":"tuple"}],"name":"createTaskContractLayerzero","outputs":[],"stateMutability":"payable","type":"function"},{"inputs":[{"internalType":"uint16","name":"_dstChainId","type":"uint16"},{"internalType":"address","name":"_userApplication","type":"address"},{"internalType":"bytes","name":"_payload","type":"bytes"},{"internalType":"bool","name":"_payInZRO","type":"bool"},{"internalType":"bytes","name":"_adapterParams","type":"bytes"}],"name":"estimateFees","outputs":[{"internalType":"uint256","name":"nativeFee","type":"uint256"},{"internalType":"uint256","name":"zroFee","type":"uint256"}],"stateMutability":"view","type":"function"},{"inputs":[{"internalType":"uint16","name":"_srcChainId","type":"uint16"},{"internalType":"bytes","name":"_from","type":"bytes"},{"internalType":"uint64","name":"_nonce","type":"uint64"},{"internalType":"bytes","name":"_payload","type":"bytes"}],"name":"lzReceive","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[{"internalType":"address","name":"_sender","type":"address"},{"internalType":"address","name":"_contractAddress","type":"address"},{"internalType":"string","name":"_message","type":"string"},{"internalType":"uint256","name":"_replyTo","type":"uint256"}],"name":"sendMessageLayerzero","outputs":[],"stateMutability":"payable","type":"function"},{"inputs":[{"internalType":"address","name":"_sender","type":"address"},{"internalType":"address","name":"_contractAddress","type":"address"},{"internalType":"string","name":"_favour","type":"string"},{"internalType":"string","name":"_message","type":"string"},{"internalType":"uint256","name":"_replyTo","type":"uint256"},{"internalType":"uint256","name":"_rating","type":"uint256"}],"name":"taskAuditDecisionLayerzero","outputs":[],"stateMutability":"payable","type":"function"},{"inputs":[{"internalType":"address","name":"_sender","type":"address"},{"internalType":"address","name":"_contractAddress","type":"address"},{"internalType":"string","name":"_message","type":"string"},{"internalType":"uint256","name":"_replyTo","type":"uint256"}],"name":"taskAuditParticipateLayerzero","outputs":[],"stateMutability":"payable","type":"function"},{"inputs":[{"internalType":"address","name":"_sender","type":"address"},{"internalType":"address","name":"_contractAddress","type":"address"},{"internalType":"string","name":"_message","type":"string"},{"internalType":"uint256","name":"_replyTo","type":"uint256"}],"name":"taskParticipateLayerzero","outputs":[],"stateMutability":"payable","type":"function"},{"inputs":[{"internalType":"address","name":"_sender","type":"address"},{"internalType":"address","name":"_contractAddress","type":"address"},{"internalType":"address payable","name":"_participant","type":"address"},{"internalType":"string","name":"_state","type":"string"},{"internalType":"string","name":"_message","type":"string"},{"internalType":"uint256","name":"_replyTo","type":"uint256"},{"internalType":"uint256","name":"_rating","type":"uint256"}],"name":"taskStateChangeLayerzero","outputs":[],"stateMutability":"payable","type":"function"}]',
  'LayerzeroFacet',
);

class LayerzeroFacet extends _i1.GeneratedContract {
  LayerzeroFacet({
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
  Future<String> createTaskContractLayerzero(
    _i1.EthereumAddress _sender,
    dynamic _taskData, {
    required _i1.Credentials credentials,
    _i1.Transaction? transaction,
  }) async {
    final function = self.abi.functions[0];
    assert(checkSignature(function, 'd3ce30bf'));
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
    final function = self.abi.functions[1];
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
    final function = self.abi.functions[2];
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

  /// The optional [transaction] parameter can be used to override parameters
  /// like the gas price, nonce and max gas. The `data` and `to` fields will be
  /// set by the contract.
  Future<String> sendMessageLayerzero(
    _i1.EthereumAddress _sender,
    _i1.EthereumAddress _contractAddress,
    String _message,
    BigInt _replyTo, {
    required _i1.Credentials credentials,
    _i1.Transaction? transaction,
  }) async {
    final function = self.abi.functions[3];
    assert(checkSignature(function, 'd0638372'));
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
  Future<String> taskAuditDecisionLayerzero(
    _i1.EthereumAddress _sender,
    _i1.EthereumAddress _contractAddress,
    String _favour,
    String _message,
    BigInt _replyTo,
    BigInt _rating, {
    required _i1.Credentials credentials,
    _i1.Transaction? transaction,
  }) async {
    final function = self.abi.functions[4];
    assert(checkSignature(function, 'df170459'));
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
  Future<String> taskAuditParticipateLayerzero(
    _i1.EthereumAddress _sender,
    _i1.EthereumAddress _contractAddress,
    String _message,
    BigInt _replyTo, {
    required _i1.Credentials credentials,
    _i1.Transaction? transaction,
  }) async {
    final function = self.abi.functions[5];
    assert(checkSignature(function, 'cef171b7'));
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
  Future<String> taskParticipateLayerzero(
    _i1.EthereumAddress _sender,
    _i1.EthereumAddress _contractAddress,
    String _message,
    BigInt _replyTo, {
    required _i1.Credentials credentials,
    _i1.Transaction? transaction,
  }) async {
    final function = self.abi.functions[6];
    assert(checkSignature(function, 'c571b2e4'));
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
  Future<String> taskStateChangeLayerzero(
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
    final function = self.abi.functions[7];
    assert(checkSignature(function, '49d289c8'));
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
      : sender = (response[0] as _i1.EthereumAddress),
        nanoId = (response[1] as String),
        taskType = (response[2] as String),
        title = (response[3] as String),
        description = (response[4] as String),
        tags = (response[5] as List<dynamic>).cast<String>(),
        symbol = (response[6] as List<dynamic>).cast<String>(),
        amount = (response[7] as List<dynamic>).cast<BigInt>();

  final _i1.EthereumAddress sender;

  final String nanoId;

  final String taskType;

  final String title;

  final String description;

  final List<String> tags;

  final List<String> symbol;

  final List<BigInt> amount;
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
