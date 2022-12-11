// Generated code, do not modify. Run `build_runner build` to re-generate!
// @dart=2.12
// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:webthree/webthree.dart' as _i1;
import 'dart:typed_data' as _i2;

final _contractAbi = _i1.ContractAbi.fromJson(
  '[{"anonymous":false,"inputs":[{"indexed":false,"internalType":"uint32","name":"origin","type":"uint32"},{"indexed":false,"internalType":"bytes32","name":"sender","type":"bytes32"},{"indexed":false,"internalType":"bytes","name":"message","type":"bytes"}],"name":"ReceivedMessage","type":"event"},{"anonymous":false,"inputs":[{"indexed":false,"internalType":"uint32","name":"destinationDomain","type":"uint32"},{"indexed":false,"internalType":"address","name":"recipient","type":"address"},{"indexed":false,"internalType":"bytes","name":"payload","type":"bytes"}],"name":"SentMessage","type":"event"},{"anonymous":false,"inputs":[{"indexed":false,"internalType":"string","name":"_nanoId","type":"string"},{"indexed":false,"internalType":"string","name":"_taskType","type":"string"},{"indexed":false,"internalType":"string","name":"_title","type":"string"},{"indexed":false,"internalType":"string","name":"_description","type":"string"},{"indexed":false,"internalType":"string","name":"_symbol","type":"string"},{"indexed":false,"internalType":"uint256","name":"_amount","type":"uint256"}],"name":"TaskContractCreating","type":"event"},{"inputs":[{"internalType":"string","name":"_nanoId","type":"string"},{"internalType":"string","name":"_taskType","type":"string"},{"internalType":"string","name":"_title","type":"string"},{"internalType":"string","name":"_description","type":"string"},{"internalType":"string","name":"_symbol","type":"string"},{"internalType":"uint256","name":"_amount","type":"uint256"}],"name":"createTaskContract","outputs":[],"stateMutability":"payable","type":"function"},{"inputs":[{"internalType":"uint32","name":"_origin","type":"uint32"},{"internalType":"bytes32","name":"_sender","type":"bytes32"},{"internalType":"bytes","name":"_payload","type":"bytes"}],"name":"handle","outputs":[],"stateMutability":"nonpayable","type":"function"}]',
  'Hyperlane',
);

class Hyperlane extends _i1.GeneratedContract {
  Hyperlane({
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
    final function = self.abi.functions[0];
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
  Future<String> handle(
    BigInt _origin,
    _i2.Uint8List _sender,
    _i2.Uint8List _payload, {
    required _i1.Credentials credentials,
    _i1.Transaction? transaction,
  }) async {
    final function = self.abi.functions[1];
    assert(checkSignature(function, '56d5d475'));
    final params = [
      _origin,
      _sender,
      _payload,
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
        recipient = (response[1] as _i1.EthereumAddress),
        payload = (response[2] as _i2.Uint8List);

  final BigInt destinationDomain;

  final _i1.EthereumAddress recipient;

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
